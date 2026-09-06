-- =============================================
-- 模块3：商品字段增强
-- 新增核心卖点、规格参数JSON字段
-- =============================================

ALTER TABLE biz_product ADD COLUMN highlights VARCHAR(500) COMMENT '核心卖点' AFTER description;
ALTER TABLE biz_product ADD COLUMN spec_json TEXT COMMENT '规格参数JSON' AFTER highlights;
