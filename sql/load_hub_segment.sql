INSERT INTO hub_segment (hub_segment_hashkey, segment, loaddate, recordsource)
SELECT DISTINCT
  md5('SEG|' || lower(trim(segment))) AS hub_segment_hashkey,
  segment,
  CURRENT_TIMESTAMP,
  'CSV_SUPERSTORE'
FROM stg_superstore s
WHERE segment IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM hub_segment h
     WHERE h.hub_segment_hashkey = md5('SEG|' || lower(trim(s.segment)))
  );