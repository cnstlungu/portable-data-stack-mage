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

FROM customers_main c
LEFT JOIN {{ref('dim_salesagent')}} s ON c.reseller_id = s.original_reseller_id