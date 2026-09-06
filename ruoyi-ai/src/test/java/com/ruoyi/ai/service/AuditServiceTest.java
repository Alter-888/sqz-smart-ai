package com.ruoyi.ai.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.ruoyi.ai.entity.ChatTurnAudit;
import com.ruoyi.ai.mapper.ChatTurnAuditMapper;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Spy;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.List;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

/**
 * AuditService 审计服务单元测试
 */
@ExtendWith(MockitoExtension.class)
class AuditServiceTest {

    @Mock
    private ChatTurnAuditMapper chatTurnAuditMapper;

    @Spy
    private ObjectMapper objectMapper = new ObjectMapper();

    @InjectMocks
    private AuditService auditService;

    @Test
    @DisplayName("recordTurn - 正常记录，verify insert被调用")
    void recordTurn_normal_insertsAudit() {
        when(chatTurnAuditMapper.insert(any(ChatTurnAudit.class))).thenReturn(1);

        auditService.recordTurn(1L, 100L, "你好", "你好！有什么可以帮您？",
                List.of(), List.of("queryOrder"), 500L);

        verify(chatTurnAuditMapper).insert(any(ChatTurnAudit.class));
    }

    @Test
    @DisplayName("recordTurn - 有RAG来源时hasRagHit=1")
    void recordTurn_withRagSources_hasRagHitIsOne() {
        ArgumentCaptor<ChatTurnAudit> captor = ArgumentCaptor.forClass(ChatTurnAudit.class);
        when(chatTurnAuditMapper.insert(captor.capture())).thenReturn(1);

        List<Map<String, String>> ragSources = List.of(
                Map.of("source", "退货政策.md", "content", "7天无理由退货"));

        auditService.recordTurn(1L, 100L, "退货政策", "回复内容",
                ragSources, List.of(), 300L);

        assertEquals(1, captor.getValue().getHasRagHit());
    }

    @Test
    @DisplayName("recordTurn - 无RAG来源时hasRagHit=0")
    void recordTurn_noRagSources_hasRagHitIsZero() {
        ArgumentCaptor<ChatTurnAudit> captor = ArgumentCaptor.forClass(ChatTurnAudit.class);
        when(chatTurnAuditMapper.insert(captor.capture())).thenReturn(1);

        auditService.recordTurn(1L, 100L, "你好", "你好！",
                List.of(), List.of(), 200L);

        assertEquals(0, captor.getValue().getHasRagHit());
    }

    @Test
    @DisplayName("recordTurn - 超长消息截断到5000字符")
    void recordTurn_longMessage_truncatedTo5000() {
        ArgumentCaptor<ChatTurnAudit> captor = ArgumentCaptor.forClass(ChatTurnAudit.class);
        when(chatTurnAuditMapper.insert(captor.capture())).thenReturn(1);

        String longMessage = "测".repeat(6000);

        auditService.recordTurn(1L, 100L, longMessage, "回复",
                List.of(), List.of(), 100L);

        assertEquals(5000, captor.getValue().getUserMessage().length());
    }

    @Test
    @DisplayName("recordTurn - mapper异常不向上抛出")
    void recordTurn_mapperException_doesNotThrow() {
        when(chatTurnAuditMapper.insert(any(ChatTurnAudit.class)))
                .thenThrow(new RuntimeException("DB连接失败"));

        assertDoesNotThrow(() ->
                auditService.recordTurn(1L, 100L, "你好", "回复",
                        List.of(), List.of(), 100L));
    }
}
