package com.ruoyi.ai.unit;

import com.ruoyi.ai.rag.RrfFusion;
import com.ruoyi.ai.rag.ScoredDoc;
import org.junit.jupiter.api.Test;

import java.util.List;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

/**
 * RRF 融合单测：score = Σ 1/(k + rank)，rank 从 1 开始，k=60，按 RRF 分降序取 topK。
 * 融合算法错了不会报错，只会让 Recall 悄悄降一点，所以必须拿手算值兜底。
 */
class RrfFusionTest {

    private static final int K = 60;

    private static ScoredDoc doc(String id) {
        return new ScoredDoc(id, "content-" + id, Map.of(), 0d);
    }

    /** 有交集：A/B/C 与 B/D，B 在两路都出现，融合后应排第一 */
    @Test
    void fuseWithOverlapOrdersByRrfScore() {
        List<ScoredDoc> list1 = List.of(doc("A"), doc("B"), doc("C"));
        List<ScoredDoc> list2 = List.of(doc("B"), doc("D"));

        List<ScoredDoc> fused = RrfFusion.fuse(List.of(list1, list2), K, 10);

        // 手算 RRF 分：A=1/61, B=1/61+1/62, C=1/63, D=1/62 → B > A > D > C
        assertEquals(List.of("B", "A", "D", "C"),
                fused.stream().map(ScoredDoc::id).collect(java.util.stream.Collectors.toList()));
    }

    /** 无交集：A/B 与 C/D，融合后四者都保留且分数只来自各自那一路 */
    @Test
    void fuseWithoutOverlapKeepsAll() {
        List<ScoredDoc> list1 = List.of(doc("A"), doc("B"));
        List<ScoredDoc> list2 = List.of(doc("C"), doc("D"));

        List<ScoredDoc> fused = RrfFusion.fuse(List.of(list1, list2), K, 10);

        assertEquals(List.of("A", "C", "B", "D"),
                fused.stream().map(ScoredDoc::id).collect(java.util.stream.Collectors.toList()));
        assertEquals(4, fused.size());
    }

    /** 单路为空：一路空，融合结果等于另一路原顺序且分数保留 */
    @Test
    void fuseWhenOneListEmptyUsesOther() {
        List<ScoredDoc> list1 = List.of();
        List<ScoredDoc> list2 = List.of(doc("A"), doc("B"), doc("C"));

        List<ScoredDoc> fused = RrfFusion.fuse(List.of(list1, list2), K, 10);

        assertEquals(List.of("A", "B", "C"),
                fused.stream().map(ScoredDoc::id).collect(java.util.stream.Collectors.toList()));
    }

    /** 两路都空：返回空列表而不是异常 */
    @Test
    void fuseWhenBothEmptyReturnsEmpty() {
        assertTrue(RrfFusion.fuse(List.of(List.of(), List.of()), K, 10).isEmpty());
    }

    /** topK 生效：融合结果被截断到 topK */
    @Test
    void fuseRespectsTopK() {
        List<ScoredDoc> list1 = List.of(doc("A"), doc("B"), doc("C"), doc("D"), doc("E"));
        List<ScoredDoc> fused = RrfFusion.fuse(List.of(list1), K, 3);
        assertEquals(3, fused.size());
    }
}
