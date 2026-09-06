-- 合并 spec_json 到 description 字段，统一为"商品规格"
-- 先将已有的规格参数数据追加到描述字段
UPDATE biz_product
SET description = CONCAT(
    IFNULL(description, ''),
    CASE WHEN spec_json IS NOT NULL AND spec_json != ''
         THEN CONCAT('\n规格参数：', spec_json)
         ELSE ''
    END
)
WHERE spec_json IS NOT NULL AND spec_json != '';

-- 删除 spec_json 列
ALTER TABLE biz_product DROP COLUMN spec_json;
