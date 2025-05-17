/*
===========================================================================
ANALYSIS 2: DIMENSION EXPLORATION
===========================================================================
Formula: DISTINCT [Dimension]
Examples:
    - DISTINCT Country
    - DISTINCT Category
===========================================================================
Purpose:
    - To explore and list unique values from key dimension fields like country and product category.

Highlights:
    - Helps understand the spread and variety within a specific dimension (e.g., geography, product lines).
    - Useful for filtering, grouping, or segmenting data during analysis.
===========================================================================
*/

--Q1. Explore All Countries our customers come from.
SELECT DISTINCT 
  country 
FROM 
  gold. dim_customers;

--Q2. Explore All Categories "The Major Divisions"
SELECT DISTINCT 
  category, subcategory, product_name 
FROM 
  gold.dim_products
ORDER BY 1,2,3;


--NOTE: RUN them seperately. 
