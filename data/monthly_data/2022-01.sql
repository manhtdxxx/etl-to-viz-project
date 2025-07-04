START TRANSACTION;

-- Set period_id for 2022
SET @period_id = 1;

-- 1. Capital mobilization and fixed asset investment
-- Transaction 1: Owner's capital contribution
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES (2201001, '2022-01-02', 'Nhận vốn góp chủ sở hữu', 5, @period_id, NULL, NULL);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2201001, 2201001, '111A', 600000000, NULL),
(2201002, 2201001, '112A', 600000000, NULL),
(2201003, 2201001, '411A', NULL, 1200000000);

-- Transaction 2: Short-term bank loan
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES (2201002, '2022-01-03', 'Vay ngắn hạn ngân hàng', 9, @period_id, NULL, NULL);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2201004, 2201002, '111A', 350000000, NULL),
(2201005, 2201002, '112A', 350000000, NULL),
(2201006, 2201002, '341A', NULL, 700000000);

-- Transaction 3: Long-term bank loan
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES (2201003, '2022-01-04', 'Vay dài hạn ngân hàng', 9, @period_id, NULL, NULL);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2201007, 2201003, '111A', 250000000, NULL),
(2201008, 2201003, '112A', 250000000, NULL),
(2201009, 2201003, '341B', NULL, 500000000);

-- Transaction 4: Fixed asset investment
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES (2201004, '2022-01-05', 'Đầu tư TSCĐ hữu hình', 5, @period_id, 5, NULL);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2201010, 2201004, '211B', 1500000000, NULL),
(2201011, 2201004, '111A', NULL, 750000000),
(2201012, 2201004, '112A', NULL, 750000000);

-- 2. Business operations
-- Transaction 5: Purchase of raw materials (cash)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES (2201005, '2022-01-06', 'Mua nguyên vật liệu bằng tiền mặt', 2, @period_id, 8, NULL);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2201013, 2201005, '152A', 181818182, NULL),
(2201014, 2201005, '133A', 18181818, NULL),
(2201015, 2201005, '111A', NULL, 200000000);

-- Transaction 6: Purchase of tools (on credit)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES (2201006, '2022-01-07', 'Mua công cụ dụng cụ trả chậm', 2, @period_id, 12, NULL);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2201016, 2201006, '153A', 136363636, NULL),
(2201017, 2201006, '133A', 13636364, NULL),
(2201018, 2201006, '331A', NULL, 150000000);

-- Transaction 7: Raw materials issued to production
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES (2201007, '2022-01-10', 'Xuất nguyên vật liệu cho sản xuất', 5, @period_id, NULL, NULL);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2201019, 2201007, 'A621', 163636364, NULL),
(2201020, 2201007, '152A', NULL, 163636364);

-- Transaction 8: Tools issued to production
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES (2201008, '2022-01-10', 'Xuất công cụ dụng cụ cho sản xuất', 5, @period_id, NULL, NULL);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2201021, 2201008, 'A627', 122727273, NULL),
(2201022, 2201008, '153A', NULL, 122727273);

-- Transaction 9: Depreciation of fixed assets
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES (2201009, '2022-01-15', 'Trích khấu hao TSCĐ', 5, @period_id, NULL, NULL);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2201023, 2201009, 'A627', 37500000, NULL), -- 2.5% of 1,500,000,000
(2201024, 2201009, '214B', NULL, 37500000);

-- Transaction 10: Salary payment
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES (2201010, '2022-01-15', 'Trả lương nhân viên sản xuất', 5, @period_id, NULL, NULL);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2201025, 2201010, 'A622', 90000000, NULL), -- 2.4x depreciation
(2201026, 2201010, '334A', NULL, 90000000);

-- Transaction 11: Transfer production costs to WIP
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES (2201011, '2022-01-20', 'Kết chuyển chi phí sản xuất vào CPSXDD', 5, @period_id, NULL, NULL);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2201027, 2201011, '154A', 291136364, NULL), -- 163,636,364 + 122,727,273 + 3,750,000 + 900,000
(2201028, 2201011, 'A621', NULL, 163636364),
(2201029, 2201011, 'A622', NULL, 90000000),
(2201030, 2201011, 'A627', NULL, 37500000);

-- Transaction 12: Transfer WIP to finished goods
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES (2201012, '2022-01-21', 'Nhập kho thành phẩm', 5, @period_id, NULL, NULL);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2201031, 2201012, '155A', 291136364, NULL),
(2201032, 2201012, '154A', NULL, 291136364);

-- Transaction 13: Record cost of goods sold (sold 85% of inventory)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES (2201013, '2022-01-22', 'Ghi nhận giá vốn hàng bán', 1, @period_id, NULL, 7);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2201033, 2201013, 'A632', 247465909, NULL), -- 85% of 291,136,364
(2201034, 2201013, '155A', NULL, 247465909);

-- Transaction 14: Record sales revenue (1.8x COGS)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES (2201014, '2022-01-22', 'Ghi nhận doanh thu bán hàng', 1, @period_id, NULL, 7);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2201035, 2201014, '112A', 396000000, NULL), -- 80% cash
(2201036, 2201014, '131A', 99000000, NULL), -- 20% credit
(2201037, 2201014, 'A511', NULL, 445500000), -- 1.8x COGS (247,465,909 * 1.8 = 445,438,636) rounded to 445,500,000
(2201038, 2201014, '333A', NULL, 49500000); -- 10% VAT

-- Transaction 15: Sales discounts
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES (2201015, '2022-01-22', 'Ghi nhận giảm trừ doanh thu', 1, @period_id, NULL, 7);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2201039, 2201015, 'A521', 22275000, NULL), -- 5% of revenue
(2201040, 2201015, '131A', NULL, 22275000);

-- Transaction 16: Record selling expenses
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES (2201016, '2022-01-25', 'Ghi nhận chi phí bán hàng', 5, @period_id, NULL, NULL);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2201041, 2201016, 'A641', 66712500, NULL), -- 15% of revenue (445,500,000 * 0.15)
(2201042, 2201016, '334A', NULL, 66712500);

-- Transaction 17: Record administrative expenses
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES (2201017, '2022-01-25', 'Ghi nhận chi phí quản lý doanh nghiệp', 5, @period_id, NULL, NULL);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2201043, 2201017, 'A642', 66712500, NULL), -- 15% of revenue (445,500,000 * 0.15)
(2201044, 2201017, '334A', NULL, 66712500);

-- 3. Financial activities
-- Transaction 18: Purchase of securities
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES (2201018, '2022-01-18', 'Mua chứng khoán ngắn hạn', 5, @period_id, NULL, NULL);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2201045, 2201018, '121A', 200000000, NULL),
(2201046, 2201018, '112A', NULL, 200000000);

-- Transaction 19: Sale of securities (sold 40% of purchase)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES (2201019, '2022-01-28', 'Bán chứng khoán ngắn hạn', 5, @period_id, NULL, 15);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2201047, 2201019, '112A', 88000000, NULL), -- Sold at a 10% loss
(2201048, 2201019, '121A', NULL, 80000000), -- 40% of 200,000,000
(2201049, 2201019, 'B635', 2000000, NULL); -- Loss of 2,000,000 (80,000,000 - 88,000,000)

-- Transaction 20: Pay bank loan interest
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES (2201020, '2022-01-29', 'Trả lãi vay ngân hàng', 9, @period_id, NULL, NULL);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2201050, 2201020, 'B635', 72000000, NULL), -- 8% of total loans (1,200,000,000 * 0.06)
(2201051, 2201020, '112A', NULL, 72000000);

-- Transaction 21: Receive investment income
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES (2201021, '2022-01-30', 'Nhận lãi đầu tư chứng khoán', 5, @period_id, NULL, 15);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2201052, 2201021, '112A', 65000000, NULL),
(2201053, 2201021, 'B515', NULL, 65000000);

-- 4. Other activities
-- Transaction 22: Other expenses
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES (2201022, '2022-01-15', 'Chi phí phạt vi phạm hợp đồng', 5, @period_id, NULL, NULL);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2201054, 2201022, 'C811', 10000000, NULL),
(2201055, 2201022, '111A', NULL, 10000000);

-- Transaction 23: Other income (sale of fixed asset - 2.5% of original cost)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES (2201023, '2022-01-20', 'Thu nhập từ bán TSCĐ', 5, @period_id, NULL, 18);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2201056, 2201023, '112A', 37500000, NULL), -- 2.5% of 1,500,000,000
(2201057, 2201023, 'C711', NULL, 37500000);

-- 5. Month-end closing entries
-- Transaction 24: Transfer all expenses to income summary
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES (2201024, '2022-01-31', 'Kết chuyển chi phí vào TK xác định KQKD', 5, @period_id, NULL, NULL);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2201058, 2201024, 'D911', 247465909, NULL), -- COGS
(2201059, 2201024, 'A632', NULL, 247465909),
(2201060, 2201024, 'D911', 66712500, NULL), -- Selling expenses
(2201061, 2201024, 'A641', NULL, 66712500),
(2201062, 2201024, 'D911', 66712500, NULL), -- Admin expenses
(2201063, 2201024, 'A642', NULL, 66712500),
(2201064, 2201024, 'D911', 2000000, NULL), -- Financial expenses (securities loss)
(2201065, 2201024, 'B635', NULL, 2000000),
(2201066, 2201024, 'D911', 72000000, NULL), -- Financial expenses (interest)
(2201067, 2201024, 'B635', NULL, 72000000),
(2201068, 2201024, 'D911', 10000000, NULL), -- Other expenses
(2201069, 2201024, 'C811', NULL, 10000000),
(2201070, 2201024, 'D911', 22275000, NULL), -- Sales discounts
(2201071, 2201024, 'A521', NULL, 22275000);

-- Transaction 25: Transfer all revenues to income summary
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES (2201025, '2022-01-31', 'Kết chuyển doanh thu vào TK xác định KQKD', 5, @period_id, NULL, NULL);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2201072, 2201025, 'A511', 445500000, NULL), -- Sales revenue
(2201073, 2201025, 'D911', NULL, 445500000),
(2201074, 2201025, 'B515', 65000000, NULL), -- Financial income
(2201075, 2201025, 'D911', NULL, 65000000),
(2201076, 2201025, 'C711', 37500000, NULL), -- Other income
(2201077, 2201025, 'D911', NULL, 37500000);

-- Calculate profit before tax: 
-- Revenues (445,500,000 + 65,000,000 + 37,500,000) = 548,000,000
-- Expenses (247,465,909 + 66,712,500 + 66,712,500 + 2,000,000 + 72,000,000 + 10,000,000 + 22,275,000) = 487,165,909
-- PBT = 548,000,000 - 487,165,909 = 60,834,091

-- Transaction 26: Record income tax expense (20% of PBT)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES (2201026, '2022-01-31', 'Ghi nhận chi phí thuế TNDN', 5, @period_id, NULL, NULL);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2201078, 2201026, 'C821', 12166818, NULL), -- 20% of 60,834,091
(2201079, 2201026, '333A', NULL, 12166818);

-- Transaction 27: Transfer tax expense to income summary
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES (2201027, '2022-01-31', 'Kết chuyển chi phí thuế vào TK xác định KQKD', 5, @period_id, NULL, NULL);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2201080, 2201027, 'D911', 12166818, NULL),
(2201081, 2201027, 'C821', NULL, 12166818);

-- Calculate net profit: 60,834,091 - 12,166,818 = 48,667,273

-- Transaction 28: Transfer net profit to retained earnings
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES (2201028, '2022-01-31', 'Kết chuyển lợi nhuận sau thuế', 5, @period_id, NULL, NULL);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2201082, 2201028, 'D911', 48667273, NULL),
(2201083, 2201028, '421B', NULL, 48667273);

-- 6. Cash flow activities
-- Transaction 29: Pay dividends (30% of net profit)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES (2201029, '2022-01-31', 'Chi trả cổ tức', 4, @period_id, NULL, NULL);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2201084, 2201029, '421B', 14600182, NULL), -- 30% of 48,667,273
(2201085, 2201029, '111A', NULL, 14600182);

-- Transaction 30: Collect receivables from customers (80% of receivables)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES (2201030, '2022-01-31', 'Thu tiền khách hàng', 3, @period_id, NULL, 7);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2201086, 2201030, '112A', 61380000, NULL), -- 80% of (99,000,000 - 22,275,000)
(2201087, 2201030, '131A', NULL, 61380000);

-- Transaction 31: Pay suppliers (75% of payables)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES (2201031, '2022-01-31', 'Trả tiền nhà cung cấp', 4, @period_id, 12, NULL);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2201088, 2201031, '331A', 112500000, NULL), -- 75% of 150,000,000
(2201089, 2201031, '112A', NULL, 112500000);

-- Transaction 32: Pay income tax (90% of tax payable)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES (2201032, '2022-01-31', 'Nộp thuế TNDN', 4, @period_id, NULL, NULL);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2201090, 2201032, '333A', 10950136, NULL), -- 90% of 12,166,818
(2201091, 2201032, '112A', NULL, 10950136);

-- Transaction 33: Pay salaries (85% of salary payable)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES (2201033, '2022-01-31', 'Trả lương nhân viên', 4, @period_id, NULL, NULL);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2201092, 2201033, '334A', 189000000, NULL), -- 85% of (90,000,000 + 66,712,500 + 66,712,500)
(2201093, 2201033, '111A', NULL, 189000000);

-- Transaction 34: Repay short-term loan principal (10% of short-term loan)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES (2201034, '2022-01-31', 'Trả nợ gốc vay ngắn hạn', 4, @period_id, NULL, NULL);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2201094, 2201034, '341A', 70000000, NULL), -- 10% of 700,000,000
(2201095, 2201034, '112A', NULL, 70000000);

-- Transaction 35: Repay long-term loan principal (5% of long-term loan)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES (2201035, '2022-01-31', 'Trả nợ gốc vay dài hạn', 4, @period_id, NULL, NULL);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2201096, 2201035, '341B', 25000000, NULL), -- 5% of 500,000,000
(2201097, 2201035, '112A', NULL, 25000000);


-- FIX
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES (2201900, '2022-01-31', 'FIX', 5, @period_id, NULL, NULL);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2201900, 2201900, '121B', 112727273, NULL);

COMMIT;