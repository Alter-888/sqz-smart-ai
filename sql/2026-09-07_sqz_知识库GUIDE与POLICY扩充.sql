-- =============================================================================
-- 说明：P6 知识库扩充 —— 使用指南 GUIDE 8 条 + 政策规范 POLICY 5 条
-- 命名：2026-09-07_sqz_知识库GUIDE与POLICY扩充.sql
-- 依据：内容来自系统真实字段/枚举（Product.refundPolicy/warrantyInfo/afterSaleNote、
--       OrderStatus、TicketType、Address/Review 功能），未凭空捏造条款。
-- 幂等：先按标题删除旧的 MANUAL 条目再插入，可重复执行。
-- 注意：执行后需在后台「知识库管理」点「重建向量库」，并给黄金集补 GUIDE/POLICY 用例。
-- =============================================================================

DELETE FROM `ai_knowledge`
 WHERE `source_type` = 'MANUAL' AND `category` IN ('GUIDE','POLICY')
   AND `title` IN (
    '如何下单购买商品','订单状态分别代表什么','如何查询物流/配送进度','如何新增/修改收货地址',
    '如何申请退款/退货','如何联系人工客服/提交工单','如何对已购买商品进行评价','如何查看商品卖点/规格',
    '退换货政策','保修政策/保修多久','售后注意事项','订单金额/支付说明','发货/配送规则'
   );

-- ============================ GUIDE 使用指南 ============================
INSERT INTO `ai_knowledge` (`title`,`content`,`category`,`status`,`source_type`,`create_time`) VALUES
('如何下单购买商品',
'【使用指南】下单流程：1) 在商品列表或搜索找到目标商品，进入商品详情；2) 点击「加入购物车」或「立即购买」；3) 进入结算页选择收货地址（可在「地址管理」新增）；4) 确认数量与金额后提交订单，订单状态为「待付款」；5) 完成支付后状态变为「已付款」。',
'GUIDE',1,'MANUAL',NOW());

INSERT INTO `ai_knowledge` (`title`,`content`,`category`,`status`,`source_type`,`create_time`) VALUES
('订单状态分别代表什么',
'【使用指南】订单状态说明：待付款=已提交未支付；已付款=支付成功；已发货=商家已发货；已签收=用户已收货；已取消=订单已取消；已退款=订单已退款。可在「我的订单」中查看当前状态。',
'GUIDE',1,'MANUAL',NOW());

INSERT INTO `ai_knowledge` (`title`,`content`,`category`,`status`,`source_type`,`create_time`) VALUES
('如何查询物流/配送进度',
'【使用指南】订单「已发货」后，可在「我的订单-订单详情」查看物流单号与物流公司，跟踪配送进度；物流送达并确认收货后，状态更新为「已签收」。',
'GUIDE',1,'MANUAL',NOW());

INSERT INTO `ai_knowledge` (`title`,`content`,`category`,`status`,`source_type`,`create_time`) VALUES
('如何新增/修改收货地址',
'【使用指南】进入「个人中心-地址管理」，可新增、编辑、删除收货地址；下单结算时选择所需地址。请确保收货人、电话、详细地址填写正确。',
'GUIDE',1,'MANUAL',NOW());

INSERT INTO `ai_knowledge` (`title`,`content`,`category`,`status`,`source_type`,`create_time`) VALUES
('如何申请退款/退货',
'【使用指南】如需退款或退货，进入「工单中心-提交工单」，工单类型选择「仅退款」或「退货退款」，填写订单号与原因后提交，客服会按流程处理。',
'GUIDE',1,'MANUAL',NOW());

INSERT INTO `ai_knowledge` (`title`,`content`,`category`,`status`,`source_type`,`create_time`) VALUES
('如何联系人工客服/提交工单',
'【使用指南】需要人工协助时，进入「工单中心-提交工单」，工单类型选择「转人工客服」或「投诉」，描述问题并提交；也可在客服对话中唤起工单卡片提交。',
'GUIDE',1,'MANUAL',NOW());

INSERT INTO `ai_knowledge` (`title`,`content`,`category`,`status`,`source_type`,`create_time`) VALUES
('如何对已购买商品进行评价',
'【使用指南】订单「已签收」后，可在订单详情/评价入口对已购买商品进行评分与文字评价，评价会展示在商品详情页。',
'GUIDE',1,'MANUAL',NOW());

INSERT INTO `ai_knowledge` (`title`,`content`,`category`,`status`,`source_type`,`create_time`) VALUES
('如何查看商品卖点/规格',
'【使用指南】进入商品详情页，可查看商品的核心卖点、详细规格描述、价格、库存与分类信息，据此确认是否适合自己。',
'GUIDE',1,'MANUAL',NOW());

-- ============================ POLICY 政策规范 ============================
INSERT INTO `ai_knowledge` (`title`,`content`,`category`,`status`,`source_type`,`create_time`) VALUES
('退换货政策',
'【政策规范】退换货政策：未拆封/未激活的商品支持7天无理由退换（部分商品如苹果手机支持未激活14天）；已激活的电子产品（如手机、平板）不支持退换，仅支持保修服务。',
'POLICY',1,'MANUAL',NOW());

INSERT INTO `ai_knowledge` (`title`,`content`,`category`,`status`,`source_type`,`create_time`) VALUES
('保修政策/保修多久',
'【政策规范】保修政策：商品全国联保一年，支持官方售后；苹果等品牌可选 AppleCare+ 延长保修，三星可购 Samsung Care+。具体以商品详情页「保修信息」为准。',
'POLICY',1,'MANUAL',NOW());

INSERT INTO `ai_knowledge` (`title`,`content`,`category`,`status`,`source_type`,`create_time`) VALUES
('售后注意事项',
'【政策规范】售后注意事项：请保留原装包装、配件与购买凭证；人为损坏、自行拆机、屏幕碎裂等不在免费保修范围内（三星碎屏建议购买 Samsung Care+）；激活后仅支持保修，不支持退换。',
'POLICY',1,'MANUAL',NOW());

INSERT INTO `ai_knowledge` (`title`,`content`,`category`,`status`,`source_type`,`create_time`) VALUES
('订单金额/支付说明',
'【政策规范】订单金额=所选商品单价×数量，以结算页总金额为准。下单后订单为「待付款」，完成支付后为「已付款」；未支付可取消订单。',
'POLICY',1,'MANUAL',NOW());

INSERT INTO `ai_knowledge` (`title`,`content`,`category`,`status`,`source_type`,`create_time`) VALUES
('发货/配送规则',
'【政策规范】发货与配送：订单支付成功后进入发货流程，发货后记录物流单号与物流公司，订单状态由「已发货」到物流送达后「已签收」，可在订单详情查看物流信息。',
'POLICY',1,'MANUAL',NOW());