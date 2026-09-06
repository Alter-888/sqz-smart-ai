package com.ruoyi.ai.unit;

import com.ruoyi.ai.aspect.ToolBudgetAspect;
import com.ruoyi.ai.aspect.ToolBudgetExceededException;
import com.ruoyi.ai.config.SmartCsProperties;
import com.ruoyi.ai.context.ChatContext;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.Signature;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.util.Map;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

/**
 * 工具预算守卫单测：预算耗尽时抛 ToolBudgetExceededException（而不是返回 error Map）。
 * 抛异常后由 ToolBudgetExecutionExceptionProcessor 放行抛出并中断 Spring AI 工具循环，
 * 再由 AbstractWorkerAgent 捕获后直接对用户说提示，避免"喂回模型→换个参数重试→循环卡很久"。
 */
class ToolBudgetAspectTest {

    private SmartCsProperties props;

    @BeforeEach
    void setUp() {
        props = new SmartCsProperties();
        // 预算设成 1：第 1 次调用放行，第 2 次调用应被拦下
        props.getAgent().setToolBudgetPerTurn(1);
    }

    @AfterEach
    void tearDown() {
        ChatContext.clear();
    }

    @Test
    void withinBudgetProceedsThrowsOnExceed() throws Throwable {
        ChatContext.clear();
        ChatContext.addToolCallName("firstTool"); // 已用 1 次 = budget
        ToolBudgetAspect aspect = new ToolBudgetAspect(props);
        ProceedingJoinPoint pjp = mock(ProceedingJoinPoint.class);
        Signature sig = mock(Signature.class);
        when(sig.getName()).thenReturn("someTool");
        when(pjp.getSignature()).thenReturn(sig);
        when(pjp.proceed()).thenReturn(Map.of("ok", true));

        // used=1, budget=1 → 已达到上限，应抛预算异常而不是 proceed
        ToolBudgetExceededException ex = assertThrows(ToolBudgetExceededException.class, () -> aspect.guard(pjp));
        assertTrue(ex.getMessage().contains("连续调用"));
        verify(pjp, never()).proceed();
    }

    @Test
    void budgetExhaustedThrowsNotReturnError() throws Throwable {
        ChatContext.clear();
        // 预置 1 个已用工具名，使 used = 1 = budget
        ChatContext.addToolCallName("searchProducts");
        ToolBudgetAspect aspect = new ToolBudgetAspect(props);
        ProceedingJoinPoint pjp = mock(ProceedingJoinPoint.class);
        when(pjp.getSignature()).thenReturn(mock(Signature.class));

        // 应抛预算异常而不是返回 Map
        ToolBudgetExceededException ex = assertThrows(ToolBudgetExceededException.class, () -> aspect.guard(pjp));
        assertTrue(ex.getMessage().contains("连续调用"));
        verify(pjp, never()).proceed();
    }

    @Test
    void underBudgetProceeds() throws Throwable {
        ChatContext.clear();
        // 0 个已用工具，budget=1 → 放行 proceed
        ToolBudgetAspect aspect = new ToolBudgetAspect(props);
        ProceedingJoinPoint pjp = mock(ProceedingJoinPoint.class);
        when(pjp.proceed()).thenReturn(Map.of("result", "ok"));

        Object result = aspect.guard(pjp);
        assertEquals(Map.of("result", "ok"), result);
        verify(pjp).proceed();
    }
}
