WITH funnel_events AS (
  SELECT
    user_pseudo_id,
    PARSE_DATE('%Y%m%d', event_date) AS event_date,
    MIN(CASE WHEN event_name = 'view_item' THEN TIMESTAMP_MICROS(event_timestamp) END) AS view_time,
    MIN(CASE WHEN event_name = 'purchase' THEN TIMESTAMP_MICROS(event_timestamp) END) AS purchase_time
  FROM `tc-da-1.turing_data_analytics.raw_events`
  GROUP BY user_pseudo_id, event_date
)
SELECT
  FORMAT_DATE('%A', event_date) AS weekday,
  ROUND(APPROX_QUANTILES(TIMESTAMP_DIFF(purchase_time, view_time, MINUTE), 2)[OFFSET(1)], 2) AS median_minutes_to_purchase,
  ROUND(AVG(TIMESTAMP_DIFF(purchase_time, view_time, MINUTE)), 2) AS avg_minutes_to_purchase
FROM funnel_events
WHERE purchase_time IS NOT NULL
  AND view_time IS NOT NULL
  AND purchase_time >= view_time
GROUP BY weekday
ORDER BY
  CASE weekday
    WHEN 'Monday' THEN 1
    WHEN 'Tuesday' THEN 2
    WHEN 'Wednesday' THEN 3
    WHEN 'Thursday' THEN 4
    WHEN 'Friday' THEN 5
    WHEN 'Saturday' THEN 6
    WHEN 'Sunday' THEN 7
  END
