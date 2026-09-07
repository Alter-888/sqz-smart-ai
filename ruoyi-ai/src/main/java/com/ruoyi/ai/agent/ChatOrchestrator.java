package com.ruoyi.ai.agent;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.ruoyi.ai.config.SmartCsProperties;
import com.ruoyi.ai.context.ChatContext;
import com.ruoyi.ai.mcp.CommonMcpTools;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.retry.support.RetryTemplate;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

import java.util.List;
import java.util.Map;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.concurrent.atomic.AtomicInteger;

/**
 * 编排中枢：路由 → 执行 → 重试/超时计数 → 审计埋点。
 * 改造后 ChatService 只负责 SSE / ticket / 事件推送 / 审计落库，编排逻辑全部下沉到这里。
 */
@Service
@RequiredArgsConstructor
public class ChatOrchestrator {

    private static final Logger log = LoggerFactory.getLogger(ChatOrchestrator.class);
    private static final String BUSY_TEXT = "抱歉，系统暂时繁忙，请稍后再试。";

    private final IntentRouter router;
    private final AgentRegistry registry;
    private final SupervisorAgent supervisor;
    private final CommonMcpTools commonMcpTools;
    private final RetryTemplate aiRetryTemplate;
    private final SmartCsProperties props;
    private final ObjectMapper objectMapper;

    /** 一轮对话的全部可观测结果，字段与 ai_chat_turn_audit 一一对应 */
    public record TurnResult(String text, String intent, String routeSource, String agentId, boolean ragEnabled,
                             List<String> toolCalls, int retryCount, int failureCount,
                             boolean timeout, long durationMs) {}

    public TurnResult handle(String message, Long sessionId, Long userId) {
        long start = System.currentTimeMillis();
        IntentRouter.RouteDecision d = router.route(message);
        pushIntent(d);   // 路由一出结果立刻推给前端，先把"感知延迟"压下去

        // ① 短路：这两类不进 Worker，省一次大模型调用
        if (d.intent() == IntentRouter.Intent.CHITCHAT) {
            return done(greeting(), d, false, List.of(), 0, 0, false, start);
        }
        if (d.intent() == IntentRouter.Intent.HUMAN_HANDOFF) {
            // 直接复用工具方法，这样 ai_tool_call_log 里照样有 escalateToHuman，
            // humanEscalationRate 指标口径不变
            commonMcpTools.escalateToHuman("用户主动要求人工客服：" + message);
            return done("已为您转接人工客服，工单已创建，客服会尽快联系您 😊",
                    d, false, List.of("escalateToHuman"), 0, 0, false, start);
        }

        AgentContext ctx = AgentContext.builder()
                .userId(userId).sessionId(sessionId)
                .intent(d.intent()).ragCategories(d.ragCategories())
                .build();

        AtomicInteger retries = new AtomicInteger();
        AtomicInteger failures = new AtomicInteger();
        AtomicBoolean timeout = new AtomicBoolean();

        AgentResult result = aiRetryTemplate.execute(rc -> {
            if (rc.getRetryCount() > 0) {
                retries.set(rc.getRetryCount());
                log.warn("Agent 调用重试 - 第 {} 次, agentId: {}, sessionId: {}",
                        rc.getRetryCount(), d.agentId(), sessionId);
            }
            // ② 跨域交 Supervisor（P7 前为不实现的空实现，P4 阶段 CROSS_DOMAIN 一般不会出现）；③ 单域直连
            if (d.intent() == IntentRouter.Intent.CROSS_DOMAIN && props.getAgent().isSupervisorEnabled()) {
                return supervisor.orchestrate(message, ctx);
            }
            return registry.get(d.agentId()).execute(message, ctx);
        }, rc -> {
            // 重试耗尽：把失败原因量化，别只留一句"系统繁忙"
            failures.set(rc.getRetryCount() + 1);
            timeout.set(isTimeout(rc.getLastThrowable()));
            log.error("Agent 调用重试耗尽 - agentId: {}, sessionId: {}, 尝试: {}, 超时: {}",
                    d.agentId(), sessionId, rc.getRetryCount() + 1, timeout.get(),
                    rc.getLastThrowable());
            return new AgentResult(BUSY_TEXT, List.of(), false);
        });

        String text = (result == null || result.text() == null || result.text().isBlank())
                ? BUSY_TEXT : result.text();

        TurnResult turn = done(text, d, !d.ragCategories().isEmpty(),
                result == null ? List.of() : result.toolCalls(),
                retries.get(), failures.get(), timeout.get(), start);

        // ④ 异步抽检已下沉到 AuditService：审计行拿到 auditId 后再触发（P7）
        return turn;
    }

    private TurnResult done(String text, IntentRouter.RouteDecision d, boolean ragEnabled,
                            List<String> toolCalls, int retryCount, int failureCount,
                            boolean timeout, long start) {
        return new TurnResult(text, d.intent().name(),
                d.source(), d.agentId() == null ? "" : d.agentId(), ragEnabled,
                toolCalls, retryCount, failureCount, timeout,
                System.currentTimeMillis() - start);
    }

    private String greeting() {
        return "您好呀！我是小智，您的数码商城智能客服助手 😊\n\n我可以帮您：\n" +
                "- 🛒 搜商品、做推荐、比参数、加购物车\n" +
                "- 📦 查订单、查物流、取消订单\n" +
                "- 🎧 处理售后、工单、评价\n" +
                "- 📍 管理收货地址\n\n请问有什么可以帮您的吗？";
    }

    /** 超时判定：沿因果链找 JDK/Spring 的超时异常，别用 message.contains 猜 */
    private boolean isTimeout(Throwable t) {
        for (Throwable c = t; c != null; c = c.getCause() == c ? null : c.getCause()) {
            if (c instanceof java.net.http.HttpTimeoutException
                    || c instanceof java.net.SocketTimeoutException
                    || c instanceof java.util.concurrent.TimeoutException
                    || c instanceof org.springframework.web.client.ResourceAccessException) {
                return true;
            }
        }
        return false;
    }

    private void pushIntent(IntentRouter.RouteDecision d) {
        SseEmitter emitter = ChatContext.getEmitter();
        if (emitter == null) return;   // 非流式路径没有 emitter
        try {
            emitter.send(SseEmitter.event().name("intent").data(objectMapper.writeValueAsString(
                    Map.of("intent", d.intent().name(),
                           "agentId", d.agentId() == null ? "" : d.agentId(),
                           "source", d.source()))));
        } catch (Exception e) {
            log.warn("intent 事件推送失败: {}", e.getMessage());
        }
    }
}
