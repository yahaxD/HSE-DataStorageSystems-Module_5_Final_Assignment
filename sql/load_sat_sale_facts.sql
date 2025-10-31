INSERT INTO sat_sale_facts (
  link_sale_hashkey, hashdiff,
  sales, quantity, discount, profit,
  loaddate, recordsource
)
WITH grouped AS (
  SELECT
    md5(
      'LINK|' ||
      md5('SHIP|' || lower(trim(ship_mode))) || '|' ||
      md5('PROD|' || lower(trim(category)) || '|' || lower(trim(sub_category))) || '|' ||
      md5('LOC|'  || lower(trim(country)) || '|' || lower(trim(city)) || '|' || lower(trim(postal_code))) || '|' ||
      md5('SEG|'  || lower(trim(segment)))
    ) AS link_sale_hashkey,
    md5(
      coalesce(sales::text,'') || '|' ||
      coalesce(quantity::text,'') || '|' ||
      coalesce(discount::text,'') || '|' ||
      coalesce(profit::text,'')
    ) AS hashdiff,
    MIN(sales) AS sales,
    MIN(quantity) AS quantity,
    MIN(discount) AS discount,
    MIN(profit) AS profit
  FROM stg_superstore
  GROUP BY
    md5(
      'LINK|' ||
      md5('SHIP|' || lower(trim(ship_mode))) || '|' ||
      md5('PROD|' || lower(trim(category)) || '|' || lower(trim(sub_category))) || '|' ||
      md5('LOC|'  || lower(trim(country)) || '|' || lower(trim(city)) || '|' || lower(trim(postal_code))) || '|' ||
      md5('SEG|'  || lower(trim(segment)))
    ),
    md5(
      coalesce(sales::text,'') || '|' ||
      coalesce(quantity::text,'') || '|' ||
      coalesce(discount::text,'') || '|' ||
      coalesce(profit::text,'')
    )
)
SELECT
  g.link_sale_hashkey,
  g.hashdiff,
  g.sales,
  g.quantity,
  g.discount,
  g.profit,
  CURRENT_TIMESTAMP AS loaddate,
  'CSV_SUPERSTORE' AS recordsource
FROM grouped g
WHERE NOT EXISTS (
  SELECT 1
  FROM sat_sale_facts sat
  WHERE sat.link_sale_hashkey = g.link_sale_hashkey
    AND sat.hashdiff = g.hashdiff
);