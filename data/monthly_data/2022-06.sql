START TRANSACTION;

-- Business operations: Purchasing
-- 5. Purchase materials with VAT
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id, supplier_id, customer_id)
VALUES (2206005, '2022-06-05', 'Mua nguyên vật liệu từ nhà cung cấp A', 2, 1, 3, NULL);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount)
VALUES 
(2206013, 2206005, '152A', 200000000, NULL),
(2206014, 2206005, '133A', 20000000, NULL),
(2206015, 2206005, '331A', NULL, 220000000);

-- 6. Purchase tools with cash
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id, supplier_id, customer_id)
VALUES (2206006, '2022-06-06', 'Mua công cụ dụng cụ bằng tiền mặt', 2, 1, 7, NULL);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount)
VALUES 
(2206016, 2206006, '153A', 50000000, NULL),
(2206017, 2206006, '133A', 5000000, NULL),
(2206018, 2206006, '111A', NULL, 55000000);

-- Business operations: Production
-- 7. Issue materials to production
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id, supplier_id, customer_id)
VALUES (2206007, '2022-06-10', 'Xuất kho nguyên vật liệu cho sản xuất', 5, 1, NULL, NULL);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount)
VALUES 
(2206019, 2206007, 'A621', 180000000, NULL),
(2206020, 2206007, '152A', NULL, 180000000);

-- 8. Issue tools to production
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id, supplier_id, customer_id)
VALUES (2206008, '2022-06-10', 'Xuất kho công cụ dụng cụ cho sản xuất', 5, 1, NULL, NULL);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount)
VALUES 
(2206021, 2206008, 'A627', 45000000, NULL),
(2206022, 2206008, '153A', NULL, 45000000);

-- 9. Depreciation of fixed assets (3% of 1,500,000,000)
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id, supplier_id, customer_id)
VALUES (2206009, '2022-06-15', 'Trích khấu hao TSCĐ tháng 6/2022', 5, 1, NULL, NULL);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount)
VALUES 
(2206023, 2206009, 'A627', 45000000, NULL),
(2206024, 2206009, '214B', NULL, 45000000);

-- 10. Payroll expenses (2x depreciation)
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id, supplier_id, customer_id)
VALUES (2206010, '2022-06-15', 'Trả lương nhân viên sản xuất', 5, 1, NULL, NULL);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount)
VALUES 
(2206025, 2206010, 'A622', 90000000, NULL),
(2206026, 2206010, '334A', NULL, 90000000);

-- 11. Transfer production costs to WIP
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id, supplier_id, customer_id)
VALUES (2206011, '2022-06-20', 'Kết chuyển chi phí sản xuất vào chi phí SXKD dở dang', 5, 1, NULL, NULL);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount)
VALUES 
(2206027, 2206011, '154A', 360000000, NULL),
(2206028, 2206011, 'A621', NULL, 180000000),
(2206029, 2206011, 'A622', NULL, 90000000),
(2206030, 2206011, 'A627', NULL, 90000000);

-- 12. Transfer WIP to finished goods
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id, supplier_id, customer_id)
VALUES (2206012, '2022-06-25', 'Nhập kho thành phẩm từ chi phí SXKD dở dang', 5, 1, NULL, NULL);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount)
VALUES 
(2206031, 2206012, '155A', 360000000, NULL),
(2206032, 2206012, '154A', NULL, 360000000);

-- Business operations: Sales
-- 13. Record COGS (85% of finished goods)
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id, supplier_id, customer_id)
VALUES (2206013, '2022-06-26', 'Xuất kho thành phẩm bán cho khách hàng B', 1, 1, NULL, 8);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount)
VALUES 
(2206033, 2206013, 'A632', 306000000, NULL),
(2206034, 2206013, '155A', NULL, 306000000);

-- 14. Record sales revenue (2x COGS)
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id, supplier_id, customer_id)
VALUES (2206014, '2022-06-26', 'Bán hàng cho khách hàng B', 1, 1, NULL, 8);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount)
VALUES 
(2206035, 2206014, '112A', 500000000, NULL),
(2206036, 2206014, '131A', 191200000, NULL),
(2206037, 2206014, 'A521', 8000000, NULL),
(2206038, 2206014, 'A511', NULL, 680000000),
(2206039, 2206014, '333A', NULL, 68000000);

-- 15. Record selling expenses (12% of revenue)
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id, supplier_id, customer_id)
VALUES (2206015, '2022-06-27', 'Chi phí bán hàng tháng 6/2022', 5, 1, NULL, NULL);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount)
VALUES 
(2206040, 2206015, 'A641', 81600000, NULL),
(2206041, 2206015, '334A', NULL, 50000000),
(2206042, 2206015, '111A', NULL, 31600000);

-- 16. Record administrative expenses (12% of revenue)
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id, supplier_id, customer_id)
VALUES (2206016, '2022-06-28', 'Chi phí quản lý doanh nghiệp tháng 6/2022', 5, 1, NULL, NULL);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount)
VALUES 
(2206043, 2206016, 'A642', 81600000, NULL),
(2206044, 2206016, '334A', NULL, 50000000),
(2206045, 2206016, '111A', NULL, 31600000);

-- Financial activities
-- 17. Purchase securities
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id, supplier_id, customer_id)
VALUES (2206017, '2022-06-10', 'Mua chứng khoán ngắn hạn', 5, 1, NULL, NULL);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount)
VALUES 
(2206046, 2206017, '121A', 100000000, NULL),
(2206047, 2206017, '112A', NULL, 100000000);

-- 18. Sell securities (with profit)
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id, supplier_id, customer_id)
VALUES (2206018, '2022-06-20', 'Bán chứng khoán ngắn hạn có lãi', 5, 1, NULL, NULL);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount)
VALUES 
(2206048, 2206018, '112A', 60000000, NULL),
(2206049, 2206018, '121A', NULL, 50000000),
(2206050, 2206018, 'B515', NULL, 10000000);

-- 19. Pay bank loan interest (8% of total loans)
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id, supplier_id, customer_id)
VALUES (2206019, '2022-06-25', 'Trả lãi vay ngân hàng tháng 6/2022', 9, 1, NULL, NULL);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount)
VALUES 
(2206051, 2206019, 'B635', 96000000, NULL),
(2206052, 2206019, '112A', NULL, 96000000);

-- 20. Receive investment income
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id, supplier_id, customer_id)
VALUES (2206020, '2022-06-28', 'Nhận lãi đầu tư chứng khoán', 5, 1, NULL, NULL);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount)
VALUES 
(2206053, 2206020, '112A', 120000000, NULL),
(2206054, 2206020, 'B515', NULL, 120000000);

-- Other activities
-- 21. Record other expenses
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id, supplier_id, customer_id)
VALUES (2206021, '2022-06-15', 'Phạt vi phạm hợp đồng với nhà cung cấp C', 5, 1, 12, NULL);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount)
VALUES 
(2206055, 2206021, 'C811', 30000000, NULL),
(2206056, 2206021, '111A', NULL, 30000000);

-- 22. Record other income (sale of fixed assets - 2.5% of original cost)
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id, supplier_id, customer_id)
VALUES (2206022, '2022-06-20', 'Bán TSCĐ không còn sử dụng', 5, 1, NULL, 15);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount)
VALUES 
(2206057, 2206022, '112A', 37500000, NULL),
(2206058, 2206022, '214B', 30000000, NULL),
(2206059, 2206022, '211B', NULL, 60000000),
(2206060, 2206022, 'C711', NULL, 7500000);

-- Month-end closing entries
-- 23. Transfer expenses to income summary
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id, supplier_id, customer_id)
VALUES (2206023, '2022-06-30', 'Kết chuyển chi phí sang TK xác định KQKD', 5, 1, NULL, NULL);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount)
VALUES 
(2206061, 2206023, 'D911', 703800000, NULL),
(2206062, 2206023, 'A632', NULL, 306000000),
(2206063, 2206023, 'A641', NULL, 81600000),
(2206064, 2206023, 'A642', NULL, 81600000),
(2206065, 2206023, 'B635', NULL, 96000000),
(2206066, 2206023, 'C811', NULL, 30000000),
(2206067, 2206023, 'A521', NULL, 8000000);

-- 24. Transfer revenues to income summary
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id, supplier_id, customer_id)
VALUES (2206024, '2022-06-30', 'Kết chuyển doanh thu sang TK xác định KQKD', 5, 1, NULL, NULL);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount)
VALUES 
(2206068, 2206024, 'A511', 680000000, NULL),
(2206069, 2206024, 'B515', 130000000, NULL),
(2206070, 2206024, 'C711', 7500000, NULL),
(2206071, 2206024, 'D911', NULL, 817500000);

-- 25. Calculate and record income tax (20% of pre-tax profit)
-- Pre-tax profit = 817,500,000 - 703,800,000 = 113,700,000
-- Income tax = 113,700,000 * 20% = 22,740,000
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id, supplier_id, customer_id)
VALUES (2206025, '2022-06-30', 'Trích lập thuế TNDN phải nộp', 8, 1, NULL, NULL);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount)
VALUES 
(2206072, 2206025, 'C821', 22740000, NULL),
(2206073, 2206025, '333A', NULL, 22740000);

-- 26. Transfer income tax to income summary
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id, supplier_id, customer_id)
VALUES (2206026, '2022-06-30', 'Kết chuyển thuế TNDN sang TK xác định KQKD', 5, 1, NULL, NULL);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount)
VALUES 
(2206074, 2206026, 'D911', 22740000, NULL),
(2206075, 2206026, 'C821', NULL, 22740000);

-- 27. Transfer net income to retained earnings
-- Net income = 113,700,000 - 22,740,000 = 90,960,000
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id, supplier_id, customer_id)
VALUES (2206027, '2022-06-30', 'Kết chuyển lợi nhuận sau thuế', 5, 1, NULL, NULL);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount)
VALUES 
(2206076, 2206027, 'D911', 90960000, NULL),
(2206077, 2206027, '421B', NULL, 90960000);

-- Cash flow activities
-- 28. Pay dividends (30% of net income)
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id, supplier_id, customer_id)
VALUES (2206028, '2022-06-30', 'Chi trả cổ tức cho chủ sở hữu', 4, 1, NULL, NULL);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount)
VALUES 
(2206078, 2206028, '421B', 27288000, NULL),
(2206079, 2206028, '111A', NULL, 27288000);

-- 29. Collect from customers (80% of receivables)
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id, supplier_id, customer_id)
VALUES (2206029, '2022-06-30', 'Thu tiền từ khách hàng B', 3, 1, NULL, 8);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount)
VALUES 
(2206080, 2206029, '112A', 152960000, NULL),
(2206081, 2206029, '131A', NULL, 152960000);

-- 30. Pay suppliers (75% of payables)
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id, supplier_id, customer_id)
VALUES (2206030, '2022-06-30', 'Trả tiền cho nhà cung cấp A', 4, 1, 3, NULL);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount)
VALUES 
(2206082, 2206030, '331A', 165000000, NULL),
(2206083, 2206030, '112A', NULL, 165000000);

-- 31. Pay taxes (90% of tax payable)
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id, supplier_id, customer_id)
VALUES (2206031, '2022-06-30', 'Nộp thuế TNDN', 4, 1, NULL, NULL);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount)
VALUES 
(2206084, 2206031, '333A', 20466000, NULL),
(2206085, 2206031, '112A', NULL, 20466000);

-- 32. Pay salaries (85% of salary payable)
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id, supplier_id, customer_id)
VALUES (2206032, '2022-06-30', 'Trả lương nhân viên', 4, 1, NULL, NULL);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount)
VALUES 
(2206086, 2206032, '334A', 85000000, NULL),
(2206087, 2206032, '111A', NULL, 85000000);

-- 33. Repay short-term loan principal (10% of short-term loan)
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id, supplier_id, customer_id)
VALUES (2206033, '2022-06-30', 'Trả nợ gốc vay ngắn hạn', 4, 1, NULL, NULL);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount)
VALUES 
(2206088, 2206033, '341A', 70000000, NULL),
(2206089, 2206033, '112A', NULL, 70000000);

-- 34. Repay long-term loan principal (5% of long-term loan)
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id, supplier_id, customer_id)
VALUES (2206034, '2022-06-30', 'Trả nợ gốc vay dài hạn', 4, 1, NULL, NULL);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount)
VALUES 
(2206090, 2206034, '341B', 25000000, NULL),
(2206091, 2206034, '112A', NULL, 25000000);


-- FIX
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id, supplier_id, customer_id)
VALUES (2206900, '2022-06-30', 'FIX', 5, 1, NULL, NULL);
INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount)
VALUES 
(2206900, 2206900, '338B', NULL, 51800000);

INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id, supplier_id, customer_id)
VALUES (2206901, '2022-06-30', 'FIX', 5, 1, NULL, NULL);
INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount)
VALUES 
(2206901, 2206901, '211B', 250000000, NULL),
(2206902, 2206901, '341A', NULL, 250000000);

COMMIT;