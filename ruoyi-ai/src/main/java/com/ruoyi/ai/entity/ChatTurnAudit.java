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

    /** 是否命中RAG: 1是 0否 */
    private Integer hasRagHit;

    private LocalDateTime createTime;
}
