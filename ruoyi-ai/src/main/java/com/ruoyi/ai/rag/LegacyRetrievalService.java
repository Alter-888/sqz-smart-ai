package com.ruoyi.ai.rag;

import com.ruoyi.ai.config.SmartCsProperties;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.stereotype.Component;

import java.util.List;

/**
 * 改造前（P5 之前）的检索实现：只走向量路 + 直通重排，无全文路 / RRF 融合。
 * 用于离线评测跑基线（smart-cs.eval.legacy-retrieval=true），与 HybridRagRetrievalService 互斥。
 */
@Component
@ConditionalOnProperty(name = "smart-cs.eval.legacy-retrieval", havingValue = "true")
@RequiredArgsConstructor
public class LegacyRetrievalService implements RagRetrievalService {

    private static final Logger log = LoggerFactory.getLogger(LegacyRetrievalService.class);

    private final VectorRetriever vectorRetriever;
    private final Reranker reranker;
    private final SmartCsProperties props;

    @Override
    public List<ScoredDoc> retrieve(String query, List<String> categories, int topK) {
        // 改造前：只向量路召回，再直通重排截断。
        List<ScoredDoc> vector = vectorRetriever.retrieve(query, categories, props.getRag().getVectorTopK());
        List<ScoredDoc> result = reranker.rerank(query, vector, topK);
        log.debug("基线检索 - query 长度: {}, categories: {}, 命中: {}", query.length(), categories, result.size());
        return result;
    }
}
