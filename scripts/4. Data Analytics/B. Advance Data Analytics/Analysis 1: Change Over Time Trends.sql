/*
===========================================================================
ANALYSIS 1: CHANGE OVER TIME TRENDS
===========================================================================
Purpose:
    - To analyze year-over-year trends in sales performance and customer activity.

Highlights:
    1. Calculates annual totals for:
        - Sales revenue
        - Unique customers
        - Quantity sold
    2. Enables time-series insights into business growth and customer engagement.
===========================================================================*/
SELECT
  	YEAR (sales_order_date)				AS order_year,
  	SUM	 (sales)						      AS total_sales,
  	COUNT (DISTINCT customer_id)	AS customer_count,
  	SUM	 (quantity)						    AS total_unit_sale
FROM 
	  gold.fact_sales
WHERE 
	  sales_order_date IS NOT NULL
GROUP BY YEAR (sales_order_date)
ORDER BY YEAR (sales_order_date);
