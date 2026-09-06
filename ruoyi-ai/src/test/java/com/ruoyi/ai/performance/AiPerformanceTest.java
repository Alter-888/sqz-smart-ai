package com.ruoyi.ai.performance;

import com.ruoyi.ai.context.ChatContext;
import com.ruoyi.ai.service.ChatService;
import com.ruoyi.ai.util.SensitiveDataMasker;
import com.ruoyi.common.core.redis.RedisCache;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.*;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Spy;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.ai.chat.client.ChatClient;
import org.springframework.retry.support.RetryTemplate;

import java.util.*;
import java.util.concurrent.*;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.concurrent.atomic.AtomicLong;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

/**
 * AI模块性能测试
 * 使用并发线程池模拟高负载场景，验证核心组件的吞吐量和线程安全性
 */
@ExtendWith(MockitoExtension.class)
@DisplayName("AI模块性能测试")
class AiPerformanceTest {

    @Mock
    private RedisCache redisCache;
    @Mock
    private ChatClient chatClient;
    @Mock
    private com.ruoyi.ai.service.ChatHistoryService chatHistoryService;
    @Mock
    private com.ruoyi.ai.service.AuditService auditService;
    @Mock
    private RetryTemplate aiRetryTemplate;
    @Spy
    private ObjectMapper objectMapper = new ObjectMapper();

    @InjectMocks
    private ChatService chatService;

    private static final int THREAD_COUNT = 20;
    private static final int OPERATIONS_PER_THREAD = 500;

    // ======================== SSE Ticket 并发吞吐量测试 ========================

    @Test
    @DisplayName("Ticket生成吞吐量 - 20线程×500次并发生成ticket")
    void ticketCreation_throughput_20threads() throws Exception {
        int totalOps = THREAD_COUNT * OPERATIONS_PER_THREAD;
        ExecutorService executor = Executors.newFixedThreadPool(THREAD_COUNT);
        CountDownLatch startLatch = new CountDownLatch(1);
        CountDownLatch endLatch = new CountDownLatch(THREAD_COUNT);
        AtomicInteger successCount = new AtomicInteger(0);
        Set<String> allTickets = ConcurrentHashMap.newKeySet();

        for (int i = 0; i < THREAD_COUNT; i++) {
            final int threadIdx = i;
            executor.submit(() -> {
                try {
                    startLatch.await();
                    for (int j = 0; j < OPERATIONS_PER_THREAD; j++) {
                        String ticket = chatService.createOneTimeTicket("login-uuid-" + threadIdx + "-" + j);
                        if (ticket != null && ticket.length() == 32) {
                            allTickets.add(ticket);
                            successCount.incrementAndGet();
                        }
                    }
                } catch (Exception e) {
                    // 记录但不中断
                } finally {
                    endLatch.countDown();
                }
            });
        }

        long start = System.nanoTime();
        startLatch.countDown();
        endLatch.await(30, TimeUnit.SECONDS);
        long elapsed = System.nanoTime() - start;

        executor.shutdown();

        double elapsedMs = elapsed / 1_000_000.0;
        double throughput = totalOps / (elapsedMs / 1000.0);

        System.out.printf("[Ticket吞吐量] 总操作=%d, 成功=%d, 耗时=%.1fms, 吞吐量=%.0f ops/s%n",
                totalOps, successCount.get(), elapsedMs, throughput);

        // 断言：全部成功，且ticket全局唯一
        assertEquals(totalOps, successCount.get(), "所有ticket生成应成功");
        assertEquals(totalOps, allTickets.size(), "每个ticket应全局唯一（无碰撞）");
        assertTrue(throughput > 1000, "吞吐量应超过1000 ops/s");
    }

    @Test
    @DisplayName("Ticket验证吞吐量 - 20线程×500次并发验证ticket")
    void ticketValidation_throughput_20threads() throws Exception {
        int totalOps = THREAD_COUNT * OPERATIONS_PER_THREAD;
        // 预先配置Mock：所有有效ticket返回对应uuid
        when(redisCache.getCacheObject(argThat(key -> key != null && key.startsWith("sse_ticket:"))))
                .thenAnswer(inv -> {
                    String key = inv.getArgument(0);
                    return "uuid-for-" + key.substring("sse_ticket:".length());
                });

        ExecutorService executor = Executors.newFixedThreadPool(THREAD_COUNT);
        CountDownLatch startLatch = new CountDownLatch(1);
        CountDownLatch endLatch = new CountDownLatch(THREAD_COUNT);
        AtomicInteger successCount = new AtomicInteger(0);

        // 预生成ticket列表
        List<String> tickets = new ArrayList<>();
        for (int i = 0; i < totalOps; i++) {
            tickets.add(UUID.randomUUID().toString().replace("-", ""));
        }

        for (int i = 0; i < THREAD_COUNT; i++) {
            final int threadIdx = i;
            executor.submit(() -> {
                try {
                    startLatch.await();
                    for (int j = 0; j < OPERATIONS_PER_THREAD; j++) {
                        int idx = threadIdx * OPERATIONS_PER_THREAD + j;
                        String result = chatService.validateAndConsumeTicket(tickets.get(idx));
                        if (result != null) {
                            successCount.incrementAndGet();
                        }
                    }
                } catch (Exception e) {
                    // 记录但不中断
                } finally {
                    endLatch.countDown();
                }
            });
        }

        long start = System.nanoTime();
        startLatch.countDown();
        endLatch.await(30, TimeUnit.SECONDS);
        long elapsed = System.nanoTime() - start;

        executor.shutdown();

        double elapsedMs = elapsed / 1_000_000.0;
        double throughput = totalOps / (elapsedMs / 1000.0);

        System.out.printf("[Ticket验证吞吐量] 总操作=%d, 成功=%d, 耗时=%.1fms, 吞吐量=%.0f ops/s%n",
                totalOps, successCount.get(), elapsedMs, throughput);

        assertEquals(totalOps, successCount.get(), "所有ticket验证应成功");
        assertTrue(throughput > 1000, "吞吐量应超过1000 ops/s");
    }

    // ======================== 敏感数据脱敏吞吐量测试 ========================

    @Test
    @DisplayName("手机号脱敏吞吐量 - 10万次连续脱敏")
    void maskPhone_throughput_100k() {
        int totalOps = 100_000;
        String[] phones = {"13812345678", "1381234", "123", "", null, "13900001111",
                "15012345678", "18600009999", "17711112222", "19933334444"};

        long start = System.nanoTime();
        for (int i = 0; i < totalOps; i++) {
            SensitiveDataMasker.maskPhone(phones[i % phones.length]);
        }
        long elapsed = System.nanoTime() - start;

        double elapsedMs = elapsed / 1_000_000.0;
        double throughput = totalOps / (elapsedMs / 1000.0);
        double avgNs = elapsed / (double) totalOps;

        System.out.printf("[手机号脱敏] 总操作=%d, 耗时=%.1fms, 吞吐量=%.0f ops/s, 平均=%.0fns/op%n",
                totalOps, elapsedMs, throughput, avgNs);

        assertTrue(throughput > 100_000, "脱敏吞吐量应超过10万 ops/s");
        assertTrue(avgNs < 10_000, "单次脱敏应小于10μs");
    }

    @Test
    @DisplayName("订单数据批量脱敏吞吐量 - 1万个Map对象")
    void maskOrderData_throughput_10k() {
        int totalOps = 10_000;
        List<Map<String, Object>> dataList = new ArrayList<>();
        for (int i = 0; i < totalOps; i++) {
            Map<String, Object> data = new HashMap<>();
            data.put("phone", "138" + String.format("%08d", i));
            data.put("address", "北京市朝阳区建国门外大街" + i + "号");
            data.put("orderId", (long) i);
            data.put("amount", 99.99);
            dataList.add(data);
        }

        long start = System.nanoTime();
        for (Map<String, Object> data : dataList) {
            SensitiveDataMasker.maskOrderData(data);
        }
        long elapsed = System.nanoTime() - start;

        double elapsedMs = elapsed / 1_000_000.0;
        double throughput = totalOps / (elapsedMs / 1000.0);

        System.out.printf("[订单脱敏] 总操作=%d, 耗时=%.1fms, 吞吐量=%.0f ops/s%n",
                totalOps, elapsedMs, throughput);

        assertTrue(throughput > 10_000, "批量脱敏吞吐量应超过1万 ops/s");

        // 验证脱敏正确性
        assertEquals("138****0000", dataList.get(0).get("phone"));
        assertEquals("北京市朝阳区***", dataList.get(0).get("address"));
        assertEquals(0L, dataList.get(0).get("orderId")); // 非敏感字段不变
    }

    // ======================== ChatContext ThreadLocal 线程安全性测试 ========================

    @Test
    @DisplayName("ChatContext线程隔离 - 20线程并发读写无数据泄漏")
    void chatContext_threadIsolation_20threads() throws Exception {
        ExecutorService executor = Executors.newFixedThreadPool(THREAD_COUNT);
        CountDownLatch startLatch = new CountDownLatch(1);
        CountDownLatch endLatch = new CountDownLatch(THREAD_COUNT);
        AtomicInteger violationCount = new AtomicInteger(0);

        for (int i = 0; i < THREAD_COUNT; i++) {
            final long threadSessionId = 1000L + i;
            final String threadToolName = "tool_" + i;
            executor.submit(() -> {
                try {
                    startLatch.await();
                    for (int j = 0; j < 200; j++) {
                        // 每次迭代：设置 → 读取验证 → 清理
                        ChatContext.setSessionId(threadSessionId);
                        ChatContext.addToolCallName(threadToolName);
                        ChatContext.addCardData(Map.of("thread", threadSessionId));

                        // 验证隔离性
                        Long readId = ChatContext.getSessionId();
                        List<String> tools = ChatContext.getToolCallNames();
                        List<Map<String, Object>> cards = ChatContext.getCardData();

                        if (!Long.valueOf(threadSessionId).equals(readId)) {
                            violationCount.incrementAndGet();
                        }
                        if (tools.stream().anyMatch(t -> !t.equals(threadToolName))) {
                            violationCount.incrementAndGet();
                        }
                        if (cards.stream().anyMatch(c -> !Long.valueOf(threadSessionId).equals(c.get("thread")))) {
                            violationCount.incrementAndGet();
                        }

                        ChatContext.clear();

                        // 清理后验证
                        if (ChatContext.getSessionId() != null) {
                            violationCount.incrementAndGet();
                        }
                    }
                } catch (Exception e) {
                    violationCount.incrementAndGet();
                } finally {
                    endLatch.countDown();
                }
            });
        }

        startLatch.countDown();
        assertTrue(endLatch.await(30, TimeUnit.SECONDS), "所有线程应在30秒内完成");
        executor.shutdown();

        assertEquals(0, violationCount.get(), "不应出现线程间数据泄漏");
        System.out.printf("[ThreadLocal隔离] 线程=%d, 迭代=200/线程, 违规=%d%n",
                THREAD_COUNT, violationCount.get());
    }

    @Test
    @DisplayName("ChatContext高频clear - 20线程×1000次clear无内存泄漏")
    void chatContext_frequentClear_noLeak() throws Exception {
        int clearPerThread = 1000;
        ExecutorService executor = Executors.newFixedThreadPool(THREAD_COUNT);
        CountDownLatch startLatch = new CountDownLatch(1);
        CountDownLatch endLatch = new CountDownLatch(THREAD_COUNT);
        AtomicInteger errorCount = new AtomicInteger(0);

        for (int i = 0; i < THREAD_COUNT; i++) {
            executor.submit(() -> {
                try {
                    startLatch.await();
                    for (int j = 0; j < clearPerThread; j++) {
                        ChatContext.setSessionId((long) j);
                        ChatContext.addToolCallName("tool");
                        ChatContext.addCardData(Map.of("k", "v"));
                        ChatContext.setRagSources(List.of(Map.of("s", "v")));
                        ChatContext.clear();
                    }
                } catch (Exception e) {
                    errorCount.incrementAndGet();
                } finally {
                    endLatch.countDown();
                }
            });
        }

        // 记录GC前后内存
        Runtime rt = Runtime.getRuntime();
        System.gc();
        long memBefore = rt.totalMemory() - rt.freeMemory();

        startLatch.countDown();
        assertTrue(endLatch.await(30, TimeUnit.SECONDS));
        executor.shutdown();

        System.gc();
        long memAfter = rt.totalMemory() - rt.freeMemory();
        long memDelta = memAfter - memBefore;

        System.out.printf("[ThreadLocal清理] 总clear=%d, 错误=%d, 内存变化=%+dKB%n",
                THREAD_COUNT * clearPerThread, errorCount.get(), memDelta / 1024);

        assertEquals(0, errorCount.get(), "clear操作不应抛出异常");
        // 内存增长不应超过10MB（允许GC波动）
        assertTrue(memDelta < 10 * 1024 * 1024, "内存增长不应超过10MB");
    }

    // ======================== Ticket唯一性压力测试 ========================

    @Test
    @DisplayName("Ticket唯一性 - 5万个ticket无碰撞")
    void ticketUniqueness_50k_noDuplication() {
        int totalTickets = 50_000;
        Set<String> tickets = new HashSet<>();

        long start = System.nanoTime();
        for (int i = 0; i < totalTickets; i++) {
            String ticket = chatService.createOneTimeTicket("uuid-test-" + String.format("%06d", i));
            tickets.add(ticket);
        }
        long elapsed = System.nanoTime() - start;

        double elapsedMs = elapsed / 1_000_000.0;

        System.out.printf("[Ticket唯一性] 总生成=%d, 唯一数=%d, 耗时=%.1fms%n",
                totalTickets, tickets.size(), elapsedMs);

        assertEquals(totalTickets, tickets.size(), "5万个ticket应全部唯一，无碰撞");
    }
}
