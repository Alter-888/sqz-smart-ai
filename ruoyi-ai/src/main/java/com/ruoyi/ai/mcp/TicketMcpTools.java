package com.ruoyi.ai.mcp;

import com.ruoyi.ai.context.ChatContext;
import com.ruoyi.ai.entity.ToolCallLog;
import com.ruoyi.ai.event.ToolCallEvent;
import com.ruoyi.ai.mapper.ToolCallLogMapper;
import com.ruoyi.business.entity.Order;
import com.ruoyi.business.entity.Ticket;
import com.ruoyi.business.service.OrderService;
import com.ruoyi.business.service.TicketService;
import com.ruoyi.common.utils.SecurityUtils;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.ai.tool.annotation.Tool;
import org.springframework.ai.tool.annotation.ToolParam;
import org.springframework.context.ApplicationEventPublisher;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * MCP 工单工具：为 AI 提供工单创建、查询、转人工客服能力
 * 通过 MCP 协议暴露，同时支持 MethodToolCallbackProvider 直接调用
 */
@Component
@RequiredArgsConstructor
public class TicketMcpTools {

    private static final Logger log = LoggerFactory.getLogger(TicketMcpTools.class);

    private final TicketService ticketService;
    private final OrderService orderService;
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

    @Tool(description = "为当前用户创建售后工单，类型包括投诉(COMPLAINT)、退款(REFUND)、换货(EXCHANGE)、咨询(CONSULT)。当用户需要投诉、退款、换货或有售后问题时使用此工具。")
    public Map<String, Object> createTicket(
            @ToolParam(description = "关联订单编号，如无关联订单可传空字符串") String orderNo,
            @ToolParam(description = "工单类型：COMPLAINT(投诉)/REFUND(退款)/EXCHANGE(换货)/CONSULT(咨询)") String type,
            @ToolParam(description = "问题描述，用户反馈的详细内容") String description) {
        long startTime = System.currentTimeMillis();
        boolean success = true;
        String errorMsg = null;
        Long userId = SecurityUtils.getUserId();
        log.info("工具调用 - 创建工单, userId: {}, type: {}", userId, type);
        publishToolCallEvent("createTicket", "正在为用户创建" + type + "工单...", List.of("ticket"));
        try {
            Long orderId = null;
            if (orderNo != null && !orderNo.isEmpty()) {
                Order order = orderService.getByOrderNo(orderNo);
                if (order == null) {
                    ChatContext.addToolCallName("createTicket");
                    return Map.of("error", "未找到关联订单: " + orderNo);
                }
                if (!order.getUserId().equals(userId)) {
                    ChatContext.addToolCallName("createTicket");
                    return Map.of("error", "该订单不属于当前用户，无法创建工单");
                }
                orderId = order.getOrderId();
            }

            Ticket ticket = new Ticket();
            ticket.setUserId(userId);
            ticket.setOrderId(orderId);
            ticket.setType(type);
            ticket.setTitle(type + " - " + (description.length() > 50 ? description.substring(0, 50) : description));
            ticket.setDescription(description);

            ticketService.createTicket(ticket);
            log.info("工具调用 - 创建工单成功: {}, 类型: {}, 用户: {}", ticket.getTicketNo(), type, userId);
            ChatContext.addToolCallName("createTicket");

            return Map.of(
                    "ticketNo", ticket.getTicketNo(),
                    "type", type,
                    "status", "OPEN",
                    "message", "工单创建成功，工单编号: " + ticket.getTicketNo()
            );
        } catch (Exception e) {
            success = false;
            errorMsg = e.getMessage();
            throw e;
        } finally {
            logToolCall("createTicket", "userId=" + userId + ",type=" + type, success,
                System.currentTimeMillis() - startTime, errorMsg);
        }
    }

    @Tool(description = "根据工单编号查询工单状态和处理进度。当用户询问之前提交的工单进度时使用此工具。")
    public Map<String, Object> queryTicket(
            @ToolParam(description = "工单编号") String ticketNo) {
        long startTime = System.currentTimeMillis();
        boolean success = true;
        String errorMsg = null;
        log.info("工具调用 - 查询工单: {}", ticketNo);
        publishToolCallEvent("queryTicket", "正在查询工单 " + ticketNo + " ...");
        try {
            Ticket ticket = ticketService.getByTicketNo(ticketNo);
            if (ticket == null) {
                ChatContext.addToolCallName("queryTicket");
                return Map.of("error", "未找到工单: " + ticketNo);
            }
            Long currentUserId = SecurityUtils.getUserId();
            if (!SecurityUtils.isAdmin(currentUserId) && !ticket.getUserId().equals(currentUserId)) {
                ChatContext.addToolCallName("queryTicket");
                return Map.of("error", "您无权查看该工单");
            }
            ChatContext.addToolCallName("queryTicket");
            return Map.of(
                    "ticketNo", ticket.getTicketNo(),
                    "type", ticket.getType(),
                    "title", ticket.getTitle(),
                    "status", ticket.getStatus(),
                    "description", ticket.getDescription() != null ? ticket.getDescription() : "",
                    "reply", ticket.getReply() != null ? ticket.getReply() : "",
                    "createTime", ticket.getCreateTime() != null ? ticket.getCreateTime().toString() : ""
            );
        } catch (Exception e) {
            success = false;
            errorMsg = e.getMessage();
            throw e;
        } finally {
            logToolCall("queryTicket", ticketNo, success,
                System.currentTimeMillis() - startTime, errorMsg);
        }
    }

    @Tool(description = "查询当前用户的所有工单列表。当用户想查看自己提交的所有工单时使用此工具。")
    public List<Map<String, Object>> queryUserTickets() {
        long startTime = System.currentTimeMillis();
        boolean success = true;
        String errorMsg = null;
        Long userId = SecurityUtils.getUserId();
        log.info("工具调用 - 查询用户工单列表, userId: {}", userId);
        publishToolCallEvent("queryUserTickets", "正在查询用户工单列表...");
        try {
            var page = ticketService.listUserTickets(userId, 1, 20);
            List<Ticket> tickets = page.getRecords();
            if (tickets.isEmpty()) {
                ChatContext.addToolCallName("queryUserTickets");
                return List.of(Map.of("message", "您暂无工单"));
            }
            ChatContext.addToolCallName("queryUserTickets");
            return tickets.stream().map(t -> Map.<String, Object>of(
                    "ticketNo", t.getTicketNo(),
                    "type", t.getType(),
                    "title", t.getTitle() != null ? t.getTitle() : "",
                    "status", t.getStatus(),
                    "createTime", t.getCreateTime() != null ? t.getCreateTime().toString() : ""
            )).collect(Collectors.toList());
        } catch (Exception e) {
            success = false;
            errorMsg = e.getMessage();
            throw e;
        } finally {
            logToolCall("queryUserTickets", String.valueOf(userId), success,
                System.currentTimeMillis() - startTime, errorMsg);
        }
    }


    @Tool(description = "帮助用户回复售后工单。当用户要求回复工单、给客服留言时使用此工具。AI应先确认工单号和回复内容后再执行。")
    public Map<String, Object> replyTicket(
            @ToolParam(description = "工单编号") String ticketNo,
            @ToolParam(description = "回复内容") String content) {
        long startTime = System.currentTimeMillis();
        boolean success = true;
        String errorMsg = null;
        Long userId = SecurityUtils.getUserId();
        log.info("工具调用 - 回复工单, userId: {}, ticketNo: {}", userId, ticketNo);
        publishToolCallEvent("replyTicket", "正在回复工单 " + ticketNo + " ...", List.of("ticket"));
        try {
            Ticket ticket = ticketService.getByTicketNo(ticketNo);
            if (ticket == null) {
                ChatContext.addToolCallName("replyTicket");
                return Map.of("error", "未找到工单: " + ticketNo);
            }
            if (!ticket.getUserId().equals(userId)) {
                ChatContext.addToolCallName("replyTicket");
                return Map.of("error", "您无权回复该工单");
            }
            ticketService.addReply(ticket.getTicketId(), userId, content, "USER");
            log.info("工具调用 - 回复工单成功: {}, 用户: {}", ticketNo, userId);
            ChatContext.addToolCallName("replyTicket");
            return Map.of(
                    "ticketNo", ticketNo,
                    "message", "回复成功",
                    "replyContent", content
            );
        } catch (Exception e) {
            success = false;
            errorMsg = e.getMessage();
            throw e;
        } finally {
            logToolCall("replyTicket", "ticketNo=" + ticketNo + ",userId=" + userId, success,
                System.currentTimeMillis() - startTime, errorMsg);
        }
    }

    @Tool(description = "帮助用户关闭已解决的工单。当用户表示工单已解决、要求关闭工单时使用此工具。AI应先确认工单号后再执行。")
    public Map<String, Object> closeTicket(
            @ToolParam(description = "工单编号") String ticketNo) {
        long startTime = System.currentTimeMillis();
        boolean success = true;
        String errorMsg = null;
        Long userId = SecurityUtils.getUserId();
        log.info("工具调用 - 关闭工单, userId: {}, ticketNo: {}", userId, ticketNo);
        publishToolCallEvent("closeTicket", "正在关闭工单 " + ticketNo + " ...", List.of("ticket"));
        try {
            Ticket ticket = ticketService.getByTicketNo(ticketNo);
            if (ticket == null) {
                ChatContext.addToolCallName("closeTicket");
                return Map.of("error", "未找到工单: " + ticketNo);
            }
            if (!ticket.getUserId().equals(userId)) {
                ChatContext.addToolCallName("closeTicket");
                return Map.of("error", "您无权关闭该工单");
            }
            ticketService.closeTicket(ticket.getTicketId());
            log.info("工具调用 - 关闭工单成功: {}, 用户: {}", ticketNo, userId);
            ChatContext.addToolCallName("closeTicket");
            return Map.of(
                    "ticketNo", ticketNo,
                    "status", "CLOSED",
                    "message", "工单已关闭"
            );
        } catch (Exception e) {
            success = false;
            errorMsg = e.getMessage();
            throw e;
        } finally {
            logToolCall("closeTicket", "ticketNo=" + ticketNo + ",userId=" + userId, success,
                System.currentTimeMillis() - startTime, errorMsg);
        }
    }
}
