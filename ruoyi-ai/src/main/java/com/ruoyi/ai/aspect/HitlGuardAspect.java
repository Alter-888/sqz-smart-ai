package com.ruoyi.ai.aspect;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.ruoyi.ai.config.SmartCsProperties;
import com.ruoyi.ai.context.ChatContext;
import com.ruoyi.ai.context.HitlContext;
import com.ruoyi.ai.entity.PendingAction;
import com.ruoyi.ai.service.PendingActionService;
import lombok.RequiredArgsConstructor;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.reflect.MethodSignature;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * P7 HITL 高危操作守卫（02 §十三.3）：
 * 工具名在 hitl-tools 白名单内、且本次不是“确认后的反射重放”时，
 * 拦截并生成待确认单，返回 Map 让模型停下来对用户说话，而不是真的执行。
 *
 * 为什么返回 Map 而不是抛异常：抛异常会被 Spring AI 包装成工具错误喂回模型，
 * 模型大概率换个参数重试；返回明确指令它才会停下来。
 * @Order(20)：ToolBudgetAspect 用 @Order(10) 先算预算，再判 HITL。
 */
@Aspect
@Component
@Order(20)
@RequiredArgsConstructor
public class HitlGuardAspect {

    private static final Logger log = LoggerFactory.getLogger(HitlGuardAspect.class);

    private final SmartCsProperties props;
    private final PendingActionService pendingActionService;
    private final ObjectMapper objectMapper;

    @Around("@annotation(org.springframework.ai.tool.annotation.Tool)")
    public Object guard(ProceedingJoinPoint pjp) throws Throwable {
        String tool = pjp.getSignature().getName();
        boolean needConfirm = props.getAgent().isHitlEnabled()
                && props.getAgent().getHitlTools().contains(tool);

        // 确认后的重放走同一个方法，靠 ThreadLocal 令牌放行，避免死循环
        if (!needConfirm || HitlContext.isConfirmedReplay()) {
            return pjp.proceed();
        }

        SseEmitter emitter = ChatContext.getEmitter();
        if (emitter == null) {
            // 非流式 /ai/chat/send：没有确认卡片可推，直接拒绝（04 §1.4）
            log.warn("非流式路径触发高危操作，已拒绝 - tool: {}", tool);
            return Map.of(
                    "status", "REJECTED",
                    "message", "该操作需要人工确认，当前为简化对话模式不会执行。请到智能客服聊天页面重新发起，并在确认卡片上完成操作。");
        }

        MethodSignature sig = (MethodSignature) pjp.getSignature();
        PendingAction action = pendingActionService.create(
                tool,
                sig.getDeclaringTypeName(),
                pjp.getArgs(),
                sig.getMethod().getParameterTypes());

        // 拦截也算一次工具尝试：模型若不听“不要重复调用”，预算守卫仍能兜底停住
        ChatContext.addToolCallName(tool);

        log.warn("高危操作已挂起待确认 - tool: {}, actionId: {}, sessionId: {}",
                tool, action.getActionId(), ChatContext.getSessionId());

        // 推 SSE 事件，前端据此渲染确认卡片（同时进入卡片管道，随 cards_data 持久化，刷新可恢复）
        String summary = action.getSummary() == null ? "" : action.getSummary();
        String expireAt = action.getExpireTime() == null ? "" : action.getExpireTime().toString();
        Map<String, Object> pendingItem = Map.of(
                "actionId", action.getActionId(),
                "toolName", tool,
                "summary", summary,
                "expireAt", expireAt,
                "status", "PENDING",
                "result", "");
        try {
            String json = objectMapper.writeValueAsString(pendingItem);
            emitter.send(SseEmitter.event().name("pending_action").data(json));

            // 以消息气泡卡片形式推送，并写入上下文供响应完成后持久化
            List<Map<String, Object>> items = new ArrayList<>();
            items.add(pendingItem);
            emitter.send(SseEmitter.event().name("card_data")
                    .data(objectMapper.writeValueAsString(Map.of("cardType", "pending_action", "items", items))));
            ChatContext.addCardData(Map.of("cardType", "pending_action", "items", items));
        } catch (Exception e) {
            log.warn("pending_action 事件推送失败: {}", e.getMessage());
        }

        return Map.of(
                "status", "PENDING_CONFIRM",
                "actionId", action.getActionId(),
                "message", "该操作需要用户本人确认。请把操作内容复述给用户，"
                        + "并告诉他在下方确认卡片上点『确认执行』或『取消』。不要重复调用本工具。");
    }
}
