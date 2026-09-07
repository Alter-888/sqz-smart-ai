package com.ruoyi.ai.controller;

import com.ruoyi.common.core.domain.AjaxResult;
import lombok.RequiredArgsConstructor;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/ai/dashboard")
@RequiredArgsConstructor
public class DashboardController {

    private final JdbcTemplate jdbcTemplate;

    @GetMapping("/stats")
    @PreAuthorize("@ss.hasPermi('ai:dashboard:list')")
    public AjaxResult getStats(@RequestParam(defaultValue = "7") int days) {
        days = normalizeDays(days);
        String messageTimeCondition = withinDaysCondition("create_time", days);
        String sessionTimeCondition = withinDaysCondition("create_time", days);
        String knowledgeTimeCondition = withinDaysCondition("create_time", days);
        String orderTimeCondition = withinDaysCondition("create_time", days);
        String ticketTimeCondition = withinDaysCondition("create_time", days);

        Map<String, Object> stats = new HashMap<>();
        stats.put("totalUsers", queryLong("SELECT COUNT(*) FROM sys_user"));
        stats.put("totalSessions", queryLong("SELECT COUNT(*) FROM ai_chat_session WHERE " + sessionTimeCondition));
        stats.put("totalMessages", queryLong("SELECT COUNT(*) FROM ai_chat_message WHERE " + messageTimeCondition));
        stats.put("totalKnowledge", queryLong("SELECT COUNT(*) FROM ai_knowledge WHERE " + knowledgeTimeCondition));
        stats.put("totalOrders", queryLong("SELECT COUNT(*) FROM biz_order WHERE " + orderTimeCondition));
        stats.put("totalTickets", queryLong("SELECT COUNT(*) FROM biz_ticket WHERE " + ticketTimeCondition));

        try {
            Double avgTurns = jdbcTemplate.queryForObject(
                    "SELECT ROUND(AVG(msg_count), 1) FROM (" +
                    "  SELECT session_id, COUNT(*) as msg_count FROM ai_chat_message " +
                    "  WHERE role = 'user' AND " + messageTimeCondition +
                    "  GROUP BY session_id" +
                    ") t", Double.class);
            stats.put("avgTurns", avgTurns != null ? avgTurns : 0);
        } catch (Exception e) {
            stats.put("avgTurns", 0);
        }

        try {
            Map<String, Object> feedbackStats = jdbcTemplate.queryForMap(
                    "SELECT " +
                    "  COUNT(CASE WHEN feedback = 1 THEN 1 END) as satisfied, " +
                    "  COUNT(CASE WHEN feedback = 0 THEN 1 END) as unsatisfied, " +
                    "  COUNT(CASE WHEN feedback IS NOT NULL THEN 1 END) as totalFeedback " +
                    "FROM ai_chat_message " +
                    "WHERE role = 'assistant' AND " + messageTimeCondition
            );
            stats.put("feedbackStats", feedbackStats);
        } catch (Exception e) {
            stats.put("feedbackStats", Map.of("satisfied", 0, "unsatisfied", 0, "totalFeedback", 0));
        }

        return AjaxResult.success(stats);
    }

    /**
     * 获取图表趋势数据（支持动态天数范围）
     */
    @GetMapping("/trends")
    @PreAuthorize("@ss.hasPermi('ai:dashboard:list')")
    public AjaxResult getTrends(@RequestParam(defaultValue = "7") int days) {
        days = normalizeDays(days);
        String messageTimeCondition = withinDaysCondition("create_time", days);
        String sessionTimeCondition = withinDaysCondition("create_time", days);
        String knowledgeTimeCondition = withinDaysCondition("create_time", days);
        String orderTimeCondition = withinDaysCondition("create_time", days);
        String ticketTimeCondition = withinDaysCondition("create_time", days);
        String toolCallTimeCondition = withinDaysCondition("create_time", days);

        Map<String, Object> trends = new HashMap<>();

        List<Map<String, Object>> messageTrend = jdbcTemplate.queryForList(
                "SELECT DATE(create_time) as date, COUNT(*) as count " +
                "FROM ai_chat_message " +
                "WHERE " + messageTimeCondition + " " +
                "GROUP BY DATE(create_time) " +
                "ORDER BY date"
        );
        trends.put("messageTrend", messageTrend);

        List<Map<String, Object>> ticketTypeDistribution = jdbcTemplate.queryForList(
                "SELECT type, COUNT(*) as count " +
                "FROM biz_ticket " +
                "WHERE " + ticketTimeCondition + " " +
                "GROUP BY type"
        );
        trends.put("ticketTypeDistribution", ticketTypeDistribution);

        List<Map<String, Object>> ticketStatusDistribution = jdbcTemplate.queryForList(
                "SELECT status, COUNT(*) as count " +
                "FROM biz_ticket " +
                "WHERE " + ticketTimeCondition + " " +
                "GROUP BY status"
        );
        trends.put("ticketStatusDistribution", ticketStatusDistribution);

        List<Map<String, Object>> knowledgeDistribution = jdbcTemplate.queryForList(
                "SELECT category, COUNT(*) as count " +
                "FROM ai_knowledge " +
                "WHERE " + knowledgeTimeCondition + " " +
                "GROUP BY category"
        );
        trends.put("knowledgeDistribution", knowledgeDistribution);

        List<Map<String, Object>> sessionTrend = jdbcTemplate.queryForList(
                "SELECT DATE(create_time) as date, COUNT(*) as count " +
                "FROM ai_chat_session " +
                "WHERE " + sessionTimeCondition + " " +
                "  AND status = 1 " +
                "GROUP BY DATE(create_time) " +
                "ORDER BY date"
        );
        trends.put("sessionTrend", sessionTrend);

        List<Map<String, Object>> orderStatusDistribution = jdbcTemplate.queryForList(
                "SELECT status, COUNT(*) as count " +
                "FROM biz_order " +
                "WHERE " + orderTimeCondition + " " +
                "GROUP BY status"
        );
        trends.put("orderStatusDistribution", orderStatusDistribution);

        List<Map<String, Object>> toolCallStats = jdbcTemplate.queryForList(
                "SELECT tool_name as toolName, COUNT(*) as callCount " +
                "FROM ai_tool_call_log " +
                "WHERE " + toolCallTimeCondition + " " +
                "GROUP BY tool_name " +
                "ORDER BY callCount DESC"
        );
        trends.put("toolCallStats", toolCallStats);

        List<Map<String, Object>> hotQuestions = jdbcTemplate.queryForList(
                "SELECT LEFT(content, 50) as question, COUNT(*) as askCount " +
                "FROM ai_chat_message " +
                "WHERE role = 'user' " +
                "  AND " + messageTimeCondition + " " +
                "  AND LENGTH(content) > 5 " +
                "GROUP BY LEFT(content, 50) " +
                "ORDER BY askCount DESC " +
                "LIMIT 5"
        );
        trends.put("hotQuestions", hotQuestions);

        return AjaxResult.success(trends);
    }

    /**
     * 获取AI效果评测指标（5个汇总值 + 5个趋势，支持动态天数范围）
     */
    @GetMapping("/ai-metrics")
    @PreAuthorize("@ss.hasPermi('ai:dashboard:list')")
    public AjaxResult getAiMetrics(@RequestParam(defaultValue = "7") int days) {
        days = normalizeDays(days);
        String messageTimeCondition = withinDaysCondition("create_time", days);
        String auditTimeCondition = withinDaysCondition("create_time", days);
        String toolCallTimeCondition = withinDaysCondition("create_time", days);

        Map<String, Object> metrics = new HashMap<>();

        try {
            Double toolCallSuccessRate = jdbcTemplate.queryForObject(
                    "SELECT ROUND(" +
                    "  SUM(CASE WHEN success_flag = 1 THEN 1 ELSE 0 END) * 100.0 / NULLIF(COUNT(*), 0), 1" +
                    ") AS rate " +
                    "FROM ai_tool_call_log t " +
                    "JOIN ai_chat_session s ON s.session_id = t.session_id " +
                    "WHERE " + withinDaysCondition("t.create_time", days) + " AND s.user_id <> -1", Double.class);
            metrics.put("toolCallSuccessRate", toolCallSuccessRate != null ? toolCallSuccessRate : 0);
        } catch (Exception e) {
            metrics.put("toolCallSuccessRate", 0);
        }

        try {
            List<Map<String, Object>> toolCallSuccessTrend = jdbcTemplate.queryForList(
                    "SELECT DATE(t.create_time) AS date, " +
                    "  ROUND(SUM(CASE WHEN t.success_flag = 1 THEN 1 ELSE 0 END) * 100.0 / NULLIF(COUNT(*), 0), 1) AS rate " +
                    "FROM ai_tool_call_log t " +
                    "JOIN ai_chat_session s ON s.session_id = t.session_id " +
                    "WHERE " + withinDaysCondition("t.create_time", days) + " AND s.user_id <> -1 " +
                    "GROUP BY DATE(t.create_time) ORDER BY date");
            metrics.put("toolCallSuccessTrend", toolCallSuccessTrend);
        } catch (Exception e) {
            metrics.put("toolCallSuccessTrend", List.of());
        }

        try {
            Double ragHitRate = jdbcTemplate.queryForObject(
                    "SELECT ROUND(" +
                    "  SUM(CASE WHEN has_rag_hit = 1 THEN 1 ELSE 0 END) * 100.0 / NULLIF(COUNT(*), 0), 1" +
                    ") AS rate " +
                    "FROM ai_chat_turn_audit " +
                    "WHERE " + auditTimeCondition + " AND rag_enabled = 1 AND user_id <> -1", Double.class);
            metrics.put("ragHitRate", ragHitRate != null ? ragHitRate : 0);
            metrics.put("ragHitRateScope", "仅统计挂RAG(rag_enabled=1)轮次，已排除评测流量(user_id=-1)");
        } catch (Exception e) {
            metrics.put("ragHitRate", 0);
        }

        try {
            List<Map<String, Object>> ragHitTrend = jdbcTemplate.queryForList(
                    "SELECT DATE(create_time) AS date, " +
                    "  ROUND(SUM(CASE WHEN has_rag_hit = 1 THEN 1 ELSE 0 END) * 100.0 / NULLIF(COUNT(*), 0), 1) AS rate " +
                    "FROM ai_chat_turn_audit " +
                    "WHERE " + auditTimeCondition + " AND rag_enabled = 1 AND user_id <> -1 " +
                    "GROUP BY DATE(create_time) ORDER BY date");
            metrics.put("ragHitTrend", ragHitTrend);
        } catch (Exception e) {
            metrics.put("ragHitTrend", List.of());
        }

        try {
            Double satisfactionRate = jdbcTemplate.queryForObject(
                    "SELECT ROUND(" +
                    "  COUNT(CASE WHEN feedback = 1 THEN 1 END) * 100.0 " +
                    "    / NULLIF(COUNT(CASE WHEN feedback IS NOT NULL THEN 1 END), 0), 1" +
                    ") AS rate " +
                    "FROM ai_chat_message m " +
                    "JOIN ai_chat_session s ON s.session_id = m.session_id " +
                    "WHERE m.role = 'assistant' AND s.user_id <> -1 AND " + withinDaysCondition("m.create_time", days), Double.class);
            metrics.put("satisfactionRate", satisfactionRate != null ? satisfactionRate : 0);
        } catch (Exception e) {
            metrics.put("satisfactionRate", 0);
        }

        try {
            List<Map<String, Object>> satisfactionTrend = jdbcTemplate.queryForList(
                    "SELECT DATE(create_time) AS date, " +
                    "  ROUND(COUNT(CASE WHEN feedback = 1 THEN 1 END) * 100.0 " +
                    "    / NULLIF(COUNT(CASE WHEN feedback IS NOT NULL THEN 1 END), 0), 1) AS rate " +
                    "FROM ai_chat_message m " +
                    "JOIN ai_chat_session s ON s.session_id = m.session_id " +
                    "WHERE m.role = 'assistant' AND s.user_id <> -1 AND " + withinDaysCondition("m.create_time", days) + " AND m.feedback IS NOT NULL " +
                    "GROUP BY DATE(m.create_time) ORDER BY date");
            metrics.put("satisfactionTrend", satisfactionTrend);
        } catch (Exception e) {
            metrics.put("satisfactionTrend", List.of());
        }

        try {
            Double avgTurnsPerSession = jdbcTemplate.queryForObject(
                    "SELECT ROUND(AVG(msg_count), 1) AS avgTurns FROM (" +
                    "  SELECT m.session_id, COUNT(*) AS msg_count FROM ai_chat_message m " +
                    "  JOIN ai_chat_session s ON s.session_id = m.session_id " +
                    "  WHERE m.role = 'user' AND s.user_id <> -1 AND " + withinDaysCondition("m.create_time", days) +
                    "  GROUP BY session_id" +
                    ") t", Double.class);
            metrics.put("avgTurnsPerSession", avgTurnsPerSession != null ? avgTurnsPerSession : 0);
        } catch (Exception e) {
            metrics.put("avgTurnsPerSession", 0);
        }

        try {
            List<Map<String, Object>> avgTurnsTrend = jdbcTemplate.queryForList(
                    "SELECT dt AS date, ROUND(AVG(msg_count), 1) AS avgTurns FROM (" +
                    "  SELECT DATE(m.create_time) AS dt, m.session_id, COUNT(*) AS msg_count " +
                    "  FROM ai_chat_message m JOIN ai_chat_session s ON s.session_id = m.session_id " +
                    "  WHERE m.role = 'user' AND s.user_id <> -1 AND " + withinDaysCondition("m.create_time", days) +
                    "  GROUP BY DATE(create_time), session_id" +
                    ") t GROUP BY dt ORDER BY dt");
            metrics.put("avgTurnsTrend", avgTurnsTrend);
        } catch (Exception e) {
            metrics.put("avgTurnsTrend", List.of());
        }

        try {
            Double humanEscalationRate = jdbcTemplate.queryForObject(
                    "SELECT ROUND(" +
                    "  COUNT(DISTINCT CASE WHEN tool_name = 'escalateToHuman' THEN t.session_id END) * 100.0 " +
                    "    / NULLIF(COUNT(DISTINCT t.session_id), 0), 1" +
                    ") AS rate " +
                    "FROM ai_tool_call_log t " +
                    "JOIN ai_chat_session s ON s.session_id = t.session_id " +
                    "WHERE " + withinDaysCondition("t.create_time", days) + " AND s.user_id <> -1", Double.class);
            metrics.put("humanEscalationRate", humanEscalationRate != null ? humanEscalationRate : 0);
        } catch (Exception e) {
            metrics.put("humanEscalationRate", 0);
        }

        try {
            List<Map<String, Object>> humanEscalationTrend = jdbcTemplate.queryForList(
                    "SELECT DATE(t.create_time) AS date, " +
                    "  ROUND(COUNT(DISTINCT CASE WHEN t.tool_name = 'escalateToHuman' THEN t.session_id END) * 100.0 " +
                    "    / NULLIF(COUNT(DISTINCT t.session_id), 0), 1) AS rate " +
                    "FROM ai_tool_call_log t " +
                    "JOIN ai_chat_session s ON s.session_id = t.session_id " +
                    "WHERE " + withinDaysCondition("t.create_time", days) + " AND s.user_id <> -1 " +
                    "GROUP BY DATE(t.create_time) ORDER BY date");
            metrics.put("humanEscalationTrend", humanEscalationTrend);
        } catch (Exception e) {
            metrics.put("humanEscalationTrend", List.of());
        }

        // ===== P3 收尾：失败率 / 重试率 / 超时率 / p95 / 规则路由覆盖率 / 意图分布（均排除评测流量 user_id=-1）=====
        try {
            Map<String, Object> rateRow = jdbcTemplate.queryForMap(
                    "SELECT " +
                    "  ROUND(SUM(CASE WHEN failure_count > 0 THEN 1 ELSE 0 END) * 100.0 / NULLIF(COUNT(*), 0), 1) AS failureRate, " +
                    "  ROUND(SUM(CASE WHEN retry_count   > 0 THEN 1 ELSE 0 END) * 100.0 / NULLIF(COUNT(*), 0), 1) AS retryRate, " +
                    "  ROUND(SUM(CASE WHEN is_timeout    = 1 THEN 1 ELSE 0 END) * 100.0 / NULLIF(COUNT(*), 0), 1) AS timeoutRate " +
                    "FROM ai_chat_turn_audit " +
                    "WHERE " + auditTimeCondition + " AND user_id <> -1");
            metrics.put("failureRate", toPercent(rateRow.get("failureRate")));
            metrics.put("retryRate", toPercent(rateRow.get("retryRate")));
            metrics.put("timeoutRate", toPercent(rateRow.get("timeoutRate")));
        } catch (Exception e) {
            metrics.put("failureRate", 0);
            metrics.put("retryRate", 0);
            metrics.put("timeoutRate", 0);
        }

        try {
            Double p95Latency = jdbcTemplate.queryForObject(
                    "SELECT ROUND(MAX(duration_ms)) AS p95Latency FROM ( " +
                    "  SELECT duration_ms, PERCENT_RANK() OVER (ORDER BY duration_ms) AS pr " +
                    "  FROM ai_chat_turn_audit " +
                    "  WHERE " + auditTimeCondition + " AND user_id <> -1 AND duration_ms IS NOT NULL " +
                    ") t WHERE pr <= 0.95", Double.class);
            metrics.put("p95Latency", p95Latency != null ? p95Latency : 0);
        } catch (Exception e) {
            metrics.put("p95Latency", 0);
        }

        try {
            Double ruleCoverage = jdbcTemplate.queryForObject(
                    "SELECT ROUND(SUM(CASE WHEN route_source = 'rule' THEN 1 ELSE 0 END) * 100.0 / NULLIF(COUNT(*), 0), 1) AS rate " +
                    "FROM ai_chat_turn_audit " +
                    "WHERE " + auditTimeCondition + " AND user_id <> -1", Double.class);
            metrics.put("routeRuleCoverageRate", ruleCoverage != null ? ruleCoverage : 0);
        } catch (Exception e) {
            metrics.put("routeRuleCoverageRate", 0);
        }

        try {
            List<Map<String, Object>> routeDist = jdbcTemplate.queryForList(
                    "SELECT route_source, intent, COUNT(*) AS cnt, ROUND(AVG(duration_ms)) AS avgMs " +
                    "FROM ai_chat_turn_audit " +
                    "WHERE " + auditTimeCondition + " AND user_id <> -1 " +
                    "GROUP BY route_source, intent ORDER BY cnt DESC");
            metrics.put("routeSourceIntentDist", routeDist);
        } catch (Exception e) {
            metrics.put("routeSourceIntentDist", List.of());
        }

        return AjaxResult.success(metrics);
    }

    /** 把 SQL 聚合出的 Number/null 转成 Double，null 一律 0（避免 NaN/Infinity 上页面） */
    private Double toPercent(Object value) {
        return value == null ? 0.0 : ((Number) value).doubleValue();
    }

    private int normalizeDays(int days) {
        return Math.max(1, Math.min(days, 90));
    }

    private String withinDaysCondition(String column, int days) {
        if (days <= 1) {
            return column + " >= CURDATE()";
        }
        return column + " >= DATE_SUB(CURDATE(), INTERVAL " + (days - 1) + " DAY)";
    }

    private Long queryLong(String sql) {
        Long value = jdbcTemplate.queryForObject(sql, Long.class);
        return value != null ? value : 0L;
    }
}
