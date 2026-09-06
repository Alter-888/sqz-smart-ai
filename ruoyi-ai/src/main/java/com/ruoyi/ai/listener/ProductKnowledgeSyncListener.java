package com.ruoyi.ai.listener;

import com.ruoyi.ai.service.KnowledgeService;
import com.ruoyi.business.event.ProductChangeEvent;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.event.EventListener;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Component;

/**
 * 监听商品变更事件，自动同步知识库
 */
@Component
@RequiredArgsConstructor
public class ProductKnowledgeSyncListener {

    private static final Logger log = LoggerFactory.getLogger(ProductKnowledgeSyncListener.class);

    private final KnowledgeService knowledgeService;

    @Async("docProcessExecutor")
    @EventListener
    public void onProductChange(ProductChangeEvent event) {
        try {
            switch (event.getChangeType()) {
                case CREATED, UPDATED -> knowledgeService.syncProductKnowledge(event.getProduct());
                case OFF_SHELF, DELETED -> knowledgeService.disableProductKnowledge(event.getProduct().getProductId());
            }
        } catch (Exception e) {
            log.error("商品知识同步失败: productId={}, type={}", event.getProduct().getProductId(), event.getChangeType(), e);
        }
    }
}
