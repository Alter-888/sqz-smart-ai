package com.ruoyi.ai.agent.worker;

import com.ruoyi.ai.advisor.HybridRagAdvisor;
import com.ruoyi.ai.agent.AgentContext;
import com.ruoyi.ai.agent.AgentResult;
import com.ruoyi.ai.agent.ChatAgent;
import com.ruoyi.ai.context.ChatContext;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.ai.chat.client.ChatClient;
import org.springframework.ai.chat.memory.ChatMemory;

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

        String text = client.prompt()
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

        List<String> all = ChatContext.getToolCallNames();
        List<String> mine = new ArrayList<>(all.subList(Math.min(mark, all.size()), all.size()));
        log.info("Worker 执行完成 - agentId: {}, tools: {}, cost: {}ms",
                getId(), mine, System.currentTimeMillis() - start);
        return new AgentResult(text, mine, text != null && !text.isBlank());
    }
}
