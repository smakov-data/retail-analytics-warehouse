/*
Model:
mart_customer_metrics

Purpose:
Customer analytics mart used for customer purchasing behavior and revenue analysis.

Grain:
One row per customer.

Source:
fct_orders

Key Metrics:
orders_cnt
net_revenue
first_seen_at
last_seen_at
*/

with fct_orders as (
    select * from {{ ref('fct_orders') }}
),

final as (
    SELECT
        customer_id,
        customer_key,
        COUNT(DISTINCT invoice_id) AS orders_cnt,
        SUM(net_amount) AS net_revenue,
        min(order_date) AS first_seen_at,
        max(order_date) AS last_seen_at
    FROM fct_orders
    WHERE customer_id is not null
    GROUP BY customer_id, customer_key
)

select * from final