/*
Model:
fct_order_lines

Purpose:
Order line fact table used for product-level sales analysis.

Grain:
One row per invoice line.

Source:
stg_sales
*/

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
        TO_DATE(s.invoice_timestamp) AS order_date, -- Retain human-readable date alongside date_key
        d.date_key, -- Retrieve surrogate date key from the date dimension
        s.invoice_timestamp,

        s.quantity,
        s.unit_price,
        s.sales_amount,
        s.is_cancelled

    FROM stg_sales s
    LEFT JOIN dim_customer c
        ON s.customer_id = c.customer_id
    LEFT JOIN dim_date d
        ON TO_DATE(s.invoice_timestamp) = d.order_date
)

SELECT * FROM final