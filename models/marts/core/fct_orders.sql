/*
Model:
fct_orders

Purpose:
Order-level fact table used for revenue and sales reporting.

Grain:
One row per invoice.

Source:
stg_sales
*/

with fct_order_lines as (
    select * from {{ ref('fct_order_lines') }}
),

final as (
    select
        -- Identifiers
        invoice_id,
        max(customer_id) as customer_id, -- Expected to be consistent within each invoice
        min(customer_key) as customer_key, -- Keep one customer dimension key per invoice

        -- Dates
        min(invoice_timestamp) as invoice_timestamp, -- Use earliest line timestamp as invoice timestamp
        to_date(min(invoice_timestamp)) as order_date,
        min(date_key) as date_key, -- Keep one date dimension key per invoice
        
        -- Flags
        max(case when is_cancelled then 1 else 0 end) as has_cancelled_lines, -- Flag invoices with at least one cancelled line

        -- Volume metrics
        sum(case when is_cancelled=false then quantity else 0 end) as gross_items,
        sum(case when is_cancelled=true then quantity else 0 end) as returned_items,
        sum(quantity) as net_items,
        
        -- Revenue metrics
        sum(case when is_cancelled=false then sales_amount else 0 end) as gross_amount,
        sum(case when is_cancelled=true then sales_amount else 0 end) as cancelled_amount,
        sum(sales_amount) as net_amount
    from fct_order_lines
    group by invoice_id
)

select * from final