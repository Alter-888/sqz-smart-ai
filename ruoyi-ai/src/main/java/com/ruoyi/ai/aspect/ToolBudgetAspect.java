package com.ruoyi.ai.aspect;

import com.ruoyi.ai.config.SmartCsProperties;
import com.ruoyi.ai.context.ChatContext;
import lombok.RequiredArgsConstructor;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

import java.util.Map;

/**
 * 工具预算守卫：单轮工具调用上限，超限返回提示字符串而不抛异常。
 *
 * 为什么不抛异常：抛异常会被 Spring AI 包成工具错误再喂回模型，
 * 模型很可能换个工具继续试；返回明确提示能让它停下来对用户说话。
 *
 * 前置：ruoyi-ai/pom.xml 需声明 spring-boot-starter-aop（P0 已加），
 * 且 spring.aop.proxy-target-class 必须为 true（Spring Boot 默认），否则 AOP 代理反射会抛 IllegalArgumentException。
 */
@Aspect
@Component
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
            // 返回字符串而不是抛异常，见类注释
            return Map.of("error", "本轮已连续调用 " + used
                    + " 次工具仍未完成，请把需求拆成两次提问，或回复『人工』转人工客服。");
        }
        return pjp.proceed();
    }
}
