{{ config(schema='raw') }}

SELECT 
    productName, 
    qty, 
    totalAmount, 
    salesChannel, 
    customer.firstname AS customer_first_name, 
    customer.lastname AS customer_last_name, 
    customer.email AS customer_email, 
    seriesCity, 
    "Created Date", 
    "reseller-id",
    "transactionID",  
    CURRENT_TIMESTAMP AS loaded_timestamp
FROM {{ source('parquet_input','resellers_type2') }}