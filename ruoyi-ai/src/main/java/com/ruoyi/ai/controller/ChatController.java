package com.ruoyi.ai.controller;

import com.ruoyi.ai.entity.ChatMessage;
import com.ruoyi.ai.entity.ChatSession;
import com.ruoyi.ai.service.ChatHistoryService;
import com.ruoyi.ai.service.PendingActionService;
import com.ruoyi.ai.service.ChatService;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.domain.model.LoginUser;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.StringUtils;
import lombok.RequiredArgsConstructor;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/ai/chat")
@RequiredArgsConstructor
public class ChatController {

    private final ChatService chatService;
    private final ChatHistoryService chatHistoryService;
    private final PendingActionService pendingActionService;

    /**
     * 获取 SSE 流式对话的一次性 ticket
     * 替代在 URL 中暴露长期 JWT token，ticket 60秒有效，一次性使用
     */
    @PostMapping("/stream-ticket")
    public AjaxResult createStreamTicket() {
        LoginUser loginUser = SecurityUtils.getLoginUser();
        String ticket = chatService.createOneTimeTicket(loginUser.getToken());
        return AjaxResult.success(Map.of("ticket", ticket));
    }

    /**
     * SSE 流式对话
     * 使用一次性 ticket 认证（替代 URL 中的长期 JWT token）
     * ticket 由 JwtAuthenticationTokenFilter → TokenService 自动处理认证
     */
    @GetMapping(path = "/stream", produces = MediaType.TEXT_EVENT_STREAM_VALUE)
    public SseEmitter streamChat(
            @RequestParam String message,
            @RequestParam Long sessionId) {
        if (StringUtils.isEmpty(message) || message.trim().isEmpty()) {
            throw new ServiceException("消息内容不能为空");
        }
        if (message.length() > 5000) {
            throw new ServiceException("消息内容超出长度限制");
        }
        if (sessionId == null || sessionId <= 0) {
            throw new ServiceException("无效的会话ID");
        }
        Long userId = SecurityUtils.getUserId();
        chatHistoryService.validateSessionOwnership(sessionId, userId);
        return chatService.streamChat(message.trim(), sessionId, userId);
    }

    /**
     * 非流式对话（兜底）
     */
    @PostMapping("/send")
    public AjaxResult sendMessage(@RequestBody Map<String, Object> request) {
        Object messageObj = request.get("message");
        Object sessionIdObj = request.get("sessionId");

        if (messageObj == null || StringUtils.isEmpty(messageObj.toString().trim())) {
            return AjaxResult.error("消息内容不能为空");
        }
        if (sessionIdObj == null) {
            return AjaxResult.error("会话ID不能为空");
        }

        String message = messageObj.toString().trim();
        if (message.length() > 5000) {
            return AjaxResult.error("消息内容超出长度限制");
        }

        Long sessionId;
        try {
            sessionId = Long.valueOf(sessionIdObj.toString());
        } catch (NumberFormatException e) {
            return AjaxResult.error("无效的会话ID");
        }
        if (sessionId <= 0) {
            return AjaxResult.error("无效的会话ID");
        }

        Long userId = SecurityUtils.getUserId();
        chatHistoryService.validateSessionOwnership(sessionId, userId);
        String response = chatService.chat(message, sessionId, userId);
        return AjaxResult.success(response);
    }

    /**
     * 新建会话
     */
    @PostMapping("/session")
    public AjaxResult createSession(@RequestBody(required = false) Map<String, String> body) {
        Long userId = SecurityUtils.getUserId();
        String title = body != null ? body.get("title") : null;
        ChatSession session = chatHistoryService.createSession(userId, title);
        return AjaxResult.success(session);
    }

    /**
     * 会话列表
     */
    @GetMapping("/session/list")
    public AjaxResult sessionList() {
        Long userId = SecurityUtils.getUserId();
        if (SecurityUtils.isAdmin(userId)) {
            return AjaxResult.success(chatHistoryService.listAllSessions(1, 100));
        }
        return AjaxResult.success(chatHistoryService.listUserSessions(userId));
    }

    /**
     * 获取会话消息记录
     */
    @GetMapping("/session/{id}/messages")
    public AjaxResult sessionMessages(@PathVariable("id") Long sessionId) {
        Long userId = SecurityUtils.getUserId();
        chatHistoryService.validateSessionOwnership(sessionId, userId);
        return AjaxResult.success(chatHistoryService.getSessionMessages(sessionId));
    }

    /**
     * 删除会话
     */
    @DeleteMapping("/session/{id}")
    public AjaxResult deleteSession(@PathVariable("id") Long sessionId) {
        Long userId = SecurityUtils.getUserId();
        chatHistoryService.validateSessionOwnership(sessionId, userId);
        chatHistoryService.deleteSession(sessionId);
        return AjaxResult.success("删除成功");
    }

    /**
     * 切换会话置顶状态
     */
    @PutMapping("/session/{id}/pin")
    public AjaxResult togglePin(@PathVariable("id") Long sessionId) {
        Long userId = SecurityUtils.getUserId();
        chatHistoryService.validateSessionOwnership(sessionId, userId);
        ChatSession session = chatHistoryService.togglePin(sessionId);
        return AjaxResult.success(session);
    }

    /**
     * 重命名会话标题
     */
    @PutMapping("/session/{id}/title")
    public AjaxResult renameSession(@PathVariable("id") Long sessionId,
                                    @RequestBody Map<String, String> body) {
        Long userId = SecurityUtils.getUserId();
        chatHistoryService.validateSessionOwnership(sessionId, userId);
        String title = body.get("title");
        if (title == null || title.trim().isEmpty()) {
            return AjaxResult.error("标题不能为空");
        }
        ChatSession session = chatHistoryService.renameSession(sessionId, title.trim());
        return AjaxResult.success(session);
    }

    /**
     * 消息满意度反馈（点赞/点踩/取消）
     */
    @PutMapping("/message/{id}/feedback")
    public AjaxResult feedback(@PathVariable("id") Long messageId,
                               @RequestBody Map<String, Object> body) {
        Object rawFeedback = body.get("feedback");
        Integer feedback = null;
        if (rawFeedback != null) {
            feedback = Integer.valueOf(rawFeedback.toString());
            if (feedback != 0 && feedback != 1) {
                return AjaxResult.error("反馈值无效，应为 0、1 或 null");
            }
        }
        Long userId = SecurityUtils.getUserId();
        chatHistoryService.updateFeedback(messageId, feedback, userId);
        return AjaxResult.success();
    }

    /**
     * P7 HITL：确认高危操作（02 §13.4 / 04 §1.3）
     */
    @PostMapping("/pending-action/{id}/confirm")
    public AjaxResult confirmPendingAction(@PathVariable("id") Long actionId) {
        Map<String, Object> result = pendingActionService.confirm(actionId);
        return AjaxResult.success("操作已执行", result);
    }

    /**
     * P7 HITL：取消高危操作，不执行
     */
    @PostMapping("/pending-action/{id}/cancel")
    public AjaxResult cancelPendingAction(@PathVariable("id") Long actionId) {
        Map<String, Object> result = pendingActionService.cancel(actionId);
        return AjaxResult.success("操作已取消", result);
    }


    /**
     * P7 HITL：确认/取消/超时后，把消息里确认卡的最终状态持久化到 cards_data（刷新页面仍显示最终态）
     */
    @PutMapping("/pending-action/{id}/state")
    public AjaxResult updatePendingCardState(@PathVariable("id") Long actionId,
                                             @RequestBody Map<String, Object> body) {
        Long sessionId = body.get("sessionId") == null ? null : Long.valueOf(body.get("sessionId").toString());
        String status = body.get("status") == null ? "" : body.get("status").toString();
        String result = body.get("result") == null ? "" : body.get("result").toString();
        if (sessionId == null) {
            return AjaxResult.error("会话ID不能为空");
        }
        Long userId = SecurityUtils.getUserId();
        chatHistoryService.validateSessionOwnership(sessionId, userId);
        chatHistoryService.updatePendingCardState(sessionId, actionId, status, result);
        return AjaxResult.success();
    }

    /**
     * P7 购物车「去结算」卡：结算成功后把完成态持久化到 cards_data（刷新页面仍显示已完成）
     */
    @PutMapping("/checkout-card/{cardId}/state")
    public AjaxResult updateCheckoutCardState(@PathVariable("cardId") String cardId,
                                              @RequestBody Map<String, Object> body) {
        Long sessionId = body.get("sessionId") == null ? null : Long.valueOf(body.get("sessionId").toString());
        String status = body.get("status") == null ? "" : body.get("status").toString();
        String orderNo = body.get("orderNo") == null ? "" : body.get("orderNo").toString();
        if (sessionId == null) {
            return AjaxResult.error("会话ID不能为空");
        }
        Long userId = SecurityUtils.getUserId();
        chatHistoryService.validateSessionOwnership(sessionId, userId);
        chatHistoryService.updateCheckoutCardState(sessionId, cardId, status, orderNo);
        return AjaxResult.success();
    }

    /**
     * P7 HITL：查自己的待确认操作（页面刷新后恢复卡片）
     */
    @GetMapping("/pending-action/list")
    public AjaxResult listPendingActions(
            @RequestParam(value = "status", required = false) String status) {
        return AjaxResult.success(pendingActionService.listPending(status));
    }
}
