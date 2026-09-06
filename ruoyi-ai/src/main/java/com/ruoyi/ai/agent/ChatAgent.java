package com.ruoyi.ai.agent;

import java.util.List;

/**
 * 多智能体统一契约：每个 Worker（领域 Agent）都实现它。
 * Supervisor（P7）复用同一契约把 Worker 包成工具进行跨域编排。
 */
public interface ChatAgent {

    /** 稳定 agentId，如 "sales-advisor"，写进审计与工具落位 */
    String getId();

    /** 一句话描述，P7 注册给 Supervisor 当工具描述用 */
    String getDescription();

    /** 执行一轮领域对话 */
    AgentResult execute(String userInput, AgentContext ctx);
}
