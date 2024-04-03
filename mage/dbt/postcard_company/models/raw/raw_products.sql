{{ config(schema='raw') }}

SELECT
    name,
    city,
    price,
    product_id,
    CURRENT_TIMESTAMP AS loaded_timestamp 
FROM {{ source('parquet_input','products') }}