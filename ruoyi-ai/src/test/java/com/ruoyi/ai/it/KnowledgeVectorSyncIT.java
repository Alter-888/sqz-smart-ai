package com.ruoyi.ai.it;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.ai.document.Document;
import org.springframework.ai.embedding.BatchingStrategy;
import org.springframework.ai.embedding.Embedding;
import org.springframework.ai.embedding.EmbeddingModel;
import org.springframework.ai.embedding.EmbeddingOptions;
import org.springframework.ai.embedding.EmbeddingRequest;
import org.springframework.ai.embedding.EmbeddingResponse;
import org.springframework.ai.vectorstore.SearchRequest;
import org.springframework.ai.vectorstore.VectorStore;
import org.springframework.ai.vectorstore.pgvector.PgVectorStore;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.datasource.DriverManagerDataSource;
import org.testcontainers.containers.PostgreSQLContainer;
import org.testcontainers.junit.jupiter.Container;
import org.testcontainers.junit.jupiter.Testcontainers;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import static org.assertj.core.api.Assertions.assertThat;

/**
 * P1 集成测试：验证 PgVectorStore 真实落库行为（07 §3.2）。
 *
 * 使用 Testcontainers 起一个 pgvector/pgvector:pg16 的临时 PG，配合 StubEmbeddingModel
 * （固定 1024 维，不调外部 API），验证：
 *  - 存知识后出现 knowledge_{id}_c{n} 分块
 *  - metadata 的每个 value 运行时都是 String（pgvector jsonb 约定）
 *  - 同 id 覆盖（upsert，行数不变、content 更新）
 *  - filter 删除按 knowledgeId 清空所有分块
 *  - 相似度检索能查回分块
 */
@Testcontainers
class KnowledgeVectorSyncIT {

    private static final int DIM = 1024;

    @Container
    static PostgreSQLContainer<?> postgres = new PostgreSQLContainer<>("pgvector/pgvector:pg16")
            .withDatabaseName("ai_vector")
            .withUsername("vector")
            .withPassword("pg123456");

    private JdbcTemplate jdbcTemplate;
    private VectorStore vectorStore;

    @BeforeEach
    void setUp() throws Exception {
        DriverManagerDataSource ds = new DriverManagerDataSource(
                postgres.getJdbcUrl(), postgres.getUsername(), postgres.getPassword());
        jdbcTemplate = new JdbcTemplate(ds);
        EmbeddingModel em = new StubEmbeddingModel(DIM);
        vectorStore = PgVectorStore.builder(jdbcTemplate, em)
                .schemaName("public")
                .vectorTableName("vector_store")
                .idType(PgVectorStore.PgIdType.TEXT)
                .dimensions(DIM)
                .distanceType(PgVectorStore.PgDistanceType.COSINE_DISTANCE)
                .indexType(PgVectorStore.PgIndexType.HNSW)
                .initializeSchema(true)
                .build();
        // PgVectorStore 手动 build() 不触发 InitializingBean.afterPropertiesSet，
        // 需显式调用以创建 vector 扩展与表（后续 DELETE / 断言依赖表已存在）
        ((org.springframework.beans.factory.InitializingBean) vectorStore).afterPropertiesSet();
        jdbcTemplate.update("DELETE FROM public.vector_store");
    }

    @Test
    void addKnowledge_producesKnowledgeChunk() {
        vectorStore.add(List.of(new Document(
                "knowledge_1_c0",
                "iPhone 支持全天候显示和灵动岛",
                Map.of("knowledgeId", "1", "chunkIndex", "0"))));
        assertThat(jdbcTemplate.queryForObject("SELECT count(*) FROM public.vector_store", Long.class)).isEqualTo(1L);
        String id = jdbcTemplate.queryForObject("SELECT id FROM public.vector_store", String.class);
        assertThat(id).isEqualTo("knowledge_1_c0");
    }

    @Test
    void metadata_allValuesAreString() {
        vectorStore.add(List.of(new Document(
                "knowledge_2_c0",
                "7 天无理由退货说明",
                Map.of(
                        "knowledgeId", "2",
                        "category", "POLICY",
                        "title", "退货政策",
                        "sourceType", "MANUAL",
                        "sourceId", "",
                        "productCategory", "",
                        "chunkIndex", "0"))));
        for (String key : new String[]{"knowledgeId", "category", "title", "sourceType", "sourceId", "productCategory", "chunkIndex"}) {
            String t = jdbcTemplate.queryForObject(
                    "SELECT jsonb_typeof(metadata::jsonb -> '" + key + "') FROM public.vector_store WHERE id='knowledge_2_c0'",
                    String.class);
            assertThat(t).as("metadata[%s] 应为 string", key).isEqualTo("string");
        }
    }

    @Test
    void update_sameId_contentReplaced() {
        vectorStore.add(List.of(new Document("knowledge_3_c0", "旧内容", Map.of("knowledgeId", "3", "chunkIndex", "0"))));
        vectorStore.add(List.of(new Document("knowledge_3_c0", "新内容", Map.of("knowledgeId", "3", "chunkIndex", "0"))));
        assertThat(jdbcTemplate.queryForObject("SELECT count(*) FROM public.vector_store", Long.class)).isEqualTo(1L);
        String content = jdbcTemplate.queryForObject(
                "SELECT content FROM public.vector_store WHERE id='knowledge_3_c0'", String.class);
        assertThat(content).isEqualTo("新内容");
    }

    @Test
    void delete_removesAllChunksForKnowledgeId() {
        vectorStore.add(List.of(
                new Document("knowledge_4_c0", "块0", Map.of("knowledgeId", "4", "chunkIndex", "0")),
                new Document("knowledge_4_c1", "块1", Map.of("knowledgeId", "4", "chunkIndex", "1"))));
        assertThat(jdbcTemplate.queryForObject("SELECT count(*) FROM public.vector_store", Long.class)).isEqualTo(2L);
        vectorStore.delete("knowledgeId == '4'");
        assertThat(jdbcTemplate.queryForObject("SELECT count(*) FROM public.vector_store", Long.class)).isEqualTo(0L);
    }

    @Test
    void similaritySearch_returnsChunk() {
        vectorStore.add(List.of(new Document("knowledge_5_c0", "退换货政策", Map.of("knowledgeId", "5", "chunkIndex", "0"))));
        List<Document> hits = vectorStore.similaritySearch(
                SearchRequest.builder().query("退换货").topK(5).build());
        assertThat(hits).isNotEmpty();
    }

    /**
     * 固定维度的 stub embedding：首分量 1.0 保证非零向量，次分量由文本 hashCode 决定，
     * 使不同文本有区分度。覆盖 PgVectorStore 实际会调用的所有 embed 入口。
     */
    static class StubEmbeddingModel implements EmbeddingModel {
        private final int dim;

        StubEmbeddingModel(int dim) {
            this.dim = dim;
        }

        private float[] vec(String s) {
            float[] v = new float[dim];
            v[0] = 1.0f;
            v[1] = (float) ((s == null ? 0 : s.hashCode()) % 1000);
            return v;
        }

        @Override
        public float[] embed(String text) {
            return vec(text);
        }

        @Override
        public float[] embed(Document document) {
            return vec(document.getText());
        }

        @Override
        public List<float[]> embed(List<Document> documents, EmbeddingOptions options, BatchingStrategy strategy) {
            List<float[]> out = new ArrayList<>();
            for (Document d : documents) {
                out.add(vec(d.getText()));
            }
            return out;
        }

        @Override
        public List<float[]> embed(List<String> texts) {
            List<float[]> out = new ArrayList<>();
            for (String t : texts) {
                out.add(vec(t));
            }
            return out;
        }

        @Override
        public EmbeddingResponse call(EmbeddingRequest request) {
            List<Embedding> list = new ArrayList<>();
            int i = 0;
            for (String t : request.getInstructions()) {
                list.add(new Embedding(vec(t), i++));
            }
            return new EmbeddingResponse(list);
        }

        @Override
        public int dimensions() {
            return dim;
        }
    }
}
