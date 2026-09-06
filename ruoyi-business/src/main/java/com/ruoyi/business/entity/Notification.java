package com.ruoyi.business.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("biz_notification")
public class Notification {

    @TableId(type = IdType.AUTO)
    private Long notificationId;

    private Long userId;

    private String title;

    private String content;

    /** 通知类型: ORDER_STATUS / TICKET_REPLY / STOCK_WARNING */
    private String type;

    /** 关联业务ID */
    private Long refId;

    /** 是否已读: 0未读/1已读 */
    private Integer isRead;

    private LocalDateTime createTime;
}
