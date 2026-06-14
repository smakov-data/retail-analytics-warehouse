/*
Model:
mart_revenue_daily

Purpose:
Daily revenue reporting mart used for trend analysis.

Grain:
One row per calendar date.

Source:
fct_orders
*/

with fct_orders as (
    select * from {{ ref('fct_orders') }}
),

final as (
    SELECT
        order_date, 
        date_key,
        sum(net_amount) AS net_revenue,
        sum(gross_amount) AS gross_revenue,
        sum(cancelled_amount) AS cancelled_revenue
    FROM fct_orders
    GROUP BY order_date, date_key
)

select * from final