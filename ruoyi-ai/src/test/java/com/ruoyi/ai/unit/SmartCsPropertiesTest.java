package com.ruoyi.ai.unit;

import com.ruoyi.ai.config.SmartCsProperties;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

/**
 * 校验 P0 新增的 smart-cs.* 配置绑定默认值（纯逻辑，不启 Spring 上下文）。
 * 若有人在 application.yml 改了默认值却忘记改 SmartCsProperties，这里会立刻报红。
 */
class SmartCsPropertiesTest {

    private final SmartCsProperties p = new SmartCsProperties();

    @Test
    void agent_defaults() {
        assertEquals(8, p.getAgent().getToolBudgetPerTurn());
        assertTrue(p.getAgent().isSupervisorEnabled());
        assertEquals(3, p.getAgent().getSupervisorMaxDelegations());
        assertEquals(0.1, p.getAgent().getEvalSampleRate(), 1e-9);
        assertTrue(p.getAgent().isHitlEnabled());
        assertTrue(p.getAgent().getHitlTools().contains("checkoutFromCart"));
        assertEquals(4, p.getAgent().getHitlTools().size());
    }

    @Test
    void model_defaults_match_unified_model() {
        assertEquals("qwen3.7-flash", p.getModel().getWorker());
        assertEquals("qwen3.7-flash", p.getModel().getRouter());
        assertEquals("qwen3.7-flash", p.getModel().getJudge());
    }

    @Test
    void rag_defaults() {
        assertEquals(0.4, p.getRag().getSimilarityThreshold(), 1e-9);
        assertEquals(20, p.getRag().getVectorTopK());
        assertFalse(p.getRag().isFullTextEnabled());
        assertFalse(p.getRag().getRerank().isEnabled());
        assertEquals(400, p.getRag().getChunkSize());
    }

    @Test
    void eval_defaults() {
        assertEquals(8, p.getEval().getK());
        assertEquals(-1, p.getEval().getUserId());
        assertFalse(p.getEval().isRunAgent());
        assertFalse(p.getEval().isJudgeEnabled());
        assertFalse(p.getEval().isLegacyRetrieval());
    }
}