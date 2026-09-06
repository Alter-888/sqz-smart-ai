package com.ruoyi.ai.unit;

import com.ruoyi.ai.aspect.ToolBudgetExceededException;
import com.ruoyi.ai.config.ToolBudgetExecutionExceptionProcessor;
import org.springframework.ai.tool.definition.ToolDefinition;
import org.springframework.ai.tool.execution.ToolExecutionException;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.Mockito.mock;

/**
 * 方案 B 单测：ToolBudgetExecutionExceptionProcessor
 * - 预算守卫异常 → 直接抛出，穿透 Spring AI 工具循环（停止重试）
 * - 其他工具异常 → 返回 message（保持喂回模型让模型修正参数）
 */
class ToolBudgetExecutionExceptionProcessorTest {

    private final ToolBudgetExecutionExceptionProcessor processor = new ToolBudgetExecutionExceptionProcessor();
    private final ToolDefinition toolDef = mock(ToolDefinition.class);

    @Test
    void budgetExceededDirectlyThrowsToBreakLoop() {
        ToolExecutionException ex = new ToolExecutionException(toolDef, new ToolBudgetExceededException("预算用完了"));
        assertThrows(ToolExecutionException.class, () -> processor.process(ex));
    }

    @Test
    void otherExceptionStillReturnsMessageToFeedModel() {
        ToolExecutionException ex = new ToolExecutionException(toolDef, new RuntimeException("db down"));
        // getMessage() 对 RuntimeException(Throwable) 是 cause 的 toString，断言包含原因即可
        String result = processor.process(ex);
        assertEquals(ex.getMessage(), result);
    }
}
