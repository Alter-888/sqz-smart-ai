-- =============================================================================
-- 说明：P4 多智能体路由 + Worker + 编排 —— 审计表 ai_chat_turn_audit 补字段
-- 用途：记录每轮对话的意图、命中领域 Agent、路由来源（rule/llm/fallback）、是否挂RAG、重试次数。
--       Dashboard/AI 指标页据此按 rag_enabled=1 口径计算 RAG 命中率等。
--
-- ⚠️ 执行顺序：本表已存在，直接执行即可。若为全新环境，请先启动应用（MyBatis-Plus 建表）
--     再执行本脚本；或先执行 sql/2026-03-04_RAG溯源与审计记录.sql 建表后执行本脚本。
-- =============================================================================

-- P4: intent 意图
SET @col = 'intent';
SET @sql = IF((SELECT COUNT(*) FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'ai_chat_turn_audit' AND COLUMN_NAME = @col) = 0,
    'ALTER TABLE `ai_chat_turn_audit` ADD COLUMN `intent` VARCHAR(32) DEFAULT NULL COMMENT ''P4意图: PRODUCT/ORDER/AFTERSALES/ACCOUNT/KNOWLEDGE/CHITCHAT/HUMAN_HANDOFF''',
    'SELECT ''Column intent already exists''');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- P4: agent_id 领域Worker
SET @col = 'agent_id';
SET @sql = IF((SELECT COUNT(*) FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'ai_chat_turn_audit' AND COLUMN_NAME = @col) = 0,
    'ALTER TABLE `ai_chat_turn_audit` ADD COLUMN `agent_id` VARCHAR(64) DEFAULT NULL COMMENT ''P4命中领域: sales-advisor/order-service/after-sales/account/knowledge''',
    'SELECT ''Column agent_id already exists''');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- P4: route_source 路由来源
SET @col = 'route_source';
SET @sql = IF((SELECT COUNT(*) FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'ai_chat_turn_audit' AND COLUMN_NAME = @col) = 0,
    'ALTER TABLE `ai_chat_turn_audit` ADD COLUMN `route_source` VARCHAR(16) DEFAULT NULL COMMENT ''P4路由来源: rule/llm/fallback''',
    'SELECT ''Column route_source already exists''');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- P4: rag_enabled 该域是否挂RAG
SET @col = 'rag_enabled';
SET @sql = IF((SELECT COUNT(*) FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'ai_chat_turn_audit' AND COLUMN_NAME = @col) = 0,
    'ALTER TABLE `ai_chat_turn_audit` ADD COLUMN `rag_enabled` TINYINT DEFAULT 0 COMMENT ''P4是否挂RAG: order-service/account为0,其余为1''',
    'SELECT ''Column rag_enabled already exists''');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- P4: retry_count 重试次数
SET @col = 'retry_count';
SET @sql = IF((SELECT COUNT(*) FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'ai_chat_turn_audit' AND COLUMN_NAME = @col) = 0,
    'ALTER TABLE `ai_chat_turn_audit` ADD COLUMN `retry_count` INT DEFAULT 0 COMMENT ''P4重试次数''',
    'SELECT ''Column retry_count already exists''');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
