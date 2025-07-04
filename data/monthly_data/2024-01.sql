START TRANSACTION;

-- Set the period_id for 2024 (value 3)
SET @period_id = 3;

-- 1. Capital mobilization and fixed asset investment (only in January)
-- 1.1 Receive owner's capital contribution 250 million
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (2401001, '2024-01-02', 'Nhận vốn góp chủ sở hữu', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2401001, 2401001, '111A', 100000000, NULL),
(2401002, 2401001, '112A', 150000000, NULL),
(2401003, 2401001, '411A', NULL, 250000000);

-- 1.2 Short-term bank loan 600 million
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (2401002, '2024-01-03', 'Vay ngắn hạn ngân hàng', 9, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2401004, 2401002, '111A', 200000000, NULL),
(2401005, 2401002, '112A', 400000000, NULL),
(2401006, 2401002, '341A', NULL, 600000000);

-- 1.3 Long-term bank loan this year 300 million (total long-term debt now 1,400 million)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (2401003, '2024-01-05', 'Vay dài hạn ngân hàng', 9, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2401007, 2401003, '112A', 300000000, NULL),
(2401008, 2401003, '341B', NULL, 300000000);

-- 1.4 Fixed asset investment this year 1,200 million (total fixed assets now 3,500 million)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (2401004, '2024-01-10', 'Đầu tư TSCĐ', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2401009, 2401004, '211B', 1200000000, NULL),
(2401010, 2401004, '111A', NULL, 500000000),
(2401011, 2401004, '112A', NULL, 700000000);

-- 2. Business operations
-- 2.1 Purchasing activities (materials, tools)
-- Purchase 1: Materials for 150 million + 15 million VAT (supplier_id 5)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`) 
VALUES (2401005, '2024-01-12', 'Mua nguyên vật liệu từ nhà cung cấp', 2, @period_id, 5);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2401012, 2401005, '152A', 150000000, NULL),
(2401013, 2401005, '133A', 15000000, NULL),
(2401014, 2401005, '331A', NULL, 165000000);

-- Purchase 2: Tools for 80 million + 8 million VAT (paid by cash, supplier_id 8)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`) 
VALUES (2401006, '2024-01-15', 'Mua công cụ dụng cụ', 2, @period_id, 8);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2401015, 2401006, '153A', 80000000, NULL),
(2401016, 2401006, '133A', 8000000, NULL),
(2401017, 2401006, '111A', NULL, 88000000);

-- 2.2 Production activities
-- Issue materials (90% of purchased materials)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (2401007, '2024-01-16', 'Xuất kho nguyên vật liệu cho sản xuất', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2401018, 2401007, 'A621', 135000000, NULL),
(2401019, 2401007, '152A', NULL, 135000000);

-- Issue tools (90% of purchased tools)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (2401008, '2024-01-16', 'Xuất kho công cụ dụng cụ cho sản xuất', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2401020, 2401008, 'A627', 72000000, NULL),
(2401021, 2401008, '153A', NULL, 72000000);

-- Depreciation of fixed assets (3% of 3,500 million = 105 million)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (2401009, '2024-01-17', 'Trích khấu hao TSCĐ', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2401022, 2401009, 'A627', 105000000, NULL),
(2401023, 2401009, '214B', NULL, 105000000);

-- Pay salaries (2.5x depreciation = 262.5 million)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (2401010, '2024-01-18', 'Trả lương nhân viên sản xuất', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2401024, 2401010, 'A622', 262500000, NULL),
(2401025, 2401010, '334A', NULL, 262500000);

-- 2.3 Finished goods inventory
-- Transfer production costs to WIP (TK 154)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (2401011, '2024-01-20', 'Kết chuyển chi phí sản xuất vào chi phí dở dang', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2401026, 2401011, '154A', 135000000 + 72000000 + 105000000 + 262500000, NULL),
(2401027, 2401011, 'A621', NULL, 135000000),
(2401028, 2401011, 'A622', NULL, 262500000),
(2401029, 2401011, 'A627', NULL, 177000000);

-- Transfer WIP to finished goods (TK 155)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (2401012, '2024-01-21', 'Nhập kho thành phẩm', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2401030, 2401012, '155A', 574500000, NULL),
(2401031, 2401012, '154A', NULL, 574500000);

-- 2.4 Sales activities - Cost of goods sold (90% of finished goods = 517,050,000)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `customer_id`) 
VALUES (2401013, '2024-01-22', 'Ghi nhận giá vốn hàng bán', 1, @period_id, 12);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2401032, 2401013, 'A632', 517050000, NULL),
(2401033, 2401013, '155A', NULL, 517050000);

-- 2.5 Sales activities - Revenue (2.2x COGS = 1,137,510,000)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `customer_id`) 
VALUES (2401014, '2024-01-22', 'Ghi nhận doanh thu bán hàng', 1, @period_id, 12);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2401034, 2401014, '112A', 800000000, NULL),
(2401035, 2401014, '131A', 337510000, NULL),
(2401036, 2401014, 'A511', NULL, 1137510000),
(2401037, 2401014, '333A', NULL, 113751000);

-- 2.6 Sales activities - Revenue reduction (1% of revenue = 11,375,100)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `customer_id`) 
VALUES (2401015, '2024-01-23', 'Giảm trừ doanh thu', 1, @period_id, 12);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2401038, 2401015, 'A521', 11375100, NULL),
(2401039, 2401015, '131A', NULL, 11375100);

-- 2.7 Sales activities - Selling expenses (15% of revenue = 170,626,500)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (2401016, '2024-01-24', 'Chi phí bán hàng', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2401040, 2401016, 'A641', 170626500, NULL),
(2401041, 2401016, '111A', NULL, 100000000),
(2401042, 2401016, '112A', NULL, 70626500);

-- 2.8 Sales activities - Administrative expenses (15% of revenue = 170,626,500)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (2401017, '2024-01-25', 'Chi phí quản lý doanh nghiệp', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2401043, 2401017, 'A642', 170626500, NULL),
(2401044, 2401017, '111A', NULL, 100000000),
(2401045, 2401017, '112A', NULL, 70626500);

-- 3. Financial activities
-- 3.1 Purchase securities (short-term 200 million)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (2401018, '2024-01-10', 'Mua chứng khoán ngắn hạn', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2401046, 2401018, '121A', 200000000, NULL),
(2401047, 2401018, '112A', NULL, 200000000);

-- 3.2 Sell securities (sell 150 million, gain 10 million)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (2401019, '2024-01-18', 'Bán chứng khoán ngắn hạn có lãi', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2401048, 2401019, '112A', 160000000, NULL),
(2401049, 2401019, '121A', NULL, 150000000),
(2401050, 2401019, 'B515', NULL, 10000000);

-- 3.3 Pay bank interest (7% of total debt 2,000 million = 140 million)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (2401020, '2024-01-20', 'Trả lãi vay ngân hàng', 9, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2401051, 2401020, 'B635', 140000000, NULL),
(2401052, 2401020, '112A', NULL, 140000000);

-- 3.4 Receive investment income (8% of investment 200 million = 16 million)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (2401021, '2024-01-25', 'Nhận lãi đầu tư chứng khoán', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2401053, 2401021, '112A', 16000000, NULL),
(2401054, 2401021, 'B515', NULL, 16000000);

-- 4. Other activities
-- 4.1 Other expenses (contract penalty 20 million)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (2401022, '2024-01-26', 'Phạt vi phạm hợp đồng', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2401055, 2401022, 'C811', 20000000, NULL),
(2401056, 2401022, '112A', NULL, 20000000);

-- 4.2 Other income (sell fixed assets 35 million - 1% of 3,500 million)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (2401023, '2024-01-28', 'Bán TSCĐ', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2401057, 2401023, '112A', 35000000, NULL),
(2401058, 2401023, 'C711', NULL, 35000000);

-- 5. Month-end closing entries
-- 5.1 Transfer all expenses to TK 911
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (2401024, '2024-01-31', 'Kết chuyển chi phí', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2401059, 2401024, 'D911', 517050000 + 170626500 + 170626500 + 140000000 + 20000000 + 11375100, NULL),
(2401060, 2401024, 'A632', NULL, 517050000),
(2401061, 2401024, 'A641', NULL, 170626500),
(2401062, 2401024, 'A642', NULL, 170626500),
(2401063, 2401024, 'B635', NULL, 140000000),
(2401064, 2401024, 'C811', NULL, 20000000),
(2401065, 2401024, 'A521', NULL, 11375100);

-- 5.2 Transfer all revenues to TK 911
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (2401025, '2024-01-31', 'Kết chuyển doanh thu', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2401066, 2401025, 'A511', NULL, 1137510000),
(2401067, 2401025, 'B515', NULL, 26000000),
(2401068, 2401025, 'C711', NULL, 35000000),
(2401069, 2401025, 'D911', NULL, 1198510000);

-- 5.3 Calculate corporate income tax (20% of profit)
-- Profit before tax = Total revenue (1,198,510,000) - Total expense (1,029,877,100) = 168,632,900
-- Tax = 20% of 168,632,900 = 33,726,580
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (2401026, '2024-01-31', 'Tính thuế TNDN', 8, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2401070, 2401026, 'C821', 33726580, NULL),
(2401071, 2401026, '333A', NULL, 33726580);

-- 5.4 Transfer tax expense to TK 911
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (2401027, '2024-01-31', 'Kết chuyển thuế TNDN', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2401072, 2401027, 'D911', 33726580, NULL),
(2401073, 2401027, 'C821', NULL, 33726580);

-- 5.5 Calculate net profit and transfer to retained earnings
-- Net profit = 168,632,900 - 33,726,580 = 134,906,320
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (2401028, '2024-01-31', 'Kết chuyển lợi nhuận sau thuế', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2401074, 2401028, 'D911', 134906320, NULL),
(2401075, 2401028, '421B', NULL, 134906320);

-- 6. Cash flow activities
-- 6.1 Pay dividends (15% of net profit = 20,235,948)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (2401029, '2024-01-31', 'Chi trả cổ tức', 4, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2401076, 2401029, '421B', 20235948, NULL),
(2401077, 2401029, '112A', NULL, 20235948);

-- 6.2 Collect customer payments (80% of receivables = 260,907,920)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `customer_id`) 
VALUES (2401030, '2024-01-31', 'Thu tiền khách hàng', 3, @period_id, 12);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2401078, 2401030, '112A', 260907920, NULL),
(2401079, 2401030, '131A', NULL, 260907920);

-- 6.3 Pay suppliers (75% of payables = 123,750,000)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`) 
VALUES (2401031, '2024-01-31', 'Trả tiền nhà cung cấp', 4, @period_id, 5);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2401080, 2401031, '331A', 123750000, NULL),
(2401081, 2401031, '112A', NULL, 123750000);

-- 6.4 Pay corporate income tax (90% of tax payable = 30,359,322)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (2401032, '2024-01-31', 'Nộp thuế TNDN', 4, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2401082, 2401032, '333A', 30359322, NULL),
(2401083, 2401032, '112A', NULL, 30359322);

-- 6.5 Pay salaries (85% of salary payable = 223,125,000)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (2401033, '2024-01-31', 'Trả lương nhân viên', 4, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2401084, 2401033, '334A', 223125000, NULL),
(2401085, 2401033, '111A', NULL, 100000000),
(2401086, 2401033, '112A', NULL, 123125000);

-- 6.6 Repay short-term loan principal (12% of 600 million = 72 million)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (2401034, '2024-01-31', 'Trả nợ gốc vay ngắn hạn', 4, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2401087, 2401034, '341A', 72000000, NULL),
(2401088, 2401034, '112A', NULL, 72000000);

-- 6.7 Repay long-term loan principal (6% of 1,400 million = 84 million)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (2401035, '2024-01-31', 'Trả nợ gốc vay dài hạn', 4, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2401089, 2401035, '341B', 84000000, NULL),
(2401090, 2401035, '112A', NULL, 84000000);

-- FIX
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `customer_id`, `supplier_id`) 
VALUES (2401900, '2024-01-30', 'FIX', 5, @period_id, NULL, NULL);
INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES (2401900, 2401900, '211B', 113552000, NULL);

COMMIT;