WITH source AS (
    SELECT * FROM {{ ref('stg_sales') }}
),

final AS (
    SELECT DISTINCT
        stock_code,
        max(product_description) AS product_description
    FROM source
    GROUP BY stock_code
)

SELECT * FROM FINAL