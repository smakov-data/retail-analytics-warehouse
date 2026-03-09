WITH SOURCE AS (
    SELECT * FROM {{ ref('stg_sales') }}
),

dates AS ( -- или какое лучше имя дать?
    SELECT DISTINCT
        to_date(invoice_timestamp) AS order_date
        
    FROM source
),

FINAL AS (
    SELECT
        order_date,
        to_number(to_char(order_date,'YYYYMMDD')) AS date_key, -- date_key - Enterpcie Practise
        year(order_date) AS year,
        month(order_date) AS month,
        to_char(order_date,'Mon') AS month_name,
        weekofyear(order_date) AS week,
        dayofweekiso(order_date) AS day_of_week
    FROM dates
)

SELECT * FROM FINAL