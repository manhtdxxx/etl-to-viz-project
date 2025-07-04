START TRANSACTION;

-- Set transaction IDs for May 2022 (yymm format)
-- All transactions will be in period_id 1 (2022)
-- Using random customer_id and supplier_id between 1-20

-- 1. Capital mobilization and fixed asset investment (should be in Jan but doing for May as per requirement)

-- 2. Business operations
-- 2.1 Purchasing materials and tools (350 million total)
-- Purchase 1: Materials 150 million + VAT 15 million (cash)
INSERT INTO `journal_transaction` VALUES 
(2205005, '2022-05-03', 'Mua nguyên vật liệu trả tiền mặt', 2, 1, 3, NULL);

INSERT INTO `journal_entry` VALUES 
(2205013, 2205005, '152A', 150000000, NULL),
(2205014, 2205005, '133A', 15000000, NULL),
(2205015, 2205005, '111A', NULL, 165000000);

-- Purchase 2: Tools 120 million + VAT 12 million (bank transfer)
INSERT INTO `journal_transaction` VALUES 
(2205006, '2022-05-04', 'Mua công cụ dụng cụ chuyển khoản', 2, 1, 8, NULL);

INSERT INTO `journal_entry` VALUES 
(2205016, 2205006, '153A', 120000000, NULL),
(2205017, 2205006, '133A', 12000000, NULL),
(2205018, 2205006, '112A', NULL, 132000000);

-- Purchase 3: Materials 50 million + VAT 5 million (on credit - short term)
INSERT INTO `journal_transaction` VALUES 
(2205007, '2022-05-05', 'Mua nguyên vật liệu trả chậm ngắn hạn', 2, 1, 12, NULL);

INSERT INTO `journal_entry` VALUES 
(2205019, 2205007, '152A', 50000000, NULL),
(2205020, 2205007, '133A', 5000000, NULL),
(2205021, 2205007, '331A', NULL, 55000000);

-- Purchase 4: Tools 30 million + VAT 3 million (on credit - long term)
INSERT INTO `journal_transaction` VALUES 
(2205008, '2022-05-06', 'Mua công cụ dụng cụ trả chậm dài hạn', 2, 1, 15, NULL);

INSERT INTO `journal_entry` VALUES 
(2205022, 2205008, '153A', 30000000, NULL),
(2205023, 2205008, '133A', 3000000, NULL),
(2205024, 2205008, '331B', NULL, 33000000);

-- 2.2 Production activities
-- 2.2.1 Issue materials (85% of inventory)
INSERT INTO `journal_transaction` VALUES 
(2205009, '2022-05-07', 'Xuất kho nguyên vật liệu sản xuất', 5, 1, NULL, NULL);

INSERT INTO `journal_entry` VALUES 
(2205025, 2205009, 'A621', 170000000, NULL), -- (150+50)*85%
(2205026, 2205009, '152A', NULL, 170000000);

-- 2.2.2 Issue tools (90% of inventory)
INSERT INTO `journal_transaction` VALUES 
(2205010, '2022-05-08', 'Xuất kho công cụ dụng cụ sản xuất', 5, 1, NULL, NULL);

INSERT INTO `journal_entry` VALUES 
(2205027, 2205010, 'A627', 135000000, NULL), -- (120+30)*90%
(2205028, 2205010, '153A', NULL, 135000000);

-- 2.2.3 Depreciation (3% of fixed assets)
INSERT INTO `journal_transaction` VALUES 
(2205011, '2022-05-09', 'Trích khấu hao TSCĐ', 5, 1, NULL, NULL);

INSERT INTO `journal_entry` VALUES 
(2205029, 2205011, 'A627', 45000000, NULL), -- 1,500,000,000 * 3%
(2205030, 2205011, '214B', NULL, 45000000);

-- 2.2.4 Pay salaries (2x depreciation)
INSERT INTO `journal_transaction` VALUES 
(2205012, '2022-05-10', 'Trả lương nhân viên sản xuất', 5, 1, NULL, NULL);

INSERT INTO `journal_entry` VALUES 
(2205031, 2205012, 'A622', 90000000, NULL), -- 45,000,000 * 2
(2205032, 2205012, '334A', NULL, 90000000);

-- 2.3 Transfer production costs to WIP
INSERT INTO `journal_transaction` VALUES 
(2205013, '2022-05-15', 'Kết chuyển chi phí sản xuất', 5, 1, NULL, NULL);

INSERT INTO `journal_entry` VALUES 
(2205033, 2205013, '154A', 440000000, NULL), -- 170+135+45+90
(2205034, 2205013, 'A621', NULL, 170000000),
(2205035, 2205013, 'A622', NULL, 90000000),
(2205036, 2205013, 'A627', NULL, 180000000);

-- 2.4 Transfer WIP to finished goods
INSERT INTO `journal_transaction` VALUES 
(2205014, '2022-05-16', 'Nhập kho thành phẩm', 5, 1, NULL, NULL);

INSERT INTO `journal_entry` VALUES 
(2205037, 2205014, '155A', 440000000, NULL),
(2205038, 2205014, '154A', NULL, 440000000);

-- 2.5 Sales - Cost of goods sold (85% of inventory)
INSERT INTO `journal_transaction` VALUES 
(2205015, '2022-05-17', 'Xuất kho thành phẩm bán hàng', 1, 1, NULL, 7);

INSERT INTO `journal_entry` VALUES 
(2205039, 2205015, 'A632', 374000000, NULL), -- 440,000,000 * 85%
(2205040, 2205015, '155A', NULL, 374000000);

-- 2.6 Sales - Revenue (2x COGS)
INSERT INTO `journal_transaction` VALUES 
(2205016, '2022-05-18', 'Bán hàng ghi nhận doanh thu', 1, 1, NULL, 7);

INSERT INTO `journal_entry` VALUES 
(2205041, 2205016, '131A', 823680000, NULL), -- 374,000,000 * 2 * 1.1 (VAT)
(2205042, 2205016, 'A511', NULL, 748000000), -- 374,000,000 * 2
(2205043, 2205016, '333A', NULL, 75680000); -- 748,000,000 * 10%

-- 2.7 Sales - Revenue deduction (5% of revenue)
INSERT INTO `journal_transaction` VALUES 
(2205017, '2022-05-19', 'Giảm trừ doanh thu', 1, 1, NULL, 7);

INSERT INTO `journal_entry` VALUES 
(2205044, 2205017, 'A521', 37400000, NULL), -- 748,000,000 * 5%
(2205045, 2205017, '131A', NULL, 37400000);

-- 2.8 Sales - Operating expenses (25% of revenue)
INSERT INTO `journal_transaction` VALUES 
(2205018, '2022-05-20', 'Chi phí bán hàng và QLDN', 5, 1, NULL, NULL);

INSERT INTO `journal_entry` VALUES 
(2205046, 2205018, 'A641', 93500000, NULL), -- 748,000,000 * 12.5%
(2205047, 2205018, 'A642', 93500000, NULL), -- 748,000,000 * 12.5%
(2205048, 2205018, '334A', NULL, 100000000),
(2205049, 2205018, '111A', NULL, 50000000),
(2205050, 2205018, '112A', NULL, 37000000);

-- 3. Financial activities
-- 3.1 Purchase securities (short-term 100 million, long-term 150 million)
INSERT INTO `journal_transaction` VALUES 
(2205019, '2022-05-21', 'Mua chứng khoán ngắn hạn', 5, 1, NULL, NULL);

INSERT INTO `journal_entry` VALUES 
(2205051, 2205019, '121A', 100000000, NULL),
(2205052, 2205019, '112A', NULL, 100000000);

INSERT INTO `journal_transaction` VALUES 
(2205020, '2022-05-22', 'Mua chứng khoán dài hạn', 5, 1, NULL, NULL);

INSERT INTO `journal_entry` VALUES 
(2205053, 2205020, '121B', 150000000, NULL),
(2205054, 2205020, '112A', NULL, 150000000);

-- 3.2 Sell securities (short-term 80 million, long-term 100 million with profit)
INSERT INTO `journal_transaction` VALUES 
(2205021, '2022-05-23', 'Bán chứng khoán ngắn hạn', 5, 1, NULL, NULL);

INSERT INTO `journal_entry` VALUES 
(2205055, 2205021, '112A', 88000000, NULL), -- 80,000,000 + 10% profit
(2205056, 2205021, '121A', NULL, 80000000),
(2205057, 2205021, 'B515', NULL, 8000000);

INSERT INTO `journal_transaction` VALUES 
(2205022, '2022-05-24', 'Bán chứng khoán dài hạn', 5, 1, NULL, NULL);

INSERT INTO `journal_entry` VALUES 
(2205058, 2205022, '112A', 105000000, NULL), -- 100,000,000 + 5% profit
(2205059, 2205022, '121B', NULL, 100000000),
(2205060, 2205022, 'B515', NULL, 5000000);

-- 3.3 Pay loan interest (8% of total loans)
INSERT INTO `journal_transaction` VALUES 
(2205023, '2022-05-25', 'Trả lãi vay ngân hàng', 9, 1, NULL, NULL);

INSERT INTO `journal_entry` VALUES 
(2205061, 2205023, 'B635', 96000000, NULL), -- (700,000,000 + 500,000,000) * 8%
(2205062, 2205023, '112A', NULL, 96000000);

-- 3.4 Receive investment income (10% of investments)
INSERT INTO `journal_transaction` VALUES 
(2205024, '2022-05-26', 'Nhận lãi đầu tư chứng khoán', 5, 1, NULL, NULL);

INSERT INTO `journal_entry` VALUES 
(2205063, 2205024, '112A', 25000000, NULL), -- (100,000,000 + 150,000,000) * 10%
(2205064, 2205024, 'B515', NULL, 25000000);

-- 4. Other activities
-- 4.1 Other expenses (contract penalty)
INSERT INTO `journal_transaction` VALUES 
(2205025, '2022-05-27', 'Phạt vi phạm hợp đồng', 5, 1, NULL, NULL);

INSERT INTO `journal_entry` VALUES 
(2205065, 2205025, 'C811', 20000000, NULL),
(2205066, 2205025, '112A', NULL, 20000000);

-- 4.2 Other income (sell fixed assets 3%)
INSERT INTO `journal_transaction` VALUES 
(2205026, '2022-05-28', 'Bán TSCĐ', 5, 1, NULL, NULL);

INSERT INTO `journal_entry` VALUES 
(2205067, 2205026, '111A', 49500000, NULL), -- 1,500,000,000 * 3% * 1.1 (VAT)
(2205068, 2205026, '211B', NULL, 45000000), -- 1,500,000,000 * 3%
(2205069, 2205026, 'C711', NULL, 45000000);

-- 5. Month-end closing entries
-- 5.1 Transfer all expenses to 911
INSERT INTO `journal_transaction` VALUES 
(2205027, '2022-05-31', 'Kết chuyển chi phí', 5, 1, NULL, NULL);

INSERT INTO `journal_entry` VALUES 
(2205070, 2205027, 'D911', 744400000, NULL), -- 374+37.4+93.5+93.5+96+20
(2205071, 2205027, 'A632', NULL, 374000000),
(2205072, 2205027, 'A521', NULL, 37400000),
(2205073, 2205027, 'A641', NULL, 93500000),
(2205074, 2205027, 'A642', NULL, 93500000),
(2205075, 2205027, 'B635', NULL, 96000000),
(2205076, 2205027, 'C811', NULL, 20000000);

-- 5.2 Transfer all revenues to 911
INSERT INTO `journal_transaction` VALUES 
(2205028, '2022-05-31', 'Kết chuyển doanh thu', 5, 1, NULL, NULL);

INSERT INTO `journal_entry` VALUES 
(2205077, 2205028, 'A511', 748000000, NULL),
(2205078, 2205028, 'B515', 18000000, NULL), -- 8+5+25
(2205079, 2205028, 'C711', 45000000, NULL),
(2205080, 2205028, 'D911', NULL, 811000000);

-- 5.3 Calculate corporate income tax (20% of profit)
-- Profit before tax = 811,000,000 - 744,400,000 = 66,600,000
-- Tax = 66,600,000 * 20% = 13,320,000
INSERT INTO `journal_transaction` VALUES 
(2205029, '2022-05-31', 'Tính thuế TNDN', 8, 1, NULL, NULL);

INSERT INTO `journal_entry` VALUES 
(2205081, 2205029, 'C821', 13320000, NULL),
(2205082, 2205029, '333A', NULL, 13320000);

-- 5.4 Transfer tax to 911
INSERT INTO `journal_transaction` VALUES 
(2205030, '2022-05-31', 'Kết chuyển thuế TNDN', 5, 1, NULL, NULL);

INSERT INTO `journal_entry` VALUES 
(2205083, 2205030, 'D911', 13320000, NULL),
(2205084, 2205030, 'C821', NULL, 13320000);

-- 5.5 Calculate and transfer net profit
-- Net profit = 66,600,000 - 13,320,000 = 53,280,000
INSERT INTO `journal_transaction` VALUES 
(2205031, '2022-05-31', 'Kết chuyển lợi nhuận', 5, 1, NULL, NULL);

INSERT INTO `journal_entry` VALUES 
(2205085, 2205031, 'D911', 53280000, NULL),
(2205086, 2205031, '421B', NULL, 53280000);

-- 6. Cash flow activities
-- 6.1 Pay dividends (30% of net profit)
INSERT INTO `journal_transaction` VALUES 
(2205032, '2022-05-31', 'Chi trả cổ tức', 4, 1, NULL, NULL);

INSERT INTO `journal_entry` VALUES 
(2205087, 2205032, '421B', 15984000, NULL), -- 53,280,000 * 30%
(2205088, 2205032, '111A', NULL, 15984000);

-- 6.2 Collect from customers (80% of receivables)
INSERT INTO `journal_transaction` VALUES 
(2205033, '2022-05-31', 'Thu tiền khách hàng', 3, 1, NULL, 7);

INSERT INTO `journal_entry` VALUES 
(2205089, 2205033, '112A', 629344000, NULL), -- (823,680,000 - 37,400,000) * 80%
(2205090, 2205033, '131A', NULL, 629344000);

-- 6.3 Pay suppliers (75% of payables)
INSERT INTO `journal_transaction` VALUES 
(2205034, '2022-05-31', 'Trả tiền nhà cung cấp', 4, 1, 12, NULL);

INSERT INTO `journal_entry` VALUES 
(2205091, 2205034, '331A', 41250000, NULL), -- 55,000,000 * 75%
(2205092, 2205034, '112A', NULL, 41250000);

INSERT INTO `journal_transaction` VALUES 
(2205035, '2022-05-31', 'Trả tiền nhà cung cấp', 4, 1, 15, NULL);

INSERT INTO `journal_entry` VALUES 
(2205093, 2205035, '331B', 24750000, NULL), -- 33,000,000 * 75%
(2205094, 2205035, '112A', NULL, 24750000);

-- 6.4 Pay taxes (90% of tax payable)
INSERT INTO `journal_transaction` VALUES 
(2205036, '2022-05-31', 'Nộp thuế TNDN', 4, 1, NULL, NULL);

INSERT INTO `journal_entry` VALUES 
(2205095, 2205036, '333A', 11988000, NULL), -- 13,320,000 * 90%
(2205096, 2205036, '111A', NULL, 11988000);

-- 6.5 Pay salaries (85% of salary payable)
INSERT INTO `journal_transaction` VALUES 
(2205037, '2022-05-31', 'Trả lương nhân viên', 4, 1, NULL, NULL);

INSERT INTO `journal_entry` VALUES 
(2205097, 2205037, '334A', 161500000, NULL), -- (90,000,000 + 100,000,000 - some already paid) * 85%
(2205098, 2205037, '111A', NULL, 100000000),
(2205099, 2205037, '112A', NULL, 61500000);

-- 6.6 Repay short-term loan principal (10% of short-term loan)
INSERT INTO `journal_transaction` VALUES 
(2205038, '2022-05-31', 'Trả nợ gốc vay ngắn hạn', 4, 1, NULL, NULL);

INSERT INTO `journal_entry` VALUES 
(2205100, 2205038, '341A', 70000000, NULL), -- 700,000,000 * 10%
(2205101, 2205038, '112A', NULL, 70000000);

-- 6.7 Repay long-term loan principal (5% of long-term loan)
INSERT INTO `journal_transaction` VALUES 
(2205039, '2022-05-31', 'Trả nợ gốc vay dài hạn', 4, 1, NULL, NULL);

INSERT INTO `journal_entry` VALUES 
(2205102, 2205039, '341B', 25000000, NULL), -- 500,000,000 * 5%
(2205103, 2205039, '112A', NULL, 25000000);


-- FIX
INSERT INTO `journal_transaction` VALUES 
(2205900, '2022-05-31', 'FIX', 5, 1, NULL, NULL);

INSERT INTO `journal_entry` VALUES 
(2205900, 2205900, '341A', NULL, 9500000);

COMMIT;