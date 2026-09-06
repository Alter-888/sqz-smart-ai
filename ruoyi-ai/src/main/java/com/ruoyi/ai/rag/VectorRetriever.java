package com.ruoyi.ai.rag;

import com.ruoyi.ai.config.SmartCsProperties;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.ai.document.Document;
import org.springframework.ai.vectorstore.SearchRequest;
import org.springframework.ai.vectorstore.VectorStore;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.stream.Collectors;

/**
 * 向量路：pgvector HNSW 相似度召回，支持 category 元数据过滤。
 */
@Component
@RequiredArgsConstructor
public class VectorRetriever implements Retriever {

    private static final Logger log = LoggerFactory.getLogger(VectorRetriever.class);

    private final VectorStore vectorStore;
    private final SmartCsProperties props;

    @Override
    public List<ScoredDoc> retrieve(String query, List<String> categories, int topK) {
        SearchRequest.Builder req = SearchRequest.builder()
                .query(query)
                .topK(topK)
                .similarityThreshold(props.getRag().getSimilarityThreshold());
        String filter = toFilterExpression(categories);
        if (filter != null) {
            req.filterExpression(filter);
        }
        List<Document> docs = vectorStore.similaritySearch(req.build());
        if (docs == null) {
            return List.of();
        }
        log.debug("向量路召回 - query 长度: {}, categories: {}, 命中: {}", query.length(), categories, docs.size());
        return docs.stream()
                .map(d -> new ScoredDoc(d.getId(), d.getText(), d.getMetadata(),
                        d.getScore() == null ? 0d : d.getScore()))
                .collect(Collectors.toList());
    }

    /**
     * 只用枚举里写死的类别常量拼表达式，用户输入永远不参与拼接。
     * 结果形如：category in ['POLICY','FAQ','GUIDE']
     */
    static String toFilterExpression(List<String> categories) {
        if (categories == null || categories.isEmpty()) {
            return null;
        }
        String in = categories.stream()
                .map(c -> "'" + c + "'")
                .collect(Collectors.joining(","));
        return "category in [" + in + "]";
    }
}
