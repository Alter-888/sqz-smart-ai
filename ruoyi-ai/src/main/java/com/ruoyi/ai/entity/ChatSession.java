package com.ruoyi.ai.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("ai_chat_session")
public class ChatSession {

    @TableId(type = IdType.AUTO)
    private Long sessionId;

    private Long userId;

    private String title;

    private Integer status;

    /** 是否置顶：0否 1是 */
    private Integer isPinned;

    /** 置顶时间 */
    private LocalDateTime pinTime;

    private LocalDateTime createTime;

    private LocalDateTime updateTime;
}
