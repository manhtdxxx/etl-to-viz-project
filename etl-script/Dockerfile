FROM apache/airflow:2.3.0-python3.10

USER airflow

WORKDIR /opt/airflow

# Copy requirements and install Python dependencies
COPY requirements.txt .

RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt