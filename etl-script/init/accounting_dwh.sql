CREATE TABLE IF NOT EXISTS dim_account (
  account_id VARCHAR(4) PRIMARY KEY,
  account_code VARCHAR(3),
  account_name VARCHAR(128),
  account_normal_balance VARCHAR(32),
  account_subcategory VARCHAR(128),
  account_category VARCHAR(128),
  type_name VARCHAR(32),
  type_normal_balance VARCHAR(32)
);

CREATE TABLE IF NOT EXISTS fact_entry (
  entry_id VARCHAR(7) PRIMARY KEY,
  transaction_id VARCHAR(7),
  account_id VARCHAR(4) REFERENCES dim_account(account_id),
  signed_amount INT,
  transaction_date DATE,
  description VARCHAR(512)
);

CREATE OR REPLACE VIEW full_view AS
SELECT
  fe.entry_id,
  fe.transaction_id,
  fe.account_id,
  fe.signed_amount,
  fe.transaction_date,
  fe.description,
  da.account_code,
  da.account_name,
  da.account_normal_balance,
  da.account_subcategory,
  da.account_category,
  da.type_name,
  da.type_normal_balance
FROM fact_entry fe
JOIN dim_account da ON fe.account_id = da.account_id;
