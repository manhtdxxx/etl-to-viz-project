import os
from dotenv import load_dotenv
from sqlalchemy import create_engine
from minio import Minio

load_dotenv()

def get_mysql_engine():
    user = os.getenv("MYSQL_USER", "root")
    password = os.getenv("MYSQL_ROOT_PASSWORD", "")
    database = os.getenv("MYSQL_DATABASE", "accounting_db2")
    host = "mysql-container"
    port = "3306"
    return create_engine(f"mysql+pymysql://{user}:{password}@{host}:{port}/{database}")


def get_minio_client():
    user = os.getenv("MINIO_ROOT_USER", "minio")
    password = os.getenv("MINIO_ROOT_PASSWORD", "")
    host = "minio-container"
    port = "9000"
    return Minio(
        endpoint=f"{host}:{port}",
        access_key=user,
        secret_key=password,
        secure=False  # True for https
    )


def get_pg_engine():
    user = os.getenv("POSTGRES_USER", "postgres")
    password = os.getenv("POSTGRES_PASSWORD", "")
    database = os.getenv("POSTGRES_DB", "accounting_dwh")
    host = "postgres-container"
    port = "5432"
    return create_engine(f"postgresql+psycopg2://{user}:{password}@{host}:{port}/{database}")

