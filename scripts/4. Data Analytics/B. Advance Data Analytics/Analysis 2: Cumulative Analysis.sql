/*
===========================================================================
ANALYSIS 2: CUMULATIVE ANALYSIS 
===========================================================================
Purpose:
    - To evaluate monthly sales progression and monitor cumulative growth trends.

Highlights:
    1. Calculates total sales per month.
    2. Computes the running (cumulative) total of sales over time.
    3. Calculates the average selling price per month.
    4. Useful for visualizing momentum, seasonality, and long-term performance.
===========================================================================*/
SELECT
  	order_date,  --(or  order_date AS sales_order_date)
  	total_sales, --(or  total_saels AS sales)
  	SUM(total_sales) OVER (ORDER BY order_date)	  AS running_total,    --(Window Function)
  	AVG(avg_price) OVER (ORDER BY order_date)			AS moving_avg_price  --(Window Function)
FROM
	(SELECT 
  		DATETRUNC(month, sales_order_date)			AS order_date,
  		SUM(sales)										          AS total_sales,
  		AVG(price)										          AS avg_price
	FROM 
		  gold.fact_sales
	WHERE 
		  sales_order_date IS NOT NULL
	GROUP BY 
		  DATETRUNC(month, sales_order_date) 
	)   AS full_date;
