-- =============================================
-- 模块2：角色权限收敛
-- 普通角色(role_id=2)从全量权限收敛为仅用户侧功能
-- =============================================

-- 1. 新增用户端菜单
INSERT INTO `sys_menu` VALUES (2020, '用户服务', 0, 3, 'user-service', NULL, NULL, '', 1, 0, 'M', '0', '0', '', 'peoples', 'admin', sysdate(), '', NULL, '用户服务目录');
INSERT INTO `sys_menu` VALUES (2021, '商品中心', 2020, 1, 'shop-product', 'shop/product/index', NULL, '', 1, 0, 'C', '0', '0', 'shop:product:list', 'shopping', 'admin', sysdate(), '', NULL, '用户商品浏览');
INSERT INTO `sys_menu` VALUES (2022, '我的订单', 2020, 2, 'my-order', 'business/order/my', NULL, '', 1, 0, 'C', '0', '0', 'business:order:my', 'list', 'admin', sysdate(), '', NULL, '用户订单列表');
INSERT INTO `sys_menu` VALUES (2023, '我的工单', 2020, 3, 'my-ticket', 'business/ticket/my', NULL, '', 1, 0, 'C', '0', '0', 'business:ticket:my', 'form', 'admin', sysdate(), '', NULL, '用户工单列表');
INSERT INTO `sys_menu` VALUES (2024, '工单创建', 2023, 1, '', NULL, NULL, '', 1, 0, 'F', '0', '0', 'business:ticket:add', '#', 'admin', sysdate(), '', NULL, '');
INSERT INTO `sys_menu` VALUES (2025, '工单回复', 2023, 2, '', NULL, NULL, '', 1, 0, 'F', '0', '0', 'business:ticket:reply', '#', 'admin', sysdate(), '', NULL, '');

-- 2. 清除普通角色(role_id=2)全部旧权限
DELETE FROM `sys_role_menu` WHERE role_id = 2;

-- 3. 仅分配用户侧权限
INSERT INTO `sys_role_menu` VALUES (2, 2000);  -- 智能客服目录
INSERT INTO `sys_role_menu` VALUES (2, 2001);  -- AI对话
INSERT INTO `sys_role_menu` VALUES (2, 2020);  -- 用户服务目录
INSERT INTO `sys_role_menu` VALUES (2, 2021);  -- 商品中心
INSERT INTO `sys_role_menu` VALUES (2, 2022);  -- 我的订单
INSERT INTO `sys_role_menu` VALUES (2, 2023);  -- 我的工单
INSERT INTO `sys_role_menu` VALUES (2, 2024);  -- 工单创建
INSERT INTO `sys_role_menu` VALUES (2, 2025);  -- 工单回复
