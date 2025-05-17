/*
===========================================================================
ANALYSIS 3: DATE EXPLORATION
===========================================================================
Formula: MIN/MAX [Date Dimension]
Examples:
    - MIN sales_order_date
    - MAX sales_order_date
    - MIN birthdate
    - MAX birthdate
===========================================================================
Purpose:
    - To explore key date-related metrics within the data for overall understanding.

Highlights:
    - Identifies important minimum and maximum dates across different datasets.
    - Provides a foundation for understanding data coverage and time ranges.
===========================================================================
*/

/*Q1. Find the date of the first and last order
How many years of sales are avaiable*/

SELECT 
  MIN(sales_order_date)                                        AS first_order_date,
  MAX(sales_order_date)                                        AS last_order_date,
  DATEDIFF(year, MIN(sales_order_date), MAX(sales_order_date)) AS order_date_difference
FROM 
  gold. fact_sales;

--Q2 Find the youngest and the oldest customer
SELECT
  MIN(birthdate)                                 AS oldest_customer__birthdate,
  DATEDIFF(year, MIN(birthdate), GETDATE())      AS oldest_customer_age,
  MAX(birthdate)                                 AS youngest_customer__birthdate,
  DATEDIFF(year, MAX(birthdate), GETDATE())      AS youngest_customer_age
FROM gold.dim_customers;


--NOTE: RUN them seperately. 
