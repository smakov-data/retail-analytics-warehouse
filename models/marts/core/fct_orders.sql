
with stg_sales as (
    select * from {{ ref('stg_sales') }}
),

final as (
    select
        -- ID
        invoice_id,
        max(customer_id) as customer_id, -- если в инвойсе один customer_id
        
        -- DATE
        min(invoice_timestamp) as invoice_timestamp,
        to_date(min(invoice_timestamp)) as order_date,
        
        -- FLAG
        max(case when is_cancelled then 1 else 0 end) as has_cancelled_lines,

        -- VOLUME
        -- kicked: sum(quantity) as total_items,
        sum(case when is_cancelled=false then quantity else 0 end) as gross_items,
        sum(case when is_cancelled=true then quantity else 0 end) as returned_items,
        sum(quantity) as net_items,
        
        -- MONEY
        sum(case when is_cancelled=false then sales_amount else 0 end) as gross_amount,
        sum(case when is_cancelled=true then sales_amount else 0 end) as cancelled_amount,
        sum(sales_amount) as net_amount
    from stg_sales
    group by invoice_id
)

select * from final