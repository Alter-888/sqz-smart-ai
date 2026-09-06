-- 购物车系统建表
-- 设计要点：无需 cart 头表，user_id + product_id 唯一键即为隐式购物车

CREATE TABLE biz_cart_item (
    cart_item_id BIGINT NOT NULL AUTO_INCREMENT COMMENT '购物车项ID',
    user_id      BIGINT NOT NULL                COMMENT '用户ID',
    product_id   BIGINT NOT NULL                COMMENT '商品ID',
    quantity     INT    NOT NULL DEFAULT 1       COMMENT '数量',
    checked      TINYINT NOT NULL DEFAULT 1      COMMENT '是否选中(0否1是)',
    create_time  DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time  DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (cart_item_id),
    UNIQUE KEY uk_user_product (user_id, product_id),
    INDEX idx_user_id (user_id)
) ENGINE=InnoDB COMMENT='购物车项表';
