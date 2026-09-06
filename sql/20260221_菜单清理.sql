-- ========================================
-- 智能客服项目菜单清理脚本
-- 清理若依框架中与项目无关的默认菜单
-- 执行前请备份 sys_menu 表
-- ========================================

-- 1. 删除"若依官网"外链 (menu_id=4)
DELETE FROM sys_menu WHERE menu_id = 4;

-- 2. 删除"系统监控"整个目录 (menu_id=2) 及所有子菜单
-- 在线用户 (109) 及其按钮
DELETE FROM sys_menu WHERE menu_id IN (109, 1046, 1047, 1048);
-- 定时任务 (110) 及其按钮
DELETE FROM sys_menu WHERE menu_id IN (110, 1049, 1050, 1051, 1052, 1053, 1054);
-- 数据监控 (111)
DELETE FROM sys_menu WHERE menu_id = 111;
-- 服务监控 (112)
DELETE FROM sys_menu WHERE menu_id = 112;
-- 缓存监控 (113)
DELETE FROM sys_menu WHERE menu_id = 113;
-- 缓存列表 (114)
DELETE FROM sys_menu WHERE menu_id = 114;
-- 删除"系统监控"目录本身 (2)
DELETE FROM sys_menu WHERE menu_id = 2;

-- 3. 删除"系统工具"整个目录 (menu_id=3) 及所有子菜单
-- 表单构建 (115)
DELETE FROM sys_menu WHERE menu_id = 115;
-- 代码生成 (116) 及其按钮
DELETE FROM sys_menu WHERE menu_id IN (116, 1055, 1056, 1057, 1058, 1059, 1060);
-- 系统接口 (117)
DELETE FROM sys_menu WHERE menu_id = 117;
-- 删除"系统工具"目录本身 (3)
DELETE FROM sys_menu WHERE menu_id = 3;

-- 4. 删除系统管理下不需要的子菜单
-- 部门管理 (103) 及其按钮
DELETE FROM sys_menu WHERE menu_id IN (103, 1016, 1017, 1018, 1019);
-- 岗位管理 (104) 及其按钮
DELETE FROM sys_menu WHERE menu_id IN (104, 1020, 1021, 1022, 1023, 1024);
-- 参数设置 (106) 及其按钮
DELETE FROM sys_menu WHERE menu_id IN (106, 1030, 1031, 1032, 1033, 1034);
-- 通知公告 (107) 及其按钮
DELETE FROM sys_menu WHERE menu_id IN (107, 1035, 1036, 1037, 1038);

-- 5. 清理角色-菜单关联表中的孤立记录
DELETE FROM sys_role_menu WHERE menu_id NOT IN (SELECT menu_id FROM sys_menu);
