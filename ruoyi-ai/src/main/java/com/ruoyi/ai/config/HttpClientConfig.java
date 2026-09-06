package com.ruoyi.ai.config;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.web.client.RestClientCustomizer;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpRequest;
import org.springframework.http.client.BufferingClientHttpRequestFactory;
import org.springframework.http.client.ClientHttpRequestExecution;
import org.springframework.http.client.ClientHttpRequestInterceptor;
import org.springframework.http.client.ClientHttpResponse;
import org.springframework.http.client.JdkClientHttpRequestFactory;

import java.io.IOException;
import java.nio.charset.StandardCharsets;

/**
 * HTTP 客户端配置
 * 让 RestClient 走 JDK 系统 DNS 解析，避免代理软件干扰。
 * 使用 BufferingClientHttpRequestFactory 使响应体可重复读取，支持日志诊断。
 */
@Configuration
public class HttpClientConfig {

    private static final Logger log = LoggerFactory.getLogger(HttpClientConfig.class);

    @Bean
    public RestClientCustomizer restClientCustomizer() {
        return builder -> builder
                // BufferingClientHttpRequestFactory 包装后，响应体可多次读取（供拦截器和 Spring AI 各自读取）
                .requestFactory(new BufferingClientHttpRequestFactory(new JdkClientHttpRequestFactory()))
                .requestInterceptor(new AiRequestLoggingInterceptor());
    }

    /**
     * AI 请求日志拦截器：
     * 1. 对 Qwen3 模型注入 enable_thinking=false（仅 SiliconFlow 上的 Qwen3 需要）
     * 2. 注入 tool_choice=auto（确保第三方平台触发 Function Calling）
     * 3. 记录请求/响应诊断信息
     */
    static class AiRequestLoggingInterceptor implements ClientHttpRequestInterceptor {
        @Override
        public ClientHttpResponse intercept(HttpRequest request, byte[] body,
                                             ClientHttpRequestExecution execution) throws IOException {
            String bodyStr = new String(body, StandardCharsets.UTF_8);
            String uri = request.getURI().toString();
            log.info("AI API 请求: {} {}", request.getMethod(), uri);

            boolean isChatCompletion = uri.contains("chat/completions");

            if (isChatCompletion) {
                boolean modified = false;

                // 1. 仅对 Qwen3 系列模型注入 enable_thinking=false（DashScope 的 qwen-plus 不需要）
                if (bodyStr.contains("\"Qwen3") && !bodyStr.contains("\"enable_thinking\"")) {
                    bodyStr = bodyStr.substring(0, bodyStr.lastIndexOf('}'))
                            + ",\"enable_thinking\":false}";
                    modified = true;
                    log.info("已注入 enable_thinking=false（Qwen3 模型关闭思考模式）");
                }

                // 2. 当请求包含 tools 但没有 tool_choice 时，注入 tool_choice="auto"
                if (bodyStr.contains("\"tools\"") && !bodyStr.contains("\"tool_choice\"")) {
                    bodyStr = bodyStr.substring(0, bodyStr.lastIndexOf('}'))
                            + ",\"tool_choice\":\"auto\"}";
                    modified = true;
                    log.info("已注入 tool_choice=auto");
                }

                if (modified) {
                    body = bodyStr.getBytes(StandardCharsets.UTF_8);
                }

                if (bodyStr.contains("\"tools\"")) {
                    int toolCount = bodyStr.split("\"type\":\"function\"").length - 1;
                    log.info("Function Calling 已启用 ✓ 工具数量: {}, tool_choice: {}",
                            toolCount, bodyStr.contains("\"tool_choice\"") ? "已设置" : "未设置");
                } else {
                    log.debug("请求中没有 tools 参数（非工具调用请求）");
                }

                // 完整请求体日志（诊断用，确认问题后可移除或降级为 DEBUG）
                log.debug("===== 完整请求体（共 {} 字符）=====", bodyStr.length());
                for (int i = 0; i < bodyStr.length(); i += 2000) {
                    int end = Math.min(i + 2000, bodyStr.length());
                    log.debug("请求体[{}-{}]: {}", i, end, bodyStr.substring(i, end));
                }
            }

            ClientHttpResponse response = execution.execute(request, body);
            log.info("AI API 响应状态: {}", response.getStatusCode());

            // 诊断：检查 chat completions 响应中是否包含 tool_calls
            if (isChatCompletion) {
                try {
                    byte[] responseBytes = response.getBody().readAllBytes();
                    String responseStr = new String(responseBytes, StandardCharsets.UTF_8);
                    if (responseStr.contains("\"tool_calls\"")) {
                        log.info("✓ 模型返回了 tool_calls — Function Calling 正常触发");
                    } else {
                        log.warn("✗ 模型未返回 tool_calls — 模型选择了直接文本回复");
                        String preview = responseStr.substring(0, Math.min(500, responseStr.length()));
                        log.warn("响应摘要: {}", preview);
                    }
                } catch (Exception e) {
                    log.warn("读取响应体诊断失败: {}", e.getMessage());
                }
            }

            return response;
        }
    }
}
