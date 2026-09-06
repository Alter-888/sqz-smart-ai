package com.ruoyi.ai.eval;

import com.ruoyi.ai.rag.ScoredDoc;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

/**
 * 评测指标累加器（P6）。所有除法只在 summarize 时做一次（05 §6.5）。
 * 独立出来便于单测：评测管道自己就是测试工具，算错了没人会告诉，必须用断言锁住。
 */
public class EvalAccumulator {

    private int ragTotal;
    private int hitCount;
    private int intentTotal;
    private int intentHit;
    private int toolTotal;
    private int toolHit;
    private int faithCount;
    private int errorCount;
    private double recallSum;
    private double recallFinalSum;
    private double precisionSum;
    private double rrSum;
    private double faithSum;

    /** docs 按相关性降序的 top-K；Recall@final-top-k 取前缀，不再查一次（05 §6.5）。 */
    public void addRetrieval(List<String> truthKeys, List<ScoredDoc> docs, int finalTopK) {
        ragTotal++;
        Set<String> truth = new HashSet<>(truthKeys);
        Set<String> hitEntries = new HashSet<>();
        Set<String> hitEntriesInFinal = new HashSet<>();
        int relevantChunks = 0;
        int firstRelevantRank = 0;
        for (int i = 0; i < docs.size(); i++) {
            String key = entryKey(docs.get(i).id());
            if (!truth.contains(key)) {
                continue;
            }
            relevantChunks++;
            hitEntries.add(key);
            if (i < finalTopK) {
                hitEntriesInFinal.add(key);
            }
            if (firstRelevantRank == 0) {
                firstRelevantRank = i + 1;
            }
        }
        recallSum += (double) hitEntries.size() / truth.size();
        recallFinalSum += (double) hitEntriesInFinal.size() / truth.size();
        precisionSum += docs.isEmpty() ? 0d : (double) relevantChunks / docs.size();
        rrSum += firstRelevantRank == 0 ? 0d : 1d / firstRelevantRank;
        if (firstRelevantRank > 0) {
            hitCount++;
        }
    }

    /** 覆盖即算对：该调的都调了就行，多调不算错（05 §五 细节 4）。 */
    /** 路由意图：hit=true 表示路由结果与期望一致。 */
    public void addIntent(boolean hit) {
        intentTotal++;
        if (hit) {
            intentHit++;
        }
    }

    public void addTools(List<String> expect, List<String> actual) {
        if (expect == null || expect.isEmpty()) {
            return;
        }
        toolTotal++;
        if (new HashSet<>(actual).containsAll(expect)) {
            toolHit++;
        }
    }

    public void addFaithfulness(double score0to5) {
        faithCount++;
        faithSum += score0to5;
    }

    public void incrementError() {
        errorCount++;
    }

    public EvalMetrics summarize(int caseCount, long avgMs) {
        return new EvalMetrics(caseCount,
                pct(recallSum, ragTotal),
                pct(recallFinalSum, ragTotal),
                pct(precisionSum, ragTotal),
                pct(rrSum, ragTotal),
                pct(hitCount, ragTotal),
                pct(intentHit, intentTotal),
                pct(toolHit, toolTotal),
                pct(faithSum / 5d, faithCount),
                avgMs);
    }

    /** 分母为 0 返回 null：含义是「这次没评这一项」，不是「得了 0 分」（05 §6.5）。 */
    private static Double pct(double num, int den) {
        return den == 0 ? null
                : BigDecimal.valueOf(num * 100d / den)
                        .setScale(2, RoundingMode.HALF_UP).doubleValue();
    }

    /** 块 id 归到条目级 entryKey：去掉末尾的 _c{n} 块后缀（05 §4.3）。 */
    public static String entryKey(String blockId) {
        if (blockId == null) {
            return "";
        }
        return blockId.trim().replaceAll("_c\\d+$", "");
    }

    public int getRagTotal() { return ragTotal; }
    public int getIntentTotal() { return intentTotal; }
    public int getIntentHit() { return intentHit; }
    public int getToolTotal() { return toolTotal; }
    public int getToolHit() { return toolHit; }
    public int getFaithCount() { return faithCount; }
    public int getErrorCount() { return errorCount; }
    public double getRecallSum() { return recallSum; }
    public double getRecallFinalSum() { return recallFinalSum; }
    public double getPrecisionSum() { return precisionSum; }
    public double getRrSum() { return rrSum; }
    public double getFaithSum() { return faithSum; }
}
