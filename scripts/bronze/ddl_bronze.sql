----------------------------------------------------------------
--Create table bronze.crm_cust_info
----------------------------------------------------------------
IF OBJECT_ID('bronze.crm_cust_info', 'U') IS NOT NULL
    DROP TABLE bronze.crm_cust_info;
GO
CREATE TABLE bronze.crm_cust_info (
	cust_id              INT,
	cust_key             NVARCHAR(50),
	cust_fname           NVARCHAR(50),
	cust_lname           NVARCHAR(50),
	cust_material_status NVARCHAR(50),
	cust_gender          NVARCHAR(50),
	cust_create_date     DATE
);
GO

----------------------------------------------------------------
--Create table bronze.crm_prod_info
----------------------------------------------------------------
IF OBJECT_ID('bronze.crm_prod_info', 'U') IS NOT NULL
    DROP TABLE bronze.crm_prod_info;
GO
  
CREATE TABLE bronze.crm_prod_info (
	prod_id         INT,
	prod_key        NVARCHAR(50),
	prod_name       NVARCHAR(50),
	prod_cost       INT,
	prod_line       NVARCHAR(50),
	prod_start_date DATETIME,
	prod_end_date   DATETIME
);
GO

----------------------------------------------------------------
--Create table bronze.crm_sales_details
----------------------------------------------------------------
IF OBJECT_ID('bronze.crm_sales_details', 'U') IS NOT NULL
    DROP TABLE bronze.crm_sales_details;
GO

CREATE TABLE bronze.crm_sales_details (
	sls_ord_num       NVARCHAR(50),
	sls_prod_key      NVARCHAR(50),
	sls_cust_id       INT,
	sls_ord_date      INT,
	sls_ship_date     INT,
	sls_due_date      INT,
	sls_sales         INT,
	sls_qty           INT,
	sls_price         INT
);
GO

----------------------------------------------------------------
--Create table bronze.erp_cust_az12
----------------------------------------------------------------
IF OBJECT_ID('bronze.erp_cust_az12', 'U') IS NOT NULL
    DROP TABLE bronze.erp_cust_az12;
GO

CREATE TABLE bronze.erp_cust_az12 (
	cid   NVARCHAR(50),
	bdate DATE,
	gen   NVARCHAR(50)
);
GO

----------------------------------------------------------------
--Create table bronze.erp_loc_a101
----------------------------------------------------------------
IF OBJECT_ID('bronze.erp_loc_a101', 'U') IS NOT NULL
    DROP TABLE bronze.erp_loc_a101;
GO
CREATE TABLE bronze.erp_loc_a101 (
	cid     NVARCHAR(50),
	country NVARCHAR(50)
);
GO

----------------------------------------------------------------
--Create table bronze.erp_px_cat_g1v2
----------------------------------------------------------------
IF OBJECT_ID('bronze.erp_px_cat_g1v2', 'U') IS NOT NULL
    DROP TABLE bronze.erp_px_cat_g1v2;
GO
CREATE TABLE bronze.erp_px_cat_g1v2 (
	id          NVARCHAR(50),
	cat         NVARCHAR(50),
	subcat      NVARCHAR(50),
	maintenance NVARCHAR(50)
);
GO
