-- =============================================
-- 菜单一级化：普通用户菜单取消二级目录，全部改为一级菜单
-- 前提：已执行过 2026-02-28_角色权限收敛.sql
-- =============================================

-- 1. 删除旧的用户服务目录及其子菜单（仅用于普通用户，admin不需要）
DELETE FROM `sys_role_menu` WHERE menu_id IN (2020, 2021, 2022, 2023, 2024, 2025);
DELETE FROM `sys_menu` WHERE menu_id IN (2024, 2025);  -- 先删按钮（子级）
DELETE FROM `sys_menu` WHERE menu_id IN (2021, 2022, 2023);  -- 再删菜单
DELETE FROM `sys_menu` WHERE menu_id = 2020;  -- 最后删目录

-- 2. 新增一级菜单（parent_id=0, menu_type=C，SidebarItem会渲染为单独顶级菜单项）
-- 列顺序: menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark
INSERT INTO `sys_menu` VALUES (2030, 'AI 对话',  0, 1, 'ai-chat',      'ai/chat/index',        NULL, '', 1, 0, 'C', '0', '0', 'ai:chat:list',        'message',  'admin', sysdate(), '', NULL, '用户端AI对话');
INSERT INTO `sys_menu` VALUES (2031, '商品中心', 0, 2, 'shop-product', 'shop/product/index',   NULL, '', 1, 0, 'C', '0', '0', 'shop:product:list',   'shopping', 'admin', sysdate(), '', NULL, '用户端商品浏览');
INSERT INTO `sys_menu` VALUES (2032, '我的订单', 0, 3, 'my-order',     'business/order/my',    NULL, '', 1, 0, 'C', '0', '0', 'business:order:my',   'list',     'admin', sysdate(), '', NULL, '用户端订单列表');
INSERT INTO `sys_menu` VALUES (2033, '我的工单', 0, 4, 'my-ticket',    'business/ticket/my',   NULL, '', 1, 0, 'C', '0', '0', 'business:ticket:my',  'form',     'admin', sysdate(), '', NULL, '用户端工单列表');
INSERT INTO `sys_menu` VALUES (2034, '工单创建', 2033, 1, '', NULL, NULL, '', 1, 0, 'F', '0', '0', 'business:ticket:add',   '#', 'admin', sysdate(), '', NULL, '');
INSERT INTO `sys_menu` VALUES (2035, '工单回复', 2033, 2, '', NULL, NULL, '', 1, 0, 'F', '0', '0', 'business:ticket:reply', '#', 'admin', sysdate(), '', NULL, '');

-- 3. 清除role_id=2全部旧权限，重新分配一级菜单
DELETE FROM `sys_role_menu` WHERE role_id = 2;

INSERT INTO `sys_role_menu` VALUES (2, 2030);  -- AI 对话
INSERT INTO `sys_role_menu` VALUES (2, 2031);  -- 商品中心
INSERT INTO `sys_role_menu` VALUES (2, 2032);  -- 我的订单
INSERT INTO `sys_role_menu` VALUES (2, 2033);  -- 我的工单
INSERT INTO `sys_role_menu` VALUES (2, 2034);  -- 工单创建按钮
INSERT INTO `sys_role_menu` VALUES (2, 2035);  -- 工单回复按钮
