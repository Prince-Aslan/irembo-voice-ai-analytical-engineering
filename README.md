# Irembo Voice AI Analytical Engineering

## Project Overview

The **Irembo Voice AI Analytical Engineering** project is designed to provide an end-to-end analytical pipeline for evaluating the impact of the Irembo Voice AI assistant on accessibility, efficiency, and adoption of public services. The project leverages **Python**, **BigQuery**, and **dbt (data build tool)** to ingest raw CSV data, transform it into analysis-ready tables, and generate insights through SQL and optional dashboards.

The project covers the following data sources:
- Users (`users.csv`)
- Voice Sessions (`voice_sessions.csv`)
- Voice Turns (`voice_turns.csv`)
- AI Performance Metrics (`voice_ai_metrics.csv`)
- Service Applications (`applications.csv`)

## Repository Structure

```
irembo-voice-ai-analytical-engineering/
├── .gitignore                      # Excludes secrets & temp files
├── gcp-creds.json                   # BigQuery credentials (do not commit)
├── README.md                        # Setup instructions & project overview
├── ingest_to_bronze.py              # Automated CSV -> BigQuery ingestion
├── requirements.txt                 # Python dependencies
├── irembo_voice_ai_dbt/             # dbt project root
│   ├── dbt_project.yml              # dbt project configuration
│   ├── models/
│   │   ├── bronze/
│   │   │   └── sources.yml          # Raw tables defined as sources
│   │   ├── silver/
│   │   │   ├── stg_voice_sessions.sql
│   │   │   ├── stg_voice_turns.sql
│   │   │   ├── stg_voice_ai_metrics.sql
│   │   │   ├── stg_applications.sql
│   │   │   ├── stg_users.sql
│   │   │   └── schema.yml           # Data quality tests for silver tables
│   │   └── gold/
│   │       ├── fact_voice_ai_sessions.sql
│   │       └── schema.yml           # Analysis-ready table with DQ tests & PII-safe descriptions
│   └── target/                       # dbt-generated artifacts (compiled SQL, run metadata)
└── docs/
    ├── dashboard_mockup.png         # Optional dashboard mockup
    ├── part_3-SQL_Analysis.md       # SQL analysis for Part 3 insights
    └── data_type.md                 # Data dictionary & field descriptions
```

## Setup Instructions

### 1. Clone the Repository

```bash
git clone https://github.com/your-username/irembo-voice-ai-analytical-engineering.git
cd irembo-voice-ai-analytical-engineering
```

### 2. Python Environment Setup

It is recommended to use a virtual environment:

```bash
python -m venv venv
source venv/bin/activate  # Linux/macOS
venv\Scripts\activate     # Windows
```

Install dependencies:

```bash
pip install -r requirements.txt
```

### 3. Configure BigQuery Credentials

1. Place your **GCP service account JSON** credentials in the project root (`gcp-creds.json`).
2. Set the environment variable:

```bash
export GOOGLE_APPLICATION_CREDENTIALS="$(pwd)/gcp-creds.json"  # Linux/macOS
set GOOGLE_APPLICATION_CREDENTIALS=%cd%\gcp-creds.json      # Windows
```

### 4. Ingest Data to BigQuery

Run the ingestion script to upload CSVs to your BigQuery project:

```bash
python ingest_to_bronze.py
```

This will populate the raw (bronze) tables in your configured BigQuery dataset.

### 5. dbt Transformations

Navigate to the dbt project:

```bash
cd irembo_voice_ai_dbt
```

Run dbt models:

```bash
# Compile SQL and build silver & gold tables
dbt run

# Run data quality tests
dbt test

# Optional: Generate documentation
dbt docs generate
```

You can view dbt docs locally by serving the documentation:

```bash
dbt docs serve
```

### 6. SQL Analysis

Use the `docs/part_3-SQL_Analysis.md` file for ready-to-run queries that generate insights on:
- Voice AI effectiveness
- Completion rates by channel & user segments
- Friction points for users

### 7. Optional Dashboard

If you choose to visualize results, use the `docs/dashboard_mockup.png` as a reference for KPI tiles, funnels, and the Cognitive Load Score.

## Notes

- **Do not commit** sensitive files like `gcp-creds.json`. The `.gitignore` is already configured.
- dbt `target/` folder is auto-generated and should not be version controlled.
- All analysis-ready outputs (gold tables) are PII-safe and include anonymized identifiers.



