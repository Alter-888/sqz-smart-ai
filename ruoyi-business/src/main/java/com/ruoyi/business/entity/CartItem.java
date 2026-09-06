package com.ruoyi.business.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@TableName("biz_cart_item")
public class CartItem {

    @TableId(type = IdType.AUTO)
    private Long cartItemId;

    private Long userId;

    private Long productId;

    private Integer quantity;

    /** 是否选中: 0否 1是 */
    private Integer checked;

    private LocalDateTime createTime;

    private LocalDateTime updateTime;

    // ========== 虚拟字段（查询时从 Product 填充） ==========

    @TableField(exist = false)
    private String productName;

    @TableField(exist = false)
    private BigDecimal price;

    @TableField(exist = false)
    private String imageUrl;

    @TableField(exist = false)
    private Integer stock;
}
