


with raw_sales as (
    select * from {{ source('raw', 'SALES') }}
),
--if CAP then CAP


cleaned_sales as (
    
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
        quantity * cast(price as decimal(18,2)) as sales_amount
    from raw_sales
)       


select * from cleaned_sales
