START TRANSACTION;

-- Set transaction IDs for December 2023 (2312000 - 2312999)
-- Set entry IDs for December 2023 (2312000 - 2312999)

-- 2. Business operations - Purchasing
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id, supplier_id) VALUES 
(2312005, '2023-12-05', 'Mua nguyên vật liệu từ NCC A', 2, 2, 5),
(2312006, '2023-12-06', 'Mua công cụ dụng cụ từ NCC B', 2, 2, 8);

-- Purchase of materials (300 million + 10% VAT)
INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount) VALUES
(2312013, 2312005, '152A', 300000000, NULL),
(2312014, 2312005, '133A', 30000000, NULL),
(2312015, 2312005, '331A', NULL, 330000000);

-- Purchase of tools (150 million + 10% VAT)
INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount) VALUES
(2312016, 2312006, '153A', 150000000, NULL),
(2312017, 2312006, '133A', 15000000, NULL),
(2312018, 2312006, '112A', NULL, 165000000);

-- 3. Business operations - Production
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id) VALUES 
(2312007, '2023-12-10', 'Xuất kho nguyên vật liệu cho SX', 5, 2),
(2312008, '2023-12-10', 'Xuất kho công cụ dụng cụ cho SX', 5, 2),
(2312009, '2023-12-10', 'Trích khấu hao TSCĐ', 5, 2),
(2312010, '2023-12-10', 'Trả lương nhân viên SX', 5, 2);

-- Material usage (90% of inventory)
INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount) VALUES
(2312019, 2312007, 'A621', 270000000, NULL),
(2312020, 2312007, '152A', NULL, 270000000);

-- Tool usage (90% of inventory)
INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount) VALUES
(2312021, 2312008, 'A627', 135000000, NULL),
(2312022, 2312008, '153A', NULL, 135000000);

-- Depreciation (3% of fixed assets = 2,500,000,000 * 3% = 75,000,000)
INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount) VALUES
(2312023, 2312009, 'A627', 75000000, NULL),
(2312024, 2312009, '214B', NULL, 75000000);

-- Salary payment (2x depreciation = 150,000,000)
INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount) VALUES
(2312025, 2312010, 'A622', 150000000, NULL),
(2312026, 2312010, '334A', NULL, 150000000);

-- 4. Business operations - Finished goods
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id) VALUES 
(2312011, '2023-12-15', 'Kết chuyển chi phí SX vào chi phí SX dở dang', 5, 2),
(2312012, '2023-12-15', 'Nhập kho thành phẩm', 5, 2);

-- Transfer production costs to WIP
INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount) VALUES
(2312027, 2312011, '154A', 495000000, NULL), -- 270 + 135 + 75 + 15 = 495
(2312028, 2312011, 'A621', NULL, 270000000),
(2312029, 2312011, 'A622', NULL, 150000000),
(2312030, 2312011, 'A627', NULL, 75000000);

-- Transfer WIP to finished goods
INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount) VALUES
(2312031, 2312012, '155A', 495000000, NULL),
(2312032, 2312012, '154A', NULL, 495000000);

-- 5. Business operations - Sales (cost)
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id, customer_id) VALUES 
(2312013, '2023-12-20', 'Xuất kho thành phẩm bán cho KH X', 1, 2, 3),
(2312014, '2023-12-21', 'Xuất kho thành phẩm bán cho KH Y', 1, 2, 7);

-- Cost of goods sold (90% of finished goods = 445,500,000)
INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount) VALUES
(2312033, 2312013, 'A632', 250000000, NULL),
(2312034, 2312013, '155A', NULL, 250000000),
(2312035, 2312014, 'A632', 200000000, NULL),
(2312036, 2312014, '155A', NULL, 200000000);

-- 6. Business operations - Sales (revenue)
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id, customer_id) VALUES 
(2312015, '2023-12-20', 'Bán hàng cho KH X', 1, 2, 3),
(2312016, '2023-12-21', 'Bán hàng cho KH Y', 1, 2, 7);

-- Sales revenue (2.2x cost = 990,000,000 + 10% VAT)
INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount) VALUES
(2312037, 2312015, '112A', 302500000, NULL), -- 250 * 2.2 * 1.1 = 605
(2312038, 2312015, '131A', 302500000, NULL),
(2312039, 2312015, 'A511', NULL, 550000000),
(2312040, 2312015, '333A', NULL, 55000000),
(2312041, 2312016, '112A', 242000000, NULL), -- 200 * 2.2 * 1.1 = 484
(2312042, 2312016, '131A', 242000000, NULL),
(2312043, 2312016, 'A511', NULL, 440000000),
(2312044, 2312016, '333A', NULL, 44000000);

-- 7. Business operations - Sales expenses
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id) VALUES 
(2312017, '2023-12-22', 'Chi phí bán hàng', 5, 2),
(2312018, '2023-12-22', 'Chi phí quản lý DN', 5, 2);

-- Selling expenses (15% of revenue = 148,500,000)
INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount) VALUES
(2312045, 2312017, 'A641', 148500000, NULL),
(2312046, 2312017, '334A', NULL, 80000000),
(2312047, 2312017, '111A', NULL, 68500000);

-- Administrative expenses (15% of revenue = 148,500,000)
INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount) VALUES
(2312048, 2312018, 'A642', 148500000, NULL),
(2312049, 2312018, '334A', NULL, 70000000),
(2312050, 2312018, '111A', NULL, 78500000);

-- 8. Financial activities - Securities trading
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id) VALUES 
(2312019, '2023-12-15', 'Mua chứng khoán ngắn hạn', 5, 2),
(2312020, '2023-12-18', 'Bán chứng khoán ngắn hạn', 5, 2);

-- Purchase securities (200 million)
INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount) VALUES
(2312051, 2312019, '121A', 200000000, NULL),
(2312052, 2312019, '112A', NULL, 200000000);

-- Sell securities (150 million, cost 160 million - loss 10 million)
INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount) VALUES
(2312053, 2312020, '112A', 150000000, NULL),
(2312054, 2312020, 'B635', 10000000, NULL),
(2312055, 2312020, '121A', NULL, 160000000);

-- 9. Financial activities - Interest
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id) VALUES 
(2312021, '2023-12-25', 'Trả lãi vay ngân hàng', 9, 2),
(2312022, '2023-12-26', 'Nhận lãi đầu tư', 5, 2);

-- Interest payment (7% of total loans = 1,500,000,000 * 7% = 105,000,000)
INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount) VALUES
(2312056, 2312021, 'B635', 105000000, NULL),
(2312057, 2312021, '112A', NULL, 105000000);

-- Interest income (120,000,000)
INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount) VALUES
(2312058, 2312022, '112A', 120000000, NULL),
(2312059, 2312022, 'B515', NULL, 120000000);

-- 10. Other activities
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id) VALUES 
(2312023, '2023-12-28', 'Chi phí phạt hợp đồng', 5, 2),
(2312024, '2023-12-29', 'Thu nhập bất thường', 5, 2);

-- Other expenses (50,000,000)
INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount) VALUES
(2312060, 2312023, 'C811', 50000000, NULL),
(2312061, 2312023, '111A', NULL, 50000000);

-- Other income (60,000,000)
INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount) VALUES
(2312062, 2312024, '112A', 60000000, NULL),
(2312063, 2312024, 'C711', NULL, 60000000);

-- 11. Month-end closing entries
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id) VALUES 
(2312025, '2023-12-31', 'Kết chuyển chi phí', 5, 2),
(2312026, '2023-12-31', 'Kết chuyển doanh thu', 5, 2),
(2312027, '2023-12-31', 'Hạch toán thuế TNDN', 8, 2),
(2312028, '2023-12-31', 'Kết chuyển thuế TNDN', 5, 2),
(2312029, '2023-12-31', 'Kết chuyển lợi nhuận', 5, 2);

-- Transfer expenses to 911
INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount) VALUES
(2312064, 2312025, 'D911', 450000000, NULL), -- 632: 450
(2312065, 2312025, 'A632', NULL, 450000000),
(2312066, 2312025, 'D911', 148500000, NULL), -- 641: 148.5
(2312067, 2312025, 'A641', NULL, 148500000),
(2312068, 2312025, 'D911', 148500000, NULL), -- 642: 148.5
(2312069, 2312025, 'A642', NULL, 148500000),
(2312070, 2312025, 'D911', 115000000, NULL), -- 635: 10 + 105
(2312071, 2312025, 'B635', NULL, 115000000),
(2312072, 2312025, 'D911', 50000000, NULL), -- 811: 50
(2312073, 2312025, 'C811', NULL, 50000000);

-- Transfer revenues to 911
INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount) VALUES
(2312074, 2312026, 'A511', 990000000, NULL), -- 511: 990
(2312075, 2312026, 'D911', NULL, 990000000),
(2312076, 2312026, 'B515', 120000000, NULL), -- 515: 120
(2312077, 2312026, 'D911', NULL, 120000000),
(2312078, 2312026, 'C711', 60000000, NULL), -- 711: 60
(2312079, 2312026, 'D911', NULL, 60000000);

-- Calculate and record income tax (20% of PBT)
-- PBT = (990+120+60) - (450+148.5+148.5+115+50) = 1,170 - 912 = 258
-- Tax = 258 * 20% = 51.6
INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount) VALUES
(2312080, 2312027, 'C821', 51600000, NULL),
(2312081, 2312027, '333A', NULL, 51600000);

-- Transfer tax to 911
INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount) VALUES
(2312082, 2312028, 'D911', 51600000, NULL),
(2312083, 2312028, 'C821', NULL, 51600000);

-- Transfer net profit to retained earnings (258 - 51.6 = 206.4)
INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount) VALUES
(2312084, 2312029, 'D911', 206400000, NULL),
(2312085, 2312029, '421B', NULL, 206400000);

-- 12. Cash flow activities
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id, customer_id, supplier_id) VALUES 
(2312030, '2023-12-28', 'Chi trả cổ tức', 4, 2, NULL, NULL),
(2312031, '2023-12-28', 'Thu tiền từ khách hàng', 3, 2, 3, NULL),
(2312032, '2023-12-29', 'Trả tiền cho nhà cung cấp', 4, 2, NULL, 5),
(2312033, '2023-12-29', 'Nộp thuế TNDN', 4, 2, NULL, NULL),
(2312034, '2023-12-30', 'Trả lương nhân viên', 4, 2, NULL, NULL),
(2312035, '2023-12-30', 'Trả nợ gốc vay ngắn hạn', 4, 2, NULL, NULL),
(2312036, '2023-12-30', 'Trả nợ gốc vay dài hạn', 4, 2, NULL, NULL);

-- Dividend payment (15% of profit = 31,000,000)
INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount) VALUES
(2312086, 2312030, '421B', 31000000, NULL),
(2312087, 2312030, '112A', NULL, 31000000);

-- Collect from customers (80% of receivables = 80% of 544.5 = 435.6)
INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount) VALUES
(2312088, 2312031, '112A', 435600000, NULL),
(2312089, 2312031, '131A', NULL, 435600000);

-- Pay to suppliers (75% of payables = 75% of 330 = 247.5)
INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount) VALUES
(2312090, 2312032, '331A', 247500000, NULL),
(2312091, 2312032, '112A', NULL, 247500000);

-- Pay income tax (90% of tax = 46,440,000)
INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount) VALUES
(2312092, 2312033, '333A', 46440000 +35000000, NULL), -- FIX
(2312093, 2312033, '112A', NULL, 46440000);

-- Pay salary (85% of salary payable = 85% of 150 = 127.5)
INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount) VALUES
(2312094, 2312034, '334A', 127500000 +100000000, NULL), -- FIX
(2312095, 2312034, '111A', NULL, 127500000);

-- Repay short-term loan (10% of 900 = 90)
INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount) VALUES
(2312096, 2312035, '341A', 90000000, NULL),
(2312097, 2312035, '112A', NULL, 90000000);

-- Repay long-term loan (5% of 1,100 = 55)
INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount) VALUES
(2312098, 2312036, '341B', 55000000, NULL),
(2312099, 2312036, '112A', NULL, 55000000);

COMMIT;