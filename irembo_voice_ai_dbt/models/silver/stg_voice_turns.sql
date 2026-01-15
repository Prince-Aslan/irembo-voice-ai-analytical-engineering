{{
  config(
    materialized = 'view'
  )
}}

SELECT
  turn_id,
  session_id,
  CAST(turn_number AS INT64) AS turn_number,
  speaker,
  detected_intent AS intent,
  CAST(intent_confidence AS FLOAT64) AS intent_confidence,
  CAST(asr_confidence AS FLOAT64) AS asr_confidence,
  error_type,
  CAST(turn_duration_sec AS INT64) AS silence_duration_sec,
  PARSE_DATE('%Y-%m-%d', created_at) AS turn_date
FROM {{ source('bronze', 'bronze_voice_turns') }}