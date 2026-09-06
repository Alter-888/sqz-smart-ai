package com.ruoyi.ai.agent.worker;

import org.springframework.ai.chat.client.ChatClient;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Component;

@Component
public class AccountAgent extends AbstractWorkerAgent {
    public AccountAgent(@Qualifier("accountClient") ChatClient client) { super(client); }
    @Override public String getId() { return "account"; }
    @Override public String getDescription() {
        return "账户事务：查看个人资料、增删改查收货地址与默认地址、处理站内通知";
    }
}
