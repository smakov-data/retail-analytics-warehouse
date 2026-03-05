
with fct_orders as (
    select * from {{ ref('fct_orders') }}
),

final as (
    SELECT
        order_date, 
        sum(net_amount) AS net,
        sum(gross_amount) AS gross,
        sum(cancelled_amount) AS cancelled
    FROM fct_orders
    GROUP BY order_date
)

select * from final