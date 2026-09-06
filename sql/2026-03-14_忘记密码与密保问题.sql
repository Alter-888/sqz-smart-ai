-- =============================================
-- 忘记密码功能：密保问题 + 管理员重置申请
-- =============================================

-- 1. sys_user 表添加密保问题和答案字段
ALTER TABLE sys_user ADD COLUMN security_question VARCHAR(200) DEFAULT NULL COMMENT '密保问题';
ALTER TABLE sys_user ADD COLUMN security_answer VARCHAR(200) DEFAULT NULL COMMENT '密保答案(BCrypt加密存储)';

-- 2. 密码重置申请表
CREATE TABLE sys_password_reset_request (
  request_id    BIGINT       NOT NULL AUTO_INCREMENT COMMENT '申请ID',
  user_id       BIGINT       NOT NULL                COMMENT '用户ID',
  user_name     VARCHAR(30)  NOT NULL                COMMENT '用户账号',
  reason        VARCHAR(500) DEFAULT ''              COMMENT '申请原因',
  status        CHAR(1)      NOT NULL DEFAULT '0'    COMMENT '状态（0待处理 1已通过 2已拒绝）',
  handle_by     VARCHAR(64)  DEFAULT ''              COMMENT '处理人',
  handle_time   DATETIME     DEFAULT NULL            COMMENT '处理时间',
  handle_remark VARCHAR(500) DEFAULT ''              COMMENT '处理备注',
  create_time   DATETIME     DEFAULT CURRENT_TIMESTAMP COMMENT '申请时间',
  PRIMARY KEY (request_id),
  INDEX idx_user_id (user_id),
  INDEX idx_status (status)
) ENGINE=InnoDB COMMENT='密码重置申请表';

-- 3. 管理员后台菜单：密码重置申请管理（动态查询系统管理的menu_id）
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, menu_type, visible, status, perms, icon, create_by, create_time, remark)
SELECT '重置密码申请', menu_id, 10, 'resetRequest', 'system/resetRequest/index', 'C', '0', '0', 'system:resetRequest:list', 'password', 'admin', NOW(), '密码重置申请管理菜单'
FROM sys_menu WHERE menu_name = '系统管理' AND parent_id = 0;

-- 4. 获取刚插入的菜单ID，插入按钮权限
SET @resetMenuId = LAST_INSERT_ID();

INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, menu_type, visible, status, perms, icon, create_by, create_time)
VALUES
  ('查看申请', @resetMenuId, 1, '#', '', 'F', '0', '0', 'system:resetRequest:list', '#', 'admin', NOW()),
  ('处理申请', @resetMenuId, 2, '#', '', 'F', '0', '0', 'system:resetRequest:handle', '#', 'admin', NOW());

-- 5. 给管理员角色(role_id=1)分配这些菜单权限
INSERT INTO sys_role_menu (role_id, menu_id) VALUES (1, @resetMenuId);
INSERT INTO sys_role_menu (role_id, menu_id)
SELECT 1, menu_id FROM sys_menu WHERE perms IN ('system:resetRequest:list', 'system:resetRequest:handle') AND parent_id = @resetMenuId;
