import numpy as np
import pandas as pd
from utils.conn import get_mysql_engine
import logging


logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

engine=get_mysql_engine()


def _extract_table(table_name: str, where_clause: str = None, engine=engine):
    conn = engine.raw_connection()
    try:
        query = f"SELECT * FROM {table_name}"
        if where_clause:
            query += f" WHERE {where_clause}"
        return pd.read_sql(query, conn)
    except Exception as e:
        logger.error(f"Error extracting table '{table_name}': {e}")
        raise
    finally:    
        conn.close()


def extract_raw_dim_account():
    account_df = _extract_table("accounting_account").add_prefix("account_")
    accountType_df = _extract_table("account_type").add_prefix("type_")

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


def extract_raw_fact_entry(year: int, month: int):
    where_clause = f"YEAR(trans_date) = {year} AND MONTH(trans_date) = {month}"

    journalTransaction_df = _extract_table("journal_transaction", where_clause=where_clause)
    journalEntry_df = _extract_table("journal_entry")

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

    # joined_df['transaction_date'] = pd.to_datetime(joined_df['transaction_date'])

    # filtered_df = joined_df[
    #     (joined_df['transaction_date'].dt.year == year) &
    #     (joined_df["transaction_date"].dt.month == month)
    # ]

    # filtered_df['transaction_date'] = filtered_df['transaction_date'].astype(str)

    return joined_df
