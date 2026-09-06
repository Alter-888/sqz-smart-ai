package com.ruoyi.ai.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.ruoyi.common.core.redis.RedisCache;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Spy;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.ai.chat.client.ChatClient;
import org.springframework.retry.support.RetryTemplate;

import java.util.concurrent.TimeUnit;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

/**
 * ChatService ticket相关方法单元测试
 */
@ExtendWith(MockitoExtension.class)
class ChatServiceTest {

    @Mock
    private RedisCache redisCache;
    @Mock
    private ChatClient chatClient;
    @Mock
    private ChatHistoryService chatHistoryService;
    @Mock
    private AuditService auditService;
    @Mock
    private RetryTemplate aiRetryTemplate;
    @Spy
    private ObjectMapper objectMapper = new ObjectMapper();

    @InjectMocks
    private ChatService chatService;

    // ======================== createOneTimeTicket ========================

    @Test
    @DisplayName("createOneTimeTicket - 返回非空且长度32的ticket")
    void createOneTimeTicket_returnsNonEmptyTicket() {
        String ticket = chatService.createOneTimeTicket("test-login-uuid-1234");
        assertNotNull(ticket);
        assertEquals(32, ticket.length());
    }

    @Test
    @DisplayName("createOneTimeTicket - Redis存储被调用，含正确前缀和TTL")
    void createOneTimeTicket_redisStoreCalledWithCorrectParams() {
        String loginUuid = "test-login-uuid-1234";
        String ticket = chatService.createOneTimeTicket(loginUuid);

        verify(redisCache).setCacheObject(
                eq("sse_ticket:" + ticket),
                eq(loginUuid),
                eq(60),
                eq(TimeUnit.SECONDS));
    }

    // ======================== validateAndConsumeTicket ========================

    @Test
    @DisplayName("validateAndConsumeTicket - 有效ticket返回loginUuid")
    void validateAndConsumeTicket_validTicket_returnsLoginUuid() {
        String ticket = "abc12345678901234567890123456789";
        String expectedUuid = "test-login-uuid-5678";
        when(redisCache.getCacheObject("sse_ticket:" + ticket)).thenReturn(expectedUuid);

        String result = chatService.validateAndConsumeTicket(ticket);

        assertEquals(expectedUuid, result);
    }

    @Test
    @DisplayName("validateAndConsumeTicket - 消费后立即删除key")
    void validateAndConsumeTicket_deletesKeyAfterConsume() {
        String ticket = "abc12345678901234567890123456789";
        when(redisCache.getCacheObject("sse_ticket:" + ticket)).thenReturn("some-uuid");

        chatService.validateAndConsumeTicket(ticket);

        verify(redisCache).deleteObject("sse_ticket:" + ticket);
    }

    @Test
    @DisplayName("validateAndConsumeTicket - 过期ticket(Redis返回null)返回null")
    void validateAndConsumeTicket_expiredTicket_returnsNull() {
        String ticket = "abc12345678901234567890123456789";
        when(redisCache.getCacheObject("sse_ticket:" + ticket)).thenReturn(null);

        String result = chatService.validateAndConsumeTicket(ticket);

        assertNull(result);
        verify(redisCache, never()).deleteObject(anyString());
    }

    @Test
    @DisplayName("validateAndConsumeTicket - null票据返回null")
    void validateAndConsumeTicket_nullTicket_returnsNull() {
        String result = chatService.validateAndConsumeTicket(null);
        assertNull(result);
        verifyNoInteractions(redisCache);
    }

    @Test
    @DisplayName("validateAndConsumeTicket - 空字符串票据返回null")
    void validateAndConsumeTicket_emptyTicket_returnsNull() {
        String result = chatService.validateAndConsumeTicket("");
        assertNull(result);
        verifyNoInteractions(redisCache);
    }
}
