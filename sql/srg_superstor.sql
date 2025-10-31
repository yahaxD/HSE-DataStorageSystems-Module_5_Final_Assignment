-- Staging table: соответствует структуре SampleSuperstore.csv
CREATE TABLE stg_superstore (
  ship_mode    TEXT,
  segment      TEXT,
  country      TEXT,
  city         TEXT,
  state        TEXT,
  postal_code  TEXT,
  region       TEXT,
  category     TEXT,
  sub_category TEXT,
  sales        NUMERIC(18,4),
  quantity     INTEGER,
  discount     NUMERIC(6,4),
  profit       NUMERIC(18,4)
) DISTRIBUTED RANDOMLY;

COMMENT ON TABLE stg_superstore IS 'Таблица для загрузки сырых данных из SampleSuperstore.csv';