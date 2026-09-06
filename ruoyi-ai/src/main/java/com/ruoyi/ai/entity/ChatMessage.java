package com.ruoyi.ai.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("ai_chat_message")
public class ChatMessage {

    @TableId(type = IdType.AUTO)
    private Long messageId;

    private Long sessionId;

    private String role;

    private String content;

    private String toolCalls;

    private String cardsData;

    private Integer feedback;

    private LocalDateTime createTime;
}
