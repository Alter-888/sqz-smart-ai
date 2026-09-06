package com.ruoyi.ai.aspect;

/**
 * 工具预算耗尽异常：由 {@link ToolBudgetAspect} 在单轮工具调用达到上限时抛出。
 *
 * 为什么用异常而不是返回 error 字符串（P4 修复·方案C）：
 * 返回 {"error": ...} 会被 Spring AI 当成"正常工具结果"喂回模型，
 * 模型认为"执行了但返回错误"，换个参数继续重试，用户等很久。
 * 抛出异常后，配合 {@code ToolBudgetExecutionExceptionProcessor} 把异常直接抛出，
 * 让 Spring AI 的工具循环立刻终止，不再喂回模型，秒级停止。
 */
public class ToolBudgetExceededException extends RuntimeException {

    public ToolBudgetExceededException(String message) {
        super(message);
    }
}
