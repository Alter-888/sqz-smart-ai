package com.ruoyi.ai.it;

import com.ruoyi.ai.rag.FullTextRetriever;
import com.ruoyi.ai.rag.ScoredDoc;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.datasource.DriverManagerDataSource;
import org.testcontainers.containers.PostgreSQLContainer;
import org.testcontainers.junit.jupiter.Container;
import org.testcontainers.junit.jupiter.Testcontainers;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

/**
 * P5 集成测试：验证全文路真实走 GIN 索引 + 参数绑定 + 降级（07 §7.2）。
 *
 * 用 Testcontainers 起一个 pgvector/pgvector:pg16 临时 PG，手动建与真实库一致的 vector_store 表
 * （id text / content text / metadata json / embedding vector(1024)）和 GIN 全文索引，
 * 然后直接 new FullTextRetriever(jdbcTemplate) 验证：
 *  - 英文型号（Pro）能命中，且 ts_rank 排序正确
 *  - EXPLAIN 在关闭 seqscan 后走 idx_vector_store_content_fts（证明索引表达式匹配）
 *  - 注入串（RK87'; DROP TABLE...）不报错、表还在（验证参数绑定）
 *  - 空串 / 纯符号不抛异常、返回空列表（降级兜底）
 */
@Testcontainers
class FullTextRetrieverIT {

    @Container
    static PostgreSQLContainer<?> postgres = new PostgreSQLContainer<>("pgvector/pgvector:pg16")
            .withDatabaseName("ai_vector")
            .withUsername("vector")
            .withPassword("pg123456");

    private JdbcTemplate jdbcTemplate;
    private FullTextRetriever retriever;

    @BeforeEach
    void setUp() {
        DriverManagerDataSource ds = new DriverManagerDataSource(
                postgres.getJdbcUrl(), postgres.getUsername(), postgres.getPassword());
        jdbcTemplate = new JdbcTemplate(ds);
        retriever = new FullTextRetriever(jdbcTemplate);

        // 建表 + GIN 索引（与真实库、与 FullTextRetriever 的 WHERE 表达式一字不差）
        jdbcTemplate.execute("CREATE EXTENSION IF NOT EXISTS vector");
        jdbcTemplate.execute("DROP TABLE IF EXISTS public.vector_store");
        jdbcTemplate.execute("""
                CREATE TABLE public.vector_store (
                    id text PRIMARY KEY,
                    content text NOT NULL,
                    metadata json,
                    embedding vector(1024)
                )""");
        jdbcTemplate.execute("""
                CREATE INDEX IF NOT EXISTS idx_vector_store_content_fts
                ON public.vector_store USING GIN (to_tsvector('simple', content))""");

        jdbcTemplate.update("INSERT INTO public.vector_store (id, content, metadata) VALUES (?,?,?::json)",
                "knowledge_1_c0", "Apple iPad Pro 11英寸 M4 256GB WiFi",
                "{\"category\":\"PRODUCT_INFO\",\"title\":\"iPad Pro\"}");
        jdbcTemplate.update("INSERT INTO public.vector_store (id, content, metadata) VALUES (?,?,?::json)",
                "knowledge_2_c0", "订单 ORD20250001 已发货，预计明日送达",
                "{\"category\":\"ORDER\",\"title\":\"订单信息\"}");
        jdbcTemplate.update("INSERT INTO public.vector_store (id, content, metadata) VALUES (?,?,?::json)",
                "knowledge_3_c0", "支持七天无理由退货",
                "{\"category\":\"POLICY\",\"title\":\"退货政策\"}");
    }

    @Test
    void englishModelHits_andRankOrdered() {
        List<ScoredDoc> hits = retriever.retrieve("Pro", List.of("PRODUCT_INFO"), 5);
        assertThat(hits).isNotEmpty();
        // 第一条应是 iPad Pro 那条，且 category 过滤生效（不会召回 ORDER / POLICY）
        assertThat(hits.get(0).metadata().get("title")).isEqualTo("iPad Pro");
    }

    @Test
    void explain_showsIndexWhenSeqscanDisabled() {
        String plan = explainWithIndex("""
                SELECT id FROM public.vector_store
                 WHERE to_tsvector('simple', content) @@ plainto_tsquery('simple', 'Pro')""");
        assertThat(plan).contains("idx_vector_store_content_fts");
    }

    @Test
    void injectionInput_isBound_notExecuted() {
        // 注入串当作普通文本，plainto_tsquery 不会当查询算符，且参数绑定不拼 SQL
        String evil = "RK87'; DROP TABLE vector_store; --";
        List<ScoredDoc> hits = retriever.retrieve(evil, null, 5);
        assertThat(hits).isNotNull();
        // 表还在：说明没被注入 DROP 掉
        Long count = jdbcTemplate.queryForObject("SELECT count(*) FROM public.vector_store", Long.class);
        assertThat(count).isEqualTo(3L);
    }

    @Test
    void emptyAndSymbolQuery_returnsEmptyNotThrow() {
        assertThat(retriever.retrieve("", null, 5)).isEmpty();
        assertThat(retriever.retrieve("&&&", null, 5)).isEmpty();
    }

    /** 在同一个连接上关闭 seqscan 后执行 EXPLAIN，断言计划里出现 GIN 索引名 */
    private String explainWithIndex(String sql) {
        try (Connection conn = DriverManager.getConnection(
                postgres.getJdbcUrl(), postgres.getUsername(), postgres.getPassword());
             Statement st = conn.createStatement()) {
            st.execute("set enable_seqscan = off");
            StringBuilder sb = new StringBuilder();
            try (ResultSet rs = st.executeQuery("EXPLAIN (COSTS OFF) " + sql)) {
                while (rs.next()) {
                    sb.append(rs.getString(1)).append('\n');
                }
            } finally {
                st.execute("set enable_seqscan = on");
            }
            return sb.toString();
        } catch (SQLException e) {
            throw new IllegalStateException("EXPLAIN 失败", e);
        }
    }
}


