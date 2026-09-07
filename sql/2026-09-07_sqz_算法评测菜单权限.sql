-- =============================================================================
-- 说明：P6 离线评测 —— 「算法评测」菜单 + 按钮权限
-- 命名：2026-09-07_sqz_算法评测菜单权限.sql
-- 用途：
--   1) 顶级菜单「算法评测」：perms=ai:eval:list，component=ai/eval/index
--   2) 子按钮「跑评测」：perms=ai:eval:run（触发 POST /ai/eval/run）
-- 对齐：is_frame/is_cache/menu_type 与现有「AI 对话」菜单保持一致。
-- 幂等：先删除同 perms 的旧菜单再插入，可重复执行。
-- 说明：admin(超管) 无感；非超管角色需在「系统管理-角色-菜单权限」里勾选。
-- =============================================================================

DELETE FROM `sys_menu` WHERE `perms` IN ('ai:eval:list','ai:eval:run');

INSERT INTO `sys_menu`
(`menu_name`,`parent_id`,`order_num`,`path`,`component`,`query`,`route_name`,`is_frame`,`is_cache`,`menu_type`,`visible`,`status`,`perms`,`icon`,`create_by`,`create_time`,`remark`)
VALUES
('算法评测', 0, 3, 'ai-eval', 'ai/eval/index', NULL, '', 1, 0, 'C', '0', '0', 'ai:eval:list', 'chart', 'admin', NOW(), 'P6 离线评测列表');

SET @evalMenuId = LAST_INSERT_ID();

INSERT INTO `sys_menu`
(`menu_name`,`parent_id`,`order_num`,`path`,`component`,`query`,`route_name`,`is_frame`,`is_cache`,`menu_type`,`visible`,`status`,`perms`,`icon`,`create_by`,`create_time`,`remark`)
VALUES
('运行评测', @evalMenuId, 1, '', NULL, NULL, '', 1, 0, 'F', '0', '0', 'ai:eval:run', '#', 'admin', NOW(), 'P6 触发离线评测');
-- =============================================================================
-- 角色授权：仅「超级管理员」(role_id=1) 可见。
-- 本项目菜单树按角色授权（见 SysMenuServiceImpl.selectMenuTreeByUserId 注释），
-- 且超级管理员角色在 UI 被锁死，需用 SQL 直接写入 sys_role_menu 绕过。
-- =============================================================================

INSERT IGNORE INTO `sys_role_menu` (`role_id`,`menu_id`) VALUES (1, @evalMenuId), (1, LAST_INSERT_ID());