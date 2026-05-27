-- ============================================================
-- RetailPulse: Sales Analytics Project
-- File: 03_analysis_queries.sql
-- Description: 12 annotated business intelligence queries
--              covering revenue, growth, retention, and CLV.
-- Dialect: SQLite 3.39+ (window functions fully supported)
-- ============================================================

-- ============================================================
-- QUERY 1: Monthly & Quarterly Revenue, Profit, and Order Volume
-- ============================================================
-- Business Question:
--   How is the business performing month by month and quarter
--   by quarter? Are we growing, and where are the revenue peaks?
-- Expected Insight:
--   Q4 (Oct–Dec) dominates due to Diwali and festive season.
--   January typically dips. Tracking order count alongside
--   revenue reveals whether growth is price-driven or volume-driven.
-- ============================================================

SELECT
    strftime('%Y', o.order_date)                        AS year,
    strftime('%m', o.order_date)                        AS month_num,
    CASE strftime('%m', o.order_date)
        WHEN '01' THEN 'Jan' WHEN '02' THEN 'Feb'
        WHEN '03' THEN 'Mar' WHEN '04' THEN 'Apr'
        WHEN '05' THEN 'May' WHEN '06' THEN 'Jun'
        WHEN '07' THEN 'Jul' WHEN '08' THEN 'Aug'
        WHEN '09' THEN 'Sep' WHEN '10' THEN 'Oct'
        WHEN '11' THEN 'Nov' WHEN '12' THEN 'Dec'
    END                                                  AS month_name,
    CASE
        WHEN CAST(strftime('%m', o.order_date) AS INTEGER) BETWEEN 1  AND 3  THEN 'Q1'
        WHEN CAST(strftime('%m', o.order_date) AS INTEGER) BETWEEN 4  AND 6  THEN 'Q2'
        WHEN CAST(strftime('%m', o.order_date) AS INTEGER) BETWEEN 7  AND 9  THEN 'Q3'
        ELSE 'Q4'
    END                                                  AS quarter,
    COUNT(DISTINCT o.order_id)                           AS total_orders,
    ROUND(SUM(oi.line_revenue), 0)                       AS gross_revenue_inr,
    ROUND(SUM(oi.line_cost), 0)                          AS total_cost_inr,
    ROUND(SUM(oi.line_profit), 0)                        AS gross_profit_inr,
    ROUND(SUM(oi.line_profit) / SUM(oi.line_revenue) * 100, 1)  AS profit_margin_pct
FROM
    fact_orders o
    JOIN fact_order_items oi ON o.order_id = oi.order_id
WHERE
    o.order_status = 'Delivered'
GROUP BY
    year, month_num
ORDER BY
    year, month_num;

-- ============================================================
-- QUERY 2: Year-over-Year (YoY) and Month-over-Month (MoM) Growth
-- ============================================================
-- Business Question:
--   Is the business growing faster or slower than last year?
--   Which months showed the biggest positive or negative swings?
-- SQL Technique: LAG() window function to compare current
--   period with prior period.
-- Expected Insight:
--   Positive YoY growth in most months; Oct/Nov Diwali spike
--   in 2023 sets a high bar for 2024 comparison.
-- ============================================================

WITH monthly_revenue AS (
    SELECT
        strftime('%Y', o.order_date)      AS yr,
        strftime('%m', o.order_date)      AS mo,
        strftime('%Y-%m', o.order_date)   AS yr_mo,
        ROUND(SUM(oi.line_revenue), 0)    AS revenue
    FROM
        fact_orders o
        JOIN fact_order_items oi ON o.order_id = oi.order_id
    WHERE
        o.order_status = 'Delivered'
    GROUP BY
        yr_mo
)
SELECT
    yr,
    mo,
    yr_mo,
    revenue                                              AS current_month_revenue,
    -- Month-over-Month growth
    LAG(revenue, 1) OVER (ORDER BY yr_mo)               AS prev_month_revenue,
    ROUND(
        (revenue - LAG(revenue, 1) OVER (ORDER BY yr_mo))
        / LAG(revenue, 1) OVER (ORDER BY yr_mo) * 100, 1
    )                                                    AS mom_growth_pct,
    -- Year-over-Year growth (compare same month, prior year)
    LAG(revenue, 12) OVER (ORDER BY yr_mo)              AS same_month_last_year,
    ROUND(
        (revenue - LAG(revenue, 12) OVER (ORDER BY yr_mo))
        / LAG(revenue, 12) OVER (ORDER BY yr_mo) * 100, 1
    )                                                    AS yoy_growth_pct
FROM
    monthly_revenue
ORDER BY
    yr_mo;

-- ============================================================
-- QUERY 3: 3-Month Moving Average of Revenue
-- ============================================================
-- Business Question:
--   Smoothing out short-term noise — what is the underlying
--   revenue trend of the business?
-- SQL Technique: AVG() OVER with a sliding window frame
--   (ROWS BETWEEN 2 PRECEDING AND CURRENT ROW).
-- Expected Insight:
--   Moving average smooths out the Q4 festive spike, revealing
--   a steady underlying uptrend in monthly revenues.
-- ============================================================

WITH monthly_rev AS (
    SELECT
        strftime('%Y-%m', o.order_date)   AS yr_mo,
        ROUND(SUM(oi.line_revenue), 0)    AS revenue
    FROM
        fact_orders o
        JOIN fact_order_items oi ON o.order_id = oi.order_id
    WHERE
        o.order_status = 'Delivered'
    GROUP BY
        yr_mo
)
SELECT
    yr_mo,
    revenue                                              AS monthly_revenue,
    ROUND(
        AVG(revenue) OVER (
            ORDER BY yr_mo
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        ), 0
    )                                                    AS revenue_3mo_moving_avg,
    -- Cumulative revenue for the year (resets each year)
    ROUND(
        SUM(revenue) OVER (
            PARTITION BY SUBSTR(yr_mo, 1, 4)
            ORDER BY yr_mo
        ), 0
    )                                                    AS cumulative_revenue_ytd
FROM
    monthly_rev
ORDER BY
    yr_mo;

-- ============================================================
-- QUERY 4: Top 10 Products by Revenue, Profit, and Margin
-- ============================================================
-- Business Question:
--   Which products are our revenue champions and margin
--   champions? Are they the same products?
-- SQL Technique: RANK() window function; CTE for aggregation.
-- Expected Insight:
--   Laptops and Smartphones top revenue; Fashion and Books
--   may have higher margin %. Identifying low-revenue/high-margin
--   products is a pricing opportunity.
-- ============================================================

WITH product_performance AS (
    SELECT
        p.product_id,
        p.product_name,
        p.category,
        p.brand,
        ROUND(p.unit_price - p.unit_cost, 0)                AS list_margin_inr,
        ROUND((p.unit_price - p.unit_cost) / p.unit_price * 100, 1) AS list_margin_pct,
        COUNT(DISTINCT oi.order_id)                          AS orders_containing_product,
        SUM(oi.quantity)                                     AS units_sold,
        ROUND(SUM(oi.line_revenue), 0)                       AS total_revenue,
        ROUND(SUM(oi.line_profit), 0)                        AS total_profit,
        ROUND(SUM(oi.line_profit) / SUM(oi.line_revenue) * 100, 1) AS realised_margin_pct
    FROM
        dim_products p
        JOIN fact_order_items oi ON p.product_id = oi.product_id
        JOIN fact_orders o       ON oi.order_id = o.order_id
    WHERE
        o.order_status = 'Delivered'
    GROUP BY
        p.product_id
)
SELECT
    product_id,
    product_name,
    category,
    brand,
    units_sold,
    total_revenue,
    total_profit,
    realised_margin_pct,
    RANK() OVER (ORDER BY total_revenue DESC) AS revenue_rank,
    RANK() OVER (ORDER BY total_profit DESC)  AS profit_rank,
    RANK() OVER (ORDER BY realised_margin_pct DESC) AS margin_rank
FROM
    product_performance
ORDER BY
    revenue_rank
LIMIT 10;

-- ============================================================
-- QUERY 5: Top 10 Customers by Revenue, Profit & Order Frequency
-- ============================================================
-- Business Question:
--   Who are our highest-value customers? What is their segment
--   and channel? Do they buy often or in large single orders?
-- SQL Technique: RANK(), multiple aggregations, CTE.
-- Expected Insight:
--   B2B accounts likely dominate by revenue per order; loyal
--   B2C customers dominate by order count. Both need protection.
-- ============================================================

WITH customer_value AS (
    SELECT
        c.customer_id,
        c.customer_name,
        c.city,
        c.region,
        c.customer_segment,
        c.acquisition_channel,
        COUNT(DISTINCT o.order_id)                           AS total_orders,
        ROUND(SUM(oi.line_revenue), 0)                       AS total_revenue,
        ROUND(SUM(oi.line_profit), 0)                        AS total_profit,
        ROUND(AVG(o.net_amount), 0)                          AS avg_order_value,
        MIN(o.order_date)                                    AS first_order_date,
        MAX(o.order_date)                                    AS last_order_date,
        ROUND(julianday('now') - julianday(MAX(o.order_date)), 0) AS days_since_last_order
    FROM
        dim_customers c
        JOIN fact_orders o       ON c.customer_id = o.customer_id
        JOIN fact_order_items oi ON o.order_id = oi.order_id
    WHERE
        o.order_status = 'Delivered'
    GROUP BY
        c.customer_id
)
SELECT
    customer_id,
    customer_name,
    city,
    customer_segment,
    acquisition_channel,
    total_orders,
    total_revenue,
    total_profit,
    avg_order_value,
    days_since_last_order,
    RANK() OVER (ORDER BY total_revenue DESC) AS revenue_rank
FROM
    customer_value
ORDER BY
    revenue_rank
LIMIT 10;

-- ============================================================
-- QUERY 6: Revenue and Growth Rate by Region and City
-- ============================================================
-- Business Question:
--   Which geographies are growing fastest? Where should we
--   invest more? Which regions are underperforming?
-- SQL Technique: CTE + LAG() partitioned by region.
-- Expected Insight:
--   West (Mumbai/Thane/Pune) is the largest region but growing
--   slowest. North (Delhi) shows the highest YoY growth rate,
--   indicating an under-penetrated opportunity.
-- ============================================================

WITH region_annual AS (
    SELECT
        c.region,
        c.city,
        strftime('%Y', o.order_date)        AS yr,
        ROUND(SUM(oi.line_revenue), 0)      AS annual_revenue,
        COUNT(DISTINCT o.order_id)          AS order_count,
        COUNT(DISTINCT o.customer_id)       AS unique_customers
    FROM
        dim_customers c
        JOIN fact_orders o       ON c.customer_id = o.customer_id
        JOIN fact_order_items oi ON o.order_id = oi.order_id
    WHERE
        o.order_status = 'Delivered'
    GROUP BY
        c.region, c.city, yr
),
region_growth AS (
    SELECT
        *,
        LAG(annual_revenue) OVER (
            PARTITION BY city ORDER BY yr
        )                                   AS prev_year_revenue,
        ROUND(
            (annual_revenue - LAG(annual_revenue) OVER (PARTITION BY city ORDER BY yr))
            / LAG(annual_revenue) OVER (PARTITION BY city ORDER BY yr) * 100, 1
        )                                   AS yoy_growth_pct
    FROM
        region_annual
)
SELECT
    region,
    city,
    yr                                      AS year,
    annual_revenue,
    order_count,
    unique_customers,
    prev_year_revenue,
    yoy_growth_pct,
    -- Revenue rank within year
    RANK() OVER (PARTITION BY yr ORDER BY annual_revenue DESC) AS revenue_rank_in_year
FROM
    region_growth
ORDER BY
    yr, region, annual_revenue DESC;

-- ============================================================
-- QUERY 7: Revenue and Order Count by Product Category
-- ============================================================
-- Business Question:
--   Which category is our core business? Which is growing
--   fastest? Which has the best margins?
-- SQL Technique: CASE WHEN, conditional SUM, GROUP BY.
-- Expected Insight:
--   Electronics is the revenue engine but margin-challenged.
--   Books & Stationery has the highest margin % but lowest
--   absolute revenue — a scaling opportunity.
-- ============================================================

SELECT
    p.category,
    COUNT(DISTINCT o.order_id)                              AS total_orders,
    SUM(oi.quantity)                                        AS total_units,
    ROUND(SUM(oi.line_revenue), 0)                          AS total_revenue,
    ROUND(SUM(oi.line_profit), 0)                           AS total_profit,
    ROUND(SUM(oi.line_profit) / SUM(oi.line_revenue) * 100, 1) AS margin_pct,
    -- Revenue share across all categories
    ROUND(
        SUM(oi.line_revenue) * 100.0
        / SUM(SUM(oi.line_revenue)) OVER (), 1
    )                                                       AS revenue_share_pct,
    ROUND(AVG(oi.unit_price), 0)                            AS avg_unit_price
FROM
    dim_products p
    JOIN fact_order_items oi ON p.product_id = oi.product_id
    JOIN fact_orders o       ON oi.order_id = o.order_id
WHERE
    o.order_status = 'Delivered'
GROUP BY
    p.category
ORDER BY
    total_revenue DESC;

-- ============================================================
-- QUERY 8: New vs. Repeat Customer Revenue Split
-- ============================================================
-- Business Question:
--   Are we a business that acquires and retains customers, or
--   one that constantly needs new customer acquisition?
--   How much revenue comes from loyal returning customers?
-- SQL Technique: CTE with MIN() to find first purchase date,
--   then LEFT JOIN to classify each order.
-- Expected Insight:
--   If repeat customer revenue is below 40%, retention is a
--   critical strategic gap requiring loyalty programme investment.
-- ============================================================

WITH first_purchases AS (
    -- Find each customer's first ever order date
    SELECT
        customer_id,
        MIN(order_date)     AS first_order_date
    FROM
        fact_orders
    WHERE
        order_status = 'Delivered'
    GROUP BY
        customer_id
),
order_classification AS (
    SELECT
        o.order_id,
        o.customer_id,
        o.order_date,
        fp.first_order_date,
        CASE
            WHEN o.order_date = fp.first_order_date THEN 'New Customer'
            ELSE 'Repeat Customer'
        END                  AS customer_type,
        oi.line_revenue,
        oi.line_profit
    FROM
        fact_orders o
        JOIN first_purchases fp ON o.customer_id = fp.customer_id
        JOIN fact_order_items oi ON o.order_id = oi.order_id
    WHERE
        o.order_status = 'Delivered'
)
SELECT
    strftime('%Y', order_date)              AS year,
    customer_type,
    COUNT(DISTINCT order_id)               AS total_orders,
    COUNT(DISTINCT customer_id)            AS unique_customers,
    ROUND(SUM(line_revenue), 0)            AS total_revenue,
    ROUND(SUM(line_profit), 0)             AS total_profit,
    -- Revenue share of each customer type within the year
    ROUND(
        SUM(line_revenue) * 100.0
        / SUM(SUM(line_revenue)) OVER (PARTITION BY strftime('%Y', order_date)), 1
    )                                      AS revenue_share_pct
FROM
    order_classification
GROUP BY
    year, customer_type
ORDER BY
    year, customer_type;

-- ============================================================
-- QUERY 9: Customer Cohort Retention Analysis
-- ============================================================
-- Business Question:
--   Of customers who made their first purchase in a given month,
--   what percentage came back and bought again in subsequent months?
--   Where is the biggest drop-off?
-- SQL Technique: CTE chain — cohort assignment → cohort orders →
--   month index calculation → GROUP BY cohort + month index.
-- Expected Insight:
--   Month 0 (first purchase) = 100%. A sharp drop to <30% by
--   Month 3 indicates a weak re-engagement / nurturing strategy.
-- ============================================================

WITH customer_cohorts AS (
    -- Assign each customer to their acquisition cohort (first purchase month)
    SELECT
        customer_id,
        MIN(strftime('%Y-%m', order_date))  AS cohort_month
    FROM
        fact_orders
    WHERE
        order_status = 'Delivered'
    GROUP BY
        customer_id
),
cohort_orders AS (
    -- Match each subsequent order back to the customer's cohort
    SELECT
        cc.cohort_month,
        o.customer_id,
        strftime('%Y-%m', o.order_date)     AS order_month
    FROM
        fact_orders o
        JOIN customer_cohorts cc ON o.customer_id = cc.customer_id
    WHERE
        o.order_status = 'Delivered'
),
cohort_size AS (
    -- Count of unique customers per cohort (the denominator)
    SELECT
        cohort_month,
        COUNT(DISTINCT customer_id)         AS cohort_customers
    FROM
        customer_cohorts
    GROUP BY
        cohort_month
),
cohort_retention AS (
    SELECT
        co.cohort_month,
        co.order_month,
        COUNT(DISTINCT co.customer_id)      AS active_customers,
        -- Month index: how many months after first purchase?
        (
            (CAST(SUBSTR(co.order_month, 1, 4) AS INTEGER) * 12 +
             CAST(SUBSTR(co.order_month, 6, 2) AS INTEGER))
            -
            (CAST(SUBSTR(co.cohort_month, 1, 4) AS INTEGER) * 12 +
             CAST(SUBSTR(co.cohort_month, 6, 2) AS INTEGER))
        )                                   AS months_since_acquisition
    FROM
        cohort_orders co
    GROUP BY
        co.cohort_month, co.order_month
)
SELECT
    cr.cohort_month,
    cs.cohort_customers                                     AS cohort_size,
    cr.months_since_acquisition                             AS period,
    cr.active_customers,
    ROUND(cr.active_customers * 100.0 / cs.cohort_customers, 1) AS retention_rate_pct
FROM
    cohort_retention cr
    JOIN cohort_size cs ON cr.cohort_month = cs.cohort_month
WHERE
    cr.months_since_acquisition <= 12   -- Show first 12 months of behaviour
ORDER BY
    cr.cohort_month, cr.months_since_acquisition;

-- ============================================================
-- QUERY 10: Average Order Value (AOV) by Region, Category & Channel
-- ============================================================
-- Business Question:
--   Where and how are our highest-value orders placed?
--   Should we push customers toward higher-AOV channels
--   or regions?
-- SQL Technique: Multi-dimensional GROUP BY with ROLLUP concept
--   using UNION for breakdown views; ROUND(), AVG().
-- Expected Insight:
--   B2B Field Sales likely has the highest AOV; Online may
--   have higher AOV than In-Store due to premium product browsing.
-- ============================================================

-- AOV by Region
SELECT
    'By Region'                             AS breakdown_type,
    c.region                                AS dimension,
    COUNT(DISTINCT o.order_id)              AS total_orders,
    ROUND(SUM(oi.line_revenue), 0)          AS total_revenue,
    ROUND(AVG(o.net_amount), 0)             AS avg_order_value_inr
FROM
    dim_customers c
    JOIN fact_orders o       ON c.customer_id = o.customer_id
    JOIN fact_order_items oi ON o.order_id = oi.order_id
WHERE
    o.order_status = 'Delivered'
GROUP BY c.region

UNION ALL

-- AOV by Product Category
SELECT
    'By Category'                           AS breakdown_type,
    p.category                              AS dimension,
    COUNT(DISTINCT o.order_id)              AS total_orders,
    ROUND(SUM(oi.line_revenue), 0)          AS total_revenue,
    ROUND(AVG(oi.line_revenue / oi.quantity * oi.quantity), 0) AS avg_order_value_inr
FROM
    dim_products p
    JOIN fact_order_items oi ON p.product_id = oi.product_id
    JOIN fact_orders o       ON oi.order_id = o.order_id
WHERE
    o.order_status = 'Delivered'
GROUP BY p.category

UNION ALL

-- AOV by Order Channel
SELECT
    'By Channel'                            AS breakdown_type,
    o.order_channel                         AS dimension,
    COUNT(DISTINCT o.order_id)              AS total_orders,
    ROUND(SUM(oi.line_revenue), 0)          AS total_revenue,
    ROUND(AVG(o.net_amount), 0)             AS avg_order_value_inr
FROM
    fact_orders o
    JOIN fact_order_items oi ON o.order_id = oi.order_id
WHERE
    o.order_status = 'Delivered'
GROUP BY o.order_channel

ORDER BY breakdown_type, avg_order_value_inr DESC;

-- ============================================================
-- QUERY 11: Customer Lifetime Value (CLV) Approximation
-- ============================================================
-- Business Question:
--   What is the long-term revenue value of each customer?
--   Which customers should we invest in retaining vs. acquiring
--   new ones?
-- Method: Historical CLV (simple) =
--   Total Revenue × (Active Months / Business Months) × 24
--   This gives a 24-month forward projection based on past rate.
-- SQL Technique: Multiple CTEs, date arithmetic, window RANK().
-- Expected Insight:
--   High CLV B2B accounts need relationship management.
--   Low CLV high-frequency B2C customers need loyalty programme.
-- ============================================================

WITH customer_stats AS (
    SELECT
        c.customer_id,
        c.customer_name,
        c.city,
        c.region,
        c.customer_segment,
        c.acquisition_channel,
        MIN(o.order_date)                                   AS first_purchase,
        MAX(o.order_date)                                   AS last_purchase,
        COUNT(DISTINCT o.order_id)                          AS total_orders,
        ROUND(SUM(oi.line_revenue), 0)                      AS total_revenue,
        ROUND(SUM(oi.line_profit), 0)                       AS total_profit,
        ROUND(AVG(o.net_amount), 0)                         AS avg_order_value,
        -- Customer lifespan in months
        ROUND(
            (julianday(MAX(o.order_date)) - julianday(MIN(o.order_date))) / 30.4, 1
        )                                                   AS lifespan_months
    FROM
        dim_customers c
        JOIN fact_orders o       ON c.customer_id = o.customer_id
        JOIN fact_order_items oi ON o.order_id = oi.order_id
    WHERE
        o.order_status = 'Delivered'
    GROUP BY
        c.customer_id
),
clv_calc AS (
    SELECT
        *,
        -- Purchase frequency: orders per month active
        ROUND(
            CASE
                WHEN lifespan_months > 0 THEN total_orders / lifespan_months
                ELSE total_orders  -- single-month customer
            END, 2
        )                                                   AS orders_per_month,
        -- Simple historical CLV: project 24 months at current rate
        ROUND(
            (total_revenue / NULLIF(lifespan_months, 0)) * 24,
            0
        )                                                   AS projected_24mo_clv,
        -- Days since last purchase (recency)
        ROUND(julianday('now') - julianday(last_purchase), 0) AS recency_days
    FROM
        customer_stats
)
SELECT
    customer_id,
    customer_name,
    city,
    customer_segment,
    acquisition_channel,
    total_orders,
    total_revenue,
    avg_order_value,
    lifespan_months,
    orders_per_month,
    projected_24mo_clv,
    recency_days,
    RANK() OVER (ORDER BY projected_24mo_clv DESC NULLS LAST) AS clv_rank,
    -- CLV tier for segmentation
    CASE
        WHEN projected_24mo_clv >= 500000 THEN 'Platinum'
        WHEN projected_24mo_clv >= 200000 THEN 'Gold'
        WHEN projected_24mo_clv >= 50000  THEN 'Silver'
        ELSE                                   'Standard'
    END                                                     AS clv_tier
FROM
    clv_calc
ORDER BY
    clv_rank;

-- ============================================================
-- QUERY 12: RFM Segmentation — Identify At-Risk Customers
-- ============================================================
-- Business Question:
--   Which customers are slipping away? Who are our champions,
--   and who needs a win-back campaign?
-- Method: RFM = Recency + Frequency + Monetary scoring.
--   Each dimension scored 1–4 using NTILE(4).
--   Combined score used to assign customer segment labels.
-- SQL Technique: Multi-step CTEs, NTILE(), CASE, ROUND().
-- Expected Insight:
--   Customers with R=1, F=1, M=1 are churned and not worth
--   expensive win-back. R=1/2 with F=3/4 are "At Risk Champions"
--   — the most valuable win-back targets.
-- ============================================================

WITH rfm_base AS (
    SELECT
        c.customer_id,
        c.customer_name,
        c.city,
        c.region,
        c.customer_segment,
        -- Recency: days since last purchase (lower = more recent)
        ROUND(julianday('now') - julianday(MAX(o.order_date)), 0) AS recency_days,
        -- Frequency: number of orders
        COUNT(DISTINCT o.order_id)                                  AS frequency,
        -- Monetary: total revenue
        ROUND(SUM(oi.line_revenue), 0)                              AS monetary
    FROM
        dim_customers c
        JOIN fact_orders o       ON c.customer_id = o.customer_id
        JOIN fact_order_items oi ON o.order_id = oi.order_id
    WHERE
        o.order_status = 'Delivered'
    GROUP BY
        c.customer_id
),
rfm_scored AS (
    SELECT
        *,
        -- R score: 4 = most recent, 1 = least recent
        -- NTILE(4) assigns quartiles; we invert recency so low days = high score
        5 - NTILE(4) OVER (ORDER BY recency_days DESC)      AS r_score,
        -- F score: 4 = highest frequency
        NTILE(4) OVER (ORDER BY frequency ASC)              AS f_score,
        -- M score: 4 = highest monetary value
        NTILE(4) OVER (ORDER BY monetary ASC)               AS m_score
    FROM
        rfm_base
),
rfm_final AS (
    SELECT
        *,
        (r_score + f_score + m_score)                       AS rfm_total,
        -- Segment labels based on RFM profile
        CASE
            WHEN r_score >= 4 AND f_score >= 3 AND m_score >= 3
                THEN 'Champion'
            WHEN r_score >= 3 AND f_score >= 3
                THEN 'Loyal Customer'
            WHEN r_score >= 3 AND f_score <= 2
                THEN 'Promising'
            WHEN r_score = 2 AND f_score >= 3
                THEN 'At Risk — High Value'          -- Most urgent win-back target
            WHEN r_score = 2 AND f_score <= 2
                THEN 'At Risk — Low Value'
            WHEN r_score = 1 AND f_score >= 3
                THEN 'Cannot Lose — Act Now'         -- Was champion, now dormant
            WHEN r_score = 1 AND f_score <= 2
                THEN 'Lost / Churned'
            ELSE 'Need Attention'
        END                                                  AS rfm_segment
    FROM
        rfm_scored
)
SELECT
    customer_id,
    customer_name,
    city,
    region,
    customer_segment,
    recency_days,
    frequency          AS total_orders,
    monetary           AS total_revenue,
    r_score,
    f_score,
    m_score,
    rfm_total,
    rfm_segment
FROM
    rfm_final
ORDER BY
    rfm_total DESC,
    monetary DESC;

-- ============================================================
-- BONUS SUMMARY: Segment-level RFM Rollup
-- ============================================================
-- Quick snapshot of how many customers fall in each segment
-- and their combined revenue — useful for a dashboard KPI card.
-- ============================================================

WITH rfm_base AS (
    SELECT
        c.customer_id,
        ROUND(julianday('now') - julianday(MAX(o.order_date)), 0) AS recency_days,
        COUNT(DISTINCT o.order_id)                                  AS frequency,
        ROUND(SUM(oi.line_revenue), 0)                              AS monetary
    FROM
        dim_customers c
        JOIN fact_orders o       ON c.customer_id = o.customer_id
        JOIN fact_order_items oi ON o.order_id = oi.order_id
    WHERE
        o.order_status = 'Delivered'
    GROUP BY c.customer_id
),
rfm_scored AS (
    SELECT *,
        5 - NTILE(4) OVER (ORDER BY recency_days DESC) AS r_score,
        NTILE(4) OVER (ORDER BY frequency ASC)         AS f_score,
        NTILE(4) OVER (ORDER BY monetary ASC)          AS m_score
    FROM rfm_base
),
rfm_segments AS (
    SELECT *,
        CASE
            WHEN r_score >= 4 AND f_score >= 3 AND m_score >= 3 THEN 'Champion'
            WHEN r_score >= 3 AND f_score >= 3                  THEN 'Loyal Customer'
            WHEN r_score >= 3 AND f_score <= 2                  THEN 'Promising'
            WHEN r_score = 2 AND f_score >= 3                   THEN 'At Risk — High Value'
            WHEN r_score = 2 AND f_score <= 2                   THEN 'At Risk — Low Value'
            WHEN r_score = 1 AND f_score >= 3                   THEN 'Cannot Lose — Act Now'
            WHEN r_score = 1 AND f_score <= 2                   THEN 'Lost / Churned'
            ELSE 'Need Attention'
        END AS rfm_segment
    FROM rfm_scored
)
SELECT
    rfm_segment,
    COUNT(*)                            AS customer_count,
    ROUND(SUM(monetary), 0)            AS total_revenue,
    ROUND(AVG(monetary), 0)            AS avg_revenue_per_customer,
    ROUND(AVG(recency_days), 0)        AS avg_recency_days
FROM
    rfm_segments
GROUP BY
    rfm_segment
ORDER BY
    total_revenue DESC;

-- ============================================================
-- End of analysis queries
-- ============================================================
