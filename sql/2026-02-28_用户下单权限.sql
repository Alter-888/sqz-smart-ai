-- =============================================
-- 用户下单权限补充
-- 普通用户(role_id=2)需要 business:order:add 权限才能下单
-- =============================================

-- 在"我的订单"(menu_id=2032)下新增下单按钮权限
INSERT INTO `sys_menu` VALUES (2036, '用户下单', 2032, 1, '', NULL, NULL, '', 1, 0, 'F', '0', '0', 'business:order:add', '#', 'admin', sysdate(), '', NULL, '');

-- 分配给普通角色
INSERT INTO `sys_role_menu` VALUES (2, 2036);
