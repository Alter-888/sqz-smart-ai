package com.ruoyi.business.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.ruoyi.common.annotation.Excel;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@TableName("biz_order")
public class Order {

    @TableId(type = IdType.AUTO)
    private Long orderId;

    @Excel(name = "订单号")
    private String orderNo;

    @Excel(name = "用户ID")
    private Long userId;

    @Excel(name = "总金额")
    private BigDecimal totalAmount;

    @Excel(name = "状态")
    private String status;

    @Excel(name = "付款时间", dateFormat = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime payTime;

    @Excel(name = "发货时间", dateFormat = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime shipTime;

    @Excel(name = "收货地址")
    private String address;

    @Excel(name = "物流单号")
    private String logisticsNo;

    @Excel(name = "物流公司")
    private String logisticsCompany;

    @Excel(name = "备注")
    private String remark;

    @Excel(name = "创建时间", dateFormat = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime createTime;

    private LocalDateTime updateTime;

    /** 用户昵称（非数据库字段，查询时填充） */
    @TableField(exist = false)
    private String nickName;

    /** 首件商品名称（非数据库字段，列表展示用） */
    @TableField(exist = false)
    private String firstItemName;

    /** 首件商品图片（非数据库字段，列表展示用） */
    @TableField(exist = false)
    private String firstItemImage;

    /** 订单商品总件数（非数据库字段，列表展示用） */
    @TableField(exist = false)
    private Integer itemCount;
}
