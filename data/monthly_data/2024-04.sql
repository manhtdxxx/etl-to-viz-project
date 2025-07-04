START TRANSACTION;

-- Set variables for April 2024 transactions
SET @period_id = 3; -- 2024
SET @trans_id_base = 2404000;
SET @entry_id_base = 2404000;


-- 5. Purchase materials (Mua nguyên vật liệu)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`) 
VALUES (@trans_id_base + 5, '2024-04-05', 'Mua nguyên vật liệu', 2, @period_id, 5);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_id_base + 13, @trans_id_base + 5, '152A', 250000000, NULL),
(@entry_id_base + 14, @trans_id_base + 5, '133A', 25000000, NULL),
(@entry_id_base + 15, @trans_id_base + 5, '331A', NULL, 275000000);

-- 6. Purchase tools (Mua công cụ dụng cụ)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`) 
VALUES (@trans_id_base + 6, '2024-04-06', 'Mua công cụ dụng cụ', 2, @period_id, 8);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_id_base + 16, @trans_id_base + 6, '153A', 80000000, NULL),
(@entry_id_base + 17, @trans_id_base + 6, '133A', 8000000, NULL),
(@entry_id_base + 18, @trans_id_base + 6, '112A', NULL, 88000000);

-- 7. Issue materials for production (Xuất kho nguyên vật liệu)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_id_base + 7, '2024-04-10', 'Xuất kho nguyên vật liệu', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_id_base + 19, @trans_id_base + 7, 'A621', 237500000, NULL), -- 95% of 250m
(@entry_id_base + 20, @trans_id_base + 7, '152A', NULL, 237500000);

-- 8. Issue tools for production (Xuất kho công cụ dụng cụ)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_id_base + 8, '2024-04-10', 'Xuất kho công cụ dụng cụ', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_id_base + 21, @trans_id_base + 8, 'A627', 68000000, NULL), -- 85% of 80m
(@entry_id_base + 22, @trans_id_base + 8, '153A', NULL, 68000000);

-- 9. Depreciation expense (Trích khấu hao TSCĐ)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_id_base + 9, '2024-04-15', 'Trích khấu hao TSCĐ', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_id_base + 23, @trans_id_base + 9, 'A627', 70000000, NULL), -- 2% of 3.5b
(@entry_id_base + 24, @trans_id_base + 9, '214B', NULL, 70000000);

-- 10. Salary expense (Chi phí nhân công)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_id_base + 10, '2024-04-15', 'Chi phí nhân công', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_id_base + 25, @trans_id_base + 10, 'A622', 175000000, NULL), -- 2.5x depreciation
(@entry_id_base + 26, @trans_id_base + 10, '334A', NULL, 175000000);

-- 11. Transfer production costs (Kết chuyển chi phí sản xuất)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_id_base + 11, '2024-04-20', 'Kết chuyển chi phí sản xuất', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_id_base + 27, @trans_id_base + 11, '154A', 480500000, NULL), -- 237.5 + 68 + 70 + 175 = 550.5m
(@entry_id_base + 28, @trans_id_base + 11, 'A621', NULL, 237500000),
(@entry_id_base + 29, @trans_id_base + 11, 'A622', NULL, 175000000),
(@entry_id_base + 30, @trans_id_base + 11, 'A627', NULL, 68000000);

-- 12. Finished goods inventory (Nhập kho thành phẩm)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_id_base + 12, '2024-04-20', 'Nhập kho thành phẩm', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_id_base + 31, @trans_id_base + 12, '155A', 480500000, NULL),
(@entry_id_base + 32, @trans_id_base + 12, '154A', NULL, 480500000);

-- 13. Cost of goods sold (Ghi nhận giá vốn hàng bán)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `customer_id`) 
VALUES (@trans_id_base + 13, '2024-04-22', 'Ghi nhận giá vốn hàng bán', 1, @period_id, 12);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_id_base + 33, @trans_id_base + 13, 'A632', 432450000, NULL), -- 90% of 480.5m
(@entry_id_base + 34, @trans_id_base + 13, '155A', NULL, 432450000);

-- 14. Sales revenue (Ghi nhận doanh thu bán hàng)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `customer_id`) 
VALUES (@trans_id_base + 14, '2024-04-22', 'Ghi nhận doanh thu bán hàng', 1, @period_id, 12);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_id_base + 35, @trans_id_base + 14, '112A', 950000000, NULL), -- ~2.2x COGS
(@entry_id_base + 36, @trans_id_base + 14, 'A521', 50000000, NULL), -- Discount
(@entry_id_base + 37, @trans_id_base + 14, 'A511', NULL, 1000000000),
(@entry_id_base + 38, @trans_id_base + 14, '333A', NULL, 100000000); -- 10% VAT

-- 15. Selling expenses (Chi phí bán hàng)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_id_base + 15, '2024-04-25', 'Chi phí bán hàng', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_id_base + 39, @trans_id_base + 15, 'A641', 142500000, NULL), -- 15% of revenue
(@entry_id_base + 40, @trans_id_base + 15, '111A', NULL, 142500000);

-- 16. Administrative expenses (Chi phí quản lý doanh nghiệp)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_id_base + 16, '2024-04-25', 'Chi phí quản lý doanh nghiệp', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_id_base + 41, @trans_id_base + 16, 'A642', 142500000, NULL), -- 15% of revenue
(@entry_id_base + 42, @trans_id_base + 16, '111A', NULL, 142500000);

-- 17. Purchase securities (Mua chứng khoán)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_id_base + 17, '2024-04-10', 'Mua chứng khoán', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_id_base + 43, @trans_id_base + 17, '121A', 300000000, NULL),
(@entry_id_base + 44, @trans_id_base + 17, '112A', NULL, 300000000);

-- 18. Sell securities (Bán chứng khoán)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_id_base + 18, '2024-04-18', 'Bán chứng khoán', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_id_base + 45, @trans_id_base + 18, '112A', 330000000, NULL),
(@entry_id_base + 46, @trans_id_base + 18, '121A', NULL, 300000000),
(@entry_id_base + 47, @trans_id_base + 18, 'B515', NULL, 30000000); -- Profit 30m

-- 19. Pay interest expense (Trả lãi vay)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_id_base + 19, '2024-04-20', 'Trả lãi vay ngân hàng', 9, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_id_base + 48, @trans_id_base + 19, 'B635', 57000000, NULL), -- 7.5% of total loans (600+1400)
(@entry_id_base + 49, @trans_id_base + 19, '112A', NULL, 57000000);

-- 20. Receive interest income (Nhận lãi đầu tư)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_id_base + 20, '2024-04-22', 'Nhận lãi đầu tư', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_id_base + 50, @trans_id_base + 20, '112A', 60000000, NULL),
(@entry_id_base + 51, @trans_id_base + 20, 'B515', NULL, 60000000);

-- 21. Other expenses (Chi phí khác)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_id_base + 21, '2024-04-25', 'Chi phí phạt hợp đồng', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_id_base + 52, @trans_id_base + 21, 'C811', 20000000, NULL),
(@entry_id_base + 53, @trans_id_base + 21, '111A', NULL, 20000000);

-- 22. Other income (Thu nhập khác)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_id_base + 22, '2024-04-26', 'Thu nhập bất thường', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_id_base + 54, @trans_id_base + 22, '112A', 35000000, NULL),
(@entry_id_base + 55, @trans_id_base + 22, 'C711', NULL, 35000000);

-- 23. Transfer expenses to P&L (Kết chuyển chi phí)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_id_base + 23, '2024-04-30', 'Kết chuyển chi phí', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_id_base + 56, @trans_id_base + 23, 'D911', 864950000, NULL), -- 432.45 + 142.5 + 142.5 + 57 + 20 + 50 = 864.45m
(@entry_id_base + 57, @trans_id_base + 23, 'A632', NULL, 432450000),
(@entry_id_base + 58, @trans_id_base + 23, 'A641', NULL, 142500000),
(@entry_id_base + 59, @trans_id_base + 23, 'A642', NULL, 142500000),
(@entry_id_base + 60, @trans_id_base + 23, 'B635', NULL, 57000000),
(@entry_id_base + 61, @trans_id_base + 23, 'C811', NULL, 20000000),
(@entry_id_base + 62, @trans_id_base + 23, 'A521', NULL, 50000000);

-- 24. Transfer revenues to P&L (Kết chuyển doanh thu)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_id_base + 24, '2024-04-30', 'Kết chuyển doanh thu', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_id_base + 63, @trans_id_base + 24, 'A511', 1000000000, NULL),
(@entry_id_base + 64, @trans_id_base + 24, 'B515', 90000000, NULL), -- 30 + 60
(@entry_id_base + 65, @trans_id_base + 24, 'C711', 35000000, NULL),
(@entry_id_base + 66, @trans_id_base + 24, 'D911', NULL, 1125000000);

-- 25. Corporate income tax (Thuế TNDN)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_id_base + 25, '2024-04-30', 'Tính thuế TNDN', 8, @period_id);

-- Profit before tax = 1125m - 864.45m = 260.55m
-- Tax = 20% of 260.55m = 52.11m
INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_id_base + 67, @trans_id_base + 25, 'C821', 52110000, NULL),
(@entry_id_base + 68, @trans_id_base + 25, '333A', NULL, 52110000);

-- 26. Transfer tax expense (Kết chuyển thuế)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_id_base + 26, '2024-04-30', 'Kết chuyển thuế TNDN', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_id_base + 69, @trans_id_base + 26, 'D911', 52110000, NULL),
(@entry_id_base + 70, @trans_id_base + 26, 'C821', NULL, 52110000);

-- 27. Transfer net profit (Kết chuyển lợi nhuận)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_id_base + 27, '2024-04-30', 'Kết chuyển lợi nhuận', 5, @period_id);

-- Net profit = 260.55m - 52.11m = 208.44m
INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_id_base + 71, @trans_id_base + 27, 'D911', 208440000, NULL),
(@entry_id_base + 72, @trans_id_base + 27, '421B', NULL, 208440000);

-- 28. Pay dividends (Chi trả cổ tức)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_id_base + 28, '2024-04-30', 'Chi trả cổ tức', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_id_base + 73, @trans_id_base + 28, '421B', 31266000, NULL), -- 15% of net profit
(@entry_id_base + 74, @trans_id_base + 28, '111A', NULL, 31266000);

-- 29. Collect from customers (Thu tiền khách hàng)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `customer_id`) 
VALUES (@trans_id_base + 29, '2024-04-28', 'Thu tiền khách hàng', 6, @period_id, 12);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_id_base + 75, @trans_id_base + 29, '112A', 712500000, NULL), -- 75% of 950m
(@entry_id_base + 76, @trans_id_base + 29, '131A', NULL, 712500000);

-- 30. Pay suppliers (Trả tiền nhà cung cấp)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`) 
VALUES (@trans_id_base + 30, '2024-04-29', 'Trả tiền nhà cung cấp', 7, @period_id, 5);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_id_base + 77, @trans_id_base + 30, '331A', 192500000, NULL), -- 70% of 275m
(@entry_id_base + 78, @trans_id_base + 30, '112A', NULL, 192500000);

-- 31. Pay tax (Nộp thuế)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_id_base + 31, '2024-04-30', 'Nộp thuế TNDN', 8, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_id_base + 79, @trans_id_base + 31, '333A', 46900000, NULL), -- 90% of 52.11m
(@entry_id_base + 80, @trans_id_base + 31, '112A', NULL, 46900000);

-- 32. Pay salary (Trả lương nhân viên)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_id_base + 32, '2024-04-30', 'Trả lương nhân viên', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_id_base + 81, @trans_id_base + 32, '334A', 140000000, NULL), -- 80% of 175m
(@entry_id_base + 82, @trans_id_base + 32, '111A', NULL, 140000000);

-- 33. Repay short-term loan (Trả nợ gốc vay ngắn hạn)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_id_base + 33, '2024-04-30', 'Trả nợ gốc vay ngắn hạn', 9, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_id_base + 83, @trans_id_base + 33, '341A', 90000000, NULL), -- 15% of 600m
(@entry_id_base + 84, @trans_id_base + 33, '112A', NULL, 90000000);

-- 34. Repay long-term loan (Trả nợ gốc vay dài hạn)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_id_base + 34, '2024-04-30', 'Trả nợ gốc vay dài hạn', 9, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_id_base + 85, @trans_id_base + 34, '341B', 70000000, NULL), -- 5% of 1400m
(@entry_id_base + 86, @trans_id_base + 34, '112A', NULL, 70000000);

-- FIX
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `customer_id`, `supplier_id`) 
VALUES (2404900, '2024-04-30', 'FIX', 5, @period_id, NULL, NULL);
INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2404900, 2404900, '121B', 200000000, NULL),
(2404901, 2404900, '211B', 550000000, NULL),
(2404902, 2404900, '152A', NULL, 200000000),
(2404903, 2404900, '153A', NULL, 200000000),
(2404904, 2404900, '155A', NULL, 200000000);


COMMIT;