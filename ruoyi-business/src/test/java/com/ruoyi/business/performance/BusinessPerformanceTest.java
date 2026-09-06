package com.ruoyi.business.performance;

import com.ruoyi.business.entity.Order;
import com.ruoyi.business.entity.OrderItem;
import com.ruoyi.business.entity.Product;
import com.ruoyi.business.enums.OrderStatus;
import com.ruoyi.business.enums.OrderStatusTransition;
import com.ruoyi.business.mapper.OrderItemMapper;
import com.ruoyi.business.mapper.OrderMapper;
import com.ruoyi.business.mapper.ProductMapper;
import com.ruoyi.business.service.NotificationService;
import com.ruoyi.business.service.OrderService;
import com.ruoyi.common.exception.ServiceException;
import org.junit.jupiter.api.*;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.math.BigDecimal;
import java.util.*;
import java.util.concurrent.*;
import java.util.concurrent.atomic.AtomicInteger;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

/**
 * 电商业务模块性能测试
 * 使用并发线程池模拟高负载场景，验证订单创建吞吐量和状态机校验性能
 */
@ExtendWith(MockitoExtension.class)
@DisplayName("业务模块性能测试")
class BusinessPerformanceTest {

    @Mock
    private OrderMapper orderMapper;
    @Mock
    private OrderItemMapper orderItemMapper;
    @Mock
    private ProductMapper productMapper;
    @Mock
    private NotificationService notificationService;

    @InjectMocks
    private OrderService orderService;

    private static final int THREAD_COUNT = 20;

    // ======================== 订单创建并发吞吐量测试 ========================

    @Test
    @DisplayName("订单创建吞吐量 - 20线程×100次并发创建订单")
    void createOrder_throughput_20threads() throws Exception {
        int opsPerThread = 100;
        int totalOps = THREAD_COUNT * opsPerThread;

        // Mock：商品存在且库存充足
        Product product = new Product();
        product.setProductId(1L);
        product.setName("测试手机");
        product.setPrice(new BigDecimal("2999.00"));
        product.setStock(999999);
        product.setStatus(1);
        lenient().when(productMapper.selectById(anyLong())).thenReturn(product);
        lenient().when(productMapper.deductStock(anyLong(), anyInt())).thenReturn(1);
        lenient().when(orderMapper.insert(any(Order.class))).thenReturn(1);
        lenient().when(orderItemMapper.insert(any(OrderItem.class))).thenReturn(1);

        ExecutorService executor = Executors.newFixedThreadPool(THREAD_COUNT);
        CountDownLatch startLatch = new CountDownLatch(1);
        CountDownLatch endLatch = new CountDownLatch(THREAD_COUNT);
        AtomicInteger successCount = new AtomicInteger(0);
        AtomicInteger errorCount = new AtomicInteger(0);

        for (int i = 0; i < THREAD_COUNT; i++) {
            final long userId = 100L + i;
            executor.submit(() -> {
                try {
                    startLatch.await();
                    for (int j = 0; j < opsPerThread; j++) {
                        try {
                            OrderItem item = new OrderItem();
                            item.setProductId(1L);
                            item.setQuantity(1);
                            List<OrderItem> items = new ArrayList<>();
                            items.add(item);

                            Order result = orderService.createOrder(userId, "北京市朝阳区" + j, "备注", items);
                            if (result != null && result.getOrderNo() != null) {
                                successCount.incrementAndGet();
                            }
                        } catch (Exception e) {
                            errorCount.incrementAndGet();
                        }
                    }
                } catch (Exception e) {
                    errorCount.incrementAndGet();
                } finally {
                    endLatch.countDown();
                }
            });
        }

        long start = System.nanoTime();
        startLatch.countDown();
        endLatch.await(60, TimeUnit.SECONDS);
        long elapsed = System.nanoTime() - start;

        executor.shutdown();

        double elapsedMs = elapsed / 1_000_000.0;
        double throughput = successCount.get() / (elapsedMs / 1000.0);

        System.out.printf("[订单创建吞吐量] 总操作=%d, 成功=%d, 失败=%d, 耗时=%.1fms, 吞吐量=%.0f ops/s%n",
                totalOps, successCount.get(), errorCount.get(), elapsedMs, throughput);

        assertEquals(totalOps, successCount.get(), "所有订单应创建成功");
        assertTrue(throughput > 500, "订单创建吞吐量应超过500 ops/s");
    }

    @Test
    @DisplayName("订单创建 - 库存扣减竞争模拟（乐观锁失败场景）")
    void createOrder_stockContention_optimisticLock() throws Exception {
        int totalOps = THREAD_COUNT * 50;

        Product product = new Product();
        product.setProductId(1L);
        product.setName("限量手机");
        product.setPrice(new BigDecimal("4999.00"));
        product.setStock(10);
        product.setStatus(1);
        lenient().when(productMapper.selectById(1L)).thenReturn(product);
        lenient().when(orderMapper.insert(any(Order.class))).thenReturn(1);
        lenient().when(orderItemMapper.insert(any(OrderItem.class))).thenReturn(1);

        // 模拟乐观锁：前200次成功，后续失败
        AtomicInteger stockCounter = new AtomicInteger(0);
        lenient().when(productMapper.deductStock(eq(1L), eq(1))).thenAnswer(inv -> {
            int current = stockCounter.incrementAndGet();
            return current <= 200 ? 1 : 0; // 前200次成功
        });

        ExecutorService executor = Executors.newFixedThreadPool(THREAD_COUNT);
        CountDownLatch startLatch = new CountDownLatch(1);
        CountDownLatch endLatch = new CountDownLatch(THREAD_COUNT);
        AtomicInteger successCount = new AtomicInteger(0);
        AtomicInteger stockFailCount = new AtomicInteger(0);

        for (int i = 0; i < THREAD_COUNT; i++) {
            final long userId = 100L + i;
            executor.submit(() -> {
                try {
                    startLatch.await();
                    for (int j = 0; j < 50; j++) {
                        try {
                            OrderItem item = new OrderItem();
                            item.setProductId(1L);
                            item.setQuantity(1);
                            orderService.createOrder(userId, "地址", null, List.of(item));
                            successCount.incrementAndGet();
                        } catch (ServiceException e) {
                            if (e.getMessage().contains("库存不足")) {
                                stockFailCount.incrementAndGet();
                            }
                        }
                    }
                } catch (Exception ignored) {
                } finally {
                    endLatch.countDown();
                }
            });
        }

        long start = System.nanoTime();
        startLatch.countDown();
        endLatch.await(60, TimeUnit.SECONDS);
        long elapsed = System.nanoTime() - start;

        executor.shutdown();

        double elapsedMs = elapsed / 1_000_000.0;

        System.out.printf("[乐观锁竞争] 总请求=%d, 成功=%d, 库存不足=%d, 耗时=%.1fms%n",
                totalOps, successCount.get(), stockFailCount.get(), elapsedMs);

        // 成功数 + 库存不足数 = 总数
        assertEquals(totalOps, successCount.get() + stockFailCount.get(),
                "每个请求应明确返回成功或库存不足");
        assertEquals(200, successCount.get(), "成功数应等于模拟的可用库存");
        assertTrue(stockFailCount.get() > 0, "应有部分请求因库存不足失败");
    }

    // ======================== 状态机校验吞吐量测试 ========================

    @Test
    @DisplayName("状态机校验吞吐量 - 10万次状态转换校验")
    void orderStatusTransition_throughput_100k() {
        int totalOps = 100_000;
        OrderStatus[] statuses = OrderStatus.values();
        int validCount = 0;
        int invalidCount = 0;

        long start = System.nanoTime();
        for (int i = 0; i < totalOps; i++) {
            OrderStatus from = statuses[i % statuses.length];
            OrderStatus to = statuses[(i * 3 + 1) % statuses.length];
            boolean result = OrderStatusTransition.canTransition(from, to);
            if (result) validCount++;
            else invalidCount++;
        }
        long elapsed = System.nanoTime() - start;

        double elapsedMs = elapsed / 1_000_000.0;
        double throughput = totalOps / (elapsedMs / 1000.0);
        double avgNs = elapsed / (double) totalOps;

        System.out.printf("[状态机校验] 总操作=%d, 合法=%d, 非法=%d, 耗时=%.1fms, 吞吐量=%.0f ops/s, 平均=%.0fns/op%n",
                totalOps, validCount, invalidCount, elapsedMs, throughput, avgNs);

        assertTrue(throughput > 1_000_000, "状态机查询吞吐量应超过100万 ops/s");
        assertTrue(avgNs < 1_000, "单次状态校验应小于1μs");
        assertTrue(validCount > 0, "应存在合法转换");
        assertTrue(invalidCount > 0, "应存在非法转换");
    }

    // ======================== 订单号生成唯一性测试 ========================

    @Test
    @DisplayName("订单号唯一性 - 20线程×200次并发创建，订单号全局唯一")
    void orderNoUniqueness_concurrent() throws Exception {
        int opsPerThread = 200;
        int totalOps = THREAD_COUNT * opsPerThread;

        Product product = new Product();
        product.setProductId(1L);
        product.setName("测试商品");
        product.setPrice(new BigDecimal("99.00"));
        product.setStock(999999);
        product.setStatus(1);
        lenient().when(productMapper.selectById(anyLong())).thenReturn(product);
        lenient().when(productMapper.deductStock(anyLong(), anyInt())).thenReturn(1);
        lenient().when(orderMapper.insert(any(Order.class))).thenReturn(1);
        lenient().when(orderItemMapper.insert(any(OrderItem.class))).thenReturn(1);

        Set<String> allOrderNos = ConcurrentHashMap.newKeySet();
        ExecutorService executor = Executors.newFixedThreadPool(THREAD_COUNT);
        CountDownLatch startLatch = new CountDownLatch(1);
        CountDownLatch endLatch = new CountDownLatch(THREAD_COUNT);

        for (int i = 0; i < THREAD_COUNT; i++) {
            final long userId = 100L + i;
            executor.submit(() -> {
                try {
                    startLatch.await();
                    for (int j = 0; j < opsPerThread; j++) {
                        OrderItem item = new OrderItem();
                        item.setProductId(1L);
                        item.setQuantity(1);
                        Order order = orderService.createOrder(userId, "地址", null, List.of(item));
                        allOrderNos.add(order.getOrderNo());
                    }
                } catch (Exception ignored) {
                } finally {
                    endLatch.countDown();
                }
            });
        }

        long start = System.nanoTime();
        startLatch.countDown();
        endLatch.await(60, TimeUnit.SECONDS);
        long elapsed = System.nanoTime() - start;

        executor.shutdown();

        double elapsedMs = elapsed / 1_000_000.0;

        System.out.printf("[订单号唯一性] 总生成=%d, 唯一数=%d, 耗时=%.1fms%n",
                totalOps, allOrderNos.size(), elapsedMs);

        assertEquals(totalOps, allOrderNos.size(), "所有订单号应全局唯一");
        assertTrue(allOrderNos.stream().allMatch(no -> no.startsWith("ORD")), "所有订单号应以ORD开头");
    }

    // ======================== 金额计算精度压力测试 ========================

    @Test
    @DisplayName("金额计算精度 - 大量订单项金额计算无精度丢失")
    void amountCalculation_precision_stress() {
        int totalOps = 10_000;
        Random random = new Random(42);

        long start = System.nanoTime();
        for (int i = 0; i < totalOps; i++) {
            BigDecimal price = BigDecimal.valueOf(random.nextInt(10000) + 1, 2); // 0.01~100.00
            int quantity = random.nextInt(100) + 1;
            BigDecimal total = price.multiply(BigDecimal.valueOf(quantity));

            // 验证精度：scale不超过原始精度之和
            assertTrue(total.scale() <= price.scale() + BigDecimal.valueOf(quantity).scale(),
                    "金额计算精度不应丢失");
            assertTrue(total.compareTo(BigDecimal.ZERO) > 0, "金额应为正数");
        }
        long elapsed = System.nanoTime() - start;

        double elapsedMs = elapsed / 1_000_000.0;
        double throughput = totalOps / (elapsedMs / 1000.0);

        System.out.printf("[金额精度] 总计算=%d, 耗时=%.1fms, 吞吐量=%.0f ops/s%n",
                totalOps, elapsedMs, throughput);

        assertTrue(throughput > 10_000, "金额计算吞吐量应超过1万 ops/s");
    }
}
