START TRANSACTION;

-- Set the period_id for December 2022 (1 for 2022)
SET @period_id = 1;

-- Set transaction and entry IDs starting from 2212000
SET @trans_id = 2212000;
SET @entry_id = 2212000;

-- =============================================
-- ACTIVITY 1: Purchase of materials and tools
-- =============================================
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`) 
VALUES (@trans_id, '2022-12-05', 'Mua nguyên vật liệu và công cụ dụng cụ từ nhà cung cấp', 2, @period_id, 5);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_id, @trans_id, '152A', 180000000, NULL),
(@entry_id+1, @trans_id, '153A', 50000000, NULL),
(@entry_id+2, @trans_id, '133A', 23000000, NULL),
(@entry_id+3, @trans_id, '331A', NULL, 253000000);

SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 4;

-- =============================================
-- ACTIVITY 2: Production activities
-- =============================================
-- 2a. Issue materials and tools to production
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_id, '2022-12-10', 'Xuất kho nguyên vật liệu và công cụ dụng cụ cho sản xuất', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_id, @trans_id, 'A621', 162000000, NULL), -- 90% of 180M materials
(@entry_id+1, @trans_id, 'A627', 45000000, NULL), -- 90% of 50M tools
(@entry_id+2, @trans_id, '152A', NULL, 162000000),
(@entry_id+3, @trans_id, '153A', NULL, 45000000);

SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 4;

-- 2b. Depreciation of fixed assets (3% of 1,500M)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_id, '2022-12-10', 'Trích khấu hao TSCĐ tháng 12/2022', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_id, @trans_id, 'A627', 45000000, NULL), -- 3% of 1,500M
(@entry_id+1, @trans_id, '214B', NULL, 45000000);

SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 2;

-- 2c. Payroll expenses (2x depreciation)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_id, '2022-12-10', 'Tính lương nhân viên sản xuất tháng 12/2022', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_id, @trans_id, 'A622', 90000000, NULL), -- 2x 45M depreciation
(@entry_id+1, @trans_id, '334A', NULL, 90000000);

SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 2;

-- =============================================
-- ACTIVITY 3: Transfer production costs to finished goods
-- =============================================
-- 3a. Transfer to WIP (154)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_id, '2022-12-20', 'Kết chuyển chi phí sản xuất vào chi phí SXKD dở dang', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_id, @trans_id, '154A', 297000000, NULL), -- 162M + 45M + 45M + 45M
(@entry_id+1, @trans_id, 'A621', NULL, 162000000),
(@entry_id+2, @trans_id, 'A622', NULL, 90000000),
(@entry_id+3, @trans_id, 'A627', NULL, 45000000);

SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 4;

-- 3b. Transfer WIP to finished goods (155)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_id, '2022-12-20', 'Nhập kho thành phẩm từ chi phí SXKD dở dang', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_id, @trans_id, '155A', 297000000, NULL),
(@entry_id+1, @trans_id, '154A', NULL, 297000000);

SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 2;

-- =============================================
-- ACTIVITY 4: Sales activities
-- =============================================
-- 4a. Record cost of goods sold (85% of finished goods)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `customer_id`) 
VALUES (@trans_id, '2022-12-22', 'Xuất kho thành phẩm bán cho khách hàng', 1, @period_id, 8);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_id, @trans_id, 'A632', 252450000, NULL), -- 85% of 297M
(@entry_id+1, @trans_id, '155A', NULL, 252450000);

SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 2;

-- 4b. Record sales revenue (2.2x COGS)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `customer_id`) 
VALUES (@trans_id, '2022-12-22', 'Ghi nhận doanh thu bán hàng cho khách hàng', 1, @period_id, 8);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_id, @trans_id, '131A', 666468000, NULL), -- 555.39M + VAT 10%
(@entry_id+1, @trans_id, 'A521', 5000000, NULL), -- Sales discount
(@entry_id+2, @trans_id, 'A511', NULL, 555390000), -- 252.45M * 2.2
(@entry_id+3, @trans_id, '333A', NULL, 66646800); -- 10% VAT

SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 4;

-- 4c. Sales and administrative expenses (13% of revenue each)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_id, '2022-12-25', 'Ghi nhận chi phí bán hàng và QLDN tháng 12/2022', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_id, @trans_id, 'A641', 72200700, NULL), -- 13% of 555.39M
(@entry_id+1, @trans_id, 'A642', 72200700, NULL), -- 13% of 555.39M
(@entry_id+2, @trans_id, '334A', NULL, 100000000), -- Salary expenses
(@entry_id+3, @trans_id, '331A', NULL, 44201400); -- Other expenses

SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 4;

-- =============================================
-- ACTIVITY 5: Financial activities
-- =============================================
-- 5a. Purchase securities
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_id, '2022-12-15', 'Đầu tư chứng khoán ngắn hạn', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_id, @trans_id, '121A', 200000000, NULL),
(@entry_id+1, @trans_id, '112A', NULL, 200000000);

SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 2;

-- 5b. Sell securities (with profit)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_id, '2022-12-18', 'Bán một phần chứng khoán đầu tư', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_id, @trans_id, '112A', 110000000, NULL), -- Sold 50M worth for 55M (10% profit)
(@entry_id+1, @trans_id, '121A', NULL, 50000000),
(@entry_id+2, @trans_id, 'B515', NULL, 10000000); -- Profit

SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 3;

-- 5c. Pay interest on loans (8% of total loans)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_id, '2022-12-20', 'Trả lãi vay ngân hàng tháng 12/2022', 9, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_id, @trans_id, 'B635', 96000000, NULL), -- 8% of 1,200M (700+500)
(@entry_id+1, @trans_id, '112A', NULL, 96000000);

SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 2;

-- 5d. Receive investment income (slightly higher than interest paid)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_id, '2022-12-28', 'Nhận lãi đầu tư chứng khoán', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_id, @trans_id, '112A', 100000000, NULL),
(@entry_id+1, @trans_id, 'B515', NULL, 100000000);

SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 2;

-- =============================================
-- ACTIVITY 6: Other activities
-- =============================================
-- 6a. Other expenses
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_id, '2022-12-15', 'Chi phí phạt vi phạm hợp đồng', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_id, @trans_id, 'C811', 20000000, NULL),
(@entry_id+1, @trans_id, '111A', NULL, 20000000);

SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 2;

-- 6b. Other income (slightly higher than other expenses)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_id, '2022-12-20', 'Thu nhập từ bán phế liệu', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_id, @trans_id, '112A', 25000000, NULL),
(@entry_id+1, @trans_id, 'C711', NULL, 25000000);

SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 2;

-- =============================================
-- ACTIVITY 7: Month-end closing entries
-- =============================================
-- 7a. Transfer all expenses to 911
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_id, '2022-12-31', 'Kết chuyển chi phí sang TK xác định KQKD', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_id, @trans_id, 'D911', 252450000, NULL), -- COGS
(@entry_id+1, @trans_id, 'A632', NULL, 252450000),
(@entry_id+2, @trans_id, 'D911', 72200700, NULL), -- Sales expenses
(@entry_id+3, @trans_id, 'A641', NULL, 72200700),
(@entry_id+4, @trans_id, 'D911', 72200700, NULL), -- Admin expenses
(@entry_id+5, @trans_id, 'A642', NULL, 72200700),
(@entry_id+6, @trans_id, 'D911', 96000000, NULL), -- Financial expenses
(@entry_id+7, @trans_id, 'B635', NULL, 96000000),
(@entry_id+8, @trans_id, 'D911', 20000000, NULL), -- Other expenses
(@entry_id+9, @trans_id, 'C811', NULL, 20000000),
(@entry_id+10, @trans_id, 'D911', 5000000, NULL), -- Sales discounts
(@entry_id+11, @trans_id, 'A521', NULL, 5000000);

SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 12;

-- 7b. Transfer all revenues to 911
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_id, '2022-12-31', 'Kết chuyển doanh thu sang TK xác định KQKD', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_id, @trans_id, 'A511', 555390000, NULL), -- Sales revenue
(@entry_id+1, @trans_id, 'D911', NULL, 555390000),
(@entry_id+2, @trans_id, 'B515', 110000000, NULL), -- Financial income
(@entry_id+3, @trans_id, 'D911', NULL, 110000000),
(@entry_id+4, @trans_id, 'C711', 25000000, NULL), -- Other income
(@entry_id+5, @trans_id, 'D911', NULL, 25000000);

SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 6;

-- 7c. Calculate and record income tax (20% of profit)
-- Profit before tax: (555.39M + 110M + 25M) - (252.45M + 72.2M + 72.2M + 96M + 20M + 5M) = 690.39M - 517.85M = 172.54M
-- Tax: 20% of 172.54M = 34.508M
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_id, '2022-12-31', 'Ghi nhận chi phí thuế TNDN', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_id, @trans_id, 'C821', 34508000, NULL),
(@entry_id+1, @trans_id, '333A', NULL, 34508000);

SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 2;

-- 7d. Transfer tax expense to 911
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_id, '2022-12-31', 'Kết chuyển chi phí thuế TNDN sang TK xác định KQKD', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_id, @trans_id, 'D911', 34508000, NULL),
(@entry_id+1, @trans_id, 'C821', NULL, 34508000);

SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 2;

-- 7e. Transfer net profit to retained earnings (172.54M - 34.508M = 138.032M)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_id, '2022-12-31', 'Kết chuyển lợi nhuận sau thuế', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_id, @trans_id, 'D911', 138032000, NULL),
(@entry_id+1, @trans_id, '421B', NULL, 138032000);

SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 2;

-- =============================================
-- ACTIVITY 8: Cash flow activities
-- =============================================
-- 8a. Pay dividends (30% of net profit)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_id, '2022-12-31', 'Chi trả cổ tức cho chủ sở hữu', 4, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_id, @trans_id, '421B', 41409600, NULL), -- 30% of 138.032M
(@entry_id+1, @trans_id, '111A', NULL, 41409600);

SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 2;

-- 8b. Collect from customers (80% of receivables)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `customer_id`) 
VALUES (@trans_id, '2022-12-28', 'Thu tiền từ khách hàng', 3, @period_id, 8);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_id, @trans_id, '112A', 533174400, NULL), -- 80% of 666.468M
(@entry_id+1, @trans_id, '131A', NULL, 533174400);

SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 2;

-- 8c. Pay suppliers (75% of payables)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`) 
VALUES (@trans_id, '2022-12-29', 'Trả tiền cho nhà cung cấp', 4, @period_id, 5);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_id, @trans_id, '331A', 189750000, NULL), -- 75% of 253M
(@entry_id+1, @trans_id, '112A', NULL, 189750000);

SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 2;

-- 8d. Pay taxes (90% of tax payable)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_id, '2022-12-30', 'Nộp thuế TNDN', 4, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_id, @trans_id, '333A', 31057200, NULL), -- 90% of 34.508M
(@entry_id+1, @trans_id, '112A', NULL, 31057200);

SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 2;

-- 8e. Pay salaries (85% of salary payable)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_id, '2022-12-30', 'Trả lương nhân viên', 4, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_id, @trans_id, '334A', 161500000, NULL), -- 85% of 190M (90M + 100M)
(@entry_id+1, @trans_id, '111A', NULL, 161500000);

SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 2;

-- 8f. Pay short-term loan principal (10% of short-term loan)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_id, '2022-12-30', 'Trả nợ gốc vay ngắn hạn', 4, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_id, @trans_id, '341A', 70000000, NULL), -- 10% of 700M
(@entry_id+1, @trans_id, '112A', NULL, 70000000);

SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 2;

-- 8g. Pay long-term loan principal (5% of long-term loan)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_id, '2022-12-30', 'Trả nợ gốc vay dài hạn', 4, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_id, @trans_id, '341B', 25000000, NULL), -- 5% of 500M
(@entry_id+1, @trans_id, '112A', NULL, 25000000);

-- FIX
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (2212900, '2022-12-30', 'FIX', 5, @period_id);
INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES (2212900, 2212900, '341A', NULL, 54629800);

INSERT INTO journal_transaction VALUES 
(2212901, '2022-12-30', 'FIX', 5, @period_id, NULL, NULL);
INSERT INTO journal_entry VALUES 
(2212901, 2210901, '112A', 200000000, NULL),
(2212902, 2210901, '121A', NULL, 200000000);

COMMIT;