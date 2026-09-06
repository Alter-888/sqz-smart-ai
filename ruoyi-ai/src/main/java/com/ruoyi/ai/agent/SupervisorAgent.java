package com.ruoyi.ai.agent;

import org.springframework.stereotype.Component;

/**
 * 跨域编排 Supervisor（P7 实现）。
 * P4 阶段先给空实现：不参与编排，抛"未实现"，由 ChatOrchestrator 在 CROSS_DOMAIN 时兜底。
 */
@Component
public class SupervisorAgent {

    public AgentResult orchestrate(String message, AgentContext ctx) {
        throw new UnsupportedOperationException("Supervisor 编排为 P7 阶段功能，请在 P4 阶段使用单域路由。");
    }
}
