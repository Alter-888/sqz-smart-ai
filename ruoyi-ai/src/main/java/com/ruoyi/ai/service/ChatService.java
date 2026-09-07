package com.ruoyi.ai.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.ruoyi.ai.agent.ChatOrchestrator;
import com.ruoyi.ai.context.ChatContext;
import com.ruoyi.ai.entity.ChatMessage;
import com.ruoyi.ai.event.ToolCallEvent;
import com.ruoyi.ai.mapper.ChatMessageMapper;
import com.ruoyi.common.core.redis.RedisCache;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.event.EventListener;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.TimeUnit;

/**
 * 对话入口（P4 改造后）：只负责 SSE / ticket / 事件推送 / 审计落库。
 * 编排逻辑（路由→Worker→重试/超时计数→intent 事件）全部下沉到 ChatOrchestrator。
 */
@Service
@RequiredArgsConstructor
public class ChatService {

    private static final Logger log = LoggerFactory.getLogger(ChatService.class);

    private final ChatOrchestrator orchestrator;
    private final ChatHistoryService chatHistoryService;
    private final ChatMessageMapper chatMessageMapper;
    private final AuditService auditService;
    private final ObjectMapper objectMapper;
    private final RedisCache redisCache;

    private static final String SSE_TICKET_PREFIX = "sse_ticket:";

    /**
     * 对话接口 - 使用 SseEmitter 推送结果
     * 采用非流式 .call() 模式确保工具调用（Function Calling）正常执行，
     * 然后通过 SSE 将完整结果推送给前端。
     * 工具调用期间的 tool_call / card_data 事件仍通过 SSE 实时推送。
     */
    public SseEmitter streamChat(String message, Long sessionId, Long userId) {
        log.info("对话请求 - sessionId: {}, userId: {}, message: {}", sessionId, userId, message);

        // 更新会话标题（首条消息时）
        chatHistoryService.updateSessionTitle(sessionId, message);

        SseEmitter emitter = new SseEmitter(300_000L);

        // 在主线程捕获 SecurityContext，供异步线程使用（避免 SseEmitter async dispatch 时 Access Denied）
        SecurityContext securityContext = SecurityContextHolder.getContext();

        // 异步执行，避免阻塞 HTTP 线程
        CompletableFuture.runAsync(() -> {
            // 恢复安全上下文到异步线程
            SecurityContextHolder.setContext(securityContext);
            // 在异步线程中设置聊天上下文（ThreadLocal 绑定当前线程）
            ChatContext.setSessionId(sessionId);
            ChatContext.setEmitter(emitter);
            long turnStart = System.currentTimeMillis();
            String response = null;
            try {
                ChatOrchestrator.TurnResult turn = orchestrator.handle(message, sessionId, userId);
                response = turn == null || turn.text() == null ? "抱歉，系统暂时繁忙，请稍后再试。" : turn.text();

                // 将完整回复通过 SSE 发送给前端（不加事件名，前端按默认 message 事件接收）
                emitter.send(SseEmitter.event().data(response));

                // 推送 RAG 来源事件
                List<Map<String, String>> ragSources = ChatContext.getRagSources();
                if (!ragSources.isEmpty()) {
                    String ragJson = objectMapper.writeValueAsString(ragSources);
                    emitter.send(SseEmitter.event().name("rag_source").data(ragJson));
                }

                // 持久化卡片数据到最近的 assistant 消息
                List<Map<String, Object>> cardData = ChatContext.getCardData();
                if (!cardData.isEmpty()) {
                    String cardsJson = objectMapper.writeValueAsString(cardData);
                    chatHistoryService.updateLastMessageCardsData(sessionId, cardsJson);
                }

                // 持久化工具调用到最近的 assistant 消息（供刷新/切会话后恢复工具调用提示）
                List<String> toolCallNames = turn == null ? List.of() : turn.toolCalls();
                if (!toolCallNames.isEmpty()) {
                    String toolCallsJson = objectMapper.writeValueAsString(toolCallNames);
                    chatHistoryService.updateLastMessageToolCalls(sessionId, toolCallsJson);
                }

                // 查询刚保存的 assistant 消息ID，供前端赞/踩使用
                LambdaQueryWrapper<ChatMessage> msgIdWrapper = new LambdaQueryWrapper<>();
                msgIdWrapper.eq(ChatMessage::getSessionId, sessionId)
                        .eq(ChatMessage::getRole, "assistant")
                        .orderByDesc(ChatMessage::getCreateTime)
                        .last("LIMIT 1");
                ChatMessage savedMsg = chatMessageMapper.selectOne(msgIdWrapper);
                if (savedMsg != null) {
                    emitter.send(SseEmitter.event().name("message_id")
                            .data(objectMapper.writeValueAsString(
                                    Map.of("messageId", savedMsg.getMessageId()))));
                }

                emitter.send(SseEmitter.event().data("[DONE]"));
                log.info("对话完成 - sessionId: {}", sessionId);

                // 写入审计记录
                long durationMs = System.currentTimeMillis() - turnStart;
                auditService.recordTurn(sessionId, userId, message, response, turn,
                        ragSources, turn == null ? List.of() : turn.toolCalls(), durationMs);

                emitter.complete();
            } catch (Exception e) {
                log.error("对话异常 - sessionId: {}", sessionId, e);
                try {
                    emitter.send(SseEmitter.event().data("抱歉，系统暂时繁忙，请稍后再试。"));
                    emitter.send(SseEmitter.event().data("[DONE]"));
                } catch (Exception ignored) {}

                // 异常情况也写入审计
                long durationMs = System.currentTimeMillis() - turnStart;
                auditService.recordTurn(sessionId, userId, message,
                        response != null ? response : "系统异常", null,
                        ChatContext.getRagSources(), ChatContext.getToolCallNames(), durationMs);

                emitter.complete();
            } finally {
                ChatContext.clear();
                SecurityContextHolder.clearContext();
            }
        });

        emitter.onTimeout(() -> {
            log.warn("SSE 超时 - sessionId: {}", sessionId);
            ChatContext.clear();
            emitter.complete();
        });

        return emitter;
    }

    /**
     * 监听工具调用事件，通过 SSE 推送到前端
     */
    @EventListener
    public void handleToolCallEvent(ToolCallEvent event) {
        SseEmitter emitter = ChatContext.getEmitter();
        if (emitter != null) {
            try {
                // 安全序列化：用 ObjectMapper 替代字符串拼接，防止 JSON 注入
                String json = objectMapper.writeValueAsString(
                        java.util.Map.of("toolName", event.getToolName(), "description", event.getDescription()));
                emitter.send(SseEmitter.event().name("tool_call").data(json));
                log.debug("工具调用通知已推送: {}", event.getToolName());

                // 如果有卡片数据，额外发送 card_data 事件
                if (event.getCardType() != null && event.getCardData() != null && !event.getCardData().isEmpty()) {
                    String cardJson = objectMapper.writeValueAsString(
                            java.util.Map.of("cardType", event.getCardType(), "items", event.getCardData()));
                    emitter.send(SseEmitter.event().name("card_data").data(cardJson));
                    log.debug("卡片数据已推送: type={}, count={}", event.getCardType(), event.getCardData().size());

                    // 累积到上下文，供响应完成后持久化
                    ChatContext.addCardData(Map.of("cardType", event.getCardType(), "items", event.getCardData()));
                }

                // 如果有数据变更类型，发送 data_changed 事件通知前端刷新
                if (event.getRefreshTypes() != null && !event.getRefreshTypes().isEmpty()) {
                    String refreshJson = objectMapper.writeValueAsString(
                            java.util.Map.of("types", event.getRefreshTypes()));
                    emitter.send(SseEmitter.event().name("data_changed").data(refreshJson));
                    log.debug("数据变更通知已推送: types={}", event.getRefreshTypes());
                }
            } catch (Exception e) {
                log.warn("工具调用通知推送失败: {}", e.getMessage());
            }
        }
    }

    /**
     * 非流式对话（兜底）- 含重试机制，走 ChatOrchestrator
     */
    public String chat(String message, Long sessionId, Long userId) {
        log.info("非流式对话请求 - sessionId: {}, userId: {}, message: {}", sessionId, userId, message);

        chatHistoryService.updateSessionTitle(sessionId, message);

        ChatContext.setSessionId(sessionId);
        try {
            ChatOrchestrator.TurnResult turn = orchestrator.handle(message, sessionId, userId);
            String response = (turn == null || turn.text() == null || turn.text().isBlank())
                    ? "抱歉，系统暂时繁忙，请稍后再试。" : turn.text();
            log.info("非流式对话完成 - sessionId: {}", sessionId);
            return response;
        } catch (Exception e) {
            log.error("非流式对话异常 - sessionId: {}", sessionId, e);
            return "抱歉，系统暂时繁忙，请稍后再试。";
        } finally {
            ChatContext.clear();
        }
    }

    /**
     * 创建一次性 SSE 短期 ticket（60秒有效，一次性使用）
     * 替代在 URL 中暴露长期 JWT token
     * @param loginUuid 用户登录会话的 UUID（用于在 Redis 中查找 LoginUser）
     */
    public String createOneTimeTicket(String loginUuid) {
        String ticket = UUID.randomUUID().toString().replace("-", "");
        String key = SSE_TICKET_PREFIX + ticket;
        redisCache.setCacheObject(key, loginUuid, 60, TimeUnit.SECONDS);
        log.info("SSE ticket 已创建 - loginUuid: {}..., ticket: {}...", loginUuid.substring(0, 8), ticket.substring(0, 8));
        return ticket;
    }

    /**
     * 验证并消费一次性 ticket，返回 loginUuid（验证后立即删除，保证一次性使用）
     * @return loginUuid，ticket 无效或已过期返回 null
     */
    public String validateAndConsumeTicket(String ticket) {
        if (ticket == null || ticket.isEmpty()) {
            return null;
        }
        String key = SSE_TICKET_PREFIX + ticket;
        String loginUuid = redisCache.getCacheObject(key);
        if (loginUuid != null) {
            // 立即删除，保证一次性使用
            redisCache.deleteObject(key);
            log.info("SSE ticket 已验证并消费 - ticket: {}...", ticket.substring(0, 8));
        }
        return loginUuid;
    }
}
