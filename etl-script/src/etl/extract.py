import os
from dotenv import load_dotenv
import numpy as np
import pandas as pd
from sqlalchemy import create_engine

load_dotenv()

user = os.getenv("MYSQL_USER", "root")
password = os.getenv("MYSQL_ROOT_PASSWORD", "")
database = os.getenv("MYSQL_DATABASE", "accounting_db2")
host = "mysql-container"
# host = "localhost"
port = "3306"

engine=create_engine(f"mysql+pymysql://{user}:{password}@{host}:{port}/{database}")


def extract_table(table_name: str, engine=engine):
    conn = engine.raw_connection()
    try:
        return pd.read_sql(f"SELECT * FROM {table_name}", conn)
    finally:
        conn.close()


def extract_dim_account():
    account_df = extract_table("accounting_account").add_prefix("account_")
    accountType_df = extract_table("account_type").add_prefix("type_")

    joined_df = pd.merge(
        account_df,
        accountType_df,
        how="inner",
        left_on="account_acctype_id",
        right_on="type_acctype_id"
    )

    joined_df.drop(['type_acctype_id'], axis=1, inplace=True)

    joined_df.rename(columns={
        'account_acc_id': 'account_id',
        'account_acctype_id': 'type_id',
    }, inplace=True)

    return joined_df


def extract_fact_entry(year: int, month: int):
    journalTransaction_df = extract_table("journal_transaction")
    journalEntry_df = extract_table("journal_entry")

    joined_df = pd.merge(
        journalEntry_df, 
        journalTransaction_df, 
        how="inner", 
        on="trans_id"
    )

    joined_df.drop(["journal_id", "period_id", "supplier_id", "customer_id"], axis=1, inplace=True)

    joined_df.rename(columns={
        'trans_id': 'transaction_id',
        'acc_id': 'account_id',
        'trans_date': 'transaction_date',
    }, inplace=True)

    joined_df['transaction_date'] = pd.to_datetime(joined_df['transaction_date'])

    filtered_df = joined_df[
        (joined_df['transaction_date'].dt.year == year) &
        (joined_df["transaction_date"].dt.month == month)
    ]

    # filtered_df['transaction_date'] = filtered_df['transaction_date'].astype(str)

    return filtered_df
