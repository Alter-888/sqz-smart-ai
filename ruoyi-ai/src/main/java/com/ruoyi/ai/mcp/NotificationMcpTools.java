package com.ruoyi.ai.mcp;

import com.ruoyi.ai.context.ChatContext;
import com.ruoyi.ai.entity.ToolCallLog;
import com.ruoyi.ai.event.ToolCallEvent;
import com.ruoyi.ai.mapper.ToolCallLogMapper;
import com.ruoyi.business.entity.Notification;
import com.ruoyi.business.service.NotificationService;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.SecurityUtils;
import com.baomidou.mybatisplus.core.metadata.IPage;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.ai.tool.annotation.Tool;
import org.springframework.ai.tool.annotation.ToolParam;
import org.springframework.context.ApplicationEventPublisher;
import org.springframework.stereotype.Component;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * MCP 通知工具：为 AI 提供用户通知查询、标记已读能力
 * 通过 MCP 协议暴露，同时支持 MethodToolCallbackProvider 直接调用
 */
@Component
@RequiredArgsConstructor
public class NotificationMcpTools {

    private static final Logger log = LoggerFactory.getLogger(NotificationMcpTools.class);

    private final NotificationService notificationService;
    private final ToolCallLogMapper toolCallLogMapper;
    private final ApplicationEventPublisher eventPublisher;

    private void logToolCall(String toolName, String params, boolean success, long durationMs, String errorMsg) {
        try {
            ToolCallLog callLog = new ToolCallLog();
            callLog.setToolName(toolName);
            callLog.setToolParams(params);
            callLog.setSessionId(ChatContext.getSessionId());
            callLog.setSuccessFlag(success ? 1 : 0);
            callLog.setDurationMs(durationMs);
            callLog.setErrorMsg(errorMsg);
            toolCallLogMapper.insert(callLog);
        } catch (Exception e) {
            log.warn("记录工具调用日志失败: {}", e.getMessage());
        }
    }

    private void publishToolCallEvent(String toolName, String description) {
        try {
            Long sessionId = ChatContext.getSessionId();
            eventPublisher.publishEvent(new ToolCallEvent(this, toolName, description, sessionId));
        } catch (Exception e) {
            log.warn("发布工具调用事件失败: {}", e.getMessage());
        }
    }

    private void publishToolCallEvent(String toolName, String description, List<String> refreshTypes) {
        try {
            Long sessionId = ChatContext.getSessionId();
            eventPublisher.publishEvent(new ToolCallEvent(this, toolName, description, sessionId, null, null, refreshTypes));
        } catch (Exception e) {
            log.warn("发布工具调用事件失败: {}", e.getMessage());
        }
    }

    @Tool(description = "查询当前用户的未读通知列表。当用户询问有什么新通知、新消息时使用此工具。")
    public List<Map<String, Object>> queryUnreadNotifications() {
        long startTime = System.currentTimeMillis();
        boolean success = true;
        String errorMsg = null;
        Long userId = SecurityUtils.getUserId();
        log.info("工具调用 - 查询未读通知, userId: {}", userId);
        publishToolCallEvent("queryUnreadNotifications", "正在查询未读通知...");
        try {
            List<Notification> notifications = notificationService.getUnreadNotifications(userId);
            if (notifications.isEmpty()) {
                ChatContext.addToolCallName("queryUnreadNotifications");
                return List.of(Map.of("message", "您暂无未读通知"));
            }

            List<Map<String, Object>> result = notifications.stream().map(n -> {
                Map<String, Object> map = new LinkedHashMap<>();
                map.put("notificationId", n.getNotificationId());
                map.put("title", n.getTitle() != null ? n.getTitle() : "");
                map.put("content", n.getContent() != null ? n.getContent() : "");
                map.put("type", n.getType() != null ? n.getType() : "");
                map.put("createTime", n.getCreateTime() != null ? n.getCreateTime().toString() : "");
                return map;
            }).collect(Collectors.toList());

            publishToolCallEvent("queryUnreadNotifications", "查询到 " + result.size() + " 条未读通知");
            ChatContext.addToolCallName("queryUnreadNotifications");
            return result;
        } catch (Exception e) {
            success = false;
            errorMsg = e.getMessage();
            throw e;
        } finally {
            logToolCall("queryUnreadNotifications", "userId=" + userId, success,
                    System.currentTimeMillis() - startTime, errorMsg);
        }
    }

    @Tool(description = "获取当前用户的未读通知数量。当用户询问有多少未读消息时使用此工具。")
    public Map<String, Object> getUnreadCount() {
        long startTime = System.currentTimeMillis();
        boolean success = true;
        String errorMsg = null;
        Long userId = SecurityUtils.getUserId();
        log.info("工具调用 - 查询未读通知数量, userId: {}", userId);
        publishToolCallEvent("getUnreadCount", "正在查询未读通知数量...");
        try {
            long count = notificationService.getUnreadCount(userId);

            ChatContext.addToolCallName("getUnreadCount");
            return Map.of(
                    "unreadCount", count,
                    "message", count > 0 ? "您有 " + count + " 条未读通知" : "您暂无未读通知"
            );
        } catch (Exception e) {
            success = false;
            errorMsg = e.getMessage();
            throw e;
        } finally {
            logToolCall("getUnreadCount", "userId=" + userId, success,
                    System.currentTimeMillis() - startTime, errorMsg);
        }
    }

    @Tool(description = "将指定通知标记为已读。当用户要求已读某条通知时使用此工具。")
    public Map<String, Object> markNotificationRead(
            @ToolParam(description = "通知ID") Long notificationId) {
        long startTime = System.currentTimeMillis();
        boolean success = true;
        String errorMsg = null;
        Long userId = SecurityUtils.getUserId();
        log.info("工具调用 - 标记通知已读: notificationId={}, userId={}", notificationId, userId);
        publishToolCallEvent("markNotificationRead", "正在标记通知为已读...", List.of("notification"));
        try {
            notificationService.markAsRead(notificationId, userId);
            ChatContext.addToolCallName("markNotificationRead");
            return Map.of(
                    "notificationId", notificationId,
                    "message", "通知已标记为已读"
            );
        } catch (ServiceException e) {
            success = false;
            errorMsg = e.getMessage();
            ChatContext.addToolCallName("markNotificationRead");
            return Map.of("error", e.getMessage());
        } catch (Exception e) {
            success = false;
            errorMsg = e.getMessage();
            throw e;
        } finally {
            logToolCall("markNotificationRead", "notificationId=" + notificationId + ",userId=" + userId, success,
                    System.currentTimeMillis() - startTime, errorMsg);
        }
    }

    @Tool(description = "将当前用户的所有未读通知标记为已读。当用户要求全部已读或清除通知时使用此工具。")
    public Map<String, Object> markAllNotificationsRead() {
        long startTime = System.currentTimeMillis();
        boolean success = true;
        String errorMsg = null;
        Long userId = SecurityUtils.getUserId();
        log.info("工具调用 - 标记所有通知已读, userId: {}", userId);
        publishToolCallEvent("markAllNotificationsRead", "正在标记所有通知为已读...", List.of("notification"));
        try {
            notificationService.markAllAsRead(userId);
            ChatContext.addToolCallName("markAllNotificationsRead");
            return Map.of("message", "已将所有通知标记为已读");
        } catch (Exception e) {
            success = false;
            errorMsg = e.getMessage();
            throw e;
        } finally {
            logToolCall("markAllNotificationsRead", "userId=" + userId, success,
                    System.currentTimeMillis() - startTime, errorMsg);
        }
    }

    @Tool(description = "分页查询当前用户的所有通知历史记录（包括已读和未读）。当用户要求查看所有通知记录、通知历史时使用此工具。")
    public Map<String, Object> queryNotificationHistory(
            @ToolParam(description = "页码，默认为1") Integer pageNum) {
        long startTime = System.currentTimeMillis();
        boolean success = true;
        String errorMsg = null;
        Long userId = SecurityUtils.getUserId();
        if (pageNum == null || pageNum < 1) {
            pageNum = 1;
        }
        log.info("工具调用 - 查询通知历史: pageNum={}, userId={}", pageNum, userId);
        publishToolCallEvent("queryNotificationHistory", "正在查询通知历史...");
        try {
            IPage<Notification> page = notificationService.listAllNotifications(userId, pageNum, 10, null, null);
            List<Map<String, Object>> notifications = page.getRecords().stream().map(n -> {
                Map<String, Object> map = new LinkedHashMap<>();
                map.put("notificationId", n.getNotificationId());
                map.put("title", n.getTitle() != null ? n.getTitle() : "");
                map.put("content", n.getContent() != null ? n.getContent() : "");
                map.put("type", n.getType() != null ? n.getType() : "");
                map.put("isRead", n.getIsRead() != null && n.getIsRead() == 1 ? "已读" : "未读");
                map.put("createTime", n.getCreateTime() != null ? n.getCreateTime().toString() : "");
                return map;
            }).collect(Collectors.toList());

            Map<String, Object> result = new LinkedHashMap<>();
            result.put("notifications", notifications);
            result.put("currentPage", page.getCurrent());
            result.put("totalPages", page.getPages());
            result.put("totalRecords", page.getTotal());

            publishToolCallEvent("queryNotificationHistory", "查询到 " + page.getTotal() + " 条通知记录");
            ChatContext.addToolCallName("queryNotificationHistory");
            return result;
        } catch (Exception e) {
            success = false;
            errorMsg = e.getMessage();
            throw e;
        } finally {
            logToolCall("queryNotificationHistory", "pageNum=" + pageNum + ",userId=" + userId, success,
                    System.currentTimeMillis() - startTime, errorMsg);
        }
    }
}
