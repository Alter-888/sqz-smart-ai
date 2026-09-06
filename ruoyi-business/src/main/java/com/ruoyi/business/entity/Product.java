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
@TableName("biz_product")
public class Product {

    @TableId(type = IdType.AUTO)
    private Long productId;

    @Excel(name = "商品名称")
    private String name;

    @Excel(name = "分类")
    private String category;

    @Excel(name = "价格")
    private BigDecimal price;

    @Excel(name = "库存")
    private Integer stock;

    @Excel(name = "描述")
    private String description;

    @Excel(name = "核心卖点")
    private String highlights;

    @Excel(name = "退换货政策")
    private String refundPolicy;

    @Excel(name = "保修信息")
    private String warrantyInfo;

    @Excel(name = "售后注意事项")
    private String afterSaleNote;

    private String imageUrl;

    @Excel(name = "状态", readConverterExp = "0=下架,1=上架")
    private Integer status;

    @Excel(name = "创建时间", dateFormat = "yyyy-MM-dd HH:mm:ss", type = Excel.Type.EXPORT)
    private LocalDateTime createTime;

    private LocalDateTime updateTime;

    /** 非数据库字段：销量（实时聚合计算） */
    @TableField(exist = false)
    private Integer salesCount;

    /** 非数据库字段：平均评分 */
    @TableField(exist = false)
    private Double avgRating;

    /** 非数据库字段：评价数量 */
    @TableField(exist = false)
    private Integer reviewCount;
}
