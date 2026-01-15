{{
  config(
    materialized = 'view'
  )
}}

SELECT
  application_id,
  session_id,
  user_id,
  service_code,
  channel,
  status,
  CAST(time_to_submit_sec AS INT64) AS time_to_submit_sec,
  PARSE_DATE('%Y-%m-%d', submitted_at) AS submitted_at
FROM {{ source('bronze', 'bronze_applications') }}