package com.ruoyi.business.event;

import com.ruoyi.business.entity.Product;
import org.springframework.context.ApplicationEvent;

/**
 * 商品变更事件：用于通知其他模块（如知识库同步）
 */
public class ProductChangeEvent extends ApplicationEvent {

    public enum ChangeType { CREATED, UPDATED, OFF_SHELF, DELETED }

    private final Product product;
    private final ChangeType changeType;

    public ProductChangeEvent(Object source, Product product, ChangeType changeType) {
        super(source);
        this.product = product;
        this.changeType = changeType;
    }

    public Product getProduct() {
        return product;
    }

    public ChangeType getChangeType() {
        return changeType;
    }
}
