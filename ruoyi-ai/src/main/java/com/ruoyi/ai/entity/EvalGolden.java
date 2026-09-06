package com.ruoyi.ai.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 评测黄金集条目（P6）。
 * 对应表：ai_eval_golden —— 05-指标与评测设计.md §3.2。
 * expect_tools / truth_chunk_ids 在库里是 JSON，这里用 String 承接，读写时手动序列化/反序列化。
 */
@Data
@TableName("ai_eval_golden")
public class EvalGolden {

    @TableId(type = IdType.AUTO)
    private Long goldenId;

    /** 黄金集版本，便于并存多套 */
    private String dataset;

    /** 用户问题（尽量用真实提问） */
    private String question;

    /** 期望意图（评路由准确率） */
    private String expectIntent;

    /** 期望调用的工具名数组（JSON 字符串，如 ["queryOrder"]） */
    private String expectTools;

    /** 相关块id数组（JSON 字符串，ground truth） */
    private String truthChunkIds;

    /** 答案必须覆盖的要点（judge 打分用） */
    private String answerPoints;

    /** FAQ / POLICY / PRODUCT_INFO / GUIDE */
    private String category;

    /** 1启用 0停用 */
    private Integer status;

    private LocalDateTime createTime;
}
