INSERT INTO hub_product (hub_product_hashkey, category, sub_category, loaddate, recordsource)
SELECT DISTINCT
  md5('PROD|' || lower(trim(category)) || '|' || lower(trim(sub_category))) AS hub_product_hashkey,
  category,
  sub_category,
  CURRENT_TIMESTAMP,
  'CSV_SUPERSTORE'
FROM stg_superstore s
WHERE category IS NOT NULL AND sub_category IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM hub_product h
     WHERE h.hub_product_hashkey = md5('PROD|' || lower(trim(s.category)) || '|' || lower(trim(s.sub_category)))
  );