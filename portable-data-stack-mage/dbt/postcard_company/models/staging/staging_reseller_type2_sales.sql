



WITH 


latest_transaction AS (
    
select MAX(loaded_timestamp) AS max_transaction  FROM {{ this }}


)


SELECT 
    productName AS product_name, 
    qty AS quantity, 
    totalAmount AS total_amount, 
    salesChannel AS sales_channel, 
    customer_first_name, 
    customer_last_name, 
    customer_email, 
    seriesCity AS series_city, 
    "Created Date" AS created_date, 
    "reseller-id" AS reseller_id,
    "transactionID" AS transaction_id,  
    CURRENT_TIMESTAMP AS loaded_timestamp
FROM     {{ ref(
      'raw_reseller_type2_sales'
    ) }}