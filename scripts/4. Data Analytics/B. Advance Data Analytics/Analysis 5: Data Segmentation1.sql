/*
===========================================================================
ANALYSIS 5: DATA SEGMENTATION
===========================================================================
Formula: [Measure] By [Measure]
Examples:
    - Total Products By Sales Range
    - Total Customers By Age
    - Total Orders By Price Range
===========================================================================
Purpose:
    - To categorize products into cost-based segments for better analysis.

Highlights:
    1. Segments products into defined cost ranges.
    2. Counts the number of products within each segment.
    3. Useful for pricing strategy, inventory planning, and product mix analysis.
===========================================================================
*/

WITH product_segments AS
(SELECT 
	product_key,
	product_name,
	product_cost,
	CASE 	WHEN product_cost < 100 THEN 'Below 100'
		WHEN product_cost BETWEEN 100 AND 500 THEN '100 - 500'	
		WHEN product_cost BETWEEN 500 AND 1000 THEN '500 - 1000'
		ELSE 'Above 1000'
	END AS cost_range
FROM 
	gold.dim_products)

SELECT
	cost_range,
	COUNT(product_key) AS total_products
FROM 
	product_segments
GROUP BY 
	cost_range
ORDER BY
	total_products DESC;
