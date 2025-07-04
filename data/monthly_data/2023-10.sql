START TRANSACTION;

-- Set period_id for 2023 (value 2)
SET @period_id = 2;

-- Set base transaction and entry IDs for October 2023 (yymm = 2310)
SET @base_trans_id = 2310000;
SET @base_entry_id = 2310000;

-- 1. Capital mobilization and fixed asset investment (only in January)
-- These transactions would normally be in January, but since you asked for October, I'll skip them
-- as per your instruction that these only happen in January

-- 2. Business operations - Purchasing activities
-- Transaction 1: Purchase materials on credit (with VAT)
INSERT INTO `journal_transaction` VALUES 
(@base_trans_id+1, '2023-10-05', 'Mua nguyên vật liệu từ nhà cung cấp A', 2, @period_id, 5, NULL);
INSERT INTO `journal_entry` VALUES
(@base_entry_id+1, @base_trans_id+1, '152A', 150000000, NULL),  -- Materials
(@base_entry_id+2, @base_trans_id+1, '133A', 15000000, NULL),   -- VAT
(@base_entry_id+3, @base_trans_id+1, '331A', NULL, 165000000);  -- Accounts payable

-- Transaction 2: Purchase tools with cash (with VAT)
INSERT INTO `journal_transaction` VALUES 
(@base_trans_id+2, '2023-10-06', 'Mua công cụ dụng cụ từ nhà cung cấp B bằng tiền mặt', 2, @period_id, 8, NULL);
INSERT INTO `journal_entry` VALUES
(@base_entry_id+4, @base_trans_id+2, '153A', 50000000, NULL),   -- Tools
(@base_entry_id+5, @base_trans_id+2, '133A', 5000000, NULL),    -- VAT
(@base_entry_id+6, @base_trans_id+2, '111A', NULL, 55000000);   -- Cash

-- 3. Production activities
-- Transaction 3: Issue materials to production (90% of purchased materials)
INSERT INTO `journal_transaction` VALUES 
(@base_trans_id+3, '2023-10-10', 'Xuất kho nguyên vật liệu cho sản xuất', 5, @period_id, NULL, NULL);
INSERT INTO `journal_entry` VALUES
(@base_entry_id+7, @base_trans_id+3, 'A621', 135000000, NULL),  -- Direct materials cost
(@base_entry_id+8, @base_trans_id+3, '152A', NULL, 135000000);  -- Materials inventory

-- Transaction 4: Issue tools to production (85% of purchased tools)
INSERT INTO `journal_transaction` VALUES 
(@base_trans_id+4, '2023-10-10', 'Xuất kho công cụ dụng cụ cho sản xuất', 5, @period_id, NULL, NULL);
INSERT INTO `journal_entry` VALUES
(@base_entry_id+9, @base_trans_id+4, 'A627', 42500000, NULL),   -- Manufacturing overhead
(@base_entry_id+10, @base_trans_id+4, '153A', NULL, 42500000);  -- Tools inventory

-- Transaction 5: Depreciation of fixed assets (3% of 2,500,000,000)
INSERT INTO `journal_transaction` VALUES 
(@base_trans_id+5, '2023-10-15', 'Trích khấu hao TSCĐ tháng 10/2023', 5, @period_id, NULL, NULL);
INSERT INTO `journal_entry` VALUES
(@base_entry_id+11, @base_trans_id+5, 'A627', 75000000, NULL),  -- Manufacturing overhead
(@base_entry_id+12, @base_trans_id+5, '214B', NULL, 75000000 +500000);  -- Accumulated depreciation -- FIX

-- Transaction 6: Payroll expenses (2x depreciation)
INSERT INTO `journal_transaction` VALUES 
(@base_trans_id+6, '2023-10-15', 'Tính lương nhân viên sản xuất tháng 10/2023', 5, @period_id, NULL, NULL);
INSERT INTO `journal_entry` VALUES
(@base_entry_id+13, @base_trans_id+6, 'A622', 150000000, NULL), -- Direct labor cost
(@base_entry_id+14, @base_trans_id+6, '334A', NULL, 150000000); -- Salaries payable

-- 4. Finished goods
-- Transaction 7: Transfer production costs to WIP
INSERT INTO `journal_transaction` VALUES 
(@base_trans_id+7, '2023-10-31', 'Kết chuyển chi phí sản xuất vào chi phí SXKD dở dang', 5, @period_id, NULL, NULL);
INSERT INTO `journal_entry` VALUES
(@base_entry_id+15, @base_trans_id+7, '154A', 402500000, NULL), -- WIP (135m + 150m + 42.5m + 75m)
(@base_entry_id+16, @base_trans_id+7, 'A621', NULL, 135000000), -- Clear direct materials
(@base_entry_id+17, @base_trans_id+7, 'A622', NULL, 150000000), -- Clear direct labor
(@base_entry_id+18, @base_trans_id+7, 'A627', NULL, 117500000); -- Clear overhead (42.5m + 75m)

-- Transaction 8: Transfer WIP to finished goods
INSERT INTO `journal_transaction` VALUES 
(@base_trans_id+8, '2023-10-31', 'Nhập kho thành phẩm từ chi phí SXKD dở dang', 5, @period_id, NULL, NULL);
INSERT INTO `journal_entry` VALUES
(@base_entry_id+19, @base_trans_id+8, '155A', 402500000, NULL), -- Finished goods
(@base_entry_id+20, @base_trans_id+8, '154A', NULL, 402500000); -- WIP

-- 5. Sales activities - COGS (90% of finished goods)
INSERT INTO `journal_transaction` VALUES 
(@base_trans_id+9, '2023-10-20', 'Xuất kho thành phẩm bán cho khách hàng C', 1, @period_id, NULL, 3);
INSERT INTO `journal_entry` VALUES
(@base_entry_id+21, @base_trans_id+9, 'A632', 362250000, NULL), -- COGS (90% of 402.5m)
(@base_entry_id+22, @base_trans_id+9, '155A', NULL, 362250000); -- Finished goods

-- 6. Sales activities - Revenue (2.2x COGS)
INSERT INTO `journal_transaction` VALUES 
(@base_trans_id+10, '2023-10-20', 'Ghi nhận doanh thu bán hàng cho khách hàng C', 1, @period_id, NULL, 3);
INSERT INTO `journal_entry` VALUES
(@base_entry_id+23, @base_trans_id+10, '131A', 797000000, NULL), -- Accounts receivable (362.25m * 2.2)
(@base_entry_id+24, @base_trans_id+10, 'A511', NULL, 770000000), -- Revenue
(@base_entry_id+25, @base_trans_id+10, '333A', NULL, 27000000);  -- VAT (10% of 770m)

-- Transaction 11: Sales discount
INSERT INTO `journal_transaction` VALUES 
(@base_trans_id+11, '2023-10-21', 'Chiết khấu thương mại cho khách hàng C', 1, @period_id, NULL, 3);
INSERT INTO `journal_entry` VALUES
(@base_entry_id+26, @base_trans_id+11, 'A521', 10000000, NULL),  -- Sales discount
(@base_entry_id+27, @base_trans_id+11, '131A', NULL, 10000000);  -- Accounts receivable

-- 7. Selling and administrative expenses (15% of revenue each)
INSERT INTO `journal_transaction` VALUES 
(@base_trans_id+12, '2023-10-25', 'Chi phí bán hàng tháng 10/2023', 5, @period_id, NULL, NULL);
INSERT INTO `journal_entry` VALUES
(@base_entry_id+28, @base_trans_id+12, 'A641', 115500000, NULL), -- Selling expenses (15% of 770m)
(@base_entry_id+29, @base_trans_id+12, '111A', NULL, 50000000),  -- Cash
(@base_entry_id+30, @base_trans_id+12, '112A', NULL, 65500000);  -- Bank

INSERT INTO `journal_transaction` VALUES 
(@base_trans_id+13, '2023-10-26', 'Chi phí quản lý doanh nghiệp tháng 10/2023', 5, @period_id, NULL, NULL);
INSERT INTO `journal_entry` VALUES
(@base_entry_id+31, @base_trans_id+13, 'A642', 115500000, NULL), -- Admin expenses (15% of 770m)
(@base_entry_id+32, @base_trans_id+13, '111A', NULL, 30000000),  -- Cash
(@base_entry_id+33, @base_trans_id+13, '112A', NULL, 85500000);  -- Bank

-- 8. Financial activities
-- Transaction 14: Purchase securities
INSERT INTO `journal_transaction` VALUES 
(@base_trans_id+14, '2023-10-15', 'Mua chứng khoán ngắn hạn', 5, @period_id, NULL, NULL);
INSERT INTO `journal_entry` VALUES
(@base_entry_id+34, @base_trans_id+14, '121A', 200000000, NULL), -- Short-term investments
(@base_entry_id+35, @base_trans_id+14, '112A', NULL, 200000000); -- Bank

-- Transaction 15: Sell securities (with profit)
INSERT INTO `journal_transaction` VALUES 
(@base_trans_id+15, '2023-10-18', 'Bán một phần chứng khoán ngắn hạn', 5, @period_id, NULL, NULL);
INSERT INTO `journal_entry` VALUES
(@base_entry_id+36, @base_trans_id+15, '112A', 110000000, NULL), -- Bank (50m cost + 10m profit)
(@base_entry_id+37, @base_trans_id+15, '121A', NULL, 100000000), -- Short-term investments (50% of 200m)
(@base_entry_id+38, @base_trans_id+15, 'B515', NULL, 10000000);  -- Financial income

-- Transaction 16: Pay loan interest (8% of total loans)
INSERT INTO `journal_transaction` VALUES 
(@base_trans_id+16, '2023-10-20', 'Trả lãi vay ngân hàng tháng 10/2023', 9, @period_id, NULL, NULL);
INSERT INTO `journal_entry` VALUES
(@base_entry_id+39, @base_trans_id+16, 'B635', 160000000, NULL), -- Financial expense (8% of 2,000m)
(@base_entry_id+40, @base_trans_id+16, '112A', NULL, 160000000); -- Bank

-- Transaction 17: Receive investment income
INSERT INTO `journal_transaction` VALUES 
(@base_trans_id+17, '2023-10-25', 'Nhận lãi đầu tư chứng khoán', 5, @period_id, NULL, NULL);
INSERT INTO `journal_entry` VALUES
(@base_entry_id+41, @base_trans_id+17, '112A', 180000000, NULL), -- Bank
(@base_entry_id+42, @base_trans_id+17, 'B515', NULL, 180000000); -- Financial income

-- 9. Other activities
-- Transaction 18: Other expenses
INSERT INTO `journal_transaction` VALUES 
(@base_trans_id+18, '2023-10-28', 'Phạt vi phạm hợp đồng với nhà cung cấp D', 5, @period_id, 12, NULL);
INSERT INTO `journal_entry` VALUES
(@base_entry_id+43, @base_trans_id+18, 'C811', 50000000, NULL),  -- Other expenses
(@base_entry_id+44, @base_trans_id+18, '112A', NULL, 50000000); -- Bank

-- Transaction 19: Other income (sell fixed asset - 1.5% of total fixed assets)
INSERT INTO `journal_transaction` VALUES 
(@base_trans_id+19, '2023-10-29', 'Bán thanh lý TSCĐ hữu hình', 5, @period_id, NULL, NULL);
INSERT INTO `journal_entry` VALUES
(@base_entry_id+45, @base_trans_id+19, '112A', 37500000, NULL), -- Bank (1.5% of 2,500m)
(@base_entry_id+46, @base_trans_id+19, 'C711', NULL, 37500000); -- Other income

-- 10. Month-end closing entries
-- Transaction 20: Transfer all expenses to 911
INSERT INTO `journal_transaction` VALUES 
(@base_trans_id+20, '2023-10-31', 'Kết chuyển chi phí tháng 10/2023', 5, @period_id, NULL, NULL);
INSERT INTO `journal_entry` VALUES
(@base_entry_id+47, @base_trans_id+20, 'D911', 813750000, NULL), -- Total expenses (362.25 + 10 + 115.5 + 115.5 + 160 + 50)
(@base_entry_id+48, @base_trans_id+20, 'A632', NULL, 362250000), -- COGS
(@base_entry_id+49, @base_trans_id+20, 'A521', NULL, 10000000),  -- Sales discount
(@base_entry_id+50, @base_trans_id+20, 'A641', NULL, 115500000), -- Selling expenses
(@base_entry_id+51, @base_trans_id+20, 'A642', NULL, 115500000), -- Admin expenses
(@base_entry_id+52, @base_trans_id+20, 'B635', NULL, 160000000), -- Financial expenses
(@base_entry_id+53, @base_trans_id+20, 'C811', NULL, 50000000);  -- Other expenses

-- Transaction 21: Transfer all revenues to 911
INSERT INTO `journal_transaction` VALUES 
(@base_trans_id+21, '2023-10-31', 'Kết chuyển doanh thu tháng 10/2023', 5, @period_id, NULL, NULL);
INSERT INTO `journal_entry` VALUES
(@base_entry_id+54, @base_trans_id+21, 'A511', 770000000, NULL), -- Revenue
(@base_entry_id+55, @base_trans_id+21, 'B515', 190000000, NULL), -- Financial income (10 + 180)
(@base_entry_id+56, @base_trans_id+21, 'C711', 37500000, NULL),  -- Other income
(@base_entry_id+57, @base_trans_id+21, 'D911', NULL, 997500000); -- Total income

-- Transaction 22: Calculate and record income tax (20% of profit)
-- Profit = 997,500,000 - 813,750,000 = 183,750,000
-- Tax = 183,750,000 * 20% = 36,750,000
INSERT INTO `journal_transaction` VALUES 
(@base_trans_id+22, '2023-10-31', 'Tính thuế TNDN phải nộp tháng 10/2023', 5, @period_id, NULL, NULL);
INSERT INTO `journal_entry` VALUES
(@base_entry_id+58, @base_trans_id+22, 'C821', 36750000, NULL),  -- Income tax expense
(@base_entry_id+59, @base_trans_id+22, '333A', NULL, 36750000); -- Tax payable

-- Transaction 23: Transfer tax expense to 911
INSERT INTO `journal_transaction` VALUES 
(@base_trans_id+23, '2023-10-31', 'Kết chuyển chi phí thuế TNDN', 5, @period_id, NULL, NULL);
INSERT INTO `journal_entry` VALUES
(@base_entry_id+60, @base_trans_id+23, 'D911', 36750000, NULL),  -- Add tax to expenses
(@base_entry_id+61, @base_trans_id+23, 'C821', NULL, 36750000); -- Clear tax expense

-- Transaction 24: Calculate net profit and transfer to retained earnings
-- Net profit = 183,750,000 - 36,750,000 = 147,000,000
INSERT INTO `journal_transaction` VALUES 
(@base_trans_id+24, '2023-10-31', 'Kết chuyển lợi nhuận sau thuế', 5, @period_id, NULL, NULL);
INSERT INTO `journal_entry` VALUES
(@base_entry_id+62, @base_trans_id+24, 'D911', 147000000, NULL), -- Net profit
(@base_entry_id+63, @base_trans_id+24, '421B', NULL, 147000000); -- Retained earnings

-- 11. Cash flow activities
-- Transaction 25: Pay dividends (15% of net profit)
INSERT INTO `journal_transaction` VALUES 
(@base_trans_id+25, '2023-10-31', 'Chi trả cổ tức cho chủ sở hữu', 4, @period_id, NULL, NULL);
INSERT INTO `journal_entry` VALUES
(@base_entry_id+64, @base_trans_id+25, '421B', 22050000, NULL),  -- Retained earnings (15% of 147m)
(@base_entry_id+65, @base_trans_id+25, '112A', NULL, 22050000); -- Bank

-- Transaction 26: Collect receivables (80% of AR)
INSERT INTO `journal_transaction` VALUES 
(@base_trans_id+26, '2023-10-30', 'Thu tiền từ khách hàng C', 3, @period_id, NULL, 3);
INSERT INTO `journal_entry` VALUES
(@base_entry_id+66, @base_trans_id+26, '112A', 629600000, NULL), -- Bank (80% of 787m)
(@base_entry_id+67, @base_trans_id+26, '131A', NULL, 629600000); -- Accounts receivable

-- Transaction 27: Pay suppliers (75% of AP)
INSERT INTO `journal_transaction` VALUES 
(@base_trans_id+27, '2023-10-28', 'Trả tiền cho nhà cung cấp A', 4, @period_id, 5, NULL);
INSERT INTO `journal_entry` VALUES
(@base_entry_id+68, @base_trans_id+27, '331A', 123750000, NULL), -- Accounts payable (75% of 165m)
(@base_entry_id+69, @base_trans_id+27, '112A', NULL, 123750000); -- Bank

-- Transaction 28: Pay taxes (90% of tax payable)
INSERT INTO `journal_transaction` VALUES 
(@base_trans_id+28, '2023-10-31', 'Nộp thuế TNDN', 4, @period_id, NULL, NULL);
INSERT INTO `journal_entry` VALUES
(@base_entry_id+70, @base_trans_id+28, '333A', 33075000, NULL),  -- Tax payable (90% of 36.75m)
(@base_entry_id+71, @base_trans_id+28, '112A', NULL, 33075000); -- Bank

-- Transaction 29: Pay salaries (85% of salary payable)
INSERT INTO `journal_transaction` VALUES 
(@base_trans_id+29, '2023-10-31', 'Trả lương nhân viên tháng 10/2023', 4, @period_id, NULL, NULL);
INSERT INTO `journal_entry` VALUES
(@base_entry_id+72, @base_trans_id+29, '334A', 127500000, NULL), -- Salaries payable (85% of 150m)
(@base_entry_id+73, @base_trans_id+29, '111A', NULL, 50000000),  -- Cash
(@base_entry_id+74, @base_trans_id+29, '112A', NULL, 77500000);  -- Bank

-- Transaction 30: Pay short-term loan principal (10% of short-term loans)
INSERT INTO `journal_transaction` VALUES 
(@base_trans_id+30, '2023-10-31', 'Trả nợ gốc vay ngắn hạn', 4, @period_id, NULL, NULL);
INSERT INTO `journal_entry` VALUES
(@base_entry_id+75, @base_trans_id+30, '341A', 90000000, NULL),  -- Short-term loans (10% of 900m)
(@base_entry_id+76, @base_trans_id+30, '112A', NULL, 90000000);  -- Bank

-- Transaction 31: Pay long-term loan principal (5% of long-term loans)
INSERT INTO `journal_transaction` VALUES 
(@base_trans_id+31, '2023-10-31', 'Trả nợ gốc vay dài hạn', 4, @period_id, NULL, NULL);
INSERT INTO `journal_entry` VALUES
(@base_entry_id+77, @base_trans_id+31, '341B', 55000000, NULL),  -- Long-term loans (5% of 1,100m)
(@base_entry_id+78, @base_trans_id+31, '112A', NULL, 55000000); -- Bank

COMMIT;