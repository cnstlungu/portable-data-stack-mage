{{ config(schema='raw') }}

SELECT  
    "Product name",
    Quantity,
    "Total amount",
    "Sales Channel",
    "Customer First Name",
    "Customer Last Name", 
    "Customer Email",
    "Series City",
    "Created Date",
    "Reseller ID",
    "Transaction ID",
    CURRENT_TIMESTAMP AS loaded_timestamp
FROM {{ source('parquet_input','resellers_type1') }}