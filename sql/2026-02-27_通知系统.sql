-- 通知系统

CREATE TABLE IF NOT EXISTS `biz_notification` (
  `notification_id` bigint       NOT NULL AUTO_INCREMENT COMMENT '通知ID',
  `user_id`         bigint       NOT NULL                COMMENT '接收用户ID',
  `title`           varchar(200) NOT NULL                COMMENT '通知标题',
  `content`         text                                 COMMENT '通知内容',
  `type`            varchar(30)  NOT NULL                COMMENT '通知类型: ORDER_STATUS/TICKET_REPLY/STOCK_WARNING',
  `ref_id`          bigint       DEFAULT NULL            COMMENT '关联业务ID',
  `is_read`         tinyint(1)   DEFAULT 0               COMMENT '是否已读: 0未读/1已读',
  `create_time`     datetime     DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`notification_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_user_read` (`user_id`, `is_read`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='通知表';
