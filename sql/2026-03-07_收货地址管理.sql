-- 用户收货地址表
CREATE TABLE biz_address (
    address_id   BIGINT       NOT NULL AUTO_INCREMENT COMMENT '地址ID',
    user_id      BIGINT       NOT NULL                COMMENT '用户ID',
    contact_name VARCHAR(50)  NOT NULL                COMMENT '收货人姓名',
    phone        VARCHAR(20)  NOT NULL                COMMENT '手机号码',
    province     VARCHAR(50)  DEFAULT ''              COMMENT '省',
    city         VARCHAR(50)  DEFAULT ''              COMMENT '市',
    district     VARCHAR(50)  DEFAULT ''              COMMENT '区',
    detail       VARCHAR(200) NOT NULL                COMMENT '详细地址',
    is_default   TINYINT      DEFAULT 0               COMMENT '是否默认(0否1是)',
    create_time  DATETIME     DEFAULT CURRENT_TIMESTAMP,
    update_time  DATETIME     DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (address_id),
    INDEX idx_user_id (user_id)
) ENGINE=InnoDB COMMENT='用户收货地址表';
