from etl.extract_mysql_source import extract_raw_dim_account, extract_raw_fact_entry
from etl.minio_handler import upload_df_to_minio, download_df_from_minio
from etl.transform import transform_dim_account, transform_fact_entry
from etl.load_to_dwh import upsert_df_to_dwh
from airflow import DAG
from airflow.operators.python import PythonOperator
from datetime import datetime, timedelta
import pandas as pd
from airflow.utils.log.logging_mixin import LoggingMixin

logger = LoggingMixin().log

def run_extract(**kwargs):
    execution_date = kwargs['logical_date']
    prev_month = execution_date.replace(day=1) - timedelta(days=1)

    # Extract dim_account
    logger.info("Starting extract raw_dim_account...")
    dim_account_raw = extract_raw_dim_account()
    upload_df_to_minio(dim_account_raw, "raw_dim_account", prev_month.year, prev_month.month)
    logger.info("Uploaded raw_dim_account to MinIO")

    # Extract fact_entry
    logger.info(f"Starting extract raw_fact_entry in {prev_month.year}-{prev_month.month}...")
    fact_entry_raw = extract_raw_fact_entry(prev_month.year, prev_month.month)
    upload_df_to_minio(fact_entry_raw, "raw_fact_entry", prev_month.year, prev_month.month)
    logger.info("Uploaded raw_fact_entry to MinIO")


def run_transform_and_load(**kwargs):
    execution_date = kwargs['logical_date']
    prev_month = execution_date.replace(day=1) - timedelta(days=1)

    # Download raw data from MinIO
    logger.info("Downloading raw_dim_account from MinIO...")
    dim_account_raw = download_df_from_minio("raw_dim_account", prev_month.year, prev_month.month)
    logger.info(f"Downloaded raw_dim_account with {len(dim_account_raw)} rows")

    logger.info("Downloading raw_fact_entry from MinIO...")
    fact_entry_raw = download_df_from_minio("raw_fact_entry", prev_month.year, prev_month.month)
    logger.info(f"Downloaded raw_fact_entry with {len(fact_entry_raw)} rows")

    # Transform
    logger.info("Transforming dim_account...")
    dim_account = transform_dim_account(dim_account_raw)
    logger.info(f"Transformed dim_account with {len(dim_account)} rows")

    logger.info("Transforming fact_entry...")
    fact_entry = transform_fact_entry(fact_entry_raw, dim_account)
    logger.info(f"Transformed fact_entry with {len(fact_entry)} rows")

    # Load to DWH
    logger.info("Upserting dim_account to DWH...")
    upsert_df_to_dwh(dim_account, "dim_account")
    logger.info("Upserted dim_account successfully")

    logger.info("Upserting fact_entry to DWH...")
    upsert_df_to_dwh(fact_entry, "fact_entry")
    logger.info("Upserted fact_entry successfully")


with DAG(dag_id="etl_runner",
         start_date=datetime(2022, 2, 1),
         schedule_interval="0 0 1 * *", # chạy vào lúc 00:00 ngày mùng 1 hàng tháng
         end_date=datetime(2025, 1, 1),
         max_active_runs=1
         ) as dag:

    extract_task = PythonOperator(
        task_id="extract_and_upload_to_minio",
        python_callable=run_extract,
    )

    transform_and_load_task = PythonOperator(
        task_id="transform_and_load_to_dwh",
        python_callable=run_transform_and_load,
    )

    extract_task >> transform_and_load_task