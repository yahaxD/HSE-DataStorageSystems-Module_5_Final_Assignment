INSERT INTO sat_location_attr (
  hub_location_hashkey, hashdiff,
  country, state, city, region, postal_code,
  loaddate, recordsource
)
WITH grouped AS (
  SELECT
    md5('LOC|' || lower(trim(country)) || '|' || lower(trim(city)) || '|' || lower(trim(postal_code))) AS hub_location_hashkey,
    md5(
      coalesce(lower(trim(country)),'') || '|' ||
      coalesce(lower(trim(state)),'') || '|' ||
      coalesce(lower(trim(city)),'') || '|' ||
      coalesce(lower(trim(region)),'') || '|' ||
      coalesce(lower(trim(postal_code)),'')
    ) AS hashdiff,
    MIN(country) AS country,
    MIN(state) AS state,
    MIN(city) AS city,
    MIN(region) AS region,
    MIN(postal_code) AS postal_code
  FROM stg_superstore
  GROUP BY
    md5('LOC|' || lower(trim(country)) || '|' || lower(trim(city)) || '|' || lower(trim(postal_code))),
    md5(
      coalesce(lower(trim(country)),'') || '|' ||
      coalesce(lower(trim(state)),'') || '|' ||
      coalesce(lower(trim(city)),'') || '|' ||
      coalesce(lower(trim(region)),'') || '|' ||
      coalesce(lower(trim(postal_code)),'')
    )
)
SELECT
  g.hub_location_hashkey,
  g.hashdiff,
  g.country,
  g.state,
  g.city,
  g.region,
  g.postal_code,
  CURRENT_TIMESTAMP AS loaddate,
  'CSV_SUPERSTORE' AS recordsource
FROM grouped g
WHERE NOT EXISTS (
  SELECT 1 FROM sat_location_attr sat
  WHERE sat.hub_location_hashkey = g.hub_location_hashkey
    AND sat.hashdiff = g.hashdiff
);
