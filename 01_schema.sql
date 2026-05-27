-- ============================================================
-- RetailPulse: Sales Analytics Project
-- File: 01_schema.sql
-- Description: Database schema — star schema design
-- Dialect: SQLite (compatible with MySQL/PostgreSQL with minor tweaks)
-- Author: [Your Name]
-- ============================================================

-- Enable foreign key enforcement in SQLite
PRAGMA foreign_keys = ON;

-- ============================================================
-- Drop tables if re-running (order matters for FK constraints)
-- ============================================================
DROP TABLE IF EXISTS fact_order_items;
DROP TABLE IF EXISTS fact_orders;
DROP TABLE IF EXISTS dim_products;
DROP TABLE IF EXISTS dim_customers;
DROP TABLE IF EXISTS dim_stores;
DROP TABLE IF EXISTS dim_date;

-- ============================================================
-- DIMENSION TABLE: dim_date
-- Purpose: Central calendar table enabling time-based slicing
--          by day, week, month, quarter, year, and fiscal period.
--          Essential for YoY, MoM, and cohort analysis.
-- ============================================================
CREATE TABLE dim_date (
    date_id     INTEGER PRIMARY KEY,   -- YYYYMMDD integer key e.g. 20230115
    full_date   DATE    NOT NULL UNIQUE,
    day_of_week INTEGER NOT NULL,      -- 0=Sunday, 6=Saturday
    day_name    TEXT    NOT NULL,      -- 'Monday', 'Tuesday', etc.
    week_number INTEGER NOT NULL,      -- ISO week number (1–53)
    month_num   INTEGER NOT NULL,      -- 1–12
    month_name  TEXT    NOT NULL,      -- 'January', 'February', etc.
    quarter     INTEGER NOT NULL,      -- 1–4
    year        INTEGER NOT NULL,
    is_weekend  INTEGER NOT NULL DEFAULT 0,  -- 1 = Saturday or Sunday
    is_holiday  INTEGER NOT NULL DEFAULT 0   -- 1 = Indian public holiday
);

-- ============================================================
-- DIMENSION TABLE: dim_customers
-- Purpose: Customer master — geography, segment, and
--          acquisition channel data for segmentation analysis.
-- ============================================================
CREATE TABLE dim_customers (
    customer_id          TEXT    PRIMARY KEY,
    customer_name        TEXT    NOT NULL,
    email                TEXT,
    phone                TEXT,
    city                 TEXT    NOT NULL,
    state                TEXT    NOT NULL,
    region               TEXT    NOT NULL,  -- North / South / East / West
    customer_segment     TEXT    NOT NULL,  -- B2C / B2B / SME
    acquisition_channel  TEXT    NOT NULL,  -- Online / In-Store / Referral / Field Sales
    registration_date    DATE    NOT NULL
);

-- ============================================================
-- DIMENSION TABLE: dim_products
-- Purpose: Product catalogue with cost and price for
--          margin and profitability analysis.
-- ============================================================
CREATE TABLE dim_products (
    product_id    TEXT    PRIMARY KEY,
    product_name  TEXT    NOT NULL,
    category      TEXT    NOT NULL,      -- Electronics / FMCG / Fashion / Home Appliances / Books
    sub_category  TEXT,
    brand         TEXT,
    unit_cost     REAL    NOT NULL,      -- Cost price (INR)
    unit_price    REAL    NOT NULL,      -- Selling price (INR)
    is_active     INTEGER NOT NULL DEFAULT 1  -- 1 = active listing
);

-- ============================================================
-- DIMENSION TABLE: dim_stores
-- Purpose: Store and channel master for regional performance
--          analysis and channel mix reporting.
-- ============================================================
CREATE TABLE dim_stores (
    store_id      TEXT    PRIMARY KEY,
    store_name    TEXT    NOT NULL,
    city          TEXT    NOT NULL,
    state         TEXT    NOT NULL,
    region        TEXT    NOT NULL,  -- North / South / East / West / Pan-India
    store_type    TEXT    NOT NULL,  -- Flagship / Express / Online / B2B Hub
    opening_date  DATE
);

-- ============================================================
-- FACT TABLE: fact_orders
-- Purpose: Order header — one row per customer order.
--          Links customers, stores, and dates.
--          Granularity: one row = one order transaction.
-- ============================================================
CREATE TABLE fact_orders (
    order_id        TEXT    PRIMARY KEY,
    customer_id     TEXT    NOT NULL REFERENCES dim_customers(customer_id),
    store_id        TEXT    NOT NULL REFERENCES dim_stores(store_id),
    order_date      DATE    NOT NULL,
    order_channel   TEXT    NOT NULL,   -- Online / In-Store / App / Field Sales
    order_status    TEXT    NOT NULL DEFAULT 'Delivered',  -- Delivered / Returned / Cancelled
    shipping_city   TEXT,
    total_amount    REAL    NOT NULL,   -- Gross order value before discount (INR)
    discount_amount REAL    NOT NULL DEFAULT 0,
    shipping_cost   REAL    NOT NULL DEFAULT 0,
    net_amount      REAL    NOT NULL    -- total_amount - discount_amount + shipping_cost
);

-- ============================================================
-- FACT TABLE: fact_order_items
-- Purpose: Order line items — one row per product per order.
--          Core table for product, category, and margin analysis.
--          Granularity: one row = one product within one order.
-- ============================================================
CREATE TABLE fact_order_items (
    item_id       INTEGER PRIMARY KEY AUTOINCREMENT,
    order_id      TEXT    NOT NULL REFERENCES fact_orders(order_id),
    product_id    TEXT    NOT NULL REFERENCES dim_products(product_id),
    quantity      INTEGER NOT NULL CHECK (quantity > 0),
    unit_price    REAL    NOT NULL,   -- Actual selling price (may differ from list price)
    unit_cost     REAL    NOT NULL,   -- Product cost at time of sale
    discount_pct  REAL    NOT NULL DEFAULT 0,   -- 0.10 = 10% discount
    line_revenue  REAL    NOT NULL,   -- quantity * unit_price * (1 - discount_pct)
    line_cost     REAL    NOT NULL,   -- quantity * unit_cost
    line_profit   REAL    NOT NULL    -- line_revenue - line_cost
);

-- ============================================================
-- INDEXES for query performance
-- ============================================================
CREATE INDEX idx_orders_customer    ON fact_orders(customer_id);
CREATE INDEX idx_orders_store       ON fact_orders(store_id);
CREATE INDEX idx_orders_date        ON fact_orders(order_date);
CREATE INDEX idx_items_order        ON fact_order_items(order_id);
CREATE INDEX idx_items_product      ON fact_order_items(product_id);
CREATE INDEX idx_customers_region   ON dim_customers(region, city);
CREATE INDEX idx_products_category  ON dim_products(category);

-- ============================================================
-- End of schema
-- ============================================================
