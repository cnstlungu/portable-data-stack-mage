{{
    config(
        materialized='incremental',
        schema='staging'
    )
}}


WITH 

{% if is_incremental() %}

latest_transaction AS (
    
select MAX(loaded_timestamp) AS max_transaction  FROM {{ this }}

),

  {% endif %}

trans_reseller AS (
  SELECT
    {{ dbt_utils.generate_surrogate_key(
      [ "'reseller-id'", "'Customer Email'"]
    ) }} AS customer_key,
    "Product name" AS product_name, 
    Quantity AS quantity, 
    "Total amount" AS total_amount, 
    "Sales Channel" AS sales_channel, 
    "Customer First Name" AS customer_first_name, 
    "Customer Last Name" AS customer_last_name,  
    "Customer Email" AS customer_email, 
    "Series City" AS series_city, 
    "Created Date" AS created_date, 
    "Reseller ID" AS reseller_id,
    "Transaction ID" AS transaction_id,
    CURRENT_TIMESTAMP AS loaded_timestamp 
  FROM
    {{ ref(
      'raw_reseller_type1_sales'
    ) }}

      {% if is_incremental() %}

  -- this filter will only be applied on an incremental run
  WHERE loaded_timestamp > (SELECT max_transaction FROM latest_transaction LIMIT 1)

  {% endif %}

) 

SELECT
  t.customer_key,
  transaction_id,
  p.product_key,
  c.channel_key,
  t.reseller_id,
  strftime(created_date::DATE, '%Y%m%d') AS bought_date_key,
  total_amount::NUMERIC AS total_amount,
  t.quantity,
  p.product_price::NUMERIC AS product_price,
  p.geography_key,
  s.commission_pct * total_amount::NUMERIC AS commissionpaid,
  s.commission_pct AS commissionpct,
  loaded_timestamp
FROM
  trans_reseller t
  LEFT JOIN {{ ref('dim_product') }} p
    ON t.product_name = p.product_name
  LEFT JOIN {{ ref('dim_channel') }} c
    ON t.sales_channel = c.channel_name
  LEFT JOIN {{ ref('dim_customer') }} cu
    ON t.customer_key = cu.customer_key
  LEFT JOIN {{ ref('dim_salesagent') }} s
    ON t.reseller_id = s.original_reseller_id
