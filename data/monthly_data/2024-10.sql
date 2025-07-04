START TRANSACTION;

-- Set period_id to 3 for year 2024
SET @period_id = 3;

-- Insert transactions for October 2024 (trans_id format: yymm000)
-- Note: Since it's October 2024, trans_id starts with 2410000

-- 2. Purchasing activities (buying materials and tools)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) VALUES
(2410005, '2024-10-05', 'Mua nguyên vật liệu từ NCC A', 2, @period_id, 3, NULL),
(2410006, '2024-10-06', 'Mua công cụ dụng cụ từ NCC B', 2, @period_id, 7, NULL),
(2410007, '2024-10-07', 'Mua nguyên vật liệu bằng tiền mặt', 2, @period_id, NULL, NULL);

-- Entries for purchasing
INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) VALUES
(2410012, 2410005, '152A', 120000000, NULL),
(2410013, 2410005, '133A', 12000000, NULL),
(2410014, 2410005, '331A', NULL, 132000000),
(2410015, 2410006, '153A', 80000000, NULL),
(2410016, 2410006, '133A', 8000000, NULL),
(2410017, 2410006, '331A', NULL, 88000000),
(2410018, 2410007, '152A', 50000000, NULL),
(2410019, 2410007, '133A', 5000000, NULL),
(2410020, 2410007, '111A', NULL, 55000000);

-- 3. Production activities
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) VALUES
(2410008, '2024-10-10', 'Xuất kho nguyên vật liệu', 5, @period_id, NULL, NULL),
(2410009, '2024-10-10', 'Xuất kho công cụ dụng cụ', 5, @period_id, NULL, NULL),
(2410010, '2024-10-15', 'Trích khấu hao TSCĐ', 5, @period_id, NULL, NULL),
(2410011, '2024-10-20', 'Trả lương nhân viên sản xuất', 5, @period_id, NULL, NULL);

-- Entries for production
-- Using 90% of materials and tools (as per 85-95% range)
INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) VALUES
(2410021, 2410008, 'A621', 153000000, NULL), -- (120M+50M)*0.9
(2410022, 2410008, '152A', NULL, 153000000),
(2410023, 2410009, 'A627', 72000000, NULL), -- 80M*0.9
(2410024, 2410009, '153A', NULL, 72000000),
-- Depreciation 3% of 3.5B TSCĐ (as per 2-4% range)
(2410025, 2410010, 'A627', 105000000, NULL), -- 3.5B * 0.03
(2410026, 2410010, '214B', NULL, 105000000),
-- Salary 2x depreciation (as per 1.5-3x range)
(2410027, 2410011, 'A622', 210000000, NULL),
(2410028, 2410011, '334A', NULL, 210000000);

-- 4. Finished goods inventory
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) VALUES
(2410012, '2024-10-25', 'Kết chuyển chi phí sản xuất vào chi phí dở dang', 5, @period_id, NULL, NULL),
(2410013, '2024-10-25', 'Nhập kho thành phẩm', 5, @period_id, NULL, NULL);

-- Entries for finished goods
-- Transfer all production costs to WIP (154)
INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) VALUES
(2410029, 2410012, '154A', 540000000, NULL), -- 153M + 210M + (72M+105M)
(2410030, 2410012, 'A621', NULL, 153000000),
(2410031, 2410012, 'A622', NULL, 210000000),
(2410032, 2410012, 'A627', NULL, 177000000),
-- Transfer WIP to finished goods (155)
(2410033, 2410013, '155A', 540000000, NULL),
(2410034, 2410013, '154A', NULL, 540000000);

-- 5. Sales activities (cost of goods sold first)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) VALUES
(2410014, '2024-10-26', 'Ghi nhận giá vốn hàng bán', 1, @period_id, NULL, 5),
(2410015, '2024-10-26', 'Ghi nhận doanh thu bán hàng', 1, @period_id, NULL, 5),
(2410016, '2024-10-27', 'Ghi nhận chi phí bán hàng và QLDN', 5, @period_id, NULL, NULL);

-- Entries for sales
-- COGS (selling 90% of finished goods as per 85-95% range)
INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) VALUES
(2410035, 2410014, 'A632', 486000000, NULL), -- 540M * 0.9
(2410036, 2410014, '155A', NULL, 486000000),
-- Revenue (1.8x COGS as per 1.6-2.5x range)
(2410037, 2410015, '131A', 1045440000, NULL), -- 486M * 1.8 * 1.1 (including 10% VAT)
(2410038, 2410015, 'A521', 20000000, NULL), -- Sales discount
(2410039, 2410015, 'A511', NULL, 874800000), -- 486M * 1.8
(2410040, 2410015, '333A', NULL, 95040000), -- 10% VAT on 486M * 1.8
-- Selling expenses (15% of revenue as per 13-18% range)
(2410041, 2410016, 'A641', 131220000, NULL), -- 874.8M * 0.15
-- Administrative expenses (15% of revenue)
(2410042, 2410016, 'A642', 131220000, NULL),
(2410043, 2410016, '334A', NULL, 262440000); -- Payable to employees

-- 6. Financial activities
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) VALUES
(2410017, '2024-10-15', 'Mua chứng khoán ngắn hạn', 5, @period_id, NULL, NULL),
(2410018, '2024-10-20', 'Bán chứng khoán ngắn hạn', 5, @period_id, NULL, NULL),
(2410019, '2024-10-25', 'Trả lãi vay ngân hàng', 9, @period_id, NULL, NULL),
(2410020, '2024-10-28', 'Nhận lãi đầu tư chứng khoán', 5, @period_id, NULL, NULL);

-- Entries for financial activities
INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) VALUES
-- Buy securities
(2410044, 2410017, '121A', 200000000, NULL),
(2410045, 2410017, '112A', NULL, 200000000),
-- Sell securities (less than bought, with profit)
(2410046, 2410018, '112A', 110000000, NULL),
(2410047, 2410018, '121A', NULL, 100000000),
(2410048, 2410018, 'B515', NULL, 10000000), -- Profit
-- Interest payment (7% of total debt 900M short-term + 1.7B long-term)
(2410049, 2410019, 'B635', 182000000, NULL), -- (900M+1.7B)*0.07
(2410050, 2410019, '112A', NULL, 182000000),
-- Investment income (slightly higher than interest paid)
(2410051, 2410020, '112A', 200000000, NULL),
(2410052, 2410020, 'B515', NULL, 200000000);

-- 7. Other activities
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) VALUES
(2410021, '2024-10-05', 'Chi phí phạt vi phạm hợp đồng', 5, @period_id, NULL, NULL),
(2410022, '2024-10-10', 'Thu nhập từ bán phế liệu', 5, @period_id, NULL, NULL),
(2410023, '2024-10-15', 'Bán TSCĐ', 5, @period_id, NULL, NULL);

-- Entries for other activities
INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) VALUES
-- Penalty expense
(2410053, 2410021, 'C811', 30000000, NULL),
(2410054, 2410021, '111A', NULL, 30000000),
-- Scrap income
(2410055, 2410022, '111A', 25000000, NULL),
(2410056, 2410022, 'C711', NULL, 25000000),
-- Sell fixed asset (1% of purchased TSCĐ)
(2410057, 2410023, '112A', 12000000, NULL), -- 1.2B * 0.01
(2410058, 2410023, '211B', NULL, 10000000),
(2410059, 2410023, '214B', 2000000, NULL), -- Accumulated depreciation
(2410060, 2410023, 'C711', NULL, 4000000); -- Gain on sale

-- 8. Month-end closing entries
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) VALUES
(2410024, '2024-10-31', 'Kết chuyển chi phí', 5, @period_id, NULL, NULL),
(2410025, '2024-10-31', 'Kết chuyển doanh thu', 5, @period_id, NULL, NULL),
(2410026, '2024-10-31', 'Tính thuế TNDN', 8, @period_id, NULL, NULL),
(2410027, '2024-10-31', 'Kết chuyển thuế TNDN', 5, @period_id, NULL, NULL),
(2410028, '2024-10-31', 'Kết chuyển lợi nhuận sau thuế', 5, @period_id, NULL, NULL);

-- Entries for closing
-- Transfer all expenses to 911
INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) VALUES
(2410061, 2410024, 'D911', 1109660000, NULL), -- 486M (COGS) + 131.22M (selling) + 131.22M (admin) + 182M (fin expense) + 30M (other expense) + 20M (sales discount)
(2410062, 2410024, 'A632', NULL, 486000000),
(2410063, 2410024, 'A641', NULL, 131220000),
(2410064, 2410024, 'A642', NULL, 131220000),
(2410065, 2410024, 'B635', NULL, 182000000),
(2410066, 2410024, 'C811', NULL, 30000000),
(2410067, 2410024, 'A521', NULL, 20000000),
-- Transfer all revenues to 911
(2410068, 2410025, 'A511', NULL, 874800000),
(2410069, 2410025, 'B515', NULL, 210000000), -- 10M + 200M
(2410070, 2410025, 'C711', NULL, 6500000), -- 2.5M + 4M
(2410071, 2410025, 'D911', 1091300000, NULL),
-- Calculate income tax (20% of profit)
-- Profit before tax = 1091300000 - 1109660000 = -18,360,000 (loss)
-- No tax on loss
(2410072, 2410026, 'C821', 0, NULL), -- No tax due to loss
(2410073, 2410026, '333A', NULL, 0),
-- Transfer tax (none in this case)
(2410074, 2410027, 'D911', 0, NULL),
(2410075, 2410027, 'C821', NULL, 0),
-- Transfer net loss to retained earnings
(2410076, 2410028, '421B', 18360000, NULL), -- Loss
(2410077, 2410028, 'D911', NULL, 18360000);

-- 9. Cash flow activities
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) VALUES
(2410029, '2024-10-28', 'Thu tiền từ khách hàng', 3, @period_id, NULL, 5),
(2410030, '2024-10-29', 'Trả tiền cho nhà cung cấp', 4, @period_id, 3, NULL),
(2410031, '2024-10-29', 'Trả lương nhân viên', 4, @period_id, NULL, NULL),
(2410032, '2024-10-30', 'Trả nợ gốc vay ngắn hạn', 9, @period_id, NULL, NULL),
(2410033, '2024-10-30', 'Trả nợ gốc vay dài hạn', 9, @period_id, NULL, NULL);

-- Entries for cash flows
-- Collect 80% of receivables (as per 75-85% range)
INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) VALUES
(2410078, 2410029, '112A', 836352000, NULL), -- 1,045,440,000 * 0.8
(2410079, 2410029, '131A', NULL, 836352000),
-- Pay 85% of payables (as per 80-90% range)
(2410080, 2410030, '331A', 187000000, NULL), -- (132M+88M)*0.85
(2410081, 2410030, '112A', NULL, 187000000),
-- Pay 90% of salary (as per 85-95% range)
(2410082, 2410031, '334A', 236196000, NULL), -- (262,440,000)*0.9
(2410083, 2410031, '111A', NULL, 236196000),
-- Pay 13% of short-term debt (as per 10-16% range)
(2410084, 2410032, '341A', 117000000, NULL), -- 900M * 0.13
(2410085, 2410032, '112A', NULL, 117000000),
-- Pay 6% of long-term debt (as per 5-8% range)
(2410086, 2410033, '341B', 102000000, NULL), -- 1.7B * 0.06
(2410087, 2410033, '112A', NULL, 102000000);


-- FIX
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES (2410900, '2024-10-30', 'FIX', 9, @period_id, NULL, NULL);
INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2410900, 2410900, '341B', NULL, 247320000);


COMMIT;