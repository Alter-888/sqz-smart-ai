-- AI工具调用日志表：记录每次AI工具调用，用于Dashboard统计
CREATE TABLE IF NOT EXISTS ai_tool_call_log (
    log_id      BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '日志ID',
    session_id  BIGINT          COMMENT '会话ID',
    tool_name   VARCHAR(100) NOT NULL COMMENT '工具名称',
    tool_params TEXT             COMMENT '调用参数（JSON）',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '调用时间',
    INDEX idx_tool_name (tool_name),
    INDEX idx_create_time (create_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='AI工具调用日志表';
