/*
===============================================================================
Date Range Exploration 
===============================================================================
Purpose:
    - To determine the temporal boundaries of key data points.
    - To understand the range of historical data.

SQL Functions Used:
    - MIN(), MAX(), DATEDIFF()
===============================================================================
*/

-- Find the date of the first and last order  and the total duration in months

SELECT
	MIN(order_date) AS first_order_date,
	MAX(order_date) AS last_order_date,
	DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS order_range_in_months
FROM gold.fact_sales


-- How many years of sales are available in the database

SELECT
	MIN(order_date) AS first_order_date,
	MAX(order_date) AS last_order_date,
	DATEDIFF(YEAR, MIN(order_date), MAX(order_date)) AS order_range_years
FROM gold.fact_sales


-- Find the younges and the oldest customer based on birthdate

SELECT
	MIN(birthdate) AS oldest_customer,
	DATEDIFF(YEAR, MIN(birthdate), GETDATE()) AS oldest_age,
	MAX(birthdate) AS youngest_customer,
	DATEDIFF(YEAR, MAX(birthdate), GETDATE()) AS youngst_age
FROm gold.dim_customers;