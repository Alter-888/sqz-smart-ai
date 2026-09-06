package com.ruoyi.ai.context;

import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * 聊天上下文：通过 ThreadLocal 传递当前会话ID、SseEmitter、RAG来源和工具调用名称
 * 用于在 @Tool 方法中获取当前会话信息并发送工具调用通知
 */
public class ChatContext {

    private static final ThreadLocal<Long> SESSION_ID = new ThreadLocal<>();
    private static final ThreadLocal<SseEmitter> EMITTER = new ThreadLocal<>();
    private static final ThreadLocal<List<Map<String, String>>> RAG_SOURCES = new ThreadLocal<>();
    private static final ThreadLocal<List<String>> TOOL_CALL_NAMES = new ThreadLocal<>();
    private static final ThreadLocal<List<Map<String, Object>>> CARD_DATA = new ThreadLocal<>();

    public static void setSessionId(Long sessionId) {
        SESSION_ID.set(sessionId);
    }

    public static Long getSessionId() {
        return SESSION_ID.get();
    }

    public static void setEmitter(SseEmitter emitter) {
        EMITTER.set(emitter);
    }

    public static SseEmitter getEmitter() {
        return EMITTER.get();
    }

    public static void setRagSources(List<Map<String, String>> sources) {
        RAG_SOURCES.set(sources);
    }

    public static List<Map<String, String>> getRagSources() {
        List<Map<String, String>> sources = RAG_SOURCES.get();
        return sources != null ? sources : new ArrayList<>();
    }

    public static void addToolCallName(String toolName) {
        List<String> names = TOOL_CALL_NAMES.get();
        if (names == null) {
            names = new ArrayList<>();
            TOOL_CALL_NAMES.set(names);
        }
        names.add(toolName);
    }

    public static List<String> getToolCallNames() {
        List<String> names = TOOL_CALL_NAMES.get();
        return names != null ? names : new ArrayList<>();
    }

    public static void addCardData(Map<String, Object> card) {
        List<Map<String, Object>> cards = CARD_DATA.get();
        if (cards == null) {
            cards = new ArrayList<>();
            CARD_DATA.set(cards);
        }
        cards.add(card);
    }

    public static List<Map<String, Object>> getCardData() {
        List<Map<String, Object>> cards = CARD_DATA.get();
        return cards != null ? cards : new ArrayList<>();
    }

    public static void clear() {
        SESSION_ID.remove();
        EMITTER.remove();
        RAG_SOURCES.remove();
        TOOL_CALL_NAMES.remove();
        CARD_DATA.remove();
    }
}
