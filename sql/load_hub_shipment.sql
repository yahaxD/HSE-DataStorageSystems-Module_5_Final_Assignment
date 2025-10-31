INSERT INTO hub_shipment (hub_shipment_hashkey, ship_mode, loaddate, recordsource)
SELECT DISTINCT
  md5('SHIP|' || lower(trim(ship_mode))) AS hub_shipment_hashkey,
  ship_mode,
  CURRENT_TIMESTAMP,
  'CSV_SUPERSTORE'
FROM stg_superstore s
WHERE ship_mode IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM hub_shipment h
     WHERE h.hub_shipment_hashkey = md5('SHIP|' || lower(trim(s.ship_mode)))
  );