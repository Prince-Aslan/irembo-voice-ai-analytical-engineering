{{
  config(
    materialized = 'view'
  )
}}

SELECT
  session_id,
  user_id,
  channel,
  language,
  CAST(total_duration_sec AS INT64) AS total_duration_sec,
  CAST(total_turns AS INT64) AS total_turns,
  final_outcome,
  transfer_reason,
  PARSE_DATE('%Y-%m-%d', created_at) AS created_at
FROM {{ source('bronze', 'bronze_voice_sessions') }}

