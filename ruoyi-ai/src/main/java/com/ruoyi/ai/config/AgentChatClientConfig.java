package com.ruoyi.ai.config;

import com.ruoyi.ai.advisor.HybridRagAdvisor;
import com.ruoyi.ai.agent.IntentRouter;
import com.ruoyi.ai.mcp.CommonMcpTools;
import com.ruoyi.ai.mcp.OrderMcpTools;
import com.ruoyi.ai.mcp.ProductMcpTools;
import com.ruoyi.ai.mcp.ReviewMcpTools;
import com.ruoyi.ai.mcp.TicketMcpTools;
import com.ruoyi.ai.mcp.UserMcpTools;
import com.ruoyi.ai.mcp.CartMcpTools;
import com.ruoyi.ai.mcp.NotificationMcpTools;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.ai.chat.client.ChatClient;
import org.springframework.ai.chat.client.advisor.MessageChatMemoryAdvisor;
import org.springframework.ai.chat.memory.ChatMemory;
import org.springframework.ai.chat.prompt.ChatOptions;
import org.springframework.ai.openai.OpenAiChatOptions;
import org.springframework.ai.tool.ToolCallbackProvider;
import org.springframework.ai.tool.method.MethodToolCallbackProvider;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * 5 个领域 Worker 的 ChatClient。
 *
 * 坑 1：ToolCallbackProvider 一律「内联构建」，绝不声明成 @Bean。
 *       MCP Server 自动配置会收集容器里所有 ToolCallbackProvider 类型的 Bean，
 *       多声明一个就会把同名工具重复暴露到 MCP 端点。全项目只保留 AiConfig 里那一个。
 *
 * 坑 2：ChatClient.Builder 在 Spring AI 的自动配置里是 prototype 作用域，
 *       所以每个 @Bean 方法各自用「方法参数」注入一份，互不污染。
 *       如果你改成注入到字段共用一份，必须显式 builder.clone()（该方法 1.0.0 确实存在）。
 */
@Configuration
@RequiredArgsConstructor
public class AgentChatClientConfig {

    private static final Logger log = LoggerFactory.getLogger(AgentChatClientConfig.class);

    private final SmartCsProperties props;

    private static ToolCallbackProvider tools(Object... toolObjects) {
        return MethodToolCallbackProvider.builder().toolObjects(toolObjects).build();
    }

    /** defaultOptions 会整体覆盖 yml 里的默认项，所以 temperature/maxTokens 要一起显式给全 */
    private ChatOptions workerOptions() {
        return OpenAiChatOptions.builder()
                .model(props.getModel().getWorker())
                .temperature(0.7)
                .maxTokens(2048)
                .build();
    }

    @Bean("salesAdvisorClient")
    public ChatClient salesAdvisorClient(ChatClient.Builder builder, ChatMemory memory,
                                        HybridRagAdvisor rag,
                                        ProductMcpTools product, CartMcpTools cart,
                                        CommonMcpTools common) {
        log.info("初始化 Worker ChatClient - agentId: sales-advisor, tools: 12, rag: true");
        return builder
                .defaultOptions(workerOptions())
                .defaultSystem(AgentPrompts.SALES_ADVISOR)
                .defaultAdvisors(MessageChatMemoryAdvisor.builder(memory).build(), rag)
                .defaultToolCallbacks(tools(product, cart, common))
                .build();
    }

    @Bean("orderServiceClient")
    public ChatClient orderServiceClient(ChatClient.Builder builder, ChatMemory memory,
                                         OrderMcpTools order, CommonMcpTools common) {
        log.info("初始化 Worker ChatClient - agentId: order-service, tools: 7, rag: false");
        return builder
                .defaultOptions(workerOptions())
                .defaultSystem(AgentPrompts.ORDER_SERVICE)
                .defaultAdvisors(MessageChatMemoryAdvisor.builder(memory).build())
                .defaultToolCallbacks(tools(order, common))
                .build();
    }

    @Bean("afterSalesClient")
    public ChatClient afterSalesClient(ChatClient.Builder builder, ChatMemory memory,
                                       HybridRagAdvisor rag,
                                       TicketMcpTools ticket, ReviewMcpTools review,
                                       CommonMcpTools common) {
        log.info("初始化 Worker ChatClient - agentId: after-sales, tools: 9, rag: true");
        return builder
                .defaultOptions(workerOptions())
                .defaultSystem(AgentPrompts.AFTER_SALES)
                .defaultAdvisors(MessageChatMemoryAdvisor.builder(memory).build(), rag)
                .defaultToolCallbacks(tools(ticket, review, common))
                .build();
    }

    @Bean("accountClient")
    public ChatClient accountClient(ChatClient.Builder builder, ChatMemory memory,
                                    UserMcpTools user, NotificationMcpTools notification,
                                    CommonMcpTools common) {
        // 不挂 rag：账户/地址/通知的答案 100% 来自数据库工具，知识库里没有对应内容
        log.info("初始化 Worker ChatClient - agentId: account, tools: 13, rag: false");
        return builder
                .defaultOptions(workerOptions())
                .defaultSystem(AgentPrompts.ACCOUNT)
                .defaultAdvisors(MessageChatMemoryAdvisor.builder(memory).build())
                .defaultToolCallbacks(tools(user, notification, common))
                .build();
    }

    @Bean("knowledgeClient")
    public ChatClient knowledgeClient(ChatClient.Builder builder, ChatMemory memory,
                                      HybridRagAdvisor rag, CommonMcpTools common) {
        // 只有 1 个工具（escalateToHuman）。这个域答不上来时必须能转人工，
        // 否则它唯一的出路就是编造——这正是幻觉最容易发生的地方
        log.info("初始化 Worker ChatClient - agentId: knowledge, tools: 1, rag: true");
        return builder
                .defaultOptions(workerOptions())
                .defaultSystem(AgentPrompts.KNOWLEDGE)
                .defaultAdvisors(MessageChatMemoryAdvisor.builder(memory).build(), rag)
                .defaultToolCallbacks(tools(common))
                .build();
    }

    @Bean("routerClient")
    public ChatClient routerClient(ChatClient.Builder builder) {
        // 关键：不挂任何工具、不挂 RAG、不挂记忆。路由只看这一句话，挂了就是白烧 token
        log.info("初始化意图路由 ChatClient - model: {}", props.getModel().getRouter());
        return IntentRouter.buildRouterClient(builder, props.getModel().getRouter());
    }
}
