-- 商品表增加售后相关字段
ALTER TABLE biz_product ADD COLUMN refund_policy TEXT COMMENT '退换货政策' AFTER spec_json;
ALTER TABLE biz_product ADD COLUMN warranty_info VARCHAR(200) COMMENT '保修信息' AFTER refund_policy;
ALTER TABLE biz_product ADD COLUMN after_sale_note TEXT COMMENT '售后注意事项' AFTER warranty_info;
