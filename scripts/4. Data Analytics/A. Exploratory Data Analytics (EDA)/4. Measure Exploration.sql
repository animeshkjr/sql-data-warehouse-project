/*
===========================================================================
ANALYSIS 4: MEASURE EXPLORATION
===========================================================================
Formula: ∑ [Measures]
Examples:
    - SUM(sales)
    - AVG(price)
    - COUNT(DISTINCT order_number)
    - COUNT(product_name)
===========================================================================
Purpose:
    - To explore key quantitative metrics within the dataset for business insights.

Highlights:
    - Calculates various aggregate measures such as totals, averages, and counts.
    - Provides a comprehensive summary of sales, orders, products, and customer activity.
===========================================================================
*/

/* -- Find the Total Sales
SELECT SUM(sales) AS total_sales 
FROM gold.fact_sales;

-- Find how many items are sold
SELECT SUM(quantity) AS total_quantity 
FROM gold.fact_sales;

-- Find the average selling price
SELECT AVG(price) AS avg_price 
FROM gold. fact_sales;

-- Find the Total number of Orders
SELECT COUNT (DISTINCT order_number) AS total_orders  -- Use of DISSTINCT as there are duplicate orders
FROM gold.fact_sales;

-- Find the total number of products
SELECT COUNT (product_name) AS total_products 
FROM gold.dim_products;

-- Find the total number of customers
SELECT COUNT (customer_key) AS total_customers 
FROM gold .dim_customers;

-- Find the total number of customers that has placed an order
SELECT COUNT (DISTINCT customer_id) AS total_customers 
FROM gold.fact_sales;

(All the above codes can run seperately but better will be to run in a single go to get a better understanding)
*/

-- Generate a Report that shows all key metrics of the business
SELECT 'Total Sales'         AS measure_name, SUM(sales)                    AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total Quantity'      AS measure_name, SUM(quantity)                 AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Average Price'       AS measure_name, AVG(price)                    AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total Orders'        AS measure_name, COUNT(DISTINCT order_number)  AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total Products'      AS measure_name, COUNT(product_name)           AS measure_value FROM gold.dim_products
UNION ALL
SELECT 'Total Customers'     AS measure_name, COUNT(customer_key)           AS measure_value FROM gold.dim_customers
UNION ALL
SELECT 'Total Orders Placed' AS measure_name, COUNT(DISTINCT customer_id)   AS measure_value FROM gold.fact_sales
