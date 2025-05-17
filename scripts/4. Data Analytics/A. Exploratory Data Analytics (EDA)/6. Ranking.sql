/*
===========================================================================
ANALYSIS 6: RANKING
===========================================================================
Formula: ∑ [Dimension] By ∑ [Measure]
Examples:
    - Rank Countries By Total Sales
    - Top 5 Products By Quantity
    - Bottom 3 Customers by Total Orders
===========================================================================
Purpose:
    - To order groups or items based on their total values.
    - Helps identify best and worst performers.
    - Useful for spotting leaders or laggards in data.
===========================================================================
Highlights:
    - Uses ranking functions to assign positions based on sums.
    - Finds top or bottom records based on key metrics.
    - Makes comparison between groups easier and clearer.
===========================================================================
*/

--1. Which 5 products generate the highest revenue and rank them ?
SELECT *
FROM
  (SELECT
  b.product_name,
  SUM(a.sales) total_revenue,
  ROW_NUMBER() OVER (ORDER BY SUM(a.sales) DESC) AS rank_products
  FROM gold.fact_sales        AS a
  LEFT JOIN gold.dim_products AS b
  ON a.product_key = b.product_key
  GROUP BY b.product_name)    AS inner_func
WHERE rank_products <= 5;

--2. What are the 5 worst-perfohming products in terms of sales ?
SELECT TOP 5
  b.product_name,
  SUM(a.sales) total_revenue
FROM gold.fact_sales        AS a
LEFT JOIN gold.dim_products AS b
  ON a.product_key = b.product_key
GROUP BY b.product_name
ORDER BY total_revenue ASC
