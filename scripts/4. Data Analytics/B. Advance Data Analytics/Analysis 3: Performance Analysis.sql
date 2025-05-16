/*
===========================================================================
ANALYSIS 3: PERFORMANCE ANALYSIS 
===========================================================================
Purpose:
    - To assess yearly product performance relative to overall average performance.

Highlights:
    1. Calculates total yearly sales for each product.
    2. Computes average sales across all products.
    3. Compares product sales to the average to highlight over/underperformance.
===========================================================================
*/
WITH yearly_product_sales AS   /*(WITH clause in SQL is used to create a Common Table Expression (CTE). It is like - Let me create a small table just for this query, and I'll use it later) */
(SELECT 
  	YEAR(a.sales_order_date) AS order_year,
  	b.product_name,
  	SUM(a.sales)		 AS current_sales
FROM 
	Gold.fact_sales	 	 AS a
LEFT JOIN 
	gold.dim_products	 AS b
ON 	a.product_key = b.product_key
WHERE 
	a.sales_order_date IS NOT NULL
GROUP BY 
	YEAR(a.sales_order_date), b.product_name)

SELECT
    	order_year,
    	product_name,
    	current_sales,
    	AVG(current_sales) OVER (PARTITION BY product_name)  AS avg_sales,
    	current_sales - AVG(current_sales) OVER (PARTITION BY product_name) AS diff_sales,
    	CASE WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name) > 0 THEN 'Above Avg Sales'
    		   WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name) < 0 THEN 'Below Avg Sales'
    		   ELSE 'Avg Sales'
    	END AS avg_change
FROM 
	yearly_product_sales
ORDER BY 
	product_name, order_year;
