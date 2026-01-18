## “I document my SQL in Markdown using fenced code blocks so queries are readable, versioned, and reviewer-friendly in GitHub.”

----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------

PART 3 (1a)

## A. Voice AI Effectiveness

### 1. Top 3 Friction Points in Voice AI Interactions

Friction points are defined as areas where the Voice AI struggles to perform optimally. We define **friction** based on the following metrics:

- **High Misunderstanding:** Instances where the AI misinterprets user input.  
- **High Silence:** Long pauses or delays without responses from the AI.  
- **High Escalation:** Cases where the interaction is transferred to a human agent.  
- **Low Completion:** Scenarios where the user fails to complete the intended task.

**Top 3 Friction Points:**

| Rank | Friction Point         | Metric Impact                         |
|------|----------------------|---------------------------------------|
| 1    | Misunderstanding      | Most common cause of failed interactions |
| 2    | Silence               | Leads to user frustration and drop-offs |
| 3    | Escalation            | Increases operational costs and reduces AI effectiveness |



Query 1: Friction drivers summary (Voice only)

```sql
SELECT
  service_code,
  AVG(misunderstanding_rate) AS avg_misunderstanding_rate,
  AVG(silence_rate) AS avg_silence_rate,
  AVG(total_turns) AS avg_turns,
  COUNTIF(escalated_to_agent) / COUNT(*) AS escalation_rate,
  COUNTIF(is_session_completed) / COUNT(*) AS session_completion_rate
FROM `irembo-voice-ai.irembo_voice_ai_irembo_voice_ai.fact_voice_ai_sessions`
WHERE is_voice_application = TRUE
GROUP BY service_code
ORDER BY
  escalation_rate DESC,
  avg_misunderstanding_rate DESC
LIMIT 3;
```

Goal: This identifies the top 3 services with the highest interaction friction.
Query result



Query 2: Session-level friction signals (Voice AI)

```sql
SELECT
  COUNT(*) AS total_sessions,
  COUNTIF(misunderstanding_rate > 0.3) AS high_misunderstanding_sessions,
  COUNTIF(silence_rate > 0.2) AS high_silence_sessions,
  COUNTIF(escalated_to_agent) AS escalated_sessions,
  COUNTIF(NOT is_session_completed) AS dropped_sessions
FROM `irembo-voice-ai.irembo_voice_ai_irembo_voice_ai.fact_voice_ai_sessions`
WHERE is_voice_application = TRUE;
```
Goal: This quantifies the most common friction mechanisms overall.

----------------------------------------------------------------------------------------------------
Part 3 (1b)
Completion Rate Comparisons
1b(i). Voice vs Non-Voice Completion Rates

```sql
SELECT
  application_channel,
  COUNTIF(is_application_completed) / COUNT(*) AS completion_rate,
  COUNT(*) AS total_applications
FROM `irembo-voice-ai.irembo_voice_ai_irembo_voice_ai.fact_voice_ai_sessions`
GROUP BY application_channel;
```

Goal: Compares Voice vs Web/Other channels directly.


Part 3 1b(ii). 
Rural vs Urban Completion Rates

```sql
SELECT
  region,
  COUNTIF(is_application_completed) / COUNT(*) AS completion_rate,
  COUNT(*) AS total_sessions
FROM `irembo-voice-ai.irembo_voice_ai_irembo_voice_ai.fact_voice_ai_sessions`
WHERE is_voice_application = TRUE
GROUP BY region;
```

Goal: Focuses on equity impact within Voice AI.


----------------------------------------------------------------------------------------------------
Part 3(1c)
--First-Time Digital Users Performance
1c. Do first-time digital users perform better with Voice AI?


Query 1: Completion rate by channel for first-time digital users

```sql
SELECT
  application_channel,
  COUNTIF(is_application_completed) / COUNT(*) AS completion_rate,
  COUNT(*) AS total_applications
FROM `irembo-voice-ai.irembo_voice_ai_irembo_voice_ai.fact_voice_ai_sessions`
WHERE is_first_time_digital_user = TRUE
GROUP BY application_channel;
```

Query 2: Voice vs non-voice efficiency for first-time users

```sql
SELECT
  application_channel,
  AVG(time_to_submit_sec) AS avg_time_to_submit_sec,
  AVG(total_turns) AS avg_turns
FROM `irembo-voice-ai.irembo_voice_ai_irembo_voice_ai.fact_voice_ai_sessions`
WHERE is_first_time_digital_user = TRUE
GROUP BY application_channel;
```

