package com.ruoyi.ai.unit;

import com.ruoyi.ai.eval.EvalAccumulator;
import com.ruoyi.ai.eval.EvalMetrics;
import com.ruoyi.ai.rag.ScoredDoc;
import org.junit.jupiter.api.Test;

import java.util.List;
import java.util.Map;

import static org.assertj.core.api.Assertions.assertThat;

/**
 * 评测指标累加器单测（P6）。
 * 评测管道自己就是测试工具，算错了没人会告诉，必须用断言锁住（05 §6.2 的 "要写的测试"）。
 */
class EvalMetricsTest {

    @Test
    void entryKey_把块id归到条目级() {
        assertThat(EvalAccumulator.entryKey("knowledge_33_c0")).isEqualTo("knowledge_33");
        assertThat(EvalAccumulator.entryKey("knowledge_33_c12")).isEqualTo("knowledge_33");
        assertThat(EvalAccumulator.entryKey("knowledge_33")).isEqualTo("knowledge_33");
        // 含 _c 的诡异输入：只剥末尾的 _c{n}
        assertThat(EvalAccumulator.entryKey("knowledge_c3_c1")).isEqualTo("knowledge_c3");
        assertThat(EvalAccumulator.entryKey(null)).isEmpty();
    }

    @Test
    void recall分母用标注条目数_precision分母用实际返回条数() {
        EvalAccumulator acc = new EvalAccumulator();
        // truth=1（knowledge_33）；docs 返回 3 条，其中 2 条归属同一 knowledge_33，1 条无关
        acc.addRetrieval(List.of("knowledge_33"),
                List.of(doc("knowledge_33_c0"), doc("knowledge_33_c12"), doc("knowledge_99_c0")),
                4);
        EvalMetrics m = acc.summarize(1, 100L);
        // Recall：命中的条目数(1) / 标注条目数(1) = 100%
        assertThat(m.recallAtK()).isEqualTo(100.0);
        // Precision：相关块数(2) / 实际返回条数(3) = 66.67（不是拿 K=8 当分母）
        assertThat(m.precisionAtK()).isEqualTo(66.67);
        // MRR：第一个相关块 rank=1 -> 100
        assertThat(m.mrr()).isEqualTo(100.0);
        // Hit Rate：至少命中一个 -> 100
        assertThat(m.hitRate()).isEqualTo(100.0);
    }

    @Test
    void 除法只在最后做一次() {
        EvalAccumulator acc = new EvalAccumulator();
        // case1：truth=2 命中 2 -> recall 1.0
        acc.addRetrieval(List.of("knowledge_1", "knowledge_2"),
                List.of(doc("knowledge_1_c0"), doc("knowledge_2_c0")), 8);
        // case2：truth=2 命中 1 -> recall 0.5
        acc.addRetrieval(List.of("knowledge_1", "knowledge_2"),
                List.of(doc("knowledge_1_c0")), 8);
        EvalMetrics m = acc.summarize(2, 50L);
        // 先累加分子分母最后再相除：(1.0 + 0.5) / 2 = 0.75 -> 75.0
        assertThat(m.recallAtK()).isEqualTo(75.0);
    }

    @Test
    void 未跑指标是null_不是0() {
        EvalAccumulator acc = new EvalAccumulator();
        EvalMetrics m = acc.summarize(1, 10L);
        assertThat(m.toolAccuracy()).isNull();
        assertThat(m.faithfulness()).isNull();
        assertThat(m.intentAccuracy()).isNull();
    }

    @Test
    void toolAccuracy用覆盖_不是完全相等() {
        EvalAccumulator acc = new EvalAccumulator();
        // 期望 [A]，实际 [A,B]：该调的都调了 -> 算对
        acc.addTools(List.of("A"), List.of("A", "B"));
        // 期望 [A,B]，实际 [A]：漏调 B -> 算错
        acc.addTools(List.of("A", "B"), List.of("A"));
        EvalMetrics m = acc.summarize(2, 20L);
        assertThat(m.toolAccuracy()).isEqualTo(50.0);
    }

    private ScoredDoc doc(String id) {
        return new ScoredDoc(id, "content", Map.of(), 0.9);
    }
}
