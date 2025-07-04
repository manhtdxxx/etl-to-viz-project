START TRANSACTION;

-- Set period_id for 2022
SET @period_id = 1;

-- Insert transactions for capital mobilization and fixed asset investment (should be in January but doing for July as per request)

-- Purchasing activities (raw materials, tools)
-- 5. Purchase raw materials with VAT (paid by cash)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES (2207005, '2022-07-03', 'Mua nguyên vật liệu trả bằng tiền mặt', 2, @period_id, 3, NULL);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2207013, 2207005, '152A', 200000000, NULL),
(2207014, 2207005, '133A', 20000000, NULL),
(2207015, 2207005, '111A', NULL, 220000000);

-- 6. Purchase tools with VAT (on credit)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES (2207006, '2022-07-04', 'Mua công cụ dụng cụ trả chậm', 2, @period_id, 8, NULL);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2207016, 2207006, '153A', 100000000, NULL),
(2207017, 2207006, '133A', 10000000, NULL),
(2207018, 2207006, '331A', NULL, 110000000);

-- Production activities
-- 7. Issue raw materials to production
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES (2207007, '2022-07-05', 'Xuất nguyên vật liệu cho sản xuất', 5, @period_id, NULL, NULL);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2207019, 2207007, 'A621', 180000000, NULL),
(2207020, 2207007, '152A', NULL, 180000000);

-- 8. Issue tools to production
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES (2207008, '2022-07-05', 'Xuất công cụ dụng cụ cho sản xuất', 5, @period_id, NULL, NULL);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2207021, 2207008, 'A627', 90000000, NULL),
(2207022, 2207008, '153A', NULL, 90000000);

-- 9. Depreciation of fixed assets (3% of 1,500,000,000)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES (2207009, '2022-07-06', 'Trích khấu hao TSCĐ', 5, @period_id, NULL, NULL);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2207023, 2207009, 'A627', 45000000, NULL),
(2207024, 2207009, '214B', NULL, 45000000);

-- 10. Payroll expenses (2x depreciation)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES (2207010, '2022-07-07', 'Chi phí nhân công trực tiếp', 5, @period_id, NULL, NULL);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2207025, 2207010, 'A622', 90000000, NULL),
(2207026, 2207010, '334A', NULL, 90000000);

-- 11. Transfer production costs to WIP
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES (2207011, '2022-07-10', 'Kết chuyển chi phí sản xuất', 5, @period_id, NULL, NULL);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2207027, 2207011, '154A', 315000000, NULL),
(2207028, 2207011, 'A621', NULL, 180000000),
(2207029, 2207011, 'A622', NULL, 90000000),
(2207030, 2207011, 'A627', NULL, 45000000);

-- 12. Transfer WIP to finished goods
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES (2207012, '2022-07-12', 'Nhập kho thành phẩm', 5, @period_id, NULL, NULL);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2207031, 2207012, '155A', 315000000, NULL),
(2207032, 2207012, '154A', NULL, 315000000);

-- Sales activities
-- 13. Record cost of goods sold (85% of finished goods)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES (2207013, '2022-07-15', 'Ghi nhận giá vốn hàng bán', 1, @period_id, NULL, 5);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2207033, 2207013, 'A632', 267750000, NULL),
(2207034, 2207013, '155A', NULL, 267750000);

-- 14. Record sales revenue (2.2x COGS)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES (2207014, '2022-07-15', 'Ghi nhận doanh thu bán hàng', 1, @period_id, NULL, 5);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2207035, 2207014, '112A', 500000000, NULL),
(2207036, 2207014, '131A', 89000000, NULL),
(2207037, 2207014, 'A521', 10000000, NULL),
(2207038, 2207014, '333A', NULL, 50000000),
(2207039, 2207014, 'A511', NULL, 589000000);

-- 15. Record selling expenses (13% of revenue)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES (2207015, '2022-07-16', 'Chi phí bán hàng', 5, @period_id, NULL, NULL);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2207040, 2207015, 'A641', 76570000, NULL),
(2207041, 2207015, '334A', NULL, 50000000),
(2207042, 2207015, '111A', NULL, 26570000);

-- 16. Record administrative expenses (13% of revenue)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES (2207016, '2022-07-17', 'Chi phí quản lý doanh nghiệp', 5, @period_id, NULL, NULL);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2207043, 2207016, 'A642', 76570000, NULL),
(2207044, 2207016, '334A', NULL, 50000000),
(2207045, 2207016, '111A', NULL, 26570000);

-- Financial activities
-- 17. Purchase securities (short-term)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES (2207017, '2022-07-18', 'Mua chứng khoán ngắn hạn', 5, @period_id, NULL, NULL);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2207046, 2207017, '121A', 100000000, NULL),
(2207047, 2207017, '112A', NULL, 100000000);

-- 18. Sell securities (partial, at profit)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES (2207018, '2022-07-19', 'Bán chứng khoán ngắn hạn có lãi', 5, @period_id, NULL, NULL);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2207048, 2207018, '112A', 55000000, NULL),
(2207049, 2207018, '121A', NULL, 50000000),
(2207050, 2207018, 'B515', NULL, 5000000);

-- 19. Pay bank loan interest (8% of total loans)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES (2207019, '2022-07-20', 'Trả lãi vay ngân hàng', 9, @period_id, NULL, NULL);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2207051, 2207019, 'B635', 96000000, NULL),
(2207052, 2207019, '112A', NULL, 96000000);

-- 20. Receive investment income (slightly higher than interest paid)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES (2207020, '2022-07-21', 'Nhận lãi đầu tư chứng khoán', 5, @period_id, NULL, NULL);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2207053, 2207020, '112A', 100000000, NULL),
(2207054, 2207020, 'B515', NULL, 100000000);

-- Other activities
-- 21. Other expenses (contract penalty)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES (2207021, '2022-07-22', 'Chi phí phạt vi phạm hợp đồng', 5, @period_id, NULL, NULL);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2207055, 2207021, 'C811', 20000000, NULL),
(2207056, 2207021, '111A', NULL, 20000000);

-- 22. Other income (sell fixed assets - 2.5% of fixed assets)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES (2207022, '2022-07-23', 'Thu nhập từ bán TSCĐ', 5, @period_id, NULL, NULL);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2207057, 2207022, '112A', 37500000, NULL),
(2207058, 2207022, 'C711', NULL, 37500000);

-- Month-end closing entries
-- 23. Transfer all expenses to 911
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES (2207023, '2022-07-31', 'Kết chuyển chi phí', 5, @period_id, NULL, NULL);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2207059, 2207023, 'D911', 597990000, NULL),
(2207060, 2207023, 'A632', NULL, 267750000),
(2207061, 2207023, 'A641', NULL, 76570000),
(2207062, 2207023, 'A642', NULL, 76570000),
(2207063, 2207023, 'B635', NULL, 96000000),
(2207064, 2207023, 'C811', NULL, 20000000),
(2207065, 2207023, 'A521', NULL, 10000000);

-- 24. Transfer all revenues to 911
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES (2207024, '2022-07-31', 'Kết chuyển doanh thu', 5, @period_id, NULL, NULL);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2207066, 2207024, 'A511', 589000000, NULL),
(2207067, 2207024, 'B515', 105000000, NULL),
(2207068, 2207024, 'C711', 37500000, NULL),
(2207069, 2207024, 'D911', NULL, 731500000);

-- 25. Calculate and record corporate income tax (20% of profit)
-- Profit before tax = 731,500,000 - 597,990,000 = 133,510,000
-- Tax = 133,510,000 * 20% = 26,702,000
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES (2207025, '2022-07-31', 'Hạch toán thuế TNDN', 8, @period_id, NULL, NULL);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2207070, 2207025, 'C821', 26702000, NULL),
(2207071, 2207025, '333A', NULL, 26702000);

-- 26. Transfer tax expense to 911
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES (2207026, '2022-07-31', 'Kết chuyển chi phí thuế TNDN', 5, @period_id, NULL, NULL);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2207072, 2207026, 'D911', 26702000, NULL),
(2207073, 2207026, 'C821', NULL, 26702000);

-- 27. Calculate and transfer net profit to retained earnings
-- Net profit = 133,510,000 - 26,702,000 = 106,808,000
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES (2207027, '2022-07-31', 'Kết chuyển lợi nhuận sau thuế', 5, @period_id, NULL, NULL);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2207074, 2207027, 'D911', 106808000, NULL),
(2207075, 2207027, '421B', NULL, 106808000);

-- Cash flow activities
-- 28. Pay dividends (30% of net profit)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES (2207028, '2022-07-31', 'Chi trả cổ tức', 4, @period_id, NULL, NULL);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2207076, 2207028, '421B', 32042400, NULL),
(2207077, 2207028, '111A', NULL, 32042400);

-- 29. Collect customer payments (80% of receivables)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES (2207029, '2022-07-31', 'Thu tiền khách hàng', 3, @period_id, NULL, 5);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2207078, 2207029, '112A', 71200000, NULL),
(2207079, 2207029, '131A', NULL, 71200000);

-- 30. Pay suppliers (75% of payables)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES (2207030, '2022-07-31', 'Trả tiền nhà cung cấp', 4, @period_id, 8, NULL);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2207080, 2207030, '331A', 82500000, NULL),
(2207081, 2207030, '112A', NULL, 82500000);

-- 31. Pay corporate income tax (90% of tax payable)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES (2207031, '2022-07-31', 'Nộp thuế TNDN', 4, @period_id, NULL, NULL);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2207082, 2207031, '333A', 24031800, NULL),
(2207083, 2207031, '112A', NULL, 24031800);

-- 32. Pay salaries (85% of payroll)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES (2207032, '2022-07-31', 'Trả lương nhân viên', 4, @period_id, NULL, NULL);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2207084, 2207032, '334A', 85000000, NULL),
(2207085, 2207032, '111A', NULL, 85000000);

-- 33. Repay short-term loan principal (10% of short-term loan)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES (2207033, '2022-07-31', 'Trả nợ gốc vay ngắn hạn', 4, @period_id, NULL, NULL);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2207086, 2207033, '341A', 70000000, NULL),
(2207087, 2207033, '112A', NULL, 70000000);

-- 34. Repay long-term loan principal (5% of long-term loan)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES (2207034, '2022-07-31', 'Trả nợ gốc vay dài hạn', 4, @period_id, NULL, NULL);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2207088, 2207034, '341B', 25000000, NULL),
(2207089, 2207034, '112A', NULL, 25000000);


-- FIX
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES (2207900, '2022-07-31', 'FIX', 5, @period_id, NULL, NULL);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2207900, 2207900, '111A', 78900000, NULL);

COMMIT;