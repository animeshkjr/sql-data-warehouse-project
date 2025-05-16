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
SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.crm_cust_info';
		TRUNCATE TABLE silver.crm_cust_info;
		PRINT '>> Inserting Data Into: silver.crm_cust_info';

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
	     ELSE 'Unknown'  						--(Normalize marital status values to readable format)
	END cust_material_status,
	CASE WHEN UPPER(TRIM(cust_gender)) = 'F' THEN 'Female'
	     WHEN UPPER(TRIM(cust_gender)) = 'M' THEN 'Male'
	     ELSE 'Unknown'						--(Normalize gender values to readable format)
	END cust_gender,
	cust_create_date

FROM 
	(SELECT *, 
  	ROW_NUMBER() OVER(PARTITION BY cust_id ORDER BY cust_create_date DESC) AS extra_ranking 
FROM 
 	 bronze.crm_cust_info) AS ranked_customers
WHERE 
  	 extra_ranking = 1; -- Select the most recent record per customer

SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';

/*==============================================================================================================
Loading silver.crm_prd_info
==============================================================================================================*/
SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.crm_prd_info';
		TRUNCATE TABLE silver.crm_prd_info;
		PRINT '>> Inserting Data Into: silver.crm_prd_info';
INSERT INTO silver.crm_prod_info
	(prod_id,
	cat_id,
	prod_key,
	prod_name,
	prod_cost,
	prod_line,
	prod_start_date,
	prod_end_date)
SELECT 
	prod_id,
	REPLACE(SUBSTRING (prod_key, 1, 5), '-', '_')   AS cat_id,   -- Extract category ID
	SUBSTRING (prod_key, 7, LEN(prod_key)) 		AS prod_key, -- Extract product key
	prod_name,
	ISNULL(prod_cost, 0) 				AS prod_cost,
	CASE	WHEN UPPER(TRIM(prod_line)) = 'M' THEN 'Mountain'
		WHEN UPPER(TRIM(prod_line)) = 'R' THEN 'Road'
		WHEN UPPER(TRIM(prod_line)) = 'S' THEN 'Other Sales'
		WHEN UPPER(TRIM(prod_line)) = 'T' THEN 'Touring'
		ELSE 'Unknown'
	END AS prod_line,  -- Map product line codes to descriptive values
	CAST(prod_start_date AS DATE) AS prod_start_date,
	CAST(LEAD(prod_start_date) OVER (PARTITION BY prod_key ORDER BY prod_start_date)-1 AS DATE) AS prod_end_date -- Calculate end date as one day before the next start date
FROM 
	bronze.crm_prod_info;

SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';

/*==============================================================================================================
Loading silver.crm_sales_details
==============================================================================================================*/
SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.crm_sales_details';
		TRUNCATE TABLE silver.crm_sales_details;
		PRINT '>> Inserting Data Into: silver.crm_sales_details';

INSERT INTO silver.crm_sales_details
	(sls_ord_num, 
	sls_prod_key,
	sls_cust_id,
	sls_ord_date,
	sls_ship_date,
	sls_due_date,
	sls_sales,
	sls_qty,
	sls_price)
SELECT 
	sls_ord_num,
	sls_prod_key,
	sls_cust_id,
	CASE 	WHEN sls_ord_date <=0 OR LEN(sls_ord_date) != 8 THEN NULL
		ELSE CAST(CAST(sls_ord_date AS VARCHAR) AS DATE) 
	END AS sls_ord_date,
	CASE 	WHEN sls_ship_date <=0 OR LEN(sls_ord_date) != 8 THEN NULL
		ELSE CAST(CAST(sls_ship_date AS VARCHAR) AS DATE) 
	END AS sls_ship_date,
	CASE 	WHEN sls_due_date <=0 OR LEN(sls_due_date) != 8 THEN NULL
		ELSE CAST(CAST(sls_due_date AS VARCHAR) AS DATE) 
	END AS sls_ord_date,
	CASE 	WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_qty * ABS(sls_price) THEN sls_qty * ABS(sls_price)
		ELSE sls_sales  -- (Recalculate sales if original value is missing or incorrect)
	END AS sls_sales,	-- (Derive price if original value is invalid)
	sls_qty,
	CASE 	WHEN sls_price IS NULL OR sls_price <= 0 OR sls_price != ABS(sls_sales)/ NULLIF(sls_qty, 0) THEN ABS(sls_sales)/NULLIF(sls_qty,0)
		ELSE sls_price
	END AS sls_price
FROM 
	bronze.crm_sales_details;

SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';


/*==============================================================================================================
Loading erp_cust_az12
==============================================================================================================*/
SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.erp_cust_az12';
		TRUNCATE TABLE silver.erp_cust_az12;
		PRINT '>> Inserting Data Into: silver.erp_cust_az12';

INSERT INTO silver.erp_cust_az12 (cid, bdate, gen)
SELECT
	CASE 	WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, len(cid))  
		ELSE cid
	END AS cid,
	CASE 	WHEN bdate > GETDATE() THEN NULL
		ELSE bdate
	END AS bdate,

	CASE 	WHEN gen = 'F' THEN 'Female'
		WHEN gen = 'M' THEN 'Male'
		WHEN gen IS NULL OR gen = '' THEN 'Unknown' 
		ELSE gen
	END AS gen  --(Normalize gender values and handle unknown cases)
FROM bronze.erp_cust_az12;

SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';

		PRINT '------------------------------------------------';
		PRINT 'Loading ERP Tables';
		PRINT '------------------------------------------------';

/*==============================================================================================================
Loading erp_loc_a101
==============================================================================================================*/
SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.erp_loc_a101';
		TRUNCATE TABLE silver.erp_loc_a101;
		PRINT '>> Inserting Data Into: silver.erp_loc_a101';
INSERT INTO silver.erp_loc_a101(cid, country)
SELECT 
	REPLACE(cid, '-','') AS cid,
	CASE 	WHEN UPPER(TRIM(country)) IN ('US','USA') THEN 'United States'
		WHEN UPPER(TRIM(country)) = 'DE' THEN 'Germany'
		WHEN country IS NULL OR country = '' THEN 'Unknown'
		ELSE country
	END AS country  -- (Normalize and Handle missing or blank country codes)
FROM bronze.erp_loc_a101;
SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';
/*==============================================================================================================
Loading erp_px_cat_g1v2
==============================================================================================================*/
SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.erp_px_cat_g1v2';
		TRUNCATE TABLE silver.erp_px_cat_g1v2;
		PRINT '>> Inserting Data Into: silver.erp_px_cat_g1v2';

SET @end_time = GETDATE();
	PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';

--=================================================================================================================
	SET @batch_end_time = GETDATE();
		PRINT '=========================================='
		PRINT 'Loading Silver Layer is Completed';
        PRINT '   - Total Load Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
		PRINT '=========================================='
		
	END TRY
	BEGIN CATCH
		PRINT '=========================================='
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER'
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Message' + CAST (ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message' + CAST (ERROR_STATE() AS NVARCHAR);
		PRINT '=========================================='
	END CATCH
END
