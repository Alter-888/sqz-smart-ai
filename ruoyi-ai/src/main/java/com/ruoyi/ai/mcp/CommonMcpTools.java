package com.ruoyi.ai.mcp;

import com.ruoyi.ai.context.ChatContext;
import com.ruoyi.ai.entity.ToolCallLog;
import com.ruoyi.ai.event.ToolCallEvent;
import com.ruoyi.ai.mapper.ToolCallLogMapper;
import com.ruoyi.business.entity.Ticket;
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

/**
 * 公共工具组：所有 Worker 都需要的能力（目前只有"转人工"）。
 * 从 TicketMcpTools 迁出 escalateToHuman，方法名与 @Tool 描述一字不改，
 * 保证 Dashboard 里 humanEscalationRate（按 tool_name='escalateToHuman' 统计）口径不断档。
 */
@Component
@RequiredArgsConstructor
public class CommonMcpTools {

    private static final Logger log = LoggerFactory.getLogger(CommonMcpTools.class);

    private final TicketService ticketService;
    private final ToolCallLogMapper toolCallLogMapper;
    private final ApplicationEventPublisher eventPublisher;

    @Tool(description = "将对话转接给人工客服。当AI无法解决用户问题，或用户明确要求人工服务时使用此工具。系统会创建一个转人工工单。")
    public Map<String, Object> escalateToHuman(
            @ToolParam(description = "转接原因，简要说明为什么需要人工介入") String reason) {
        long startTime = System.currentTimeMillis();
        boolean success = true;
        String errorMsg = null;
        Long userId = SecurityUtils.getUserId();
        log.info("工具调用 - 转人工客服: userId={}, reason={}", userId, reason);
        publishToolCallEvent("escalateToHuman", "正在为您转接人工客服...", List.of("ticket"));
        try {
            Ticket ticket = new Ticket();
            ticket.setUserId(userId);
            ticket.setType("CONSULT");
            ticket.setTitle("【转人工】" + (reason.length() > 40 ? reason.substring(0, 40) : reason));
            ticket.setDescription("用户在AI对话中请求转人工服务。原因：" + reason);
            ticket.setPriority(1);

            ticketService.createTicket(ticket);
            log.info("转人工工单创建成功: {}, 用户: {}", ticket.getTicketNo(), userId);
            ChatContext.addToolCallName("escalateToHuman");

            return Map.of(
                    "ticketNo", ticket.getTicketNo(),
                    "message", "已为您转接人工客服，工单号: " + ticket.getTicketNo() + "，客服人员会尽快处理。"
            );
        } catch (Exception e) {
            success = false;
            errorMsg = e.getMessage();
            throw e;
        } finally {
            logToolCall("escalateToHuman", "reason=" + reason, success,
                System.currentTimeMillis() - startTime, errorMsg);
        }
    }

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

    private void publishToolCallEvent(String toolName, String description, List<String> refreshTypes) {
        try {
            Long sessionId = ChatContext.getSessionId();
            eventPublisher.publishEvent(new ToolCallEvent(this, toolName, description, sessionId, null, null, refreshTypes));
        } catch (Exception e) {
            log.warn("发布工具调用事件失败: {}", e.getMessage());
        }
    }
}
