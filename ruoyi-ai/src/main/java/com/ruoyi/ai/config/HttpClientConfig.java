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
import java.net.http.HttpClient;
import java.nio.charset.StandardCharsets;
import java.time.Duration;

/**
 * HTTP 客户端配置
 * 让 RestClient 走 JDK 系统 DNS 解析，避免代理软件干扰。
 * 使用 BufferingClientHttpRequestFactory 使响应体可重复读取，支持日志诊断。
 *
 * P0 修复（02 §9.1）：给请求工厂设 connectTimeout(10s) + readTimeout(60s)。
 * 原实现不设读超时，模型端一旦卡住请求会一直挂着，Retry 模板既不重试也不失败，
 * 用户干等 SseEmitter 的 300 秒，且 is_timeout 指标恒为 0（量不到超时）。
 */
@Configuration
public class HttpClientConfig {

    private static final Logger log = LoggerFactory.getLogger(HttpClientConfig.class);

    @Bean
    public RestClientCustomizer restClientCustomizer() {
        return builder -> builder
                // BufferingClientHttpRequestFactory 包装后，响应体可多次读取（供拦截器和 Spring AI 各自读取）
                .requestFactory(new BufferingClientHttpRequestFactory(jdkFactoryWithTimeouts()))
                .requestInterceptor(new AiRequestLoggingInterceptor());
    }

    /**
     * JDK HttpClient + 显式超时：
     * connectTimeout 10s 防止连不上时无限等；readTimeout 60s 大于模型最慢正常响应（p95≈29s、最慢≈96.9s），
     * 但远小于 SseEmitter 的 300s —— 真出现极端慢轮次，让它快点失败而不是让用户空等。
     */
    private JdkClientHttpRequestFactory jdkFactoryWithTimeouts() {
        HttpClient httpClient = HttpClient.newBuilder()
                .connectTimeout(Duration.ofSeconds(10))
                .build();
        JdkClientHttpRequestFactory factory = new JdkClientHttpRequestFactory(httpClient);
        factory.setReadTimeout(Duration.ofSeconds(60));
        return factory;
    }

    /**
     * AI 请求日志拦截器：
     * 1. 对 Qwen3 模型注入 enable_thinking=false（仅 SiliconFlow 上的 Qwen3 需要）
     * 2. 注入 tool_choice=auto（确保第三方平台触发 Function Calling）
     * 3. 记录请求/响应状态与 tool_calls 诊断（已移除打印全量请求体的 debug 循环，避免噪音与信息泄露）
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