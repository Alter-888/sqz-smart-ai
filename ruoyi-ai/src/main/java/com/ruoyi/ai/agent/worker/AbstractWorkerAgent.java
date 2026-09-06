package com.ruoyi.ai.agent.worker;

import com.ruoyi.ai.advisor.HybridRagAdvisor;
import com.ruoyi.ai.agent.AgentContext;
import com.ruoyi.ai.agent.AgentResult;
import com.ruoyi.ai.agent.ChatAgent;
import com.ruoyi.ai.aspect.ToolBudgetExceededException;
import com.ruoyi.ai.context.ChatContext;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.ai.chat.client.ChatClient;
import org.springframework.ai.chat.memory.ChatMemory;
import org.springframework.ai.tool.execution.ToolExecutionException;

import java.util.ArrayList;
import java.util.List;

/** 5 个 Worker 的逻辑完全一样，用基类避免复制 5 遍 */
public abstract class AbstractWorkerAgent implements ChatAgent {

    private static final Logger log = LoggerFactory.getLogger(AbstractWorkerAgent.class);
    protected final ChatClient client;

    protected AbstractWorkerAgent(ChatClient client) { this.client = client; }

    @Override
    public AgentResult execute(String userInput, AgentContext ctx) {
        // 工具调用名累积在 ThreadLocal 里，先记下水位，差值就是本 Agent 调了哪些工具
        int mark = ChatContext.getToolCallNames().size();
        long start = System.currentTimeMillis();

        String text;
        try {
            text = client.prompt()
                    .system(s -> s.param("userId", String.valueOf(ctx.getUserId())))
                    .user(userInput)
                    .advisors(a -> {
                        a.param(ChatMemory.CONVERSATION_ID, String.valueOf(ctx.getSessionId()));
                        if (ctx.getRagCategories() != null && !ctx.getRagCategories().isEmpty()) {
                            a.param(HybridRagAdvisor.CATEGORIES, ctx.getRagCategories());
                        }
                    })
                    .call()
                    .content();
        } catch (ToolExecutionException e) {
            // 工具预算耗尽（方案C）：捕获后立即返回提示，不再走 client.prompt() 重试，秒级停止
            if (hasBudgetCause(e)) {
                return budgetStoppedResult(mark, start, e);
            }
            // 其他工具执行异常：保持原样向上抛，交给 ChatOrchestrator 的重试/超时逻辑
            throw e;
        }

        List<String> all = ChatContext.getToolCallNames();
        List<String> mine = new ArrayList<>(all.subList(Math.min(mark, all.size()), all.size()));
        log.info("Worker 执行完成 - agentId: {}, tools: {}, cost: {}ms",
                getId(), mine, System.currentTimeMillis() - start);
        return new AgentResult(text, mine, text != null && !text.isBlank());
    }

    /** 预算已耗尽：返回明确提示，并记录本轮实际调用的工具 */
    private AgentResult budgetStoppedResult(int mark, long start, Throwable e) {
        List<String> all = ChatContext.getToolCallNames();
        List<String> mine = new ArrayList<>(all.subList(Math.min(mark, all.size()), all.size()));
        log.warn("工具预算耗尽，停止本轮 - agentId: {}, tools: {}, cost: {}ms",
                getId(), mine, System.currentTimeMillis() - start);
        return new AgentResult(budgetMessage(e), mine, true);
    }

    private boolean hasBudgetCause(Throwable t) {
        for (Throwable c = t; c != null; c = c.getCause() == c ? null : c.getCause()) {
            if (c instanceof ToolBudgetExceededException) {
                return true;
            }
        }
        return false;
    }

    private String budgetMessage(Throwable t) {
        for (Throwable c = t; c != null; c = c.getCause() == c ? null : c.getCause()) {
            if (c instanceof ToolBudgetExceededException) {
                return c.getMessage();
            }
        }
        return "本轮已连续调用工具仍未完成，请把需求拆成两次提问，或回复『人工』转人工客服。";
    }
}
