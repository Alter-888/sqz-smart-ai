package com.ruoyi.ai.eval;

import java.util.List;

/**
 * 一条评测用例（从 ai_eval_golden 读出后转成的内存形态，P6）。
 * truthKeys 是 knowledge 条目的 entryKey（去掉 _c{n} 块后缀），算 Recall/MRR 的 ground truth。
 */
public record GoldenCase(
        Long goldenId,
        String question,
        String expectIntent,
        List<String> expectTools,
        List<String> truthKeys,
        String answerPoints,
        String category) {
}
