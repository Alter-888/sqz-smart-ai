package com.ruoyi.ai.rag;

import java.util.List;

/**
 * 线上对话与离线评测共用的唯一检索入口。
 * 检索逻辑收敛在这一层，HybridRagAdvisor / EvaluationJob 都调它，保证评的是同一份代码。
 */
public interface RagRetrievalService {

    /** categories 为空表示不过滤；topK 为最终返回条数 */
    List<ScoredDoc> retrieve(String query, List<String> categories, int topK);
}
