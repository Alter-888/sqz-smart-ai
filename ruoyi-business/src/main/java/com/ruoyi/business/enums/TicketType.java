package com.ruoyi.business.enums;

import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * 工单类型枚举
 */
@Getter
@AllArgsConstructor
public enum TicketType {

    COMPLAINT("COMPLAINT", "投诉"),
    REFUND("REFUND", "仅退款"),
    EXCHANGE("EXCHANGE", "退货退款"),
    CONSULT("CONSULT", "转人工客服");

    private final String code;
    private final String desc;

    public static TicketType fromCode(String code) {
        for (TicketType type : values()) {
            if (type.getCode().equals(code)) {
                return type;
            }
        }
        throw new IllegalArgumentException("未知工单类型: " + code);
    }
}
