WITH stg_sales AS (
    SELECT * FROM {{ ref('stg_sales') }}
),

dedup AS (
    SELECT
        customer_id,
        country,
        ROW_NUMBER() OVER (
            PARTITION BY customer_id
            ORDER BY invoice_timestamp DESC
        ) AS rn
    FROM stg_sales
    WHERE customer_id IS NOT NULL
),

final AS (
    SELECT
        {{ dbt_utils.generate_surrogate_key(['customer_id']) }} AS customer_key, -- gen customer_key, for future joins and SCD, better for DWH
        customer_id,
        country
    FROM dedup
    WHERE rn = 1
)

SELECT * FROM final