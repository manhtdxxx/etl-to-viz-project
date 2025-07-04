START TRANSACTION;

-- Set period_id for 2024 (3)
SET @period_id = 3;

-- Set base transaction and entry IDs for July 2024 (2407...)
SET @trans_base = 2407000;
SET @entry_base = 2407000;

-- 1. Capital mobilization and fixed asset investment (only in January, but we'll record in July for this example)

-- 2. Business operations
-- a. Purchasing materials and tools (total 350 million)
INSERT INTO `journal_transaction` VALUES 
(@trans_base+5, '2024-07-03', 'Mua nguyên vật liệu', 2, @period_id, 8, NULL);

INSERT INTO `journal_entry` VALUES
(@entry_base+13, @trans_base+5, '152A', 200000000, NULL),
(@entry_base+14, @trans_base+5, '153A', 100000000, NULL),
(@entry_base+15, @trans_base+5, '133A', 50000000, NULL),
(@entry_base+16, @trans_base+5, '331A', NULL, 350000000);

-- b. Production activities
-- i. Issue materials (90% of inventory)
INSERT INTO `journal_transaction` VALUES 
(@trans_base+6, '2024-07-05', 'Xuất kho nguyên vật liệu', 5, @period_id, NULL, NULL);

INSERT INTO `journal_entry` VALUES
(@entry_base+17, @trans_base+6, 'A621', 180000000, NULL),
(@entry_base+18, @trans_base+6, 'A627', 20000000, NULL),
(@entry_base+19, @trans_base+6, '152A', NULL, 180000000),
(@entry_base+20, @trans_base+6, '153A', NULL, 20000000);

-- ii. Depreciation (3% of fixed assets = 105 million)
INSERT INTO `journal_transaction` VALUES 
(@trans_base+7, '2024-07-06', 'Trích khấu hao TSCĐ', 5, @period_id, NULL, NULL);

INSERT INTO `journal_entry` VALUES
(@entry_base+21, @trans_base+7, 'A627', 105000000, NULL),
(@entry_base+22, @trans_base+7, '214B', NULL, 105000000);

-- iii. Pay salaries (2x depreciation = 210 million)
INSERT INTO `journal_transaction` VALUES 
(@trans_base+8, '2024-07-07', 'Trả lương nhân viên', 5, @period_id, NULL, NULL);

INSERT INTO `journal_entry` VALUES
(@entry_base+23, @trans_base+8, 'A622', 210000000, NULL),
(@entry_base+24, @trans_base+8, '334A', NULL, 210000000);

-- c. Finished goods inventory
-- Transfer production costs to WIP (154)
INSERT INTO `journal_transaction` VALUES 
(@trans_base+9, '2024-07-10', 'Kết chuyển chi phí sản xuất', 5, @period_id, NULL, NULL);

INSERT INTO `journal_entry` VALUES
(@entry_base+25, @trans_base+9, '154A', 180000000, NULL), -- Materials
(@entry_base+26, @trans_base+9, '154A', 210000000, NULL), -- Labor
(@entry_base+27, @trans_base+9, '154A', 125000000, NULL), -- Overhead (depreciation + tools)
(@entry_base+28, @trans_base+9, 'A621', NULL, 180000000),
(@entry_base+29, @trans_base+9, 'A622', NULL, 210000000),
(@entry_base+30, @trans_base+9, 'A627', NULL, 125000000);

-- Transfer WIP to finished goods (155)
INSERT INTO `journal_transaction` VALUES 
(@trans_base+10, '2024-07-10', 'Nhập kho thành phẩm', 5, @period_id, NULL, NULL);

INSERT INTO `journal_entry` VALUES
(@entry_base+31, @trans_base+10, '155A', 515000000, NULL),
(@entry_base+32, @trans_base+10, '154A', NULL, 515000000);

-- d. Sales recording COGS (90% of finished goods = 463.5 million)
INSERT INTO `journal_transaction` VALUES 
(@trans_base+11, '2024-07-15', 'Ghi nhận giá vốn hàng bán', 1, @period_id, NULL, 7);

INSERT INTO `journal_entry` VALUES
(@entry_base+33, @trans_base+11, 'A632', 463500000, NULL),
(@entry_base+34, @trans_base+11, '155A', NULL, 463500000);

-- e. Sales recording revenue (2x COGS = 927 million)
INSERT INTO `journal_transaction` VALUES 
(@trans_base+12, '2024-07-15', 'Ghi nhận doanh thu bán hàng', 1, @period_id, NULL, 7);

INSERT INTO `journal_entry` VALUES
(@entry_base+35, @trans_base+12, '112A', 700000000, NULL),
(@entry_base+36, @trans_base+12, '131A', 227000000, NULL),
(@entry_base+37, @trans_base+12, 'A521', 50000000, NULL), -- Sales discounts
(@entry_base+38, @trans_base+12, '333A', NULL, 92700000), -- VAT 10%
(@entry_base+39, @trans_base+12, 'A511', NULL, 877000000); -- Net revenue

-- f. Sales and administrative expenses (15% of revenue each = 131.55 million each)
INSERT INTO `journal_transaction` VALUES 
(@trans_base+13, '2024-07-20', 'Chi phí bán hàng và QLDN', 5, @period_id, NULL, NULL);

INSERT INTO `journal_entry` VALUES
(@entry_base+40, @trans_base+13, 'A641', 131550000, NULL),
(@entry_base+41, @trans_base+13, 'A642', 131550000, NULL),
(@entry_base+42, @trans_base+13, '334A', NULL, 100000000), -- Salaries
(@entry_base+43, @trans_base+13, '111A', NULL, 100000000), -- Cash expenses
(@entry_base+44, @trans_base+13, '331A', NULL, 63100000); -- Payables

-- 3. Financial activities
-- a. Buy securities (120 million)
INSERT INTO `journal_transaction` VALUES 
(@trans_base+14, '2024-07-21', 'Mua chứng khoán', 5, @period_id, NULL, NULL);

INSERT INTO `journal_entry` VALUES
(@entry_base+45, @trans_base+14, '121A', 120000000, NULL),
(@entry_base+46, @trans_base+14, '112A', NULL, 120000000);

-- b. Sell securities (100 million, profit 10 million)
INSERT INTO `journal_transaction` VALUES 
(@trans_base+15, '2024-07-22', 'Bán chứng khoán', 5, @period_id, NULL, NULL);

INSERT INTO `journal_entry` VALUES
(@entry_base+47, @trans_base+15, '112A', 110000000, NULL),
(@entry_base+48, @trans_base+15, '121A', NULL, 100000000),
(@entry_base+49, @trans_base+15, 'B515', NULL, 10000000);

-- c. Pay bank interest (7% of total loans = 161 million)
INSERT INTO `journal_transaction` VALUES 
(@trans_base+16, '2024-07-23', 'Trả lãi vay ngân hàng', 9, @period_id, NULL, NULL);

INSERT INTO `journal_entry` VALUES
(@entry_base+50, @trans_base+16, 'B635', 161000000, NULL),
(@entry_base+51, @trans_base+16, '112A', NULL, 161000000);

-- d. Receive investment income (170 million)
INSERT INTO `journal_transaction` VALUES 
(@trans_base+17, '2024-07-24', 'Nhận lãi đầu tư', 5, @period_id, NULL, NULL);

INSERT INTO `journal_entry` VALUES
(@entry_base+52, @trans_base+17, '112A', 170000000, NULL),
(@entry_base+53, @trans_base+17, 'B515', NULL, 170000000);

-- 4. Other activities
-- a. Other expenses (penalties) - 20 million
INSERT INTO `journal_transaction` VALUES 
(@trans_base+18, '2024-07-25', 'Phạt vi phạm hợp đồng', 5, @period_id, NULL, NULL);

INSERT INTO `journal_entry` VALUES
(@entry_base+54, @trans_base+18, 'C811', 20000000, NULL),
(@entry_base+55, @trans_base+18, '111A', NULL, 20000000);

-- b. Other income (sell fixed assets - 35 million)
INSERT INTO `journal_transaction` VALUES 
(@trans_base+19, '2024-07-26', 'Bán TSCĐ', 5, @period_id, NULL, NULL);

INSERT INTO `journal_entry` VALUES
(@entry_base+56, @trans_base+19, '112A', 35000000, NULL),
(@entry_base+57, @trans_base+19, 'C711', NULL, 35000000);

-- 5. Month-end closing entries
-- a. Transfer all expenses to 911
INSERT INTO `journal_transaction` VALUES 
(@trans_base+20, '2024-07-31', 'Kết chuyển chi phí', 5, @period_id, NULL, NULL);

INSERT INTO `journal_entry` VALUES
(@entry_base+58, @trans_base+20, 'D911', 463500000, NULL), -- COGS
(@entry_base+59, @trans_base+20, 'D911', 131550000, NULL), -- Selling expenses
(@entry_base+60, @trans_base+20, 'D911', 131550000, NULL), -- Admin expenses
(@entry_base+61, @trans_base+20, 'D911', 161000000, NULL), -- Financial expenses
(@entry_base+62, @trans_base+20, 'D911', 20000000, NULL), -- Other expenses
(@entry_base+63, @trans_base+20, 'D911', 50000000, NULL), -- Sales discounts
(@entry_base+64, @trans_base+20, 'A632', NULL, 463500000),
(@entry_base+65, @trans_base+20, 'A641', NULL, 131550000),
(@entry_base+66, @trans_base+20, 'A642', NULL, 131550000),
(@entry_base+67, @trans_base+20, 'B635', NULL, 161000000),
(@entry_base+68, @trans_base+20, 'C811', NULL, 20000000),
(@entry_base+69, @trans_base+20, 'A521', NULL, 50000000);

-- b. Transfer all revenues to 911
INSERT INTO `journal_transaction` VALUES 
(@trans_base+21, '2024-07-31', 'Kết chuyển doanh thu', 5, @period_id, NULL, NULL);

INSERT INTO `journal_entry` VALUES
(@entry_base+70, @trans_base+21, 'A511', 877000000, NULL),
(@entry_base+71, @trans_base+21, 'B515', 180000000, NULL),
(@entry_base+72, @trans_base+21, 'C711', 35000000, NULL),
(@entry_base+73, @trans_base+21, 'D911', NULL, 877000000),
(@entry_base+74, @trans_base+21, 'D911', NULL, 180000000),
(@entry_base+75, @trans_base+21, 'D911', NULL, 35000000);

-- Calculate profit before tax (1,092,000 - 958,100 = 133,900)
-- Income tax (20% = 26,780)
INSERT INTO `journal_transaction` VALUES 
(@trans_base+22, '2024-07-31', 'Tính thuế TNDN', 8, @period_id, NULL, NULL);

INSERT INTO `journal_entry` VALUES
(@entry_base+76, @trans_base+22, 'C821', 26780000, NULL),
(@entry_base+77, @trans_base+22, '333A', NULL, 26780000);

-- Transfer tax to 911
INSERT INTO `journal_transaction` VALUES 
(@trans_base+23, '2024-07-31', 'Kết chuyển thuế TNDN', 5, @period_id, NULL, NULL);

INSERT INTO `journal_entry` VALUES
(@entry_base+78, @trans_base+23, 'D911', 26780000, NULL),
(@entry_base+79, @trans_base+23, 'C821', NULL, 26780000);

-- Calculate net profit and transfer to retained earnings (133,900 - 26,780 = 107,120)
INSERT INTO `journal_transaction` VALUES 
(@trans_base+24, '2024-07-31', 'Kết chuyển lợi nhuận', 5, @period_id, NULL, NULL);

INSERT INTO `journal_entry` VALUES
(@entry_base+80, @trans_base+24, 'D911', 107120000, NULL),
(@entry_base+81, @trans_base+24, '421B', NULL, 107120000);

-- 6. Cash flow activities
-- a. Pay dividends (15% of net profit = 16.068 million)
INSERT INTO `journal_transaction` VALUES 
(@trans_base+25, '2024-07-31', 'Chi trả cổ tức', 4, @period_id, NULL, NULL);

INSERT INTO `journal_entry` VALUES
(@entry_base+82, @trans_base+25, '421B', 16068000, NULL),
(@entry_base+83, @trans_base+25, '111A', NULL, 16068000);

-- b. Collect from customers (80% of receivables = 181.6 million)
INSERT INTO `journal_transaction` VALUES 
(@trans_base+26, '2024-07-31', 'Thu tiền khách hàng', 3, @period_id, NULL, 7);

INSERT INTO `journal_entry` VALUES
(@entry_base+84, @trans_base+26, '112A', 181600000, NULL),
(@entry_base+85, @trans_base+26, '131A', NULL, 181600000);

-- c. Pay suppliers (85% of payables = 297.5 + 53.635 = 351.135 million)
INSERT INTO `journal_transaction` VALUES 
(@trans_base+27, '2024-07-31', 'Trả tiền nhà cung cấp', 4, @period_id, 8, NULL);

INSERT INTO `journal_entry` VALUES
(@entry_base+86, @trans_base+27, '331A', 297500000, NULL), -- Materials
(@entry_base+87, @trans_base+27, '331A', 53635000, NULL), -- Expenses
(@entry_base+88, @trans_base+27, '112A', NULL, 351135000);

-- d. Pay taxes (90% = 24.102 million)
INSERT INTO `journal_transaction` VALUES 
(@trans_base+28, '2024-07-31', 'Nộp thuế TNDN', 4, @period_id, NULL, NULL);

INSERT INTO `journal_entry` VALUES
(@entry_base+89, @trans_base+28, '333A', 24102000, NULL),
(@entry_base+90, @trans_base+28, '112A', NULL, 24102000);

-- e. Pay salaries (90% = 189 million)
INSERT INTO `journal_transaction` VALUES 
(@trans_base+29, '2024-07-31', 'Trả lương nhân viên', 4, @period_id, NULL, NULL);

INSERT INTO `journal_entry` VALUES
(@entry_base+91, @trans_base+29, '334A', 189000000, NULL),
(@entry_base+92, @trans_base+29, '111A', NULL, 189000000);

-- f. Repay short-term loan principal (12% = 72 million)
INSERT INTO `journal_transaction` VALUES 
(@trans_base+30, '2024-07-31', 'Trả nợ gốc vay ngắn hạn', 4, @period_id, NULL, NULL);

INSERT INTO `journal_entry` VALUES
(@entry_base+93, @trans_base+30, '341A', 72000000 - 7800000, NULL), -- FIX
(@entry_base+94, @trans_base+30, '112A', NULL, 72000000);

-- g. Repay long-term loan principal (6% = 84 million)
INSERT INTO `journal_transaction` VALUES 
(@trans_base+31, '2024-07-31', 'Trả nợ gốc vay dài hạn', 4, @period_id, NULL, NULL);

INSERT INTO `journal_entry` VALUES
(@entry_base+95, @trans_base+31, '341B', 84000000, NULL),
(@entry_base+96, @trans_base+31, '112A', NULL, 84000000);

COMMIT;