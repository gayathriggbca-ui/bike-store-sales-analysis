# Bike Store Sales Analysis

End-to-end data analysis project using **Python, MySQL and Power BI**.

## Tools Used
- **Python (pandas, matplotlib):** data cleaning, validation and charts
- **MySQL:** data quality checks and business queries
- **Power BI:** interactive dashboard with DAX measures

## Dataset
9 tables: brands, categories, customers, order_items, orders, products, staffs, stocks, stores.

## Project Steps
1. **Python:** cleaned all 9 tables (nulls, duplicates, data types, text formatting, order status mapping) and checked relationships between tables.
2. **SQL:** checked data quality, fixed column types and wrote business queries.
3. **Power BI:** built a dashboard with DAX measures.

Rejected orders are excluded from orders, units and revenue in SQL and Power BI.

## Business Questions Answered
- Total orders, units sold, revenue and customers
- Monthly order trends
- Top 10 best-selling products
- Revenue by category, brand and store
- Top 10 customers by spending

## Key Insights
- Total revenue is **7.48M** from **1,570 orders** and **6,898 units** sold to **1,445 customers** (rejected orders excluded).
- **Mountain Bikes** earn the most revenue (2.65M, about 35% of total), followed by Road Bikes (1.60M).
- **Trek** is the top brand by revenue (4.48M), far ahead of Electra (1.17M) and Surly (0.92M).
- **Electra Cruiser 1 (24-Inch) - 2016** is the best-selling product (290 units).
- **Baldwin Bikes** earns the most revenue (5.14M), about 69% of total revenue.
- Price has only a weak link with units sold (correlation about -0.11).

## Dashboard
![Dashboard]!(dashboardbike.png)

## Folder Structure
- `raw_data`: original files
- `cleaned_data`: cleaned files
- `bikestorepython.ipynb`: Python cleaning and analysis
- `sql`: SQL script
- `powerbi`: Power BI file
- `images`: dashboard screenshot
