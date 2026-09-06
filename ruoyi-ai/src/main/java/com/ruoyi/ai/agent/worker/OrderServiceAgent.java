package com.ruoyi.ai.agent.worker;

import org.springframework.ai.chat.client.ChatClient;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Component;

@Component
public class OrderServiceAgent extends AbstractWorkerAgent {
    public OrderServiceAgent(@Qualifier("orderServiceClient") ChatClient client) { super(client); }
    @Override public String getId() { return "order-service"; }
    @Override public String getDescription() {
        return "订单事务：按单号或按人查订单、查物流进度、取消订单、支付、确认收货";
    }
}
