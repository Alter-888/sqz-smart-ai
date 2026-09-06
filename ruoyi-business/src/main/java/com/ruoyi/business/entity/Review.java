package com.ruoyi.business.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("biz_review")
public class Review {

    @TableId(type = IdType.AUTO)
    private Long reviewId;

    private Long orderId;

    private Long orderItemId;

    private Long productId;

    private Long userId;

    private Integer rating;

    private String content;

    private Integer status;

    private LocalDateTime createTime;

    /** 商家回复内容 */
    private String adminReply;

    /** 回复时间 */
    private LocalDateTime replyTime;

    /** 非数据库字段：用户昵称（查询时填充） */
    @TableField(exist = false)
    private String nickName;

    /** 非数据库字段：商品名称（查询时填充） */
    @TableField(exist = false)
    private String productName;

    /** 非数据库字段：商品图片URL（查询时填充） */
    @TableField(exist = false)
    private String productImageUrl;
}
