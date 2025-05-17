/*
===========================================================================
ANALYSIS 1: CHANGE OVER TIME TRENDS
===========================================================================
Formula: Σ [Measure] By [Date Dimension]
Examples:
    - Total Sales By Year
    - Avg Cost By Month
    - Total Orders By Quarter
===========================================================================
Purpose:
    - To analyze year-over-year trends in sales performance and customer activity.

Highlights:
    1. Calculates annual totals for (Method 2):
        - Sales revenue
        - Unique customers
        - Quantity sold
    2. Enables time-series insights into business growth and customer engagement.
===========================================================================*/
SELECT
  	DATETRUNC (year, sales_order_date)  	AS order_year,
  	SUM (sales)				AS total_sales,
  	COUNT (DISTINCT customer_id)		AS customer_count,
  	SUM (quantity)				AS total_unit_sale
FROM 
	gold.fact_sales
WHERE 
	sales_order_date IS NOT NULL
GROUP BY DATETRUNC (year, sales_order_date)
ORDER BY DATETRUNC (year, sales_order_date);
