-- 工单多轮沟通：新建回复表，工单增加优先级和指派字段

-- 创建工单回复表
CREATE TABLE IF NOT EXISTS `biz_ticket_reply` (
  `reply_id`    bigint       NOT NULL AUTO_INCREMENT COMMENT '回复ID',
  `ticket_id`   bigint       NOT NULL                COMMENT '工单ID',
  `user_id`     bigint       NOT NULL                COMMENT '回复用户ID',
  `content`     text         NOT NULL                COMMENT '回复内容',
  `reply_type`  varchar(20)  NOT NULL DEFAULT 'USER' COMMENT '回复类型: USER(用户)/STAFF(客服)/SYSTEM(系统)',
  `create_time` datetime     DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`reply_id`),
  KEY `idx_ticket_id` (`ticket_id`),
  KEY `idx_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='工单回复表';

-- biz_ticket 增加 priority 字段（0普通/1紧急/2特急）
SET @col_exists = (SELECT COUNT(*) FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'biz_ticket' AND COLUMN_NAME = 'priority');
SET @sql = IF(@col_exists = 0,
    'ALTER TABLE biz_ticket ADD COLUMN priority int DEFAULT 0 COMMENT ''优先级: 0普通/1紧急/2特急'' AFTER status',
    'SELECT ''priority 字段已存在，跳过''');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- biz_ticket 增加 assignee_id 字段（指派客服）
SET @col_exists = (SELECT COUNT(*) FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'biz_ticket' AND COLUMN_NAME = 'assignee_id');
SET @sql = IF(@col_exists = 0,
    'ALTER TABLE biz_ticket ADD COLUMN assignee_id bigint DEFAULT NULL COMMENT ''指派客服ID'' AFTER priority',
    'SELECT ''assignee_id 字段已存在，跳过''');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
