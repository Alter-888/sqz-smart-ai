package com.ruoyi.ai.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("ai_chat_turn_audit")
public class ChatTurnAudit {

    @TableId(type = IdType.AUTO)
    private Long auditId;

    private Long sessionId;

    private Long userId;

    private String userMessage;

    private String aiResponse;

    /** RAG检索来源(JSON) */
    private String ragSource;

    /** 工具调用列表(JSON) */
    private String toolCalls;

    /** 本轮对话耗时(毫秒) */
    private Long durationMs;

    /** 意图（P4）：路由结果，如 PRODUCT/ORDER/AFTERSALES/ACCOUNT/KNOWLEDGE/CHITCHAT/HUMAN_HANDOFF */
    private String intent;

    /** 命中的领域 Agent（P4），如 sales-advisor/order-service */
    private String agentId;

    /** 路由来源（P4）：rule/llm/fallback */
    private String routeSource;

    /** 是否启用 RAG（P4）：该域是否挂知识检索，1是 0否 */
    private Integer ragEnabled;

    /** 重试次数（P4） */
    private Integer retryCount;

    /** 是否命中RAG: 1是 0否 */
    private Integer hasRagHit;

    private LocalDateTime createTime;
}
