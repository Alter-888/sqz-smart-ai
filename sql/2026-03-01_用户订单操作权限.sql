-- =============================================
-- 修复：普通用户无法支付、取消、确认收货订单
-- 原因：role_id=2 缺少 business:order:status 权限
-- menu_id=2015 对应 '订单状态修改' 按钮权限
-- =============================================

-- 动态查询 menu_id 再插入，避免不同环境 ID 不一致
INSERT IGNORE INTO sys_role_menu (role_id, menu_id)
SELECT 2, menu_id FROM sys_menu
WHERE perms = 'business:order:status' AND menu_type = 'F';
