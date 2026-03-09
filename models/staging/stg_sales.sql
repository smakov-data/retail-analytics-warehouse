
/*
This script create staging layer (view( based on raw data from dbt database snowlake.
*/

with raw_sales as (
    select * from {{ source('raw', 'SALES') }}
),
--if CAP then CAP

base as (
    
    select
        invoice as invoice_id,
        stockcode as stock_code,
        description as product_description,
        quantity,
        invoicedate as invoice_timestamp,
        cast(price as decimal(18,2)) as unit_price,
        customer_id,
        country,

        case when left(invoice, 1) = 'C' then true else false end as is_cancelled,
        quantity * cast(price as decimal(18,2)) as sales_amount,

        ROW_NUMBER() OVER (
            PARTITION BY
                invoice,
                stock_code,
                invoicedate,
                COALESCE(customer_id, 'IF_ID_NULL_PLACEHOLDER')
            ORDER BY invoice
        ) AS line_dup_seq
        --{{ dbt_utils.generate_surrogate_key(['invoice','stockcode','invoicedate', 'quantity', 'price', "coalesce(customer_id, 'IF_ID_NULL_PLACEHOLDER')"]) }} as order_line_key
        --{{ dbt_utils.generate_surrogate_key(['invoice','stockcode','invoicedate',"coalesce(customer_id, '__NA__')"]) }} as order_line_key
    from raw_sales
),

FINAL AS (
    SELECT 
        *,
        {{ dbt_utils.generate_surrogate_key(['invoice_id','stock_code','invoice_timestamp', "coalesce(customer_id, 'IF_ID_NULL_PLACEHOLDER')", 'line_dup_seq']) }} as order_line_key
    FROM base
)


select * from final
