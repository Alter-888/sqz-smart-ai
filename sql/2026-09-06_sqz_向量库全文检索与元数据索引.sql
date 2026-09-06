-- ============================================================================
-- 向量库全文检索与元数据索引
-- 命名：日期_sqz_中文介绍.sql
-- ============================================================================
-- 重要执行顺序（务必遵守，否则会报错）：
--   ① 先启动 RuoYi 应用（ruoyi-admin），让 PgVectorStore.initializeSchema=true
--      自动创建 vector / hstore 扩展，并 CREATE TABLE IF NOT EXISTS public.vector_store。
--   ② 确认表已存在：\d public.vector_store
--      应能看到 id(text) / content(text) / metadata(json) / embedding(vector(1024))。
--   ③ 再执行本脚本，创建以下两个索引。
--
--   ⚠️  若跳过 ① 直接执行本脚本，会报错：relation "vector_store" does not exist。
--       （表得先由应用建好，脚本才能在其上建索引）
--   该脚本基于 IF NOT EXISTS，是幂等的，可重复执行。
--   本地环境已在 2026-09-06 成功执行并生效。
--
-- 用途：
--   1) 全文检索索引（P5 打开 smart-cs.rag.full-text-enabled 后生效）
--   2) metadata jsonb 路径索引（P1 用 knowledgeId 做 filter 删除/统计时加速）
-- ============================================================================

-- 1. 全文检索索引：content 列做 GIN 全文索引（simple 分词；中文建议后续换 zhparser/pg_jieba，P5 评估）
CREATE INDEX IF NOT EXISTS idx_vector_store_content_fts
    ON public.vector_store USING GIN (to_tsvector('simple', content));

-- 2. metadata 路径索引：加速 knowledgeId / category / title 等元数据过滤
CREATE INDEX IF NOT EXISTS idx_vector_store_metadata_path
    ON public.vector_store USING GIN ((metadata::jsonb) jsonb_path_ops);
