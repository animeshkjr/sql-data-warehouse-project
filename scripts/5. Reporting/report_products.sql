/*
===========================================================================
Product Report
===========================================================================
Purpose :
	- This report consolidates key products metrics and behaviors

Highlights :
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
	- average order revenue
	- average monthly revenue
===========================================================================*/

CREATE VIEW gold.report_products AS
/*=========================================================================
1) Base Query: Retrieves Core Columns from Tables
=========================================================================*/
WITH base_query AS
(SELECT 
  	a.order_number,
  	a.sales_order_date,
  	a.customer_id,
  	a.product_key,
  	b.product_name,
  	b.category,
  	b.subcategory,
  	b.product_cost,
  	a.sales,
  	a.quantity
FROM 
  	gold.fact_sales   AS a
LEFT JOIN 
  	gold.dim_products AS b
  	ON a.product_key = b.product_key
WHERE 
    sales_order_date IS NOT NULL),

/*=========================================================================
2) Product Aggregation: Aggregates product-level metrics
=========================================================================*/
product_aggregation AS
(SELECT
  	product_key,
  	product_name,
  	category,
  	subcategory,
  	product_cost,
  	DATEDIFF(MONTH, MIN(sales_order_date), MAX(sales_order_date)) AS lifespan,
  	MAX(sales_order_date)										                      AS last_sales_date,
  	COUNT(DISTINCT order_number)								                  AS total_orders,
  	COUNT(DISTINCT customer_id)									                  AS total_customers,
  	SUM(sales)													                          AS total_sales,
  	SUM(quantity)											                            AS total_quantity,
  	ROUND(AVG(CAST(sales AS FLOAT) / NULLIF(quantity, 0)), 1)	    AS avg_selling_price
FROM 
    base_query
GROUP BY
  	product_key,
  	product_name,
  	category,
  	subcategory,
  	product_cost)

/*=========================================================================
3) Final Query: Combines all product levels in one output
=========================================================================*/

SELECT 
  	product_key,
  	product_name,
  	category,
  	subcategory,
  	product_cost,
  	last_sales_date,
  	DATEDIFF(MONTH, last_sales_date, GETDATE()) AS recency_in_months,
  	CASE WHEN total_sales > 50000 THEN 'High-Performer'
  		   WHEN total_sales >= 10000 THEN 'Mid_Range'
  		   ELSE 'Low-Performer'
  	END AS product_segment,
  	lifespan,
  	total_orders,
  	total_customers,
  	total_sales,
  	total_quantity,
  	avg_selling_price,
  	--Average Order Revenue (AOR)--
  	CASE WHEN total_orders = 0 THEN 0
  		   ELSE total_sales / total_orders
  	END AS avg_order_revenue,
    --Average Monthly Revenue
  	CASE WHEN lifespan = 0 THEN total_sales
  		   ELSE total_sales / lifespan
  	END AS avg_monthly_revenue
FROM 
    product_aggregation;
