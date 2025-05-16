/*
===============================================================================
Stored Procedure: Load Silver Layer (Bronze -> Silver)
===============================================================================
Script Purpose:
    This stored procedure performs the ETL (Extract, Transform, Load) process to 
    populate the 'silver' schema tables from the 'bronze' schema.
	Actions Performed:
		- Truncates Silver tables.
		- Inserts transformed and cleansed data from Bronze into Silver tables.
		
Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC Silver.load_silver;
===============================================================================
*/

CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
    DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME; 
    BEGIN TRY
        SET @batch_start_time = GETDATE();
        PRINT '================================================';
        PRINT 'Loading Silver Layer';
        PRINT '================================================';

        		PRINT '------------------------------------------------';
        		PRINT 'Loading CRM Tables';
        		PRINT '------------------------------------------------';

/*==============================================================================================================
Loading silver.crm_cust_info
==============================================================================================================*/
INSERT INTO silver.crm_cust_info
  (cust_id,
  cust_key,
  cust_fname,
  cust_lname,
  cust_material_status,
  cust_gender,
  cust_create_date)

SELECT 
  cust_id,
  cust_key,
  TRIM(cust_fname)     AS cust_fname, 
  TRIM(cust_lname)     AS cust_lname,
  CASE WHEN UPPER(TRIM(cust_material_status)) = 'M' THEN 'Married'
		   WHEN UPPER(TRIM(cust_material_status)) = 'S' THEN 'Single'
		   ELSE 'Unknown'
  END cust_material_status,
  CASE WHEN UPPER(TRIM(cust_gender)) = 'F' THEN 'Female'
		   WHEN UPPER(TRIM(cust_gender)) = 'M' THEN 'Male'
		   ELSE 'Unknown'
  END cust_gender,
  cust_create_date

FROM 
(SELECT *, 
  ROW_NUMBER() OVER(PARTITION BY cust_id ORDER BY cust_create_date DESC) AS extra_ranking 
FROM 
  bronze.crm_cust_info) AS ranked_customers
WHERE 
  extra_ranking = 1; -- Select the most recent record per customer



