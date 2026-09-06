-- =============================================
-- 隐藏字典管理和菜单管理菜单入口
-- 说明：仅隐藏菜单显示，不删除数据和后端代码
--       系统底层功能（动态路由、权限、字典数据读取）不受影响
-- =============================================

-- 1. 隐藏菜单管理（menu_id = 102）
UPDATE sys_menu SET visible = '1' WHERE menu_id = 102;

-- 2. 隐藏字典管理（menu_id = 105）
UPDATE sys_menu SET visible = '1' WHERE menu_id = 105;

-- 验证修改结果
SELECT menu_id, menu_name, visible,
       CASE visible WHEN '0' THEN '显示' WHEN '1' THEN '隐藏' END AS visible_desc
FROM sys_menu
WHERE menu_id IN (102, 105);
