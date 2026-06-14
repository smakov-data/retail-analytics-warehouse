/*
Model:
stg_sales

Purpose:
Clean and standardize raw sales data from the source system.

Grain:
One row per invoice line item.

Source:
raw.sales
*/

with raw_sales as (
    select * from {{ source('raw', 'SALES') }}
),

base as (
    
    select
        invoice as invoice_id,
        stockcode as stock_code,
        description as product_description,
        quantity,
        invoicedate as invoice_timestamp,
        cast(price as decimal(18,2)) as unit_price,
        CAST(customerid AS VARCHAR) AS customer_id, -- CustomerID is stored as VARCHAR to safely handle null and non-numeric source values
        country,

        case when left(invoice, 1) = 'C' then true else false end as is_cancelled,
        quantity * cast(price as decimal(18,2)) as sales_amount,

        ROW_NUMBER() OVER (
            PARTITION BY
                invoice,
                stock_code,
                invoicedate,
                COALESCE(CAST(customerid AS VARCHAR), 'IF_ID_NULL_PLACEHOLDER')
            ORDER BY invoice
        ) AS line_dup_seq
    from raw_sales
),

FINAL AS (
    SELECT 
        *,
        {{ dbt_utils.generate_surrogate_key(['invoice_id','stock_code','invoice_timestamp', "COALESCE(customer_id, 'IF_ID_NULL_PLACEHOLDER')", 'line_dup_seq']) }} as order_line_key
    FROM base
)


select * from final
