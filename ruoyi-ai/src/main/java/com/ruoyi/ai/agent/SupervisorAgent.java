package com.ruoyi.ai.agent;

import com.ruoyi.ai.context.ChatContext;
import com.ruoyi.ai.mcp.AgentDelegateTools;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.ai.chat.client.ChatClient;
import org.springframework.ai.chat.memory.ChatMemory;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

/**
 * 跨域编排 Supervisor（P7 实现，02 §十一）。
 * 故意不实现 ChatAgent（见设计 §七 末尾警告）：它不直接对用户说话，
 * 而是把 Worker 包成工具让模型编排，自己只负责重置/清理委派计数。
 */
@Service
public class SupervisorAgent {

    private static final Logger log = LoggerFactory.getLogger(SupervisorAgent.class);

    private final ChatClient supervisorClient;

    // 显式写构造器 + @Qualifier，不用 @RequiredArgsConstructor：
    // 容器里有 8 个 ChatClient，靠“字段名 == Bean 名”碰对能跑但脆弱
    public SupervisorAgent(@Qualifier("supervisorClient") ChatClient supervisorClient) {
        this.supervisorClient = supervisorClient;
    }

    public AgentResult orchestrate(String userInput, AgentContext ctx) {
        int mark = ChatContext.getToolCallNames().size();
        long start = System.currentTimeMillis();
        AgentDelegateTools.resetDelegations();
        try {
            String text = supervisorClient.prompt()
                    .user(userInput)
                    .advisors(a -> a.param(ChatMemory.CONVERSATION_ID,
                            String.valueOf(ctx.getSessionId())))
                    .call()
                    .content();

            List<String> all = ChatContext.getToolCallNames();
            List<String> mine = new ArrayList<>(all.subList(Math.min(mark, all.size()), all.size()));
            log.info("Supervisor 编排完成 - tools: {}, cost: {}ms",
                    mine, System.currentTimeMillis() - start);
            return new AgentResult(text, mine, text != null && !text.isBlank());
        } finally {
            // 异常路径也清计数，避免线程池复用后下一轮一进来就“已达委派上限”
            AgentDelegateTools.clearDelegations();
        }
    }
}
