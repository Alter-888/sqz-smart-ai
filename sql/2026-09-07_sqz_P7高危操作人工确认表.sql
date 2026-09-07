-- =============================================================================
-- 说明：P7 高危操作人工确认 HITL —— ai_pending_action 待确认单表（02 §十三 / 05 §3.4）
-- 幂等：CREATE TABLE IF NOT EXISTS，可反复执行；执行时机：启动应用建表后或直接执行均可（无外键依赖）
-- =============================================================================
CREATE TABLE IF NOT EXISTS `ai_pending_action` (
    `action_id`    BIGINT       NOT NULL AUTO_INCREMENT COMMENT '操作ID',
    `user_id`      BIGINT       NOT NULL                COMMENT '发起用户，确认时必须比对',
    `session_id`   BIGINT       DEFAULT NULL            COMMENT '会话ID',
    `tool_name`    VARCHAR(64)  NOT NULL                COMMENT '工具方法名，确认时二次核对白名单',
    `target_class` VARCHAR(255) NOT NULL                COMMENT '声明该方法的类全名，反射重放用',
    `param_types`  VARCHAR(500) DEFAULT NULL            COMMENT '参数类型全名，逗号分隔',
    `args_json`    JSON         DEFAULT NULL            COMMENT '位置参数JSON数组',
    `summary`      VARCHAR(255) DEFAULT NULL            COMMENT '给用户看的一句话摘要',
    `status`       VARCHAR(16)  NOT NULL DEFAULT 'PENDING' COMMENT 'PENDING/CONFIRMED/CANCELLED/EXPIRED/FAILED',
    `result`       VARCHAR(2000) DEFAULT NULL           COMMENT '执行结果或失败原因',
    `expire_time`  DATETIME     DEFAULT NULL            COMMENT '过期时间(创建+10分钟)',
    `create_time`  DATETIME     DEFAULT CURRENT_TIMESTAMP,
    `update_time`  DATETIME     DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`action_id`),
    KEY `idx_user_status` (`user_id`, `status`),
    KEY `idx_session` (`session_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='高危操作待确认单';