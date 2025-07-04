import time
import socket
from minio import Minio
from minio.error import S3Error

MINIO_HOST = "minio-container"
MINIO_PORT = 9000
ACCESS_KEY = "minio"
SECRET_KEY = "12345678"


def wait_for_minio(host, port, timeout=60):
    start_time = time.time()
    while True:
        try:
            with socket.create_connection((host, port), timeout=2):
                print(f"MinIO is available at {host}:{port}")
                return
        except OSError:
            elapsed = time.time() - start_time
            if elapsed > timeout:
                raise TimeoutError(f"Timed out waiting for MinIO at {host}:{port}")
            print(f"Waiting for MinIO at {host}:{port}...")
            time.sleep(2)

wait_for_minio(MINIO_HOST, MINIO_PORT)


client = Minio(
    f"{MINIO_HOST}:{MINIO_PORT}",
    access_key=ACCESS_KEY,
    secret_key=SECRET_KEY,
    secure=False  # not use https, use http
)


buckets = ["storage-2022", "storage-2023", "storage-2024"]  # not allow for _
for bucket in buckets:
    try:
        if not client.bucket_exists(bucket_name=bucket):
            client.make_bucket(bucket_name=bucket)
            print(f"Bucket '{bucket}' created successfully.")
        else:
            print(f"Bucket '{bucket}' already exists.")
    except S3Error as e:
        print(f"Error creating bucket '{bucket}': {e}")
