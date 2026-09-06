package com.ruoyi.ai.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.retry.annotation.EnableRetry;
import org.springframework.retry.backoff.ExponentialBackOffPolicy;
import org.springframework.retry.policy.SimpleRetryPolicy;
import org.springframework.retry.support.RetryTemplate;

/**
 * AI 调用重试配置
 */
@Configuration
@EnableRetry
public class RetryConfig {

    @Value("${smart-cs.chat.retry-max-attempts:3}")
    private int maxAttempts;

    @Bean
    public RetryTemplate aiRetryTemplate() {
        RetryTemplate retryTemplate = new RetryTemplate();

        // 重试策略：最多 N 次
        SimpleRetryPolicy retryPolicy = new SimpleRetryPolicy();
        retryPolicy.setMaxAttempts(maxAttempts);
        retryTemplate.setRetryPolicy(retryPolicy);

        // 退避策略：指数退避（1s → 2s → 4s）
        ExponentialBackOffPolicy backOffPolicy = new ExponentialBackOffPolicy();
        backOffPolicy.setInitialInterval(1000L);
        backOffPolicy.setMultiplier(2.0);
        backOffPolicy.setMaxInterval(10000L);
        retryTemplate.setBackOffPolicy(backOffPolicy);

        return retryTemplate;
    }
}
