package com.ruoyi.ai.config;

import com.ruoyi.ai.mcp.CartMcpTools;
import com.ruoyi.ai.mcp.NotificationMcpTools;
import com.ruoyi.ai.mcp.OrderMcpTools;
import com.ruoyi.ai.mcp.ProductMcpTools;
import com.ruoyi.ai.mcp.ReviewMcpTools;
import com.ruoyi.ai.mcp.TicketMcpTools;
import com.ruoyi.ai.mcp.UserMcpTools;
import com.ruoyi.ai.mcp.CommonMcpTools;
import org.springframework.ai.tool.ToolCallbackProvider;
import org.springframework.ai.tool.method.MethodToolCallbackProvider;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * AI 核心配置（P4 改造后）。
 *
 * 工具调用架构：MCP（Model Context Protocol）
 * - MCP 工具层（mcp/ 包）：商品、订单、工单、用户、通知、评价、购物车、公共 八大工具组，通过 @Tool 注解声明
 * - MethodToolCallbackProvider 将工具注册到 MCP Server，由 spring-ai-starter-mcp-server-webmvc 暴露为标准 MCP 协议端点
 *
 * ⚠️ 这里只保留一个 ToolCallbackProvider Bean。
 *   5 个领域 Worker 的 ChatClient 工具回调在 AgentChatClientConfig 里「内联构建」，绝不再声明成 @Bean，
 *   否则 Spring 会把重复的同名工具暴露到 MCP 端点，工具清单就破了。
 */
@Configuration
public class AiConfig {

    /**
     * 唯一的 MCP 工具回调提供器：把 MCP 工具层八大工具组注册为 ToolCallback，供 MCP Server 使用。
     */
    @Bean
    public ToolCallbackProvider toolCallbackProvider(OrderMcpTools orderMcpTools,
                                                     TicketMcpTools ticketMcpTools,
                                                     ProductMcpTools productMcpTools,
                                                     UserMcpTools userMcpTools,
                                                     NotificationMcpTools notificationMcpTools,
                                                     ReviewMcpTools reviewMcpTools,
                                                     CartMcpTools cartMcpTools,
                                                     CommonMcpTools commonMcpTools) {
        return MethodToolCallbackProvider.builder()
                .toolObjects(orderMcpTools, ticketMcpTools, productMcpTools,
                             userMcpTools, notificationMcpTools, reviewMcpTools,
                             cartMcpTools, commonMcpTools)
                .build();
    }
}
