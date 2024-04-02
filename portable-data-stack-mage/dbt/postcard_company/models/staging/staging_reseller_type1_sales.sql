{{
    config(
        schema='staging'
    )
}}

WITH  trans_reseller AS (
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
)

SELECT
  t.customer_key,
  transaction_id,
  e.product_key,
  C.channel_key,
  t.reseller_id,
  strftime(created_date::DATE, '%Y%m%d') AS bought_date_key,
  total_amount::NUMERIC AS total_amount,
  t.quantity,
  e.product_price::NUMERIC AS product_price,
  e.geography_key,
  s.commission_pct * total_amount::NUMERIC AS commissionpaid,
  s.commission_pct AS commissionpct,
  loaded_timestamp
FROM
  trans_reseller t
  JOIN {{ ref('dim_product') }} e
    ON t.product_name = e.product_name
  JOIN {{ ref('dim_channel') }} C
    ON t.sales_channel = C.channel_name
  JOIN {{ ref('dim_customer') }} cu
    ON t.customer_key = cu.customer_key
  JOIN {{ ref('dim_salesagent') }} s
    ON t.reseller_id = s.original_reseller_id
