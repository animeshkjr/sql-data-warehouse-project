/*
===========================================================================
ANALYSIS 4: PART TO WHOLE PROPORTIONAL ANALYSIS
===========================================================================
Purpose:
    - To understand how different categories contribute to total sales.

Highlights:
    1. Calculates total sales by category.
    2. Determines each category’s proportion of overall sales.
    3. Helps identify dominant and underperforming categories in the sales mix.
===========================================================================
*/

WITH category_contribution AS
(SELECT
  	b.category,
  	SUM(a.sales)			AS total_sales
FROM 
	  gold.fact_sales		AS a
LEFT JOIN 
    gold.dim_products AS b
	  ON a.product_key = b.product_key
GROUP BY category)

SELECT
  	category,
  	total_sales,
  	SUM(total_sales) OVER () AS overall_sales,
  	CONCAT(ROUND((CAST(total_sales AS FLOAT) / SUM(total_sales) OVER ()) * 100, 2), '%') AS percent_of_sales
FROM 
	  category_contribution
ORDER BY 
	  total_sales DESC;
