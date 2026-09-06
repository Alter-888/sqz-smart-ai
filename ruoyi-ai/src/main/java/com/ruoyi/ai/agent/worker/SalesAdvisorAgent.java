package com.ruoyi.ai.agent.worker;

import org.springframework.ai.chat.client.ChatClient;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Component;

@Component
public class SalesAdvisorAgent extends AbstractWorkerAgent {
    public SalesAdvisorAgent(@Qualifier("salesAdvisorClient") ChatClient client) { super(client); }
    @Override public String getId() { return "sales-advisor"; }
    @Override public String getDescription() {
        return "商品导购：按关键词或分类搜商品、按场景和预算推荐、对比参数、看评价、加购与结算";
    }
}
