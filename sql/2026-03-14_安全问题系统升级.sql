-- ============================================
-- 安全问题系统升级 - 多问题支持 + 管理员一键重置
-- 日期: 2026-03-14
-- ============================================

-- 1. 新建用户安全问题表
CREATE TABLE IF NOT EXISTS sys_user_security_question (
  id           BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键',
  user_id      BIGINT       NOT NULL                COMMENT '用户ID',
  question     VARCHAR(200) NOT NULL                COMMENT '密保问题',
  answer       VARCHAR(200) NOT NULL                COMMENT '密保答案(BCrypt加密)',
  sort_order   INT          DEFAULT 0               COMMENT '排序',
  create_time  DATETIME     DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (id),
  INDEX idx_user_id (user_id)
) ENGINE=InnoDB COMMENT='用户安全问题表';

-- 2. 迁移已有数据（从sys_user表动态查询后插入）
INSERT INTO sys_user_security_question (user_id, question, answer, sort_order, create_time)
SELECT user_id, security_question, security_answer, 1, NOW()
FROM sys_user
WHERE security_question IS NOT NULL AND security_question != ''
  AND security_answer IS NOT NULL AND security_answer != '';

-- 3. 扩展重置申请表，新增用户提交的新密码字段
ALTER TABLE sys_password_reset_request
  ADD COLUMN new_password VARCHAR(200) DEFAULT NULL COMMENT '用户提交的新密码(BCrypt加密)';

-- 4. 删除sys_user旧的密保字段（数据已迁移到新表）
ALTER TABLE sys_user DROP COLUMN security_question;
ALTER TABLE sys_user DROP COLUMN security_answer;
