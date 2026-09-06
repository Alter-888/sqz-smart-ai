package com.ruoyi.ai.rag;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;

/**
 * 全文路：PG tsvector 精确命中（RK87、ORD20250001、iPhone 16 Pro 这类型号/单号/英文词）。
 *
 * 关键约定：
 * 1) 必须用 {@code pgVectorJdbcTemplate}（指向 PG 向量库），**不要**用默认 JdbcTemplate（那是 @Primary 的 MySQL）。
 * 2) {@code WHERE to_tsvector('simple', content) @@ plainto_tsquery('simple', ?)} 必须和 GIN 索引定义
 *    （sql/2026-09-06_sqz_向量库全文检索与元数据索引.sql 的 idx_vector_store_content_fts）一字不差，
 *    否则索引不会被用到、退化成全表扫。
 * 3) 用 plainto_tsquery 而不是 to_tsquery：把用户输入当普通文本，& | ! 等符号不会当查询算符，免疫语法注入。
 * 4) 中文基本不命中是设计使然（simple 配置对连续汉字不分词），中文语义交给向量路，这一路专门补型号/单号精确命中。
 * 5) 降级：全文路异常时返回空列表，不能让这一路拖垮整轮对话。
 */
@Component
@RequiredArgsConstructor
public class FullTextRetriever implements Retriever {

    private static final Logger log = LoggerFactory.getLogger(FullTextRetriever.class);
    private static final ObjectMapper MAPPER = new ObjectMapper();

    @Qualifier("pgVectorJdbcTemplate")
    private final JdbcTemplate pgJdbc;

    @Override
    public List<ScoredDoc> retrieve(String query, List<String> categories, int topK) {
        // category 用占位符逐个绑定，绝不字符串拼接；categories 为空则不过滤
        String inClause = categories == null || categories.isEmpty() ? ""
                : " AND metadata::jsonb ->> 'category' IN ("
                  + String.join(",", Collections.nCopies(categories.size(), "?")) + ")";

        String sql = "SELECT id, content, metadata::text AS metadata_json, "
                + "       ts_rank(to_tsvector('simple', content), plainto_tsquery('simple', ?)) AS rank "
                + "  FROM public.vector_store "
                + " WHERE to_tsvector('simple', content) @@ plainto_tsquery('simple', ?)"
                + inClause
                + " ORDER BY rank DESC "
                + " LIMIT ?";

        List<Object> args = new ArrayList<>();
        args.add(query);                 // ts_rank 的 tsquery
        args.add(query);                 // WHERE 的 tsquery
        if (categories != null) {
            args.addAll(categories);
        }
        args.add(topK);

        try {
            List<ScoredDoc> hits = pgJdbc.query(sql, args.toArray(), (rs, i) -> new ScoredDoc(
                    rs.getString("id"), rs.getString("content"),
                    parseMetadata(rs.getString("metadata_json")), rs.getDouble("rank")));
            log.debug("全文路召回 - categories: {}, 命中: {}", categories, hits.size());
            return hits;
        } catch (Exception e) {
            // 降级：全文路挂了就只用向量路，不能让它拖垮整轮对话
            log.warn("全文检索失败，本轮只用向量路: {}", e.getMessage());
            return List.of();
        }
    }

    /** 把 vector_store.metadata::text 的 JSON 字符串解析成 Map，解析失败返回空 Map（不阻断检索） */
    private static Map<String, Object> parseMetadata(String metadataJson) {
        if (metadataJson == null || metadataJson.isBlank()) {
            return Map.of();
        }
        try {
            return MAPPER.readValue(metadataJson, new TypeReference<Map<String, Object>>() {});
        } catch (Exception e) {
            log.warn("metadata 解析失败，忽略该块 metadata: {}", e.getMessage());
            return Map.of();
        }
    }
}
