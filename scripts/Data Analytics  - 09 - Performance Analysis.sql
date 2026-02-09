
-- analyze the yearly performace of products by compering each product's sales 
-- to both its average sales perfromance and the previous year's sales

WITH 

yearly_product_sales AS
(
SELECT
	YEAR(s.order_date) AS order_date_year,
	p.product_name,
	SUM(s.sales_amount) AS current_sales
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_products AS p
ON s.product_key = p.product_key
WHERE order_date IS NOT NULL
GROUP BY 
	YEAR(s.order_date), 
	p.product_name
)

SELECT
	order_date_year,
	product_name,
	current_sales,
	AVG(current_sales) OVER(PARTITION BY product_name) AS average_sales,
	current_sales - AVG(current_sales) OVER(PARTITION BY product_name) AS diff_avg,
	CASE
		WHEN current_sales - AVG(current_sales) OVER(PARTITION BY product_name) > 0 THEN 'Above Avg'
		WHEN current_sales - AVG(current_sales) OVER(PARTITION BY product_name) < 0 THEN 'Below Avg'
		ELSE 'Avg'
	END AS avg_change,
	-- year-over-year analysis
	LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_date_year ASC) AS py_sales,
	current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_date_year ASC) AS diff_py,
	CASE
		WHEN current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_date_year ASC) > 0 THEN 'Increase'
		WHEN current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_date_year ASC) < 0 THEN 'Decrease'
		ELSE 'No change'
	END AS py_change
FROM yearly_product_sales
GROUP BY
	order_date_year,
	product_name,
	current_sales
ORDER BY 
	product_name ASC,
	order_date_year ASC;