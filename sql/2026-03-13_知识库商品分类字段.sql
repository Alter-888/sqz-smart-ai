-- =============================================
-- 知识库增加商品分类字段 - 2026-03-13
-- 为 PRODUCT_AUTO 类型的知识条目记录商品实际分类（手机/笔记本等）
-- =============================================

ALTER TABLE ai_knowledge ADD COLUMN product_category VARCHAR(50) DEFAULT NULL
  COMMENT '商品分类（PRODUCT_AUTO类型使用，如：手机、笔记本电脑）';

-- 回填已有自动同步条目的商品分类
UPDATE ai_knowledge k
  JOIN biz_product p ON k.source_id = p.product_id
  SET k.product_category = p.category
  WHERE k.source_type = 'PRODUCT_AUTO';
