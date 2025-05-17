/*
===========================================================================
ANALYSIS 4: PART TO WHOLE PROPORTIONAL ANALYSIS
===========================================================================
Formula: ([Measure] / Total [Measure]) * 100 By [Dimension]
Examples:
    - (Sales / Total Sales) * 100 By Category
    - (Quantity / Total Quantity) * 100 By Country
    - (Profit / Total Profit) * 100 By Region
===========================================================================
Purpose:
    - To understand how different categories contribute to total sales.

Highlights:
    1. Calculates total sales by category.
    2. Determines each category’s proportion of overall sales.
    3. Helps identify dominant and underperforming categories in the sales mix.
===========================================================================*/
SELECT
    b.category,
    SUM(a.sales)              AS category_total_sales,
    SUM(SUM(a.sales)) OVER () AS overall_total_sales,
    CONCAT(ROUND((CAST(SUM(a.sales) AS FLOAT) / SUM(SUM(a.sales)) OVER ()) * 100, 2), '%') AS sales_percentage
FROM 
    gold.fact_sales   AS a
LEFT JOIN 
    gold.dim_products AS b
    ON a.product_key = b.product_key
GROUP BY b.category
ORDER BY category_total_sales DESC;
