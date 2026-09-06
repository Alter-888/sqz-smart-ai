package com.ruoyi.ai.eval;

/**
 * 一次评测的汇总指标（P6）。
 * 可为空的三项（toolAccuracy / faithfulness / 其余指标）没跑就是 null，绝不是 0：
 * 填 0 会在趋势图上造成一次假的"暴跌"。
 */
public record EvalMetrics(
        int caseCount,
        Double recallAtK,
        Double recallAtFinalK,
        Double precisionAtK,
        Double mrr,
        Double hitRate,
        Double intentAccuracy,
        Double toolAccuracy,
        Double faithfulness,
        long avgDurationMs) {
}
