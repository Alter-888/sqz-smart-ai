package com.ruoyi.business.enums;

import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * 订单状态枚举
 */
@Getter
@AllArgsConstructor
public enum OrderStatus {

    PENDING("PENDING", "待付款"),
    PAID("PAID", "已付款"),
    SHIPPED("SHIPPED", "已发货"),
    DELIVERED("DELIVERED", "已签收"),
    CANCELLED("CANCELLED", "已取消"),
    REFUNDED("REFUNDED", "已退款");

    private final String code;
    private final String desc;

    public static OrderStatus fromCode(String code) {
        for (OrderStatus status : values()) {
            if (status.getCode().equals(code)) {
                return status;
            }
        }
        throw new IllegalArgumentException("未知订单状态: " + code);
    }
}
