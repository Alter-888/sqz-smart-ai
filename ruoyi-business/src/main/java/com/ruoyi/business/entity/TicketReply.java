package com.ruoyi.business.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("biz_ticket_reply")
public class TicketReply {

    @TableId(type = IdType.AUTO)
    private Long replyId;

    private Long ticketId;

    private Long userId;

    private String content;

    /** 回复类型: USER(用户)/STAFF(客服)/SYSTEM(系统) */
    private String replyType;

    private LocalDateTime createTime;
}
