/*
===============================================================================
Ranking Analysis
===============================================================================
Purpose:
    - To rank items (e.g., products, customers) based on performance or other metrics.
    - To identify top performers or laggards.

SQL Functions Used:
    - Window Ranking Functions: RANK(), DENSE_RANK(), ROW_NUMBER(), TOP
    - Clauses: GROUP BY, ORDER BY
===============================================================================
*/

-- Which 5 products generate the highest revenue 


--simple ranking using top function

SELECT TOP 5
	p.product_name,
	SUM(s.sales_amount) AS total_revenue,
	RANK() OVER(ORDER BY SUM(s.sales_amount) DESC) AS revenue_ranking
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_products AS p
ON s.product_key = p.product_key
GROUP BY p.product_name
ORDER BY total_revenue DESC;

-- Complex but Flexibly Ranking Using Window Functions

SELECT
	*
FROM
(
	SELECT
		p.product_name,
		SUM(s.sales_amount) AS total_revenue,
		RANK() OVER(ORDER BY SUM(s.sales_amount) DESC) AS revenue_ranking_best
	FROM gold.fact_sales AS s
	LEFT JOIN gold.dim_products AS p
	ON s.product_key = p.product_key
	GROUP BY p.product_name
	) AS SubQueryTable
WHERE revenue_ranking_best <= 5
ORDER BY revenue_ranking_best ASC;


-- What are the 5 worst-performing products in terms of sales

--simple ranking using top function

SELECT TOP 5
	p.product_name,
	SUM(s.sales_amount) AS total_revenue
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_products AS p
ON s.product_key = p.product_key
GROUP BY p.product_name
ORDER BY total_revenue ASC;

-- Complex but Flexibly Ranking Using Window Functions

SELECT
	*
FROM
(
	SELECT
		p.product_name,
		SUM(s.sales_amount) AS total_revenue,
		RANK() OVER(ORDER BY SUM(s.sales_amount) ASC) AS revenue_ranking_worst
	FROM gold.fact_sales AS s
	LEFT JOIN gold.dim_products AS p
	ON s.product_key = p.product_key
	GROUP BY p.product_name
) AS SubQueryTable
WHERE revenue_ranking_worst <= 5
ORDER BY revenue_ranking_worst ASC;


-- Find the top 10 customers who have generated the highest revenue

--simple ranking using top function

SELECT TOP 10
	c.customer_key,
	c.first_name,
	c.last_name,
	SUM(s.sales_amount) AS total_revenue
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_customers AS c
ON s.customer_key = c.customer_key
GROUP BY 
	c.customer_key,
	c.first_name,
	c.last_name
ORDER BY total_revenue DESC;

-- Complex but Flexibly Ranking Using Window Functions

SELECT
	*
FROM
(
	SELECT
		c.customer_key,
		c.first_name,
		c.last_name,
		SUM(s.sales_amount) AS total_revenu,
		ROW_NUMBER() OVER(ORDER BY SUM(s.sales_amount) DESC) AS customer_ranking
	FROM gold.fact_sales AS s
	LEFT JOIN gold.dim_customers AS c
	ON s.customer_key = c.customer_key
	GROUP BY 
		c.customer_key,
		c.first_name,
		c.last_name
) AS SubQueryTable
WHERE customer_ranking <= 10;


-- The 3 customers with the fewes orders placed

--simple ranking using top function

SELECT TOP 3
	c.customer_key,
	c.first_name,
	c.last_name,
	COUNT(DISTINCT order_number) AS total_orders
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_customers AS c
ON s.customer_key = c.customer_key
GROUP BY
	c.customer_key,
	c.first_name,
	c.last_name
ORDER BY total_orders ASC;


-- Complex but Flexibly Ranking Using Window Functions

SELECT
	*
FROM
(
	SELECT
		c.customer_key,
		c.first_name,
		c.last_name,
		COUNT(DISTINCT order_number) AS total_orders,
		ROW_NUMBER() OVER(ORDER BY COUNT(DISTINCT order_number) ASC) AS ranking_orders
	FROM gold.fact_sales AS s
	LEFT JOIN gold.dim_customers AS c
	ON s.customer_key = c.customer_key
	GROUP BY
		c.customer_key,
		c.first_name,
		c.last_name
) AS SubQueryTable
WHERE ranking_orders <= 3
ORDER BY ranking_orders ASC;
	
