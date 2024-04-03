{{ config(
    materialized = 'table',
    schema='staging'
) }}


SELECT 

  customer_key,
  transaction_id,
  product_key,
  channel_key,
  reseller_id,
  bought_date_key,
  total_amount,
  qty,
  product_price,
  geography_key,
  commissionpaid,
  commissionpct,
  loaded_timestamp


FROM {{ref('staging_transactions_main')}}


UNION ALL

SELECT 
  customer_key,
  transaction_id,
  product_key,
  channel_key,
  reseller_id,
  bought_date_key,
  total_amount,
  quantity,
  product_price,
  geography_key,
  commissionpaid,
  commissionpct,
  loaded_timestamp
FROM 
    {{ref('staging_reseller_type1_sales')}}

UNION ALL

SELECT 
  customer_key,
  transaction_id,
  product_key,
  channel_key,
  reseller_id,
  bought_date_key,
  total_amount,
  quantity,
  product_price,
  geography_key,
  commissionpaid,
  commissionpct,
  loaded_timestamp
FROM 
    {{ref('staging_reseller_type2_sales')}}