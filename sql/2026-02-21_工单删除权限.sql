-- 工单删除按钮权限
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time)
SELECT '工单删除', menu_id, 3, '', NULL, 1, 0, 'F', '0', '0', 'business:ticket:remove', '#', 'admin', sysdate()
FROM sys_menu WHERE perms = 'business:ticket:list' LIMIT 1;

-- 给管理员角色赋予工单删除权限
INSERT INTO sys_role_menu (role_id, menu_id)
SELECT 1, menu_id FROM sys_menu WHERE perms = 'business:ticket:remove' LIMIT 1;
