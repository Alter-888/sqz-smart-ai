-- =============================================
-- 管理员菜单角色化
-- 让admin也通过角色权限(sys_role_menu)加载侧边栏菜单
-- 配合后端SysMenuServiceImpl.selectMenuTreeByUserId的修改
-- 实现：管理员看到"用户端页面"收纳目录，普通用户保持平铺
-- 执行前提：已执行过 2026-02-28_管理员菜单一级化.sql
-- =============================================

-- ========== 第一步：创建管理员专属的"用户端页面"目录 ==========

-- 创建"用户端页面"一级目录（menu_type='M'），排序在工单管理(6)之后、系统管理(10)之前
INSERT INTO sys_menu VALUES (2040, '用户端页面', 0, 7, 'user-pages', NULL, NULL, '', 1, 0, 'M', '0', '0', '', 'peoples', 'admin', sysdate(), '', NULL, '管理员查看的用户端功能集合');

-- 在目录下创建子菜单，指向与普通用户相同的Vue组件
-- 使用显式route_name避免与普通用户的平铺菜单路由名冲突
-- AI对话也归入用户端页面（管理员不需要客服聊天功能，该功能是面向普通用户的）
INSERT INTO sys_menu VALUES (2044, 'AI 对话',  2040, 1, 'ai-chat',      'ai/chat/index',        NULL, 'UserAiChat',     1, 0, 'C', '0', '0', 'ai:chat:list',        'message',  'admin', sysdate(), '', NULL, '管理员视角-用户AI对话');
INSERT INTO sys_menu VALUES (2041, '商品中心', 2040, 2, 'shop-product', 'shop/product/index',   NULL, 'UserShopProduct', 1, 0, 'C', '0', '0', 'shop:product:list',   'shopping', 'admin', sysdate(), '', NULL, '管理员视角-用户商品浏览');
INSERT INTO sys_menu VALUES (2042, '我的订单', 2040, 3, 'my-order',     'business/order/my',    NULL, 'UserMyOrder',     1, 0, 'C', '0', '0', 'business:order:my',   'list',     'admin', sysdate(), '', NULL, '管理员视角-用户订单列表');
INSERT INTO sys_menu VALUES (2043, '我的工单', 2040, 4, 'my-ticket',    'business/ticket/my',   NULL, 'UserMyTicket',    1, 0, 'C', '0', '0', 'business:ticket:my',  'form',     'admin', sysdate(), '', NULL, '管理员视角-用户工单列表');

-- ========== 第二步：为管理员角色(role_id=1)配置菜单权限 ==========
-- 之前admin通过代码特殊处理看到所有菜单，现改为通过sys_role_menu控制
-- admin的操作权限(*:*:*)不受影响，仅控制侧边栏显示

-- 清空管理员角色的旧菜单关联（可能为空）
DELETE FROM sys_role_menu WHERE role_id = 1;

-- 给管理员角色分配菜单，排除：
--   1. 普通用户专属的平铺菜单 (2031-2037)
--      2031-2033: 商品中心/我的订单/我的工单（一级菜单）
--      2034-2035: 工单创建/工单回复（按钮）
--      2036: 用户下单（按钮）
--      2037: 我的通知（一级菜单）
--   2. 顶级AI对话菜单（menu_id是auto_increment，通过名称+类型+parent_id动态匹配）
--      该菜单已收纳到"用户端页面"目录下的2044子菜单中
-- 普通用户的role_menu不受影响，仍能看到平铺的AI对话和其他菜单
INSERT INTO sys_role_menu (role_id, menu_id)
SELECT DISTINCT 1, menu_id FROM sys_menu
WHERE menu_id NOT IN (2031, 2032, 2033, 2034, 2035, 2036, 2037)
  AND NOT (menu_name = 'AI 对话' AND menu_type = 'C' AND parent_id = 0)
  AND status = '0';

-- ========== 执行结果说明 ==========
-- 管理员侧边栏将显示：
--   知识库管理 | 商品管理 | 订单管理 | 工单管理
--   用户端页面 ▸ (AI对话 / 商品中心 / 我的订单 / 我的工单 / 我的通知)
--   系统管理 ▸ (用户管理 / 角色管理 / ...)
--
-- 普通用户侧边栏：
--   AI对话 | 商品中心 | 我的订单 | 我的工单 | 我的通知
