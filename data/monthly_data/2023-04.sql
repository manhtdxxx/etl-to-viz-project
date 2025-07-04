START TRANSACTION;

-- Set variables for April 2023
SET @period_id = 2; -- 2023
SET @year_month = '2304';
SET @trans_start = CONCAT(@year_month, '000');
SET @entry_start = CONCAT(@year_month, '000');


-- 5. Purchase raw materials with VAT - 250 million (150 + 100 VAT)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`) 
VALUES (@trans_start+5, '2023-04-03', 'Mua nguyên vật liệu', 2, @period_id, 8);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_start+11, @trans_start+5, '152A', 150000000, NULL),
(@entry_start+12, @trans_start+5, '133A', 25000000, NULL),
(@entry_start+13, @trans_start+5, '331A', NULL, 175000000);

-- 6. Purchase tools with VAT - 120 million (100 + 20 VAT)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`) 
VALUES (@trans_start+6, '2023-04-05', 'Mua công cụ dụng cụ', 2, @period_id, 12);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_start+14, @trans_start+6, '153A', 100000000, NULL),
(@entry_start+15, @trans_start+6, '133A', 20000000, NULL),
(@entry_start+16, @trans_start+6, '112A', NULL, 120000000);

-- 7. Issue materials to production (90% of inventory)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_start+7, '2023-04-10', 'Xuất kho nguyên vật liệu', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_start+17, @trans_start+7, 'A621', 135000000, NULL), -- 90% of 150 million
(@entry_start+18, @trans_start+7, '152A', NULL, 135000000);

-- 8. Issue tools to production (85% of inventory)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_start+8, '2023-04-10', 'Xuất kho công cụ dụng cụ', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_start+19, @trans_start+8, 'A627', 85000000, NULL), -- 85% of 100 million
(@entry_start+20, @trans_start+8, '153A', NULL, 85000000);

-- 9. Depreciation of fixed assets (3% of 2,500 million)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_start+9, '2023-04-15', 'Trích khấu hao TSCĐ', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_start+21, @trans_start+9, 'A627', 75000000, NULL), -- 3% of 2,500 million
(@entry_start+22, @trans_start+9, '214B', NULL, 75000000);

-- 10. Payroll expenses (2.5x depreciation)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_start+10, '2023-04-15', 'Trả lương nhân viên', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_start+23, @trans_start+10, 'A622', 187500000, NULL), -- 2.5x 75 million
(@entry_start+24, @trans_start+10, '334A', NULL, 187500000);

-- 11. Transfer production costs to WIP
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_start+11, '2023-04-20', 'Kết chuyển chi phí sản xuất', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_start+25, @trans_start+11, '154A', 397500000, NULL), -- 135 + 85 + 75 + 187.5 = 397.5
(@entry_start+26, @trans_start+11, 'A621', NULL, 135000000),
(@entry_start+27, @trans_start+11, 'A622', NULL, 187500000),
(@entry_start+28, @trans_start+11, 'A627', NULL, 75000000);

-- 12. Transfer WIP to finished goods
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_start+12, '2023-04-21', 'Nhập kho thành phẩm', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_start+29, @trans_start+12, '155A', 397500000, NULL),
(@entry_start+30, @trans_start+12, '154A', NULL, 397500000);

-- 13. Record cost of goods sold (90% of finished goods)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_start+13, '2023-04-22', 'Ghi nhận giá vốn hàng bán', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_start+31, @trans_start+13, 'A632', 357750000, NULL), -- 90% of 397.5
(@entry_start+32, @trans_start+13, '155A', NULL, 357750000);

-- 14. Sales revenue (2.2x COGS) - 787 million (715 + 72 VAT)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `customer_id`) 
VALUES (@trans_start+14, '2023-04-23', 'Bán hàng cho khách A', 1, @period_id, 3);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_start+33, @trans_start+14, '112A', 500000000, NULL),
(@entry_start+34, @trans_start+14, '131A', 287000000, NULL),
(@entry_start+35, @trans_start+14, 'A511', NULL, 715000000), -- 2.2x 325.23
(@entry_start+36, @trans_start+14, '333A', NULL, 72000000);

-- 15. Sales returns (revenue deduction) - 15 million
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `customer_id`) 
VALUES (@trans_start+15, '2023-04-24', 'Hàng bán bị trả lại', 1, @period_id, 3);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_start+37, @trans_start+15, 'A521', 15000000, NULL),
(@entry_start+38, @trans_start+15, '131A', NULL, 15000000);

-- 16. Selling expenses (13% of revenue)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_start+16, '2023-04-25', 'Chi phí bán hàng', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_start+39, @trans_start+16, 'A641', 91000000, NULL), -- 13% of 700 (715-15)
(@entry_start+40, @trans_start+16, '111A', NULL, 91000000);

-- 17. Administrative expenses (13% of revenue)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_start+17, '2023-04-26', 'Chi phí quản lý doanh nghiệp', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_start+41, @trans_start+17, 'A642', 91000000, NULL), -- 13% of 700
(@entry_start+42, @trans_start+17, '112A', NULL, 91000000);

-- 18. Purchase securities - 300 million (short-term)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_start+18, '2023-04-10', 'Mua chứng khoán ngắn hạn', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_start+43, @trans_start+18, '121A', 300000000, NULL),
(@entry_start+44, @trans_start+18, '112A', NULL, 300000000);

-- 19. Sell securities (80% of purchase) - 240 million (sold for 260 million, profit 20 million)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_start+19, '2023-04-20', 'Bán chứng khoán ngắn hạn', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_start+45, @trans_start+19, '112A', 260000000, NULL),
(@entry_start+46, @trans_start+19, '121A', NULL, 240000000),
(@entry_start+47, @trans_start+19, 'B515', NULL, 20000000);

-- 20. Pay interest on loans (8% of total loans)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_start+20, '2023-04-25', 'Trả lãi vay ngân hàng', 4, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_start+48, @trans_start+20, 'B635', 120000000, NULL), -- 8% of 1,500 (900+600)
(@entry_start+49, @trans_start+20, '112A', NULL, 120000000);

-- 21. Receive investment income (higher than interest paid)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_start+21, '2023-04-27', 'Nhận lãi đầu tư', 3, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_start+50, @trans_start+21, '112A', 130000000, NULL),
(@entry_start+51, @trans_start+21, 'B515', NULL, 130000000);

-- 22. Other expenses - 25 million
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_start+22, '2023-04-28', 'Phạt vi phạm hợp đồng', 4, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_start+52, @trans_start+22, 'C811', 25000000, NULL),
(@entry_start+53, @trans_start+22, '111A', NULL, 25000000);

-- 23. Other income - 30 million (from selling fixed assets)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_start+23, '2023-04-29', 'Bán TSCĐ', 3, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_start+54, @trans_start+23, '112A', 30000000, NULL),
(@entry_start+55, @trans_start+23, 'C711', NULL, 30000000);

-- 24. Month-end closing - Transfer all expenses to 911
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_start+24, '2023-04-30', 'Kết chuyển chi phí', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_start+56, @trans_start+24, 'D911', 721750000, NULL), -- 357.75 + 91 + 91 + 120 + 25 + 15 = 699.75
(@entry_start+57, @trans_start+24, 'A632', NULL, 357750000),
(@entry_start+58, @trans_start+24, 'A641', NULL, 91000000),
(@entry_start+59, @trans_start+24, 'A642', NULL, 91000000),
(@entry_start+60, @trans_start+24, 'B635', NULL, 120000000),
(@entry_start+61, @trans_start+24, 'C811', NULL, 25000000),
(@entry_start+62, @trans_start+24, 'A521', NULL, 15000000);

-- 25. Month-end closing - Transfer all revenues to 911
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_start+25, '2023-04-30', 'Kết chuyển doanh thu', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_start+63, @trans_start+25, 'A511', 715000000, NULL),
(@entry_start+64, @trans_start+25, 'B515', 150000000, NULL), -- 20 + 130
(@entry_start+65, @trans_start+25, 'C711', 30000000, NULL),
(@entry_start+66, @trans_start+25, 'D911', NULL, 895000000);

-- 26. Calculate corporate income tax (20% of profit before tax)
-- Profit before tax = Revenue (895) - Expenses (721.75) = 173.25
-- Tax = 20% of 173.25 = 34.65
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_start+26, '2023-04-30', 'Tính thuế TNDN', 8, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_start+67, @trans_start+26, 'C821', 34650000, NULL),
(@entry_start+68, @trans_start+26, '333A', NULL, 34650000);

-- 27. Transfer tax expense to 911
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_start+27, '2023-04-30', 'Kết chuyển thuế TNDN', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_start+69, @trans_start+27, 'D911', 34650000, NULL),
(@entry_start+70, @trans_start+27, 'C821', NULL, 34650000);

-- 28. Calculate and transfer net profit to retained earnings
-- Net profit = 173.25 - 34.65 = 138.6
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_start+28, '2023-04-30', 'Kết chuyển lợi nhuận', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_start+71, @trans_start+28, 'D911', 138600000, NULL),
(@entry_start+72, @trans_start+28, '421B', NULL, 138600000);

-- 29. Pay dividends (15% of net profit)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_start+29, '2023-04-30', 'Chi trả cổ tức', 4, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_start+73, @trans_start+29, '421B', 20790000, NULL), -- 15% of 138.6
(@entry_start+74, @trans_start+29, '112A', NULL, 20790000);

-- 30. Collect from customers (80% of receivables)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `customer_id`) 
VALUES (@trans_start+30, '2023-04-30', 'Thu tiền khách hàng', 3, @period_id, 3);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_start+75, @trans_start+30, '112A', 217600000, NULL), -- 80% of 272 (287-15)
(@entry_start+76, @trans_start+30, '131A', NULL, 217600000);

-- 31. Pay suppliers (75% of payables)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`) 
VALUES (@trans_start+31, '2023-04-30', 'Trả tiền nhà cung cấp', 4, @period_id, 8);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_start+77, @trans_start+31, '331A', 131250000, NULL), -- 75% of 175
(@entry_start+78, @trans_start+31, '112A', NULL, 131250000);

-- 32. Pay corporate income tax (90% of tax payable)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_start+32, '2023-04-30', 'Nộp thuế TNDN', 4, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_start+79, @trans_start+32, '333A', 31185000, NULL), -- 90% of 34.65
(@entry_start+80, @trans_start+32, '112A', NULL, 31185000);

-- 33. Pay salaries (85% of payroll)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_start+33, '2023-04-30', 'Trả lương nhân viên', 4, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_start+81, @trans_start+33, '334A', 159375000, NULL), -- 85% of 187.5
(@entry_start+82, @trans_start+33, '111A', NULL, 159375000);

-- 34. Repay short-term loan principal (10% of short-term loan)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_start+34, '2023-04-30', 'Trả nợ gốc vay ngắn hạn', 4, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_start+83, @trans_start+34, '341A', 90000000, NULL), -- 10% of 900
(@entry_start+84, @trans_start+34, '112A', NULL, 90000000);

-- 35. Repay long-term loan principal (5% of long-term loan)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_start+35, '2023-04-30', 'Trả nợ gốc vay dài hạn', 4, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_start+85, @trans_start+35, '341B', 30000000, NULL), -- 5% of 600
(@entry_start+86, @trans_start+35, '112A', NULL, 30000000);


INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (2304900, '2023-04-30', 'FIX', 5, @period_id);
INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2304900, 2304900, '121B', 63000000, NULL);

COMMIT;