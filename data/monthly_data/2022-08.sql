START TRANSACTION;

-- Set period_id for 2022 (1)
SET @period_id = 1;

-- Set base transaction and entry IDs for August 2022 (yymm = 2208)
SET @base_trans_id = 2208000;
SET @base_entry_id = 2208000;

-- 1. Capital mobilization and fixed asset investment (only in January, so skipping for August)

-- 2. Business operations

-- 2.1 Purchasing activities (buying materials and tools)
-- Transaction 1: Purchase materials on credit (with VAT)
INSERT INTO `journal_transaction` VALUES 
(@base_trans_id+1, '2022-08-05', 'Mua nguyên vật liệu từ nhà cung cấp A', 2, @period_id, 5, NULL);

INSERT INTO `journal_entry` VALUES
(@base_entry_id+1, @base_trans_id+1, '152A', 150000000, NULL),  -- Materials
(@base_entry_id+2, @base_trans_id+1, '133A', 15000000, NULL),   -- VAT (10%)
(@base_entry_id+3, @base_trans_id+1, '331A', NULL, 165000000);  -- Accounts payable

-- Transaction 2: Purchase tools with cash
INSERT INTO `journal_transaction` VALUES 
(@base_trans_id+2, '2022-08-06', 'Mua công cụ dụng cụ bằng tiền mặt', 2, @period_id, 8, NULL);

INSERT INTO `journal_entry` VALUES
(@base_entry_id+4, @base_trans_id+2, '153A', 50000000, NULL),   -- Tools
(@base_entry_id+5, @base_trans_id+2, '133A', 5000000, NULL),    -- VAT (10%)
(@base_entry_id+6, @base_trans_id+2, '111A', NULL, 55000000);   -- Cash

-- 2.2 Production activities
-- Transaction 3: Issue materials to production
INSERT INTO `journal_transaction` VALUES 
(@base_trans_id+3, '2022-08-10', 'Xuất kho nguyên vật liệu cho sản xuất', 5, @period_id, NULL, NULL);

INSERT INTO `journal_entry` VALUES
(@base_entry_id+7, @base_trans_id+3, 'A621', 135000000, NULL),  -- 90% of materials (150M)
(@base_entry_id+8, @base_trans_id+3, '152A', NULL, 135000000);

-- Transaction 4: Issue tools to production
INSERT INTO `journal_transaction` VALUES 
(@base_trans_id+4, '2022-08-10', 'Xuất kho công cụ dụng cụ cho sản xuất', 5, @period_id, NULL, NULL);

INSERT INTO `journal_entry` VALUES
(@base_entry_id+9, @base_trans_id+4, 'A627', 45000000, NULL),   -- 90% of tools (50M)
(@base_entry_id+10, @base_trans_id+4, '153A', NULL, 45000000);

-- Transaction 5: Depreciation of fixed assets (3% of 1,500M = 45M)
INSERT INTO `journal_transaction` VALUES 
(@base_trans_id+5, '2022-08-15', 'Trích khấu hao TSCĐ tháng 8', 5, @period_id, NULL, NULL);

INSERT INTO `journal_entry` VALUES
(@base_entry_id+11, @base_trans_id+5, 'A627', 45000000, NULL),  -- Depreciation expense
(@base_entry_id+12, @base_trans_id+5, '214B', NULL, 45000000);   -- Accumulated depreciation

-- Transaction 6: Payroll expenses (2x depreciation = 90M)
INSERT INTO `journal_transaction` VALUES 
(@base_trans_id+6, '2022-08-15', 'Tính lương nhân viên sản xuất', 5, @period_id, NULL, NULL);

INSERT INTO `journal_entry` VALUES
(@base_entry_id+13, @base_trans_id+6, 'A622', 90000000, NULL),  -- Labor cost
(@base_entry_id+14, @base_trans_id+6, '334A', NULL, 90000000);   -- Salaries payable

-- 2.3 Finished goods
-- Transaction 7: Transfer production costs to WIP
INSERT INTO `journal_transaction` VALUES 
(@base_trans_id+7, '2022-08-31', 'Kết chuyển chi phí sản xuất vào chi phí dở dang', 5, @period_id, NULL, NULL);

INSERT INTO `journal_entry` VALUES
(@base_entry_id+15, @base_trans_id+7, '154A', 270000000, NULL), -- WIP (135M + 45M + 90M)
(@base_entry_id+16, @base_trans_id+7, 'A621', NULL, 135000000),
(@base_entry_id+17, @base_trans_id+7, 'A622', NULL, 90000000),
(@base_entry_id+18, @base_trans_id+7, 'A627', NULL, 45000000);

-- Transaction 8: Transfer WIP to finished goods
INSERT INTO `journal_transaction` VALUES 
(@base_trans_id+8, '2022-08-31', 'Nhập kho thành phẩm', 5, @period_id, NULL, NULL);

INSERT INTO `journal_entry` VALUES
(@base_entry_id+19, @base_trans_id+8, '155A', 270000000, NULL), -- Finished goods
(@base_entry_id+20, @base_trans_id+8, '154A', NULL, 270000000);

-- 2.4 Sales activities - COGS
-- Transaction 9: Record COGS (80% of finished goods = 216M)
INSERT INTO `journal_transaction` VALUES 
(@base_trans_id+9, '2022-08-20', 'Xuất kho thành phẩm bán cho khách hàng B', 1, @period_id, NULL, 3);

INSERT INTO `journal_entry` VALUES
(@base_entry_id+21, @base_trans_id+9, 'A632', 216000000, NULL), -- COGS
(@base_entry_id+22, @base_trans_id+9, '155A', NULL, 216000000);

-- 2.5 Sales activities - Revenue (2.2x COGS = 475.2M)
-- Transaction 10: Record sales revenue
INSERT INTO `journal_transaction` VALUES 
(@base_trans_id+10, '2022-08-20', 'Bán hàng cho khách hàng B', 1, @period_id, NULL, 3);

INSERT INTO `journal_entry` VALUES
(@base_entry_id+23, @base_trans_id+10, '131A', 475200000, NULL), -- Accounts receivable
(@base_entry_id+24, @base_trans_id+10, 'A511', NULL, 432000000), -- Revenue (475.2M - 43.2M discount)
(@base_entry_id+25, @base_trans_id+10, 'A521', 43200000, NULL),  -- Sales discount (10%)
(@base_entry_id+26, @base_trans_id+10, '333A', NULL, 43200000); -- VAT (10% of net revenue)

-- 2.6 Sales activities - Selling and administrative expenses
-- Transaction 11: Selling expenses (12% of revenue = 51.84M)
INSERT INTO `journal_transaction` VALUES 
(@base_trans_id+11, '2022-08-25', 'Chi phí bán hàng tháng 8', 5, @period_id, NULL, NULL);

INSERT INTO `journal_entry` VALUES
(@base_entry_id+27, @base_trans_id+11, 'A641', 51840000, NULL), -- Selling expenses
(@base_entry_id+28, @base_trans_id+11, '111A', NULL, 51840000); -- Paid in cash

-- Transaction 12: Administrative expenses (12% of revenue = 51.84M)
INSERT INTO `journal_transaction` VALUES 
(@base_trans_id+12, '2022-08-25', 'Chi phí quản lý doanh nghiệp tháng 8', 5, @period_id, NULL, NULL);

INSERT INTO `journal_entry` VALUES
(@base_entry_id+29, @base_trans_id+12, 'A642', 51840000, NULL), -- Admin expenses
(@base_entry_id+30, @base_trans_id+12, '111A', NULL, 51840000); -- Paid in cash

-- 3. Financial activities
-- 3.1 Buy securities
-- Transaction 13: Purchase short-term securities
INSERT INTO `journal_transaction` VALUES 
(@base_trans_id+13, '2022-08-10', 'Mua chứng khoán ngắn hạn', 5, @period_id, NULL, NULL);

INSERT INTO `journal_entry` VALUES
(@base_entry_id+31, @base_trans_id+13, '121A', 100000000, NULL), -- Short-term securities
(@base_entry_id+32, @base_trans_id+13, '112A', NULL, 100000000); -- Bank transfer

-- 3.2 Sell securities (sell 50M worth, at a loss of 5M)
-- Transaction 14: Sell securities at a loss
INSERT INTO `journal_transaction` VALUES 
(@base_trans_id+14, '2022-08-15', 'Bán chứng khoán ngắn hạn bị lỗ', 5, @period_id, NULL, NULL);

INSERT INTO `journal_entry` VALUES
(@base_entry_id+33, @base_trans_id+14, '112A', 45000000, NULL),  -- Cash received (50M - 5M loss)
(@base_entry_id+34, @base_trans_id+14, 'B635', 5000000, NULL),   -- Financial loss
(@base_entry_id+35, @base_trans_id+14, '121A', NULL, 50000000);  -- Securities sold

-- 3.3 Pay bank loan interest (8% of total loans = 8% of 1,200M = 96M)
-- Transaction 15: Pay interest on loans
INSERT INTO `journal_transaction` VALUES 
(@base_trans_id+15, '2022-08-20', 'Trả lãi vay ngân hàng', 9, @period_id, NULL, NULL);

INSERT INTO `journal_entry` VALUES
(@base_entry_id+36, @base_trans_id+15, 'B635', 96000000, NULL), -- Interest expense
(@base_entry_id+37, @base_trans_id+15, '112A', NULL, 96000000);  -- Bank transfer

-- 3.4 Receive investment income (slightly higher than interest paid = 100M)
-- Transaction 16: Receive investment income
INSERT INTO `journal_transaction` VALUES 
(@base_trans_id+16, '2022-08-25', 'Nhận lãi đầu tư chứng khoán', 5, @period_id, NULL, NULL);

INSERT INTO `journal_entry` VALUES
(@base_entry_id+38, @base_trans_id+16, '112A', 100000000, NULL), -- Bank deposit
(@base_entry_id+39, @base_trans_id+16, 'B515', NULL, 100000000); -- Investment income

-- 4. Other activities
-- 4.1 Other expenses (penalty = 10M)
-- Transaction 17: Record penalty expense
INSERT INTO `journal_transaction` VALUES 
(@base_trans_id+17, '2022-08-18', 'Phạt vi phạm hợp đồng', 5, @period_id, NULL, NULL);

INSERT INTO `journal_entry` VALUES
(@base_entry_id+40, @base_trans_id+17, 'C811', 10000000, NULL), -- Other expense
(@base_entry_id+41, @base_trans_id+17, '111A', NULL, 10000000); -- Cash

-- 4.2 Other income (sell fixed asset 3% of 1,500M = 45M)
-- Transaction 18: Record sale of fixed asset
INSERT INTO `journal_transaction` VALUES 
(@base_trans_id+18, '2022-08-22', 'Bán TSCĐ không còn sử dụng', 5, @period_id, NULL, NULL);

INSERT INTO `journal_entry` VALUES
(@base_entry_id+42, @base_trans_id+18, '111A', 45000000, NULL),  -- Cash received
(@base_entry_id+43, @base_trans_id+18, '214B', 30000000, NULL),  -- Remove accumulated depreciation
(@base_entry_id+44, @base_trans_id+18, '211B', NULL, 50000000),  -- Remove asset cost (50M)
(@base_entry_id+45, @base_trans_id+18, 'C711', NULL, 25000000);  -- Gain on sale (45M - (50M-30M))

-- 5. Month-end closing entries
-- 5.1 Close expense accounts to 911
-- Transaction 19: Close expenses
INSERT INTO `journal_transaction` VALUES 
(@base_trans_id+19, '2022-08-31', 'Kết chuyển chi phí cuối tháng', 5, @period_id, NULL, NULL);

INSERT INTO `journal_entry` VALUES
(@base_entry_id+46, @base_trans_id+19, 'D911', 216000000, NULL), -- COGS
(@base_entry_id+47, @base_trans_id+19, 'A632', NULL, 216000000),
(@base_entry_id+48, @base_trans_id+19, 'D911', 51840000, NULL),  -- Selling expenses
(@base_entry_id+49, @base_trans_id+19, 'A641', NULL, 51840000),
(@base_entry_id+50, @base_trans_id+19, 'D911', 51840000, NULL),  -- Admin expenses
(@base_entry_id+51, @base_trans_id+19, 'A642', NULL, 51840000),
(@base_entry_id+52, @base_trans_id+19, 'D911', 101000000, NULL), -- Financial expenses (96M+5M)
(@base_entry_id+53, @base_trans_id+19, 'B635', NULL, 101000000),
(@base_entry_id+54, @base_trans_id+19, 'D911', 10000000, NULL),  -- Other expenses
(@base_entry_id+55, @base_trans_id+19, 'C811', NULL, 10000000),
(@base_entry_id+56, @base_trans_id+19, 'D911', 43200000, NULL),  -- Sales discounts
(@base_entry_id+57, @base_trans_id+19, 'A521', NULL, 43200000);

-- 5.2 Close revenue accounts to 911
-- Transaction 20: Close revenues
INSERT INTO `journal_transaction` VALUES 
(@base_trans_id+20, '2022-08-31', 'Kết chuyển doanh thu cuối tháng', 5, @period_id, NULL, NULL);

INSERT INTO `journal_entry` VALUES
(@base_entry_id+58, @base_trans_id+20, 'A511', 432000000, NULL), -- Sales revenue
(@base_entry_id+59, @base_trans_id+20, 'D911', NULL, 432000000),
(@base_entry_id+60, @base_trans_id+20, 'B515', 100000000, NULL), -- Financial income
(@base_entry_id+61, @base_trans_id+20, 'D911', NULL, 100000000),
(@base_entry_id+62, @base_trans_id+20, 'C711', 25000000, NULL),  -- Other income
(@base_entry_id+63, @base_trans_id+20, 'D911', NULL, 25000000);

-- 5.3 Calculate and record income tax (20% of profit)
-- Profit before tax = (432M + 100M + 25M) - (216M + 51.84M + 51.84M + 101M + 10M + 43.2M) = 557M - 473.88M = 83.12M
-- Tax = 83.12M * 20% = 16.624M
-- Transaction 21: Record income tax
INSERT INTO `journal_transaction` VALUES 
(@base_trans_id+21, '2022-08-31', 'Tính thuế TNDN phải nộp', 8, @period_id, NULL, NULL);

INSERT INTO `journal_entry` VALUES
(@base_entry_id+64, @base_trans_id+21, 'C821', 16624000, NULL), -- Tax expense
(@base_entry_id+65, @base_trans_id+21, '333A', NULL, 16624000);  -- Tax payable

-- 5.4 Close tax expense to 911
-- Transaction 22: Close tax expense
INSERT INTO `journal_transaction` VALUES 
(@base_trans_id+22, '2022-08-31', 'Kết chuyển chi phí thuế TNDN', 5, @period_id, NULL, NULL);

INSERT INTO `journal_entry` VALUES
(@base_entry_id+66, @base_trans_id+22, 'D911', 16624000, NULL), -- Tax expense
(@base_entry_id+67, @base_trans_id+22, 'C821', NULL, 16624000);

-- 5.5 Calculate and transfer net profit (83.12M - 16.624M = 66.496M)
-- Transaction 23: Transfer net profit
INSERT INTO `journal_transaction` VALUES 
(@base_trans_id+23, '2022-08-31', 'Kết chuyển lợi nhuận sau thuế', 5, @period_id, NULL, NULL);

INSERT INTO `journal_entry` VALUES
(@base_entry_id+68, @base_trans_id+23, 'D911', 66496000, NULL), -- Net profit
(@base_entry_id+69, @base_trans_id+23, '421B', NULL, 66496000);

-- 6. Cash flow activities
-- 6.1 Pay dividends (30% of profit = 20M)
-- Transaction 24: Pay dividends
INSERT INTO `journal_transaction` VALUES 
(@base_trans_id+24, '2022-08-31', 'Chi trả cổ tức', 4, @period_id, NULL, NULL);

INSERT INTO `journal_entry` VALUES
(@base_entry_id+70, @base_trans_id+24, '421B', 20000000, NULL), -- Retained earnings
(@base_entry_id+71, @base_trans_id+24, '111A', NULL, 20000000); -- Cash

-- 6.2 Collect from customers (80% of 475.2M = 380.16M)
-- Transaction 25: Collect receivables
INSERT INTO `journal_transaction` VALUES 
(@base_trans_id+25, '2022-08-28', 'Thu tiền khách hàng', 3, @period_id, NULL, 3);

INSERT INTO `journal_entry` VALUES
(@base_entry_id+72, @base_trans_id+25, '112A', 380160000, NULL), -- Bank deposit
(@base_entry_id+73, @base_trans_id+25, '131A', NULL, 380160000); -- Accounts receivable

-- 6.3 Pay suppliers (75% of 165M = 123.75M)
-- Transaction 26: Pay suppliers
INSERT INTO `journal_transaction` VALUES 
(@base_trans_id+26, '2022-08-29', 'Trả tiền nhà cung cấp', 4, @period_id, 5, NULL);

INSERT INTO `journal_entry` VALUES
(@base_entry_id+74, @base_trans_id+26, '331A', 123750000, NULL), -- Accounts payable
(@base_entry_id+75, @base_trans_id+26, '112A', NULL, 123750000); -- Bank transfer

-- 6.4 Pay taxes (90% of 59.824M = 53.8416M)
-- Transaction 27: Pay taxes
INSERT INTO `journal_transaction` VALUES 
(@base_trans_id+27, '2022-08-30', 'Nộp thuế', 4, @period_id, NULL, NULL);

INSERT INTO `journal_entry` VALUES
(@base_entry_id+76, @base_trans_id+27, '333A', 53841600, NULL), -- Tax payable
(@base_entry_id+77, @base_trans_id+27, '112A', NULL, 53841600);  -- Bank transfer

-- 6.5 Pay salaries (85% of 90M = 76.5M)
-- Transaction 28: Pay salaries
INSERT INTO `journal_transaction` VALUES 
(@base_trans_id+28, '2022-08-30', 'Trả lương nhân viên', 4, @period_id, NULL, NULL);

INSERT INTO `journal_entry` VALUES
(@base_entry_id+78, @base_trans_id+28, '334A', 76500000, NULL), -- Salaries payable
(@base_entry_id+79, @base_trans_id+28, '111A', NULL, 76500000); -- Cash

-- 6.6 Repay short-term loan principal (10% of 700M = 70M)
-- Transaction 29: Repay short-term loan
INSERT INTO `journal_transaction` VALUES 
(@base_trans_id+29, '2022-08-31', 'Trả nợ gốc vay ngắn hạn', 9, @period_id, NULL, NULL);

INSERT INTO `journal_entry` VALUES
(@base_entry_id+80, @base_trans_id+29, '341A', 70000000, NULL), -- Short-term loan
(@base_entry_id+81, @base_trans_id+29, '112A', NULL, 70000000); -- Bank transfer

-- 6.7 Repay long-term loan principal (5% of 500M = 25M)
-- Transaction 30: Repay long-term loan
INSERT INTO `journal_transaction` VALUES 
(@base_trans_id+30, '2022-08-31', 'Trả nợ gốc vay dài hạn', 9, @period_id, NULL, NULL);

INSERT INTO `journal_entry` VALUES
(@base_entry_id+82, @base_trans_id+30, '341B', 25000000, NULL), -- Long-term loan
(@base_entry_id+83, @base_trans_id+30, '112A', NULL, 25000000); -- Bank transfer

-- FIX
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES (2208900, '2022-08-30', 'FIX', 5, @period_id, NULL, NULL);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2208900, 2208900, '111A', 1800000, NULL);

COMMIT;