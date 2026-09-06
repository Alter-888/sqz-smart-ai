package com.ruoyi.ai.enums;

import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * 知识库文档处理状态枚举
 */
@Getter
@AllArgsConstructor
public enum KnowledgeDocStatus {

    PENDING("PENDING", "待处理"),
    PROCESSING("PROCESSING", "处理中"),
    COMPLETED("COMPLETED", "已完成"),
    FAILED("FAILED", "失败");

    private final String code;
    private final String desc;

    public static KnowledgeDocStatus fromCode(String code) {
        for (KnowledgeDocStatus status : values()) {
            if (status.getCode().equals(code)) {
                return status;
            }
        }
        throw new IllegalArgumentException("未知文档状态: " + code);
    }
}
