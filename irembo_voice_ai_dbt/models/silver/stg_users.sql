{{
  config(
    materialized = 'view'
  )
}}

SELECT
  user_id,
  region,
  disability_flag,
  first_time_digital_user
FROM {{ source('bronze', 'bronze_users') }}
WHERE user_id IS NOT NULL

