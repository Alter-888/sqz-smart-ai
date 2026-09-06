-- =============================================
-- 智能客服系统 - 测试数据 + 菜单注册（适配若依框架）
-- 在若依数据库 ry-vue 中执行
-- user_id 对应: 1=admin, 2=ry（若依默认用户）
-- =============================================

-- =============================================
-- 1. 业务测试数据
-- =============================================

-- 商品数据
INSERT INTO biz_product (name, category, price, stock, description, status) VALUES
('iPhone 15 Pro Max 256GB', '手机', 9999.00, 100, '苹果最新旗舰手机，A17 Pro芯片，钛金属设计', 1),
('华为 Mate 60 Pro', '手机', 6999.00, 80, '华为旗舰手机，麒麟9000S芯片，卫星通话', 1),
('小米14 Ultra', '手机', 5999.00, 120, '小米影像旗舰，徕卡光学镜头，骁龙8 Gen3', 1),
('MacBook Pro 14英寸 M3', '电脑', 12999.00, 50, '苹果笔记本电脑，M3芯片，Liquid Retina XDR显示屏', 1),
('联想 ThinkPad X1 Carbon', '电脑', 8999.00, 60, '商务轻薄本，14英寸，酷睿i7处理器', 1),
('AirPods Pro 2', '配件', 1799.00, 200, '苹果无线降噪耳机，USB-C充电', 1),
('华为 FreeBuds Pro 3', '配件', 1199.00, 150, '华为旗舰降噪耳机，超感知原声双单元', 1),
('Apple Watch Series 9', '配件', 2999.00, 80, '苹果智能手表，S9芯片，双指互点手势', 1),
('iPad Air M2', '平板', 4799.00, 70, '苹果平板电脑，M2芯片，10.9英寸', 1),
('华为 MatePad Pro 13.2', '平板', 5699.00, 40, '华为旗舰平板，星闪连接，OLED柔性屏', 1);

-- 订单数据（user_id: 1=admin, 2=ry）
INSERT INTO biz_order (order_no, user_id, total_amount, status, address, logistics_no, logistics_company, remark) VALUES
('ORD20250001', 2, 9999.00, 'DELIVERED', '北京市朝阳区建国路88号', 'SF1234567890', '顺丰速运', '请小心轻放'),
('ORD20250002', 2, 1799.00, 'SHIPPED', '北京市朝阳区建国路88号', 'YT9876543210', '圆通快递', NULL),
('ORD20250003', 2, 12999.00, 'PAID', '北京市朝阳区建国路88号', NULL, NULL, '需要发票'),
('ORD20250004', 1, 6999.00, 'PENDING', '上海市浦东新区陆家嘴金融中心', NULL, NULL, NULL),
('ORD20250005', 1, 5699.00, 'SHIPPED', '上海市浦东新区陆家嘴金融中心', 'ZT1122334455', '中通快递', NULL),
('ORD20250006', 2, 5999.00, 'CANCELLED', '北京市朝阳区建国路88号', NULL, NULL, '不想要了');

-- 订单商品数据
INSERT INTO biz_order_item (order_id, product_id, product_name, price, quantity) VALUES
(1, 1, 'iPhone 15 Pro Max 256GB', 9999.00, 1),
(2, 6, 'AirPods Pro 2', 1799.00, 1),
(3, 4, 'MacBook Pro 14英寸 M3', 12999.00, 1),
(4, 2, '华为 Mate 60 Pro', 6999.00, 1),
(5, 10, '华为 MatePad Pro 13.2', 5699.00, 1),
(6, 3, '小米14 Ultra', 5999.00, 1);

-- 工单数据
INSERT INTO biz_ticket (ticket_no, user_id, order_id, type, title, description, status, reply) VALUES
('TK20250001', 2, 1, 'COMPLAINT', '手机屏幕有划痕', '收到的iPhone 15 Pro Max屏幕上有一道明显的划痕，要求更换', 'RESOLVED', '非常抱歉给您带来不便，我们已安排换货，新机将于3个工作日内发出。'),
('TK20250002', 1, 4, 'REFUND', '申请退款', '订单还未发货，我不想要了，请退款', 'OPEN', NULL),
('TK20250003', 2, NULL, 'CONSULT', '产品保修咨询', '请问iPhone的保修期是多久？海外购买的可以在国内保修吗？', 'PROCESSING', NULL);

-- 知识库数据
INSERT INTO ai_knowledge (title, content, category, status) VALUES
('退货政策', '本店退货政策如下：\n1. 商品签收后7天内可申请无理由退货\n2. 退货商品需保持原包装完整，配件齐全\n3. 已激活的电子产品（手机、电脑等）不支持无理由退货\n4. 质量问题可在15天内申请退换货\n5. 退款将在收到退货商品并检验合格后3个工作日内原路退回', 'POLICY', 1),

('保修政策', '保修政策说明：\n1. 所有商品享受国家三包政策\n2. 手机类产品：整机保修1年，电池保修6个月\n3. 电脑类产品：整机保修2年\n4. 配件类产品：保修1年\n5. 人为损坏不在保修范围内\n6. 保修期内免费维修，过保收取工本费', 'POLICY', 1),

('配送说明', '配送信息：\n1. 下单后24小时内发货（节假日顺延）\n2. 默认顺丰快递，偏远地区使用圆通/中通\n3. 一线城市次日达，二三线城市2-3天\n4. 满99元免运费，不满99元收取10元运费\n5. 支持货到付款（仅限部分地区）\n6. 可在订单详情中查看物流信息', 'POLICY', 1),

('支付方式', '支持以下支付方式：\n1. 微信支付\n2. 支付宝\n3. 银联在线支付\n4. 花呗分期（3/6/12期）\n5. 信用卡支付\n所有支付均通过加密通道，请放心使用。', 'FAQ', 1),

('常见问题 - 如何查询订单', '查询订单方法：\n1. 在聊天中直接告诉我您的订单编号，我可以帮您查询\n2. 登录后进入"我的订单"页面查看\n3. 订单编号格式为 ORD 开头，如 ORD20250001\n4. 如需查询物流进度，也可以直接询问我', 'FAQ', 1),

('iPhone 15 Pro Max 产品信息', 'iPhone 15 Pro Max 详细信息：\n- 处理器：A17 Pro 芯片\n- 屏幕：6.7英寸 Super Retina XDR 常亮显示屏\n- 存储：256GB/512GB/1TB\n- 摄像头：4800万像素主摄 + 1200万超广角 + 1200万长焦（5倍光学变焦）\n- 电池：持久续航，支持MagSafe无线充电\n- 材质：钛金属边框\n- 颜色：原色钛金属、蓝色钛金属、白色钛金属、黑色钛金属\n- 支持USB-C接口\n- 价格：9999元起', 'PRODUCT_INFO', 1),

('华为 Mate 60 Pro 产品信息', '华为 Mate 60 Pro 详细信息：\n- 处理器：麒麟9000S\n- 屏幕：6.82英寸 OLED 曲面屏\n- 存储：256GB/512GB/1TB\n- 摄像头：5000万像素超光变主摄 + 1200万超广角 + 4800万超微距长焦\n- 特色功能：天通卫星通话、昆仑玻璃\n- 电池：5000mAh，支持88W有线快充\n- 颜色：雅丹黑、雅川青、南糯紫、白沙银\n- 价格：6999元起', 'PRODUCT_INFO', 1),

('售后联系方式', '售后服务联系方式：\n1. 在线客服：通过智能客服对话即可处理大部分售后问题\n2. 客服热线：400-888-8888（工作日 9:00-18:00）\n3. 邮箱：service@smartcs.com\n4. 微信公众号：SmartCS官方商城\n5. 工单系统：可通过对话让AI客服帮您创建售后工单', 'FAQ', 1);

-- =============================================
-- 2. 菜单注册
-- =============================================

-- 智能客服（一级目录）
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES ('智能客服', 0, 1, 'ai', NULL, 1, 0, 'M', '0', '0', '', 'monitor', 'admin', sysdate(), '', NULL, '智能客服目录');

-- 获取智能客服目录的 menu_id（用于子菜单的 parent_id）
SET @ai_parent_id = LAST_INSERT_ID();

-- AI 对话
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES ('AI 对话', @ai_parent_id, 1, 'chat', 'ai/chat/index', 1, 0, 'C', '0', '0', 'ai:chat:list', 'message', 'admin', sysdate(), '', NULL, 'AI对话菜单');

-- 知识库管理
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES ('知识库管理', @ai_parent_id, 2, 'knowledge', 'ai/knowledge/index', 1, 0, 'C', '0', '0', 'ai:knowledge:list', 'documentation', 'admin', sysdate(), '', NULL, '知识库管理菜单');

SET @knowledge_menu_id = LAST_INSERT_ID();

-- 知识库按钮权限
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES ('知识新增', @knowledge_menu_id, 1, '', NULL, 1, 0, 'F', '0', '0', 'ai:knowledge:add', '#', 'admin', sysdate(), '', NULL, '');
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES ('知识编辑', @knowledge_menu_id, 2, '', NULL, 1, 0, 'F', '0', '0', 'ai:knowledge:edit', '#', 'admin', sysdate(), '', NULL, '');
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES ('知识删除', @knowledge_menu_id, 3, '', NULL, 1, 0, 'F', '0', '0', 'ai:knowledge:remove', '#', 'admin', sysdate(), '', NULL, '');
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES ('文档上传', @knowledge_menu_id, 4, '', NULL, 1, 0, 'F', '0', '0', 'ai:knowledge:upload', '#', 'admin', sysdate(), '', NULL, '');

-- 数据仪表盘
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES ('数据仪表盘', @ai_parent_id, 3, 'dashboard', 'ai/dashboard/index', 1, 0, 'C', '0', '0', 'ai:dashboard:list', 'chart', 'admin', sysdate(), '', NULL, '数据仪表盘菜单');

-- =============================================

-- 业务管理（一级目录）
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES ('业务管理', 0, 2, 'business', NULL, 1, 0, 'M', '0', '0', '', 'shopping', 'admin', sysdate(), '', NULL, '业务管理目录');

SET @biz_parent_id = LAST_INSERT_ID();

-- 商品管理
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES ('商品管理', @biz_parent_id, 1, 'product', 'business/product/index', 1, 0, 'C', '0', '0', 'business:product:list', 'shopping', 'admin', sysdate(), '', NULL, '商品管理菜单');

SET @product_menu_id = LAST_INSERT_ID();

-- 商品按钮权限
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES ('商品新增', @product_menu_id, 1, '', NULL, 1, 0, 'F', '0', '0', 'business:product:add', '#', 'admin', sysdate(), '', NULL, '');
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES ('商品编辑', @product_menu_id, 2, '', NULL, 1, 0, 'F', '0', '0', 'business:product:edit', '#', 'admin', sysdate(), '', NULL, '');
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES ('商品删除', @product_menu_id, 3, '', NULL, 1, 0, 'F', '0', '0', 'business:product:remove', '#', 'admin', sysdate(), '', NULL, '');

-- 订单管理
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES ('订单管理', @biz_parent_id, 2, 'order', 'business/order/index', 1, 0, 'C', '0', '0', 'business:order:list', 'list', 'admin', sysdate(), '', NULL, '订单管理菜单');

SET @order_menu_id = LAST_INSERT_ID();

-- 订单按钮权限
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES ('订单编辑', @order_menu_id, 1, '', NULL, 1, 0, 'F', '0', '0', 'business:order:edit', '#', 'admin', sysdate(), '', NULL, '');
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES ('订单状态修改', @order_menu_id, 2, '', NULL, 1, 0, 'F', '0', '0', 'business:order:status', '#', 'admin', sysdate(), '', NULL, '');

-- 工单管理
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES ('工单管理', @biz_parent_id, 3, 'ticket', 'business/ticket/index', 1, 0, 'C', '0', '0', 'business:ticket:list', 'form', 'admin', sysdate(), '', NULL, '工单管理菜单');

SET @ticket_menu_id = LAST_INSERT_ID();

-- 工单按钮权限
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES ('工单回复', @ticket_menu_id, 1, '', NULL, 1, 0, 'F', '0', '0', 'business:ticket:reply', '#', 'admin', sysdate(), '', NULL, '');

-- =============================================
-- 3. 给管理员角色分配所有新菜单权限
-- =============================================

-- admin 角色 (role_id=1) 自动拥有所有权限，无需额外配置
-- 如需给普通角色 (role_id=2) 也分配权限，执行以下语句：
-- INSERT INTO sys_role_menu (role_id, menu_id)
-- SELECT 2, menu_id FROM sys_menu WHERE perms LIKE 'ai:%' OR perms LIKE 'business:%';
