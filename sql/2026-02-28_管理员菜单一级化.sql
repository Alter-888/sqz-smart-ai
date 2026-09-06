-- =============================================
-- 管理员菜单一级化
-- 将智能客服、业务管理目录下的菜单提升为一级菜单
-- 仅保留系统管理的二级结构
-- 执行前提：已执行过 2026-02-28_菜单一级化.sql
-- =============================================

-- 1. 将"智能客服"目录下的子菜单提升为一级菜单
--    parent_id 改为 0, path 改为顶级路由格式
UPDATE sys_menu
   SET parent_id = 0, order_num = 1, path = 'ai-dashboard'
 WHERE menu_id = (
   SELECT t.menu_id FROM (
     SELECT menu_id FROM sys_menu WHERE menu_name = '数据仪表盘' AND menu_type = 'C'
   ) t
 );

UPDATE sys_menu
   SET parent_id = 0, order_num = 2, path = 'ai-chat'
 WHERE menu_id = (
   SELECT t.menu_id FROM (
     SELECT menu_id FROM sys_menu WHERE menu_name = 'AI 对话' AND menu_type = 'C' AND parent_id != 0
   ) t
 );

UPDATE sys_menu
   SET parent_id = 0, order_num = 3, path = 'ai-knowledge'
 WHERE menu_id = (
   SELECT t.menu_id FROM (
     SELECT menu_id FROM sys_menu WHERE menu_name = '知识库管理' AND menu_type = 'C'
   ) t
 );

-- 2. 将"业务管理"目录下的子菜单提升为一级菜单
UPDATE sys_menu
   SET parent_id = 0, order_num = 4, path = 'biz-product'
 WHERE menu_id = (
   SELECT t.menu_id FROM (
     SELECT menu_id FROM sys_menu WHERE menu_name = '商品管理' AND menu_type = 'C'
   ) t
 );

UPDATE sys_menu
   SET parent_id = 0, order_num = 5, path = 'biz-order'
 WHERE menu_id = (
   SELECT t.menu_id FROM (
     SELECT menu_id FROM sys_menu WHERE menu_name = '订单管理' AND menu_type = 'C'
   ) t
 );

UPDATE sys_menu
   SET parent_id = 0, order_num = 6, path = 'biz-ticket'
 WHERE menu_id = (
   SELECT t.menu_id FROM (
     SELECT menu_id FROM sys_menu WHERE menu_name = '工单管理' AND menu_type = 'C'
   ) t
 );

-- 3. 调整用户端专属菜单排序
UPDATE sys_menu SET order_num = 7 WHERE menu_id = 2031 AND menu_name = '商品中心';
UPDATE sys_menu SET order_num = 8 WHERE menu_id = 2032 AND menu_name = '我的订单';
UPDATE sys_menu SET order_num = 9 WHERE menu_id = 2033 AND menu_name = '我的工单';

-- 4. 系统管理放最后（保留二级目录不变）
UPDATE sys_menu SET order_num = 10 WHERE menu_id = 1 AND menu_name = '系统管理';

-- 5. 删除已空的目录菜单（智能客服、业务管理）
DELETE FROM sys_menu
 WHERE menu_name = '智能客服' AND menu_type = 'M' AND parent_id = 0;

DELETE FROM sys_menu
 WHERE menu_name = '业务管理' AND menu_type = 'M' AND parent_id = 0;

-- 6. 删除重复的用户端"AI 对话"一级菜单(menu_id=2030)
--    此菜单由菜单一级化.sql创建，与步骤1中提升的管理员AI对话(2001)功能完全重复
DELETE FROM sys_role_menu WHERE menu_id = 2030;
DELETE FROM sys_menu WHERE menu_id = 2030 AND menu_name = 'AI 对话';

-- 7. 更新普通角色(role_id=2)权限：用提升后的AI对话替换已删除的2030
INSERT IGNORE INTO sys_role_menu (role_id, menu_id)
SELECT 2, menu_id FROM sys_menu
 WHERE menu_name = 'AI 对话' AND menu_type = 'C' AND parent_id = 0
 LIMIT 1;
