package com.ruoyi.business.service;

import com.ruoyi.business.entity.Order;
import com.ruoyi.business.entity.OrderItem;
import com.ruoyi.business.entity.Product;
import com.ruoyi.business.enums.OrderStatus;
import com.ruoyi.business.mapper.OrderItemMapper;
import com.ruoyi.business.mapper.OrderMapper;
import com.ruoyi.business.mapper.ProductMapper;
import com.ruoyi.common.exception.ServiceException;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

/**
 * OrderService 核心方法单元测试
 */
@ExtendWith(MockitoExtension.class)
class OrderServiceTest {

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

    // ======================== createOrder ========================

    @Test
    @DisplayName("创建订单 - 正常流程：商品存在、库存充足")
    void createOrder_success() {
        // 准备商品数据
        Product product = new Product();
        product.setProductId(1L);
        product.setName("测试手机");
        product.setPrice(new BigDecimal("2999.00"));
        product.setStock(100);
        product.setStatus(1);

        when(productMapper.selectById(1L)).thenReturn(product);
        when(productMapper.deductStock(eq(1L), eq(2))).thenReturn(1);
        when(orderMapper.insert(any(Order.class))).thenReturn(1);
        when(orderItemMapper.insert(any(OrderItem.class))).thenReturn(1);

        // 构建订单项
        OrderItem item = new OrderItem();
        item.setProductId(1L);
        item.setQuantity(2);
        List<OrderItem> items = new ArrayList<>();
        items.add(item);

        // 执行
        Order result = orderService.createOrder(1L, "北京市朝阳区", "测试备注", items);

        // 验证
        assertNotNull(result);
        assertEquals(OrderStatus.PENDING.getCode(), result.getStatus());
        assertEquals(new BigDecimal("5998.00"), result.getTotalAmount());
        assertTrue(result.getOrderNo().startsWith("ORD"));
        verify(productMapper).deductStock(1L, 2);
        verify(orderMapper).insert(any(Order.class));
        verify(orderItemMapper).insert(any(OrderItem.class));
    }

    @Test
    @DisplayName("创建订单 - 订单项为空时抛出异常")
    void createOrder_emptyItems_throwsException() {
        ServiceException ex = assertThrows(ServiceException.class,
                () -> orderService.createOrder(1L, "地址", null, Collections.emptyList()));
        assertEquals("订单项不能为空", ex.getMessage());
    }

    @Test
    @DisplayName("创建订单 - 库存不足时抛出异常并回滚")
    void createOrder_insufficientStock_throwsException() {
        Product product = new Product();
        product.setProductId(1L);
        product.setName("测试手机");
        product.setPrice(new BigDecimal("2999.00"));
        product.setStock(5);
        product.setStatus(1);

        when(productMapper.selectById(1L)).thenReturn(product);
        // deductStock 返回0表示库存不足
        when(productMapper.deductStock(eq(1L), eq(10))).thenReturn(0);

        OrderItem item = new OrderItem();
        item.setProductId(1L);
        item.setQuantity(10);
        List<OrderItem> items = List.of(item);

        ServiceException ex = assertThrows(ServiceException.class,
                () -> orderService.createOrder(1L, "地址", null, items));
        assertTrue(ex.getMessage().contains("库存不足"));
        // 不应插入订单
        verify(orderMapper, never()).insert(any(Order.class));
    }

    // ======================== updateOrderStatus ========================

    @Test
    @DisplayName("更新订单状态 - 幂等短路：目标状态等于当前状态，直接跳过")
    void updateOrderStatus_idempotent_skipsUpdate() {
        Order order = new Order();
        order.setOrderId(1L);
        order.setOrderNo("ORD001");
        order.setStatus(OrderStatus.PAID.getCode());

        when(orderMapper.selectById(1L)).thenReturn(order);

        // 执行：将已付款订单再次设为已付款
        orderService.updateOrderStatus(1L, "PAID");

        // 应跳过更新
        verify(orderMapper, never()).updateById(any(Order.class));
        verify(notificationService, never()).createNotification(anyLong(), anyString(), anyString(), anyString(), anyLong());
    }

    @Test
    @DisplayName("更新订单状态 - 非法状态转换（PENDING→DELIVERED）抛出异常")
    void updateOrderStatus_invalidTransition_throwsException() {
        Order order = new Order();
        order.setOrderId(1L);
        order.setOrderNo("ORD001");
        order.setStatus(OrderStatus.PENDING.getCode());

        when(orderMapper.selectById(1L)).thenReturn(order);

        ServiceException ex = assertThrows(ServiceException.class,
                () -> orderService.updateOrderStatus(1L, "DELIVERED"));
        assertTrue(ex.getMessage().contains("不允许从"));
        verify(orderMapper, never()).updateById(any(Order.class));
    }
}
