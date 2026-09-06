-- ============================================
-- 数据库修复脚本
-- 修复项：
--   1. 补充缺失的 business:order:add 权限菜单
--   2. 统一字符集排序规则为 utf8mb4_general_ci
--   3. 为普通角色(role_id=2) 分配业务和AI菜单权限
-- ============================================

-- ============================================
-- 1. 补充 business:order:add 权限菜单
-- ============================================

-- 先检查是否已存在，避免重复插入
SET @order_add_exists = (SELECT COUNT(*) FROM sys_menu WHERE perms = 'business:order:add');

-- 动态获取订单管理菜单的 menu_id 作为 parent_id
SET @order_parent = (SELECT menu_id FROM sys_menu WHERE perms = 'business:order:list' AND menu_type = 'C' LIMIT 1);

SET @sql = IF(@order_add_exists = 0 AND @order_parent IS NOT NULL,
    CONCAT('INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time) VALUES (''订单新增'', ', @order_parent, ', 0, '''', NULL, 1, 0, ''F'', ''0'', ''0'', ''business:order:add'', ''#'', ''admin'', sysdate())'),
    'SELECT ''business:order:add 已存在或父菜单不存在，跳过''');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 给管理员角色赋予订单新增权限（admin role_id=1 自动拥有所有权限，此处为 role_menu 表补记录）
INSERT IGNORE INTO sys_role_menu (role_id, menu_id)
SELECT 1, menu_id FROM sys_menu WHERE perms = 'business:order:add' LIMIT 1;


-- ============================================
-- 2. 统一字符集排序规则为 utf8mb4_general_ci
--    受影响表: ai_tool_call_log, biz_notification, biz_ticket_reply
-- ============================================

ALTER TABLE `ai_tool_call_log` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
ALTER TABLE `biz_notification` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
ALTER TABLE `biz_ticket_reply` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;


-- ============================================
-- 3. 为普通角色(role_id=2) 分配业务和AI菜单权限
--    使 ry 用户也能访问智能客服和业务管理模块
-- ============================================

INSERT IGNORE INTO sys_role_menu (role_id, menu_id)
SELECT 2, menu_id FROM sys_menu
WHERE perms LIKE 'ai:%' OR perms LIKE 'business:%'
   OR menu_id IN (
       SELECT menu_id FROM sys_menu WHERE menu_name IN ('智能客服', '业务管理') AND menu_type = 'M'
   );
