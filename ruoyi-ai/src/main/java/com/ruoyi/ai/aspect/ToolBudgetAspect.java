package com.ruoyi.ai.aspect;

import com.ruoyi.ai.config.SmartCsProperties;
import com.ruoyi.ai.context.ChatContext;
import lombok.RequiredArgsConstructor;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;

/**
 * 工具预算守卫：单轮工具调用上限，超限抛 {@link ToolBudgetExceededException}。
 *
 * 为什么不返回 {"error": ...}（P4 修复·方案C）：
 * 返回提示字符串会被 Spring AI 当成"正常工具结果"喂回模型，模型认为"执行了但返回错误"，
 * 换个参数继续重试，循环 4-5 轮（日志里工具数量 12→14→15→17 递增就是重试堆叠），用户等超久。
 *
 * 为什么抛异常能停（P4 修复·方案B）：
 * {@link com.ruoyi.ai.config.ToolBudgetExecutionExceptionProcessor} 会识别本异常并把异常直接抛出，
 * 让它穿透 Spring AI 的工具循环（不再被 process() 转成 error 字符串喂回模型），
 * 由 {@link com.ruoyi.ai.agent.worker.AbstractWorkerAgent} 捕获后直接对用户说提示，秒级停止。
 *
 * 前置：ruoyi-ai/pom.xml 需声明 spring-boot-starter-aop（P0 已加），
 * 且 spring.aop.proxy-target-class 必须为 true（Spring Boot 默认），否则 AOP 代理反射会抛 IllegalArgumentException。
 */
@Aspect
@Component
@Order(10)
@RequiredArgsConstructor
public class ToolBudgetAspect {

    private static final Logger log = LoggerFactory.getLogger(ToolBudgetAspect.class);
    private final SmartCsProperties props;

    @Around("@annotation(org.springframework.ai.tool.annotation.Tool)")
    public Object guard(ProceedingJoinPoint pjp) throws Throwable {
        int used = ChatContext.getToolCallNames().size();
        int budget = props.getAgent().getToolBudgetPerTurn();
        if (used >= budget) {
            String tool = pjp.getSignature().getName();
            log.warn("工具预算耗尽，拒绝调用 - tool: {}, used: {}, budget: {}", tool, used, budget);
            // 抛异常而不是返回提示，见类注释；由 ToolBudgetExecutionExceptionProcessor 放行抛出并中断循环
            throw new ToolBudgetExceededException("本轮已连续调用 " + used
                    + " 次工具仍未完成，请把需求拆成两次提问，或回复『人工』转人工客服。");
        }
        return pjp.proceed();
    }
}
