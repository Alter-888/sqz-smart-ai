-- 向量库全文检索与元数据索引
-- 命名：日期_sqz_中文介绍.sql
-- 前提：必须先让应用启动一次，由 PgVectorStore.initializeSchema=true 自动创建 public.vector_store 表，再执行本脚本。
-- 用途：
--   1) 全文检索索引（P5 打开 smart-cs.rag.full-text-enabled 后生效）
--   2) metadata jsonb 路径索引（P1 用 knowledgeId 做 filter 删除/统计时加速）

-- 1. 全文检索索引：content 列做 GIN 全文索引（simple 分词；中文建议后续换 zhparser/pg_jieba，P5 评估）
CREATE INDEX IF NOT EXISTS idx_vector_store_content_fts
    ON public.vector_store USING GIN (to_tsvector('simple', content));

-- 2. metadata 路径索引：加速 knowledgeId / category / title 等元数据过滤
CREATE INDEX IF NOT EXISTS idx_vector_store_metadata_path
    ON public.vector_store USING GIN ((metadata::jsonb) jsonb_path_ops);
