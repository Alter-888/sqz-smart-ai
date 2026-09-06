package com.ruoyi.ai.rag;

import java.util.List;

/**
 * 单路检索器。向量路、全文路各自实现。
 * categories 为空表示不过滤；实现内部不得把用户输入拼进 SQL 或过滤表达式。
 */
public interface Retriever {

    /** categories 为空表示不过滤；topK 为该路返回候选条数 */
    List<ScoredDoc> retrieve(String query, List<String> categories, int topK);
}
