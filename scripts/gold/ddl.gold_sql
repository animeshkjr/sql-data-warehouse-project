/*
===============================================================================
DDL Script: Create Gold Views
===============================================================================
Script Purpose:
    This script creates views for the Gold layer in the data warehouse. 
    The Gold layer represents the final dimension and fact tables (Star Schema)

    Each view performs transformations and combines data from the Silver layer 
    to produce a clean, enriched, and business-ready dataset.

Usage:
    - These views can be queried directly for analytics and reporting.
===============================================================================
*/

/*=============================================================================
Create Dimension: gold.dim_customers
=============================================================================*/
IF OBJECT_ID('gold.dim_customers', 'V') IS NOT NULL
    DROP VIEW gold.dim_customers;
GO
CREATE VIEW gold.dim_customers AS
SELECT 
	ROW_NUMBER() OVER (ORDER BY cust_id) AS customer_key,
	aa.cust_id			AS customer_id,
	aa.cust_key			AS customer_number,
	aa.cust_fname			AS first_name,
	aa.cust_lname			AS last_name,
	cc.country			AS country,
	aa.cust_material_status		AS marital_status,
	CASE WHEN aa.cust_gender != 'Unknown' THEN aa.cust_gender --cust_gender is the master
		 ELSE COALESCE(bb.gen, 'Unknown')
	END AS gender,
	bb.bdate			AS birthdate,
	aa.cust_create_date		AS create_date
FROM 
	silver.crm_cust_info		AS aa
LEFT JOIN 
	silver.erp_cust_az12		AS bb
	ON aa.cust_key = bb.cid
LEFT JOIN 
	silver.erp_loc_a101		AS cc
	ON aa.cust_key = cc.cid;
GO

/*=============================================================================
Create Dimension: gold.dim_products
=============================================================================*/
IF OBJECT_ID('gold.dim_products', 'V') IS NOT NULL
    DROP VIEW gold.dim_products;
GO
CREATE VIEW gold.dim_products AS
SELECT 
	ROW_NUMBER() OVER(ORDER BY pp.prod_start_date, pp.prod_key) AS product_serial,
	pp.prod_id 		AS product_id,
	pp.prod_key 		AS product_key,
	pp.prod_name 		AS product_name,
	pp.cat_id 		AS category_id,
	qq.cat 			AS category,
	qq.subcat 		AS subcategory,
	pp.prod_line 		AS product_line,
	pp.prod_cost 		AS product_cost,
	pp.prod_start_date 	AS start_date,
	qq.maintenance 		AS maintenance
FROM 
	silver.crm_prod_info 	AS pp
LEFT JOIN 
	silver.erp_px_cat_g1v2 AS qq
	ON pp.cat_id = qq.cat_id
WHERE prod_end_date IS NULL;
GO

/*=============================================================================
Create Dimension: gold.fact_sales
=============================================================================*/
IF OBJECT_ID('gold.fact_sales', 'V') IS NOT NULL
    DROP VIEW gold.fact_sales;
GO
CREATE VIEW gold.fact_sales AS
SELECT 
	zz.sls_ord_num 	  AS order_number, 
	xx.product_key,
	yy.customer_id,
	zz.sls_ord_date   AS sales_order_date,
	zz.sls_ship_date  AS sales_ship_date,
	zz.sls_due_date   AS sales_due_date,
	zz.sls_sales 	  AS sales,
	zz.sls_qty 	  AS quantity,
	zz.sls_price 	  AS price
FROM 
	silver.crm_sales_details AS zz
LEFT JOIN 
	gold.dim_products AS xx
	ON zz.sls_prod_key = xx.product_key
LEFT JOIN 
	gold.dim_customers AS yy
	ON zz.sls_cust_id = yy.customer_id;
