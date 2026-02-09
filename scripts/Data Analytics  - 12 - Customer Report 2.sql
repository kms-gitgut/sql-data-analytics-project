/*
===============================================================================
Customer Report
===============================================================================
Purpose:
    - This report consolidates key product metrics and behaviors.

Highlights:
    1. Gathers essential fields such as names, ages and transaction details.
    2. Segments customers into categories (VIP, Regular, New) and age groups (below 20, 20-29, 30-39, 40-49 and 50 and above.
    	
        - VIP: Customers with at least 12 months of history and spending more than 5000,
	    - Regular: Customers with at least 12 months of history and spending 5000 or less,
	    - New: Customers with a lifespan less than 12 months.

    3. Aggregates customer-level metrics:
       - total orders
       - total sales
       - total quantity purchased
       - total products
       - lifespan (in months)
    4. Calculates valuable KPIs:
       - recency (months since last order)
       - average order value
       - average monthly spend
===============================================================================
*/