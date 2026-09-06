-- 订单流程增强：biz_order 增加 pay_time, ship_time 字段
-- 使用动态查询后 ALTER，避免不同环境操作不一致

-- 添加 pay_time 字段（付款时间）
SET @col_exists = (SELECT COUNT(*) FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'biz_order' AND COLUMN_NAME = 'pay_time');
SET @sql = IF(@col_exists = 0,
    'ALTER TABLE biz_order ADD COLUMN pay_time datetime DEFAULT NULL COMMENT ''付款时间'' AFTER status',
    'SELECT ''pay_time 字段已存在，跳过''');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 添加 ship_time 字段（发货时间）
SET @col_exists = (SELECT COUNT(*) FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'biz_order' AND COLUMN_NAME = 'ship_time');
SET @sql = IF(@col_exists = 0,
    'ALTER TABLE biz_order ADD COLUMN ship_time datetime DEFAULT NULL COMMENT ''发货时间'' AFTER pay_time',
    'SELECT ''ship_time 字段已存在，跳过''');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
