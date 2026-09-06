package com.ruoyi.business.service;

import com.ruoyi.business.entity.Order;
import com.ruoyi.business.entity.Ticket;
import com.ruoyi.business.enums.OrderStatus;
import com.ruoyi.business.enums.TicketStatus;
import com.ruoyi.business.mapper.TicketMapper;
import com.ruoyi.business.mapper.TicketReplyMapper;
import com.ruoyi.common.exception.ServiceException;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

/**
 * TicketService 核心方法单元测试
 */
@ExtendWith(MockitoExtension.class)
class TicketServiceTest {

    @Mock
    private TicketMapper ticketMapper;
    @Mock
    private TicketReplyMapper ticketReplyMapper;
    @Mock
    private NotificationService notificationService;
    @Mock
    private OrderService orderService;

    @InjectMocks
    private TicketService ticketService;

    // ======================== createTicket ========================

    @Test
    @DisplayName("创建工单 - 正常流程：关联订单校验通过")
    void createTicket_withOrder_success() {
        Order order = new Order();
        order.setOrderId(10L);
        order.setUserId(1L);
        order.setStatus(OrderStatus.DELIVERED.getCode());
        when(orderService.getById(10L)).thenReturn(order);
        when(ticketMapper.insert(any(Ticket.class))).thenReturn(1);

        Ticket ticket = new Ticket();
        ticket.setUserId(1L);
        ticket.setOrderId(10L);
        ticket.setType("COMPLAINT");
        ticket.setTitle("商品有问题");

        Ticket result = ticketService.createTicket(ticket);

        assertNotNull(result);
        assertEquals(TicketStatus.OPEN.getCode(), result.getStatus());
        assertTrue(result.getTicketNo().startsWith("TK"));
        verify(ticketMapper).insert(any(Ticket.class));
    }

    @Test
    @DisplayName("创建工单 - 关联的订单不属于当前用户")
    void createTicket_wrongOwner_throwsException() {
        Order order = new Order();
        order.setOrderId(10L);
        order.setUserId(999L); // 其他用户的订单
        when(orderService.getById(10L)).thenReturn(order);

        Ticket ticket = new Ticket();
        ticket.setUserId(1L);
        ticket.setOrderId(10L);
        ticket.setType("COMPLAINT");

        ServiceException ex = assertThrows(ServiceException.class,
                () -> ticketService.createTicket(ticket));
        assertEquals("不能对他人订单创建工单", ex.getMessage());
        verify(ticketMapper, never()).insert(any(Ticket.class));
    }

    @Test
    @DisplayName("创建工单 - 退款类型但订单状态为PENDING，拒绝创建")
    void createTicket_refundOnPendingOrder_throwsException() {
        Order order = new Order();
        order.setOrderId(10L);
        order.setUserId(1L);
        order.setStatus(OrderStatus.PENDING.getCode()); // 待付款不能退款
        when(orderService.getById(10L)).thenReturn(order);

        Ticket ticket = new Ticket();
        ticket.setUserId(1L);
        ticket.setOrderId(10L);
        ticket.setType("REFUND");

        ServiceException ex = assertThrows(ServiceException.class,
                () -> ticketService.createTicket(ticket));
        assertEquals("当前订单状态不支持退款", ex.getMessage());
        verify(ticketMapper, never()).insert(any(Ticket.class));
    }

    // ======================== closeTicket ========================

    @Test
    @DisplayName("关闭工单 - 已关闭的工单再次关闭抛出异常")
    void closeTicket_alreadyClosed_throwsException() {
        Ticket ticket = new Ticket();
        ticket.setTicketId(1L);
        ticket.setTicketNo("TK001");
        ticket.setStatus(TicketStatus.CLOSED.getCode());
        when(ticketMapper.selectById(1L)).thenReturn(ticket);

        ServiceException ex = assertThrows(ServiceException.class,
                () -> ticketService.closeTicket(1L));
        assertEquals("工单已是关闭状态", ex.getMessage());
        verify(ticketMapper, never()).updateById(any(Ticket.class));
    }
}
