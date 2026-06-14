/*
Model:
dim_date

Purpose:
Date dimension used for time-based reporting and analysis.

Grain:
One row per calendar date.

Source:
stg_sales
*/

WITH SOURCE AS (
    SELECT * FROM {{ ref('stg_sales') }}
),

dates AS (
    SELECT DISTINCT
        to_date(invoice_timestamp) AS order_date
        
    FROM source
    WHERE invoice_timestamp IS NOT NULL 
),

FINAL AS (
    SELECT
        order_date,
        to_number(to_char(order_date,'YYYYMMDD')) AS date_key, --  Surrogate date key (smart key) used for joins between fact and date dimension tables
        year(order_date) AS year,
        month(order_date) AS month,
        to_char(order_date,'Mon') AS month_name,
        weekofyear(order_date) AS week,
        dayofweekiso(order_date) AS day_of_week
    FROM dates
)

SELECT * FROM FINAL