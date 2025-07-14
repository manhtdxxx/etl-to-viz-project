from minio import Minio
from io import BytesIO, StringIO
import pandas as pd
from utils.conn import get_minio_client
import logging


logging.basicConfig(level=logging.ERROR)
logger = logging.getLogger(__name__)


def _convert_df_to_bytes(df: pd.DataFrame, file_format="parquet"):
    buffer = BytesIO()
    try:
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
    
    except Exception as e:
        logger.error(f"Failed to convert DataFrame to {file_format}: {e}")
        raise


def _upload_bytes_to_minio(object_name: str, buffer: BytesIO, content_type: str, bucket_name: str, client: Minio):
    try:
        if not client.bucket_exists(bucket_name):
            client.make_bucket(bucket_name)

        client.put_object(
            bucket_name=bucket_name,
            object_name=object_name,
            data=buffer,
            length=buffer.getbuffer().nbytes,
            content_type=content_type
        )
    except Exception as e:
        logger.error(f"Failed to upload {object_name} to MinIO bucket {bucket_name}: {e}")
        raise


def _format_object_name(object_name: str, year: int, month: int, file_format: str) -> str:
    if object_name not in {"raw_dim_account", "raw_fact_entry"}:
        raise ValueError("Unsupported object_name. Use 'raw_dim_account' or 'raw_fact_entry'.")
    return f"{object_name}-{year}-{int(month):02d}.{file_format}"


def upload_df_to_minio(df: pd.DataFrame, object_name: str, year: int, month: int, file_format = "parquet"):
    if df.empty:
        logger.warning("DataFrame is empty. Skipping upload.")
        return
    
    client = get_minio_client()
    buffer, content_type = _convert_df_to_bytes(df, file_format)
    bucket_name = f"bucket-{str(year)}"
    object_file = _format_object_name(object_name, year, month, file_format)

    _upload_bytes_to_minio(object_file, buffer, content_type, bucket_name, client)


def download_df_from_minio(object_name: str, year: int, month: int, file_format="parquet"):
    client = get_minio_client()
    bucket_name = f"bucket-{str(year)}"
    object_file = _format_object_name(object_name, year, month, file_format)

    try:
        response = client.get_object(bucket_name=bucket_name, object_name=object_file)
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

        return df
    
    except Exception as e:
        logger.error(f"Failed to download or parse {object_name} from bucket {bucket_name} as {file_format}: {e}")
        raise

    finally:
        response.close()
        response.release_conn()
