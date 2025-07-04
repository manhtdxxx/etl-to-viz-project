START TRANSACTION;

-- Insert transactions for capital mobilization and fixed asset investment in January 2023
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id) VALUES 
(2301001, '2023-01-05', 'Nhận vốn góp chủ sở hữu bằng tiền mặt và tiền gửi ngân hàng', 5, 2),
(2301002, '2023-01-10', 'Vay ngắn hạn ngân hàng', 9, 2),
(2301003, '2023-01-15', 'Vay dài hạn ngân hàng', 9, 2),
(2301004, '2023-01-20', 'Đầu tư TSCĐ hữu hình', 5, 2);

-- Entries for capital contribution (500 million)
INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount) VALUES 
(2301001, 2301001, '111A', 100000000, NULL),
(2301002, 2301001, '112A', 400000000, NULL),
(2301003, 2301001, '411A', NULL, 500000000);

-- Entries for short-term loan (900 million)
INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount) VALUES 
(2301004, 2301002, '111A', 300000000, NULL),
(2301005, 2301002, '112A', 600000000, NULL),
(2301006, 2301002, '341A', NULL, 900000000);

-- Entries for long-term loan (600 million)
INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount) VALUES 
(2301007, 2301003, '111A', 200000000, NULL),
(2301008, 2301003, '112A', 400000000, NULL),
(2301009, 2301003, '341B', NULL, 600000000);

-- Entries for fixed asset investment (1,000 million)
INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount) VALUES 
(2301010, 2301004, '211B', 1000000000, NULL),
(2301011, 2301004, '111A', NULL, 400000000),
(2301012, 2301004, '112A', NULL, 600000000);

-- Business operations - Purchasing activities
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id, supplier_id) VALUES 
(2301005, '2023-01-06', 'Mua nguyên vật liệu trả bằng tiền mặt', 2, 2, 5),
(2301006, '2023-01-12', 'Mua công cụ dụng cụ trả chậm', 2, 2, 8),
(2301007, '2023-01-18', 'Mua nguyên vật liệu trả bằng chuyển khoản', 2, 2, 12);

-- Purchasing entries (total ~300 million)
INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount) VALUES 
(2301013, 2301005, '152A', 80000000, NULL),
(2301014, 2301005, '133A', 8000000, NULL),
(2301015, 2301005, '111A', NULL, 88000000),
(2301016, 2301006, '153A', 120000000, NULL),
(2301017, 2301006, '133A', 12000000, NULL),
(2301018, 2301006, '331A', NULL, 132000000),
(2301019, 2301007, '152A', 60000000, NULL),
(2301020, 2301007, '133A', 6000000, NULL),
(2301021, 2301007, '112A', NULL, 66000000);

-- Production activities
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id) VALUES 
(2301008, '2023-01-14', 'Xuất kho nguyên vật liệu cho sản xuất', 5, 2),
(2301009, '2023-01-21', 'Trích khấu hao TSCĐ', 5, 2),
(2301010, '2023-01-28', 'Trả lương nhân viên sản xuất', 5, 2);

-- Production entries (using ~85% of materials, depreciation ~3% of fixed assets, salary ~2x depreciation)
INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount) VALUES 
(2301022, 2301008, 'A621', 119000000, NULL),
(2301023, 2301008, '152A', NULL, 119000000),
(2301024, 2301009, 'A627', 75000000, NULL),
(2301025, 2301009, '214B', NULL, 75000000),
(2301026, 2301010, 'A622', 150000000, NULL),
(2301027, 2301010, '334A', NULL, 150000000);

-- Finished goods
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id) VALUES 
(2301011, '2023-01-31', 'Kết chuyển chi phí sản xuất vào thành phẩm', 5, 2),
(2301012, '2023-01-31', 'Nhập kho thành phẩm', 5, 2);

-- Finished goods entries (transfer all production costs)
INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount) VALUES 
(2301028, 2301011, '154A', 344000000, NULL),
(2301029, 2301011, 'A621', NULL, 119000000),
(2301030, 2301011, 'A622', NULL, 150000000),
(2301031, 2301011, 'A627', NULL, 75000000),
(2301032, 2301012, '155A', 344000000, NULL),
(2301033, 2301012, '154A', NULL, 344000000);

-- Sales activities (cost ~80% of finished goods, revenue ~2.2x cost)
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id, customer_id) VALUES 
(2301013, '2023-01-15', 'Bán hàng ghi nhận giá vốn', 1, 2, 3),
(2301014, '2023-01-15', 'Bán hàng ghi nhận doanh thu', 1, 2, 3),
(2301015, '2023-01-22', 'Bán hàng ghi nhận giá vốn', 1, 2, 7),
(2301016, '2023-01-22', 'Bán hàng ghi nhận doanh thu', 1, 2, 7);

-- Sales entries
INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount) VALUES 
(2301034, 2301013, 'A632', 150000000, NULL),
(2301035, 2301013, '155A', NULL, 150000000),
(2301036, 2301014, '131A', 330000000, NULL),
(2301037, 2301014, 'A511', NULL, 300000000),
(2301038, 2301014, '333A', NULL, 30000000),
(2301039, 2301015, 'A632', 125000000, NULL),
(2301040, 2301015, '155A', NULL, 125000000),
(2301041, 2301016, '112A', 275000000, NULL),
(2301042, 2301016, 'A511', NULL, 250000000),
(2301043, 2301016, '333A', NULL, 25000000);

-- Sales expenses (~13% of revenue each)
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id) VALUES 
(2301017, '2023-01-31', 'Chi phí bán hàng', 5, 2),
(2301018, '2023-01-31', 'Chi phí quản lý doanh nghiệp', 5, 2);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount) VALUES 
(2301044, 2301017, 'A641', 71500000, NULL),
(2301045, 2301017, '334A', NULL, 71500000),
(2301046, 2301018, 'A642', 71500000, NULL),
(2301047, 2301018, '334A', NULL, 71500000);

-- Financial activities
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id) VALUES 
(2301019, '2023-01-11', 'Mua chứng khoán ngắn hạn', 5, 2),
(2301020, '2023-01-25', 'Bán chứng khoán ngắn hạn', 5, 2),
(2301021, '2023-01-31', 'Trả lãi vay ngân hàng', 9, 2),
(2301022, '2023-01-31', 'Nhận lãi đầu tư chứng khoán', 5, 2);

-- Financial entries
INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount) VALUES 
(2301048, 2301019, '121A', 200000000, NULL),
(2301049, 2301019, '112A', NULL, 200000000),
(2301050, 2301020, '112A', 220000000, NULL),
(2301051, 2301020, '121A', NULL, 200000000),
(2301052, 2301020, 'B515', NULL, 20000000),
(2301053, 2301021, 'B635', 125000000, NULL),
(2301054, 2301021, '112A', NULL, 125000000),
(2301055, 2301022, '112A', 150000000, NULL),
(2301056, 2301022, 'B515', NULL, 150000000);

-- Other activities
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id) VALUES 
(2301023, '2023-01-19', 'Chi phí phạt vi phạm hợp đồng', 5, 2),
(2301024, '2023-01-27', 'Thu nhập từ bán phế liệu', 5, 2);

-- Other entries
INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount) VALUES 
(2301057, 2301023, 'C811', 30000000, NULL),
(2301058, 2301023, '111A', NULL, 30000000),
(2301059, 2301024, '112A', 50000000, NULL),
(2301060, 2301024, 'C711', NULL, 50000000);

-- Month-end closing entries
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id) VALUES 
(2301025, '2023-01-31', 'Kết chuyển doanh thu', 5, 2),
(2301026, '2023-01-31', 'Kết chuyển chi phí', 5, 2),
(2301027, '2023-01-31', 'Tính thuế TNDN', 8, 2),
(2301028, '2023-01-31', 'Kết chuyển thuế TNDN', 5, 2),
(2301029, '2023-01-31', 'Kết chuyển lợi nhuận sau thuế', 5, 2);

-- Closing entries
INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount) VALUES 
-- Transfer revenues
(2301061, 2301025, 'A511', 550000000, NULL),
(2301062, 2301025, 'B515', 170000000, NULL),
(2301063, 2301025, 'C711', 50000000, NULL),
(2301064, 2301025, 'D911', NULL, 770000000),
-- Transfer expenses
(2301065, 2301026, 'D911', 650500000, NULL),
(2301066, 2301026, 'A632', NULL, 275000000),
(2301067, 2301026, 'A641', NULL, 71500000),
(2301068, 2301026, 'A642', NULL, 71500000),
(2301069, 2301026, 'B635', NULL, 125000000),
(2301070, 2301026, 'C811', NULL, 30000000),
-- Calculate income tax (20% of profit: 770M - 650.5M = 119.5M * 20% = 23.9M)
(2301071, 2301027, 'C821', 23900000, NULL),
(2301072, 2301027, '333A', NULL, 23900000),
-- Transfer income tax
(2301073, 2301028, 'D911', 23900000, NULL),
(2301074, 2301028, 'C821', NULL, 23900000),
-- Transfer net profit (119.5M - 23.9M = 95.6M)
(2301075, 2301029, 'D911', 95600000, NULL),
(2301076, 2301029, '421B', NULL, 95600000);

-- Cash flow activities
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id, customer_id, supplier_id) VALUES 
(2301030, '2023-01-30', 'Chi trả cổ tức', 4, 2, NULL, NULL),
(2301031, '2023-01-16', 'Thu tiền khách hàng', 3, 2, 3, NULL),
(2301032, '2023-01-23', 'Trả tiền nhà cung cấp', 4, 2, NULL, 8),
(2301033, '2023-01-31', 'Trả thuế TNDN', 4, 2, NULL, NULL),
(2301034, '2023-01-31', 'Trả lương nhân viên', 4, 2, NULL, NULL),
(2301035, '2023-01-31', 'Trả nợ gốc vay ngắn hạn', 4, 2, NULL, NULL),
(2301036, '2023-01-31', 'Trả nợ gốc vay dài hạn', 4, 2, NULL, NULL);

-- Cash flow entries
INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount) VALUES 
-- Dividend payment (15% of profit)
(2301077, 2301030, '421B', 14340000, NULL),
(2301078, 2301030, '112A', NULL, 14340000),
-- Collect from customers (80% of receivables)
(2301079, 2301031, '112A', 264000000, NULL),
(2301080, 2301031, '131A', NULL, 264000000),
-- Pay suppliers (75% of payables)
(2301081, 2301032, '331A', 99000000, NULL),
(2301082, 2301032, '112A', NULL, 99000000),
-- Pay income tax (90% of tax payable)
(2301083, 2301033, '333A', 21510000, NULL),
(2301084, 2301033, '112A', NULL, 21510000),
-- Pay salary (85% of salary payable)
(2301085, 2301034, '334A', 188275000, NULL),
(2301086, 2301034, '111A', NULL, 188275000),
-- Repay short-term loan (10% of short-term debt)
(2301087, 2301035, '341A', 90000000, NULL),
(2301088, 2301035, '112A', NULL, 90000000),
-- Repay long-term loan (5% of long-term debt)
(2301089, 2301036, '341B', 55000000, NULL),
(2301090, 2301036, '112A', NULL, 55000000);


-- FIX
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id, customer_id, supplier_id) VALUES 
(2301900, '2023-01-30', 'FIX', 5, 2, NULL, NULL);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount) VALUES 
(2301900, 2301900, '421B', NULL, 77500000);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount) VALUES 
(2301901, 2301900, '211B', 600000000, NULL),
(2301902, 2301900, '131A', NULL, 300000000),
(2301903, 2301900, '152A', NULL, 100000000),
(2301904, 2301900, '153A', NULL, 100000000),
(2301905, 2301900, '155A', NULL, 100000000);

COMMIT;