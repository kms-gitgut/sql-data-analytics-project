
-- Find the date pf the first and last order

SELECT
	MIN(order_date) AS first_order_date,
	MAX(order_date) AS last_order_date
FROM gold.fact_sales

-- How many years of sales are available

SELECT
	MIN(order_date) AS first_order_date,
	MAX(order_date) AS last_order_date,
	DATEDIFF(YEAR, MIN(order_date), MAX(order_date)) AS order_range_years
FROM gold.fact_sales



-- Find the younges and the oldest customer

SELECT
	MIN(birthdate) AS oldest_customer,
	DATEDIFF(YEAR, MIN(birthdate), GETDATE()) AS oldest_age,
	MAX(birthdate) AS youngest_customer,
	DATEDIFF(YEAR, MAX(birthdate), GETDATE()) AS youngst_age
FROm gold.dim_customers;