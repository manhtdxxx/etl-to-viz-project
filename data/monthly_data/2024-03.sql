START TRANSACTION;

-- Capital raising and fixed asset investment (March is not month 1, so skipping these)
-- These activities should only be recorded in January according to requirements

-- Purchase of materials (with VAT) - paid by cash
INSERT INTO `journal_transaction` VALUES (2403000, '2024-03-05', 'Mua nguyên vật liệu trả bằng tiền mặt', 2, 3, 5, NULL);
INSERT INTO `journal_entry` VALUES 
(2403000, 2403000, '152A', 180000000, NULL),
(2403001, 2403000, '133A', 18000000, NULL),
(2403002, 2403000, '111A', NULL, 198000000);

-- Purchase of tools (with VAT) - on credit (short-term)
INSERT INTO `journal_transaction` VALUES (2403001, '2024-03-06', 'Mua công cụ dụng cụ trả chậm', 2, 3, 12, NULL);
INSERT INTO `journal_entry` VALUES 
(2403003, 2403001, '153A', 120000000, NULL),
(2403004, 2403001, '133A', 12000000, NULL),
(2403005, 2403001, '331A', NULL, 132000000);

-- Issue materials to production (90% of purchased materials)
INSERT INTO `journal_transaction` VALUES (2403002, '2024-03-07', 'Xuất kho nguyên vật liệu sản xuất', 5, 3, NULL, NULL);
INSERT INTO `journal_entry` VALUES 
(2403006, 2403002, 'A621', 162000000, NULL),
(2403007, 2403002, '152A', NULL, 162000000);

-- Issue tools to production (85% of purchased tools)
INSERT INTO `journal_transaction` VALUES (2403003, '2024-03-07', 'Xuất kho công cụ dụng cụ sản xuất', 5, 3, NULL, NULL);
INSERT INTO `journal_entry` VALUES 
(2403008, 2403003, 'A627', 102000000, NULL),
(2403009, 2403003, '153A', NULL, 102000000);

-- Depreciation of fixed assets (3% of 3,500 million)
INSERT INTO `journal_transaction` VALUES (2403004, '2024-03-08', 'Trích khấu hao TSCĐ', 5, 3, NULL, NULL);
INSERT INTO `journal_entry` VALUES 
(2403010, 2403004, 'A627', 105000000, NULL),
(2403011, 2403004, '214B', NULL, 105000000);

-- Payroll expenses (2x depreciation)
INSERT INTO `journal_transaction` VALUES (2403005, '2024-03-10', 'Trả lương nhân viên sản xuất', 5, 3, NULL, NULL);
INSERT INTO `journal_entry` VALUES 
(2403012, 2403005, 'A622', 210000000, NULL),
(2403013, 2403005, '334A', NULL, 210000000);

-- Transfer production costs to WIP
INSERT INTO `journal_transaction` VALUES (2403006, '2024-03-15', 'Kết chuyển chi phí sản xuất', 5, 3, NULL, NULL);
INSERT INTO `journal_entry` VALUES 
(2403014, 2403006, '154A', 477000000, NULL),
(2403015, 2403006, 'A621', NULL, 162000000),
(2403016, 2403006, 'A622', NULL, 210000000),
(2403017, 2403006, 'A627', NULL, 105000000);

-- Transfer WIP to finished goods
INSERT INTO `journal_transaction` VALUES (2403007, '2024-03-16', 'Nhập kho thành phẩm', 5, 3, NULL, NULL);
INSERT INTO `journal_entry` VALUES 
(2403018, 2403007, '155A', 477000000, NULL),
(2403019, 2403007, '154A', NULL, 477000000);

-- Record cost of goods sold (90% of finished goods)
INSERT INTO `journal_transaction` VALUES (2403008, '2024-03-18', 'Xuất kho thành phẩm bán', 1, 3, NULL, 8);
INSERT INTO `journal_entry` VALUES 
(2403020, 2403008, 'A632', 429300000, NULL),
(2403021, 2403008, '155A', NULL, 429300000);

-- Record sales revenue (2.2x COGS)
INSERT INTO `journal_transaction` VALUES (2403009, '2024-03-18', 'Bán hàng thu tiền ngay một phần', 1, 3, NULL, 8);
INSERT INTO `journal_entry` VALUES 
(2403022, 2403009, '112A', 600000000, NULL),
(2403023, 2403009, '131A', 344460000, NULL),
(2403024, 2403009, 'A511', NULL, 900000000),
(2403025, 2403009, '333A', NULL, 44460000);

-- Sales returns (2% of revenue)
INSERT INTO `journal_transaction` VALUES (2403010, '2024-03-19', 'Hàng bán bị trả lại', 1, 3, NULL, 8);
INSERT INTO `journal_entry` VALUES 
(2403026, 2403010, 'A521', 18000000, NULL),
(2403027, 2403010, '131A', NULL, 18000000);

-- Record selling expenses (15% of revenue)
INSERT INTO `journal_transaction` VALUES (2403011, '2024-03-20', 'Chi phí bán hàng', 5, 3, NULL, NULL);
INSERT INTO `journal_entry` VALUES 
(2403028, 2403011, 'A641', 132300000, NULL),
(2403029, 2403011, '334A', NULL, 132300000);

-- Record administrative expenses (15% of revenue)
INSERT INTO `journal_transaction` VALUES (2403012, '2024-03-21', 'Chi phí quản lý doanh nghiệp', 5, 3, NULL, NULL);
INSERT INTO `journal_entry` VALUES 
(2403030, 2403012, 'A642', 132300000, NULL),
(2403031, 2403012, '334A', NULL, 132300000);

-- Purchase securities (short-term)
INSERT INTO `journal_transaction` VALUES (2403013, '2024-03-22', 'Mua chứng khoán ngắn hạn', 5, 3, NULL, NULL);
INSERT INTO `journal_entry` VALUES 
(2403032, 2403013, '121A', 250000000, NULL),
(2403033, 2403013, '112A', NULL, 250000000);

-- Sell securities (80% of purchased, with profit)
INSERT INTO `journal_transaction` VALUES (2403014, '2024-03-23', 'Bán chứng khoán ngắn hạn', 5, 3, NULL, NULL);
INSERT INTO `journal_entry` VALUES 
(2403034, 2403014, '112A', 220000000, NULL),
(2403035, 2403014, '121A', NULL, 200000000),
(2403036, 2403014, 'B515', NULL, 20000000);

-- Pay bank loan interest (7% of total loans)
INSERT INTO `journal_transaction` VALUES (2403015, '2024-03-24', 'Trả lãi vay ngân hàng', 9, 3, NULL, NULL);
INSERT INTO `journal_entry` VALUES 
(2403037, 2403015, 'B635', 133000000, NULL),
(2403038, 2403015, '112A', NULL, 133000000);

-- Receive investment income
INSERT INTO `journal_transaction` VALUES (2403016, '2024-03-25', 'Nhận lãi đầu tư', 5, 3, NULL, NULL);
INSERT INTO `journal_entry` VALUES 
(2403039, 2403016, '112A', 140000000, NULL),
(2403040, 2403016, 'B515', NULL, 140000000);

-- Other expenses (penalty)
INSERT INTO `journal_transaction` VALUES (2403017, '2024-03-26', 'Phạt vi phạm hợp đồng', 5, 3, NULL, NULL);
INSERT INTO `journal_entry` VALUES 
(2403041, 2403017, 'C811', 15000000, NULL),
(2403042, 2403017, '111A', NULL, 15000000);

-- Other income (sell fixed asset - 1% of total)
INSERT INTO `journal_transaction` VALUES (2403018, '2024-03-27', 'Bán TSCĐ', 5, 3, NULL, NULL);
INSERT INTO `journal_entry` VALUES 
(2403043, 2403018, '112A', 35000000, NULL),
(2403044, 2403018, '211B', NULL, 25000000),
(2403045, 2403018, '214B', NULL, 5000000),
(2403046, 2403018, 'C711', NULL, 5000000);

-- Close revenue and expense accounts at month-end
-- Transfer all expenses to 911
INSERT INTO `journal_transaction` VALUES (2403019, '2024-03-31', 'Kết chuyển chi phí', 5, 3, NULL, NULL);
INSERT INTO `journal_entry` VALUES 
(2403047, 2403019, 'D911', 429300000, NULL), -- COGS
(2403048, 2403019, 'A632', NULL, 429300000),
(2403049, 2403019, 'D911', 132300000, NULL), -- Selling expense
(2403050, 2403019, 'A641', NULL, 132300000),
(2403051, 2403019, 'D911', 132300000, NULL), -- Admin expense
(2403052, 2403019, 'A642', NULL, 132300000),
(2403053, 2403019, 'D911', 133000000, NULL), -- Financial expense
(2403054, 2403019, 'B635', NULL, 133000000),
(2403055, 2403019, 'D911', 15000000, NULL), -- Other expense
(2403056, 2403019, 'C811', NULL, 15000000),
(2403057, 2403019, 'D911', 18000000, NULL), -- Sales returns
(2403058, 2403019, 'A521', NULL, 18000000);

-- Transfer all revenues to 911
INSERT INTO `journal_transaction` VALUES (2403020, '2024-03-31', 'Kết chuyển doanh thu', 5, 3, NULL, NULL);
INSERT INTO `journal_entry` VALUES 
(2403059, 2403020, 'A511', 900000000, NULL),
(2403060, 2403020, 'D911', NULL, 900000000),
(2403061, 2403020, 'B515', 160000000, NULL),
(2403062, 2403020, 'D911', NULL, 160000000),
(2403063, 2403020, 'C711', 5000000, NULL),
(2403064, 2403020, 'D911', NULL, 5000000);

-- Calculate and record income tax (20% of profit)
-- Profit before tax = (900,000,000 + 160,000,000 + 5,000,000) - (429,300,000 + 132,300,000 + 132,300,000 + 133,000,000 + 15,000,000 + 18,000,000) = 1,065,000,000 - 859,900,000 = 205,100,000
-- Tax = 205,100,000 * 20% = 41,020,000
INSERT INTO `journal_transaction` VALUES (2403021, '2024-03-31', 'Hạch toán thuế TNDN', 8, 3, NULL, NULL);
INSERT INTO `journal_entry` VALUES 
(2403065, 2403021, 'C821', 41020000, NULL),
(2403066, 2403021, '333A', NULL, 41020000);

-- Transfer tax expense to 911
INSERT INTO `journal_transaction` VALUES (2403022, '2024-03-31', 'Kết chuyển thuế TNDN', 5, 3, NULL, NULL);
INSERT INTO `journal_entry` VALUES 
(2403067, 2403022, 'D911', 41020000, NULL),
(2403068, 2403022, 'C821', NULL, 41020000);

-- Transfer net profit to retained earnings (205,100,000 - 41,020,000 = 164,080,000)
INSERT INTO `journal_transaction` VALUES (2403023, '2024-03-31', 'Kết chuyển lợi nhuận', 5, 3, NULL, NULL);
INSERT INTO `journal_entry` VALUES 
(2403069, 2403023, 'D911', 164080000, NULL),
(2403070, 2403023, '421B', NULL, 164080000);

-- Pay dividends (15% of net profit)
INSERT INTO `journal_transaction` VALUES (2403024, '2024-03-31', 'Chi trả cổ tức', 4, 3, NULL, NULL);
INSERT INTO `journal_entry` VALUES 
(2403071, 2403024, '421B', 24612000, NULL),
(2403072, 2403024, '112A', NULL, 24612000);

-- Collect from customers (80% of receivables)
INSERT INTO `journal_transaction` VALUES (2403025, '2024-03-31', 'Thu tiền khách hàng', 3, 3, NULL, 8);
INSERT INTO `journal_entry` VALUES 
(2403073, 2403025, '112A', 261168000, NULL),
(2403074, 2403025, '131A', NULL, 261168000);

-- Pay suppliers (75% of payables)
INSERT INTO `journal_transaction` VALUES (2403026, '2024-03-31', 'Trả tiền nhà cung cấp', 4, 3, 12, NULL);
INSERT INTO `journal_entry` VALUES 
(2403075, 2403026, '331A', 99000000, NULL),
(2403076, 2403026, '112A', NULL, 99000000);

-- Pay taxes (90% of tax payable)
INSERT INTO `journal_transaction` VALUES (2403027, '2024-03-31', 'Nộp thuế TNDN', 4, 3, NULL, NULL);
INSERT INTO `journal_entry` VALUES 
(2403077, 2403027, '333A', 36918000, NULL),
(2403078, 2403027, '112A', NULL, 36918000);

-- Pay salaries (85% of salary payable)
INSERT INTO `journal_transaction` VALUES (2403028, '2024-03-31', 'Trả lương nhân viên', 4, 3, NULL, NULL);
INSERT INTO `journal_entry` VALUES 
(2403079, 2403028, '334A', 290955000, NULL),
(2403080, 2403028, '111A', NULL, 290955000);

-- Repay short-term loan principal (12% of short-term loan)
INSERT INTO `journal_transaction` VALUES (2403029, '2024-03-31', 'Trả nợ gốc vay ngắn hạn', 4, 3, NULL, NULL);
INSERT INTO `journal_entry` VALUES 
(2403081, 2403029, '341A', 72000000, NULL),
(2403082, 2403029, '112A', NULL, 72000000);

-- Repay long-term loan principal (6% of long-term loan)
INSERT INTO `journal_transaction` VALUES (2403030, '2024-03-31', 'Trả nợ gốc vay dài hạn', 4, 3, NULL, NULL);
INSERT INTO `journal_entry` VALUES 
(2403083, 2403030, '341B', 84000000, NULL),
(2403084, 2403030, '112A', NULL, 84000000);


-- FIX
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `customer_id`, `supplier_id`) 
VALUES (2403900, '2024-03-30', 'FIX', 5, @period_id, NULL, NULL);
INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES (2403900, 2403900, '211B', 102000000, NULL);

COMMIT;