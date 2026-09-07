-- =============================================================================
-- 说明：P3 审计与在线指标收尾 —— ai_chat_turn_audit 补齐 failure_count / is_timeout / eval_score / eval_reason + 组合索引
-- 前置：sql/2026-09-06_sqz_多智能体P4审计字段.sql 已执行（intent/agent_id/route_source/rag_enabled/retry_count 已存在）
-- 幂等：全部用 information_schema 动态判断，可反复执行；全新环境先跑 P4 审计字段脚本再跑本脚本
-- =============================================================================

SET @db_name = DATABASE();
SET @tbl = 'ai_chat_turn_audit';

-- P3: failure_count 重试耗尽失败次数
SET @col='failure_count'; SET @ddl='ADD COLUMN `failure_count` INT DEFAULT 0 COMMENT ''P3重试耗尽失败次数''';
SET @exists=(SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=@db_name AND TABLE_NAME=@tbl AND COLUMN_NAME=@col);
SET @sql=IF(@exists=0, CONCAT('ALTER TABLE `',@tbl,'` ',@ddl), 'SELECT ''skip failure_count''');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- P3: is_timeout 是否超时失败
SET @col='is_timeout'; SET @ddl='ADD COLUMN `is_timeout` TINYINT DEFAULT 0 COMMENT ''P3是否超时失败''';
SET @exists=(SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=@db_name AND TABLE_NAME=@tbl AND COLUMN_NAME=@col);
SET @sql=IF(@exists=0, CONCAT('ALTER TABLE `',@tbl,'` ',@ddl), 'SELECT ''skip is_timeout''');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- P3: eval_score 异步抽检得分（P7 Evaluator 回写，未抽到为 NULL）
SET @col='eval_score'; SET @ddl='ADD COLUMN `eval_score` DECIMAL(3,1) NULL COMMENT ''P7异步抽检得分0-5''';
SET @exists=(SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=@db_name AND TABLE_NAME=@tbl AND COLUMN_NAME=@col);
SET @sql=IF(@exists=0, CONCAT('ALTER TABLE `',@tbl,'` ',@ddl), 'SELECT ''skip eval_score''');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- P3: eval_reason 异步抽检理由
SET @col='eval_reason'; SET @ddl='ADD COLUMN `eval_reason` VARCHAR(500) NULL COMMENT ''P7异步抽检理由''';
SET @exists=(SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=@db_name AND TABLE_NAME=@tbl AND COLUMN_NAME=@col);
SET @sql=IF(@exists=0, CONCAT('ALTER TABLE `',@tbl,'` ',@ddl), 'SELECT ''skip eval_reason''');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- P3: 组合索引（时间 + 意图），指标查询全部按此聚合
SET @idx='idx_audit_intent_time';
SET @exists=(SELECT COUNT(*) FROM information_schema.STATISTICS WHERE TABLE_SCHEMA=@db_name AND TABLE_NAME=@tbl AND INDEX_NAME=@idx);
SET @sql=IF(@exists=0, CONCAT('ALTER TABLE `',@tbl,'` ADD INDEX `',@idx,'` (`create_time`,`intent`)'), 'SELECT ''skip idx''');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;