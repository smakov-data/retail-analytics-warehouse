/*
Model:
mart_product_performance

Purpose:
Product performance mart used for revenue and sales analysis.

Grain:
One row per product.

Source:
fct_order_lines

Key Metrics:
units_sold
orders_cnt
sku_net_revenue
return_rate
revenue_share
cumulative_share
avg_order_value_per_sku
*/

with fct_order_lines as (
    select * from {{ ref('fct_order_lines') }}
),

sku as (
    select
        stock_code,
        sum(case when not is_cancelled then quantity else 0 end) as units_sold,
        count(distinct invoice_id) as orders_cnt,
        sum(sales_amount) as sku_net_revenue,

        sum(case when not is_cancelled then sales_amount else 0 end) as gross_amount,
        sum(case when is_cancelled then sales_amount else 0 end) as cancelled_amount
    from fct_order_lines
    group by stock_code
),

final as (
    select
        stock_code,
        units_sold,
        orders_cnt,
        sku_net_revenue,
        abs(cancelled_amount / nullif(gross_amount, 0)) as return_rate, -- Calculate return rate based on cancelled revenue vs gross revenue
        sku_net_revenue / nullif(sum(sku_net_revenue) over (), 0) as revenue_share,
        sum(
            case when sku_net_revenue > 0 then sku_net_revenue else 0 end
        ) over (
            order by case when sku_net_revenue > 0 then sku_net_revenue else 0 end desc
        )
        /
        nullif(
            sum(case when sku_net_revenue > 0 then sku_net_revenue else 0 end) over (),
            0
        ) as cumulative_share, -- Calculate cumulative revenue share for Pareto / ABC-style product analysis
        sku_net_revenue / nullif(orders_cnt, 0) as avg_order_value_per_sku
    from sku
)

select * from final