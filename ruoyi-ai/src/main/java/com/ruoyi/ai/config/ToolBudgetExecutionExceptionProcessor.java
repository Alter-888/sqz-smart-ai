package com.ruoyi.ai.config;

import com.ruoyi.ai.aspect.ToolBudgetExceededException;
import org.springframework.ai.tool.execution.ToolExecutionException;
import org.springframework.ai.tool.execution.ToolExecutionExceptionProcessor;
import org.springframework.stereotype.Component;

/**
 * 方案 B：工具执行异常处理器，覆盖 Spring AI 自动配置里的默认 Bean
 * （{@code ToolCallingAutoConfiguration#toolExecutionExceptionProcessor()} 标了 @ConditionalOnMissingBean，
 * 只要容器里有下面这个实现，自动配置的那个就不会创建）。
 *
 * 作用：让「工具预算耗尽」的异常真正中断整个工具循环，而不是被吞成 error 字符串喂回模型。
 *
 * 默认行为（1.0.0）：{@code DefaultToolExecutionExceptionProcessor} 的 alwaysThrow=false，
 * 会把工具抛出的异常转成 error 字符串返回，作为工具结果喂回模型 → 模型换个参数继续重试 → 用户等超久。
 *
 * 本实现（P4 修复·方案B）：
 * - 如果异常链条里含 {@link ToolBudgetExceededException}，直接原样抛出。
 *   由于 Spring AI 的 {@code lambda$executeToolCall$5} 只用 catch ToolExecutionException 包了一层，
 *   这里再抛出就会穿透 executeToolCalls / ChatModel 内部循环，传播到 Worker 的 client.prompt().call()，
 *   被 AbstractWorkerAgent 捕获后立即对用户说提示，不再喂回模型、不再重试。
 * - 其他工具异常保持默认：返回错误消息喂回模型，让模型有机会修正参数（不改变原有语义）。
 */
@Component
public class ToolBudgetExecutionExceptionProcessor implements ToolExecutionExceptionProcessor {

    @Override
    public String process(ToolExecutionException exception) {
        if (hasCause(exception, ToolBudgetExceededException.class)) {
            // 关键：抛出而非返回字符串，让它穿透工具循环
            throw exception;
        }
        return exception.getMessage();
    }

    private boolean hasCause(Throwable t, Class<?> type) {
        for (Throwable c = t; c != null; c = c.getCause() == c ? null : c.getCause()) {
            if (type.isInstance(c)) {
                return true;
            }
        }
        return false;
    }
}
