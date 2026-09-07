package com.ruoyi.ai.mcp;

import com.ruoyi.ai.agent.AgentContext;
import com.ruoyi.ai.agent.AgentRegistry;
import com.ruoyi.ai.agent.AgentResult;
import com.ruoyi.ai.agent.IntentRouter;
import com.ruoyi.ai.config.SmartCsProperties;
import com.ruoyi.ai.context.ChatContext;
import com.ruoyi.common.utils.SecurityUtils;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.ai.tool.annotation.Tool;
import org.springframework.ai.tool.annotation.ToolParam;
import org.springframework.stereotype.Component;

/**
 * P7 Supervisor 委派工具（02 §十一）：
 * 把 5 个 Worker 包成 @Tool 交给 supervisorClient 调用，模型决定拆几个子任务就调几个工具。
 * 委派必须串行（ChatContext 是 ThreadLocal）；上限由 delegate() 里的硬计数保证，不靠 Prompt。
 * 注意：本类不加入 AiConfig 的 ToolCallbackProvider，只内联挂在 supervisorClient 上，
 * 避免同名业务工具被重复暴露到 MCP 端点。
 */
@Component
@RequiredArgsConstructor
public class AgentDelegateTools {

    private static final Logger log = LoggerFactory.getLogger(AgentDelegateTools.class);

    private final AgentRegistry registry;
    private final SmartCsProperties props;

    @Tool(description = "把商品相关的子任务交给导购助手处理：搜商品、按预算或场景推荐、对比参数、加购物车、结算下单。传入完整的子任务描述。")
    public String askSalesAdvisor(@ToolParam(description = "子任务描述，要能独立看懂") String task) {
        return delegate("sales-advisor", task);
    }

    @Tool(description = "把订单相关的子任务交给订单专员处理：查订单、查物流、取消订单、确认收货、支付。传入完整的子任务描述。")
    public String askOrderService(@ToolParam(description = "子任务描述，要能独立看懂") String task) {
        return delegate("order-service", task);
    }

    @Tool(description = "把售后相关的子任务交给售后专员处理：创建和跟进工单、提交或查询商品评价、解释退换货与保修规则。传入完整的子任务描述。")
    public String askAfterSales(@ToolParam(description = "子任务描述，要能独立看懂") String task) {
        return delegate("after-sales", task);
    }

    @Tool(description = "把账户相关的子任务交给账户助理处理：查看个人资料、增删改收货地址、设置默认地址、查看站内通知。传入完整的子任务描述。")
    public String askAccount(@ToolParam(description = "子任务描述，要能独立看懂") String task) {
        return delegate("account", task);
    }

    @Tool(description = "把政策规则类的子任务交给政策顾问处理：退换货政策、保修条款、操作指南这类只查规则、不涉及具体订单的问题。传入完整的子任务描述。")
    public String askKnowledge(@ToolParam(description = "子任务描述，要能独立看懂") String task) {
        return delegate("knowledge", task);
    }

    /** 本轮已委派次数，由 SupervisorAgent.orchestrate() 进出时 reset / clear */
    private static final ThreadLocal<Integer> DELEGATIONS = ThreadLocal.withInitial(() -> 0);

    public static void resetDelegations() {
        DELEGATIONS.set(0);
    }

    public static void clearDelegations() {
        DELEGATIONS.remove();
    }

    private String delegate(String agentId, String task) {
        int used = DELEGATIONS.get();
        int max = props.getAgent().getSupervisorMaxDelegations();
        if (used >= max) {
            // 返回字符串而不抛异常，让模型停下来对用户说话
            log.warn("委派上限已达，拒绝委派 - agentId: {}, used: {}, max: {}", agentId, used, max);
            return "已达本轮委派上限。请先回答已经完成的部分，并告诉用户剩下的问题麻烦再单独问一次。";
        }
        DELEGATIONS.set(used + 1);

        IntentRouter.Intent intent = IntentRouter.Intent.byAgentId(agentId);
        AgentContext ctx = AgentContext.builder()
                .userId(SecurityUtils.getUserId())
                .sessionId(ChatContext.getSessionId())     // 串行执行才拿得到
                .intent(intent)
                .ragCategories(intent.ragCategories)       // 必须带：漏了 Worker 检索不过滤
                .build();
        log.info("Supervisor 委派 - agentId: {}, seq: {}/{}, task: {}", agentId, used + 1, max, task);
        AgentResult r = registry.get(agentId).execute(task, ctx);
        return r.text();
    }
}
