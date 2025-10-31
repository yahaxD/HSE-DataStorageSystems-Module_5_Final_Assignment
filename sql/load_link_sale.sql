INSERT INTO link_sale (
  link_sale_hashkey, hub_product_hashkey, hub_location_hashkey,
  hub_segment_hashkey, hub_shipment_hashkey, is_active, valid_from, loaddate, recordsource
)
SELECT DISTINCT
  md5('LINK|' ||
      md5('PROD|' || lower(trim(s.category)) || '|' || lower(trim(s.sub_category))) || '|' ||
      md5('LOC|' || lower(trim(s.country)) || '|' || lower(trim(s.city)) || '|' || coalesce(trim(s.postal_code),'')) || '|' ||
      md5('SEG|' || lower(trim(s.segment))) || '|' ||
      md5('SHIP|' || lower(trim(s.ship_mode)))
     ) AS link_sale_hashkey,
  md5('PROD|' || lower(trim(s.category)) || '|' || lower(trim(s.sub_category))) AS hub_product_hashkey,
  md5('LOC|' || lower(trim(s.country)) || '|' || lower(trim(s.city)) || '|' || coalesce(trim(s.postal_code),'')) AS hub_location_hashkey,
  md5('SEG|' || lower(trim(s.segment))) AS hub_segment_hashkey,
  md5('SHIP|' || lower(trim(s.ship_mode))) AS hub_shipment_hashkey,
  TRUE AS is_active,
  CURRENT_TIMESTAMP AS valid_from,
  CURRENT_TIMESTAMP AS loaddate,
  'CSV_SUPERSTORE' AS recordsource
FROM stg_superstore s
-- вставляем только если такой link ещё не существует
WHERE NOT EXISTS (
  SELECT 1 FROM link_sale l
   WHERE l.link_sale_hashkey = md5('LINK|' ||
      md5('PROD|' || lower(trim(s.category)) || '|' || lower(trim(s.sub_category))) || '|' ||
      md5('LOC|' || lower(trim(s.country)) || '|' || lower(trim(s.city)) || '|' || coalesce(trim(s.postal_code),'')) || '|' ||
      md5('SEG|' || lower(trim(s.segment))) || '|' ||
      md5('SHIP|' || lower(trim(s.ship_mode)))
  )
);
