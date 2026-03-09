with stg_sales as (
    select * from {{ ref('stg_sales') }}
),

final as (
    select
        customer_id,
        max(country) as country -- one country
    from stg_sales
    where customer_id is not null -- kick guests
    group by customer_id -- dim: group_by id
)

select * from final