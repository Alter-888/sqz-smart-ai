package com.ruoyi.ai.rag;

import com.ruoyi.ai.config.SmartCsProperties;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 默认检索实现：向量路（→ 全文路 → RRF）→ 重排 → 截断。
 * P2~P4 阶段 fullTextEnabled=false，只走向量路 + 直通重排。
 */
@Service
@ConditionalOnProperty(name = "smart-cs.eval.legacy-retrieval", havingValue = "false", matchIfMissing = true)
@RequiredArgsConstructor
public class HybridRagRetrievalService implements RagRetrievalService {

    private static final Logger log = LoggerFactory.getLogger(HybridRagRetrievalService.class);

    private final VectorRetriever vectorRetriever;
    private final FullTextRetriever fullTextRetriever;
    private final Reranker reranker;
    private final SmartCsProperties props;

    @Override
    public List<ScoredDoc> retrieve(String query, List<String> categories, int topK) {
        SmartCsProperties.Rag cfg = props.getRag();
        List<ScoredDoc> vector = vectorRetriever.retrieve(query, categories, cfg.getVectorTopK());
        if (!cfg.isFullTextEnabled()) {
            return reranker.rerank(query, vector, topK);
        }
        List<ScoredDoc> fullText = fullTextRetriever.retrieve(query, categories, cfg.getFullTextTopK());
        List<ScoredDoc> fused = RrfFusion.fuse(List.of(vector, fullText), cfg.getRrfK(), cfg.getFusionTopK());
        log.info("混合检索 - 向量: {}, 全文: {}, 融合后: {}", vector.size(), fullText.size(), fused.size());
        return reranker.rerank(query, fused, topK);
    }
}
