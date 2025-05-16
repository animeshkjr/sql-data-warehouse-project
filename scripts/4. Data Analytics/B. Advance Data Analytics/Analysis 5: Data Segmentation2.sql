/*
===========================================================================
ANALYSIS 5: DATA SEGMENTATION
===========================================================================
Purpose:
    - To classify customers based on their lifecycle and spending patterns for targeted analysis.

Highlights:
    1.Group customers into THREE segments based on their spending behaviour:
        - VIP: Customers with at least 12 months of history and spending more than $5,000
        - Regular: Customers with at least 12 months of history but spending $5,000 and less 
        - New: Customers with lifespan less than 12 months
     2.And find total number of customers by each group
===========================================================================
*/

WITH customer_spending AS
(SELECT
	b.customer_id,
	SUM(a.sales)													                            AS total_spending,
	MIN(a.sales_order_date)											                      AS first_order,
	MAX(a.sales_order_date)											                      AS last_order,
	DATEDIFF(month, MIN(a.sales_order_date), MAX(a.sales_order_date)) AS lifespan
FROM 
	gold.fact_sales     AS a
LEFT JOIN
	gold.dim_customers  AS b
	ON a.customer_id = b.customer_id
	GROUP BY b.customer_id)

SELECT
	customer_segment,
	COUNT(customer_id)   AS total_customers
FROM
	(SELECT 
		customer_id,
		total_spending,
		lifespan,
		CASE WHEN lifespan >= 12 AND total_spending > 5000  THEN 'VIP'
			   WHEN lifespan >= 12 AND total_spending <= 5000 THEN 'Regular'
			   ELSE 'New'
		END AS customer_segment
	FROM
		customer_spending) AS t
GROUP BY customer_segment
ORDER BY total_customers DESC;


