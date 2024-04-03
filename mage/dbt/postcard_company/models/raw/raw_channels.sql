{{ config(schema='raw') }}
SELECT
    channel_name,
    channel_id,
    CURRENT_TIMESTAMP AS loaded_timestamp 
FROM {{ source('parquet_input','channels') }}