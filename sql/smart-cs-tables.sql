-- =============================================
-- 智能客服系统 - 表结构初始化（适配若依框架）
-- 在若依数据库 ry-vue 中执行
-- 不含 sys_user 表（复用若依自带用户体系）
-- =============================================

-- =============================================
-- 1. 业务表
-- =============================================

-- 商品表
CREATE TABLE IF NOT EXISTS biz_product (
    product_id   BIGINT PRIMARY KEY AUTO_INCREMENT,
    name         VARCHAR(200) NOT NULL COMMENT '商品名称',
    category     VARCHAR(50) COMMENT '分类',
    price        DECIMAL(10,2) NOT NULL COMMENT '价格',
    stock        INT NOT NULL DEFAULT 0 COMMENT '库存',
    description  TEXT COMMENT '商品描述',
    image_url    VARCHAR(255) COMMENT '商品图片',
    status       TINYINT NOT NULL DEFAULT 1 COMMENT '状态：0下架 1上架',
    create_time  DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time  DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB COMMENT '商品表';

-- 订单表
CREATE TABLE IF NOT EXISTS biz_order (
    order_id     BIGINT PRIMARY KEY AUTO_INCREMENT,
    order_no     VARCHAR(50) NOT NULL UNIQUE COMMENT '订单编号',
    user_id      BIGINT NOT NULL COMMENT '用户ID（关联sys_user.user_id）',
    total_amount DECIMAL(10,2) NOT NULL COMMENT '订单总金额',
    status       VARCHAR(20) NOT NULL DEFAULT 'PENDING' COMMENT '订单状态：PENDING/PAID/SHIPPED/DELIVERED/CANCELLED/REFUNDED',
    address      VARCHAR(500) COMMENT '收货地址',
    logistics_no VARCHAR(50) COMMENT '物流单号',
    logistics_company VARCHAR(50) COMMENT '物流公司',
    remark       VARCHAR(500) COMMENT '备注',
    create_time  DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time  DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_user_id (user_id),
    INDEX idx_order_no (order_no)
) ENGINE=InnoDB COMMENT '订单表';

-- 订单商品表
CREATE TABLE IF NOT EXISTS biz_order_item (
    item_id     BIGINT PRIMARY KEY AUTO_INCREMENT,
    order_id    BIGINT NOT NULL COMMENT '订单ID',
    product_id  BIGINT NOT NULL COMMENT '商品ID',
    product_name VARCHAR(200) NOT NULL COMMENT '商品名称（冗余）',
    price       DECIMAL(10,2) NOT NULL COMMENT '下单时价格',
    quantity    INT NOT NULL COMMENT '数量',
    INDEX idx_order_id (order_id)
) ENGINE=InnoDB COMMENT '订单商品表';

-- 工单表
CREATE TABLE IF NOT EXISTS biz_ticket (
    ticket_id    BIGINT PRIMARY KEY AUTO_INCREMENT,
    ticket_no    VARCHAR(50) NOT NULL UNIQUE COMMENT '工单编号',
    user_id      BIGINT NOT NULL COMMENT '提交用户ID（关联sys_user.user_id）',
    order_id     BIGINT COMMENT '关联订单ID（可为空）',
    type         VARCHAR(20) NOT NULL COMMENT '类型：COMPLAINT/REFUND/EXCHANGE/CONSULT',
    title        VARCHAR(200) NOT NULL COMMENT '标题',
    description  TEXT NOT NULL COMMENT '问题描述',
    status       VARCHAR(20) NOT NULL DEFAULT 'OPEN' COMMENT '状态：OPEN/PROCESSING/RESOLVED/CLOSED',
    reply        TEXT COMMENT '管理员回复',
    create_time  DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time  DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_user_id (user_id)
) ENGINE=InnoDB COMMENT '工单表';

-- =============================================
-- 2. AI 相关表
-- =============================================

-- 知识库条目表
CREATE TABLE IF NOT EXISTS ai_knowledge (
    knowledge_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    title        VARCHAR(200) NOT NULL COMMENT '标题',
    content      TEXT NOT NULL COMMENT '知识内容（纯文本）',
    category     VARCHAR(50) COMMENT '分类：FAQ/POLICY/PRODUCT_INFO/GUIDE',
    status       TINYINT NOT NULL DEFAULT 1 COMMENT '状态：0禁用 1启用',
    create_time  DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time  DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB COMMENT '知识库条目表';

-- 知识库文档表
CREATE TABLE IF NOT EXISTS ai_knowledge_doc (
    doc_id       BIGINT PRIMARY KEY AUTO_INCREMENT,
    file_name    VARCHAR(200) NOT NULL COMMENT '文件名',
    file_path    VARCHAR(500) NOT NULL COMMENT '文件存储路径',
    file_type    VARCHAR(20) NOT NULL COMMENT '文件类型：txt/md/pdf',
    file_size    BIGINT COMMENT '文件大小（字节）',
    chunk_count  INT DEFAULT 0 COMMENT '分片数量',
    status       VARCHAR(20) NOT NULL DEFAULT 'PENDING' COMMENT '状态：PENDING/PROCESSING/COMPLETED/FAILED',
    create_time  DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB COMMENT '知识库文档表';

-- 对话会话表
CREATE TABLE IF NOT EXISTS ai_chat_session (
    session_id   BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id      BIGINT NOT NULL COMMENT '用户ID（关联sys_user.user_id）',
    title        VARCHAR(200) COMMENT '会话标题（取第一条消息摘要）',
    status       TINYINT NOT NULL DEFAULT 1 COMMENT '状态：0已关闭 1活跃',
    create_time  DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time  DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_user_id (user_id)
) ENGINE=InnoDB COMMENT '对话会话表';

-- 对话消息表
CREATE TABLE IF NOT EXISTS ai_chat_message (
    message_id   BIGINT PRIMARY KEY AUTO_INCREMENT,
    session_id   BIGINT NOT NULL COMMENT '会话ID',
    role         VARCHAR(20) NOT NULL COMMENT '角色：user/assistant/system',
    content      TEXT NOT NULL COMMENT '消息内容',
    tool_calls   TEXT COMMENT 'AI 调用的工具信息（JSON，可为空）',
    create_time  DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_session_id (session_id)
) ENGINE=InnoDB COMMENT '对话消息表';
