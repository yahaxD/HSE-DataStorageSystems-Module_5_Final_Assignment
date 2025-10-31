INSERT INTO sat_product_attr (
  hub_product_hashkey, hashdiff, category, sub_category, loaddate, recordsource
)
WITH grouped AS (
  SELECT
    md5('PROD|' || lower(trim(category)) || '|' || lower(trim(sub_category))) AS hub_product_hashkey,
    md5(coalesce(lower(trim(category)), '') || '|' || coalesce(lower(trim(sub_category)), '')) AS hashdiff,
    MIN(category) AS category,
    MIN(sub_category) AS sub_category
  FROM stg_superstore
  GROUP BY
    md5('PROD|' || lower(trim(category)) || '|' || lower(trim(sub_category))),
    md5(coalesce(lower(trim(category)), '') || '|' || coalesce(lower(trim(sub_category)), ''))
)
SELECT
  g.hub_product_hashkey,
  g.hashdiff,
  g.category,
  g.sub_category,
  CURRENT_TIMESTAMP AS loaddate,
  'CSV_SUPERSTORE' AS recordsource
FROM grouped g
WHERE NOT EXISTS (
  SELECT 1 FROM sat_product_attr sat
  WHERE sat.hub_product_hashkey = g.hub_product_hashkey
    AND sat.hashdiff = g.hashdiff
);