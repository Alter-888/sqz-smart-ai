package com.ruoyi.ai.rag;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * 倒数排名融合（Reciprocal Rank Fusion）。
 * 只看排名不看分数，因此不需要把「余弦相似度」与「ts_rank」这两种量纲不同的分数归一化。
 */
public final class RrfFusion {

    /** score = Σ 1/(k + rank)，rank 从 1 开始；k 越大靠前名次的优势越平缓，业界惯例 60 */
    public static List<ScoredDoc> fuse(List<List<ScoredDoc>> lists, int k, int topK) {
        Map<String, Double> scores = new HashMap<>();
        Map<String, ScoredDoc> byId = new HashMap<>();
        for (List<ScoredDoc> list : lists) {
            if (list == null || list.isEmpty()) {
                continue;
            }
            for (int i = 0; i < list.size(); i++) {
                ScoredDoc d = list.get(i);
                scores.merge(d.id(), 1.0 / (k + i + 1), Double::sum);
                byId.putIfAbsent(d.id(), d);
            }
        }
        return scores.entrySet().stream()
                .sorted(Map.Entry.<String, Double>comparingByValue().reversed())
                .limit(topK)
                .map(e -> {
                    ScoredDoc d = byId.get(e.getKey());
                    return new ScoredDoc(d.id(), d.content(), d.metadata(), e.getValue());
                })
                .collect(Collectors.toList());
    }

    private RrfFusion() {
    }
}
