-- #01: Validate Snowflake session context
SELECT 
    CURRENT_USER(),
    CURRENT_ROLE(),
    CURRENT_WAREHOUSE();

-- #02: Create dbt warehouse
CREATE WAREHOUSE IF NOT EXISTS DBT_WH
WITH 
    WAREHOUSE_SIZE = 'XSMALL'
    AUTO_SUSPEND = 60
    AUTO_RESUME = TRUE;

-- #03: Set active warehouse
USE WAREHOUSE DBT_WH;

-- #04: Create database and schemas
CREATE DATABASE IF NOT EXISTS ANALYTICS;
USE DATABASE ANALYTICS;

CREATE SCHEMA IF NOT EXISTS RAW;
CREATE SCHEMA IF NOT EXISTS STAGING;
CREATE SCHEMA IF NOT EXISTS MART;

-- #05: Validate raw source table after CSV upload
SELECT 
    COUNT(*) AS raw_sales_row_count
FROM ANALYTICS.RAW.SALES;

-- #06: Preview staging model after dbt run
SELECT * 
FROM ANALYTICS.STAGING.STG_SALES
LIMIT 20;

-- #07: Preview fact order lines model
SELECT * 
FROM ANALYTICS.MART.FCT_ORDER_LINES
LIMIT 20;

-- #08: Validate invoice grain in fact order lines
SELECT 
    invoice_id, 
    COUNT(*) AS line_count
FROM ANALYTICS.MART.FCT_ORDER_LINES
GROUP BY invoice_id
HAVING COUNT(*) > 1;

-- #09: Preview fact orders model
SELECT * 
FROM ANALYTICS.MART.FCT_ORDERS
LIMIT 20;

-- #10: Validate invoice grain in fact orders
SELECT 
    invoice_id, 
    COUNT(*) AS order_count
FROM ANALYTICS.MART.FCT_ORDERS
GROUP BY invoice_id
HAVING COUNT(*) > 1;

-- #11: Preview customer dimension
SELECT *
FROM ANALYTICS.MART.DIM_CUSTOMER
LIMIT 20;

-- #12: Preview product dimension
SELECT *
FROM ANALYTICS.MART.DIM_PRODUCT
LIMIT 20;

-- #13: Preview daily revenue mart
SELECT *
FROM ANALYTICS.MART.MART_REVENUE_DAILY
LIMIT 20;

-- #14: Preview product performance mart
SELECT *
FROM ANALYTICS.MART.MART_PRODUCT_PERFORMANCE
LIMIT 20;

-- #15: Validate revenue share calculations
SELECT
    MIN(cumulative_share) AS min_cumulative_share,
    MAX(cumulative_share) AS max_cumulative_share,
    SUM(revenue_share) AS total_revenue_share
FROM ANALYTICS.MART.MART_PRODUCT_PERFORMANCE;

-- #16: Export-ready queries for Power BI
SELECT *
FROM ANALYTICS.MART.FCT_ORDERS;

SELECT *
FROM ANALYTICS.MART.DIM_CUSTOMER;

SELECT *
FROM ANALYTICS.MART.MART_REVENUE_DAILY;

SELECT *
FROM ANALYTICS.MART.MART_PRODUCT_PERFORMANCE;