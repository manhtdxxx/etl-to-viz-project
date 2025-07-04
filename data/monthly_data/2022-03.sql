START TRANSACTION;

-- Set period_id to 1 for year 2022
SET @period_id = 1;

-- 1. Capital mobilization and fixed asset investment (only in January, so we'll skip for March)

-- 2. Business operations

-- 2.1 Purchasing activities (buying materials and tools)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`) 
VALUES 
(2203001, '2022-03-05', 'Mua nguyên vật liệu từ nhà cung cấp', 2, @period_id, 5),
(2203002, '2022-03-10', 'Mua công cụ dụng cụ từ nhà cung cấp', 2, @period_id, 8);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2203001, 2203001, '152A', 150000000, NULL), -- NVL
(2203002, 2203001, '133A', 15000000, NULL),  -- VAT
(2203003, 2203001, '331A', NULL, 165000000), -- Phải trả người bán

(2203004, 2203002, '153A', 80000000, NULL),  -- CCDC
(2203005, 2203002, '133A', 8000000, NULL),   -- VAT
(2203006, 2203002, '112A', NULL, 88000000);  -- Tiền gửi ngân hàng

-- 2.2 Production activities
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES 
(2203003, '2022-03-15', 'Xuất kho nguyên vật liệu sản xuất', 5, @period_id),
(2203004, '2022-03-15', 'Xuất kho công cụ dụng cụ sản xuất', 5, @period_id),
(2203005, '2022-03-15', 'Trích khấu hao TSCĐ', 5, @period_id),
(2203006, '2022-03-15', 'Trả lương nhân viên sản xuất', 5, @period_id);

-- Xuất 85% NVL (150tr * 85% = 127.5tr)
INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2203007, 2203003, 'A621', 127500000, NULL), -- Chi phí NVL trực tiếp
(2203008, 2203003, '152A', NULL, 127500000); -- Giảm NVL

-- Xuất 90% CCDC (80tr * 90% = 72tr)
INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2203009, 2203004, 'A627', 72000000, NULL),  -- Chi phí SXC
(2203010, 2203004, '153A', NULL, 72000000);  -- Giảm CCDC

-- Trích khấu hao 3% TSCĐ (1500tr * 3% = 45tr)
INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2203011, 2203005, 'A627', 45000000, NULL),  -- Chi phí SXC
(2203012, 2203005, '214B', NULL, 45000000);  -- Hao mòn TSCĐ

-- Trả lương nhân viên (2x khấu hao = 90tr)
INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2203013, 2203006, 'A622', 90000000, NULL),  -- Chi phí nhân công
(2203014, 2203006, '334A', NULL, 90000000);  -- Phải trả NLĐ

-- 2.3 Finished goods inventory
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES 
(2203007, '2022-03-31', 'Kết chuyển chi phí sản xuất', 5, @period_id),
(2203008, '2022-03-31', 'Nhập kho thành phẩm', 5, @period_id);

-- Kết chuyển chi phí sản xuất (127.5 + 90 + 45 + 72 = 334.5tr)
INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2203015, 2203007, '154A', 334500000, NULL), -- Chi phí SXDD
(2203016, 2203007, 'A621', NULL, 127500000),
(2203017, 2203007, 'A622', NULL, 90000000),
(2203018, 2203007, 'A627', NULL, 117000000);

-- Nhập kho thành phẩm
INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2203019, 2203008, '155A', 334500000, NULL), -- Thành phẩm
(2203020, 2203008, '154A', NULL, 334500000);  -- Giảm CPSXDD

-- 2.4 Sales activities - Cost of goods sold (selling 85% of inventory: 334.5tr * 85% = 284.325tr)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `customer_id`) 
VALUES 
(2203009, '2022-03-20', 'Xuất bán thành phẩm', 1, @period_id, 12);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2203021, 2203009, 'A632', 284325000, NULL), -- Giá vốn
(2203022, 2203009, '155A', NULL, 284325000);  -- Giảm thành phẩm

-- 2.5 Sales activities - Revenue (1.8x COGS = 511.785tr)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `customer_id`) 
VALUES 
(2203010, '2022-03-20', 'Ghi nhận doanh thu bán hàng', 1, @period_id, 12),
(2203011, '2022-03-20', 'Giảm trừ doanh thu', 1, @period_id, 12);

-- Doanh thu
INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2203023, 2203010, '131A', 511785000, NULL), -- Phải thu KH
(2203024, 2203010, 'A511', NULL, 500000000), -- Doanh thu
(2203025, 2203010, '333A', NULL, 11785000);  -- Thuế phải nộp

-- Giảm trừ doanh thu (2% doanh thu = 10tr)
INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2203026, 2203011, 'A521', 10000000, NULL),  -- Giảm trừ DT
(2203027, 2203011, '131A', NULL, 10000000); -- Giảm phải thu

-- 2.6 Sales expenses (12% revenue = 60tr)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES 
(2203012, '2022-03-25', 'Chi phí bán hàng', 5, @period_id),
(2203013, '2022-03-25', 'Chi phí quản lý DN', 5, @period_id);

-- Chi phí bán hàng
INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2203028, 2203012, 'A641', 30000000, NULL),  -- CP bán hàng
(2203029, 2203012, '334A', NULL, 30000000);  -- Phải trả NLĐ

-- Chi phí quản lý DN
INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2203030, 2203013, 'A642', 30000000, NULL),  -- CP QLDN
(2203031, 2203013, '334A', NULL, 30000000);  -- Phải trả NLĐ

-- 3. Financial activities

-- 3.1 Buy securities (200tr)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES 
(2203014, '2022-03-08', 'Mua chứng khoán ngắn hạn', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2203032, 2203014, '121A', 200000000, NULL), -- CK kinh doanh
(2203033, 2203014, '112A', NULL, 200000000); -- Tiền gửi NH

-- 3.2 Sell securities (sell 150tr, cost 160tr -> loss 10tr)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES 
(2203015, '2022-03-18', 'Bán chứng khoán ngắn hạn', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2203034, 2203015, '112A', 150000000, NULL), -- Tiền gửi NH
(2203035, 2203015, 'B635', 10000000, NULL),   -- Chi phí tài chính (lỗ)
(2203036, 2203015, '121A', NULL, 160000000);  -- Giảm CK kinh doanh

-- 3.3 Pay loan interest (8% of total loans: (700+500)*8% = 96tr)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES 
(2203016, '2022-03-28', 'Trả lãi vay ngân hàng', 4, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2203037, 2203016, 'B635', 96000000, NULL),  -- Chi phí tài chính
(2203038, 2203016, '112A', NULL, 96000000);  -- Tiền gửi NH

-- 3.4 Receive investment income (100tr)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES 
(2203017, '2022-03-29', 'Nhận lãi đầu tư chứng khoán', 3, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2203039, 2203017, '112A', 100000000, NULL), -- Tiền gửi NH
(2203040, 2203017, 'B515', NULL, 100000000); -- Doanh thu TC

-- 4. Other activities

-- 4.1 Other expenses (15tr)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES 
(2203018, '2022-03-30', 'Chi phí phạt hợp đồng', 4, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2203041, 2203018, 'C811', 15000000, NULL),  -- Chi phí khác
(2203042, 2203018, '111A', NULL, 15000000); -- Tiền mặt

-- 4.2 Other income (20tr)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES 
(2203019, '2022-03-30', 'Thu nhập bất thường', 3, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2203043, 2203019, '112A', 20000000, NULL), -- Tiền gửi NH
(2203044, 2203019, 'C711', NULL, 20000000); -- Thu nhập khác

-- 5. Month-end closing entries

-- 5.1 Transfer expenses to 911
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES 
(2203020, '2022-03-31', 'Kết chuyển chi phí', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2203045, 2203020, 'D911', 284325000, NULL), -- Giá vốn
(2203046, 2203020, 'A632', NULL, 284325000),

(2203047, 2203020, 'D911', 60000000, NULL),  -- CP bán hàng + QLDN
(2203048, 2203020, 'A641', NULL, 30000000),
(2203049, 2203020, 'A642', NULL, 30000000),

(2203050, 2203020, 'D911', 106000000, NULL), -- CP tài chính
(2203051, 2203020, 'B635', NULL, 106000000),

(2203052, 2203020, 'D911', 15000000, NULL),  -- CP khác
(2203053, 2203020, 'C811', NULL, 15000000),

(2203054, 2203020, 'D911', 10000000, NULL),  -- Giảm trừ DT
(2203055, 2203020, 'A521', NULL, 10000000);

-- 5.2 Transfer revenues to 911
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES 
(2203021, '2022-03-31', 'Kết chuyển doanh thu', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2203056, 2203021, 'A511', 500000000, NULL), -- Doanh thu BH
(2203057, 2203021, 'D911', NULL, 500000000),

(2203058, 2203021, 'B515', 100000000, NULL), -- Doanh thu TC
(2203059, 2203021, 'D911', NULL, 100000000),

(2203060, 2203021, 'C711', 20000000, NULL),  -- Thu nhập khác
(2203061, 2203021, 'D911', NULL, 20000000);

-- 5.3 Calculate and record corporate income tax (20%)
-- Profit before tax: (500 + 100 + 20) - (284.325 + 60 + 106 + 15 + 10) = 620 - 475.325 = 144.675tr
-- Tax: 144.675 * 20% = 28.935tr
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES 
(2203022, '2022-03-31', 'Ghi nhận thuế TNDN', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2203062, 2203022, 'C821', 28935000, NULL),  -- Chi phí thuế
(2203063, 2203022, '333A', NULL, 28935000);  -- Thuế phải nộp

-- 5.4 Transfer tax expense to 911
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES 
(2203023, '2022-03-31', 'Kết chuyển chi phí thuế', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2203064, 2203023, 'D911', 28935000, NULL),  -- Chi phí thuế
(2203065, 2203023, 'C821', NULL, 28935000);

-- 5.5 Calculate and transfer net profit (144.675 - 28.935 = 115.74tr)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES 
(2203024, '2022-03-31', 'Kết chuyển lợi nhuận sau thuế', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2203066, 2203024, 'D911', 115740000, NULL), -- LNST
(2203067, 2203024, '421B', NULL, 115740000);

-- 6. Cash flow activities

-- 6.1 Pay dividends (30% of profit = 34.722tr)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES 
(2203025, '2022-03-31', 'Chi trả cổ tức', 4, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2203068, 2203025, '421B', 34722000, NULL),  -- Giảm LNST
(2203069, 2203025, '112A', NULL, 34722000); -- Tiền gửi NH

-- 6.2 Collect customer payments (80% of AR = 401.428tr)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `customer_id`) 
VALUES 
(2203026, '2022-03-31', 'Thu tiền khách hàng', 3, @period_id, 12);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2203070, 2203026, '112A', 401428000, NULL), -- Tiền gửi NH
(2203071, 2203026, '131A', NULL, 401428000); -- Giảm phải thu

-- 6.3 Pay suppliers (75% of AP = 123.75tr)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`) 
VALUES 
(2203027, '2022-03-31', 'Trả tiền nhà cung cấp', 4, @period_id, 5);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2203072, 2203027, '331A', 123750000, NULL), -- Giảm phải trả
(2203073, 2203027, '112A', NULL, 123750000); -- Tiền gửi NH

-- 6.4 Pay taxes (90% = 26.0415tr)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES 
(2203028, '2022-03-31', 'Nộp thuế TNDN', 4, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2203074, 2203028, '333A', 26041500, NULL),  -- Giảm thuế phải nộp
(2203075, 2203028, '112A', NULL, 26041500);  -- Tiền gửi NH

-- 6.5 Pay salaries (85% = 127.5tr)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES 
(2203029, '2022-03-31', 'Trả lương nhân viên', 4, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2203076, 2203029, '334A', 127500000, NULL), -- Giảm phải trả NLĐ
(2203077, 2203029, '111A', NULL, 127500000); -- Tiền mặt

-- 6.6 Pay short-term loan principal (10% = 70tr)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES 
(2203030, '2022-03-31', 'Trả nợ gốc vay ngắn hạn', 4, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2203078, 2203030, '341A', 70000000, NULL),  -- Giảm nợ vay NH
(2203079, 2203030, '112A', NULL, 70000000); -- Tiền gửi NH

-- 6.7 Pay long-term loan principal (5% = 25tr)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES 
(2203031, '2022-03-31', 'Trả nợ gốc vay dài hạn', 4, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2203080, 2203031, '341B', 25000000, NULL),  -- Giảm nợ vay DH
(2203081, 2203031, '112A', NULL, 25000000); -- Tiền gửi NH

COMMIT;