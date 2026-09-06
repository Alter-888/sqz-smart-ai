-- 为聊天消息表添加卡片数据字段，用于持久化商品/订单卡片
ALTER TABLE ai_chat_message ADD COLUMN cards_data TEXT COMMENT '工具调用产生的卡片数据(JSON)' AFTER tool_calls;
