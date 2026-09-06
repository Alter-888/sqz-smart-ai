-- ai_chat_message 表添加满意度反馈字段
ALTER TABLE ai_chat_message ADD COLUMN feedback TINYINT DEFAULT NULL
  COMMENT '满意度反馈：1满意 0不满意 NULL未评价';
