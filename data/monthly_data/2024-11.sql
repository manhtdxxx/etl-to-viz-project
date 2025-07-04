START TRANSACTION;

-- Set transaction IDs for November 2024 (yy=24, mm=11)
-- Using trans_id from 2411001 onwards and entry_id from 2411001 onwards

-- 1. Capital mobilization and fixed asset investment (only in January, but we'll skip as it's November)
-- Note: Since it's November, we won't include these initial transactions as per your instruction

-- 2. Business operations

-- 2.1 Purchasing activities (buying materials and tools)
INSERT INTO `journal_transaction` VALUES 
(2411001, '2024-11-05', 'Mua nguyên vật liệu từ nhà cung cấp A', 2, 3, 5, NULL),
(2411002, '2024-11-07', 'Mua công cụ dụng cụ từ nhà cung cấp B', 2, 3, 8, NULL);

INSERT INTO `journal_entry` VALUES 
-- Transaction 2411001: Buy materials on credit (total 180tr + VAT 10% = 198tr)
(2411001, 2411001, '152A', 180000000, NULL),  -- Raw materials
(2411002, 2411001, '133A', 18000000, NULL),   -- VAT
(2411003, 2411001, '331A', NULL, 198000000),  -- Payable to supplier

-- Transaction 2411002: Buy tools with cash (total 50tr + VAT 10% = 55tr)
(2411004, 2411002, '153A', 50000000, NULL),   -- Tools
(2411005, 2411002, '133A', 5000000, NULL),    -- VAT
(2411006, 2411002, '112A', NULL, 55000000);   -- Bank payment

-- 2.2 Production activities
INSERT INTO `journal_transaction` VALUES 
(2411003, '2024-11-10', 'Xuất kho nguyên vật liệu sản xuất', 5, 3, NULL, NULL),
(2411004, '2024-11-10', 'Xuất kho công cụ dụng cụ sản xuất', 5, 3, NULL, NULL),
(2411005, '2024-11-10', 'Trích khấu hao TSCĐ tháng 11/2024', 5, 3, NULL, NULL),
(2411006, '2024-11-10', 'Trả lương nhân viên sản xuất', 5, 3, NULL, NULL);

-- Assume total fixed assets = 3,500,000,000 (from January)
-- Depreciation = 3% of 3,500,000,000 = 105,000,000
-- Labor cost = 2x depreciation = 210,000,000
-- Material usage = 90% of inventory (180,000,000 * 0.9 = 162,000,000)
-- Tools usage = 90% of inventory (50,000,000 * 0.9 = 45,000,000)

INSERT INTO `journal_entry` VALUES 
-- Transaction 2411003: Issue materials to production
(2411007, 2411003, 'A621', 162000000, NULL),  -- Material cost
(2411008, 2411003, '152A', NULL, 162000000),  -- Reduce material inventory

-- Transaction 2411004: Issue tools to production
(2411009, 2411004, 'A627', 45000000, NULL),   -- Production overhead
(2411010, 2411004, '153A', NULL, 45000000),   -- Reduce tools inventory

-- Transaction 2411005: Depreciation
(2411011, 2411005, 'A627', 105000000, NULL),  -- Production overhead
(2411012, 2411005, '214B', NULL, 105000000),  -- Accumulated depreciation

-- Transaction 2411006: Labor cost
(2411013, 2411006, 'A622', 210000000, NULL),  -- Labor cost
(2411014, 2411006, '334A', NULL, 210000000); -- Salary payable

-- 2.3 Finished goods
INSERT INTO `journal_transaction` VALUES 
(2411007, '2024-11-30', 'Kết chuyển chi phí sản xuất vào sản phẩm dở dang', 5, 3, NULL, NULL),
(2411008, '2024-11-30', 'Nhập kho thành phẩm từ sản phẩm dở dang', 5, 3, NULL, NULL);

-- Transfer all production costs (621, 622, 627) to WIP (154)
INSERT INTO `journal_entry` VALUES 
-- Transaction 2411007: Transfer production costs to WIP
(2411015, 2411007, '154A', 162000000, NULL),  -- From material cost
(2411016, 2411007, 'A621', NULL, 162000000),

(2411017, 2411007, '154A', 210000000, NULL),  -- From labor cost
(2411018, 2411007, 'A622', NULL, 210000000),

(2411019, 2411007, '154A', 150000000, NULL),  -- From overhead (45+105)
(2411020, 2411007, 'A627', NULL, 150000000),

-- Transaction 2411008: Transfer WIP to finished goods (154 to 155)
(2411021, 2411008, '155A', 522000000, NULL),  -- Finished goods
(2411022, 2411008, '154A', NULL, 522000000);

-- 2.4 Sales activities - Cost of goods sold
INSERT INTO `journal_transaction` VALUES 
(2411009, '2024-11-15', 'Bán hàng cho khách hàng X - ghi nhận giá vốn', 1, 3, NULL, 3),
(2411010, '2024-11-20', 'Bán hàng cho khách hàng Y - ghi nhận giá vốn', 1, 3, NULL, 7);

-- Sell 90% of finished goods (522,000,000 * 0.9 = 469,800,000)
INSERT INTO `journal_entry` VALUES 
-- Transaction 2411009: COGS for customer X (60% of sales)
(2411023, 2411009, 'A632', 281880000, NULL),  -- COGS (60% of total)
(2411024, 2411009, '155A', NULL, 281880000),

-- Transaction 2411010: COGS for customer Y (40% of sales)
(2411025, 2411010, 'A632', 187920000, NULL),  -- COGS (40% of total)
(2411026, 2411010, '155A', NULL, 187920000);

-- 2.5 Sales activities - Revenue recognition
INSERT INTO `journal_transaction` VALUES 
(2411011, '2024-11-15', 'Bán hàng cho khách hàng X - ghi nhận doanh thu', 1, 3, NULL, 3),
(2411012, '2024-11-20', 'Bán hàng cho khách hàng Y - ghi nhận doanh thu', 1, 3, NULL, 7),
(2411013, '2024-11-25', 'Giảm trừ doanh thu cho khách hàng X', 1, 3, NULL, 3);

-- Revenue = 2x COGS (469,800,000 * 2 = 939,600,000)
-- Revenue for customer X (60%) = 563,760,000
-- Revenue for customer Y (40%) = 375,840,000
-- Sales discount (5% of total revenue) = 46,980,000
-- VAT 10% on net revenue = (939,600,000 - 46,980,000) * 10% = 89,262,000

INSERT INTO `journal_entry` VALUES 
-- Transaction 2411011: Revenue from customer X (60% on credit)
(2411027, 2411011, '131A', 620136000, NULL),  -- Receivable (563,760,000 + 10% VAT)
(2411028, 2411011, 'A511', NULL, 563760000),  -- Revenue
(2411029, 2411011, '333A', NULL, 56376000),   -- VAT payable

-- Transaction 2411012: Revenue from customer Y (40% cash)
(2411030, 2411012, '112A', 413424000, NULL),  -- Bank receipt (375,840,000 + 10% VAT)
(2411031, 2411012, 'A511', NULL, 375840000),  -- Revenue
(2411032, 2411012, '333A', NULL, 37584000),  -- VAT payable

-- Transaction 2411013: Sales discount for customer X
(2411033, 2411013, 'A521', 46980000, NULL),  -- Sales discount (5% of total revenue)
(2411034, 2411013, '131A', NULL, 46980000);

-- 2.6 Sales and administrative expenses
INSERT INTO `journal_transaction` VALUES 
(2411014, '2024-11-28', 'Chi phí bán hàng tháng 11/2024', 5, 3, NULL, NULL),
(2411015, '2024-11-28', 'Chi phí quản lý doanh nghiệp tháng 11/2024', 5, 3, NULL, NULL);

-- Sales expense = 15% of revenue = 140,940,000
-- Admin expense = 15% of revenue = 140,940,000
INSERT INTO `journal_entry` VALUES 
-- Transaction 2411014: Sales expense (paid by bank)
(2411035, 2411014, 'A641', 140940000, NULL),  -- Sales expense
(2411036, 2411014, '112A', NULL, 140940000),

-- Transaction 2411015: Admin expense (paid by bank)
(2411037, 2411015, 'A642', 140940000, NULL),  -- Admin expense
(2411038, 2411015, '112A', NULL, 140940000);

-- 3. Financial activities

-- 3.1 Securities trading
INSERT INTO `journal_transaction` VALUES 
(2411016, '2024-11-08', 'Mua chứng khoán ngắn hạn', 5, 3, NULL, NULL),
(2411017, '2024-11-18', 'Bán chứng khoán ngắn hạn', 5, 3, NULL, NULL);

-- Buy securities for 200,000,000
-- Sell securities for 180,000,000 (10% loss)
INSERT INTO `journal_entry` VALUES 
-- Transaction 2411016: Buy securities
(2411039, 2411016, '121A', 200000000, NULL),  -- Short-term securities
(2411040, 2411016, '112A', NULL, 200000000), -- Bank payment

-- Transaction 2411017: Sell securities at loss
(2411041, 2411017, '112A', 180000000, NULL),  -- Bank receipt
(2411042, 2411017, 'B635', 20000000, NULL),   -- Financial loss (200-180)
(2411043, 2411017, '121A', NULL, 200000000);  -- Reduce securities

-- 3.2 Interest activities
INSERT INTO `journal_transaction` VALUES 
(2411018, '2024-11-20', 'Trả lãi vay ngân hàng tháng 11/2024', 9, 3, NULL, NULL),
(2411019, '2024-11-25', 'Nhận lãi tiền gửi ngân hàng', 5, 3, NULL, NULL);

-- Total loans: 600 (short) + 1,400 (long) = 2,000,000,000
-- Interest expense = 7% annual = 2,000,000,000 * 7% / 12 = 11,666,667
-- Interest income = 12,000,000 (slightly higher)
INSERT INTO `journal_entry` VALUES 
-- Transaction 2411018: Pay loan interest
(2411044, 2411018, 'B635', 11666667, NULL),  -- Financial expense
(2411045, 2411018, '112A', NULL, 11666667),  -- Bank payment

-- Transaction 2411019: Receive deposit interest
(2411046, 2411019, '112A', 12000000, NULL),  -- Bank receipt
(2411047, 2411019, 'B515', NULL, 12000000);  -- Financial income

-- 4. Other activities

-- 4.1 Other expenses
INSERT INTO `journal_transaction` VALUES 
(2411020, '2024-11-12', 'Phạt vi phạm hợp đồng với nhà cung cấp C', 5, 3, 12, NULL);

-- Other expense = 10,000,000
INSERT INTO `journal_entry` VALUES 
-- Transaction 2411020: Penalty expense
(2411048, 2411020, 'C811', 10000000, NULL),  -- Other expense
(2411049, 2411020, '112A', NULL, 10000000);  -- Bank payment

-- 4.2 Other income
INSERT INTO `journal_transaction` VALUES 
(2411021, '2024-11-22', 'Bán phế liệu thu hồi', 5, 3, NULL, NULL);

-- Other income = 12,000,000 (slightly higher than expense)
INSERT INTO `journal_entry` VALUES 
-- Transaction 2411021: Scrap sales
(2411050, 2411021, '112A', 12000000, NULL),  -- Bank receipt
(2411051, 2411021, 'C711', NULL, 12000000);  -- Other income

-- 5. Month-end closing entries

-- 5.1 Transfer expenses to 911
INSERT INTO `journal_transaction` VALUES 
(2411022, '2024-11-30', 'Kết chuyển chi phí sang TK 911', 5, 3, NULL, NULL);

INSERT INTO `journal_entry` VALUES 
-- Transaction 2411022: Transfer expenses
(2411052, 2411022, 'D911', 469800000, NULL),  -- COGS (281,880,000 + 187,920,000)
(2411053, 2411022, 'A632', NULL, 469800000),

(2411054, 2411022, 'D911', 140940000, NULL),  -- Sales expense
(2411055, 2411022, 'A641', NULL, 140940000),

(2411056, 2411022, 'D911', 140940000, NULL),  -- Admin expense
(2411057, 2411022, 'A642', NULL, 140940000),

(2411058, 2411022, 'D911', 31666667, NULL),   -- Financial expense (20,000,000 + 11,666,667)
(2411059, 2411022, 'B635', NULL, 31666667),

(2411060, 2411022, 'D911', 10000000, NULL),   -- Other expense
(2411061, 2411022, 'C811', NULL, 10000000),

(2411062, 2411022, 'D911', 46980000, NULL),   -- Sales discount
(2411063, 2411022, 'A521', NULL, 46980000);

-- 5.2 Transfer revenues to 911
INSERT INTO `journal_transaction` VALUES 
(2411023, '2024-11-30', 'Kết chuyển doanh thu sang TK 911', 5, 3, NULL, NULL);

INSERT INTO `journal_entry` VALUES 
-- Transaction 2411023: Transfer revenues
(2411064, 2411023, 'A511', 939600000, NULL),  -- Revenue (563,760,000 + 375,840,000)
(2411065, 2411023, 'D911', NULL, 939600000),

(2411066, 2411023, 'B515', 12000000, NULL),   -- Financial income
(2411067, 2411023, 'D911', NULL, 12000000),

(2411068, 2411023, 'C711', 12000000, NULL),   -- Other income
(2411069, 2411023, 'D911', NULL, 12000000);

-- 5.3 Calculate and record income tax
-- Profit before tax = Revenue (939,600,000 + 12,000,000 + 12,000,000) - Expenses (469,800,000 + 140,940,000 + 140,940,000 + 31,666,667 + 10,000,000 + 46,980,000)
-- = 963,600,000 - 840,326,667 = 123,273,333
-- Tax = 20% = 24,654,667

INSERT INTO `journal_transaction` VALUES 
(2411024, '2024-11-30', 'Ghi nhận thuế TNDN phải nộp', 8, 3, NULL, NULL);

INSERT INTO `journal_entry` VALUES 
-- Transaction 2411024: Income tax
(2411070, 2411024, 'C821', 24654667, NULL),   -- Income tax expense
(2411071, 2411024, '333A', NULL, 24654667);  -- Tax payable

-- 5.4 Transfer tax to 911
INSERT INTO `journal_transaction` VALUES 
(2411025, '2024-11-30', 'Kết chuyển thuế TNDN sang TK 911', 5, 3, NULL, NULL);

INSERT INTO `journal_entry` VALUES 
-- Transaction 2411025: Transfer tax
(2411072, 2411025, 'D911', 24654667, NULL),   -- Income tax
(2411073, 2411025, 'C821', NULL, 24654667);

-- 5.5 Calculate and transfer net profit
-- Net profit = 123,273,333 - 24,654,667 = 98,618,666

INSERT INTO `journal_transaction` VALUES 
(2411026, '2024-11-30', 'Kết chuyển lợi nhuận sau thuế', 5, 3, NULL, NULL);

INSERT INTO `journal_entry` VALUES 
-- Transaction 2411026: Transfer net profit
(2411074, 2411026, 'D911', 98618666, NULL),  -- Close 911
(2411075, 2411026, '421B', NULL, 98618666);  -- Retained earnings

-- 6. Cash flow activities

-- 6.1 Dividend payment (15% of net profit = 14,792,800)
INSERT INTO `journal_transaction` VALUES 
(2411027, '2024-11-30', 'Chi trả cổ tức cho chủ sở hữu', 4, 3, NULL, NULL);

INSERT INTO `journal_entry` VALUES 
-- Transaction 2411027: Dividend payment
(2411076, 2411027, '421B', 14792800, NULL),  -- Reduce retained earnings
(2411077, 2411027, '112A', NULL, 14792800); -- Bank payment

-- 6.2 Collect receivables (80% of 573,156,000 = 458,524,800)
INSERT INTO `journal_transaction` VALUES 
(2411028, '2024-11-28', 'Thu tiền từ khách hàng X', 3, 3, NULL, 3);

INSERT INTO `journal_entry` VALUES 
-- Transaction 2411028: Collect receivables
(2411078, 2411028, '112A', 458524800, NULL),  -- Bank receipt
(2411079, 2411028, '131A', NULL, 458524800); -- Reduce receivables

-- 6.3 Pay suppliers (85% of 198,000,000 = 168,300,000)
INSERT INTO `journal_transaction` VALUES 
(2411029, '2024-11-29', 'Trả tiền cho nhà cung cấp A', 4, 3, 5, NULL);

INSERT INTO `journal_entry` VALUES 
-- Transaction 2411029: Pay supplier
(2411080, 2411029, '331A', 168300000, NULL),  -- Reduce payable
(2411081, 2411029, '112A', NULL, 168300000); -- Bank payment

-- 6.4 Pay tax (90% of total tax = (56,376,000 + 37,584,000 + 24,654,667) * 90% = 106,754,400)
INSERT INTO `journal_transaction` VALUES 
(2411030, '2024-11-30', 'Nộp thuế cho nhà nước', 4, 3, NULL, NULL);

INSERT INTO `journal_entry` VALUES 
-- Transaction 2411030: Pay tax
(2411082, 2411030, '333A', 106754400, NULL),  -- Reduce tax payable
(2411083, 2411030, '112A', NULL, 106754400); -- Bank payment

-- 6.5 Pay salary (90% of 210,000,000 = 189,000,000)
INSERT INTO `journal_transaction` VALUES 
(2411031, '2024-11-30', 'Trả lương nhân viên tháng 11/2024', 4, 3, NULL, NULL);

INSERT INTO `journal_entry` VALUES 
-- Transaction 2411031: Pay salary
(2411084, 2411031, '334A', 189000000, NULL),  -- Reduce salary payable
(2411085, 2411031, '111A', NULL, 189000000); -- Cash payment

-- 6.6 Pay short-term loan principal (12% of 600,000,000 = 72,000,000)
INSERT INTO `journal_transaction` VALUES 
(2411032, '2024-11-30', 'Trả nợ gốc vay ngắn hạn', 9, 3, NULL, NULL);

INSERT INTO `journal_entry` VALUES 
-- Transaction 2411032: Pay short-term loan
(2411086, 2411032, '341A', 72000000, NULL),  -- Reduce short-term loan
(2411087, 2411032, '112A', NULL, 72000000);  -- Bank payment

-- 6.7 Pay long-term loan principal (6% of 1,400,000,000 = 84,000,000)
INSERT INTO `journal_transaction` VALUES 
(2411033, '2024-11-30', 'Trả nợ gốc vay dài hạn', 9, 3, NULL, NULL);

INSERT INTO `journal_entry` VALUES 
-- Transaction 2411033: Pay long-term loan
(2411088, 2411033, '341B', 84000000, NULL),  -- Reduce long-term loan
(2411089, 2411033, '112A', NULL, 84000000);  -- Bank payment

COMMIT;