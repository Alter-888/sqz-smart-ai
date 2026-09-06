package com.ruoyi.ai.agent.worker;

import org.springframework.ai.chat.client.ChatClient;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Component;

@Component
public class KnowledgeAgent extends AbstractWorkerAgent {
    public KnowledgeAgent(@Qualifier("knowledgeClient") ChatClient client) { super(client); }
    @Override public String getId() { return "knowledge"; }
    @Override public String getDescription() {
        return "政策顾问：只依据知识库检索结果解答退换货、保修条款与操作指南，无业务工具";
    }
}
