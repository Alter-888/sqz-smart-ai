package com.ruoyi.business.service;

import cn.hutool.core.util.IdUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.ruoyi.business.constant.BusinessConstants;
import com.ruoyi.business.entity.Ticket;
import com.ruoyi.business.entity.TicketReply;
import com.ruoyi.business.enums.TicketStatus;
import com.ruoyi.business.entity.Order;
import com.ruoyi.business.enums.OrderStatus;
import com.ruoyi.business.mapper.TicketMapper;
import com.ruoyi.business.mapper.TicketReplyMapper;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.SecurityUtils;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class TicketService {

    private static final Logger log = LoggerFactory.getLogger(TicketService.class);

    private final TicketMapper ticketMapper;
    private final TicketReplyMapper ticketReplyMapper;
    private final NotificationService notificationService;
    private final OrderService orderService;

    public IPage<Ticket> listTickets(int pageNum, int pageSize, String status, String type) {
        return listTickets(pageNum, pageSize, status, type, null);
    }

    public IPage<Ticket> listTickets(int pageNum, int pageSize, String status, String type, Integer priority) {
        Page<Ticket> page = new Page<>(pageNum, pageSize);
        LambdaQueryWrapper<Ticket> wrapper = new LambdaQueryWrapper<>();
        if (status != null && !status.isEmpty()) {
            wrapper.eq(Ticket::getStatus, status);
        }
        if (type != null && !type.isEmpty()) {
            wrapper.eq(Ticket::getType, type);
        }
        if (priority != null) {
            wrapper.eq(Ticket::getPriority, priority);
        }
        wrapper.orderByDesc(Ticket::getCreateTime);
        return ticketMapper.selectPage(page, wrapper);
    }

    public IPage<Ticket> listUserTickets(Long userId, int pageNum, int pageSize) {
        return listUserTickets(userId, pageNum, pageSize, null, null);
    }

    public IPage<Ticket> listUserTickets(Long userId, int pageNum, int pageSize, String type, String status) {
        Page<Ticket> page = new Page<>(pageNum, pageSize);
        LambdaQueryWrapper<Ticket> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Ticket::getUserId, userId);
        if (type != null && !type.isEmpty()) {
            wrapper.eq(Ticket::getType, type);
        }
        if (status != null && !status.isEmpty()) {
            wrapper.eq(Ticket::getStatus, status);
        }
        wrapper.orderByDesc(Ticket::getCreateTime);
        return ticketMapper.selectPage(page, wrapper);
    }

    public Ticket getById(Long ticketId) {
        return ticketMapper.selectById(ticketId);
    }

    /**
     * 验证工单归属权：非管理员只能访问自己的工单
     */
    public void validateTicketOwnership(Long ticketId, Long userId) {
        if (SecurityUtils.isAdmin(userId)) {
            return;
        }
        Ticket ticket = ticketMapper.selectById(ticketId);
        if (ticket == null) {
            throw new ServiceException("工单不存在");
        }
        if (!ticket.getUserId().equals(userId)) {
            throw new ServiceException("无权访问该工单");
        }
    }

    public Ticket getByTicketNo(String ticketNo) {
        LambdaQueryWrapper<Ticket> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Ticket::getTicketNo, ticketNo);
        return ticketMapper.selectOne(wrapper);
    }

    public Ticket createTicket(Ticket ticket) {
        ticket.setTicketNo(BusinessConstants.TICKET_NO_PREFIX + IdUtil.getSnowflakeNextIdStr());
        ticket.setStatus(TicketStatus.OPEN.getCode());
        if (ticket.getPriority() == null) {
            ticket.setPriority(0);
        }
        // 退款/退货退款工单自动设置退款进度为待审核
        if ("REFUND".equals(ticket.getType()) || "EXCHANGE".equals(ticket.getType())) {
            ticket.setRefundStatus("PENDING_REVIEW");
        }
        // 订单关联校验
        if (ticket.getOrderId() != null) {
            Order order = orderService.getById(ticket.getOrderId());
            if (order == null) {
                throw new ServiceException("关联订单不存在");
            }
            if (!order.getUserId().equals(ticket.getUserId())) {
                throw new ServiceException("不能对他人订单创建工单");
            }
            if ("REFUND".equals(ticket.getType()) || "EXCHANGE".equals(ticket.getType())) {
                String orderStatus = order.getStatus();
                if (!OrderStatus.PAID.getCode().equals(orderStatus)
                        && !OrderStatus.SHIPPED.getCode().equals(orderStatus)
                        && !OrderStatus.DELIVERED.getCode().equals(orderStatus)) {
                    throw new ServiceException("当前订单状态不支持退款");
                }
            }
        }
        ticketMapper.insert(ticket);
        log.info("工单创建成功: {}, 类型: {}, 用户ID: {}", ticket.getTicketNo(), ticket.getType(), ticket.getUserId());
        return ticket;
    }

    /**
     * 兼容保留：回复工单（同时写入回复表）
     */
    public void replyTicket(Long ticketId, String reply) {
        Ticket ticket = ticketMapper.selectById(ticketId);
        if (ticket == null) {
            throw new ServiceException("工单不存在");
        }
        ticket.setReply(reply);
        ticket.setStatus(TicketStatus.RESOLVED.getCode());
        ticketMapper.updateById(ticket);

        // 同步写入回复表
        TicketReply ticketReply = new TicketReply();
        ticketReply.setTicketId(ticketId);
        ticketReply.setUserId(0L);
        ticketReply.setContent(reply);
        ticketReply.setReplyType("STAFF");
        ticketReplyMapper.insert(ticketReply);

        log.info("工单回复完成: {}", ticket.getTicketNo());
    }

    /**
     * 多轮回复：添加回复记录
     * 客服回复自动将 OPEN 状态改为 PROCESSING
     */
    public TicketReply addReply(Long ticketId, Long userId, String content, String replyType) {
        Ticket ticket = ticketMapper.selectById(ticketId);
        if (ticket == null) {
            throw new ServiceException("工单不存在");
        }
        if (TicketStatus.CLOSED.getCode().equals(ticket.getStatus())) {
            throw new ServiceException("工单已关闭，不可回复");
        }

        TicketReply reply = new TicketReply();
        reply.setTicketId(ticketId);
        reply.setUserId(userId);
        reply.setContent(content);
        reply.setReplyType(replyType);
        ticketReplyMapper.insert(reply);

        // 客服回复时，自动将 OPEN 状态改为 PROCESSING
        if ("STAFF".equals(replyType) && TicketStatus.OPEN.getCode().equals(ticket.getStatus())) {
            ticket.setStatus(TicketStatus.PROCESSING.getCode());
            ticketMapper.updateById(ticket);
            log.info("工单状态自动更新为处理中: {}", ticket.getTicketNo());
        }

        log.info("工单回复添加: ticketNo={}, replyType={}, userId={}", ticket.getTicketNo(), replyType, userId);

        // 客服回复后通知用户
        if ("STAFF".equals(replyType)) {
            notificationService.createNotification(
                    ticket.getUserId(),
                    "工单回复",
                    "您的工单 " + ticket.getTicketNo() + " 收到新的客服回复",
                    "TICKET_REPLY",
                    ticketId
            );
        }

        return reply;
    }

    /**
     * 获取工单回复记录列表
     */
    public List<TicketReply> getTicketReplies(Long ticketId) {
        LambdaQueryWrapper<TicketReply> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(TicketReply::getTicketId, ticketId);
        wrapper.orderByAsc(TicketReply::getCreateTime);
        return ticketReplyMapper.selectList(wrapper);
    }

    /**
     * 关闭工单
     */
    public void closeTicket(Long ticketId) {
        Ticket ticket = ticketMapper.selectById(ticketId);
        if (ticket == null) {
            throw new ServiceException("工单不存在");
        }
        if (TicketStatus.CLOSED.getCode().equals(ticket.getStatus())) {
            throw new ServiceException("工单已是关闭状态");
        }
        ticket.setStatus(TicketStatus.CLOSED.getCode());
        ticketMapper.updateById(ticket);
        log.info("工单关闭: {}", ticket.getTicketNo());
    }

    /**
     * 指派客服
     */
    public void assignTicket(Long ticketId, Long assigneeId) {
        Ticket ticket = ticketMapper.selectById(ticketId);
        if (ticket == null) {
            throw new ServiceException("工单不存在");
        }
        ticket.setAssigneeId(assigneeId);
        ticketMapper.updateById(ticket);
        log.info("工单指派: {} -> 客服ID: {}", ticket.getTicketNo(), assigneeId);
    }

    public void deleteTicket(Long ticketId) {
        Ticket ticket = ticketMapper.selectById(ticketId);
        if (ticket == null) {
            throw new ServiceException("工单不存在");
        }
        ticketMapper.deleteById(ticketId);
        log.info("工单删除成功: {}", ticket.getTicketNo());
    }

    /**
     * 管理端工单统计（全量，各状态数量）
     */
    public Map<String, Object> getAllTicketStats() {
        List<Ticket> tickets = ticketMapper.selectList(null);
        Map<String, Long> statusCounts = tickets.stream()
                .collect(Collectors.groupingBy(Ticket::getStatus, Collectors.counting()));
        Map<String, Object> stats = new LinkedHashMap<>();
        stats.put("totalCount", tickets.size());
        stats.put("openCount", statusCounts.getOrDefault("OPEN", 0L));
        stats.put("processingCount", statusCounts.getOrDefault("PROCESSING", 0L));
        stats.put("resolvedCount", statusCounts.getOrDefault("RESOLVED", 0L));
        stats.put("closedCount", statusCounts.getOrDefault("CLOSED", 0L));
        return stats;
    }

    /**
     * 用户工单统计（各状态数量）
     */
    public Map<String, Object> getUserTicketStats(Long userId) {
        LambdaQueryWrapper<Ticket> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Ticket::getUserId, userId);
        List<Ticket> tickets = ticketMapper.selectList(wrapper);

        Map<String, Long> statusCounts = tickets.stream()
                .collect(Collectors.groupingBy(Ticket::getStatus, Collectors.counting()));

        Map<String, Object> stats = new LinkedHashMap<>();
        stats.put("totalCount", tickets.size());
        stats.put("openCount", statusCounts.getOrDefault("OPEN", 0L));
        stats.put("processingCount", statusCounts.getOrDefault("PROCESSING", 0L));
        stats.put("resolvedCount", statusCounts.getOrDefault("RESOLVED", 0L));
        stats.put("closedCount", statusCounts.getOrDefault("CLOSED", 0L));
        return stats;
    }

    /**
     * 不分页全量查询（导出用）
     */
    public List<Ticket> listAllTickets(String status, String type) {
        LambdaQueryWrapper<Ticket> wrapper = new LambdaQueryWrapper<>();
        if (status != null && !status.isEmpty()) {
            wrapper.eq(Ticket::getStatus, status);
        }
        if (type != null && !type.isEmpty()) {
            wrapper.eq(Ticket::getType, type);
        }
        wrapper.orderByDesc(Ticket::getCreateTime);
        return ticketMapper.selectList(wrapper);
    }

    /**
     * 同意退款（管理员操作）
     */
    public void approveRefund(Long ticketId) {
        Ticket ticket = ticketMapper.selectById(ticketId);
        if (ticket == null) {
            throw new ServiceException("工单不存在");
        }
        if (!"REFUND".equals(ticket.getType()) && !"EXCHANGE".equals(ticket.getType())) {
            throw new ServiceException("该工单不支持退款操作");
        }
        if (!"PENDING_REVIEW".equals(ticket.getRefundStatus())) {
            throw new ServiceException("当前退款状态不允许此操作");
        }
        ticket.setRefundStatus("APPROVED");
        ticketMapper.updateById(ticket);
        log.info("退款工单已同意: {}", ticket.getTicketNo());

        // 系统回复通知用户（区分仅退款/退货退款）
        String approveMsg = "EXCHANGE".equals(ticket.getType())
                ? "您的退货申请已审核通过，请将商品寄回，我们收到后将为您办理退款。"
                : "您的退款申请已审核通过，等待退款处理。";
        TicketReply reply = new TicketReply();
        reply.setTicketId(ticketId);
        reply.setUserId(0L);
        reply.setContent(approveMsg);
        reply.setReplyType("SYSTEM");
        ticketReplyMapper.insert(reply);

        notificationService.createNotification(
                ticket.getUserId(), "退款审核通过",
                "您的工单 " + ticket.getTicketNo() + " 退款申请已通过审核",
                "TICKET_REFUND", ticketId
        );
    }

    /**
     * 确认退款（管理员操作）- 联动订单状态改为 REFUNDED + 恢复库存
     */
    @Transactional(rollbackFor = Exception.class)
    public void confirmRefund(Long ticketId) {
        Ticket ticket = ticketMapper.selectById(ticketId);
        if (ticket == null) {
            throw new ServiceException("工单不存在");
        }
        if (!"REFUND".equals(ticket.getType()) && !"EXCHANGE".equals(ticket.getType())) {
            throw new ServiceException("该工单不支持退款操作");
        }
        if (!"APPROVED".equals(ticket.getRefundStatus())) {
            throw new ServiceException("请先同意退款再执行确认退款");
        }
        ticket.setRefundStatus("REFUNDED");
        ticket.setStatus(TicketStatus.RESOLVED.getCode());
        ticketMapper.updateById(ticket);
        log.info("退款工单已确认退款: {}", ticket.getTicketNo());

        // 联动订单状态（与工单在同一事务中，失败则整体回滚，保证数据一致性）
        if (ticket.getOrderId() != null) {
            orderService.updateOrderStatus(ticket.getOrderId(), "REFUNDED");
            log.info("退款联动：订单 {} 状态已改为 REFUNDED", ticket.getOrderId());
        }

        // 系统回复（区分仅退款/退货退款）
        String confirmMsg = "EXCHANGE".equals(ticket.getType())
                ? "已确认收货并完成退款，退款金额：¥" + (ticket.getRefundAmount() != null ? ticket.getRefundAmount() : "0") + "，请注意查收。"
                : "退款已完成，退款金额：¥" + (ticket.getRefundAmount() != null ? ticket.getRefundAmount() : "0") + "，请注意查收。";
        TicketReply reply = new TicketReply();
        reply.setTicketId(ticketId);
        reply.setUserId(0L);
        reply.setContent(confirmMsg);
        reply.setReplyType("SYSTEM");
        ticketReplyMapper.insert(reply);

        notificationService.createNotification(
                ticket.getUserId(), "退款已完成",
                "您的工单 " + ticket.getTicketNo() + " 退款已完成",
                "TICKET_REFUND", ticketId
        );
    }

    /**
     * 拒绝退款（管理员操作）
     */
    public void rejectRefund(Long ticketId, String reason) {
        Ticket ticket = ticketMapper.selectById(ticketId);
        if (ticket == null) {
            throw new ServiceException("工单不存在");
        }
        if (!"REFUND".equals(ticket.getType()) && !"EXCHANGE".equals(ticket.getType())) {
            throw new ServiceException("该工单不支持退款操作");
        }
        if (!"PENDING_REVIEW".equals(ticket.getRefundStatus())) {
            throw new ServiceException("当前退款状态不允许此操作");
        }
        ticket.setRefundStatus("REJECTED");
        ticketMapper.updateById(ticket);
        log.info("退款工单已拒绝: {}, 原因: {}", ticket.getTicketNo(), reason);

        // 系统回复
        TicketReply reply = new TicketReply();
        reply.setTicketId(ticketId);
        reply.setUserId(0L);
        reply.setContent("您的退款申请已被拒绝。原因：" + (reason != null ? reason : "未说明"));
        reply.setReplyType("SYSTEM");
        ticketReplyMapper.insert(reply);

        notificationService.createNotification(
                ticket.getUserId(), "退款被拒绝",
                "您的工单 " + ticket.getTicketNo() + " 退款申请被拒绝，原因：" + (reason != null ? reason : "未说明"),
                "TICKET_REFUND", ticketId
        );
    }

    /**
     * 标记工单已解决（管理员操作，用于投诉/咨询类工单）
     */
    public void resolveTicket(Long ticketId) {
        Ticket ticket = ticketMapper.selectById(ticketId);
        if (ticket == null) {
            throw new ServiceException("工单不存在");
        }
        if (TicketStatus.CLOSED.getCode().equals(ticket.getStatus())) {
            throw new ServiceException("工单已关闭，无法标记为已解决");
        }
        if (TicketStatus.RESOLVED.getCode().equals(ticket.getStatus())) {
            throw new ServiceException("工单已是已解决状态");
        }
        ticket.setStatus(TicketStatus.RESOLVED.getCode());
        ticketMapper.updateById(ticket);
        log.info("工单已标记为已解决: {}", ticket.getTicketNo());

        // 系统消息
        TicketReply reply = new TicketReply();
        reply.setTicketId(ticketId);
        reply.setUserId(0L);
        reply.setContent("工单已标记为已解决。");
        reply.setReplyType("SYSTEM");
        ticketReplyMapper.insert(reply);

        notificationService.createNotification(
                ticket.getUserId(), "工单已解决",
                "您的工单 " + ticket.getTicketNo() + " 已标记为已解决",
                "TICKET_RESOLVED", ticketId
        );
    }
}
