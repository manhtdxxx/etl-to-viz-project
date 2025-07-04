START TRANSACTION;

-- Set period_id to 2 for year 2023
SET @period_id = 2;

-- Insert transactions for capital mobilization and fixed asset investment (only in January)
-- Note: These would be in January, but since we're focusing on February, I'll skip these
-- as per your instruction that these activities are only in January

-- Insert transactions for production and business activities
-- 1. Purchasing activities (materials, tools)
INSERT INTO `journal_transaction` VALUES 
(2302001, '2023-02-05', 'Mua nguyên vật liệu từ nhà cung cấp A', 2, @period_id, 5, NULL),
(2302002, '2023-02-07', 'Mua công cụ dụng cụ từ nhà cung cấp B', 2, @period_id, 8, NULL),
(2302003, '2023-02-10', 'Thanh toán tiền mua nguyên vật liệu', 4, @period_id, 5, NULL),
(2302004, '2023-02-12', 'Mua nguyên vật liệu trả ngay bằng tiền mặt', 2, @period_id, 12, NULL);

-- Entries for transaction 2302001 (Purchase materials on credit)
INSERT INTO `journal_entry` VALUES 
(2302001, 2302001, '152A', 200000000, NULL),  -- Raw materials
(2302002, 2302001, '133A', 20000000, NULL),   -- VAT input
(2302003, 2302001, '331A', NULL, 220000000); -- Accounts payable

-- Entries for transaction 2302002 (Purchase tools on credit)
INSERT INTO `journal_entry` VALUES 
(2302004, 2302002, '153A', 50000000, NULL),  -- Tools
(2302005, 2302002, '133A', 5000000, NULL),   -- VAT input
(2302006, 2302002, '331B', NULL, 55000000); -- Long-term accounts payable

-- Entries for transaction 2302003 (Payment for materials)
INSERT INTO `journal_entry` VALUES 
(2302007, 2302003, '331A', 100000000, NULL), -- Partial payment
(2302008, 2302003, '112A', NULL, 100000000); -- Bank payment

-- Entries for transaction 2302004 (Cash purchase of materials)
INSERT INTO `journal_entry` VALUES 
(2302009, 2302004, '152A', 80000000, NULL),  -- Raw materials
(2302010, 2302004, '133A', 8000000, NULL),   -- VAT input
(2302011, 2302004, '111A', NULL, 88000000); -- Cash payment

-- 2. Production activities
INSERT INTO `journal_transaction` VALUES 
(2302005, '2023-02-15', 'Xuất kho nguyên vật liệu sản xuất', 5, @period_id, NULL, NULL),
(2302006, '2023-02-15', 'Xuất kho công cụ dụng cụ sản xuất', 5, @period_id, NULL, NULL),
(2302007, '2023-02-15', 'Trích khấu hao TSCĐ tháng 2', 5, @period_id, NULL, NULL),
(2302008, '2023-02-15', 'Trả lương nhân viên sản xuất', 5, @period_id, NULL, NULL),
(2302009, '2023-02-28', 'Kết chuyển chi phí sản xuất', 5, @period_id, NULL, NULL),
(2302010, '2023-02-28', 'Nhập kho thành phẩm', 5, @period_id, NULL, NULL);

-- Entries for transaction 2302005 (Issue materials for production)
INSERT INTO `journal_entry` VALUES 
(2302012, 2302005, 'A621', 250000000, NULL), -- Direct materials cost
(2302013, 2302005, '152A', NULL, 250000000); -- Raw materials

-- Entries for transaction 2302006 (Issue tools for production)
INSERT INTO `journal_entry` VALUES 
(2302014, 2302006, 'A627', 40000000, NULL),  -- Manufacturing overhead
(2302015, 2302006, '153A', NULL, 40000000);  -- Tools

-- Entries for transaction 2302007 (Depreciation)
-- Assuming total fixed assets of 2,500,000,000 * 3% = 75,000,000
INSERT INTO `journal_entry` VALUES 
(2302016, 2302007, 'A627', 75000000, NULL),  -- Manufacturing overhead
(2302017, 2302007, '214B', NULL, 75000000);  -- Accumulated depreciation

-- Entries for transaction 2302008 (Payroll)
-- 2.5 times depreciation = 187,500,000
INSERT INTO `journal_entry` VALUES 
(2302018, 2302008, 'A622', 150000000, NULL), -- Direct labor
(2302019, 2302008, 'A627', 37500000, NULL),   -- Indirect labor
(2302020, 2302008, '334A', NULL, 187500000);  -- Salaries payable

-- Entries for transaction 2302009 (Transfer production costs)
-- Sum of A621 (250,000,000) + A622 (150,000,000) + A627 (40,000,000 + 75,000,000 + 37,500,000 = 152,500,000)
INSERT INTO `journal_entry` VALUES 
(2302021, 2302009, '154A', 552500000, NULL),  -- WIP
(2302022, 2302009, 'A621', NULL, 250000000),
(2302023, 2302009, 'A622', NULL, 150000000),
(2302024, 2302009, 'A627', NULL, 152500000);

-- Entries for transaction 2302010 (Transfer finished goods)
INSERT INTO `journal_entry` VALUES 
(2302025, 2302010, '155A', 552500000, NULL),  -- Finished goods
(2302026, 2302010, '154A', NULL, 552500000);  -- WIP

-- 3. Sales activities
INSERT INTO `journal_transaction` VALUES 
(2302011, '2023-02-18', 'Bán hàng cho khách hàng X trả chậm', 1, @period_id, NULL, 3),
(2302012, '2023-02-20', 'Bán hàng cho khách hàng Y trả ngay', 1, @period_id, NULL, 7),
(2302013, '2023-02-22', 'Ghi nhận giá vốn hàng bán cho khách X', 1, @period_id, NULL, 3),
(2302014, '2023-02-22', 'Ghi nhận giá vốn hàng bán cho khách Y', 1, @period_id, NULL, 7),
(2302015, '2023-02-25', 'Chi phí bán hàng', 5, @period_id, NULL, NULL),
(2302016, '2023-02-25', 'Chi phí quản lý doanh nghiệp', 5, @period_id, NULL, NULL);

-- Calculate COGS (80% of finished goods = 442,000,000)
-- Split between two customers (60% and 40%)
-- Entries for transaction 2302013 (COGS for customer X)
INSERT INTO `journal_entry` VALUES 
(2302027, 2302013, 'A632', 265200000, NULL),  -- 60% of COGS
(2302028, 2302013, '155A', NULL, 265200000);

-- Entries for transaction 2302014 (COGS for customer Y)
INSERT INTO `journal_entry` VALUES 
(2302029, 2302014, 'A632', 176800000, NULL),  -- 40% of COGS
(2302030, 2302014, '155A', NULL, 176800000);

-- Total COGS = 442,000,000
-- Sales revenue = 2.2 times COGS = 972,400,000
-- Split between two customers (60% and 40%)

-- Entries for transaction 2302011 (Sales to customer X on credit)
INSERT INTO `journal_entry` VALUES 
(2302031, 2302011, '131A', 583440000, NULL),  -- 60% of revenue
(2302032, 2302011, 'A521', 9724000, NULL),    -- 1% sales discount
(2302033, 2302011, '333A', NULL, 58344000),  -- VAT output (10%)
(2302034, 2302011, 'A511', NULL, 622920000); -- Net revenue

-- Entries for transaction 2302012 (Cash sales to customer Y)
INSERT INTO `journal_entry` VALUES 
(2302035, 2302012, '112A', 388960000, NULL),   -- 40% of revenue
(2302036, 2302012, 'A521', 6483000, NULL),    -- 1% sales discount
(2302037, 2302012, '333A', NULL, 38896000),   -- VAT output (10%)
(2302038, 2302012, 'A511', NULL, 415280000); -- Net revenue

-- Entries for transaction 2302015 (Selling expenses - 13% of revenue)
INSERT INTO `journal_entry` VALUES 
(2302039, 2302015, 'A641', 126412000, NULL),  -- Selling expenses
(2302040, 2302015, '334A', NULL, 80000000),  -- Salaries
(2302041, 2302015, '331A', NULL, 46412000);   -- Other expenses

-- Entries for transaction 2302016 (Admin expenses - 13% of revenue)
INSERT INTO `journal_entry` VALUES 
(2302042, 2302016, 'A642', 126412000, NULL),  -- Admin expenses
(2302043, 2302016, '334A', NULL, 80000000),  -- Salaries
(2302044, 2302016, '214B', NULL, 20000000),  -- Depreciation
(2302045, 2302016, '331A', NULL, 26412000);   -- Other expenses

-- 4. Financial activities
INSERT INTO `journal_transaction` VALUES 
(2302017, '2023-02-08', 'Mua chứng khoán ngắn hạn', 5, @period_id, NULL, NULL),
(2302018, '2023-02-16', 'Bán chứng khoán ngắn hạn', 5, @period_id, NULL, NULL),
(2302019, '2023-02-25', 'Trả lãi vay ngân hàng', 5, @period_id, NULL, NULL),
(2302020, '2023-02-28', 'Nhận lãi đầu tư chứng khoán', 5, @period_id, NULL, NULL);

-- Total bank loans: 900 (short) + 1,100 (long) = 2,000 million
-- Interest expense: 8% of 2,000 = 160,000,000
-- Interest income: 180,000,000 (slightly higher)

-- Entries for transaction 2302017 (Purchase short-term securities)
INSERT INTO `journal_entry` VALUES 
(2302046, 2302017, '121A', 300000000, NULL), -- Short-term investments
(2302047, 2302017, '112A', NULL, 300000000); -- Bank payment

-- Entries for transaction 2302018 (Sell short-term securities at profit)
INSERT INTO `journal_entry` VALUES 
(2302048, 2302018, '112A', 220000000, NULL),  -- Cash received
(2302049, 2302018, '121A', NULL, 200000000),  -- Cost of securities
(2302050, 2302018, 'B515', NULL, 20000000);  -- Gain on sale

-- Entries for transaction 2302019 (Pay loan interest)
INSERT INTO `journal_entry` VALUES 
(2302051, 2302019, 'B635', 160000000, NULL), -- Interest expense
(2302052, 2302019, '112A', NULL, 160000000); -- Bank payment

-- Entries for transaction 2302020 (Receive investment income)
INSERT INTO `journal_entry` VALUES 
(2302053, 2302020, '112A', 180000000, NULL), -- Cash received
(2302054, 2302020, 'B515', NULL, 180000000); -- Investment income

-- 5. Other activities
INSERT INTO `journal_transaction` VALUES 
(2302021, '2023-02-14', 'Chi phí phạt hợp đồng', 5, @period_id, NULL, NULL),
(2302022, '2023-02-28', 'Thu nhập bán phế liệu', 5, @period_id, NULL, NULL),
(2302023, '2023-02-28', 'Bán TSCĐ không còn sử dụng', 5, @period_id, NULL, NULL);

-- Entries for transaction 2302021 (Contract penalty)
INSERT INTO `journal_entry` VALUES 
(2302055, 2302021, 'C811', 50000000, NULL),  -- Other expenses
(2302056, 2302021, '111A', NULL, 50000000); -- Cash payment

-- Entries for transaction 2302022 (Scrap sales)
INSERT INTO `journal_entry` VALUES 
(2302057, 2302022, '111A', 30000000, NULL),  -- Cash received
(2302058, 2302022, 'C711', NULL, 30000000); -- Other income

-- Entries for transaction 2302023 (Sell fixed asset)
-- 2.5% of 2,500,000,000 = 62,500,000
INSERT INTO `journal_entry` VALUES 
(2302059, 2302023, '112A', 62500000, NULL),  -- Cash received
(2302060, 2302023, '211B', NULL, 50000000),  -- Fixed asset cost
(2302061, 2302023, '214B', NULL, 10000000),  -- Accumulated depreciation
(2302062, 2302023, 'C711', NULL, 22500000); -- Gain on sale

-- 6. Month-end closing entries
INSERT INTO `journal_transaction` VALUES 
(2302024, '2023-02-28', 'Kết chuyển doanh thu', 5, @period_id, NULL, NULL),
(2302025, '2023-02-28', 'Kết chuyển chi phí', 5, @period_id, NULL, NULL),
(2302026, '2023-02-28', 'Hạch toán thuế TNDN', 5, @period_id, NULL, NULL),
(2302027, '2023-02-28', 'Kết chuyển thuế TNDN', 5, @period_id, NULL, NULL),
(2302028, '2023-02-28', 'Kết chuyển lợi nhuận', 5, @period_id, NULL, NULL);

-- Calculate profit before tax:
-- Revenue: 622,920,000 + 415,280,000 + 20,000,000 + 180,000,000 + 30,000,000 + 22,500,000 = 1,290,700,000
-- Expenses: 442,000,000 + 126,412,000 + 126,412,000 + 160,000,000 + 50,000,000 + 9,724,000 + 6,483,000 = 921,031,000
-- Profit before tax: 1,290,700,000 - 921,031,000 = 369,669,000
-- Tax: 20% of 369,669,000 = 73,933,800
-- Net profit: 369,669,000 - 73,933,800 = 295,735,200

-- Entries for transaction 2302024 (Transfer revenue)
INSERT INTO `journal_entry` VALUES 
(2302063, 2302024, 'A511', 1038200000, NULL), -- Sales revenue
(2302064, 2302024, 'B515', 200000000, NULL),   -- Financial income
(2302065, 2302024, 'C711', 52500000, NULL),    -- Other income
(2302066, 2302024, 'D911', NULL, 1290700000); -- Profit and loss

-- Entries for transaction 2302025 (Transfer expenses)
INSERT INTO `journal_entry` VALUES 
(2302067, 2302025, 'D911', 921031000, NULL),  -- Profit and loss
(2302068, 2302025, 'A632', NULL, 442000000),  -- COGS
(2302069, 2302025, 'A641', NULL, 126412000),  -- Selling expenses
(2302070, 2302025, 'A642', NULL, 126412000),  -- Admin expenses
(2302071, 2302025, 'B635', NULL, 160000000),  -- Financial expenses
(2302072, 2302025, 'C811', NULL, 50000000),  -- Other expenses
(2302073, 2302025, 'A521', NULL, 16207000);  -- Sales discounts

-- Entries for transaction 2302026 (Income tax)
INSERT INTO `journal_entry` VALUES 
(2302074, 2302026, 'C821', 73933800, NULL),  -- Income tax expense
(2302075, 2302026, '333A', NULL, 73933800);   -- Tax payable

-- Entries for transaction 2302027 (Transfer tax)
INSERT INTO `journal_entry` VALUES 
(2302076, 2302027, 'D911', 73933800, NULL),   -- Profit and loss
(2302077, 2302027, 'C821', NULL, 73933800);   -- Income tax expense

-- Entries for transaction 2302028 (Transfer net profit)
INSERT INTO `journal_entry` VALUES 
(2302078, 2302028, 'D911', 295735200, NULL),  -- Profit and loss
(2302079, 2302028, '421B', NULL, 295735200); -- Retained earnings

-- 7. Cash flow activities
INSERT INTO `journal_transaction` VALUES 
(2302029, '2023-02-28', 'Chi trả cổ tức', 4, @period_id, NULL, NULL),
(2302030, '2023-02-28', 'Thu tiền khách hàng', 3, @period_id, NULL, 3),
(2302031, '2023-02-28', 'Trả tiền nhà cung cấp', 4, @period_id, 5, NULL),
(2302032, '2023-02-28', 'Nộp thuế TNDN', 4, @period_id, NULL, NULL),
(2302033, '2023-02-28', 'Trả lương nhân viên', 4, @period_id, NULL, NULL),
(2302034, '2023-02-28', 'Trả nợ gốc vay ngắn hạn', 4, @period_id, NULL, NULL),
(2302035, '2023-02-28', 'Trả nợ gốc vay dài hạn', 4, @period_id, NULL, NULL);

-- Dividend payment (15% of net profit)
INSERT INTO `journal_entry` VALUES 
(2302080, 2302029, '421B', 44360280, NULL),   -- Retained earnings
(2302081, 2302029, '112A', NULL, 44360280);  -- Bank payment

-- Collect from customers (80% of receivables)
INSERT INTO `journal_entry` VALUES 
(2302082, 2302030, '112A', 466752000, NULL), -- Bank receipt
(2302083, 2302030, '131A', NULL, 466752000); -- Accounts receivable

-- Pay suppliers (75% of payables)
INSERT INTO `journal_entry` VALUES 
(2302084, 2302031, '331A', 165000000, NULL),  -- Accounts payable
(2302085, 2302031, '112A', NULL, 165000000); -- Bank payment

-- Pay income tax (90% of tax payable)
INSERT INTO `journal_entry` VALUES 
(2302086, 2302032, '333A', 66540420, NULL),  -- Tax payable
(2302087, 2302032, '112A', NULL, 66540420);   -- Bank payment

-- Pay salaries (85% of salaries payable)
INSERT INTO `journal_entry` VALUES 
(2302088, 2302033, '334A', 227437500, NULL),  -- Salaries payable
(2302089, 2302033, '111A', NULL, 159206250), -- Cash payment
(2302090, 2302033, '112A', NULL, 68231250);  -- Bank payment

-- Repay short-term loan (10% of 900,000,000)
INSERT INTO `journal_entry` VALUES 
(2302091, 2302034, '341A', 90000000, NULL),  -- Short-term loan
(2302092, 2302034, '112A', NULL, 90000000); -- Bank payment

-- Repay long-term loan (5% of 1,100,000,000)
INSERT INTO `journal_entry` VALUES 
(2302093, 2302035, '341B', 55000000, NULL),   -- Long-term loan
(2302094, 2302035, '112A', NULL, 55000000);  -- Bank payment


-- FIX
INSERT INTO `journal_transaction` VALUES 
(2302900, '2023-02-28', 'FIX', 5, @period_id, NULL, NULL);
INSERT INTO `journal_entry` VALUES 
(2302900, 2302900, '211B', 166833000, NULL);

COMMIT;