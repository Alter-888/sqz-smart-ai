-- ============================================================
-- P1-2：RAG 溯源 + 审计记录
-- 日期：2026-03-04
-- 说明：
--   (A) ai_tool_call_log 增加 success_flag / duration_ms / error_msg 字段
--   (B) 新建 ai_chat_turn_audit 审计表
-- ============================================================

-- --------------------------------------------------------
-- (A) ai_tool_call_log 增加 3 个字段（动态查询确保幂等）
-- --------------------------------------------------------

-- 增加 success_flag 字段
SET @db_name = DATABASE();
SET @tbl = 'ai_tool_call_log';
SET @col = 'success_flag';
SET @exists = (SELECT COUNT(*) FROM information_schema.COLUMNS
               WHERE TABLE_SCHEMA = @db_name AND TABLE_NAME = @tbl AND COLUMN_NAME = @col);
SET @sql = IF(@exists = 0,
    CONCAT('ALTER TABLE `', @tbl, '` ADD COLUMN `success_flag` TINYINT DEFAULT 1 COMMENT ''1成功 0失败'''),
    'SELECT ''Column success_flag already exists''');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 增加 duration_ms 字段
SET @col = 'duration_ms';
SET @exists = (SELECT COUNT(*) FROM information_schema.COLUMNS
               WHERE TABLE_SCHEMA = @db_name AND TABLE_NAME = @tbl AND COLUMN_NAME = @col);
SET @sql = IF(@exists = 0,
    CONCAT('ALTER TABLE `', @tbl, '` ADD COLUMN `duration_ms` BIGINT DEFAULT NULL COMMENT ''执行耗时(毫秒)'''),
    'SELECT ''Column duration_ms already exists''');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 增加 error_msg 字段
SET @col = 'error_msg';
SET @exists = (SELECT COUNT(*) FROM information_schema.COLUMNS
               WHERE TABLE_SCHEMA = @db_name AND TABLE_NAME = @tbl AND COLUMN_NAME = @col);
SET @sql = IF(@exists = 0,
    CONCAT('ALTER TABLE `', @tbl, '` ADD COLUMN `error_msg` VARCHAR(500) DEFAULT NULL COMMENT ''错误信息'''),
    'SELECT ''Column error_msg already exists''');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- --------------------------------------------------------
-- (B) 新建 ai_chat_turn_audit 审计表
-- --------------------------------------------------------

CREATE TABLE IF NOT EXISTS `ai_chat_turn_audit` (
    `audit_id`      BIGINT       NOT NULL AUTO_INCREMENT COMMENT '审计记录ID',
    `session_id`    BIGINT       DEFAULT NULL             COMMENT '会话ID',
    `user_id`       BIGINT       DEFAULT NULL             COMMENT '用户ID',
    `user_message`  TEXT                                  COMMENT '用户消息',
    `ai_response`   TEXT                                  COMMENT 'AI回复',
    `rag_source`    JSON         DEFAULT NULL             COMMENT 'RAG检索来源(JSON)',
    `tool_calls`    JSON         DEFAULT NULL             COMMENT '工具调用列表(JSON)',
    `duration_ms`   BIGINT       DEFAULT NULL             COMMENT '本轮对话耗时(毫秒)',
    `has_rag_hit`   TINYINT      DEFAULT 0                COMMENT '是否命中RAG: 1是 0否',
    `create_time`   DATETIME     DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    PRIMARY KEY (`audit_id`),
    KEY `idx_session_id` (`session_id`),
    KEY `idx_user_id` (`user_id`),
    KEY `idx_create_time` (`create_time`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_general_ci
  COMMENT = 'AI对话轮次审计表';
