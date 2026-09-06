-- 会话置顶功能：为 ai_chat_session 表添加置顶字段
-- 使用动态查询判断字段是否已存在，避免重复执行报错

-- 添加 is_pinned 字段（0=未置顶, 1=已置顶）
SET @db_name = DATABASE();
SET @table_name = 'ai_chat_session';

-- 检查并添加 is_pinned 字段
SELECT COUNT(*) INTO @col_exists
FROM information_schema.columns
WHERE table_schema = @db_name AND table_name = @table_name AND column_name = 'is_pinned';

SET @sql = IF(@col_exists = 0,
    'ALTER TABLE ai_chat_session ADD COLUMN is_pinned TINYINT DEFAULT 0 COMMENT ''是否置顶：0否 1是''',
    'SELECT ''is_pinned column already exists''');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 检查并添加 pin_time 字段
SELECT COUNT(*) INTO @col_exists2
FROM information_schema.columns
WHERE table_schema = @db_name AND table_name = @table_name AND column_name = 'pin_time';

SET @sql2 = IF(@col_exists2 = 0,
    'ALTER TABLE ai_chat_session ADD COLUMN pin_time DATETIME DEFAULT NULL COMMENT ''置顶时间''',
    'SELECT ''pin_time column already exists''');
PREPARE stmt2 FROM @sql2;
EXECUTE stmt2;
DEALLOCATE PREPARE stmt2;
