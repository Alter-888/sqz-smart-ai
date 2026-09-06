package com.ruoyi.ai.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.ruoyi.ai.entity.ChatTurnAudit;
import com.ruoyi.ai.mapper.ChatTurnAuditMapper;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

/**
 * AI对话审计服务：异步记录每轮对话的RAG命中和工具调用情况
 */
@Service
@RequiredArgsConstructor
public class AuditService {

    private static final Logger log = LoggerFactory.getLogger(AuditService.class);

    private final ChatTurnAuditMapper chatTurnAuditMapper;
    private final ObjectMapper objectMapper;

    @Async("auditExecutor")
    public void recordTurn(Long sessionId, Long userId, String userMessage, String aiResponse,
                           List<Map<String, String>> ragSources, List<String> toolCallNames, long durationMs) {
        try {
            ChatTurnAudit audit = new ChatTurnAudit();
            audit.setSessionId(sessionId);
            audit.setUserId(userId);
            audit.setUserMessage(truncate(userMessage, 5000));
            audit.setAiResponse(truncate(aiResponse, 10000));
            audit.setRagSource(ragSources != null && !ragSources.isEmpty()
                    ? objectMapper.writeValueAsString(ragSources) : null);
            audit.setToolCalls(toolCallNames != null && !toolCallNames.isEmpty()
                    ? objectMapper.writeValueAsString(toolCallNames) : null);
            audit.setDurationMs(durationMs);
            audit.setHasRagHit(ragSources != null && !ragSources.isEmpty() ? 1 : 0);

            chatTurnAuditMapper.insert(audit);
            log.debug("审计记录已写入 - sessionId: {}, hasRagHit: {}, toolCalls: {}",
                    sessionId, audit.getHasRagHit(), toolCallNames);
        } catch (Exception e) {
            log.warn("写入审计记录失败: {}", e.getMessage());
        }
    }

    private String truncate(String text, int maxLength) {
        if (text == null) return null;
        return text.length() > maxLength ? text.substring(0, maxLength) : text;
    }
}
