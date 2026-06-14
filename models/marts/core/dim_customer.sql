/*
Model:
dim_customer

Purpose:
Customer dimension used for customer-level reporting and analysis.

Grain:
One row per customer.

Source:
stg_sales
*/

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
        {{ dbt_utils.generate_surrogate_key(['customer_id']) }} AS customer_key, -- Generate warehouse surrogate key from source customer_id = Used for dimensional joins and future SCD implementations
        customer_id,
        country
    FROM dedup
    WHERE rn = 1
)

SELECT * FROM final