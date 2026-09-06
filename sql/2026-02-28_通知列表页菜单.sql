-- =============================================
-- 补丁：通知列表页菜单
-- 为普通用户和管理员分别注册通知历史菜单
-- 前提：已执行过 2026-02-28_管理员菜单角色化.sql
--       已执行过 2026-02-28_用户下单权限.sql（占用了2036）
-- =============================================

-- 1. 普通用户：新增一级菜单"我的通知"（与商品中心/我的订单/我的工单同级）
--    注意：2036已被"用户下单权限"占用，此处使用2037
INSERT INTO sys_menu VALUES (2037, '我的通知', 0, 5, 'my-notification', 'business/notification/index', NULL, '', 1, 0, 'C', '0', '0', 'business:notification:list', 'message', 'admin', sysdate(), '', NULL, '用户端通知历史');

-- 2. 管理员"用户端页面"目录下也加入"我的通知"子菜单
INSERT INTO sys_menu VALUES (2045, '我的通知', 2040, 5, 'my-notification', 'business/notification/index', NULL, 'UserMyNotification', 1, 0, 'C', '0', '0', 'business:notification:list', 'message', 'admin', sysdate(), '', NULL, '管理员视角-用户通知历史');

-- 3. 普通用户角色(role_id=2)分配该菜单
INSERT INTO sys_role_menu VALUES (2, 2037);

-- 4. 管理员角色(role_id=1)分配该菜单
INSERT INTO sys_role_menu VALUES (1, 2045);
