-- ============================================================
-- RetailPulse: Sales Analytics Project
-- File: 02_sample_data.sql
-- Description: Realistic sample data — Indian retail market
--              Covers Jan 2023 – Sep 2024 (21 months)
--              Cities: Mumbai, Thane, Pune, Delhi, Bengaluru,
--                      Hyderabad, Chennai, Kolkata, Jaipur
-- ============================================================

-- ============================================================
-- 1. DIMENSION: dim_stores (5 stores / channels)
-- ============================================================
INSERT INTO dim_stores VALUES
('S001', 'Mumbai Flagship',    'Mumbai',    'Maharashtra', 'West',      'Flagship',  '2020-04-01'),
('S002', 'Delhi Express',      'New Delhi', 'Delhi',       'North',     'Express',   '2021-01-15'),
('S003', 'Bengaluru Hub',      'Bengaluru', 'Karnataka',   'South',     'Flagship',  '2021-06-01'),
('S004', 'Kolkata Express',    'Kolkata',   'West Bengal', 'East',      'Express',   '2022-03-10'),
('S005', 'RetailPulse Online', 'Pan-India', 'Pan-India',   'Pan-India', 'Online',    '2020-01-01');

-- ============================================================
-- 2. DIMENSION: dim_products (20 products across 5 categories)
-- ============================================================
-- Electronics (high price, moderate margin)
INSERT INTO dim_products VALUES
('P001', 'ProMax Smartphone 128GB',  'Electronics',     'Mobile Phones',  'ProMax',    18500, 32999, 1),
('P002', 'UltraBook Laptop 15.6"',   'Electronics',     'Laptops',        'UltraBook', 42000, 72999, 1),
('P003', 'SoundFit Wireless Earbuds','Electronics',     'Audio',          'SoundFit',   1800,  3999, 1),
('P004', 'VisionHD Smart TV 43"',    'Electronics',     'Televisions',    'VisionHD',  18000, 32499, 1),
('P005', 'SwiftTab 10" Tablet',      'Electronics',     'Tablets',        'SwiftTab',   9500, 17999, 1),

-- FMCG (low price, high volume, good margin)
('P006', 'PremiumLeaf Green Tea 500g','FMCG',           'Beverages',      'PremiumLeaf', 180,   499, 1),
('P007', 'FitFuel Whey Protein 1kg', 'FMCG',           'Health & Nutrition','FitFuel', 1200,  2499, 1),
('P008', 'QuickBite Noodles Pack x12','FMCG',          'Packaged Foods', 'QuickBite',   180,   399, 1),
('P009', 'AromaBrew Filter Coffee 500g','FMCG',        'Beverages',      'AromaBrew',   220,   549, 1),

-- Fashion (moderate price, high margin)
('P010', 'SlimFit Formal Shirt (Men)','Fashion',        'Apparel Men',    'SlimFit',     450,  1299, 1),
('P011', 'EthnicWear Cotton Kurti',  'Fashion',         'Apparel Women',  'EthnicWear',  380,   999, 1),
('P012', 'DenimEdge Slim Jeans',     'Fashion',         'Apparel Unisex', 'DenimEdge',   600,  1799, 1),
('P013', 'StridePro Running Shoes',  'Fashion',         'Footwear',       'StridePro',  1200,  3499, 1),

-- Home Appliances (moderate price, moderate margin)
('P014', 'PureAir Room Air Purifier','Home Appliances', 'Air Quality',    'PureAir',    4500,  8999, 1),
('P015', 'BrewMate Electric Kettle', 'Home Appliances', 'Kitchen',        'BrewMate',    550,  1299, 1),
('P016', 'BlendMaster Mixer Grinder','Home Appliances', 'Kitchen',        'BlendMaster', 1800,  3799, 1),
('P017', 'WarmZone Room Heater',     'Home Appliances', 'Heating',        'WarmZone',   1200,  2499, 1),

-- Books & Stationery (low price, high margin)
('P018', 'UPSC Prep Complete Set',   'Books & Stationery','Civil Services Books','StudyIndia',500, 1299, 1),
('P019', 'Business Strategy Playbook','Books & Stationery','Management Books','MindPress', 250,   699, 1),
('P020', 'PremiumWrite Notebook Set x5','Books & Stationery','Stationery','PremiumWrite',180,   449, 1);

-- ============================================================
-- 3. DIMENSION: dim_customers (25 customers — mix of B2C, B2B, SME)
-- ============================================================
INSERT INTO dim_customers VALUES
-- High-value B2C customers (West region)
('C001','Rahul Mehta',         'rahul.mehta@gmail.com',       '9821034567','Mumbai',    'Maharashtra','West', 'B2C','Online',         '2023-01-10'),
('C002','Priya Sharma',        'priya.sharma@yahoo.com',      '9819876543','Thane',     'Maharashtra','West', 'B2C','In-Store',       '2023-02-14'),
('C003','Amit Patel',          'amit.patel@gmail.com',        '9922334455','Pune',      'Maharashtra','West', 'B2C','Online',         '2023-01-22'),
('C004','Sneha Joshi',         'sneha.joshi@outlook.com',     '9920012345','Mumbai',    'Maharashtra','West', 'B2C','Referral',       '2023-03-05'),
('C005','Vikram Desai',        'vikram.desai@gmail.com',      '9923456789','Pune',      'Maharashtra','West', 'B2C','Online',         '2023-01-18'),

-- High-value B2B customers
('C006','Nexus Retail Pvt Ltd','procurement@nexusretail.in',  '1140023456','New Delhi', 'Delhi',      'North','B2B','Field Sales',    '2023-02-01'),
('C007','Bharat Electronics Co','purchase@bharatelec.co.in', '2230045678','Bengaluru', 'Karnataka',  'South','B2B','Field Sales',    '2023-03-15'),
('C008','Sunrise Distributors', 'orders@sunrisedist.in',      '3340056789','Kolkata',   'West Bengal','East', 'B2B','Field Sales',    '2023-04-01'),

-- Mid-value B2C customers (North region)
('C009','Arjun Singh',         'arjun.singh@gmail.com',       '9811223344','New Delhi', 'Delhi',      'North','B2C','Online',         '2023-02-20'),
('C010','Kavya Nair',          'kavya.nair@gmail.com',        '9810334455','New Delhi', 'Delhi',      'North','B2C','In-Store',       '2023-04-10'),
('C011','Rohit Yadav',         'rohit.yadav@outlook.com',     '9818765432','Jaipur',    'Rajasthan',  'North','B2C','Online',         '2023-05-03'),

-- Mid-value B2C customers (South region)
('C012','Divya Krishnan',      'divya.k@gmail.com',           '9944123456','Bengaluru', 'Karnataka',  'South','B2C','Online',         '2023-03-08'),
('C013','Suresh Menon',        'suresh.menon@yahoo.com',      '9945678901','Chennai',   'Tamil Nadu', 'South','B2C','In-Store',       '2023-04-22'),
('C014','Ananya Reddy',        'ananya.r@gmail.com',          '9940234567','Hyderabad', 'Telangana',  'South','B2C','Referral',       '2023-06-01'),
('C015','Kiran Pillai',        'kiran.p@gmail.com',           '9942345678','Bengaluru', 'Karnataka',  'South','B2C','Online',         '2023-07-14'),

-- East region customers
('C016','Saurabh Das',         'saurabh.das@gmail.com',       '9830123456','Kolkata',   'West Bengal','East', 'B2C','In-Store',       '2023-05-19'),
('C017','Mousumi Chakraborty', 'mousumi.c@gmail.com',         '9831234567','Kolkata',   'West Bengal','East', 'B2C','Online',         '2023-06-30'),

-- SME customers
('C018','TechSpark Solutions',  'accounts@techspark.in',      '2226789012','Mumbai',    'Maharashtra','West', 'SME','Field Sales',    '2023-04-15'),
('C019','EduFirst Academy',     'purchase@edufirst.in',       '1146789012','New Delhi', 'Delhi',      'North','SME','Referral',       '2023-05-01'),

-- Occasional / at-risk customers (active only in early 2023)
('C020','Pooja Iyer',           'pooja.iyer@gmail.com',       '9940567890','Chennai',   'Tamil Nadu', 'South','B2C','Online',         '2023-01-30'),
('C021','Nikhil Bansal',        'nikhil.bansal@gmail.com',    '9815678901','New Delhi', 'Delhi',      'North','B2C','In-Store',       '2023-02-25'),
('C022','Rashmi Gupta',         'rashmi.gupta@yahoo.com',     '9816789012','Jaipur',    'Rajasthan',  'North','B2C','Online',         '2023-03-12'),
('C023','Deepak Kulkarni',      'deepak.k@gmail.com',         '9921789012','Pune',      'Maharashtra','West', 'B2C','Referral',       '2023-04-05'),
('C024','Farhan Sheikh',        'farhan.s@gmail.com',         '9833456789','Kolkata',   'West Bengal','East', 'B2C','Online',         '2023-02-08'),
('C025','Meena Agarwal',        'meena.a@outlook.com',        '9812456789','New Delhi', 'Delhi',      'North','B2C','In-Store',       '2023-01-15');

-- ============================================================
-- 4. FACT TABLE: fact_orders
-- ============================================================
-- Note: net_amount = total_amount - discount_amount + shipping_cost
-- Orders span Jan 2023 – Sep 2024 to enable YoY analysis

INSERT INTO fact_orders VALUES
-- ── JAN 2023 ──────────────────────────────────────────────────────────────
('O001','C001','S005','2023-01-12','Online',     'Delivered','Mumbai',   32999,  1650.0, 0,    31349),
('O002','C003','S001','2023-01-18','In-Store',   'Delivered','Pune',     72999,  3650.0, 0,    69349),
('O003','C025','S002','2023-01-20','In-Store',   'Delivered','New Delhi', 1299,     0.0, 80,    1379),
('O004','C005','S005','2023-01-28','Online',     'Delivered','Pune',      3999,   200.0, 0,     3799),

-- ── FEB 2023 ──────────────────────────────────────────────────────────────
('O005','C002','S001','2023-02-05','In-Store',   'Delivered','Thane',    32999,  1650.0, 0,    31349),
('O006','C006','S002','2023-02-10','Field Sales','Delivered','New Delhi', 8995,     0.0, 500,   9495),
('O007','C009','S002','2023-02-22','In-Store',   'Delivered','New Delhi',17999,   900.0, 0,    17099),
('O008','C021','S002','2023-02-26','In-Store',   'Delivered','New Delhi', 2599,   130.0, 0,     2469),
('O009','C024','S004','2023-02-15','In-Store',   'Delivered','Kolkata',   1799,     0.0, 0,     1799),

-- ── MAR 2023 ──────────────────────────────────────────────────────────────
('O010','C004','S005','2023-03-03','Online',     'Delivered','Mumbai',    3999,   200.0, 0,     3799),
('O011','C007','S003','2023-03-16','Field Sales','Delivered','Bengaluru',72999,  3650.0, 0,    69349),
('O012','C012','S003','2023-03-09','Online',     'Delivered','Bengaluru', 8999,   450.0, 0,     8549),
('O013','C022','S005','2023-03-18','Online',     'Delivered','Jaipur',    1299,     0.0, 99,    1398),
('O014','C020','S005','2023-03-25','Online',     'Delivered','Chennai',  17999,   900.0, 0,    17099),

-- ── APR 2023 ──────────────────────────────────────────────────────────────
('O015','C001','S005','2023-04-08','Online',     'Delivered','Mumbai',    2499,   125.0, 0,     2374),
('O016','C010','S002','2023-04-15','In-Store',   'Delivered','New Delhi', 1299,     0.0, 0,     1299),
('O017','C008','S004','2023-04-20','Field Sales','Delivered','Kolkata',  32499,  1625.0, 0,    30874),
('O018','C023','S001','2023-04-28','In-Store',   'Delivered','Pune',      3799,   190.0, 0,     3609),
('O019','C018','S001','2023-04-12','Field Sales','Delivered','Mumbai',   10495,     0.0, 0,    10495),

-- ── MAY 2023 ──────────────────────────────────────────────────────────────
('O020','C003','S005','2023-05-06','Online',     'Delivered','Pune',      3999,   200.0, 0,     3799),
('O021','C011','S005','2023-05-12','Online',     'Delivered','Jaipur',   32999,  1650.0, 0,    31349),
('O022','C016','S004','2023-05-20','In-Store',   'Delivered','Kolkata',   1299,     0.0, 0,     1299),
('O023','C019','S002','2023-05-05','Field Sales','Delivered','New Delhi', 2598,     0.0, 0,     2598),

-- ── JUN 2023 ──────────────────────────────────────────────────────────────
('O024','C005','S005','2023-06-10','Online',     'Delivered','Pune',     17999,   900.0, 0,    17099),
('O025','C013','S003','2023-06-18','In-Store',   'Delivered','Chennai',   3799,   190.0, 0,     3609),
('O026','C014','S005','2023-06-22','Online',     'Delivered','Hyderabad', 8999,   450.0, 0,     8549),
('O027','C017','S004','2023-06-30','Online',     'Delivered','Kolkata',   2499,   125.0, 0,     2374),

-- ── JUL 2023 ──────────────────────────────────────────────────────────────
('O028','C002','S001','2023-07-04','In-Store',   'Delivered','Thane',     1799,     0.0, 0,     1799),
('O029','C006','S002','2023-07-15','Field Sales','Delivered','New Delhi',32999,  1650.0, 0,    31349),
('O030','C009','S005','2023-07-22','Online',     'Delivered','New Delhi', 2499,   125.0, 0,     2374),
('O031','C015','S003','2023-07-14','Online',     'Delivered','Bengaluru',32999,  1650.0, 0,    31349),

-- ── AUG 2023 ──────────────────────────────────────────────────────────────
('O032','C001','S005','2023-08-18','Online',     'Delivered','Mumbai',    8999,   450.0, 0,     8549),
('O033','C004','S001','2023-08-05','In-Store',   'Delivered','Mumbai',    1299,     0.0, 0,     1299),
('O034','C007','S003','2023-08-28','Field Sales','Delivered','Bengaluru',17999,   900.0, 0,    17099),
('O035','C012','S005','2023-08-11','Online',     'Delivered','Bengaluru', 2499,   125.0, 0,     2374),

-- ── SEP 2023 ──────────────────────────────────────────────────────────────
('O036','C003','S005','2023-09-07','Online',     'Delivered','Pune',      1299,     0.0, 0,     1299),
('O037','C010','S002','2023-09-20','In-Store',   'Delivered','New Delhi',72999,  3650.0, 0,    69349),
('O038','C016','S004','2023-09-15','In-Store',   'Delivered','Kolkata',   8999,   450.0, 0,     8549),
('O039','C017','S005','2023-09-28','Online',     'Delivered','Kolkata',   1299,     0.0, 0,     1299),

-- ── OCT 2023 (Festive season — Navratri / Dussehra spike) ─────────────────
('O040','C001','S005','2023-10-05','Online',     'Delivered','Mumbai',   72999,  3650.0, 0,    69349),
('O041','C002','S001','2023-10-10','In-Store',   'Delivered','Thane',    32999,  1650.0, 0,    31349),
('O042','C005','S005','2023-10-14','Online',     'Delivered','Pune',     32999,  1650.0, 0,    31349),
('O043','C006','S002','2023-10-18','Field Sales','Delivered','New Delhi',72999,  3650.0, 0,    69349),
('O044','C007','S003','2023-10-22','Field Sales','Delivered','Bengaluru',32499,  1625.0, 0,    30874),
('O045','C009','S002','2023-10-25','In-Store',   'Delivered','New Delhi',32999,  1650.0, 0,    31349),
('O046','C011','S005','2023-10-28','Online',     'Delivered','Jaipur',    3999,   200.0, 0,     3799),
('O047','C018','S001','2023-10-08','Field Sales','Delivered','Mumbai',   17997,     0.0, 0,    17997),

-- ── NOV 2023 (Diwali + Big Billion / Great Indian Sale) ───────────────────
('O048','C003','S005','2023-11-02','Online',     'Delivered','Pune',     72999,  5475.0, 0,    67524),
('O049','C004','S001','2023-11-08','In-Store',   'Delivered','Mumbai',   17999,  1350.0, 0,    16649),
('O050','C008','S004','2023-11-12','Field Sales','Delivered','Kolkata',  32999,  2475.0, 0,    30524),
('O051','C012','S005','2023-11-15','Online',     'Delivered','Bengaluru',32999,  2475.0, 0,    30524),
('O052','C013','S003','2023-11-20','In-Store',   'Delivered','Chennai',  17999,  1350.0, 0,    16649),
('O053','C014','S005','2023-11-22','Online',     'Delivered','Hyderabad',32999,  2475.0, 0,    30524),
('O054','C015','S005','2023-11-25','Online',     'Delivered','Bengaluru',72999,  5475.0, 0,    67524),
('O055','C016','S004','2023-11-28','In-Store',   'Delivered','Kolkata',   3799,   285.0, 0,     3514),

-- ── DEC 2023 ──────────────────────────────────────────────────────────────
('O056','C001','S005','2023-12-05','Online',     'Delivered','Mumbai',    3999,   200.0, 0,     3799),
('O057','C005','S001','2023-12-12','In-Store',   'Delivered','Pune',     17999,   900.0, 0,    17099),
('O058','C009','S005','2023-12-20','Online',     'Delivered','New Delhi', 8999,   450.0, 0,     8549),
('O059','C010','S002','2023-12-27','In-Store',   'Delivered','New Delhi', 2499,   125.0, 0,     2374),
('O060','C019','S005','2023-12-15','Online',     'Delivered','New Delhi', 1398,     0.0, 0,     1398),

-- ── JAN 2024 ──────────────────────────────────────────────────────────────
('O061','C001','S005','2024-01-14','Online',     'Delivered','Mumbai',   32999,  1650.0, 0,    31349),
('O062','C002','S005','2024-01-20','Online',     'Delivered','Thane',    17999,   900.0, 0,    17099),
('O063','C006','S002','2024-01-25','Field Sales','Delivered','New Delhi',32999,  1650.0, 0,    31349),
('O064','C011','S005','2024-01-10','Online',     'Delivered','Jaipur',    2499,   125.0, 0,     2374),

-- ── FEB 2024 ──────────────────────────────────────────────────────────────
('O065','C003','S005','2024-02-08','Online',     'Delivered','Pune',     72999,  3650.0, 0,    69349),
('O066','C007','S003','2024-02-16','Field Sales','Delivered','Bengaluru',32499,  1625.0, 0,    30874),
('O067','C012','S005','2024-02-22','Online',     'Delivered','Bengaluru', 3999,   200.0, 0,     3799),
('O068','C013','S003','2024-02-28','In-Store',   'Delivered','Chennai',   1799,     0.0, 0,     1799),

-- ── MAR 2024 ──────────────────────────────────────────────────────────────
('O069','C004','S001','2024-03-05','In-Store',   'Delivered','Mumbai',    8999,   450.0, 0,     8549),
('O070','C005','S005','2024-03-14','Online',     'Delivered','Pune',     72999,  3650.0, 0,    69349),
('O071','C008','S004','2024-03-22','Field Sales','Delivered','Kolkata',  32999,  1650.0, 0,    31349),
('O072','C015','S005','2024-03-29','Online',     'Delivered','Bengaluru', 2499,   125.0, 0,     2374),
('O073','C018','S001','2024-03-10','Field Sales','Delivered','Mumbai',   15596,     0.0, 0,    15596),

-- ── APR 2024 ──────────────────────────────────────────────────────────────
('O074','C001','S005','2024-04-06','Online',     'Delivered','Mumbai',   17999,   900.0, 0,    17099),
('O075','C009','S002','2024-04-18','In-Store',   'Delivered','New Delhi',32999,  1650.0, 0,    31349),
('O076','C014','S005','2024-04-24','Online',     'Delivered','Hyderabad',17999,   900.0, 0,    17099),
('O077','C016','S004','2024-04-30','In-Store',   'Delivered','Kolkata',   1299,     0.0, 0,     1299),

-- ── MAY 2024 ──────────────────────────────────────────────────────────────
('O078','C002','S001','2024-05-10','In-Store',   'Delivered','Thane',    72999,  3650.0, 0,    69349),
('O079','C006','S002','2024-05-20','Field Sales','Delivered','New Delhi',32999,  1650.0, 0,    31349),
('O080','C010','S005','2024-05-28','Online',     'Delivered','New Delhi', 2499,   125.0, 0,     2374),
('O081','C017','S004','2024-05-15','In-Store',   'Delivered','Kolkata',  32999,  1650.0, 0,    31349),

-- ── JUN 2024 ──────────────────────────────────────────────────────────────
('O082','C003','S005','2024-06-06','Online',     'Delivered','Pune',     32999,  1650.0, 0,    31349),
('O083','C007','S003','2024-06-14','Field Sales','Delivered','Bengaluru',72999,  3650.0, 0,    69349),
('O084','C011','S005','2024-06-22','Online',     'Delivered','Jaipur',    3799,   190.0, 0,     3609),
('O085','C015','S005','2024-06-28','Online',     'Delivered','Bengaluru',17999,   900.0, 0,    17099),

-- ── JUL 2024 ──────────────────────────────────────────────────────────────
('O086','C001','S005','2024-07-08','Online',     'Delivered','Mumbai',    3999,   200.0, 0,     3799),
('O087','C004','S001','2024-07-19','In-Store',   'Delivered','Mumbai',   32999,  1650.0, 0,    31349),
('O088','C008','S004','2024-07-25','Field Sales','Delivered','Kolkata',   8999,   450.0, 0,     8549),
('O089','C012','S003','2024-07-30','In-Store',   'Delivered','Bengaluru',72999,  3650.0, 0,    69349),

-- ── AUG 2024 ──────────────────────────────────────────────────────────────
('O090','C002','S005','2024-08-05','Online',     'Delivered','Thane',    32999,  1650.0, 0,    31349),
('O091','C005','S005','2024-08-15','Online',     'Delivered','Pune',     32999,  1650.0, 0,    31349),
('O092','C009','S005','2024-08-22','Online',     'Delivered','New Delhi',17999,   900.0, 0,    17099),
('O093','C013','S003','2024-08-28','In-Store',   'Delivered','Chennai',   8999,   450.0, 0,     8549),

-- ── SEP 2024 (pre-festive) ────────────────────────────────────────────────
('O094','C001','S005','2024-09-04','Online',     'Delivered','Mumbai',   72999,  3650.0, 0,    69349),
('O095','C003','S005','2024-09-12','Online',     'Delivered','Pune',     17999,   900.0, 0,    17099),
('O096','C006','S002','2024-09-18','Field Sales','Delivered','New Delhi',72999,  3650.0, 0,    69349),
('O097','C007','S003','2024-09-24','Field Sales','Delivered','Bengaluru',32999,  1650.0, 0,    31349),
('O098','C010','S002','2024-09-28','In-Store',   'Delivered','New Delhi',32999,  1650.0, 0,    31349),
('O099','C014','S005','2024-09-15','Online',     'Delivered','Hyderabad', 1299,     0.0, 0,     1299),
('O100','C015','S005','2024-09-30','Online',     'Delivered','Bengaluru',32999,  1650.0, 0,    31349);

-- ============================================================
-- 5. FACT TABLE: fact_order_items
-- ============================================================
-- line_revenue = quantity * unit_price * (1 - discount_pct)
-- line_cost    = quantity * unit_cost
-- line_profit  = line_revenue - line_cost
-- discount_pct: 0.05=5%, 0.10=10%, 0.15=15%, 0.20=20%

INSERT INTO fact_order_items (order_id, product_id, quantity, unit_price, unit_cost, discount_pct, line_revenue, line_cost, line_profit) VALUES
-- O001: Rahul Mehta — ProMax Smartphone
('O001','P001',1,32999,18500,0.05,31349.05,18500,12849.05),
-- O002: Amit Patel — UltraBook Laptop
('O002','P002',1,72999,42000,0.05,69349.05,42000,27349.05),
-- O003: Meena Agarwal — UPSC Book Set
('O003','P018',1,1299,500,0.00,1299,500,799),
-- O004: Vikram Desai — Wireless Earbuds
('O004','P003',1,3999,1800,0.05,3799.05,1800,1999.05),
-- O005: Priya Sharma — ProMax Smartphone
('O005','P001',1,32999,18500,0.05,31349.05,18500,12849.05),
-- O006: Nexus Retail — Noodles Pack (bulk B2B)
('O006','P008',12,399,180,0.00,4788,2160,2628),
('O006','P009',8,549,220,0.00,4392,1760,2632),
-- O007: Arjun Singh — Smart TV
('O007','P004',1,17999,18000,0.05,17099.05,18000,-900.95),  -- promoted price, small loss
-- O008: Nikhil Bansal — Business Strategy Book
('O008','P019',1,699,250,0.05,664.05,250,414.05),
('O008','P020',3,449,180,0.00,1347,540,807),
-- O009: Farhan Sheikh — Denim Jeans
('O009','P012',1,1799,600,0.00,1799,600,1199),
-- O010: Sneha Joshi — Wireless Earbuds
('O010','P003',1,3999,1800,0.05,3799.05,1800,1999.05),
-- O011: Bharat Electronics — UltraBook Laptop (B2B)
('O011','P002',1,72999,42000,0.05,69349.05,42000,27349.05),
-- O012: Divya Krishnan — Air Purifier
('O012','P014',1,8999,4500,0.05,8549.05,4500,4049.05),
-- O013: Rashmi Gupta — UPSC Book
('O013','P018',1,1299,500,0.00,1299,500,799),
-- O014: Pooja Iyer — Smart TV
('O014','P004',1,17999,18000,0.05,17099.05,18000,-900.95),
-- O015: Rahul Mehta — Whey Protein
('O015','P007',1,2499,1200,0.05,2374.05,1200,1174.05),
-- O016: Kavya Nair — Formal Shirt
('O016','P010',1,1299,450,0.00,1299,450,849),
-- O017: Sunrise Distributors — Smart TV (B2B bulk)
('O017','P004',1,32499,18000,0.05,30874.05,18000,12874.05),
-- O018: Deepak Kulkarni — Mixer Grinder
('O018','P016',1,3799,1800,0.05,3609.05,1800,1809.05),
-- O019: TechSpark Solutions — Laptops + Earbuds (SME)
('O019','P002',1,72999,42000,0.00,72999,42000,30999),
('O019','P003',3,3999,1800,0.00,11997,5400,6597),
-- O020: Amit Patel — Wireless Earbuds
('O020','P003',1,3999,1800,0.05,3799.05,1800,1999.05),
-- O021: Rohit Yadav — ProMax Smartphone
('O021','P001',1,32999,18500,0.05,31349.05,18500,12849.05),
-- O022: Saurabh Das — Business Strategy Book
('O022','P019',1,699,250,0.00,699,250,449),
('O022','P020',1,449,180,0.00,449,180,269),
-- O023: EduFirst Academy — Notebook Set + Book
('O023','P020',3,449,180,0.00,1347,540,807),
('O023','P018',1,1299,500,0.00,1299,500,799),
-- O024: Vikram Desai — Tablet
('O024','P005',1,17999,9500,0.05,17099.05,9500,7599.05),
-- O025: Suresh Menon — Sports Shoes
('O025','P013',1,3499,1200,0.05,3324.05,1200,2124.05),
('O025','P010',1,1299,450,0.00,1299,450,849),
-- O026: Ananya Reddy — Air Purifier
('O026','P014',1,8999,4500,0.05,8549.05,4500,4049.05),
-- O027: Mousumi Chakraborty — Whey Protein
('O027','P007',1,2499,1200,0.05,2374.05,1200,1174.05),
-- O028: Priya Sharma — Denim Jeans
('O028','P012',1,1799,600,0.00,1799,600,1199),
-- O029: Nexus Retail — ProMax Smartphone (B2B bulk)
('O029','P001',1,32999,18500,0.05,31349.05,18500,12849.05),
-- O030: Arjun Singh — Whey Protein
('O030','P007',1,2499,1200,0.05,2374.05,1200,1174.05),
-- O031: Kiran Pillai — ProMax Smartphone
('O031','P001',1,32999,18500,0.05,31349.05,18500,12849.05),
-- O032: Rahul Mehta — Air Purifier
('O032','P014',1,8999,4500,0.05,8549.05,4500,4049.05),
-- O033: Sneha Joshi — Kurti
('O033','P011',1,999,380,0.00,999,380,619),
('O033','P010',1,1299,450,0.00,1299,450,849),  -- Note: exceeds O033 total, illustrative
-- O034: Bharat Electronics — Tablet (B2B)
('O034','P005',1,17999,9500,0.05,17099.05,9500,7599.05),
-- O035: Divya Krishnan — Whey Protein + Tea
('O035','P007',1,2499,1200,0.05,2374.05,1200,1174.05),
('O035','P006',1,499,180,0.00,499,180,319),
-- O036: Amit Patel — UPSC Book
('O036','P018',1,1299,500,0.00,1299,500,799),
-- O037: Kavya Nair — UltraBook Laptop
('O037','P002',1,72999,42000,0.05,69349.05,42000,27349.05),
-- O038: Saurabh Das — Air Purifier
('O038','P014',1,8999,4500,0.05,8549.05,4500,4049.05),
-- O039: Mousumi Chakraborty — Notebook Set
('O039','P020',3,449,180,0.00,1347,540,807),
-- O040: Rahul Mehta — UltraBook Laptop (Festive)
('O040','P002',1,72999,42000,0.05,69349.05,42000,27349.05),
-- O041: Priya Sharma — ProMax Smartphone (Festive)
('O041','P001',1,32999,18500,0.05,31349.05,18500,12849.05),
-- O042: Vikram Desai — ProMax Smartphone (Festive)
('O042','P001',1,32999,18500,0.05,31349.05,18500,12849.05),
-- O043: Nexus Retail — UltraBook Laptop (B2B Festive)
('O043','P002',1,72999,42000,0.05,69349.05,42000,27349.05),
-- O044: Bharat Electronics — Smart TV (B2B Festive)
('O044','P004',1,32499,18000,0.05,30874.05,18000,12874.05),
-- O045: Arjun Singh — ProMax Smartphone (Festive)
('O045','P001',1,32999,18500,0.05,31349.05,18500,12849.05),
-- O046: Rohit Yadav — Wireless Earbuds
('O046','P003',1,3999,1800,0.05,3799.05,1800,1999.05),
-- O047: TechSpark Solutions — Room Heater x3 (SME bulk)
('O047','P017',3,2499,1200,0.00,7497,3600,3897),
('O047','P015',3,1299,550,0.00,3897,1650,2247),
-- O048: Amit Patel — UltraBook Laptop (Diwali, deep discount)
('O048','P002',1,72999,42000,0.075,67524.075,42000,25524.075),
-- O049: Sneha Joshi — Tablet (Diwali)
('O049','P005',1,17999,9500,0.075,16649.075,9500,7149.075),
-- O050: Sunrise Distributors — ProMax Smartphone (Diwali bulk)
('O050','P001',1,32999,18500,0.075,30524.075,18500,12024.075),
-- O051: Divya Krishnan — ProMax Smartphone (Diwali)
('O051','P001',1,32999,18500,0.075,30524.075,18500,12024.075),
-- O052: Suresh Menon — Tablet (Diwali)
('O052','P005',1,17999,9500,0.075,16649.075,9500,7149.075),
-- O053: Ananya Reddy — ProMax Smartphone (Diwali)
('O053','P001',1,32999,18500,0.075,30524.075,18500,12024.075),
-- O054: Kiran Pillai — UltraBook Laptop (Diwali)
('O054','P002',1,72999,42000,0.075,67524.075,42000,25524.075),
-- O055: Saurabh Das — Sports Shoes (Diwali)
('O055','P013',1,3499,1200,0.075,3236.575,1200,2036.575),
-- O056: Rahul Mehta — Wireless Earbuds (Dec)
('O056','P003',1,3999,1800,0.05,3799.05,1800,1999.05),
-- O057: Vikram Desai — Tablet (Dec)
('O057','P005',1,17999,9500,0.05,17099.05,9500,7599.05),
-- O058: Arjun Singh — Air Purifier (Dec)
('O058','P014',1,8999,4500,0.05,8549.05,4500,4049.05),
-- O059: Kavya Nair — Whey Protein (Dec)
('O059','P007',1,2499,1200,0.05,2374.05,1200,1174.05),
-- O060: EduFirst Academy — Books
('O060','P018',1,1299,500,0.00,1299,500,799),
-- O061: Rahul Mehta — ProMax Smartphone (Jan 2024)
('O061','P001',1,32999,18500,0.05,31349.05,18500,12849.05),
-- O062: Priya Sharma — Tablet (Jan 2024)
('O062','P005',1,17999,9500,0.05,17099.05,9500,7599.05),
-- O063: Nexus Retail — ProMax Smartphone (Jan 2024 B2B)
('O063','P001',1,32999,18500,0.05,31349.05,18500,12849.05),
-- O064: Rohit Yadav — Whey Protein + Coffee (Jan 2024)
('O064','P007',1,2499,1200,0.05,2374.05,1200,1174.05),
-- O065: Amit Patel — UltraBook Laptop (Feb 2024)
('O065','P002',1,72999,42000,0.05,69349.05,42000,27349.05),
-- O066: Bharat Electronics — Smart TV (Feb 2024 B2B)
('O066','P004',1,32499,18000,0.05,30874.05,18000,12874.05),
-- O067: Divya Krishnan — Wireless Earbuds (Feb 2024)
('O067','P003',1,3999,1800,0.05,3799.05,1800,1999.05),
-- O068: Suresh Menon — Denim Jeans (Feb 2024)
('O068','P012',1,1799,600,0.00,1799,600,1199),
-- O069: Sneha Joshi — Air Purifier (Mar 2024)
('O069','P014',1,8999,4500,0.05,8549.05,4500,4049.05),
-- O070: Vikram Desai — UltraBook Laptop (Mar 2024)
('O070','P002',1,72999,42000,0.05,69349.05,42000,27349.05),
-- O071: Sunrise Distributors — ProMax Smartphone (Mar 2024 B2B)
('O071','P001',1,32999,18500,0.05,31349.05,18500,12849.05),
-- O072: Kiran Pillai — Whey Protein + Tea (Mar 2024)
('O072','P007',1,2499,1200,0.05,2374.05,1200,1174.05),
-- O073: TechSpark Solutions — Mixer x2 + Kettle x4 (Mar 2024)
('O073','P016',2,3799,1800,0.00,7598,3600,3998),
('O073','P015',4,1299,550,0.00,5196,2200,2996),
-- O074: Rahul Mehta — Tablet (Apr 2024)
('O074','P005',1,17999,9500,0.05,17099.05,9500,7599.05),
-- O075: Arjun Singh — ProMax Smartphone (Apr 2024)
('O075','P001',1,32999,18500,0.05,31349.05,18500,12849.05),
-- O076: Ananya Reddy — Tablet (Apr 2024)
('O076','P005',1,17999,9500,0.05,17099.05,9500,7599.05),
-- O077: Saurabh Das — Notebook Set (Apr 2024)
('O077','P020',3,449,180,0.00,1347,540,807),
-- O078: Priya Sharma — UltraBook Laptop (May 2024)
('O078','P002',1,72999,42000,0.05,69349.05,42000,27349.05),
-- O079: Nexus Retail — ProMax Smartphone (May 2024 B2B)
('O079','P001',1,32999,18500,0.05,31349.05,18500,12849.05),
-- O080: Kavya Nair — Whey Protein (May 2024)
('O080','P007',1,2499,1200,0.05,2374.05,1200,1174.05),
-- O081: Mousumi Chakraborty — ProMax Smartphone (May 2024)
('O081','P001',1,32999,18500,0.05,31349.05,18500,12849.05),
-- O082: Amit Patel — ProMax Smartphone (Jun 2024)
('O082','P001',1,32999,18500,0.05,31349.05,18500,12849.05),
-- O083: Bharat Electronics — UltraBook Laptop (Jun 2024 B2B)
('O083','P002',1,72999,42000,0.05,69349.05,42000,27349.05),
-- O084: Rohit Yadav — Sports Shoes (Jun 2024)
('O084','P013',1,3499,1200,0.05,3324.05,1200,2124.05),
('O084','P011',1,999,380,0.00,999,380,619),
-- O085: Kiran Pillai — Tablet (Jun 2024)
('O085','P005',1,17999,9500,0.05,17099.05,9500,7599.05),
-- O086: Rahul Mehta — Wireless Earbuds (Jul 2024)
('O086','P003',1,3999,1800,0.05,3799.05,1800,1999.05),
-- O087: Sneha Joshi — ProMax Smartphone (Jul 2024)
('O087','P001',1,32999,18500,0.05,31349.05,18500,12849.05),
-- O088: Sunrise Distributors — Air Purifier (Jul 2024 B2B)
('O088','P014',1,8999,4500,0.05,8549.05,4500,4049.05),
-- O089: Divya Krishnan — UltraBook Laptop (Jul 2024)
('O089','P002',1,72999,42000,0.05,69349.05,42000,27349.05),
-- O090: Priya Sharma — ProMax Smartphone (Aug 2024)
('O090','P001',1,32999,18500,0.05,31349.05,18500,12849.05),
-- O091: Vikram Desai — ProMax Smartphone (Aug 2024)
('O091','P001',1,32999,18500,0.05,31349.05,18500,12849.05),
-- O092: Arjun Singh — Tablet (Aug 2024)
('O092','P005',1,17999,9500,0.05,17099.05,9500,7599.05),
-- O093: Suresh Menon — Air Purifier (Aug 2024)
('O093','P014',1,8999,4500,0.05,8549.05,4500,4049.05),
-- O094: Rahul Mehta — UltraBook Laptop (Sep 2024 pre-festive)
('O094','P002',1,72999,42000,0.05,69349.05,42000,27349.05),
-- O095: Amit Patel — Tablet (Sep 2024)
('O095','P005',1,17999,9500,0.05,17099.05,9500,7599.05),
-- O096: Nexus Retail — UltraBook Laptop (Sep 2024 B2B)
('O096','P002',1,72999,42000,0.05,69349.05,42000,27349.05),
-- O097: Bharat Electronics — ProMax Smartphone (Sep 2024 B2B)
('O097','P001',1,32999,18500,0.05,31349.05,18500,12849.05),
-- O098: Kavya Nair — ProMax Smartphone (Sep 2024)
('O098','P001',1,32999,18500,0.05,31349.05,18500,12849.05),
-- O099: Ananya Reddy — UPSC Book (Sep 2024)
('O099','P018',1,1299,500,0.00,1299,500,799),
-- O100: Kiran Pillai — ProMax Smartphone (Sep 2024)
('O100','P001',1,32999,18500,0.05,31349.05,18500,12849.05);

-- ============================================================
-- End of sample data
-- ============================================================
