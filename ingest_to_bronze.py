"""
Irembo Voice AI: Automated Ingestion from Google Drive → BigQuery (Bronze Layer)
- Downloads 5 CSVs using direct-download URLs
- Loads to BigQuery with WRITE_TRUNCATE (no duplicates)
- Handles empty users.csv gracefully
- Includes full error logging for debugging
"""

import pandas as pd
from google.cloud import bigquery
from io import StringIO
import requests
import sys
from google.oauth2 import service_account


# MY GCP project ID
PROJECT_ID = "irembo-voice-ai"
DATASET_ID = "irembo_voice_ai"
CREDENTIALS_PATH = "gcp-creds.json"

FILES = {
    "voice_sessions": "https://drive.google.com/uc?export=download&id=1HuKRaRUjG30XTJ3Blx6WNDcvz-juGSHA",
    "voice_turns": "https://drive.google.com/uc?export=download&id=17mH-Zmd_bF_dOhJgFdXVzqIQjp0V2qSz",
    "voice_ai_metrics": "https://drive.google.com/uc?export=download&id=1_Ph5Bz4NcvyY24j3WYGqOgoLBBZ_EgMP",
    "applications": "https://drive.google.com/uc?export=download&id=1-vVMOqyk5VJTsxP39maBJHYZUAYx0byw",
    "users": "https://drive.google.com/uc?export=download&id=1BW-kZpttNmqFTAtrJVrujHXKQP72Nnr_"
}

def download_csv(url: str) -> pd.DataFrame:
    """Download CSV from URL and return DataFrame."""
    print(f"Downloading from: {url}")
    try:
        response = requests.get(url, timeout=30)
        response.raise_for_status()
        df = pd.read_csv(StringIO(response.text))
        print(f"Downloaded {len(df)} rows")
        return df
    except Exception as e:
        print(f"FAILED to download {url}: {e}")
        sys.exit(1)

def load_to_bigquery(df: pd.DataFrame, table_name: str):
    """Load DataFrame to BigQuery bronze table."""
    print(f"Loading {table_name} ({len(df)} rows) to BigQuery...")
    try:
        credentials = service_account.Credentials.from_service_account_file(
            CREDENTIALS_PATH,
            scopes=["https://www.googleapis.com/auth/cloud-platform"]
        )
        client = bigquery.Client(project=PROJECT_ID, credentials=credentials)
        
        table_id = f"{PROJECT_ID}.{DATASET_ID}.bronze_{table_name}"
        job_config = bigquery.LoadJobConfig(
            write_disposition="WRITE_TRUNCATE",
            autodetect=True,
        )
        
        job = client.load_table_from_dataframe(df, table_id, job_config=job_config)
        job.result()  # Wait for completion
        print(f"SUCCESS: Loaded {table_id}")
    except Exception as e:
        print(f"FAILED to load {table_name}: {e}")
        sys.exit(1)

def main():
    print("STARTING IREMBRO VOICE AI INGESTION PIPELINE\n")
    
    for name, url in FILES.items():
        print(f"\n--- Processing {name.upper()} ---")
        df = download_csv(url)

        # Handle empty users.csv
        if name == "users" and df.empty:
            print("users.csv is empty. Creating empty schema.")
            df = pd.DataFrame(columns=["user_id", "region", "disability_flag", "first_time_digital_user"])

        load_to_bigquery(df, name)

    print("\n ALL TABLES LOADED SUCCESSFULLY!")

if __name__ == "__main__":
    main()