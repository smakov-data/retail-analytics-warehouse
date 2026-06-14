

WITH stg_sales AS (
    SELECT * FROM {{ ref('stg_sales') }}
),

dim_customer AS (
    SELECT * FROM {{ ref('dim_customer') }}
),

dim_date AS (
    SELECT * FROM {{ ref('dim_date')}}
),


final AS (
    SELECT
        s.order_line_key,
        s.invoice_id,

        c.customer_key,
        s.customer_id,

        s.stock_code,
        TO_DATE(s.invoice_timestamp) AS order_date,
        d.date_key, -- тянем из dim_date
        s.invoice_timestamp,

        s.quantity,
        s.unit_price,
        s.sales_amount,
        s.is_cancelled

    -- JOIN
    FROM stg_sales s
    LEFT JOIN dim_customer c
        ON s.customer_id = c.customer_id
    LEFT JOIN dim_date d
        ON TO_DATE(s.invoice_timestamp) = d.order_date -- подгонка формата инвойса со временем К order_date
        -- кста, такой же ту_дейт используется в dim_date - это не бьется, просто такой же подход 
)

SELECT * FROM final