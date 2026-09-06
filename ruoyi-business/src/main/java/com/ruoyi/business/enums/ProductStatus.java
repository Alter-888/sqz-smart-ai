package com.ruoyi.business.enums;

import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * 商品状态枚举
 */
@Getter
@AllArgsConstructor
public enum ProductStatus {

    OFF_SHELF(0, "下架"),
    ON_SHELF(1, "上架");

    private final Integer code;
    private final String desc;

    public static ProductStatus fromCode(Integer code) {
        for (ProductStatus status : values()) {
            if (status.getCode().equals(code)) {
                return status;
            }
        }
        throw new IllegalArgumentException("未知商品状态: " + code);
    }
}
