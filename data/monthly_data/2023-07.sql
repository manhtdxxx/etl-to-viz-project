START TRANSACTION;

-- Set period_id for 2023 (value 2)
SET @period_id = 2;

-- Insert transactions for capital mobilization and fixed asset investment (only in month 1)
-- Since this is July, we won't include these transactions as per requirement

-- 1. Purchase of materials and tools (with VAT)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`) 
VALUES 
(2307001, '2023-07-05', 'Mua nguyên vật liệu từ nhà cung cấp A', 2, @period_id, 5),
(2307002, '2023-07-10', 'Mua công cụ dụng cụ từ nhà cung cấp B', 2, @period_id, 8),
(2307003, '2023-07-15', 'Mua nguyên vật liệu từ nhà cung cấp C', 2, @period_id, 12);

-- Entries for purchase transactions
INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2307001, 2307001, '152A', 120000000, NULL),
(2307002, 2307001, '133A', 12000000, NULL),
(2307003, 2307001, '331A', NULL, 132000000),
(2307004, 2307002, '153A', 80000000, NULL),
(2307005, 2307002, '133A', 8000000, NULL),
(2307006, 2307002, '112A', NULL, 88000000),
(2307007, 2307003, '152A', 150000000, NULL),
(2307008, 2307003, '133A', 15000000, NULL),
(2307009, 2307003, '331A', NULL, 165000000);

-- 2. Production activities
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES 
(2307004, '2023-07-10', 'Xuất kho nguyên vật liệu cho sản xuất', 5, @period_id),
(2307005, '2023-07-10', 'Xuất kho công cụ dụng cụ cho sản xuất', 5, @period_id),
(2307006, '2023-07-15', 'Trích khấu hao TSCĐ tháng 7/2023', 5, @period_id),
(2307007, '2023-07-20', 'Trả lương nhân viên sản xuất', 5, @period_id),
(2307008, '2023-07-25', 'Phân bổ chi phí sản xuất chung', 5, @period_id);

-- Entries for production activities
INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
-- Xuất kho nguyên vật liệu (90% of 270,000,000)
(2307010, 2307004, 'A621', 243000000, NULL),
(2307011, 2307004, '152A', NULL, 243000000),
-- Xuất kho công cụ dụng cụ (90% of 80,000,000)
(2307012, 2307005, 'A627', 72000000, NULL),
(2307013, 2307005, '153A', NULL, 72000000),
-- Trích khấu hao TSCĐ (3% of 2,500,000,000)
(2307014, 2307006, 'A627', 75000000, NULL),
(2307015, 2307006, '214B', NULL, 75000000),
-- Trả lương nhân viên (2x khấu hao)
(2307016, 2307007, 'A622', 150000000, NULL),
(2307017, 2307007, '334A', NULL, 150000000),
-- Chi phí sản xuất chung khác
(2307018, 2307008, 'A627', 50000000, NULL),
(2307019, 2307008, '331A', NULL, 50000000);

-- 3. Finished goods inventory
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES 
(2307009, '2023-07-31', 'Kết chuyển chi phí sản xuất vào chi phí dở dang', 5, @period_id),
(2307010, '2023-07-31', 'Nhập kho thành phẩm từ chi phí dở dang', 5, @period_id);

-- Entries for finished goods
INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
-- Kết chuyển chi phí sản xuất vào TK 154
(2307020, 2307009, '154A', 515000000, NULL), -- 243 + 150 + 72 + 50
(2307021, 2307009, 'A621', NULL, 243000000),
(2307022, 2307009, 'A622', NULL, 150000000),
(2307023, 2307009, 'A627', NULL, 122000000),
-- Nhập kho thành phẩm từ TK 154
(2307024, 2307010, '155A', 515000000, NULL),
(2307025, 2307010, '154A', NULL, 515000000);

-- 4. Sales activities - Cost of goods sold
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `customer_id`) 
VALUES 
(2307011, '2023-07-15', 'Xuất bán thành phẩm cho khách hàng X', 1, @period_id, 3),
(2307012, '2023-07-20', 'Xuất bán thành phẩm cho khách hàng Y', 1, @period_id, 7),
(2307013, '2023-07-25', 'Xuất bán thành phẩm cho khách hàng Z', 1, @period_id, 15);

-- Entries for COGS (selling 90% of 515,000,000)
INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2307026, 2307011, 'A632', 180000000, NULL),
(2307027, 2307011, '155A', NULL, 180000000),
(2307028, 2307012, 'A632', 200000000, NULL),
(2307029, 2307012, '155A', NULL, 200000000),
(2307030, 2307013, 'A632', 83500000, NULL),
(2307031, 2307013, '155A', NULL, 83500000);

-- 5. Sales activities - Revenue recognition
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `customer_id`) 
VALUES 
(2307014, '2023-07-15', 'Bán hàng cho khách hàng X', 1, @period_id, 3),
(2307015, '2023-07-20', 'Bán hàng cho khách hàng Y', 1, @period_id, 7),
(2307016, '2023-07-25', 'Bán hàng cho khách hàng Z', 1, @period_id, 15);

-- Entries for revenue (2.2x COGS = ~1,020,000,000)
INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2307032, 2307014, '131A', 396000000, NULL), -- 180 * 2.2 = 396
(2307033, 2307014, 'A511', NULL, 360000000),
(2307034, 2307014, '333A', NULL, 36000000),
(2307035, 2307015, '112A', 440000000, NULL), -- 200 * 2.2 = 440
(2307036, 2307015, 'A511', NULL, 400000000),
(2307037, 2307015, '333A', NULL, 40000000),
(2307038, 2307016, '131A', 183700000, NULL), -- 83.5 * 2.2 = 183.7
(2307039, 2307016, 'A511', NULL, 167000000),
(2307040, 2307016, '333A', NULL, 16700000),
(2307041, 2307016, 'A521', 3000000, NULL), -- Giảm trừ doanh thu
(2307042, 2307016, '131A', NULL, 3000000);

-- 6. Selling and administrative expenses
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES 
(2307017, '2023-07-15', 'Chi phí bán hàng tháng 7/2023', 5, @period_id),
(2307018, '2023-07-15', 'Chi phí quản lý doanh nghiệp tháng 7/2023', 5, @period_id);

-- Entries for expenses (15% of revenue each)
INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
-- Chi phí bán hàng (15% of 927,000,000)
(2307043, 2307017, 'A641', 139050000, NULL),
(2307044, 2307017, '331A', NULL, 80000000),
(2307045, 2307017, '334A', NULL, 50000000),
(2307046, 2307017, '214B', NULL, 9050000),
-- Chi phí quản lý doanh nghiệp (15% of 927,000,000)
(2307047, 2307018, 'A642', 139050000, NULL),
(2307048, 2307018, '331A', NULL, 70000000),
(2307049, 2307018, '334A', NULL, 60000000),
(2307050, 2307018, '214B', NULL, 9050000);

-- 7. Financial activities
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES 
(2307019, '2023-07-10', 'Mua chứng khoán ngắn hạn', 5, @period_id),
(2307020, '2023-07-20', 'Bán chứng khoán ngắn hạn', 5, @period_id),
(2307021, '2023-07-25', 'Trả lãi vay ngân hàng', 5, @period_id),
(2307022, '2023-07-28', 'Nhận lãi đầu tư chứng khoán', 5, @period_id);

-- Entries for financial activities
INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
-- Mua chứng khoán
(2307051, 2307019, '121A', 200000000, NULL),
(2307052, 2307019, '112A', NULL, 200000000),
-- Bán chứng khoán (bán 50% với lãi 10%)
(2307053, 2307020, '112A', 110000000, NULL),
(2307054, 2307020, '121A', NULL, 100000000),
(2307055, 2307020, 'B515', NULL, 10000000),
-- Trả lãi vay (8% of 2,000,000,000 total debt)
(2307056, 2307021, 'B635', 160000000, NULL),
(2307057, 2307021, '112A', NULL, 160000000),
-- Nhận lãi đầu tư (cao hơn trả lãi 1 chút)
(2307058, 2307022, '112A', 180000000, NULL),
(2307059, 2307022, 'B515', NULL, 180000000);

-- 8. Other activities
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES 
(2307023, '2023-07-15', 'Chi phí phạt vi phạm hợp đồng', 5, @period_id),
(2307024, '2023-07-20', 'Thu nhập từ bán phế liệu', 5, @period_id),
(2307025, '2023-07-25', 'Bán TSCĐ không còn sử dụng', 5, @period_id);

-- Entries for other activities
INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
-- Chi phí phạt
(2307060, 2307023, 'C811', 30000000, NULL),
(2307061, 2307023, '111A', NULL, 30000000),
-- Thu nhập phế liệu
(2307062, 2307024, '111A', 25000000, NULL),
(2307063, 2307024, 'C711', NULL, 25000000),
-- Bán TSCĐ (1.5% of 2,500,000,000)
(2307064, 2307025, '112A', 37500000, NULL),
(2307065, 2307025, '211B', NULL, 30000000),
(2307066, 2307025, '214B', NULL, 5000000),
(2307067, 2307025, 'C711', NULL, 12500000);

-- 9. Month-end closing entries
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES 
(2307026, '2023-07-31', 'Kết chuyển doanh thu và chi phí xác định kết quả kinh doanh', 5, @period_id),
(2307027, '2023-07-31', 'Hạch toán thuế TNDN', 5, @period_id),
(2307028, '2023-07-31', 'Kết chuyển thuế TNDN', 5, @period_id),
(2307029, '2023-07-31', 'Kết chuyển lợi nhuận sau thuế', 5, @period_id);

-- Calculate profit before tax
-- Revenue: 511 (927,000,000) + 515 (190,000,000) + 711 (37,500,000) = 1,154,500,000
-- Expenses: 632 (463,500,000) + 641 (139,050,000) + 642 (139,050,000) + 635 (160,000,000) + 811 (30,000,000) + 521 (3,000,000) = 934,600,000
-- Profit before tax: 1,154,500,000 - 934,600,000 = 219,900,000
-- Tax (20%): 43,980,000
-- Net profit: 175,920,000

-- Entries for closing
INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
-- Kết chuyển doanh thu
(2307068, 2307026, 'A511', 927000000, NULL),
(2307069, 2307026, 'B515', 190000000, NULL),
(2307070, 2307026, 'C711', 37500000, NULL),
(2307071, 2307026, 'D911', NULL, 1154500000),
-- Kết chuyển chi phí
(2307072, 2307026, 'D911', 934600000, NULL),
(2307073, 2307026, 'A632', NULL, 463500000),
(2307074, 2307026, 'A641', NULL, 139050000),
(2307075, 2307026, 'A642', NULL, 139050000),
(2307076, 2307026, 'B635', NULL, 160000000),
(2307077, 2307026, 'C811', NULL, 30000000),
(2307078, 2307026, 'A521', NULL, 3000000),
-- Hạch toán thuế TNDN
(2307079, 2307027, 'C821', 43980000, NULL),
(2307080, 2307027, '333A', NULL, 43980000),
-- Kết chuyển thuế TNDN
(2307081, 2307028, 'D911', 43980000, NULL),
(2307082, 2307028, 'C821', NULL, 43980000),
-- Kết chuyển lợi nhuận sau thuế
(2307083, 2307029, 'D911', 175920000, NULL),
(2307084, 2307029, '421B', NULL, 175920000);

-- 10. Cash flow activities
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `customer_id`, `supplier_id`) 
VALUES 
(2307030, '2023-07-05', 'Thu tiền từ khách hàng', 3, @period_id, 3, NULL),
(2307031, '2023-07-10', 'Trả tiền cho nhà cung cấp', 4, @period_id, NULL, 5),
(2307032, '2023-07-15', 'Trả lương nhân viên', 4, @period_id, NULL, NULL),
(2307033, '2023-07-20', 'Trả thuế TNDN', 4, @period_id, NULL, NULL),
(2307034, '2023-07-25', 'Trả nợ gốc vay ngắn hạn', 4, @period_id, NULL, NULL),
(2307035, '2023-07-28', 'Trả nợ gốc vay dài hạn', 4, @period_id, NULL, NULL),
(2307036, '2023-07-30', 'Chi trả cổ tức', 4, @period_id, NULL, NULL);

-- Entries for cash flow
INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
-- Thu tiền từ khách hàng (80% of 579,700,000)
(2307085, 2307030, '112A', 463760000, NULL),
(2307086, 2307030, '131A', NULL, 463760000),
-- Trả tiền nhà cung cấp (75% of 297,000,000)
(2307087, 2307031, '331A', 222750000, NULL),
(2307088, 2307031, '112A', NULL, 222750000),
-- Trả lương nhân viên (85% of 200,000,000)
(2307089, 2307032, '334A', 170000000, NULL),
(2307090, 2307032, '111A', NULL, 170000000),
-- Trả thuế TNDN (95% of 43,980,000)
(2307091, 2307033, '333A', 41781000, NULL),
(2307092, 2307033, '112A', NULL, 41781000),
-- Trả nợ gốc vay ngắn hạn (10% of 900,000,000)
(2307093, 2307034, '341A', 90000000, NULL),
(2307094, 2307034, '112A', NULL, 90000000),
-- Trả nợ gốc vay dài hạn (5% of 1,100,000,000)
(2307095, 2307035, '341B', 55000000, NULL),
(2307096, 2307035, '112A', NULL, 55000000),
-- Chi trả cổ tức (15% of 175,920,000)
(2307097, 2307036, '421B', 26388000, NULL),
(2307098, 2307036, '112A', NULL, 26388000);

-- FIX
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `customer_id`, `supplier_id`) 
VALUES (2307900, '2023-07-30', 'FIX', 5, @period_id, NULL, NULL);
INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES (2307900, 2307900, '211B', 85000000, NULL);

COMMIT;