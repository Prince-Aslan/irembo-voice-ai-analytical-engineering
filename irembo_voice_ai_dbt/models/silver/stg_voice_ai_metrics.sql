{{
  config(
    materialized = 'view'
  )
}}

SELECT
  session_id,
  CAST(avg_asr_confidence AS FLOAT64) AS avg_asr_confidence,
  CAST(avg_intent_confidence AS FLOAT64) AS avg_intent_confidence,
  CAST(misunderstanding_rate AS FLOAT64) AS misunderstanding_rate,
  CAST(silence_rate AS FLOAT64) AS silence_rate,
  recovery_success,
  escalation_flag
FROM {{ source('bronze', 'bronze_voice_ai_metrics') }}