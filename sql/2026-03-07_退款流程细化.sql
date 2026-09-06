-- 退款流程细化：biz_ticket 表增加退款相关字段
-- 退款进度值: PENDING_REVIEW(待审核) -> APPROVED(已同意) -> REFUNDED(已退款) / REJECTED(已拒绝)

ALTER TABLE biz_ticket ADD COLUMN refund_amount DECIMAL(10,2) DEFAULT NULL COMMENT '退款金额' AFTER description;
ALTER TABLE biz_ticket ADD COLUMN refund_reason VARCHAR(200) DEFAULT NULL COMMENT '退款原因' AFTER refund_amount;
ALTER TABLE biz_ticket ADD COLUMN refund_status VARCHAR(30) DEFAULT NULL COMMENT '退款进度(PENDING_REVIEW/APPROVED/REFUNDED/REJECTED)' AFTER refund_reason;
