WITH session_applications AS (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY session_id
            ORDER BY submitted_at
        ) AS app_rank
    FROM {{ ref('stg_applications') }}
),

single_application AS (
    SELECT *
    FROM session_applications
    WHERE app_rank = 1
)

SELECT
    -- Identifiers
    vs.session_id,
    vs.user_id,

    -- User attributes
    u.region,
    u.disability_flag,
    u.first_time_digital_user,

    -- Session attributes
    vs.channel AS session_channel,
    vs.language,
    vs.total_duration_sec,
    vs.total_turns,
    vs.final_outcome AS session_outcome,
    vs.transfer_reason,
    vs.created_at AS session_start_at,

    -- AI metrics
    m.avg_asr_confidence,
    m.avg_intent_confidence,
    m.misunderstanding_rate,
    m.silence_rate,
    m.recovery_success = 'yes' AS recovery_success_flag,
    m.escalation_flag = 'yes' AS escalated_to_agent,

    -- Application outcomes (1:1 per session)
    a.application_id,
    a.service_code,
    a.channel AS application_channel,
    a.status AS application_status,
    a.time_to_submit_sec,
    a.submitted_at,

    -- KPI flags
    u.region = 'rural' AS is_rural_user,
    u.first_time_digital_user = 'yes' AS is_first_time_digital_user,
    u.disability_flag = 'yes' AS has_disability_flag,
    vs.final_outcome = 'completed' AS is_session_completed,
    a.status = 'completed' AS is_application_completed,
    a.channel = 'voice' AS is_voice_application

FROM {{ ref('stg_voice_sessions') }} vs
LEFT JOIN {{ ref('stg_users') }} u
    ON vs.user_id = u.user_id
LEFT JOIN {{ ref('stg_voice_ai_metrics') }} m
    ON vs.session_id = m.session_id
LEFT JOIN single_application a
    ON vs.session_id = a.session_id
