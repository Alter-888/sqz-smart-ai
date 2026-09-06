package com.ruoyi.business.enums;

import java.util.EnumMap;
import java.util.Map;
import java.util.Set;

/**
 * 订单状态转换规则
 */
public class OrderStatusTransition {

    private static final Map<OrderStatus, Set<OrderStatus>> ALLOWED_TRANSITIONS = new EnumMap<>(OrderStatus.class);

    static {
        ALLOWED_TRANSITIONS.put(OrderStatus.PENDING, Set.of(OrderStatus.PAID, OrderStatus.CANCELLED));
        ALLOWED_TRANSITIONS.put(OrderStatus.PAID, Set.of(OrderStatus.SHIPPED, OrderStatus.REFUNDED));
        ALLOWED_TRANSITIONS.put(OrderStatus.SHIPPED, Set.of(OrderStatus.DELIVERED));
        ALLOWED_TRANSITIONS.put(OrderStatus.DELIVERED, Set.of(OrderStatus.REFUNDED));
        // 终态：不可转换
        ALLOWED_TRANSITIONS.put(OrderStatus.CANCELLED, Set.of());
        ALLOWED_TRANSITIONS.put(OrderStatus.REFUNDED, Set.of());
    }

    /**
     * 判断是否允许从 from 状态转换到 to 状态
     */
    public static boolean canTransition(OrderStatus from, OrderStatus to) {
        Set<OrderStatus> allowed = ALLOWED_TRANSITIONS.get(from);
        return allowed != null && allowed.contains(to);
    }

    /**
     * 获取当前状态允许的下一步状态列表
     */
    public static Set<OrderStatus> getAllowedNextStatuses(OrderStatus current) {
        return ALLOWED_TRANSITIONS.getOrDefault(current, Set.of());
    }

    private OrderStatusTransition() {
    }
}
