-- =============================================
-- 首页改造：删除数据仪表盘菜单
-- 仪表盘内容已迁移到管理员首页，无需独立菜单入口
-- =============================================

-- 1. 删除数据仪表盘的角色-菜单关联
--    menu_id 是 auto_increment 生成的，使用名称动态匹配
DELETE rm FROM sys_role_menu rm
INNER JOIN sys_menu m ON rm.menu_id = m.menu_id
WHERE m.menu_name = '数据仪表盘' AND m.menu_type = 'C' AND m.parent_id = 0;

-- 2. 删除数据仪表盘菜单本身
DELETE FROM sys_menu
WHERE menu_name = '数据仪表盘' AND menu_type = 'C' AND parent_id = 0;
