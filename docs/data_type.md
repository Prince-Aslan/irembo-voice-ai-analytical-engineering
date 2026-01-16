### `fact_voice_ai_sessions` Schema

| Field                        | Type      | Description                                                                 |
|-----------------------------|-----------|-----------------------------------------------------------------------------|
| `session_id`                | STRING    | Anonymized session ID (e.g., S2000)                                         |
| `user_id`                   | STRING    | Anonymized user ID (e.g., U1000)                                            |
| `region`                    | STRING    | User's geographic region: `'urban'` or `'rural'`                            |
| `disability_flag`           | STRING    | Indicates accessibility need: `'yes'` or `'no'`                             |
| `first_time_digital_user`   | STRING    | Whether user is new to digital services: `'yes'` or `'no'`                  |
| `session_channel`           | STRING    | Channel used for session; always `'voice'`                                  |
| `language`                  | STRING    | Language spoken during session (e.g., `'KINYARWANDA'`)                      |
| `total_duration_sec`        | INT64     | Total duration of the voice session in seconds                              |
| `total_turns`               | INT64     | Number of conversational turns in the session                               |
| `session_outcome`           | STRING    | Final session result: `'completed'`, `'abandoned'`, or `'transferred'`      |
| `transfer_reason`           | STRING    | Reason for transfer to agent (if applicable)                                |
| `session_start_at`          | TIMESTAMP | Timestamp when the session began                                            |
| `avg_asr_confidence`        | FLOAT64   | Average Automatic Speech Recognition confidence score (0.0–1.0)             |
| `avg_intent_confidence`     | FLOAT64   | Average intent classification confidence score (0.0–1.0)                    |
| `misunderstanding_rate`     | FLOAT64   | Proportion of turns with misunderstood user intent                          |
| `silence_rate`              | FLOAT64   | Proportion of turns with excessive silence or no input                      |
| `recovery_success_flag`     | BOOL      | `TRUE` if system successfully recovered from an error                       |
| `escalated_to_agent`        | BOOL      | `TRUE` if session was escalated to a human agent                            |
| `application_id`            | STRING    | ID of linked application (if any)                                           |
| `service_code`              | STRING    | Type of government service requested (e.g., `ID_REPLACEMENT`)               |
| `application_channel`       | STRING    | Channel used to submit application: `'voice'`, `'web'`, `'ussd'`            |
| `application_status`        | STRING    | Status of linked application: `'completed'`, `'abandoned'`, `'failed'`      |
| `time_to_submit_sec`        | INT64     | Seconds from session start to application submission                        |
| `submitted_at`              | TIMESTAMP | Timestamp when the application was submitted                                |
| `is_rural_user`             | BOOL      | Derived flag: `TRUE` if user is from a rural region                         |
| `is_first_time_digital_user`| BOOL      | Derived flag: `TRUE` if user is new to digital services                     |
| `has_disability_flag`       | BOOL      | Derived flag: `TRUE` if user has a reported disability                      |
| `is_session_completed`      | BOOL      | Derived flag: `TRUE` if session ended in `'completed'`                      |
| `is_application_completed`  | BOOL      | Derived flag: `TRUE` if linked application status is `'completed'`          |
| `is_voice_application`      | BOOL      | Derived flag: `TRUE` if application was submitted via voice channel         |