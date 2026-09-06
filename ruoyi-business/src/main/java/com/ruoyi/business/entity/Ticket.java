package com.ruoyi.business.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.ruoyi.common.annotation.Excel;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@TableName("biz_ticket")
public class Ticket {

    @TableId(type = IdType.AUTO)
    private Long ticketId;

    @Excel(name = "工单号")
    private String ticketNo;

    @Excel(name = "用户ID")
    private Long userId;

    @Excel(name = "关联订单ID")
    private Long orderId;

    @Excel(name = "类型")
    private String type;

    @Excel(name = "标题")
    private String title;

    @Excel(name = "描述")
    private String description;

    @Excel(name = "退款金额")
    private BigDecimal refundAmount;

    @Excel(name = "退款原因")
    private String refundReason;

    @Excel(name = "退款进度")
    private String refundStatus;

    @Excel(name = "状态")
    private String status;

    @Excel(name = "优先级", readConverterExp = "0=普通,1=紧急,2=特急")
    private Integer priority;

    @Excel(name = "指派客服ID")
    private Long assigneeId;

    @Excel(name = "回复")
    private String reply;

    @Excel(name = "创建时间", dateFormat = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime createTime;

    private LocalDateTime updateTime;
}
