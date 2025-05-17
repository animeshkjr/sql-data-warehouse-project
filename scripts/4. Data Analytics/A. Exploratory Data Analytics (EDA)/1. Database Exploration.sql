/*
===========================================================================
ANALYSIS 1: DATABASE EXPLORATION
===========================================================================
Purpose: Metadata Queries
    - To get a quick overview of what tables exist in the database 
      and what columns are inside a selected table.

Highlights:
    - Lists all tables and views in the system.
    - Shows column names and data types for a given table.
    - Useful for getting familiar with the database structure before starting analysis.
===========================================================================
*/

--Q1. Explore all objects in the Database
SELECT * FROM INFORMATION_SCHEMA.TABLES;

--Q2. Explore all columns in the Database
SELECT * FROM INFORMATION_SCHEMA.COLUMNS;


-- RUN them seperately. 
-- To filter further columns USE WHERE Clause
