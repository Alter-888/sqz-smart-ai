package com.ruoyi.ai.unit;

import com.ruoyi.ai.aspect.ToolBudgetAspect;
import com.ruoyi.ai.config.SmartCsProperties;
import com.ruoyi.ai.context.ChatContext;
import org.aspectj.lang.ProceedingJoinPoint;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.util.Map;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

/**
 * 工具预算守卫单测：预算耗尽返回提示字符串而不是抛异常。
 * 抛异常会被 Spring AI 包成工具错误再喂回模型，模型大概率换个参数重试；
 * 返回明确提示能让它停下来对用户说话。
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
    void withinBudgetProceeds() throws Throwable {
        ChatContext.clear();
        ChatContext.addToolCallName("firstTool"); // 已用 1 次 = budget
        ToolBudgetAspect aspect = new ToolBudgetAspect(props);
        ProceedingJoinPoint pjp = mock(ProceedingJoinPoint.class);
        org.aspectj.lang.Signature sig = mock(org.aspectj.lang.Signature.class);
        when(sig.getName()).thenReturn("someTool");
        when(pjp.getSignature()).thenReturn(sig);
        when(pjp.proceed()).thenReturn(Map.of("ok", true));

        // used=1, budget=1 → 已达到上限，应拦截而不是 proceed
        Object result = aspect.guard(pjp);
        assertTrue(result instanceof Map);
        verify(pjp, never()).proceed();
    }

    @Test
    void budgetExhaustedReturnsMessageNotThrow() throws Throwable {
        ChatContext.clear();
        // 预置 1 个已用工具名，使 used = 1 = budget
        ChatContext.addToolCallName("searchProducts");
        ToolBudgetAspect aspect = new ToolBudgetAspect(props);
        ProceedingJoinPoint pjp = mock(ProceedingJoinPoint.class);
        when(pjp.getSignature()).thenReturn(mock(org.aspectj.lang.Signature.class));

        Object result = aspect.guard(pjp);
        // 应返回包含"工具预算耗尽"语义的 Map 而不是抛异常
        assertTrue(result instanceof Map);
        Map<?, ?> m = (Map<?, ?>) result;
        assertTrue(String.valueOf(m.get("error")).contains("连续调用"));
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
        verify(pjp).proceed();
    }
}
