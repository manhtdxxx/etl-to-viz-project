from etl.extract import extract_dim_account, extract_fact_entry
from etl.transform import transform_dim_account, transform_fact_entry
from etl.load_to_storage import upload_df_to_minio
from etl.load_from_storage_to_dwh import copy_file_to_dwh
from airflow import DAG
from airflow.operators.python import PythonOperator
from datetime import datetime, timedelta
import pandas as pd
from airflow.utils.log.logging_mixin import LoggingMixin

logger = LoggingMixin().log

def run_etl(**kwargs):
    execution_date = kwargs['logical_date']
    prev_month = execution_date.replace(day=1) - timedelta(days=1)

    # Extract dim_account
    logger.info("Starting extract_dim_account...")
    dim_account = extract_dim_account()
    logger.info(f"Extracted dim_account with {len(dim_account)} rows")

    # Extract fact_entry
    logger.info(f"Starting extract_fact_entry for {prev_month.year}-{prev_month.month}...")
    fact_entry = extract_fact_entry(prev_month.year, prev_month.month)
    logger.info(f"Extracted fact_entry with {len(fact_entry)} rows")

    # Transform dim_account
    logger.info("Starting transform_dim_account...")
    transformed_dim_account = transform_dim_account(dim_account)
    logger.info(f"Transformed dim_account with {len(transformed_dim_account)} rows")

    # Transform fact_entry
    logger.info("Starting transform_fact_entry...")
    transformed_fact_entry = transform_fact_entry(fact_entry, transformed_dim_account)
    logger.info(f"Transformed fact_entry with {len(transformed_fact_entry)} rows")

    # Load dim_account
    logger.info("Uploading dim_account to MinIO...")
    upload_df_to_minio(transformed_dim_account, "dim_account", prev_month.year, prev_month.month)
    logger.info("Uploaded dim_account successfully")

    # Load fact_entry
    logger.info("Uploading fact_entry to MinIO...")
    upload_df_to_minio(transformed_fact_entry, "fact_entry", prev_month.year, prev_month.month)
    logger.info("Uploaded fact_entry successfully")


def load_to_dwh(**kwargs):
    execution_date = kwargs['logical_date']
    prev_month = execution_date.replace(day=1) - timedelta(days=1)

    logger.info("Loading dim_account from MinIO to DWH...")
    copy_file_to_dwh("dim_account", prev_month.year, prev_month.month)
    logger.info("Loaded dim_account to DWH.")

    logger.info("Loading fact_entry from MinIO to DWH...")
    copy_file_to_dwh("fact_entry", prev_month.year, prev_month.month)
    logger.info("Loaded fact_entry to DWH.")


with DAG(dag_id="etl_runner",
         start_date=datetime(2022, 2, 1),
         schedule_interval="0 0 1 * *", # chạy vào lúc 00:00 ngày mùng 1 hàng tháng
         end_date=datetime(2025, 1, 1),
         max_active_runs=1
         ) as dag:

    etl_task = PythonOperator(
        task_id="run_etl",
        python_callable=run_etl,
    )

    load_dwh_task = PythonOperator(
        task_id="copy_file_to_dwh",
        python_callable=load_to_dwh,
    )

    etl_task >> load_dwh_task