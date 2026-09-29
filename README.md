# Olist E-Commerce Business Analysis — SQL

> **Analyzing growth drivers, customer behavior, revenue concentration, and delivery experience using MySQL**

## 📌 Project Overview

This project analyzes the **Olist Brazilian E-Commerce Public Dataset** using SQL to understand how an e-commerce marketplace is performing as transaction volume scales.

Rather than treating SQL as a collection of queries, the project follows a **business-first analytical approach**:

**Business Problem → Data Validation → SQL Analysis → Evidence → Business Insight → Recommendation**

The analysis focuses on three areas:

* 📈 **Commercial Performance** — growth, order volume, AOV, and category contribution
* 👥 **Customer Behavior** — repeat purchasing and customer revenue concentration
* 🚚 **Operations & Customer Experience** — delivery performance and review scores

---

## 🎯 Business Problem

Management wants to understand:

> **Is the marketplace scaling primarily through higher transaction volume, and what customer and operational factors could affect future growth and customer experience?**

The analysis was designed to support decisions around:

1. Growth performance
2. Product-category strategy
3. Customer retention
4. High-value customer management
5. Delivery reliability

---

## 🔎 Business Questions

### Commercial Performance

1. Is product sales value and order volume growing over time?
2. Is growth driven primarily by order volume or average order value?
3. Which product categories contribute the most sales value?

### Customer Behavior

4. How significant are one-time versus repeat customers?
5. How concentrated is sales value among high-value customers?

### Operations & Experience

6. How does delivery performance vary across customer states?
7. Are late deliveries associated with lower customer review scores?

---

## 🗂️ Dataset

**Dataset:** Olist Brazilian E-Commerce Public Dataset

The dataset contains information about:

* Customers
* Orders
* Order items
* Payments
* Products
* Sellers
* Reviews
* Geolocation
* Product categories

The analysis uses multiple tables and relational joins to build business-level metrics.

---

## 🧹 Data Preparation & Validation

Before conducting the analysis, the dataset was validated using SQL.

### Data quality checks

* Validated row counts and unique identifiers across core tables.
* Checked referential integrity between orders, customers, products, sellers, payments, and reviews.
* Identified **775 orders without order items**, primarily associated with non-delivered statuses.
* Identified **1 delivered order without a payment record** and retained the record rather than modifying the source data.
* Checked missing delivery timestamps before calculating delivery metrics.
* Used `customer_unique_id` for repeat-customer analysis because `customer_id` represents individual order relationships in the Olist dataset.
* Used `COUNT(DISTINCT order_id)` where necessary to prevent order duplication after item-level joins.
* Joined the category translation table to convert category names into English.

### Revenue definition

For this project:

**Product Sales Value = SUM(order_items.price)**

Freight charges were excluded because they represent shipping rather than product value.

Therefore, **Product Sales Value should not be interpreted as accounting revenue or profit.**

---

# 📊 Key Findings

## 1. Growth was primarily volume-driven

Delivered order volume expanded substantially through 2017 and 2018, while monthly AOV generally remained within approximately **R$125–R$150**.

The highest monthly delivered-order volume observed was:

**7,289 orders — November 2017**

The highest monthly product sales value observed was:

**R$987,765.37 — November 2017**

**Business implication:**
Observed growth appears more closely associated with increasing transaction volume than with a major increase in average customer spend.

---

## 2. Revenue is diversified across product categories

The **top five categories contributed 39.83%** of total product sales value.

The largest category by sales value was:

**Health & Beauty — R$1.23M**

Watches & Gifts generated:

**R$1.17M**

with an AOV of approximately:

**R$212.23**

Meanwhile, Bed & Bath Table generated the highest category order volume among the major categories:

**9,272 orders**

**Business implication:**
Category performance should be evaluated using both **order volume and customer spend**, rather than sales value alone.

---

## 3. Repeat customers represent a small part of the customer base

| Customer Type | Customers | Customer Share | Sales Value | Sales Share |
| ------------- | --------: | -------------: | ----------: | ----------: |
| One-time      |    90,557 |         97.00% |    R$12.49M |      94.49% |
| Repeat        |     2,801 |          3.00% |      R$728K |       5.51% |

Only **3% of customers** were classified as repeat customers.

However, repeat customers contributed **5.51% of sales value**, slightly higher than their share of customers.

**Business implication:**
Repeat purchasing is a relatively small component of the observed customer base and represents an area for further retention and reactivation analysis.

---

## 4. Sales value is not dominated by a tiny customer group

Customer revenue concentration showed:

| Customer Segment | Sales Value Share |
| ---------------- | ----------------: |
| Top 1%           |            11.46% |
| Next 4%          |            17.67% |
| Next 5%          |            11.97% |
| Remaining 90%    |            58.90% |

The **top 10% of customers generated 41.10%** of product sales value.

The remaining 90% generated **58.90%**.

**Business implication:**
High-value customers contribute a meaningful share of sales, but the marketplace's sales value remains broadly distributed rather than being dominated by a very small group.

---

## 5. Delivery performance varies substantially by geography

Average delivery time varied considerably across Brazilian states.

Examples:

| State | Delivered Orders | Avg. Delivery Time |
| ----- | ---------------: | -----------------: |
| SP    |           40,501 |          8.70 days |
| MG    |           11,354 |         11.95 days |
| PR    |            4,923 |         11.94 days |
| RJ    |           12,350 |         15.24 days |
| PA    |              946 |         23.73 days |
| AM    |              145 |         26.36 days |
| RR    |               41 |         29.34 days |

**Business implication:**
Delivery performance differs significantly by geography and should be investigated alongside seller location, logistics coverage, and order characteristics.

Small-volume states should be interpreted cautiously.

---

## 6. Late deliveries are associated with substantially lower review scores

| Delivery Status | Orders | Average Review Score |
| --------------- | -----: | -------------------: |
| Late            |  6,381 |         **2.27 / 5** |
| On-Time / Early | 89,450 |         **4.29 / 5** |

The difference between the two groups was:

**2.02 review-score points**

**Business implication:**
Delivery reliability is an important customer-experience KPI and should be monitored alongside customer review performance.

> **Important:** This analysis identifies an association, not causation.

---

# 💡 Business Recommendations

## Priority 1 — Investigate late-delivery drivers

Analyze late orders by:

* State
* Seller
* Product category
* Logistics characteristics
* Delivery distance

**Rationale:** Late deliveries were associated with substantially lower review scores.

**Caveat:** The current analysis does not establish which operational factor causes delays.

---

## Priority 2 — Investigate repeat-purchase opportunities

Further analyze:

* Time between purchases
* Category-specific repurchase behavior
* Cross-category purchases
* Customer reactivation
* Post-purchase engagement

**Rationale:** 97% of customers were classified as one-time customers.

**Caveat:** The dataset does not provide customer acquisition dates, marketing exposure, or campaign history.

---

## Priority 3 — Evaluate categories using both volume and value

Segment categories using:

* Order volume
* Sales value
* AOV
* Revenue contribution

This helps distinguish **high-volume categories** from **high-value categories**.

---

## Priority 4 — Monitor high-value customer segments

The top 10% of customers contributed **41.10% of sales value**.

Management could monitor:

* Purchase frequency
* Category preferences
* Repeat behavior
* Service issues
* Customer experience

**Caveat:** Revenue concentration alone does not indicate customer risk or churn probability.

---

# ⚠️ Limitations

### Historical data

The analysis is based on historical Olist transactions and may not represent current marketplace behavior.

### No profitability data

The dataset does not provide sufficient information to calculate:

* Gross margin
* Net profit
* Customer acquisition cost
* Contribution margin

Therefore, this project focuses on **sales value rather than profitability**.

### Repeat-customer analysis

The 3% repeat-customer figure describes observed delivered purchases in the dataset.

It does not account for:

* Customer tenure
* Acquisition date
* Marketing exposure
* Time available to repurchase

Therefore, it should not be interpreted directly as a retention rate.

### Delivery analysis

State-level delivery differences may reflect:

* Geography
* Seller location
* Logistics network
* Product mix
* Order characteristics

The analysis does not identify a specific causal factor.

### Review analysis

The relationship between delivery status and review score represents **association rather than causation**.

### Sales-value metric

Product Sales Value is calculated using item prices and excludes freight.

It should not be interpreted as official accounting revenue.

---

# 🛠️ SQL Techniques Used

The project demonstrates practical intermediate SQL techniques including:

* `SELECT`
* `WHERE`
* `CASE WHEN`
* `GROUP BY`
* `HAVING`
* `ORDER BY`
* `JOIN`
* `LEFT JOIN`
* `COUNT(DISTINCT)`
* `SUM()`
* `AVG()`
* `ROUND()`
* Date functions
* Common Table Expressions (`CTEs`)
* Window functions
* `ROW_NUMBER()`
* Percentage contribution calculations
* Customer segmentation
* Data-quality validation

The focus was on applying these techniques to **business questions**, rather than using SQL complexity for its own sake.

---

# 🎯 Final Business Takeaway

The analysis indicates that the marketplace experienced substantial transaction growth, primarily through increasing order volume, while repeat purchasing remained limited.

At the same time, sales value was reasonably distributed across the customer base and product categories, while delivery performance varied considerably by geography.

Most importantly, **late deliveries were associated with substantially lower customer review scores**, making delivery reliability a key operational area for further investigation.

The next analytical step would be to investigate **which sellers, regions, product categories, and logistics characteristics contribute most to late deliveries**, while separately exploring opportunities to increase repeat purchasing.

---

## 📚 Dataset

**Olist Brazilian E-Commerce Public Dataset**

The dataset is publicly available for educational and analytical purposes.

---

## 👤 Author

**Guna Sampath**

Aspiring **Data Analyst | BI Analyst**

**Skills demonstrated:**
`SQL` · `MySQL` · `Business Analysis` · `Data Cleaning` · `Data Validation` · `Customer Analytics` · `E-Commerce Analytics`
