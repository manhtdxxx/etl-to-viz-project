import os
from dotenv import load_dotenv
import pandas as pd
from io import BytesIO
from minio import Minio
from sqlalchemy import create_engine, text, MetaData, Table

load_dotenv()

minio_user = os.getenv("MINIO_ROOT_USER", "minio")
minio_password = os.getenv("MINIO_ROOT_PASSWORD", "")
minio_host = "minio-container"
minio_port = "9000"

pg_user = os.getenv("POSTGRES_USER", "postgres")
pg_password = os.getenv("POSTGRES_PASSWORD", "")
pg_database = os.getenv("POSTGRES_DB", "accounting_dwh")
pg_host = "postgres-container"
pg_port = "5432"

def _get_minio_client(user=minio_user, password=minio_password, host=minio_host, port=minio_port):
    return Minio(
        endpoint=f"{host}:{port}",
        access_key=user,
        secret_key=password,
        secure=False
    )

def _get_pg_engine(user=pg_user, password=pg_password, host=pg_host, port=pg_port, database=pg_database):
    url = f"postgresql+psycopg2://{user}:{password}@{host}:{port}/{database}"
    return create_engine(url)


def _download_parquet_from_minio(client: Minio, bucket_name: str, object_name: str, file_format="parquet"):
    response = client.get_object(bucket_name=bucket_name, object_name=object_name)
    data = response.read()
    buffer = BytesIO(data)

    if file_format == "parquet":
        df = pd.read_parquet(buffer)
    elif file_format == "csv":
        df = pd.read_csv(buffer)
    elif file_format == "json":
        df = pd.read_json(buffer, orient="records", lines=True)
    else:
        raise ValueError("Unsupported format. Use 'parquet', 'csv', or 'json'.")

    response.close()
    response.release_conn()
    return df


def _get_postgres_type(series: pd.Series):
    if pd.api.types.is_integer_dtype(series):
        return "BIGINT"
    elif pd.api.types.is_float_dtype(series):
        return "DOUBLE PRECISION"
    elif pd.api.types.is_bool_dtype(series):
        return "BOOLEAN"
    elif pd.api.types.is_datetime64_any_dtype(series):
        return "TIMESTAMP"
    else:
        return "TEXT"


def _get_primary_keys(table_name, engine):
    metadata = MetaData()
    metadata.reflect(bind=engine, only=[table_name])
    table = metadata.tables.get(table_name)
    if table is None:
        raise ValueError(f"Table '{table_name}' not found in metadata.")
    return [col.name for col in table.primary_key.columns]

def _create_staging_table(cursor, staging_table: str, df: pd.DataFrame):
    columns = [(col, _get_postgres_type(df[col])) for col in df.columns]
    table_schema = ', '.join([f'"{col_name}" {dtype}' for col_name, dtype in columns])
    cursor.execute(f"""
        DROP TABLE IF EXISTS {staging_table};
        CREATE TEMP TABLE {staging_table} ({table_schema}) ON COMMIT DROP;
    """)

def _copy_df_to_staging(cursor, staging_table: str, df: pd.DataFrame):
    buffer = BytesIO()
    df.to_csv(buffer, index=False, header=False)  # WRITE DF TO CSV (IN RAM)
    buffer.seek(0)
    cursor.copy_expert(
        f"COPY {staging_table} ({', '.join(df.columns)}) FROM STDIN WITH (FORMAT CSV)",  # COPY FROM RAM TO TABLE
        buffer
    )

def _upsert_from_staging(cursor, table_name: str, staging_table: str, df: pd.DataFrame, engine):
    list_all_cols = list(df.columns)
    list_pk_cols = _get_primary_keys(table_name, engine)
    list_update_cols = [col for col in list_all_cols if col not in list_pk_cols]

    update_clause = ', '.join([f'"{col}" = EXCLUDED."{col}"' for col in list_update_cols])
    all_cols_clause = ', '.join([f'"{col}"' for col in list_all_cols])
    pk_cols_clause = ', '.join([f'"{col}"' for col in list_pk_cols])

    cursor.execute(f"""
        INSERT INTO {table_name} ({all_cols_clause})
        SELECT {all_cols_clause} FROM {staging_table}
        ON CONFLICT ({pk_cols_clause}) DO UPDATE
        SET {update_clause};
    """)
    

def _upsert_df_to_dwh(df: pd.DataFrame, table_name: str, engine):
    if df.empty:
        print("DataFrame is empty, skipping upsert.")
        return

    staging_table = f"staging_{table_name}"

    with engine.begin() as conn:
        with conn.connection.cursor() as cursor:
            _create_staging_table(cursor, staging_table, df)
            _copy_df_to_staging(cursor, staging_table, df)
            _upsert_from_staging(cursor, table_name, staging_table, df, engine)


def copy_file_to_dwh(table_name: str, year: int, month: int, file_format="parquet"):
    client = _get_minio_client()
    engine = _get_pg_engine()

    bucket_name = f"storage-{year}"
    object_name = f"{table_name}-{year}-{int(month):02d}.{file_format}"

    print(f"Downloading {bucket_name}/{object_name} from MinIO...")
    df = _download_parquet_from_minio(client, bucket_name, object_name)

    if "transaction_date" in df.columns:
        df["transaction_date"] = pd.to_datetime(df["transaction_date"])

    print(f"Upserting to PostgreSQL table {table_name}...")
    _upsert_df_to_dwh(df, table_name, engine)