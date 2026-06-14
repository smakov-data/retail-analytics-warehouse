

WITH stg_sales AS (
    SELECT * FROM {{ ref('stg_sales') }}
),

dim_customer AS (
    SELECT * FROM {{ ref('dim_customer') }}
),

final AS (
    SELECT
        s.order_line_key,
        s.invoice_id,

        c.customer_key,
        s.customer_id,

        s.stock_code,
        TO_DATE(s.invoice_timestamp) AS order_date,
        to_number(to_char(TO_DATE(s.invoice_timestamp),'YYYYMMDD')) AS date_key, -- date_key - Enterpcie Practise (Spot #2)
        s.invoice_timestamp,

        s.quantity,
        s.unit_price,
        s.sales_amount,
        s.is_cancelled

    -- JOIN
    FROM stg_sales s
    LEFT JOIN dim_customer c
        ON s.customer_id = c.customer_id
)

SELECT * FROM final