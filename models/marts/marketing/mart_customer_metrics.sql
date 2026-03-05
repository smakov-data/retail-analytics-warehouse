with fct_orders as (
    select * from {{ ref('fct_orders') }}
),

final as (
    SELECT
        customer_id,
        COUNT(DISTINCT invoice_id) AS orders_cnt,
        SUM(net_amount) AS net_revenue,
        min(order_date) AS first_seen_at,
        max(order_date) AS last_seen_at
    FROM fct_orders
    WHERE customer_id is not null -- kick: guests
    GROUP BY customer_id
)

select * from final