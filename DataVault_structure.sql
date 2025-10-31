-- ==============================
-- HUBS
-- ==============================

-- HUB_PRODUCT
CREATE TABLE hub_product (
    hub_product_hashkey     CHAR(32) PRIMARY KEY,  -- md5 hash of business key
    category                TEXT NOT NULL,
    sub_category            TEXT NOT NULL,
    loaddate                TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    recordsource            TEXT NOT NULL
)
DISTRIBUTED BY (hub_product_hashkey);

COMMENT ON TABLE hub_product IS 'Хаб товаров. Бизнес-ключ: Category + Sub-Category';

-- HUB_LOCATION
CREATE TABLE hub_location (
    hub_location_hashkey    CHAR(32) PRIMARY KEY,
    country                 TEXT NOT NULL,
    city                    TEXT NOT NULL,
    postal_code             TEXT NOT NULL,
    loaddate                TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    recordsource            TEXT NOT NULL
)
DISTRIBUTED BY (hub_location_hashkey);

COMMENT ON TABLE hub_location IS 'Хаб географических данных. Бизнес-ключ: Country + City + PostalCode';

-- HUB_SEGMENT
CREATE TABLE hub_segment (
    hub_segment_hashkey     CHAR(32) PRIMARY KEY,
    segment                 TEXT NOT NULL,
    loaddate                TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    recordsource            TEXT NOT NULL
)
DISTRIBUTED BY (hub_segment_hashkey);

COMMENT ON TABLE hub_segment IS 'Хаб классов покупателей. Бизнес-ключ: Segment';

-- HUB_SHIPMENT
CREATE TABLE hub_shipment (
    hub_shipment_hashkey    CHAR(32) PRIMARY KEY,
    ship_mode               TEXT NOT NULL,
    loaddate                TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    recordsource            TEXT NOT NULL
)
DISTRIBUTED BY (hub_shipment_hashkey);

COMMENT ON TABLE hub_shipment IS 'Хаб способов доставки. Бизнес-ключ: Ship Mode';


-- ==============================
-- LINKS
-- ==============================

CREATE TABLE link_sale (
    link_sale_hashkey       CHAR(32) PRIMARY KEY,
    hub_product_hashkey     CHAR(32) NOT NULL,
    hub_location_hashkey    CHAR(32) NOT NULL,
    hub_segment_hashkey     CHAR(32) NOT NULL,
    hub_shipment_hashkey    CHAR(32) NOT NULL,
    loaddate                TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    recordsource            TEXT NOT NULL
)
DISTRIBUTED BY (link_sale_hashkey);

COMMENT ON TABLE link_sale IS 'Линк факта продажи, соединяющий товар, локацию, сегмент и способ доставки';


-- ==============================
-- SATELLITES
-- ==============================

-- SAT_PRODUCT_ATTR
CREATE TABLE sat_product_attr (
    hub_product_hashkey     CHAR(32) NOT NULL,
    hashdiff                CHAR(32) NOT NULL,  -- md5 hash of all descriptive attributes
    category                TEXT,
    sub_category            TEXT,
    loaddate                TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    recordsource            TEXT NOT NULL,
    CONSTRAINT pk_sat_product PRIMARY KEY (hub_product_hashkey, loaddate)
)
DISTRIBUTED BY (hub_product_hashkey);

COMMENT ON TABLE sat_product_attr IS 'Спутник товаров. Атрибуты: Category, Sub-Category';

-- SAT_LOCATION_ATTR
CREATE TABLE sat_location_attr (
    hub_location_hashkey    CHAR(32) NOT NULL,
    hashdiff                CHAR(32) NOT NULL,
    country                 TEXT,
    state                   TEXT,
    city                    TEXT,
    region                  TEXT,
    postal_code             TEXT,
    loaddate                TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    recordsource            TEXT NOT NULL,
    CONSTRAINT pk_sat_location PRIMARY KEY (hub_location_hashkey, loaddate)
)
DISTRIBUTED BY (hub_location_hashkey);

COMMENT ON TABLE sat_location_attr IS 'Спутник локации. Атрибуты: Country, State, City, Region, Postal Code';

-- SAT_SALE_FACTS
CREATE TABLE sat_sale_facts (
    link_sale_hashkey       CHAR(32) NOT NULL,
    hashdiff                CHAR(32) NOT NULL,
    sales                   NUMERIC(12,2),
    quantity                INT,
    discount                NUMERIC(5,2),
    profit                  NUMERIC(12,2),
    loaddate                TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    recordsource            TEXT NOT NULL,
    CONSTRAINT pk_sat_sale PRIMARY KEY (link_sale_hashkey, loaddate)
)
DISTRIBUTED BY (link_sale_hashkey);

COMMENT ON TABLE sat_sale_facts IS 'Спутник фактов продаж. Метрики: Sales, Quantity, Discount, Profit';


