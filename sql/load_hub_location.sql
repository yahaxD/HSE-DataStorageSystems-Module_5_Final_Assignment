INSERT INTO hub_location (hub_location_hashkey, country, city, postal_code, loaddate, recordsource)
SELECT DISTINCT
  md5('LOC|' || lower(trim(country)) || '|' || lower(trim(city)) || '|' || coalesce(trim(postal_code),'')) AS hub_location_hashkey,
  country,
  city,
  postal_code,
  CURRENT_TIMESTAMP,
  'CSV_SUPERSTORE'
FROM stg_superstore s
WHERE country IS NOT NULL AND city IS NOT NULL AND postal_code IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM hub_location h
     WHERE h.hub_location_hashkey = md5('LOC|' || lower(trim(s.country)) || '|' || lower(trim(s.city)) || '|' || coalesce(trim(s.postal_code),''))
  );