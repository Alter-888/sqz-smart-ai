-- =============================================
-- !! 已废弃 - 请勿执行 !!
-- 本脚本的内容已合并到 2026-02-28_管理员菜单角色化.sql（最终版）中
-- 该脚本已包含 2044(AI对话) 的创建和排序调整
-- 重复执行本脚本会导致 menu_id=2044 主键冲突
-- =============================================

-- 以下为原始内容，仅作历史记录保留
-- （原）补丁：AI对话归入用户端页面
-- （原）前提：已执行过 2026-02-28_管理员菜单角色化.sql（第一版）

-- INSERT INTO sys_menu VALUES (2044, 'AI 对话', 2040, 1, 'ai-chat', 'ai/chat/index', NULL, 'UserAiChat', 1, 0, 'C', '0', '0', 'ai:chat:list', 'message', 'admin', sysdate(), '', NULL, '管理员视角-用户AI对话');
-- UPDATE sys_menu SET order_num = 2 WHERE menu_id = 2041 AND menu_name = '商品中心';
-- UPDATE sys_menu SET order_num = 3 WHERE menu_id = 2042 AND menu_name = '我的订单';
-- UPDATE sys_menu SET order_num = 4 WHERE menu_id = 2043 AND menu_name = '我的工单';
-- DELETE FROM sys_role_menu WHERE role_id = 1;
-- INSERT INTO sys_role_menu (role_id, menu_id) SELECT DISTINCT 1, menu_id FROM sys_menu WHERE menu_id NOT IN (2031, 2032, 2033, 2034, 2035) AND NOT (menu_name = 'AI 对话' AND menu_type = 'C' AND parent_id = 0) AND status = '0';
