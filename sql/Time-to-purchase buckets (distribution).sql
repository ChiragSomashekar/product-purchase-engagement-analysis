WITH visits AS (
  SELECT
    user_pseudo_id,
    PARSE_DATE('%Y%m%d', event_date) AS visit_date,
    MIN(TIMESTAMP_MICROS(event_timestamp)) AS first_visit_time
  FROM `tc-da-1.turing_data_analytics.raw_events`
  WHERE event_name = 'session_start'
  GROUP BY user_pseudo_id, visit_date
),

purchases AS (
  SELECT
    user_pseudo_id,
    PARSE_DATE('%Y%m%d', event_date) AS purchase_date,
    MIN(TIMESTAMP_MICROS(event_timestamp)) AS first_purchase_time
  FROM `tc-da-1.turing_data_analytics.raw_events`
  WHERE event_name = 'purchase'
  GROUP BY user_pseudo_id, purchase_date
),

durations AS (
  SELECT
    v.user_pseudo_id,
    TIMESTAMP_DIFF(p.first_purchase_time, v.first_visit_time, MINUTE) AS minutes_to_purchase
  FROM visits v
  JOIN purchases p
    ON v.user_pseudo_id = p.user_pseudo_id
   AND v.visit_date = p.purchase_date
)

SELECT
  CASE
    WHEN minutes_to_purchase BETWEEN 0 AND 10 THEN 'Quick Buyers (0–10 min)'
    WHEN minutes_to_purchase BETWEEN 11 AND 30 THEN 'Comparers (11–30 min)'
    WHEN minutes_to_purchase BETWEEN 31 AND 45 THEN 'Browsers (31-45)'
    ELSE 'Late Converters(>45 min)'
  END AS time_bucket,
  COUNT(DISTINCT user_pseudo_id) AS purchasers
FROM durations
GROUP BY time_bucket
ORDER BY time_bucket
