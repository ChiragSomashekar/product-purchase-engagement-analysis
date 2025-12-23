WITH purchases AS (
  SELECT
    PARSE_DATE('%Y%m%d', event_date) AS purchase_date,
    user_pseudo_id,
    SUM(purchase_revenue_in_usd) AS revenue,
    COUNT(*) AS user_purchases
  FROM `tc-da-1.turing_data_analytics.raw_events`
  WHERE event_name = 'purchase'
  GROUP BY user_pseudo_id, event_date
)
SELECT
  COUNT(DISTINCT user_pseudo_id) AS total_customers,
  SUM(user_purchases) AS total_purchases,
  ROUND(SUM(revenue), 2) AS total_revenue,
  ROUND(SUM(revenue) / SUM(user_purchases), 2) AS AOV,
  ROUND(SUM(revenue) / COUNT(DISTINCT user_pseudo_id), 2) AS ARPU
FROM purchases
