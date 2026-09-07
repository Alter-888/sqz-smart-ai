package com.ruoyi.ai.eval;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.ruoyi.ai.agent.IntentRouter;
import com.ruoyi.ai.config.SmartCsProperties;
import com.ruoyi.ai.entity.EvalGolden;
import com.ruoyi.ai.entity.EvalResult;
import com.ruoyi.ai.mapper.EvalGoldenMapper;
import com.ruoyi.ai.mapper.EvalResultMapper;
import com.ruoyi.ai.rag.RagRetrievalService;
import com.ruoyi.ai.rag.ScoredDoc;
import com.ruoyi.common.exception.ServiceException;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * 离线评测管道（P6）。
 * 走与线上同一条 {@link RagRetrievalService}，保证评的是同一份代码。
 * 默认只跑检索层 + 路由层（几十秒出结果），Worker 层默认关（会真实执行工具、写审计表）。
 */
@Service
@RequiredArgsConstructor
public class EvaluationJob {

    private static final Logger log = LoggerFactory.getLogger(EvaluationJob.class);

    private final EvalGoldenMapper goldenMapper;
    private final EvalResultMapper resultMapper;
    private final RagRetrievalService retrieval;
    private final IntentRouter router;
    private final SmartCsProperties props;
    private final ObjectMapper objectMapper;

    /** 查向量库行数必须走 PG 连接（@Primary 的 JdbcTemplate 是 MySQL）。 */
    @Autowired
    @Qualifier("pgVectorJdbcTemplate")
    private JdbcTemplate pgVectorJdbcTemplate;

    /** 跑一次评测：加载全部启用条目 -> 逐条评估 -> 汇总落库（05 §6.4）。 */
    public EvalMetrics run(String dataset, String remark) {
        List<GoldenCase> cases = loadCases(dataset);
        if (cases.isEmpty()) {
            throw new ServiceException("黄金集为空或全部停用: " + dataset);
        }
        int k = props.getEval().getK();
        EvalAccumulator acc = new EvalAccumulator();
        long t0 = System.currentTimeMillis();
        for (GoldenCase c : cases) {
            try {
                evalOne(c, k, acc);
            } catch (Exception e) {
                acc.incrementError();
                log.warn("评测单条失败 - goldenId: {}, err: {}", c.goldenId(), e.getMessage());
            }
        }
        long avgMs = (System.currentTimeMillis() - t0) / cases.size();
        EvalMetrics m = acc.summarize(cases.size(), avgMs);
        save(dataset, m, remark);
        log.info("评测完成 - dataset: {}, 用例: {}, 异常: {}, 结果: {}",
                dataset, cases.size(), acc.getErrorCount(), m);
        return m;
    }

    private void evalOne(GoldenCase c, int k, EvalAccumulator acc) {
        // ① 路由层：规则命中零成本
        IntentRouter.RouteDecision d = router.route(c.question());
        log.info("评测路由 - goldenId: {}, q: {}, 实际: {}({}), 期望: {}", c.goldenId(), c.question(), d.intent().name(), d.source(), c.expectIntent());
        if (StringUtils.hasText(c.expectIntent())) {
            acc.addIntent(d.intent().name().equals(c.expectIntent()));
        }

        // ② 检索层：类别过滤用「期望意图」而非路由结果，避免路由错拖累检索归因
        IntentRouter.Intent forRag = intentForRag(c, d);
        if (!c.truthKeys().isEmpty() && !forRag.ragCategories.isEmpty()) {
            List<ScoredDoc> docs = retrieval.retrieve(c.question(), forRag.ragCategories, k);
            acc.addRetrieval(c.truthKeys(), docs, props.getRag().getFinalTopK());
        }

        // ③ Worker 层：默认关（run-agent=false），开了才跑（05 §6.3 两条硬约束）
        if (props.getEval().isRunAgent()) {
            runAgentAndScore(c, acc);
        }
    }

    /** 有 expect_intent 就用它，没标才退回路由结果（05 §6.4）。 */
    private IntentRouter.Intent intentForRag(GoldenCase c, IntentRouter.RouteDecision d) {
        if (!StringUtils.hasText(c.expectIntent())) {
            return d.intent();
        }
        try {
            return IntentRouter.Intent.valueOf(c.expectIntent());
        } catch (IllegalArgumentException e) {
            log.warn("黄金集 expect_intent 不是合法枚举 - goldenId: {}, value: {}",
                    c.goldenId(), c.expectIntent());
            return d.intent();
        }
    }

    /** Worker 层：评 Tool Accuracy / Faithfulness。默认关，此处留空，开了 run-agent 才补全（05 §6.2）。 */
    private void runAgentAndScore(GoldenCase c, EvalAccumulator acc) {
        // TODO P6 可选增强：run-agent=true 时真实驱动 Worker + judge 打分，回填 toolAccuracy / faithfulness。
        log.debug("run-agent 已开启，但 Worker 层评估当前未落地 - goldenId: {}", c.goldenId());
    }

    private List<GoldenCase> loadCases(String dataset) {
        LambdaQueryWrapper<EvalGolden> qw = new LambdaQueryWrapper<>();
        qw.eq(EvalGolden::getDataset, dataset).eq(EvalGolden::getStatus, 1);
        List<EvalGolden> rows = goldenMapper.selectList(qw);
        List<GoldenCase> cases = new ArrayList<>();
        for (EvalGolden g : rows) {
            try {
                GoldenRules.validate(g);
            } catch (Exception e) {
                // 单条非法不能废掉整轮（05 §6.4）
                log.warn("黄金集条目校验未通过，跳过 - goldenId: {}, err: {}", g.getGoldenId(), e.getMessage());
                continue;
            }
            List<String> truth = GoldenRules.readJsonList(g.getTruthChunkIds()).stream()
                    .map(EvalAccumulator::entryKey).distinct().collect(Collectors.toList());
            cases.add(new GoldenCase(g.getGoldenId(), g.getQuestion(), g.getExpectIntent(),
                    GoldenRules.readJsonList(g.getExpectTools()), truth,
                    g.getAnswerPoints(), g.getCategory()));
        }
        return cases;
    }

    private void save(String dataset, EvalMetrics m, String remark) {
        EvalResult e = new EvalResult();
        e.setDataset(dataset);
        e.setCaseCount(m.caseCount());
        e.setRecallAtK(m.recallAtK());
        e.setRecallAtFinalK(m.recallAtFinalK());
        e.setPrecisionAtK(m.precisionAtK());
        e.setMrr(m.mrr());
        e.setHitRate(m.hitRate());
        e.setIntentAccuracy(m.intentAccuracy());
        e.setToolAccuracy(m.toolAccuracy());
        e.setFaithfulness(m.faithfulness());
        e.setAvgDurationMs(m.avgDurationMs());
        e.setConfigSnapshot(snapshotJson());
        e.setRemark(StringUtils.hasText(remark) ? remark : "未填写本次目的");
        resultMapper.insert(e);
    }

    /** 快照覆盖所有会影响结果的东西；缺一项，这条记录就无法复现（05 §6.6）。 */
    private String snapshotJson() {
        SmartCsProperties.Rag r = props.getRag();
        Map<String, Object> s = new LinkedHashMap<>();
        s.put("evalK", props.getEval().getK());
        s.put("finalTopK", r.getFinalTopK());
        s.put("vectorTopK", r.getVectorTopK());
        s.put("fullTextEnabled", r.isFullTextEnabled());
        s.put("fullTextTopK", r.getFullTextTopK());
        s.put("fusionTopK", r.getFusionTopK());
        s.put("rrfK", r.getRrfK());
        s.put("similarityThreshold", r.getSimilarityThreshold());
        s.put("parentExpand", r.isParentExpand());
        s.put("rerankEnabled", r.getRerank().isEnabled());
        s.put("chunkSize", r.getChunkSize());
        s.put("runAgent", props.getEval().isRunAgent());
        s.put("workerModel", props.getModel().getWorker());
        s.put("routerModel", props.getModel().getRouter());
        s.put("judgeModel", props.getModel().getJudge());
        s.put("vectorRows", countVectorRows());
        try {
            return objectMapper.writeValueAsString(s);
        } catch (JsonProcessingException ex) {
            log.warn("配置快照序列化失败，本次记录将缺少快照: {}", ex.getMessage());
            return "{}";
        }
    }

    private long countVectorRows() {
        try {
            Long c = pgVectorJdbcTemplate.queryForObject("SELECT count(*) FROM public.vector_store", Long.class);
            return c == null ? 0L : c;
        } catch (Exception e) {
            log.warn("向量库行数统计失败，快照 vectorRows 记 0: {}", e.getMessage());
            return 0L;
        }
    }
}
