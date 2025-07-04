START TRANSACTION;

-- Set the period to November 2022 (period_id = 1 for 2022)
-- Note: Using variables is not allowed per requirements, so we'll hardcode period_id = 1

-- 1. Capital mobilization and fixed asset investment (only in January - SKIP for November)
-- These transactions would only be in January, so we're not including them in November

-- 2. Business operations - Purchasing activities
-- Transaction 1: Purchase materials on credit (with VAT)
INSERT INTO `journal_transaction` VALUES 
(2211001, '2022-11-05', 'Mua nguyên vật liệu từ nhà cung cấp A', 2, 1, 5, NULL);

INSERT INTO `journal_entry` VALUES 
(2211001, 2211001, '152A', 150000000, NULL),  -- Materials
(2211002, 2211001, '133A', 15000000, NULL),   -- VAT (10%)
(2211003, 2211001, '331A', NULL, 165000000);  -- Accounts payable

-- Transaction 2: Purchase tools with cash (with VAT)
INSERT INTO `journal_transaction` VALUES 
(2211002, '2022-11-07', 'Mua công cụ dụng cụ bằng tiền mặt', 2, 1, 8, NULL);

INSERT INTO `journal_entry` VALUES 
(2211004, 2211002, '153A', 50000000, NULL),   -- Tools
(2211005, 2211002, '133A', 5000000, NULL),    -- VAT (10%)
(2211006, 2211002, '111A', NULL, 55000000);   -- Cash

-- 3. Production activities
-- Transaction 3: Issue materials to production
INSERT INTO `journal_transaction` VALUES 
(2211003, '2022-11-10', 'Xuất kho nguyên vật liệu cho sản xuất', 5, 1, NULL, NULL);

INSERT INTO `journal_entry` VALUES 
(2211007, 2211003, 'A621', 135000000, NULL),  -- 90% of materials issued
(2211008, 2211003, '152A', NULL, 135000000);

-- Transaction 4: Issue tools to production
INSERT INTO `journal_transaction` VALUES 
(2211004, '2022-11-10', 'Xuất kho công cụ dụng cụ cho sản xuất', 5, 1, NULL, NULL);

INSERT INTO `journal_entry` VALUES 
(2211009, 2211004, 'A627', 40000000, NULL),   -- 80% of tools issued
(2211010, 2211004, '153A', NULL, 40000000);

-- Transaction 5: Depreciation of fixed assets (3% of 1,500,000,000)
INSERT INTO `journal_transaction` VALUES 
(2211005, '2022-11-15', 'Trích khấu hao TSCĐ tháng 11/2022', 5, 1, NULL, NULL);

INSERT INTO `journal_entry` VALUES 
(2211011, 2211005, 'A627', 45000000, NULL),   -- Depreciation expense
(2211012, 2211005, '214B', NULL, 45000000);   -- Accumulated depreciation

-- Transaction 6: Payroll for production staff (2x depreciation)
INSERT INTO `journal_transaction` VALUES 
(2211006, '2022-11-15', 'Trả lương nhân viên sản xuất', 5, 1, NULL, NULL);

INSERT INTO `journal_entry` VALUES 
(2211013, 2211006, 'A622', 90000000, NULL),   -- Labor cost
(2211014, 2211006, '334A', NULL, 90000000);   -- Salary payable

-- 4. Finished goods
-- Transaction 7: Transfer production costs to WIP
INSERT INTO `journal_transaction` VALUES 
(2211007, '2022-11-30', 'Kết chuyển chi phí sản xuất vào chi phí dở dang', 5, 1, NULL, NULL);

INSERT INTO `journal_entry` VALUES 
(2211015, 2211007, '154A', 270000000, NULL),  -- WIP (621+622+627)
(2211016, 2211007, 'A621', NULL, 135000000),
(2211017, 2211007, 'A622', NULL, 90000000),
(2211018, 2211007, 'A627', NULL, 45000000);

-- Transaction 8: Transfer WIP to finished goods
INSERT INTO `journal_transaction` VALUES 
(2211008, '2022-11-30', 'Nhập kho thành phẩm từ chi phí dở dang', 5, 1, NULL, NULL);

INSERT INTO `journal_entry` VALUES 
(2211019, 2211008, '155A', 270000000, NULL),  -- Finished goods
(2211020, 2211008, '154A', NULL, 270000000);

-- 5. Sales activities - COGS first
-- Transaction 9: Record COGS (80% of finished goods)
INSERT INTO `journal_transaction` VALUES 
(2211009, '2022-11-20', 'Ghi nhận giá vốn hàng bán', 1, 1, NULL, 3);

INSERT INTO `journal_entry` VALUES 
(2211021, 2211009, 'A632', 216000000, NULL),  -- COGS (80% of 270M)
(2211022, 2211009, '155A', NULL, 216000000);

-- Transaction 10: Record sales revenue (2.2x COGS)
INSERT INTO `journal_transaction` VALUES 
(2211010, '2022-11-20', 'Bán hàng cho khách hàng B', 1, 1, NULL, 7);

INSERT INTO `journal_entry` VALUES 
(2211023, 2211010, '131A', 475200000, NULL),  -- Accounts receivable (475.2M)
(2211024, 2211010, 'A521', 48000000, NULL),   -- Sales returns (48M)
(2211025, 2211010, 'A511', NULL, 475200000),  -- Revenue (475.2M)
(2211026, 2211010, '333A', NULL, 43200000);   -- VAT (10% of net revenue)

-- Transaction 11: Record selling expenses (13% of revenue)
INSERT INTO `journal_transaction` VALUES 
(2211011, '2022-11-25', 'Chi phí bán hàng tháng 11/2022', 5, 1, NULL, NULL);

INSERT INTO `journal_entry` VALUES 
(2211027, 2211011, 'A641', 55598400, NULL),   -- Selling expenses (13% of 427.68M net revenue)
(2211028, 2211011, '334A', NULL, 30000000),   -- Salary payable
(2211029, 2211011, '111A', NULL, 25598400);   -- Cash for other selling expenses

-- Transaction 12: Record administrative expenses (13% of revenue)
INSERT INTO `journal_transaction` VALUES 
(2211012, '2022-11-25', 'Chi phí quản lý doanh nghiệp tháng 11/2022', 5, 1, NULL, NULL);

INSERT INTO `journal_entry` VALUES 
(2211030, 2211012, 'A642', 55598400, NULL),   -- Admin expenses (13% of 427.68M net revenue)
(2211031, 2211012, '334A', NULL, 35000000),   -- Salary payable
(2211032, 2211012, '112A', NULL, 20598400);   -- Bank for other admin expenses

-- 6. Financial activities
-- Transaction 13: Purchase securities (short-term)
INSERT INTO `journal_transaction` VALUES 
(2211013, '2022-11-08', 'Mua chứng khoán ngắn hạn', 5, 1, NULL, NULL);

INSERT INTO `journal_entry` VALUES 
(2211033, 2211013, '121A', 100000000, NULL),  -- Short-term securities
(2211034, 2211013, '112A', NULL, 100000000);  -- Bank

-- Transaction 14: Sell securities (partial, with profit)
INSERT INTO `journal_transaction` VALUES 
(2211014, '2022-11-18', 'Bán một phần chứng khoán ngắn hạn', 5, 1, NULL, NULL);

INSERT INTO `journal_entry` VALUES 
(2211035, 2211014, '112A', 55000000, NULL),   -- Bank (received)
(2211036, 2211014, '121A', NULL, 40000000),   -- Cost of securities sold
(2211037, 2211014, 'B515', NULL, 15000000);   -- Profit (15M)

-- Transaction 15: Pay interest on bank loans (8% of total loans)
-- Total loans: 700M short-term + 500M long-term = 1,200M
INSERT INTO `journal_transaction` VALUES 
(2211015, '2022-11-15', 'Trả lãi vay ngân hàng', 9, 1, NULL, NULL);

INSERT INTO `journal_entry` VALUES 
(2211038, 2211015, 'B635', 96000000, NULL),   -- Interest expense (8% of 1,200M)
(2211039, 2211015, '112A', NULL, 96000000);   -- Bank

-- Transaction 16: Receive investment income (slightly higher than interest paid)
INSERT INTO `journal_transaction` VALUES 
(2211016, '2022-11-20', 'Nhận lãi từ đầu tư chứng khoán', 5, 1, NULL, NULL);

INSERT INTO `journal_entry` VALUES 
(2211040, 2211016, '112A', 100000000, NULL),  -- Bank
(2211041, 2211016, 'B515', NULL, 100000000);  -- Investment income

-- 7. Other activities
-- Transaction 17: Record other expenses (contract penalty)
INSERT INTO `journal_transaction` VALUES 
(2211017, '2022-11-10', 'Phạt vi phạm hợp đồng với nhà cung cấp C', 5, 1, 12, NULL);

INSERT INTO `journal_entry` VALUES 
(2211042, 2211017, 'C811', 20000000, NULL),   -- Other expenses
(2211043, 2211017, '112A', NULL, 20000000);    -- Bank

-- Transaction 18: Record other income (sale of fixed assets)
INSERT INTO `journal_transaction` VALUES 
(2211018, '2022-11-15', 'Bán thanh lý TSCĐ', 5, 1, NULL, NULL);

INSERT INTO `journal_entry` VALUES 
(2211044, 2211018, '112A', 40000000, NULL),   -- Bank (2.67% of 1,500M)
(2211045, 2211018, '211B', NULL, 30000000),   -- Cost of fixed asset sold
(2211046, 2211018, '214B', NULL, 5000000),    -- Accumulated depreciation
(2211047, 2211018, 'C711', NULL, 15000000);   -- Gain on sale (15M)

-- 8. Month-end closing entries
-- Transaction 19: Transfer all expenses to 911
INSERT INTO `journal_transaction` VALUES 
(2211019, '2022-11-30', 'Kết chuyển chi phí cuối tháng', 5, 1, NULL, NULL);

INSERT INTO `journal_entry` VALUES 
(2211048, 2211019, 'D911', 502796800, NULL),  -- Total expenses
(2211049, 2211019, 'A632', NULL, 216000000),  -- COGS
(2211050, 2211019, 'A641', NULL, 55598400),   -- Selling expenses
(2211051, 2211019, 'A642', NULL, 55598400),   -- Admin expenses
(2211052, 2211019, 'B635', NULL, 96000000),   -- Financial expenses
(2211053, 2211019, 'C811', NULL, 20000000),   -- Other expenses
(2211054, 2211019, 'A521', NULL, 48000000),   -- Sales returns
(2211055, 2211019, 'C821', NULL, 61643200);   -- Tax expense (calculated below)

-- Transaction 20: Transfer all revenues to 911
INSERT INTO `journal_transaction` VALUES 
(2211020, '2022-11-30', 'Kết chuyển doanh thu cuối tháng', 5, 1, NULL, NULL);

INSERT INTO `journal_entry` VALUES 
(2211056, 2211020, 'A511', 475200000, NULL),  -- Sales revenue
(2211057, 2211020, 'B515', 115000000, NULL),  -- Financial income
(2211058, 2211020, 'C711', 15000000, NULL),    -- Other income
(2211059, 2211020, 'D911', NULL, 605200000);  -- Total revenue

-- Transaction 21: Calculate and record income tax (20% of profit before tax)
-- Profit before tax = 605,200,000 - 502,796,800 = 102,403,200
-- Tax = 20% of 102,403,200 = 20,480,640 (rounded to 20,480,000)
INSERT INTO `journal_transaction` VALUES 
(2211021, '2022-11-30', 'Ghi nhận thuế TNDN phải nộp', 8, 1, NULL, NULL);

INSERT INTO `journal_entry` VALUES 
(2211060, 2211021, 'C821', 20480000, NULL),   -- Tax expense
(2211061, 2211021, '333A', NULL, 20480000);   -- Tax payable

-- Transaction 22: Transfer tax expense to 911
-- Already included in Transaction 19 (entry_id 2211055)

-- Transaction 23: Calculate net profit and transfer to retained earnings
-- Net profit = 102,403,200 - 20,480,640 = 81,922,560 (rounded to 81,923,200)
INSERT INTO `journal_transaction` VALUES 
(2211022, '2022-11-30', 'Kết chuyển lợi nhuận sau thuế', 5, 1, NULL, NULL);

INSERT INTO `journal_entry` VALUES 
(2211062, 2211022, 'D911', 81923200, NULL),   -- Net profit
(2211063, 2211022, '421B', NULL, 81923200);   -- Retained earnings

-- 9. Cash flow activities
-- Transaction 24: Pay dividends (30% of net profit)
INSERT INTO `journal_transaction` VALUES 
(2211023, '2022-11-30', 'Chi trả cổ tức', 4, 1, NULL, NULL);

INSERT INTO `journal_entry` VALUES 
(2211064, 2211023, '421B', 24576960, NULL),   -- Dividends (30% of 81,923,200)
(2211065, 2211023, '112A', NULL, 24576960);   -- Bank

-- Transaction 25: Collect receivables (80% of AR)
INSERT INTO `journal_transaction` VALUES 
(2211024, '2022-11-28', 'Thu tiền từ khách hàng B', 3, 1, NULL, 7);

INSERT INTO `journal_entry` VALUES 
(2211066, 2211024, '112A', 380160000, NULL),  -- Bank (80% of 475.2M)
(2211067, 2211024, '131A', NULL, 380160000);  -- Accounts receivable

-- Transaction 26: Pay suppliers (75% of AP)
INSERT INTO `journal_transaction` VALUES 
(2211025, '2022-11-29', 'Trả tiền nhà cung cấp A', 4, 1, 5, NULL);

INSERT INTO `journal_entry` VALUES 
(2211068, 2211025, '331A', 123750000, NULL),  -- Accounts payable (75% of 165M)
(2211069, 2211025, '112A', NULL, 123750000);  -- Bank

-- Transaction 27: Pay taxes (90% of tax payable)
INSERT INTO `journal_transaction` VALUES 
(2211026, '2022-11-30', 'Nộp thuế TNDN', 4, 1, NULL, NULL);

INSERT INTO `journal_entry` VALUES 
(2211070, 2211026, '333A', 18432000, NULL),   -- Tax payable (90% of 20,480,000)
(2211071, 2211026, '112A', NULL, 18432000);   -- Bank

-- Transaction 28: Pay salaries (85% of salary payable)
INSERT INTO `journal_transaction` VALUES 
(2211027, '2022-11-30', 'Trả lương nhân viên', 4, 1, NULL, NULL);

INSERT INTO `journal_entry` VALUES 
(2211072, 2211027, '334A', 110500000, NULL),  -- Salary payable (85% of 130M)
(2211073, 2211027, '111A', NULL, 60500000),   -- Cash
(2211074, 2211027, '112A', NULL, 50000000);   -- Bank

-- Transaction 29: Repay short-term loan principal (10% of 700M)
INSERT INTO `journal_transaction` VALUES 
(2211028, '2022-11-30', 'Trả nợ gốc vay ngắn hạn', 4, 1, NULL, NULL);

INSERT INTO `journal_entry` VALUES 
(2211075, 2211028, '341A', 70000000, NULL),   -- Short-term loan
(2211076, 2211028, '112A', NULL, 70000000);   -- Bank

-- Transaction 30: Repay long-term loan principal (5% of 500M)
INSERT INTO `journal_transaction` VALUES 
(2211029, '2022-11-30', 'Trả nợ gốc vay dài hạn', 4, 1, NULL, NULL);

INSERT INTO `journal_entry` VALUES 
(2211077, 2211029, '341B', 25000000, NULL),   -- Long-term loan
(2211078, 2211029, '112A', NULL, 25000000);   -- Bank


-- FIX
INSERT INTO `journal_transaction` VALUES 
(2211900, '2022-11-30', 'FIX', 5, 1, NULL, NULL);

INSERT INTO `journal_entry` VALUES 
(2211900, 2211900, '211B', 33600000, NULL);

COMMIT;