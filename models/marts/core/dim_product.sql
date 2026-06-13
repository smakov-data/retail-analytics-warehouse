WITH source AS (
    SELECT * FROM {{ ref('stg_sales') }}
),

final AS (
    SELECT DISTINCT
        stock_code,
        
        max(product_description) AS product_description 
        -- выбираем тот вариант где МАКС кол-во текста в описании
    FROM source
    GROUP BY stock_code
)

SELECT * FROM FINAL