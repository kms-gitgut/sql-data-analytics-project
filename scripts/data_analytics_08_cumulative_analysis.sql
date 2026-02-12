/*
===============================================================================
Cumulative Analysis
===============================================================================
Purpose:
    - To calculate running totals or moving averages for key metrics.
    - To track performance over time cumulatively.
    - Useful for growth analysis or identifying long-term trends.

SQL Functions Used:
    - Window Functions: SUM() OVER(), AVG() OVER()
===============================================================================
*/

-- Calculate the total sales per month
-- and the running total of sales over time (ytd)

SELECT
	order_date,
	total_sales_mtd,
	avg_price_mtd,
	SUM(total_sales_mtd) OVER(PARTITION BY DATETRUNC(YEAR, order_date) ORDER BY order_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS total_sales_ytd,
	AVG(avg_price_mtd) OVER(PARTITION BY DATETRUNC(YEAR, order_date) ORDER BY order_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS agv_price_ytd,
	SUM(total_sales_mtd) OVER(ORDER BY order_date) AS running_total_sales
FROM
(
	SELECT
	 DATETRUNC(MONTH, order_date) AS order_date,
	 SUM(sales_amount) AS total_sales_mtd,
	 AVG(price) AS avg_price_mtd
	 FROM gold.fact_sales
	 WHERE order_date IS NOT NULL
	 GROUP BY DATETRUNC(MONTH, order_date)
 ) AS SubQueryTable
 ORDER BY DATETRUNC(MONTH, order_date) ASC;