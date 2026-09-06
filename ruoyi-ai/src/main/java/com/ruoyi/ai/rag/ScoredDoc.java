package com.ruoyi.ai.rag;

import java.util.Map;

/**
 * 一条检索候选块。
 * score 的含义随来源不同：向量路是相似度(1-cosine_distance)，全文路是 ts_rank，融合后是 RRF 分。
 */
public record ScoredDoc(String id, String content, Map<String, Object> metadata, double score) {
}
