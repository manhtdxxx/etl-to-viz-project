START TRANSACTION;

-- Insert transactions for capital mobilization and fixed asset investment (only in month 1)
-- These would normally be in January, but we'll include them here as per instructions

-- Business operations: Purchasing
-- 5. Purchase materials and tools (300 million) with VAT (10%) and partial payment
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id, supplier_id) 
VALUES (2204005, '2022-04-05', 'Mua nguyên vật liệu, công cụ dụng cụ', 2, 1, 5);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount) 
VALUES 
(2204013, 2204005, '152A', 200000000, NULL),
(2204014, 2204005, '153A', 72727273, NULL), -- 80 million before VAT
(2204015, 2204005, '133A', 30000000, NULL), -- 10% VAT
(2204016, 2204005, '112A', NULL, 100000000),
(2204017, 2204005, '331A', NULL, 202727273);

-- Business operations: Production
-- 6. Issue materials and tools to production (90% of inventory)
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id) 
VALUES (2204006, '2022-04-10', 'Xuất kho nguyên vật liệu sản xuất', 5, 1);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount) 
VALUES 
(2204018, 2204006, 'A621', 180000000, NULL), -- 90% of 200 million materials
(2204019, 2204006, 'A627', 65454545, NULL), -- 90% of 72.727 million tools
(2204020, 2204006, '152A', NULL, 180000000),
(2204021, 2204006, '153A', NULL, 65454545);

-- 7. Depreciation of fixed assets (3% of 1,500 million = 45 million)
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id) 
VALUES (2204007, '2022-04-15', 'Trích khấu hao TSCĐ', 5, 1);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount) 
VALUES 
(2204022, 2204007, 'A627', 45000000, NULL),
(2204023, 2204007, '214B', NULL, 45000000);

-- 8. Pay employee salaries (2x depreciation = 90 million)
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id) 
VALUES (2204008, '2022-04-20', 'Trả lương nhân viên', 5, 1);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount) 
VALUES 
(2204024, 2204008, 'A622', 90000000, NULL),
(2204025, 2204008, '334A', NULL, 90000000);

-- 9. Transfer production costs to finished goods
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id) 
VALUES (2204009, '2022-04-25', 'Kết chuyển chi phí sản xuất', 5, 1);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount) 
VALUES 
(2204026, 2204009, '154A', 290454545, NULL), -- 180 + 65.4545 + 45
(2204027, 2204009, 'A621', NULL, 180000000),
(2204028, 2204009, 'A622', NULL, 90000000),
(2204029, 2204009, 'A627', NULL, 20454545);

-- 10. Transfer finished goods to inventory
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id) 
VALUES (2204010, '2022-04-26', 'Nhập kho thành phẩm', 5, 1);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount) 
VALUES 
(2204030, 2204010, '155A', 290454545, NULL),
(2204031, 2204010, '154A', NULL, 290454545);

-- Business operations: Sales
-- 11. Record cost of goods sold (85% of inventory = 246.9 million)
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id, customer_id) 
VALUES (2204011, '2022-04-27', 'Ghi nhận giá vốn hàng bán', 1, 1, 8);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount) 
VALUES 
(2204032, 2204011, 'A632', 246886363, NULL), -- 85% of 290.45 million
(2204033, 2204011, '155A', NULL, 246886363);

-- 12. Record sales revenue (2x COGS = 493.8 million) with VAT (10%) and partial cash payment
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id, customer_id) 
VALUES (2204012, '2022-04-28', 'Ghi nhận doanh thu bán hàng', 1, 1, 8);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount) 
VALUES 
(2204034, 2204012, '112A', 200000000, NULL),
(2204035, 2204012, '131A', 343180000, NULL), -- 493.8 + 49.38 = 543.18 - 200 = 343.18
(2204036, 2204012, 'A511', NULL, 493800000),
(2204037, 2204012, '333A', NULL, 49380000); -- 10% VAT

-- 13. Record sales returns (5% of revenue = 24.69 million)
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id, customer_id) 
VALUES (2204013, '2022-04-29', 'Ghi nhận giảm trừ doanh thu', 1, 1, 8);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount) 
VALUES 
(2204038, 2204013, 'A521', 24690000, NULL),
(2204039, 2204013, '131A', NULL, 24690000);

-- 14. Record selling expenses (12% of revenue = 59.26 million)
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id) 
VALUES (2204014, '2022-04-30', 'Ghi nhận chi phí bán hàng', 5, 1);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount) 
VALUES 
(2204040, 2204014, 'A641', 59256000, NULL),
(2204041, 2204014, '334A', NULL, 30000000),
(2204042, 2204014, '111A', NULL, 29256000);

-- 15. Record administrative expenses (12% of revenue = 59.26 million)
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id) 
VALUES (2204015, '2022-04-30', 'Ghi nhận chi phí quản lý doanh nghiệp', 5, 1);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount) 
VALUES 
(2204043, 2204015, 'A642', 59256000, NULL),
(2204044, 2204015, '334A', NULL, 30000000),
(2204045, 2204015, '111A', NULL, 29256000);

-- Financial activities
-- 16. Purchase securities (short-term investment 100 million)
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id) 
VALUES (2204016, '2022-04-10', 'Mua chứng khoán ngắn hạn', 5, 1);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount) 
VALUES 
(2204046, 2204016, '121A', 100000000, NULL),
(2204047, 2204016, '112A', NULL, 100000000);

-- 17. Sell securities (80 million, with 5 million profit)
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id) 
VALUES (2204017, '2022-04-20', 'Bán chứng khoán ngắn hạn', 5, 1);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount) 
VALUES 
(2204048, 2204017, '112A', 85000000, NULL),
(2204049, 2204017, '121A', NULL, 80000000),
(2204050, 2204017, 'B515', NULL, 5000000);

-- 18. Pay bank loan interest (8% of total loans = 96 million)
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id) 
VALUES (2204018, '2022-04-25', 'Trả lãi vay ngân hàng', 9, 1);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount) 
VALUES 
(2204051, 2204018, 'B635', 96000000, NULL),
(2204052, 2204018, '112A', NULL, 96000000);

-- 19. Receive investment income (100 million)
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id) 
VALUES (2204019, '2022-04-28', 'Nhận lãi đầu tư', 5, 1);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount) 
VALUES 
(2204053, 2204019, '112A', 100000000, NULL),
(2204054, 2204019, 'B515', NULL, 100000000);

-- Other activities
-- 20. Record other expenses (penalty 20 million)
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id) 
VALUES (2204020, '2022-04-15', 'Phạt vi phạm hợp đồng', 5, 1);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount) 
VALUES 
(2204055, 2204020, 'C811', 20000000, NULL),
(2204056, 2204020, '112A', NULL, 20000000);

-- 21. Record other income (sell fixed asset 40 million - 3% of 1,500 million)
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id) 
VALUES (2204021, '2022-04-20', 'Bán TSCĐ', 5, 1);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount) 
VALUES 
(2204057, 2204021, '112A', 40000000, NULL),
(2204058, 2204021, '211B', NULL, 35000000),
(2204059, 2204021, '214B', NULL, 5000000), -- Accumulated depreciation
(2204060, 2204021, 'C711', NULL, 10000000); -- Gain on sale

-- Month-end closing entries
-- 22. Transfer all expenses to 911
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id) 
VALUES (2204022, '2022-04-30', 'Kết chuyển chi phí', 5, 1);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount) 
VALUES 
(2204061, 2204022, 'D911', 551158363, NULL), -- Sum of all expenses
(2204062, 2204022, 'A632', NULL, 246886363),
(2204063, 2204022, 'A641', NULL, 59256000),
(2204064, 2204022, 'A642', NULL, 59256000),
(2204065, 2204022, 'B635', NULL, 96000000),
(2204066, 2204022, 'C811', NULL, 20000000),
(2204067, 2204022, 'A521', NULL, 24690000),
(2204068, 2204022, 'A627', NULL, 20454545); -- Remaining production overhead

-- 23. Transfer all revenues to 911
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id) 
VALUES (2204023, '2022-04-30', 'Kết chuyển doanh thu', 5, 1);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount) 
VALUES 
(2204069, 2204023, 'A511', 493800000, NULL),
(2204070, 2204023, 'B515', 105000000, NULL),
(2204071, 2204023, 'C711', 10000000, NULL),
(2204072, 2204023, 'D911', NULL, 608800000);

-- 24. Calculate and record corporate income tax (20% of profit)
-- Profit before tax = 608,800,000 - 551,158,363 = 57,641,637
-- Tax = 57,641,637 * 20% = 11,528,327
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id) 
VALUES (2204024, '2022-04-30', 'Ghi nhận thuế TNDN', 8, 1);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount) 
VALUES 
(2204073, 2204024, 'C821', 11528327, NULL),
(2204074, 2204024, '333A', NULL, 11528327);

-- 25. Transfer tax expense to 911
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id) 
VALUES (2204025, '2022-04-30', 'Kết chuyển thuế TNDN', 5, 1);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount) 
VALUES 
(2204075, 2204025, 'D911', 11528327, NULL),
(2204076, 2204025, 'C821', NULL, 11528327);

-- 26. Calculate and transfer net profit (57,641,637 - 11,528,327 = 46,113,310)
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id) 
VALUES (2204026, '2022-04-30', 'Kết chuyển lợi nhuận', 5, 1);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount) 
VALUES 
(2204077, 2204026, 'D911', 46113310, NULL),
(2204078, 2204026, '421B', NULL, 46113310);

-- Cash flow activities
-- 27. Pay dividends (30% of profit = 13,833,993)
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id) 
VALUES (2204027, '2022-04-30', 'Chi trả cổ tức', 4, 1);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount) 
VALUES 
(2204079, 2204027, '421B', 13833993, NULL),
(2204080, 2204027, '112A', NULL, 13833993);

-- 28. Collect customer payments (80% of receivables = 274,544,000)
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id, customer_id) 
VALUES (2204028, '2022-04-30', 'Thu tiền khách hàng', 3, 1, 8);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount) 
VALUES 
(2204081, 2204028, '112A', 274544000, NULL),
(2204082, 2204028, '131A', NULL, 274544000);

-- 29. Pay suppliers (75% of payables = 152,045,455)
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id, supplier_id) 
VALUES (2204029, '2022-04-30', 'Trả tiền nhà cung cấp', 4, 1, 5);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount) 
VALUES 
(2204083, 2204029, '331A', 152045455, NULL),
(2204084, 2204029, '112A', NULL, 152045455);

-- 30. Pay taxes (90% of tax payable = 54,855,000)
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id) 
VALUES (2204030, '2022-04-30', 'Nộp thuế TNDN', 4, 1);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount) 
VALUES 
(2204085, 2204030, '333A', 54855000, NULL), -- 49.38 + 11.528 = 60.908 * 90%
(2204086, 2204030, '112A', NULL, 54855000);

-- 31. Pay salaries (85% of salary payable = 51,000,000)
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id) 
VALUES (2204031, '2022-04-30', 'Trả lương nhân viên', 4, 1);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount) 
VALUES 
(2204087, 2204031, '334A', 51000000, NULL),
(2204088, 2204031, '111A', NULL, 51000000);

-- 32. Repay short-term loan principal (10% = 70,000,000)
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id) 
VALUES (2204032, '2022-04-30', 'Trả nợ gốc vay ngắn hạn', 4, 1);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount) 
VALUES 
(2204089, 2204032, '341A', 70000000, NULL),
(2204090, 2204032, '112A', NULL, 70000000);

-- 33. Repay long-term loan principal (5% = 25,000,000)
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id) 
VALUES (2204033, '2022-04-30', 'Trả nợ gốc vay dài hạn', 4, 1);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount) 
VALUES 
(2204091, 2204033, '341B', 25000000, NULL),
(2204092, 2204033, '112A', NULL, 25000000);


-- FIX
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id) 
VALUES (2204900, '2022-04-30', 'FIX', 5, 1);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount) 
VALUES 
(2204900, 2204900, '121B', 54930000, NULL);

COMMIT;