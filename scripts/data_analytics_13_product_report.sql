/*
===============================================================================
Product Report
===============================================================================
Purpose:
    - This report consolidates key product metrics and behaviors.

Highlights:
    1. Gathers essential fields such as product name, category, subcategory, and cost.
    
    2. Segments products by revenue to identify High-Performers, Mid-Range, or Low-Performers.
    
    3. Aggregates product-level metrics:
       - total orders
       - total sales
       - total quantity sold
       - total customers (unique)
       - lifespan (in months)

    4. Calculates valuable KPIs:
       - recency (months since last sale)
       - average order revenue (AOR)
       - average monthly revenue
===============================================================================
*/

-- =============================================================================
-- Create Report: gold.report_products
-- =============================================================================

IF OBJECT_ID('gold.report_products', 'V') IS NOT NULL
    DROP VIEW gold.report_products;
GO

CREATE VIEW gold.report_products AS

WITH

base_query AS

/*
-------------------------------------------------------------------------------
1) Base Query: Retrives core columns from tables
-------------------------------------------------------------------------------
*/

(
SELECT
    s.order_number,
    s.order_date,
    c.customer_key,
    s.sales_amount,
    s.quantity,
    p.product_key,
    p.product_name,
    p.category,
    p.subcategory,
    p.cost
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_customers AS c
ON s.customer_key = c.customer_key
LEFT JOIN gold.dim_products AS p
ON s.product_key = p.product_key
WHERE order_date IS NOT NULL -- only consider valid sales dates
),

product_aggregation AS

/*
-------------------------------------------------------------------------------
2) Product Aggregations: Summarizes key metrics at the product level
-------------------------------------------------------------------------------
*/

(
SELECT
    product_key,
    product_name,
    category,
    subcategory,
    cost,
    DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan,
    MAX(order_date) AS last_sales_date,
    COUNT(DISTINCT order_number) AS total_orders,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(sales_amount) AS total_sales,
    SUM(quantity) AS total_quantity_sold,
    ROUND(AVG(CAST(sales_amount AS FLOAT) / NULLIF(quantity, 0)),1) AS avg_selling_price
FROM base_query
GROUP BY
    product_key,
    product_name,
    category,
    subcategory,
    cost
)

/*
-------------------------------------------------------------------------------
3) Final query: segmentation with case & KPIs 
-------------------------------------------------------------------------------
*/

SELECT
    product_key,
    product_name,
    category,
    subcategory,
    cost,
    last_sales_date,
    DATEDIFF(MONTH, last_sales_date, GETDATE()) recency_in_months,
    CASE
        WHEN total_sales > 50000 THEN 'High-Performers'
        WHEN total_sales >= 10000 THEN 'Mid-Performers'
        ELSE 'Low-Performers'
    END AS product_segments,
    lifespan,
    total_orders,
    total_sales,
    total_quantity_sold,
    total_customers,
    avg_selling_price, 	
    CASE -- Average Order Revenue (AOR)
        WHEN total_orders = 0 THEN 0 
        ELSE total_sales / total_orders 
    END AS avg_order_revenue,
    CASE 	-- Average Monthly Revenue
        WHEN lifespan = 0 THEN total_sales
        ELSE total_sales / lifespan
    END AS avg_monthly_revenue
FROM product_aggregation;
