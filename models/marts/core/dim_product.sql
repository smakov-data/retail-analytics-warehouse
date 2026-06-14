/*
Model:
dim_product

Purpose:
Product dimension used for product-level reporting and analysis.

Grain:
One row per product.

Source:
stg_sales
*/

WITH source AS (
    SELECT * FROM {{ ref('stg_sales') }}
),

final AS (
    SELECT DISTINCT
        stock_code,
        
        max(product_description) AS product_description -- Resolve multiple descriptions per stock_code by selecting one representative value (MAX velue)
    FROM source
    GROUP BY stock_code
)

SELECT * FROM FINAL