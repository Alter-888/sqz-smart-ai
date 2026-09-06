package com.ruoyi.ai.rag;

import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

import java.util.List;

/**
 * 全文路：PG tsvector 精确命中（型号/单号/英文词）。
 * P2 阶段先返回空列表；P5 再补真实实现（用 pgVectorJdbcTemplate 走 GIN 索引 + plainto_tsquery）。
 */
@Component
@RequiredArgsConstructor
public class FullTextRetriever implements Retriever {

    private static final Logger log = LoggerFactory.getLogger(FullTextRetriever.class);

    @Override
    public List<ScoredDoc> retrieve(String query, List<String> categories, int topK) {
        log.debug("全文路未启用（P5 实现），返回空");
        return List.of();
    }
}
