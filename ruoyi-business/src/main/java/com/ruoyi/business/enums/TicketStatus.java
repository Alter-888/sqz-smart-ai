package com.ruoyi.business.enums;

import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * 工单状态枚举
 */
@Getter
@AllArgsConstructor
public enum TicketStatus {

    OPEN("OPEN", "待处理"),
    PROCESSING("PROCESSING", "处理中"),
    RESOLVED("RESOLVED", "已解决"),
    CLOSED("CLOSED", "已关闭");

    private final String code;
    private final String desc;

    public static TicketStatus fromCode(String code) {
        for (TicketStatus status : values()) {
            if (status.getCode().equals(code)) {
                return status;
            }
        }
        throw new IllegalArgumentException("未知工单状态: " + code);
    }
}
