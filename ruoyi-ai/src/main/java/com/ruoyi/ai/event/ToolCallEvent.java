package com.ruoyi.ai.event;

import org.springframework.context.ApplicationEvent;

import java.util.List;
import java.util.Map;

/**
 * 工具调用事件：工具被调用时发布此事件
 * ChatService 监听此事件并通过 SSE 推送到前端
 */
public class ToolCallEvent extends ApplicationEvent {

    private final String toolName;
    private final String description;
    private final Long sessionId;
    /** 卡片类型：product / order / null */
    private final String cardType;
    /** 卡片数据列表 */
    private final List<Map<String, Object>> cardData;
    /** 数据变更类型列表：通知前端刷新对应模块，如 "cart", "order", "notification", "address", "review", "ticket" */
    private final List<String> refreshTypes;

    public ToolCallEvent(Object source, String toolName, String description, Long sessionId) {
        this(source, toolName, description, sessionId, null, null, null);
    }

    public ToolCallEvent(Object source, String toolName, String description, Long sessionId,
                         String cardType, List<Map<String, Object>> cardData) {
        this(source, toolName, description, sessionId, cardType, cardData, null);
    }

    public ToolCallEvent(Object source, String toolName, String description, Long sessionId,
                         String cardType, List<Map<String, Object>> cardData, List<String> refreshTypes) {
        super(source);
        this.toolName = toolName;
        this.description = description;
        this.sessionId = sessionId;
        this.cardType = cardType;
        this.cardData = cardData;
        this.refreshTypes = refreshTypes;
    }

    public String getToolName() {
        return toolName;
    }

    public String getDescription() {
        return description;
    }

    public Long getSessionId() {
        return sessionId;
    }

    public String getCardType() {
        return cardType;
    }

    public List<Map<String, Object>> getCardData() {
        return cardData;
    }

    public List<String> getRefreshTypes() {
        return refreshTypes;
    }
}
