-- =============================================
-- 补丁：评价管理菜单
-- 日期: 2026-03-09
-- 说明: 为管理员新增评价管理菜单页面及权限按钮
-- =============================================

-- 先将用户端页面(2040)的排序从7调为8，为评价管理腾出位置
UPDATE sys_menu SET order_num = 8 WHERE menu_id = 2040 AND order_num = 7;

-- 评价管理一级菜单（排序7，紧跟工单管理之后）
INSERT INTO sys_menu VALUES (2046, '评价管理', 0, 7, 'biz-review', 'business/review/index', NULL, '', 1, 0, 'C', '0', '0', 'business:review:list', 'star', 'admin', sysdate(), '', NULL, '评价管理菜单');

-- 评价管理子权限按钮
INSERT INTO sys_menu VALUES (2047, '评价编辑', 2046, 1, '', NULL, NULL, '', 1, 0, 'F', '0', '0', 'business:review:edit', '#', 'admin', sysdate(), '', NULL, '');
INSERT INTO sys_menu VALUES (2048, '评价删除', 2046, 2, '', NULL, NULL, '', 1, 0, 'F', '0', '0', 'business:review:remove', '#', 'admin', sysdate(), '', NULL, '');

-- 管理员角色(role_id=1)分配评价管理菜单权限
INSERT INTO sys_role_menu VALUES (1, 2046);
INSERT INTO sys_role_menu VALUES (1, 2047);
INSERT INTO sys_role_menu VALUES (1, 2048);
