{{
    config(
        materialized='incremental',
        schema='staging'
    )
}}


WITH  latest_transaction AS (
    
SELECT MAX(loaded_timestamp) AS max_transaction_timestamp  FROM {{ this }}

)

,

trans_resellers  AS (


SELECT 

    {{ dbt_utils.generate_surrogate_key(
      [ "'reseller-id'", "'customer_email'"]
    ) }} AS customer_key,
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
FROM         {{ ref(
      'raw_reseller_type2_sales'
    ) }}

  {% if is_incremental() %}

  -- this filter will only be applied on an incremental run
  where CURRENT_TIMESTAMP > (SELECT max_transaction_timestamp FROM latest_transaction LIMIT 1)

  {% endif %}

)

SELECT
  t.customer_key,
  transaction_id,
  t.product_name,
  p.product_key,
  c.channel_key,
  t.reseller_id,
  strftime(created_date::DATE, '%Y%m%d') AS bought_date_key,
  total_amount::NUMERIC AS total_amount,
  quantity,
  p.product_price::NUMERIC AS product_price,
  p.geography_key,
  s.commission_pct * total_amount::NUMERIC AS commissionpaid,
  s.commission_pct AS commissionpct,
  loaded_timestamp
FROM
  trans_resellers t
  LEFT JOIN {{ ref('dim_product') }} p
    ON t.product_name = p.product_name
  LEFT JOIN {{ ref('dim_channel') }} c
    ON t.sales_channel = c.channel_name
  LEFT JOIN {{ ref('dim_customer') }} cu
    ON t.customer_key = cu.customer_key
  LEFT JOIN {{ ref('dim_salesagent') }} s
    ON t.reseller_id = s.original_reseller_id