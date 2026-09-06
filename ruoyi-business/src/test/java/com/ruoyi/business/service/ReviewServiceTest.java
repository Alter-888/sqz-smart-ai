package com.ruoyi.business.service;

import com.ruoyi.business.entity.Order;
import com.ruoyi.business.entity.OrderItem;
import com.ruoyi.business.mapper.OrderItemMapper;
import com.ruoyi.business.mapper.OrderMapper;
import com.ruoyi.business.mapper.ProductMapper;
import com.ruoyi.business.mapper.ReviewMapper;
import com.ruoyi.common.exception.ServiceException;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.when;

/**
 * ReviewService 核心方法单元测试
 */
@ExtendWith(MockitoExtension.class)
class ReviewServiceTest {

    @Mock
    private ReviewMapper reviewMapper;
    @Mock
    private OrderMapper orderMapper;
    @Mock
    private OrderItemMapper orderItemMapper;
    @Mock
    private ProductMapper productMapper;

    @InjectMocks
    private ReviewService reviewService;

    @Test
    @DisplayName("检查评价状态 - 订单项不属于当前用户时抛出异常")
    void hasReviewed_wrongUser_throwsException() {
        OrderItem item = new OrderItem();
        item.setItemId(100L);
        item.setOrderId(10L);
        when(orderItemMapper.selectById(100L)).thenReturn(item);

        Order order = new Order();
        order.setOrderId(10L);
        order.setUserId(999L); // 属于其他用户
        when(orderMapper.selectById(10L)).thenReturn(order);

        ServiceException ex = assertThrows(ServiceException.class,
                () -> reviewService.hasReviewed(100L, 1L));
        assertEquals("该订单项不属于当前用户", ex.getMessage());
    }
}
