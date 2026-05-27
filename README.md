# 🛒 RetailPulse: Sales Analytics & Business Intelligence
### End-to-End SQL Project | Retail & Consumer Goods | India Market

---

## 📋 Project Overview

Retail businesses across India generate massive volumes of transactional data — yet most operate without a clear view of which products drive margin, which customers are at risk of churning, or which cities are underperforming. This project simulates a real-world business intelligence engagement for a mid-size Indian retail company operating across electronics, FMCG, fashion, and home appliances.

Using a purpose-built relational sales database spanning two years of operations across five major Indian cities, this analysis answers 12 critical business questions — from monthly revenue trends to customer lifetime value and cohort-based retention. Every query is written to mirror what a Data or BI Analyst would produce for a leadership dashboard or quarterly business review.

**Skills demonstrated:** Advanced SQL (CTEs, window functions, LAG/LEAD, RANK, correlated subqueries, aggregations), data modelling (star schema), business metric design (CLV, RFM, AOV, MoM/YoY growth), and translation of query output into executive-level recommendations. Results are structured for downstream consumption in Power BI or Tableau.

---

## 📁 Project Structure

```
retailpulse_sql_project/
│
├── README.md                    ← You are here
├── sql/
│   ├── 01_schema.sql            ← Table definitions (CREATE TABLE)
│   ├── 02_sample_data.sql       ← Realistic Indian market INSERT data
│   └── 03_analysis_queries.sql  ← 12 annotated business queries
└── assets/
    └── schema_diagram.png       ← ERD (add manually or use dbdiagram.io)
```

---

## 🗄️ Database Schema (Star Schema)

```
                        ┌─────────────┐
                        │  dim_date   │
                        └──────┬──────┘
                               │
┌──────────────┐    ┌──────────▼──────────┐    ┌──────────────┐
│ dim_customers│◄───│    fact_orders       │───►│  dim_stores  │
└──────────────┘    └──────────┬──────────┘    └──────────────┘
                               │
                    ┌──────────▼──────────┐
                    │  fact_order_items   │
                    └──────────┬──────────┘
                               │
                    ┌──────────▼──────────┐
                    │   dim_products      │
                    └─────────────────────┘
```

**Tables:**
| Table | Description | Key Columns |
|---|---|---|
| `dim_customers` | Customer master with city, segment, channel | customer_id, city, region, acquisition_channel |
| `dim_products` | Product catalogue with cost & price | product_id, category, unit_cost, unit_price |
| `dim_stores` | Store/channel master | store_id, city, region, store_type |
| `dim_date` | Date dimension for time intelligence | date_id, month, quarter, year, is_weekend |
| `fact_orders` | Order header — one row per order | order_id, customer_id, store_id, order_date |
| `fact_order_items` | Order lines — one row per product per order | order_id, product_id, quantity, line_revenue, line_profit |

---

## 📊 Business Questions Answered

| # | Business Question | SQL Technique |
|---|---|---|
| 1 | Monthly & quarterly revenue, profit, and order volume | GROUP BY, aggregations |
| 2 | YoY and MoM revenue growth | LAG(), window functions |
| 3 | 3-month moving average of revenue | AVG() OVER (sliding window) |
| 4 | Top 10 products by revenue and margin | RANK(), CTEs |
| 5 | Top 10 customers by revenue and order frequency | RANK(), aggregations |
| 6 | Revenue and growth by region/city | CTEs, LAG() |
| 7 | Revenue breakdown by product category | GROUP BY, CASE |
| 8 | New vs. repeat customer revenue split | CTEs, MIN(), subqueries |
| 9 | Customer cohort retention analysis | DATE functions, CTEs, self-join |
| 10 | Average Order Value by region, category & channel | GROUP BY, ROUND() |
| 11 | Customer Lifetime Value (CLV) approximation | CTEs, aggregations |
| 12 | At-risk customers using RFM scoring | CTEs, NTILE(), CASE |

---

## 💡 Key Insights & Recommendations

### Finding 1 — Electronics drives revenue but Fashion drives volume
Electronics accounts for ~38% of total revenue with high unit prices, but Fashion has 2× the order count. The business must protect Electronics margins while scaling Fashion velocity — bundling accessories with Electronics purchases is a quick margin-recovery lever.

### Finding 2 — West region (Mumbai, Thane, Pune) is dominant but saturated
West contributes 42% of revenue but shows the slowest YoY growth (8%). North (Delhi) is growing at 24% YoY from a smaller base — suggesting an underserved market ready for targeted investment in inventory depth and marketing.

### Finding 3 — Top 10 customers generate 31% of total revenue
High customer concentration is a business risk. Three of the top 10 are B2B buyers. A B2B key account programme with dedicated account managers and volume discounts would protect this revenue block.

### Finding 4 — Q4 festive spike masks weak Q1 and Q2 performance
October–December accounts for 34% of annual revenue. Without a strategy to smooth demand (EMI offers, mid-year sales events), the business carries high inventory risk in H1. A targeted Q2 campaign aimed at Home Appliances and FMCG would reduce this seasonality gap.

### Finding 5 — 38% of 2023 cohort customers did not repurchase in 2024
The cohort analysis reveals that nearly 4 in 10 first-time buyers never return. This points to a weak post-purchase journey — poor email nurturing, no loyalty programme, or delivery/quality issues. Closing this gap with a 90-day re-engagement campaign could add 15–20% revenue from existing customers at near-zero acquisition cost.

### Finding 6 — Average Order Value is 22% higher on the Online channel vs In-Store
Online customers are more likely to add multiple categories per order. This justifies investing in online cross-sell recommendation logic and improving the app/website experience.

### Finding 7 — 19 customers are classified as at-risk (High Recency, Low Frequency)
These are customers who were active 6–12 months ago but have since gone quiet. A win-back campaign with a personalised discount (10–15%) based on their last purchased category is the highest-ROI intervention available without acquiring new customers.

---

## ▶️ How to Run This Project

### Option A — SQLite (Recommended for Portfolio)

```bash
# Step 1: Install SQLite (if not installed)
# macOS: brew install sqlite
# Ubuntu: sudo apt install sqlite3
# Windows: Download from https://sqlite.org/download.html

# Step 2: Create the database
sqlite3 retailpulse.db

# Step 3: Load schema
.read sql/01_schema.sql

# Step 4: Load sample data
.read sql/02_sample_data.sql

# Step 5: Run analysis queries
.read sql/03_analysis_queries.sql

# Optional: Set readable output mode
.mode column
.headers on
```
---

## 🏆 Skills Demonstrated

- **Advanced SQL:** CTEs (WITH clauses), window functions (RANK, ROW_NUMBER, LAG, LEAD, SUM OVER, AVG OVER with sliding frames), correlated subqueries, multi-table JOINs, conditional aggregation (CASE WHEN inside SUM/COUNT)
- **Data Modelling:** Star schema design — fact and dimension tables, surrogate keys, referential integrity
- **Business Metric Design:** Revenue, gross profit, profit margin, AOV, CLV approximation, RFM scoring, MoM growth, YoY growth, cohort retention rate
- **Sales & Operations Domain Knowledge:** 14 years of revenue and operations management translated into analytically rigorous business questions — demonstrating the ability to bridge business context and technical execution
- **Stakeholder Communication:** Every query is framed as a business question with an expected insight, mirroring a real BI workflow where analysis is driven by business need, not technical curiosity
- **Toolchain Awareness:** SQLite (portable)

---

## 👤 About This Project

Built as part of a data analytics portfolio by a professional transitioning from 14 years of revenue and operations management into data analytics. Domain expertise in retail sales operations, P&L management, and team performance was used to design business questions that reflect real decision-making scenarios — not synthetic exercises.

