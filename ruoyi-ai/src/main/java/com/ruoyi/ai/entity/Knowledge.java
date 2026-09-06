package com.ruoyi.ai.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("ai_knowledge")
public class Knowledge {

    @TableId(type = IdType.AUTO)
    private Long knowledgeId;

    private String title;

    private String content;

    private String category;

    private Integer status;

    /** 来源类型：MANUAL手动 PRODUCT_AUTO商品自动 */
    private String sourceType;

    /** 来源ID（商品ID等） */
    private Long sourceId;

    /** 商品分类（仅 PRODUCT_AUTO 类型使用，如：手机、笔记本电脑） */
    private String productCategory;

    private LocalDateTime createTime;

    private LocalDateTime updateTime;
}
