START TRANSACTION;

-- Set variables for June 2024 transactions (using literals instead of variables)
-- Note: Since we can't use SET VARIABLE, I'll use literals directly in the queries

-- 1. Capital mobilization and fixed asset investment (only in January, so skipping for June)

-- 2. Business operations
-- 2.1 Purchasing activities
-- Transaction 1: Purchase materials with cash and tax
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id, supplier_id) 
VALUES (2406001, '2024-06-05', 'Mua nguyên vật liệu bằng tiền mặt', 2, 3, 5);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount)
VALUES 
(2406001, 2406001, '152A', 150000000, NULL),
(2406002, 2406001, '133A', 15000000, NULL),
(2406003, 2406001, '111A', NULL, 165000000);

-- Transaction 2: Purchase tools on credit
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id, supplier_id) 
VALUES (2406002, '2024-06-07', 'Mua công cụ dụng cụ trả chậm', 2, 3, 8);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount)
VALUES 
(2406004, 2406002, '153A', 80000000, NULL),
(2406005, 2406002, '133A', 8000000, NULL),
(2406006, 2406002, '331A', NULL, 88000000);

-- 2.2 Production activities
-- Transaction 3: Issue materials to production
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id) 
VALUES (2406003, '2024-06-10', 'Xuất kho nguyên vật liệu sản xuất', 5, 3);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount)
VALUES 
(2406007, 2406003, 'A621', 142500000, NULL), -- 95% of 150M materials
(2406008, 2406003, '152A', NULL, 142500000);

-- Transaction 4: Issue tools to production
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id) 
VALUES (2406004, '2024-06-10', 'Xuất kho công cụ dụng cụ sản xuất', 5, 3);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount)
VALUES 
(2406009, 2406004, 'A627', 68000000, NULL), -- 85% of 80M tools
(2406010, 2406004, '153A', NULL, 68000000);

-- Transaction 5: Depreciation of fixed assets (3% of 3.5B)
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id) 
VALUES (2406005, '2024-06-15', 'Trích khấu hao TSCĐ', 5, 3);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount)
VALUES 
(2406011, 2406005, 'A627', 105000000, NULL), -- 3% of 3.5B
(2406012, 2406005, '214B', NULL, 105000000 -9950000);  -- FIX

-- Transaction 6: Payroll expenses (2x depreciation)
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id) 
VALUES (2406006, '2024-06-15', 'Tính lương nhân viên', 5, 3);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount)
VALUES 
(2406013, 2406006, 'A622', 210000000, NULL),
(2406014, 2406006, '334A', NULL, 210000000);

-- 2.3 Finished goods
-- Transaction 7: Transfer production costs to WIP
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id) 
VALUES (2406007, '2024-06-20', 'Kết chuyển chi phí sản xuất', 5, 3);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount)
VALUES 
(2406015, 2406007, '154A', 142500000, NULL), -- Direct materials
(2406016, 2406007, '154A', 210000000, NULL), -- Labor
(2406017, 2406007, '154A', 173000000, NULL), -- Overhead (tools + depreciation)
(2406018, 2406007, 'A621', NULL, 142500000),
(2406019, 2406007, 'A622', NULL, 210000000),
(2406020, 2406007, 'A627', NULL, 173000000);

-- Transaction 8: Transfer WIP to finished goods
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id) 
VALUES (2406008, '2024-06-21', 'Nhập kho thành phẩm', 5, 3);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount)
VALUES 
(2406021, 2406008, '155A', 525500000, NULL), -- Total production cost
(2406022, 2406008, '154A', NULL, 525500000);

-- 2.4 Sales activities (COGS)
-- Transaction 9: Record COGS (90% of finished goods)
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id, customer_id) 
VALUES (2406009, '2024-06-22', 'Xuất kho bán hàng - ghi nhận giá vốn', 1, 3, 12);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount)
VALUES 
(2406023, 2406009, 'A632', 472950000, NULL), -- 90% of 525.5M
(2406024, 2406009, '155A', NULL, 472950000);

-- 2.5 Sales activities (Revenue)
-- Transaction 10: Record sales revenue (2x COGS)
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id, customer_id) 
VALUES (2406010, '2024-06-22', 'Bán hàng - ghi nhận doanh thu', 1, 3, 12);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount)
VALUES 
(2406025, 2406010, '112A', 1035000000, NULL), -- 2.19x COGS (1.035B)
(2406026, 2406010, 'A511', NULL, 900000000),
(2406027, 2406010, '333A', NULL, 135000000); -- 15% VAT

-- Transaction 11: Sales discounts
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id, customer_id) 
VALUES (2406011, '2024-06-23', 'Giảm trừ doanh thu', 1, 3, 12);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount)
VALUES 
(2406028, 2406011, 'A521', 50000000, NULL),
(2406029, 2406011, '112A', NULL, 50000000);

-- 2.6 Sales and administrative expenses
-- Transaction 12: Selling expenses (15% of revenue)
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id) 
VALUES (2406012, '2024-06-25', 'Chi phí bán hàng', 5, 3);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount)
VALUES 
(2406030, 2406012, 'A641', 127500000, NULL), -- 15% of 850M net revenue
(2406031, 2406012, '111A', NULL, 127500000);

-- Transaction 13: Administrative expenses (15% of revenue)
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id) 
VALUES (2406013, '2024-06-25', 'Chi phí quản lý doanh nghiệp', 5, 3);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount)
VALUES 
(2406032, 2406013, 'A642', 127500000, NULL), -- 15% of 850M net revenue
(2406033, 2406013, '111A', NULL, 127500000);

-- 3. Financial activities
-- 3.1 Investment in securities
-- Transaction 14: Buy short-term securities
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id) 
VALUES (2406014, '2024-06-10', 'Mua chứng khoán ngắn hạn', 5, 3);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount)
VALUES 
(2406034, 2406014, '121A', 200000000, NULL),
(2406035, 2406014, '112A', NULL, 200000000);

-- 3.2 Sell securities (less than bought) with profit
-- Transaction 15: Sell short-term securities
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id) 
VALUES (2406015, '2024-06-18', 'Bán chứng khoán ngắn hạn', 5, 3);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount)
VALUES 
(2406036, 2406015, '112A', 110000000, NULL), -- Sold 100M worth for 110M
(2406037, 2406015, '121A', NULL, 100000000),
(2406038, 2406015, 'B515', NULL, 10000000);

-- 3.3 Pay loan interest (7% of total loans: 600M short + 1.4B long = 2B total)
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id) 
VALUES (2406016, '2024-06-20', 'Trả lãi vay ngân hàng', 9, 3);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount)
VALUES 
(2406039, 2406016, 'B635', 140000000, NULL), -- 7% of 2B
(2406040, 2406016, '112A', NULL, 140000000);

-- 3.4 Receive investment income (slightly higher than interest paid)
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id) 
VALUES (2406017, '2024-06-25', 'Nhận lãi đầu tư', 5, 3);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount)
VALUES 
(2406041, 2406017, '112A', 150000000, NULL),
(2406042, 2406017, 'B515', NULL, 150000000);

-- 4. Other activities
-- 4.1 Other expenses
-- Transaction 18: Penalty expense
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id) 
VALUES (2406018, '2024-06-28', 'Phạt vi phạm hợp đồng', 5, 3);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount)
VALUES 
(2406043, 2406018, 'C811', 30000000, NULL),
(2406044, 2406018, '112A', NULL, 30000000);

-- 4.2 Other income (1% of fixed assets)
-- Transaction 19: Sell fixed assets
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id) 
VALUES (2406019, '2024-06-29', 'Bán TSCĐ', 5, 3);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount)
VALUES 
(2406045, 2406019, '112A', 35000000, NULL), -- 1% of 3.5B
(2406046, 2406019, '211B', NULL, 30000000),
(2406047, 2406019, '214B', NULL, 5000000),
(2406048, 2406019, 'C711', NULL, 10000000); -- Gain of 10M

-- 5. Month-end closing entries
-- 5.1 Transfer all expenses to 911
-- Transaction 20: Close expense accounts
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id) 
VALUES (2406020, '2024-06-30', 'Kết chuyển chi phí', 5, 3);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount)
VALUES 
(2406049, 2406020, 'D911', 472950000, NULL), -- COGS
(2406050, 2406020, 'D911', 127500000, NULL), -- Selling expense
(2406051, 2406020, 'D911', 127500000, NULL), -- Admin expense
(2406052, 2406020, 'D911', 140000000, NULL), -- Financial expense
(2406053, 2406020, 'D911', 30000000, NULL),  -- Other expense
(2406054, 2406020, 'D911', 50000000, NULL),  -- Sales discounts
(2406055, 2406020, 'A632', NULL, 472950000),
(2406056, 2406020, 'A641', NULL, 127500000),
(2406057, 2406020, 'A642', NULL, 127500000),
(2406058, 2406020, 'B635', NULL, 140000000),
(2406059, 2406020, 'C811', NULL, 30000000),
(2406060, 2406020, 'A521', NULL, 50000000);

-- 5.2 Transfer all revenues to 911
-- Transaction 21: Close revenue accounts
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id) 
VALUES (2406021, '2024-06-30', 'Kết chuyển doanh thu', 5, 3);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount)
VALUES 
(2406061, 2406021, 'A511', 900000000, NULL),
(2406062, 2406021, 'B515', 160000000, NULL), -- 10M + 150M
(2406063, 2406021, 'C711', 10000000, NULL),
(2406064, 2406021, 'D911', NULL, 900000000),
(2406065, 2406021, 'D911', NULL, 160000000),
(2406066, 2406021, 'D911', NULL, 10000000);

-- Calculate profit before tax: Revenue (1.07B) - Expense (0.948B) = 122M
-- 5.3 Income tax expense (20%)
-- Transaction 22: Record income tax
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id) 
VALUES (2406022, '2024-06-30', 'Tính thuế TNDN', 8, 3);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount)
VALUES 
(2406067, 2406022, 'C821', 24400000, NULL), -- 20% of 122M
(2406068, 2406022, '333A', NULL, 24400000);

-- 5.4 Close income tax to 911
-- Transaction 23: Close income tax
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id) 
VALUES (2406023, '2024-06-30', 'Kết chuyển thuế TNDN', 5, 3);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount)
VALUES 
(2406069, 2406023, 'D911', 24400000, NULL),
(2406070, 2406023, 'C821', NULL, 24400000);

-- 5.5 Transfer net profit to retained earnings (122M - 24.4M = 97.6M)
-- Transaction 24: Close net profit
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id) 
VALUES (2406024, '2024-06-30', 'Kết chuyển lợi nhuận', 5, 3);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount)
VALUES 
(2406071, 2406024, 'D911', 97600000, NULL),
(2406072, 2406024, '421B', NULL, 97600000);

-- 6. Cash flow activities
-- 6.1 Pay dividends (15% of profit)
-- Transaction 25: Pay dividends
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id) 
VALUES (2406025, '2024-06-30', 'Chi trả cổ tức', 4, 3);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount)
VALUES 
(2406073, 2406025, '421B', 14640000, NULL), -- 15% of 97.6M
(2406074, 2406025, '112A', NULL, 14640000);

-- 6.2 Collect receivables (80% of AR)
-- Transaction 26: Collect from customers
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id, customer_id) 
VALUES (2406026, '2024-06-30', 'Thu tiền khách hàng', 3, 3, 12);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount)
VALUES 
(2406075, 2406026, '112A', 800000000, NULL), -- Assuming 1B AR, collect 80%
(2406076, 2406026, '131A', NULL, 800000000);

-- 6.3 Pay suppliers (85% of AP)
-- Transaction 27: Pay suppliers
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id, supplier_id) 
VALUES (2406027, '2024-06-30', 'Trả tiền nhà cung cấp', 4, 3, 8);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount)
VALUES 
(2406077, 2406027, '331A', 74800000, NULL), -- 85% of 88M
(2406078, 2406027, '112A', NULL, 74800000);

-- 6.4 Pay taxes (90% of tax payable)
-- Transaction 28: Pay taxes
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id) 
VALUES (2406028, '2024-06-30', 'Nộp thuế TNDN', 4, 3);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount)
VALUES 
(2406079, 2406028, '333A', 21960000, NULL), -- 90% of 24.4M
(2406080, 2406028, '112A', NULL, 21960000);

-- 6.5 Pay salaries (90% of salary payable)
-- Transaction 29: Pay salaries
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id) 
VALUES (2406029, '2024-06-30', 'Trả lương nhân viên', 4, 3);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount)
VALUES 
(2406081, 2406029, '334A', 189000000, NULL), -- 90% of 210M
(2406082, 2406029, '112A', NULL, 189000000);

-- 6.6 Pay short-term loan principal (12% of 600M)
-- Transaction 30: Pay short-term loan
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id) 
VALUES (2406030, '2024-06-30', 'Trả nợ gốc vay ngắn hạn', 4, 3);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount)
VALUES 
(2406083, 2406030, '341A', 72000000, NULL), -- 12% of 600M
(2406084, 2406030, '112A', NULL, 72000000);

-- 6.7 Pay long-term loan principal (6% of 1.4B)
-- Transaction 31: Pay long-term loan
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id) 
VALUES (2406031, '2024-06-30', 'Trả nợ gốc vay dài hạn', 4, 3);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount)
VALUES 
(2406085, 2406031, '341B', 84000000, NULL), -- 6% of 1.4B
(2406086, 2406031, '112A', NULL, 84000000);

-- FIX
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `customer_id`, `supplier_id`) 
VALUES (2406901, '2024-06-30', 'FIX', 5, @period_id, NULL, NULL);
INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2406901, 2406901, '131A', 1000000000, NULL),
(2406902, 2406901, '111A', NULL, 500000000),
(2406903, 2406901, '112A', NULL, 500000000),

(2406904, 2406901, '341A', NULL, 500000000),
(2406905, 2406901, '341B', NULL, 500000000),
(2406906, 2406901, '333A', 500000000, NULL),
(2406907, 2406901, '334A', 500000000, NULL);


COMMIT;