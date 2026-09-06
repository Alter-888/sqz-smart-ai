-- 为评价表添加商家回复字段
ALTER TABLE biz_review
  ADD COLUMN admin_reply VARCHAR(500) DEFAULT NULL COMMENT '商家回复内容',
  ADD COLUMN reply_time DATETIME DEFAULT NULL COMMENT '回复时间';
