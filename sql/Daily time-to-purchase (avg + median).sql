WITH visits AS (
  SELECT
    user_pseudo_id,
    PARSE_DATE('%Y%m%d', event_date) visit_date,
    MIN(TIMESTAMP_MICROS(event_timestamp)) AS first_visit_time
FROM `tc-da-1.turing_data_analytics.raw_events`
WHERE event_name = 'session_start'
GROUP BY user_pseudo_id, visit_date
),

purchases AS (
  SELECT
    user_pseudo_id,
    PARSE_DATE('%Y%m%d', event_date) purchase_date,
    MIN(TIMESTAMP_MICROS(event_timestamp)) AS first_purchase_time
  FROM `tc-da-1.turing_data_analytics.raw_events`
  WHERE event_name = 'purchase'
  GROUP BY user_pseudo_id, purchase_date
)

SELECT
  v.visit_date,
  COUNT(v.user_pseudo_id) AS users,
  ROUND(
    AVG(TIMESTAMP_DIFF(p.first_purchase_time, v.first_visit_time, MINUTE)),
     2) AS avg_minutes_to_purchase,
  ROUND(
    APPROX_QUANTILES(
      TIMESTAMP_DIFF(p.first_purchase_time, v.first_visit_time, MINUTE),
        2)[OFFSET(1)], 2) AS median_minutes_to_purchase
FROM visits AS v
JOIN purchases AS p
ON v.user_pseudo_id = p.user_pseudo_id
AND v.visit_date = p.purchase_date
GROUP BY v.visit_date
ORDER BY v.visit_date
