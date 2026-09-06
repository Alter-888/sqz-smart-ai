package com.ruoyi.business.service;

import cn.hutool.core.util.IdUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.ruoyi.business.constant.BusinessConstants;
import com.ruoyi.business.entity.Order;
import com.ruoyi.business.entity.OrderItem;
import com.ruoyi.business.entity.Product;
import com.ruoyi.business.enums.OrderStatus;
import com.ruoyi.business.enums.OrderStatusTransition;
import com.ruoyi.business.mapper.OrderItemMapper;
import com.ruoyi.business.mapper.OrderMapper;
import com.ruoyi.business.mapper.ProductMapper;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.SecurityUtils;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class OrderService {

    private static final Logger log = LoggerFactory.getLogger(OrderService.class);

    private final OrderMapper orderMapper;
    private final OrderItemMapper orderItemMapper;
    private final ProductMapper productMapper;
    private final NotificationService notificationService;

    public IPage<Order> listOrders(int pageNum, int pageSize, String orderNo, String status) {
        Page<Order> page = new Page<>(pageNum, pageSize);
        LambdaQueryWrapper<Order> wrapper = new LambdaQueryWrapper<>();
        if (orderNo != null && !orderNo.isEmpty()) {
            wrapper.like(Order::getOrderNo, orderNo);
        }
        if (status != null && !status.isEmpty()) {
            wrapper.eq(Order::getStatus, status);
        }
        wrapper.orderByDesc(Order::getCreateTime);
        IPage<Order> result = orderMapper.selectPage(page, wrapper);
        fillNickNames(result.getRecords());
        fillItemSummary(result.getRecords());
        return result;
    }

    public IPage<Order> listUserOrders(Long userId, int pageNum, int pageSize) {
        return listUserOrders(userId, pageNum, pageSize, null, null);
    }

    public IPage<Order> listUserOrders(Long userId, int pageNum, int pageSize, String orderNo, String status) {
        Page<Order> page = new Page<>(pageNum, pageSize);
        LambdaQueryWrapper<Order> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Order::getUserId, userId);
        if (orderNo != null && !orderNo.isEmpty()) {
            wrapper.like(Order::getOrderNo, orderNo);
        }
        if (status != null && !status.isEmpty()) {
            wrapper.eq(Order::getStatus, status);
        }
        wrapper.orderByDesc(Order::getCreateTime);
        return orderMapper.selectPage(page, wrapper);
    }

    public Order getById(Long orderId) {
        return orderMapper.selectById(orderId);
    }

    /**
     * 验证订单归属权：非管理员只能访问自己的订单
     */
    public void validateOrderOwnership(Long orderId, Long userId) {
        if (SecurityUtils.isAdmin(userId)) {
            return;
        }
        Order order = orderMapper.selectById(orderId);
        if (order == null) {
            throw new ServiceException("订单不存在");
        }
        if (!order.getUserId().equals(userId)) {
            throw new ServiceException("无权访问该订单");
        }
    }

    public Order getByOrderNo(String orderNo) {
        LambdaQueryWrapper<Order> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Order::getOrderNo, orderNo);
        return orderMapper.selectOne(wrapper);
    }

    public List<OrderItem> getOrderItems(Long orderId) {
        LambdaQueryWrapper<OrderItem> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(OrderItem::getOrderId, orderId);
        List<OrderItem> items = orderItemMapper.selectList(wrapper);
        // 填充商品图片
        for (OrderItem item : items) {
            Product product = productMapper.selectById(item.getProductId());
            if (product != null) {
                item.setImageUrl(product.getImageUrl());
            }
        }
        return items;
    }

    /**
     * 创建订单（含库存扣减、事务保护）
     */
    @Transactional(rollbackFor = Exception.class)
    public Order createOrder(Long userId, String address, String remark, List<OrderItem> items) {
        if (items == null || items.isEmpty()) {
            throw new ServiceException("订单项不能为空");
        }

        BigDecimal totalAmount = BigDecimal.ZERO;

        // 校验商品存在性和库存，并扣减库存
        for (OrderItem item : items) {
            Product product = productMapper.selectById(item.getProductId());
            if (product == null) {
                throw new ServiceException("商品不存在: " + item.getProductId());
            }
            if (product.getStatus() == null || product.getStatus() != 1) {
                throw new ServiceException("商品已下架: " + product.getName());
            }
            // 乐观锁扣减库存
            int rows = productMapper.deductStock(item.getProductId(), item.getQuantity());
            if (rows == 0) {
                throw new ServiceException("商品库存不足: " + product.getName());
            }
            // 填充订单项信息
            item.setProductName(product.getName());
            item.setPrice(product.getPrice());
            totalAmount = totalAmount.add(product.getPrice().multiply(BigDecimal.valueOf(item.getQuantity())));
        }

        // 生成订单
        Order order = new Order();
        order.setOrderNo(BusinessConstants.ORDER_NO_PREFIX + IdUtil.getSnowflakeNextIdStr());
        order.setUserId(userId);
        order.setTotalAmount(totalAmount);
        order.setStatus(OrderStatus.PENDING.getCode());
        order.setAddress(address);
        order.setRemark(remark);
        orderMapper.insert(order);

        // 创建订单项
        for (OrderItem item : items) {
            item.setOrderId(order.getOrderId());
            orderItemMapper.insert(item);
        }

        log.info("订单创建成功: {}, 用户: {}, 金额: {}, 订单项: {}",
                order.getOrderNo(), userId, totalAmount, items.size());
        return order;
    }

    /**
     * 更新订单状态（集成状态机校验）
     */
    @Transactional(rollbackFor = Exception.class)
    public void updateOrderStatus(Long orderId, String status) {
        updateOrderStatus(orderId, status, null, null);
    }

    /**
     * 更新订单状态（支持物流信息传入）
     */
    @Transactional(rollbackFor = Exception.class)
    public void updateOrderStatus(Long orderId, String status, String logisticsNo, String logisticsCompany) {
        // 校验目标状态码合法性
        OrderStatus targetStatus = OrderStatus.fromCode(status);
        Order order = orderMapper.selectById(orderId);
        if (order == null) {
            throw new ServiceException("订单不存在");
        }
        OrderStatus currentStatus = OrderStatus.fromCode(order.getStatus());

        // 幂等短路：目标状态与当前状态相同则跳过
        if (order.getStatus().equals(status)) {
            log.info("订单状态无需更新，已为目标状态: orderNo={}, status={}", order.getOrderNo(), status);
            return;
        }

        // 状态机校验
        if (!OrderStatusTransition.canTransition(currentStatus, targetStatus)) {
            throw new ServiceException("不允许从 " + currentStatus.getDesc() + " 转换为 " + targetStatus.getDesc());
        }

        String oldStatus = order.getStatus();
        order.setStatus(status);

        // 记录关键时间点
        if (targetStatus == OrderStatus.PAID) {
            order.setPayTime(LocalDateTime.now());
        } else if (targetStatus == OrderStatus.SHIPPED) {
            order.setShipTime(LocalDateTime.now());
            if (logisticsNo != null && !logisticsNo.isEmpty()) {
                order.setLogisticsNo(logisticsNo);
            }
            if (logisticsCompany != null && !logisticsCompany.isEmpty()) {
                order.setLogisticsCompany(logisticsCompany);
            }
        }

        orderMapper.updateById(order);
        log.info("订单状态更新: {}, {} -> {}", order.getOrderNo(), oldStatus, status);

        // 取消或退款时恢复库存
        if (targetStatus == OrderStatus.CANCELLED || targetStatus == OrderStatus.REFUNDED) {
            List<OrderItem> items = orderItemMapper.selectList(
                    new LambdaQueryWrapper<OrderItem>().eq(OrderItem::getOrderId, orderId));
            for (OrderItem item : items) {
                productMapper.restoreStock(item.getProductId(), item.getQuantity());
            }
            log.info("订单库存已恢复: {}, 恢复商品项数: {}", order.getOrderNo(), items.size());
        }

        // 发送通知
        notificationService.createNotification(
                order.getUserId(),
                "订单状态变更",
                "您的订单 " + order.getOrderNo() + " 状态已更新为: " + targetStatus.getDesc(),
                "ORDER_STATUS",
                order.getOrderId()
        );
    }

    public void updateOrder(Order order) {
        orderMapper.updateById(order);
    }

    /**
     * 用户订单统计（各状态数量 + 待付金额）
     */
    public Map<String, Object> getUserOrderStats(Long userId) {
        LambdaQueryWrapper<Order> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Order::getUserId, userId);
        List<Order> orders = orderMapper.selectList(wrapper);

        Map<String, Long> statusCounts = orders.stream()
                .collect(Collectors.groupingBy(Order::getStatus, Collectors.counting()));

        BigDecimal pendingAmount = orders.stream()
                .filter(o -> OrderStatus.PENDING.getCode().equals(o.getStatus()))
                .map(Order::getTotalAmount)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        Map<String, Object> stats = new java.util.LinkedHashMap<>();
        stats.put("totalCount", orders.size());
        stats.put("pendingCount", statusCounts.getOrDefault("PENDING", 0L));
        stats.put("paidCount", statusCounts.getOrDefault("PAID", 0L));
        stats.put("shippedCount", statusCounts.getOrDefault("SHIPPED", 0L));
        stats.put("deliveredCount", statusCounts.getOrDefault("DELIVERED", 0L));
        stats.put("cancelledCount", statusCounts.getOrDefault("CANCELLED", 0L));
        stats.put("refundedCount", statusCounts.getOrDefault("REFUNDED", 0L));
        stats.put("pendingAmount", pendingAmount);
        return stats;
    }

    /**
     * 管理员订单统计（全部订单各状态数量 + 待付金额 + 营业收入 + 今日新增）
     */
    public Map<String, Object> getAdminOrderStats() {
        List<Order> orders = orderMapper.selectList(null);

        Map<String, Long> statusCounts = orders.stream()
                .collect(Collectors.groupingBy(Order::getStatus, Collectors.counting()));

        BigDecimal pendingAmount = orders.stream()
                .filter(o -> OrderStatus.PENDING.getCode().equals(o.getStatus()))
                .map(Order::getTotalAmount)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        // 营业收入：已付款+已发货+已签收的订单金额合计
        BigDecimal totalRevenue = orders.stream()
                .filter(o -> {
                    String s = o.getStatus();
                    return OrderStatus.PAID.getCode().equals(s)
                            || OrderStatus.SHIPPED.getCode().equals(s)
                            || OrderStatus.DELIVERED.getCode().equals(s);
                })
                .map(Order::getTotalAmount)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        // 今日新增订单数
        java.time.LocalDate today = java.time.LocalDate.now();
        long todayCount = orders.stream()
                .filter(o -> o.getCreateTime() != null && o.getCreateTime().toLocalDate().equals(today))
                .count();

        Map<String, Object> stats = new java.util.LinkedHashMap<>();
        stats.put("totalCount", orders.size());
        stats.put("pendingCount", statusCounts.getOrDefault("PENDING", 0L));
        stats.put("paidCount", statusCounts.getOrDefault("PAID", 0L));
        stats.put("shippedCount", statusCounts.getOrDefault("SHIPPED", 0L));
        stats.put("deliveredCount", statusCounts.getOrDefault("DELIVERED", 0L));
        stats.put("cancelledCount", statusCounts.getOrDefault("CANCELLED", 0L));
        stats.put("refundedCount", statusCounts.getOrDefault("REFUNDED", 0L));
        stats.put("pendingAmount", pendingAmount);
        stats.put("totalRevenue", totalRevenue);
        stats.put("todayCount", todayCount);
        return stats;
    }

    /**
     * 不分页全量查询（导出用）
     */
    public List<Order> listAllOrders(String orderNo, String status) {
        LambdaQueryWrapper<Order> wrapper = new LambdaQueryWrapper<>();
        if (orderNo != null && !orderNo.isEmpty()) {
            wrapper.like(Order::getOrderNo, orderNo);
        }
        if (status != null && !status.isEmpty()) {
            wrapper.eq(Order::getStatus, status);
        }
        wrapper.orderByDesc(Order::getCreateTime);
        return orderMapper.selectList(wrapper);
    }

    /**
     * 批量填充订单列表中的用户昵称
     */
    private void fillNickNames(List<Order> orders) {
        if (orders == null || orders.isEmpty()) {
            return;
        }
        List<Long> userIds = orders.stream()
                .map(Order::getUserId)
                .distinct()
                .collect(Collectors.toList());
        try {
            Map<Long, Map<String, Object>> nickMap = orderMapper.selectUserNickNames(userIds);
            for (Order order : orders) {
                Map<String, Object> userInfo = nickMap.get(order.getUserId());
                if (userInfo != null) {
                    order.setNickName((String) userInfo.get("nickName"));
                }
            }
        } catch (Exception e) {
            log.warn("批量查询用户昵称失败: {}", e.getMessage());
        }
    }

    /**
     * 批量填充订单列表中的商品摘要信息（首件名称、图片、总件数）
     */
    private void fillItemSummary(List<Order> orders) {
        if (orders == null || orders.isEmpty()) {
            return;
        }
        List<Long> orderIds = orders.stream()
                .map(Order::getOrderId)
                .collect(Collectors.toList());
        try {
            // 批量查询所有订单项
            LambdaQueryWrapper<OrderItem> itemWrapper = new LambdaQueryWrapper<>();
            itemWrapper.in(OrderItem::getOrderId, orderIds);
            List<OrderItem> allItems = orderItemMapper.selectList(itemWrapper);

            // 批量查询商品图片
            List<Long> productIds = allItems.stream()
                    .map(OrderItem::getProductId)
                    .filter(id -> id != null)
                    .distinct()
                    .collect(Collectors.toList());
            Map<Long, String> imageMap = new java.util.HashMap<>();
            if (!productIds.isEmpty()) {
                List<Product> products = productMapper.selectBatchIds(productIds);
                for (Product p : products) {
                    imageMap.put(p.getProductId(), p.getImageUrl());
                }
            }

            // 按订单分组并填充
            Map<Long, List<OrderItem>> itemsByOrder = allItems.stream()
                    .collect(Collectors.groupingBy(OrderItem::getOrderId));
            for (Order order : orders) {
                List<OrderItem> items = itemsByOrder.get(order.getOrderId());
                if (items != null && !items.isEmpty()) {
                    OrderItem firstItem = items.get(0);
                    order.setFirstItemName(firstItem.getProductName());
                    order.setFirstItemImage(imageMap.get(firstItem.getProductId()));
                    order.setItemCount(items.stream().mapToInt(OrderItem::getQuantity).sum());
                }
            }
        } catch (Exception e) {
            log.warn("批量填充商品摘要失败: {}", e.getMessage());
        }
    }
}
