package com.ruoyi.business.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.math.BigDecimal;

@Data
@TableName("biz_order_item")
public class OrderItem {

    @TableId(type = IdType.AUTO)
    private Long itemId;

    private Long orderId;

    private Long productId;

    private String productName;

    private BigDecimal price;

    private Integer quantity;

    // 虚拟字段（查询时从 Product 填充）
    @TableField(exist = false)
    private String imageUrl;
}
