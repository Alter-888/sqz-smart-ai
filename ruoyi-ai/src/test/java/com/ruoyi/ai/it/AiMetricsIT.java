package com.ruoyi.ai.it;

import com.ruoyi.ai.controller.DashboardController;
import com.ruoyi.common.core.domain.AjaxResult;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.datasource.DriverManagerDataSource;
import org.testcontainers.containers.MySQLContainer;
import org.testcontainers.junit.jupiter.Container;
import org.testcontainers.junit.jupiter.Testcontainers;

import java.util.Map;

import static org.assertj.core.api.Assertions.assertThat;

/**
 * P3 集成测试：验证 DashboardController.getAiMetrics 新增的 4 个在线指标（07 §5.2）。
 *
 * 用 Testcontainers 起一个 mysql:8 临时库，手动建与真实库一致的 4 张表，插入固定审计数据，
 * 直接 new DashboardController(jdbcTemplate) 验证：
 *  - failureRate / retryRate / timeoutRate / p95Latency 等于手算值（PERCENT_RANK 窗口函数边界）
 *  - RAG 命中率新口径：分母只算 rag_enabled=1，rag_enabled=0 的命中行不拉低命中率
 *  - routeRuleCoverageRate / routeSourceIntentDist 与手工分布一致
 *  - 空数据集不返回 NaN/Infinity/不抛除零
 *  - user_id=-1 的评测流量被排除，不污染在线指标
 */
@Testcontainers
class AiMetricsIT {

    @Container
    static MySQLContainer<?> mysql = new MySQLContainer<>("mysql:8.0")
            .withDatabaseName("sqz_smart_ai_test")
            .withUsername("root")
            .withPassword("test");

    private JdbcTemplate jdbcTemplate;
    private DashboardController controller;

    @BeforeEach
    void setUp() {
        DriverManagerDataSource ds = new DriverManagerDataSource(
                mysql.getJdbcUrl(), mysql.getUsername(), mysql.getPassword());
        jdbcTemplate = new JdbcTemplate(ds);
        controller = new DashboardController(jdbcTemplate);
        createTables();
    }

    @Test
    void rateMetrics_matchHandCalculatedValues() {
        insertOnlineAuditRows();
        insertSupportingRows(false);

        Map<String, Object> data = fetchMetrics();

        assertThat(num(data, "failureRate")).isEqualTo(40.0);
        assertThat(num(data, "retryRate")).isEqualTo(30.0);
        assertThat(num(data, "timeoutRate")).isEqualTo(20.0);
        assertThat(num(data, "p95Latency")).isEqualTo(900.0);
        // RAG 命中率：rag_enabled=1 的 6 行中命中 3 行（50%）；rag_enabled=0 的命中行不进分母
        assertThat(num(data, "ragHitRate")).isEqualTo(50.0);
        assertThat(data.get("ragHitRateScope")).isNotNull();
        // 规则路由覆盖率：10 行中 rule 6 行
        assertThat(num(data, "routeRuleCoverageRate")).isEqualTo(60.0);
        assertThat((java.util.List<?>) data.get("routeSourceIntentDist")).isNotEmpty();
    }

    @Test
    void evalTraffic_userMinusOne_isExcluded() {
        insertOnlineAuditRows();
        insertSupportingRows(true);

        Map<String, Object> data = fetchMetrics();

        // 评测用户再插 2 行失败数据：若未排除，failureRate 会变成 6/12=50
        assertThat(num(data, "failureRate")).isEqualTo(40.0);
        assertThat(num(data, "retryRate")).isEqualTo(30.0);
        assertThat(num(data, "timeoutRate")).isEqualTo(20.0);
        assertThat(num(data, "p95Latency")).isEqualTo(900.0);
    }

    @Test
    void emptyTables_returnZeroNotNaNOrThrow() {
        Map<String, Object> data = fetchMetrics();

        assertThat(num(data, "failureRate")).isEqualTo(0.0);
        assertThat(num(data, "retryRate")).isEqualTo(0.0);
        assertThat(num(data, "timeoutRate")).isEqualTo(0.0);
        assertThat(num(data, "p95Latency")).isEqualTo(0.0);
        assertThat(num(data, "ragHitRate")).isEqualTo(0.0);
        assertThat(num(data, "routeRuleCoverageRate")).isEqualTo(0.0);
        // 兜底不允许出现 NaN / Infinity
        for (Object v : data.values()) {
            if (v instanceof Number n) {
                assertThat(n.doubleValue()).isNotNaN().isNotInfinite();
            }
        }
    }

    // ============ 工具方法 ============

    private Map<String, Object> fetchMetrics() {
        AjaxResult result = controller.getAiMetrics(7);
        @SuppressWarnings("unchecked")
        Map<String, Object> data = (Map<String, Object>) result.get("data");
        assertThat(data).isNotNull();
        return data;
    }

    private double num(Map<String, Object> data, String key) {
        Object v = data.get(key);
        assertThat(v).as(key + " 不应为 null").isNotNull();
        return ((Number) v).doubleValue();
    }

    private void createTables() {
        // @BeforeEach 每个用例都重建，保证互不污染
        for (String t : new String[]{"ai_chat_turn_audit", "ai_tool_call_log", "ai_chat_message", "ai_chat_session"}) {
            jdbcTemplate.execute("DROP TABLE IF EXISTS " + t);
        }
        jdbcTemplate.execute("""
                CREATE TABLE ai_chat_session (
                  session_id BIGINT PRIMARY KEY AUTO_INCREMENT,
                  user_id BIGINT NOT NULL,
                  create_time DATETIME DEFAULT CURRENT_TIMESTAMP
                )""");
        jdbcTemplate.execute("""
                CREATE TABLE ai_chat_message (
                  message_id BIGINT PRIMARY KEY AUTO_INCREMENT,
                  session_id BIGINT NOT NULL,
                  role VARCHAR(20),
                  content TEXT,
                  feedback TINYINT,
                  create_time DATETIME DEFAULT CURRENT_TIMESTAMP
                )""");
        jdbcTemplate.execute("""
                CREATE TABLE ai_tool_call_log (
                  log_id BIGINT PRIMARY KEY AUTO_INCREMENT,
                  session_id BIGINT,
                  tool_name VARCHAR(100),
                  success_flag TINYINT DEFAULT 1,
                  create_time DATETIME DEFAULT CURRENT_TIMESTAMP
                )""");
        jdbcTemplate.execute("""
                CREATE TABLE ai_chat_turn_audit (
                  audit_id BIGINT PRIMARY KEY AUTO_INCREMENT,
                  session_id BIGINT,
                  user_id BIGINT,
                  user_message TEXT,
                  ai_response TEXT,
                  rag_source JSON,
                  tool_calls JSON,
                  duration_ms BIGINT,
                  has_rag_hit TINYINT DEFAULT 0,
                  create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
                  intent VARCHAR(32),
                  agent_id VARCHAR(64),
                  route_source VARCHAR(16),
                  rag_enabled TINYINT DEFAULT 0,
                  retry_count INT DEFAULT 0,
                  failure_count INT DEFAULT 0,
                  is_timeout TINYINT DEFAULT 0
                )""");
    }

    /**
     * 10 行在线审计数据（user_id=1），手算口径：
     * 失败 4 行(1-4)、超时 2 行(1,4)、重试 3 行(5,6,7)、duration 100~1000 → p95=900；
     * rag_enabled=1 共 6 行(1-6) 命中 3 行(1,2,4) → 50%；route=rule 6 行 → 60%。
     */
    private void insertOnlineAuditRows() {
        jdbcTemplate.update("""
                INSERT INTO ai_chat_turn_audit
                  (session_id, user_id, duration_ms, has_rag_hit, intent, agent_id, route_source,
                   rag_enabled, retry_count, failure_count, is_timeout)
                VALUES (1, 1, 100, 1, 'PRODUCT', 'sales-advisor', 'rule', 1, 0, 1, 1),
                       (1, 1, 200, 1, 'ORDER', 'order-service', 'rule', 1, 0, 1, 0),
                       (1, 1, 300, 0, 'AFTERSALES', 'after-sales', 'rule', 1, 0, 1, 0),
                       (1, 1, 400, 1, 'ACCOUNT', 'account', 'rule', 1, 0, 1, 1),
                       (1, 1, 500, 0, 'KNOWLEDGE', 'knowledge', 'llm', 1, 2, 0, 0),
                       (1, 1, 600, 0, 'PRODUCT', 'sales-advisor', 'llm', 1, 1, 0, 0),
                       (1, 1, 700, 1, 'ORDER', 'order-service', 'llm', 0, 1, 0, 0),
                       (1, 1, 800, 1, 'CHITCHAT', NULL, 'fallback', 0, 0, 0, 0),
                       (1, 1, 900, 0, 'PRODUCT', 'sales-advisor', 'rule', 0, 0, 0, 0),
                       (1, 1, 1000, 0, 'KNOWLEDGE', 'knowledge', 'rule', 0, 0, 0, 0)""");
    }

    /**
     * 支撑表数据：session 归属 + message/tool_call。
     * evalTraffic=true 时额外插 user_id=-1 的会话、2 行失败审计、1 行失败工具日志，
     * 用于验证评测流量在所有指标口径里都被排除。
     */
    private void insertSupportingRows(boolean withEvalTraffic) {
        jdbcTemplate.update("INSERT INTO ai_chat_session (session_id, user_id) VALUES (1, 1)");
        jdbcTemplate.update("""
                INSERT INTO ai_chat_message (session_id, role, content, feedback)
                VALUES (1, 'user', '你好', NULL),
                       (1, 'assistant', '您好', 1)""");
        jdbcTemplate.update("""
                INSERT INTO ai_tool_call_log (session_id, tool_name, success_flag)
                VALUES (1, 'searchProducts', 1)""");
        if (withEvalTraffic) {
            jdbcTemplate.update("INSERT INTO ai_chat_session (session_id, user_id) VALUES (2, -1)");
            jdbcTemplate.update("""
                    INSERT INTO ai_chat_turn_audit
                      (session_id, user_id, duration_ms, has_rag_hit, intent, agent_id, route_source,
                       rag_enabled, retry_count, failure_count, is_timeout)
                    VALUES (2, -1, 50, 0, 'PRODUCT', 'sales-advisor', 'rule', 1, 1, 1, 1),
                           (2, -1, 60, 0, 'ORDER', 'order-service', 'rule', 1, 0, 1, 0)""");
            jdbcTemplate.update("""
                    INSERT INTO ai_tool_call_log (session_id, tool_name, success_flag)
                    VALUES (2, 'cancelOrder', 0)""");
        }
    }
}