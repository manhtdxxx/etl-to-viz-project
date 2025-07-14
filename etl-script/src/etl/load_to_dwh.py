import pandas as pd
import datetime
from io import BytesIO
from minio import Minio
from sqlalchemy import text, MetaData, Table
from utils.conn import get_pg_engine
import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


def _get_postgres_dtype(series: pd.Series) -> str:
    if pd.api.types.is_integer_dtype(series):
        return "BIGINT"
    elif pd.api.types.is_float_dtype(series):
        return "DOUBLE PRECISION"
    elif pd.api.types.is_bool_dtype(series):
        return "BOOLEAN"
    elif pd.api.types.is_datetime64_any_dtype(series):
        return "TIMESTAMP"
    elif series.dtype == 'object' and all(isinstance(val, datetime.date) for val in series.dropna()):
        return "DATE"
    else:
        return "TEXT"


def _get_primary_keys(table_name: str, engine) -> list:
    try:
        metadata = MetaData()
        metadata.reflect(bind=engine, only=[table_name])
        table = metadata.tables.get(table_name)
        if table is None:
            raise ValueError(f"Table '{table_name}' not found in metadata.")
        return [col.name for col in table.primary_key.columns]
    except Exception as e:
        logger.error(f"Failed to get primary keys for table '{table_name}': {e}")
        raise


def _create_staging_table(cursor, staging_table: str, df: pd.DataFrame):
    try:
        columns = [(col, _get_postgres_dtype(df[col])) for col in df.columns]
        table_schema = ', '.join([f'"{col}" {dtype}' for col, dtype in columns])
        cursor.execute(f"""
            DROP TABLE IF EXISTS {staging_table};
            CREATE TEMP TABLE {staging_table} ({table_schema}) ON COMMIT DROP;
        """)
    except Exception as e:
        logger.error(f"Failed to create staging table '{staging_table}': {e}")
        raise


def _copy_df_to_staging(cursor, staging_table: str, df: pd.DataFrame):
    try:
        buffer = BytesIO()
        df.to_csv(buffer, index=False, header=False)
        buffer.seek(0)
        cursor.copy_expert(
            f"COPY {staging_table} ({', '.join(df.columns)}) FROM STDIN WITH (FORMAT CSV)",
            buffer
        )
    except Exception as e:
        logger.error(f"Failed to copy DataFrame to staging table '{staging_table}': {e}")
        raise


def _upsert_from_staging(cursor, table_name: str, staging_table: str, df: pd.DataFrame, engine):
    try:
        all_cols = list(df.columns)
        pk_cols = _get_primary_keys(table_name, engine)
        update_cols = [col for col in all_cols if col not in pk_cols]

        if not pk_cols:
            raise ValueError(f"No primary key found for table '{table_name}' — cannot upsert.")

        update_clause = ', '.join([f'"{col}" = EXCLUDED."{col}"' for col in update_cols])
        all_cols_clause = ', '.join([f'"{col}"' for col in all_cols])
        pk_clause = ', '.join([f'"{col}"' for col in pk_cols])

        cursor.execute(f"""
            INSERT INTO {table_name} ({all_cols_clause})
            SELECT {all_cols_clause} FROM {staging_table}
            ON CONFLICT ({pk_clause}) DO UPDATE
            SET {update_clause};
        """)
        logger.info(f"Upserted data into table {table_name}")

    except Exception as e:
        logger.error(f"Failed to upsert from staging to table '{table_name}': {e}")
        raise
    

def upsert_df_to_dwh(df: pd.DataFrame, table_name: str):
    if df.empty:
        logger.warning("DataFrame is empty. Skipping upsert.")
        return

    engine = get_pg_engine()
    staging_table = f"staging_{table_name}"

    with engine.begin() as conn:
        with conn.connection.cursor() as cursor:
            _create_staging_table(cursor, staging_table, df)
            _copy_df_to_staging(cursor, staging_table, df)
            _upsert_from_staging(cursor, table_name, staging_table, df, engine)
            
    logger.info(f"Successfully completed upsert into '{table_name}'")
