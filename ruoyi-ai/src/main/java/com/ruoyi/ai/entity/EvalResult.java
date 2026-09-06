package com.ruoyi.ai.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 离线评测结果（P6）。
 * 对应表：ai_eval_result —— 05-指标与评测设计.md §3.3。
 * 指标允许为 null（没跑就是未评测，不是 0）；config_snapshot 记录当次参数快照。
 */
@Data
@TableName("ai_eval_result")
public class EvalResult {

    @TableId(type = IdType.AUTO)
    private Long resultId;

    private String dataset;

    /** 本次实际评测条数 */
    private Integer caseCount;

    private Double recallAtK;

    private Double recallAtFinalK;

    private Double precisionAtK;

    private Double mrr;

    private Double hitRate;

    private Double intentAccuracy;

    private Double toolAccuracy;

    private Double faithfulness;

    /** 平均单条耗时（ms） */
    private Long avgDurationMs;

    /** 当次参数快照（JSON 字符串） */
    private String configSnapshot;

    /** 本次跑的目的，如「P5全文路开启后」 */
    private String remark;

    private LocalDateTime runTime;
}
