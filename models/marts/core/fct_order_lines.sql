
with stg_sales as (
    select * from {{ ref('stg_sales') }}
),

final as (
    SELECT
        -- ID
        order_line_key,
        invoice_id,
        stock_code,
        to_date(invoice_timestamp) AS order_date,
        invoice_timestamp,
        quantity,
        unit_price, 
        sales_amount,
        is_cancelled
    FROM stg_sales
)

select * from final