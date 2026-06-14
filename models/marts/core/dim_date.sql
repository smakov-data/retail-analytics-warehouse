WITH SOURCE AS (
    SELECT * FROM {{ ref('stg_sales') }}
),

dates AS (
    SELECT DISTINCT
        to_date(invoice_timestamp) AS order_date
        
    FROM source
    WHERE invoice_timestamp IS NOT NULL -- чтобы не 
),

FINAL AS (
    SELECT
        order_date,
        to_number(to_char(order_date,'YYYYMMDD')) AS date_key, -- date_key - Enterpcie Practise (Spot #1 and last -> в fct_order_lines - date_key подтягиваем отсюда via JOIN)
        year(order_date) AS year,
        month(order_date) AS month,
        to_char(order_date,'Mon') AS month_name,
        weekofyear(order_date) AS week,
        dayofweekiso(order_date) AS day_of_week
    FROM dates
)

SELECT * FROM FINAL