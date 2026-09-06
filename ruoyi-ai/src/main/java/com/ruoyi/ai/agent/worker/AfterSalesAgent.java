package com.ruoyi.ai.agent.worker;

import org.springframework.ai.chat.client.ChatClient;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Component;

@Component
public class AfterSalesAgent extends AbstractWorkerAgent {
    public AfterSalesAgent(@Qualifier("afterSalesClient") ChatClient client) { super(client); }
    @Override public String getId() { return "after-sales"; }
    @Override public String getDescription() {
        return "售后处理：创建与跟进工单、提交和查询商品评价、解答退换货与保修规则";
    }
}
