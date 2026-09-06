package com.ruoyi.ai.context;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.util.List;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.*;

/**
 * ChatContext ThreadLocal上下文管理单元测试
 */
class ChatContextTest {

    @AfterEach
    void tearDown() {
        ChatContext.clear();
    }

    @Test
    @DisplayName("sessionId - set后get返回正确值")
    void sessionId_setAndGet() {
        ChatContext.setSessionId(100L);
        assertEquals(100L, ChatContext.getSessionId());
    }

    @Test
    @DisplayName("toolCallNames - 多次add累积为列表")
    void toolCallNames_multipleAdd() {
        ChatContext.addToolCallName("queryOrder");
        ChatContext.addToolCallName("queryProduct");
        ChatContext.addToolCallName("createTicket");

        List<String> names = ChatContext.getToolCallNames();
        assertEquals(3, names.size());
        assertEquals("queryOrder", names.get(0));
        assertEquals("queryProduct", names.get(1));
        assertEquals("createTicket", names.get(2));
    }

    @Test
    @DisplayName("toolCallNames - 未设置时返回空列表非null")
    void toolCallNames_notSet_returnsEmptyList() {
        List<String> names = ChatContext.getToolCallNames();
        assertNotNull(names);
        assertTrue(names.isEmpty());
    }

    @Test
    @DisplayName("cardData - 多次add累积为列表")
    void cardData_multipleAdd() {
        ChatContext.addCardData(Map.of("cardType", "product", "id", 1));
        ChatContext.addCardData(Map.of("cardType", "order", "id", 2));

        List<Map<String, Object>> cards = ChatContext.getCardData();
        assertEquals(2, cards.size());
        assertEquals("product", cards.get(0).get("cardType"));
        assertEquals("order", cards.get(1).get("cardType"));
    }

    @Test
    @DisplayName("ragSources - 未设置时返回空列表非null")
    void ragSources_notSet_returnsEmptyList() {
        List<Map<String, String>> sources = ChatContext.getRagSources();
        assertNotNull(sources);
        assertTrue(sources.isEmpty());
    }

    @Test
    @DisplayName("clear - 清理所有字段恢复初始状态")
    void clear_resetsAllFields() {
        ChatContext.setSessionId(100L);
        ChatContext.addToolCallName("queryOrder");
        ChatContext.addCardData(Map.of("type", "test"));
        ChatContext.setRagSources(List.of(Map.of("source", "doc1")));

        ChatContext.clear();

        assertNull(ChatContext.getSessionId());
        assertNull(ChatContext.getEmitter());
        assertTrue(ChatContext.getToolCallNames().isEmpty());
        assertTrue(ChatContext.getCardData().isEmpty());
        assertTrue(ChatContext.getRagSources().isEmpty());
    }
}
