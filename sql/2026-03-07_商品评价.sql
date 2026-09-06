-- 商品评价表
CREATE TABLE IF NOT EXISTS biz_review (
    review_id     BIGINT       NOT NULL AUTO_INCREMENT COMMENT '评价ID',
    order_id      BIGINT       NOT NULL                COMMENT '订单ID',
    order_item_id BIGINT       NOT NULL                COMMENT '订单项ID',
    product_id    BIGINT       NOT NULL                COMMENT '商品ID',
    user_id       BIGINT       NOT NULL                COMMENT '用户ID',
    rating        TINYINT      NOT NULL                COMMENT '评分(1-5)',
    content       TEXT                                  COMMENT '评价内容',
    status        TINYINT      DEFAULT 1               COMMENT '状态(0隐藏1显示)',
    create_time   DATETIME     DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (review_id),
    INDEX idx_product_id (product_id),
    UNIQUE KEY uk_order_item (order_item_id)
) ENGINE=InnoDB COMMENT='商品评价表';
