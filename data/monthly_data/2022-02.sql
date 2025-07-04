START TRANSACTION;

-- Set the period_id for 2022 (1)
SET @period_id = 1;

-- Insert transactions for purchasing activities
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) VALUES
(2202005, '2022-02-03', 'Mua nguyên vật liệu trả bằng tiền mặt', 2, @period_id, 3, NULL),
(2202006, '2022-02-05', 'Mua công cụ dụng cụ trả chậm', 2, @period_id, 7, NULL),
(2202007, '2022-02-07', 'Mua nguyên vật liệu trả bằng chuyển khoản', 2, @period_id, 12, NULL);

-- Insert entries for purchasing activities
INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) VALUES
(2202013, 2202005, '152A', 80000000, NULL),
(2202014, 2202005, '133A', 8000000, NULL),
(2202015, 2202005, '111A', NULL, 88000000),
(2202016, 2202006, '153A', 120000000, NULL),
(2202017, 2202006, '133A', 12000000, NULL),
(2202018, 2202006, '331A', NULL, 132000000),
(2202019, 2202007, '152A', 150000000, NULL),
(2202020, 2202007, '133A', 15000000, NULL),
(2202021, 2202007, '112A', NULL, 165000000);

-- Insert transactions for production activities
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) VALUES
(2202008, '2022-02-10', 'Xuất kho nguyên vật liệu cho sản xuất', 5, @period_id, NULL, NULL),
(2202009, '2022-02-10', 'Xuất kho công cụ dụng cụ cho sản xuất', 5, @period_id, NULL, NULL),
(2202010, '2022-02-15', 'Trích khấu hao TSCĐ', 5, @period_id, NULL, NULL),
(2202011, '2022-02-15', 'Trả lương nhân viên sản xuất', 5, @period_id, NULL, NULL);

-- Insert entries for production activities
INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) VALUES
(2202022, 2202008, 'A621', 200000000, NULL),
(2202023, 2202008, '152A', NULL, 200000000),
(2202024, 2202009, 'A627', 100000000, NULL),
(2202025, 2202009, '153A', NULL, 100000000),
(2202026, 2202010, 'A627', 30000000, NULL), -- 2% of 1,500,000,000
(2202027, 2202010, '214B', NULL, 30000000),
(2202028, 2202011, 'A622', 75000000, NULL), -- 2.5x depreciation
(2202029, 2202011, '334A', NULL, 75000000);

-- Insert transactions for finished goods
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) VALUES
(2202012, '2022-02-20', 'Kết chuyển chi phí sản xuất vào chi phí dở dang', 5, @period_id, NULL, NULL),
(2202013, '2022-02-25', 'Nhập kho thành phẩm', 5, @period_id, NULL, NULL);

-- Insert entries for finished goods
INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) VALUES
(2202030, 2202012, '154A', 405000000, NULL), -- Sum of A621, A622, A627 (200 + 75 + 130)
(2202031, 2202012, 'A621', NULL, 200000000),
(2202032, 2202012, 'A622', NULL, 75000000),
(2202033, 2202012, 'A627', NULL, 130000000),
(2202034, 2202013, '155A', 405000000, NULL),
(2202035, 2202013, '154A', NULL, 405000000);

-- Insert transactions for sales activities (cost of goods sold)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) VALUES
(2202014, '2022-02-18', 'Ghi nhận giá vốn hàng bán', 1, @period_id, NULL, 5),
(2202015, '2022-02-18', 'Ghi nhận doanh thu bán hàng', 1, @period_id, NULL, 5),
(2202016, '2022-02-19', 'Ghi nhận giảm trừ doanh thu', 1, @period_id, NULL, 8),
(2202017, '2022-02-20', 'Ghi nhận chi phí bán hàng', 5, @period_id, NULL, NULL),
(2202018, '2022-02-20', 'Ghi nhận chi phí quản lý doanh nghiệp', 5, @period_id, NULL, NULL);

-- Insert entries for sales activities
INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) VALUES
(2202036, 2202014, 'A632', 320000000, NULL), -- ~80% of 405,000,000
(2202037, 2202014, '155A', NULL, 320000000),
(2202038, 2202015, '131A', 704000000, NULL), -- 1.8x COGS (320M * 1.8 = 576M) + 10% VAT
(2202039, 2202015, 'A511', NULL, 640000000),
(2202040, 2202015, '333A', NULL, 64000000),
(2202041, 2202016, 'A521', 20000000, NULL),
(2202042, 2202016, '131A', NULL, 20000000),
(2202043, 2202017, 'A641', 80000000, NULL), -- ~12.5% of revenue (640M)
(2202044, 2202017, '334A', NULL, 80000000),
(2202045, 2202018, 'A642', 96000000, NULL), -- ~15% of revenue (640M)
(2202046, 2202018, '334A', NULL, 96000000);

-- Insert transactions for financial activities
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) VALUES
(2202019, '2022-02-08', 'Mua chứng khoán ngắn hạn', 5, @period_id, NULL, NULL),
(2202020, '2022-02-22', 'Bán chứng khoán ngắn hạn', 5, @period_id, NULL, NULL),
(2202021, '2022-02-25', 'Trả lãi vay ngân hàng', 9, @period_id, NULL, NULL),
(2202022, '2022-02-28', 'Nhận lãi đầu tư chứng khoán', 5, @period_id, NULL, NULL);

-- Insert entries for financial activities
INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) VALUES
(2202047, 2202019, '121A', 200000000, NULL),
(2202048, 2202019, '112A', NULL, 200000000),
(2202049, 2202020, '112A', 180000000, NULL), -- Sold at a loss
(2202050, 2202020, '121A', NULL, 200000000),
(2202051, 2202020, 'B635', 20000000, NULL),
(2202052, 2202021, 'B635', 72000000, NULL), -- 6% of total debt (1,200M)
(2202053, 2202021, '112A', NULL, 72000000),
(2202054, 2202022, '112A', 80000000, NULL),
(2202055, 2202022, 'B515', NULL, 80000000);

-- Insert transactions for other activities
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) VALUES
(2202023, '2022-02-12', 'Chi phí phạt vi phạm hợp đồng', 5, @period_id, NULL, NULL),
(2202024, '2022-02-16', 'Thu nhập từ bán phế liệu', 5, @period_id, NULL, NULL),
(2202025, '2022-02-28', 'Bán TSCĐ', 5, @period_id, NULL, 15);

-- Insert entries for other activities
INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) VALUES
(2202056, 2202023, 'C811', 10000000, NULL),
(2202057, 2202023, '111A', NULL, 10000000),
(2202058, 2202024, '112A', 15000000, NULL),
(2202059, 2202024, 'C711', NULL, 15000000),
(2202060, 2202025, '112A', 40000000, NULL), -- 2.67% of 1,500,000,000
(2202061, 2202025, '211B', NULL, 30000000),
(2202062, 2202025, '214B', 5000000, NULL),
(2202063, 2202025, 'C711', NULL, 15000000);

-- Insert transactions for month-end closing
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) VALUES
(2202026, '2022-02-28', 'Kết chuyển chi phí', 5, @period_id, NULL, NULL),
(2202027, '2022-02-28', 'Kết chuyển doanh thu', 5, @period_id, NULL, NULL),
(2202028, '2022-02-28', 'Hạch toán thuế TNDN', 8, @period_id, NULL, NULL),
(2202029, '2022-02-28', 'Kết chuyển thuế TNDN', 5, @period_id, NULL, NULL),
(2202030, '2022-02-28', 'Kết chuyển lợi nhuận sau thuế', 5, @period_id, NULL, NULL);

-- Calculate profit before tax
-- Revenue: 640,000,000 (A511) - 20,000,000 (A521) + 80,000,000 (B515) + 30,000,000 (C711) = 730,000,000
-- Expenses: 320,000,000 (A632) + 80,000,000 (A641) + 96,000,000 (A642) + 92,000,000 (B635) + 10,000,000 (C811) = 598,000,000
-- Profit before tax: 730,000,000 - 598,000,000 = 132,000,000
-- Tax: 132,000,000 * 20% = 26,400,000
-- Profit after tax: 132,000,000 - 26,400,000 = 105,600,000

-- Insert entries for month-end closing
INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) VALUES
-- Transfer expenses to 911
(2202064, 2202026, 'D911', 598000000, NULL),
(2202065, 2202026, 'A632', NULL, 320000000),
(2202066, 2202026, 'A641', NULL, 80000000),
(2202067, 2202026, 'A642', NULL, 96000000),
(2202068, 2202026, 'B635', NULL, 92000000),
(2202069, 2202026, 'A521', NULL, 20000000),
(2202070, 2202026, 'C811', NULL, 10000000),
-- Transfer revenues to 911
(2202071, 2202027, 'A511', 640000000, NULL),
(2202072, 2202027, 'B515', 80000000, NULL),
(2202073, 2202027, 'C711', 30000000, NULL),
(2202074, 2202027, 'D911', NULL, 750000000),
-- Record income tax
(2202075, 2202028, 'C821', 26400000, NULL),
(2202076, 2202028, '333A', NULL, 26400000),
-- Transfer income tax to 911
(2202077, 2202029, 'D911', 26400000, NULL),
(2202078, 2202029, 'C821', NULL, 26400000),
-- Transfer net profit to retained earnings
(2202079, 2202030, 'D911', 105600000, NULL),
(2202080, 2202030, '421B', NULL, 105600000);

-- Insert transactions for cash flow activities
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) VALUES
(2202031, '2022-02-28', 'Chi trả cổ tức', 4, @period_id, NULL, NULL),
(2202032, '2022-02-28', 'Thu tiền khách hàng', 3, @period_id, NULL, 5),
(2202033, '2022-02-28', 'Trả tiền người bán', 4, @period_id, 7, NULL),
(2202034, '2022-02-28', 'Trả thuế TNDN', 4, @period_id, NULL, NULL),
(2202035, '2022-02-28', 'Trả lương nhân viên', 4, @period_id, NULL, NULL),
(2202036, '2022-02-28', 'Trả nợ gốc vay ngắn hạn', 4, @period_id, NULL, NULL),
(2202037, '2022-02-28', 'Trả nợ gốc vay dài hạn', 4, @period_id, NULL, NULL);

-- Insert entries for cash flow activities
INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) VALUES
-- Dividend payment (30% of profit)
(2202081, 2202031, '421B', 31680000, NULL),
(2202082, 2202031, '112A', NULL, 31680000),
-- Collect from customers (80% of receivables)
(2202083, 2202032, '112A', 547200000, NULL), -- 80% of 684,000,000
(2202084, 2202032, '131A', NULL, 547200000),
-- Pay suppliers (75% of payables)
(2202085, 2202033, '331A', 99000000, NULL), -- 75% of 132,000,000
(2202086, 2202033, '112A', NULL, 99000000),
-- Pay income tax (90% of tax payable)
(2202087, 2202034, '333A', 23760000, NULL), -- 90% of 26,400,000
(2202088, 2202034, '112A', NULL, 23760000),
-- Pay salary (85% of salary payable)
(2202089, 2202035, '334A', 213350000, NULL), -- 85% of (75M + 80M + 96M) = 251M * 85% = 213.35M
(2202090, 2202035, '111A', NULL, 213350000),
-- Pay short-term loan principal (10% of short-term loan)
(2202091, 2202036, '341A', 70000000, NULL), -- 10% of 700M
(2202092, 2202036, '112A', NULL, 70000000),
-- Pay long-term loan principal (5% of long-term loan)
(2202093, 2202037, '341B', 25000000, NULL), -- 5% of 500M
(2202094, 2202037, '112A', NULL, 25000000);

COMMIT;