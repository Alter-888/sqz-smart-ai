-- =============================================
-- 模块4：知识库来源追踪
-- 新增source_type和source_id字段，支持商品自动同步知识库
-- =============================================

ALTER TABLE ai_knowledge ADD COLUMN source_type VARCHAR(20) DEFAULT 'MANUAL' COMMENT '来源类型：MANUAL手动 PRODUCT_AUTO商品自动' AFTER status;
ALTER TABLE ai_knowledge ADD COLUMN source_id BIGINT DEFAULT NULL COMMENT '来源ID（商品ID等）' AFTER source_type;

-- 已有数据标记为手动
UPDATE ai_knowledge SET source_type = 'MANUAL' WHERE source_type IS NULL;

-- 添加来源索引，方便按商品ID查询
ALTER TABLE ai_knowledge ADD INDEX idx_source (source_type, source_id);
