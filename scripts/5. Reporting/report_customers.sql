/*
===========================================================================
Customer Report
===========================================================================
Purpose :
	- This report consolidates key customer metrics and behaviors

Highlights :
1. Gathers essential fields such as names, ages, and transaction details.
2. Segments customers into categories (VIP, Regular, New) and age groups.
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
===========================================================================*/

CREATE VIEW gold.report_customers AS
WITH base_query AS
/*=========================================================================
1) Base Query: Retrieves Core Columns from Tables
=========================================================================*/
(SELECT 
    a.order_number,
    a.product_key,
	  a.sales_order_date,
	  a.sales,
	  a.quantity,
	  b.customer_key,
	  b.customer_number,
	  CONCAT(b.first_name, ' ' , b.last_name)	AS customer_name,
	  DATEDIFF(YEAR, b.birthdate, GETDATE())	AS age
FROM 
  	gold.fact_sales		AS a
LEFT JOIN 
	  gold.dim_customers  	AS b
	  ON a.customer_id = b.customer_id
WHERE
	  sales_order_date IS NOT NULL), --(Filtering out the NULL Order Date)

/*=========================================================================
2) Custoemr Aggregation: Aggregates customer-level metrics
=========================================================================*/
customer_aggregateion AS 
(SELECT 
  	customer_key,
  	customer_number,
  	customer_name,
  	age,
	  COUNT(DISTINCT order_number)					AS total_orders,
	  SUM(sales)							AS total_sales,
	  SUM(quantity)							AS total_quantity,
	  COUNT(product_key)						AS total_products,
	  MAX(sales_order_date)						AS last_order_date,
	  DATEDIFF(month, MIN(sales_order_date), MAX(sales_order_date)) AS lifespan
FROM base_query
GROUP BY
  	customer_key,
  	customer_number,
  	customer_name,
  	age)

/*=========================================================================
3)  Custoemr Segmentation on the basis of Age & Sales
	Calculates valuable KPIs
=========================================================================*/
SELECT
  	customer_key,
  	customer_number,
  	customer_name,
  	age,
  	CASE WHEN age < 20 THEN 'Under 20'
  		   WHEN age BETWEEN 20 AND 29 THEN '20-29'
  		   WHEN age BETWEEN 30 AND 39 THEN '30-39'
  		   WHEN age BETWEEN 40 AND 49 THEN '40-49'
  		   ELSE '50 & above'
  	END AS age_group,
  	CASE WHEN lifespan >= 12 AND total_sales > 5000  THEN 'VIP'
  		   WHEN lifespan >= 12 AND total_sales <= 5000 THEN 'Regular'
  		   ELSE 'New'
  	END AS customer_segment,
	  last_order_date,
-- Recency (months since last order)
  	DATEDIFF(MONTH, last_order_date, GETDATE()) AS recency, 
  	total_orders,
  	total_sales,
  	total_quantity,
  	total_products,
  	lifespan,
-- Compute average order value
	  CASE WHEN total_orders = 0 THEN total_sales
		     ELSE total_sales / total_orders
	  END AS average_order_value,
-- Average monthly spend
	  CASE WHEN lifespan = 0 THEN 1
		     ELSE total_sales / lifespan 
	  END AS average_monthly_spend	
FROM 
	  customer_aggregateion;
