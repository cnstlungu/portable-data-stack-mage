{{ config(schema='staging') }}
WITH 

customers_main AS (

    SELECT 
    
    customer_id, 
    first_name AS customer_first_name, 
    last_name AS customer_last_name, 
    email AS customer_email,
    0 AS reseller_id
    
    FROM {{ref('raw_customers')}}

),

customers_reseller_type1  AS (

    SELECT  
        "customer first name" AS customer_first_name, 
        "customer last name" AS customer_last_name ,
        "customer email" AS customer_email,
        "reseller id"::INT AS reseller_id,
        "transaction id" AS transaction_id
    FROM 
        {{ref('raw_reseller_type1_sales')}}
)
,

customers_reseller_type2 AS (

    SELECT 
        customer_first_name, 
        customer_last_name, 
        customer_email,
        "reseller-id" AS reseller_id,
        transactionId AS transaction_id
    FROM 
        {{ref('raw_reseller_type2_sales')}}
), 

customers_union AS (

SELECT reseller_id, transaction_id AS customer_id , customer_first_name, customer_last_name, customer_email  FROM customers_reseller_type1

UNION 

SELECT reseller_id, transaction_id AS customer_id, customer_first_name, customer_last_name, customer_email  FROM customers_reseller_type2

UNION

SELECT 0 AS reseller_id, customer_id, customer_first_name, customer_last_name, customer_email  FROM customers_main
)



SELECT 

  {{ dbt_utils.generate_surrogate_key([
      "'Main'",
      'customer_id']
  ) }} AS customer_key,
 
 customer_first_name, 
 customer_last_name, 
 customer_email,
 s.sales_agent_key

FROM customers_union c
LEFT JOIN {{ref('dim_salesagent')}} s ON c.reseller_id = s.original_reseller_id