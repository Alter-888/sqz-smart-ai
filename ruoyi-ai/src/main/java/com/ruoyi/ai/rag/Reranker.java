package com.ruoyi.ai.rag;

import java.util.List;

/**
 * 重排器。默认直通（只截断，不重排），P5 后可接外部精排。
 */
public interface Reranker {

    List<ScoredDoc> rerank(String query, List<ScoredDoc> candidates, int topK);
}
