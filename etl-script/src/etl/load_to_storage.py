from minio import Minio
import os
from dotenv import load_dotenv
from io import BytesIO, StringIO
import pandas as pd

load_dotenv()

user = os.getenv("MINIO_ROOT_USER", "minio")
password = os.getenv("MINIO_ROOT_PASSWORD", "")
host = "minio-container"
port = "9000"


def _get_client(user=user, password=password, host=host, port=port):
    return Minio(
        endpoint=f"{host}:{port}",
        access_key=user,
        secret_key=password,
        secure=False  # True for https
    )


def _convert_df_to_bytes(df: pd.DataFrame, file_format="parquet"):
    buffer = BytesIO()

    if file_format == "parquet":
        df.to_parquet(buffer, index=False)
        content_type = "application/parquet"

    elif file_format == "csv":
        df.to_csv(buffer, index=False, encoding="utf-8")
        content_type = "text/csv"

    elif file_format == "json":
        df.to_json(buffer, orient="records", lines=True, force_ascii=False)  # giữ UTF-8
        content_type = "application/json"

    else:
        raise ValueError("Unsupported format. Use 'parquet', 'csv', or 'json'.")

    buffer.seek(0)
    return buffer, content_type



def _upload_bytes_to_minio(object_name: str, buffer: BytesIO, content_type: str, bucket_name: str, client: Minio):
    if not client.bucket_exists(bucket_name):
        client.make_bucket(bucket_name)

    client.put_object(
        bucket_name=bucket_name,
        object_name=object_name,
        data=buffer,
        length=buffer.getbuffer().nbytes,
        content_type=content_type
    )

    print(f"Uploaded to MinIO: {bucket_name}/{object_name}")


def upload_df_to_minio(df: pd.DataFrame, object_name: str, year: int, month: int, file_format = "parquet"):
    if df.empty:
        print("Warning: DataFrame is empty. Skipping upload.")
        return
    
    client = _get_client()
    buffer, content_type = _convert_df_to_bytes(df, file_format)
    bucket_name = f"storage-{str(year)}"

    if object_name == "dim_account":
        object_name = f"{object_name}-{year}-{int(month):02d}.{file_format}"
        _upload_bytes_to_minio(object_name, buffer, content_type, bucket_name, client)

    elif object_name == "fact_entry":
        object_name = f"{object_name}-{year}-{int(month):02d}.{file_format}"
        _upload_bytes_to_minio(object_name, buffer, content_type, bucket_name, client)

    else:
        raise ValueError("Unsupported object_name. Use 'dim_account' or 'fact_entry'.")