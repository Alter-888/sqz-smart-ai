package com.ruoyi.ai.rag;

import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.stereotype.Component;

import java.util.List;

/**
 * 默认重排器：不重排，只截断。smart-cs.rag.rerank.enabled=false（或未配置）时生效。
 * 重排不可用/未开启时，检索链路必须能用它兜底，绝不能因重排失败让整轮检索失败。
 */
@Component
@ConditionalOnProperty(name = "smart-cs.rag.rerank.enabled", havingValue = "false", matchIfMissing = true)
public class PassThroughReranker implements Reranker {

    @Override
    public List<ScoredDoc> rerank(String query, List<ScoredDoc> candidates, int topK) {
        if (candidates == null || candidates.isEmpty()) {
            return List.of();
        }
        return candidates.size() <= topK ? candidates : candidates.subList(0, topK);
    }
}
