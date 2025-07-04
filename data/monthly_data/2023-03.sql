START TRANSACTION;

-- Insert transactions for March 2023 (period_id = 2 for 2023)
-- Transaction IDs start with 2303 (year 23, month 03) followed by 3 digits

-- 5. Purchase materials (mua nguyên vật liệu)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES (2303005, '2023-03-05', 'Mua nguyên vật liệu từ nhà cung cấp A', 2, 2, 8, NULL);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2303013, 2303005, '152A', 150000000, NULL),
(2303014, 2303005, '133A', 15000000, NULL),
(2303015, 2303005, '331A', NULL, 165000000);

-- 6. Purchase tools (mua công cụ dụng cụ)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES (2303006, '2023-03-06', 'Mua công cụ dụng cụ từ nhà cung cấp B', 2, 2, 12, NULL);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2303016, 2303006, '153A', 80000000, NULL),
(2303017, 2303006, '133A', 8000000, NULL),
(2303018, 2303006, '112A', NULL, 88000000);

-- 7. Material consumption (xuất kho nguyên vật liệu)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES (2303007, '2023-03-10', 'Xuất kho nguyên vật liệu sản xuất', 5, 2, NULL, NULL);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2303019, 2303007, 'A621', 135000000, NULL),
(2303020, 2303007, '152A', NULL, 135000000);

-- 8. Tools consumption (xuất kho công cụ dụng cụ)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES (2303008, '2023-03-10', 'Xuất kho công cụ dụng cụ sản xuất', 5, 2, NULL, NULL);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2303021, 2303008, 'A627', 72000000, NULL),
(2303022, 2303008, '153A', NULL, 72000000);

-- 9. Depreciation expense (trích khấu hao TSCĐ)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES (2303009, '2023-03-15', 'Trích khấu hao TSCĐ tháng 3/2023', 5, 2, NULL, NULL);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2303023, 2303009, 'A627', 50000000, NULL), -- 2% of 2,500,000,000
-- (2303024, 2303009, '214B', NULL, 50000000);
(2303024, 2303009, '214B', NULL, 50000000 - 240000000);  -- FIX

-- 10. Salary expense (chi phí nhân công)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES (2303010, '2023-03-15', 'Chi phí lương nhân viên sản xuất', 5, 2, NULL, NULL);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2303025, 2303010, 'A622', 120000000, NULL), -- 2.4x depreciation
(2303026, 2303010, '334A', NULL, 120000000);

-- 11. Transfer production costs to WIP (kết chuyển chi phí sản xuất)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES (2303011, '2023-03-25', 'Kết chuyển chi phí sản xuất', 5, 2, NULL, NULL);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2303027, 2303011, '154A', 377000000, NULL), -- 135 + 72 + 50 + 120
(2303028, 2303011, 'A621', NULL, 135000000),
(2303029, 2303011, 'A622', NULL, 120000000),
(2303030, 2303011, 'A627', NULL, 122000000);

-- 12. Transfer WIP to finished goods (nhập kho thành phẩm)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES (2303012, '2023-03-26', 'Nhập kho thành phẩm', 5, 2, NULL, NULL);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2303031, 2303012, '155A', 377000000, NULL),
(2303032, 2303012, '154A', NULL, 377000000);

-- 13. Record cost of goods sold (ghi nhận giá vốn)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES (2303013, '2023-03-27', 'Xuất kho thành phẩm bán cho khách hàng X', 1, 2, NULL, 3);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2303033, 2303013, 'A632', 339300000, NULL), -- 90% of 377,000,000
(2303034, 2303013, '155A', NULL, 339300000);

-- 14. Record sales revenue (ghi nhận doanh thu)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES (2303014, '2023-03-27', 'Bán hàng cho khách hàng X', 1, 2, NULL, 3);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2303035, 2303014, '131A', 847500000, NULL), -- 2.5x COGS (339,300,000 * 2.5 = 848,250,000) rounded to 847,500,000
(2303036, 2303014, 'A511', NULL, 800000000),
(2303037, 2303014, '333A', NULL, 47500000); -- 5% VAT

-- 15. Sales discount (giảm trừ doanh thu)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES (2303015, '2023-03-28', 'Giảm giá cho khách hàng X', 1, 2, NULL, 3);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2303038, 2303015, 'A521', 10000000, NULL),
(2303039, 2303015, '131A', NULL, 10000000);

-- 16. Selling expenses (chi phí bán hàng)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES (2303016, '2023-03-29', 'Chi phí bán hàng tháng 3/2023', 5, 2, NULL, NULL);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2303040, 2303016, 'A641', 101700000, NULL), -- 12% of revenue (847,500,000 * 0.12)
(2303041, 2303016, '334A', NULL, 60000000),
(2303042, 2303016, '112A', NULL, 41700000);

-- 17. Administrative expenses (chi phí quản lý doanh nghiệp)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES (2303017, '2023-03-29', 'Chi phí quản lý doanh nghiệp tháng 3/2023', 5, 2, NULL, NULL);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2303043, 2303017, 'A642', 101700000, NULL), -- 12% of revenue
(2303044, 2303017, '334A', NULL, 50000000),
(2303045, 2303017, '111A', NULL, 51700000);

-- 18. Purchase securities (mua chứng khoán)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES (2303018, '2023-03-15', 'Mua chứng khoán ngắn hạn', 5, 2, NULL, NULL);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2303046, 2303018, '121A', 200000000, NULL),
(2303047, 2303018, '112A', NULL, 200000000);

-- 19. Sell securities (bán chứng khoán)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES (2303019, '2023-03-20', 'Bán chứng khoán ngắn hạn', 5, 2, NULL, NULL);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2303048, 2303019, '112A', 180000000, NULL), -- Sold at a loss
(2303049, 2303019, '121A', NULL, 150000000),
(2303050, 2303019, 'B635', NULL, 30000000); -- Loss of 30,000,000

-- 20. Interest payment (trả lãi vay)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES (2303020, '2023-03-25', 'Trả lãi vay ngân hàng', 9, 2, NULL, NULL);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2303051, 2303020, 'B635', 90000000, NULL), -- 6% of total loans (1,500,000,000)
(2303052, 2303020, '112A', NULL, 90000000);

-- 21. Interest income (nhận lãi đầu tư)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES (2303021, '2023-03-28', 'Nhận lãi đầu tư chứng khoán', 5, 2, NULL, NULL);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2303053, 2303021, '112A', 100000000, NULL),
(2303054, 2303021, 'B515', NULL, 100000000);

-- 22. Other expenses (chi phí khác)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES (2303022, '2023-03-29', 'Phạt vi phạm hợp đồng', 5, 2, NULL, NULL);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2303055, 2303022, 'C811', 20000000, NULL),
(2303056, 2303022, '111A', NULL, 20000000);

-- 23. Other income (thu nhập khác)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES (2303023, '2023-03-30', 'Bán phế liệu thu hồi', 5, 2, NULL, NULL);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2303057, 2303023, '111A', 25000000, NULL),
(2303058, 2303023, 'C711', NULL, 25000000);

-- 24. Transfer expenses to income summary (kết chuyển chi phí)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES (2303024, '2023-03-31', 'Kết chuyển chi phí', 5, 2, NULL, NULL);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2303059, 2303024, 'D911', 772700000, NULL), -- 339.3 + 101.7 + 101.7 + 30 + 90 + 20 + 10
(2303060, 2303024, 'A632', NULL, 339300000),
(2303061, 2303024, 'A641', NULL, 101700000),
(2303062, 2303024, 'A642', NULL, 101700000),
(2303063, 2303024, 'B635', NULL, 120000000), -- 30 + 90
(2303064, 2303024, 'C811', NULL, 20000000),
(2303065, 2303024, 'A521', NULL, 10000000);

-- 25. Transfer revenues to income summary (kết chuyển doanh thu)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES (2303025, '2023-03-31', 'Kết chuyển doanh thu', 5, 2, NULL, NULL);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2303066, 2303025, 'A511', 800000000, NULL),
(2303067, 2303025, 'B515', 100000000, NULL),
(2303068, 2303025, 'C711', 25000000, NULL),
(2303069, 2303025, 'D911', NULL, 925000000);

-- 26. Corporate income tax (thuế TNDN)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES (2303026, '2023-03-31', 'Tính thuế TNDN', 8, 2, NULL, NULL);

-- Profit before tax = 925,000,000 - 772,700,000 = 152,300,000
-- Tax = 152,300,000 * 20% = 30,460,000
INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2303070, 2303026, 'C821', 30460000, NULL),
(2303071, 2303026, '333A', NULL, 30460000);

-- 27. Transfer tax to income summary (kết chuyển thuế)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES (2303027, '2023-03-31', 'Kết chuyển thuế TNDN', 5, 2, NULL, NULL);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2303072, 2303027, 'D911', 30460000, NULL),
(2303073, 2303027, 'C821', NULL, 30460000);

-- 28. Transfer net profit to retained earnings (kết chuyển lợi nhuận)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES (2303028, '2023-03-31', 'Kết chuyển lợi nhuận sau thuế', 5, 2, NULL, NULL);

-- Net profit = 152,300,000 - 30,460,000 = 121,840,000
INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2303074, 2303028, 'D911', 121840000, NULL),
(2303075, 2303028, '421B', NULL, 121840000);

-- 29. Dividend payment (chi trả cổ tức)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES (2303029, '2023-03-31', 'Chi trả cổ tức', 4, 2, NULL, NULL);

-- Dividend = 15% of net profit (121,840,000 * 0.15 = 18,276,000)
INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2303076, 2303029, '421B', 18000000, NULL), -- Rounded to 18,000,000
(2303077, 2303029, '111A', NULL, 18000000);

-- 30. Collect receivables (thu tiền khách hàng)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES (2303030, '2023-03-31', 'Thu tiền khách hàng X', 6, 2, NULL, 3);

-- Receivable = 847,500,000 - 10,000,000 = 837,500,000
-- Collect 80% = 670,000,000
INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2303078, 2303030, '112A', 670000000, NULL),
(2303079, 2303030, '131A', NULL, 670000000);

-- 31. Pay suppliers (trả tiền nhà cung cấp)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES (2303031, '2023-03-31', 'Trả tiền nhà cung cấp A', 7, 2, 8, NULL);

-- Payable = 165,000,000
-- Pay 75% = 123,750,000
INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2303080, 2303031, '331A', 123750000, NULL),
(2303081, 2303031, '112A', NULL, 123750000);

-- 32. Pay tax (nộp thuế)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES (2303032, '2023-03-31', 'Nộp thuế TNDN', 8, 2, NULL, NULL);

-- Tax payable = 30,460,000
-- Pay 90% = 27,414,000
INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2303082, 2303032, '333A', 27414000, NULL),
(2303083, 2303032, '112A', NULL, 27414000);

-- 33. Pay salary (trả lương nhân viên)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES (2303033, '2023-03-31', 'Trả lương nhân viên', 4, 2, NULL, NULL);

-- Salary payable = 120,000,000 + 60,000,000 + 50,000,000 = 230,000,000
-- Pay 85% = 195,500,000
INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2303084, 2303033, '334A', 195500000, NULL),
(2303085, 2303033, '111A', NULL, 100000000),
(2303086, 2303033, '112A', NULL, 95500000);

-- 34. Pay short-term loan principal (trả nợ gốc vay ngắn hạn)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES (2303034, '2023-03-31', 'Trả nợ gốc vay ngắn hạn', 9, 2, NULL, NULL);

-- Short-term loan = 900,000,000
-- Pay 10% = 90,000,000
INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2303087, 2303034, '341A', 90000000, NULL),
(2303088, 2303034, '112A', NULL, 90000000);

-- 35. Pay long-term loan principal (trả nợ gốc vay dài hạn)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES (2303035, '2023-03-31', 'Trả nợ gốc vay dài hạn', 9, 2, NULL, NULL);

-- Long-term loan = 600,000,000
-- Pay 5% = 30,000,000
INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2303089, 2303035, '341B', 30000000, NULL),
(2303090, 2303035, '112A', NULL, 30000000);



COMMIT;