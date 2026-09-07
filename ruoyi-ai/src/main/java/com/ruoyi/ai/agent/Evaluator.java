package com.ruoyi.ai.agent;

import com.ruoyi.ai.config.SmartCsProperties;
import com.ruoyi.ai.mapper.ChatTurnAuditMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.ai.chat.client.ChatClient;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ThreadLocalRandom;

/**
 * 异步抽检评估（P7 实现，02 §十二）。
 * 由 AuditService.recordTurn（@Async auditExecutor）在审计行落库后调用，
 * 因此本方法自身不再标 @Async：同一线程内先拿到 auditId 再抽检，避免二次排队和竞态。
 * 采样命中才调 judge 模型，绝不阻塞用户线程（抽检慢一点无所谓，p95 不能被它拖高）。
 */
@Service
public class Evaluator {

    private static final Logger log = LoggerFactory.getLogger(Evaluator.class);

    private final SmartCsProperties props;
    private final ChatTurnAuditMapper auditMapper;
    private final ChatClient judgeClient;

    public Evaluator(@Qualifier("judgeClient") ChatClient judgeClient,
                     ChatTurnAuditMapper auditMapper,
                     SmartCsProperties props) {
        this.judgeClient = judgeClient;
        this.auditMapper = auditMapper;
        this.props = props;
    }

    /** judge 的结构化输出：supportScore/answerScore 各 0~5，reason 一句中文理由 */
    private record Verdict(Integer supportScore, Integer answerScore, String reason) {
    }

    public void spotCheck(Long auditId, String userMessage, String aiResponse,
                          ChatOrchestrator.TurnResult turn,
                          List<Map<String, String>> ragSources) {
        if (auditId == null || turn == null || aiResponse == null || aiResponse.isBlank()) {
            return;
        }
        double rate = props.getAgent().getEvalSampleRate();
        if (rate <= 0 || ThreadLocalRandom.current().nextDouble() >= rate) {
            return;   // 采样率之外直接跳过
        }
        long start = System.currentTimeMillis();
        try {
            Verdict v = judgeClient.prompt()
                    .user("用户问题：\n" + userMessage
                            + "\n\n助手回答：\n" + aiResponse
                            + "\n\n参考资料（可能为空）：\n" + buildRagText(ragSources)
                            + "\n\n只输出 JSON，不要输出其他内容。")
                    .call()
                    .entity(Verdict.class);

            int support = clampScore(v == null ? null : v.supportScore());
            int answer = clampScore(v == null ? null : v.answerScore());
            BigDecimal score = BigDecimal.valueOf(
                    Math.round((support + answer) / 2.0 * 10) / 10.0);
            String reason = "支持度=" + support + "/5，完成度=" + answer + "/5"
                    + (v != null && v.reason() != null && !v.reason().isBlank() ? "，" + v.reason() : "");
            auditMapper.updateEval(auditId, score, truncate(reason, 2000));
            log.info("异步抽检完成 - auditId: {}, score: {}, cost: {}ms",
                    auditId, score, System.currentTimeMillis() - start);
        } catch (Exception e) {
            log.warn("异步抽检失败 - auditId: {}, error: {}", auditId, e.getMessage());
        }
    }

    private String buildRagText(List<Map<String, String>> ragSources) {
        if (ragSources == null || ragSources.isEmpty()) {
            return "（无）";
        }
        StringBuilder sb = new StringBuilder();
        int i = 1;
        for (Map<String, String> s : ragSources) {
            sb.append(i++).append(". ");
            sb.append(s.getOrDefault("source", ""));
            if (s.get("content") != null) {
                sb.append("：").append(s.get("content"));
            }
            sb.append("\n");
        }
        return sb.toString();
    }

    private int clampScore(Integer score) {
        if (score == null) return 0;
        return Math.max(0, Math.min(5, score));
    }

    private String truncate(String text, int maxLength) {
        if (text == null) return null;
        return text.length() > maxLength ? text.substring(0, maxLength) : text;
    }
}
