# irembo-voice-ai-analytical-engineering
irembo-voice-ai-analytical-engineering Project 


## Prerequisites
- Google Cloud Project with BigQuery enabled
- Service account with BigQuery Admin role
- Python 3.11+

## Setup
1. Clone this repo
2. Create a virtual environment and install dependencies:
   ```bash
   python -m venv venv
   source venv/bin/activate
   pip install -r requirements.txt


3. Download your GCP service account key as gcp-creds.json in the root

4. Create ~/.dbt/profiles.yml:
`irembo_voice_ai:`
  `target: dev`
  `outputs:`
    `dev:`
      `type: bigquery`
      `method: service-account`
      `project: YOUR_PROJECT_ID`
      `dataset: irembo_voice_ai`
      `keyfile: /full/path/to/gcp-creds.json`
      `location: US`


5. Ingest data:
`python ingest_to_bronze.py`


6. Run dbt:
`cd irembo_voice_ai_dbt`
`dbt run`
`dbt test`



### 2. **Include a `requirements.txt`**
Make sure you have one:
google-cloud-bigquery==3.24.0
pandas==2.2.0
requests==2.31.0
dbt-bigquery==1.11.0


Run this once to generate it:
`pip freeze > requirements.txt`
