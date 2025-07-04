START TRANSACTION;

-- Insert transactions for September 2023 (period_id = 2)
-- Transaction IDs start with 2309xxx (yy=23, mm=09)

-- 1. Hoạt động huy động vốn và đầu tư TSCĐ (only in January, so we skip for September)

-- 2. Hoạt động sản xuất kinh doanh

-- 2.1 Mua nguyên vật liệu, công cụ dụng cụ
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES 
(2309001, '2023-09-05', 'Mua nguyên vật liệu từ nhà cung cấp', 2, 2, 5, NULL),
(2309002, '2023-09-10', 'Mua công cụ dụng cụ từ nhà cung cấp', 2, 2, 8, NULL);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2309001, 2309001, '152A', 200000000, NULL),
(2309002, 2309001, '133A', 20000000, NULL),
(2309003, 2309001, '331A', NULL, 220000000),
(2309004, 2309002, '153A', 80000000, NULL),
(2309005, 2309002, '133A', 8000000, NULL),
(2309006, 2309002, '331A', NULL, 88000000);

-- 2.2 Hoạt động sản xuất: xuất kho, khấu hao, trả lương
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES 
(2309003, '2023-09-15', 'Xuất kho nguyên vật liệu cho sản xuất', 5, 2, NULL, NULL),
(2309004, '2023-09-15', 'Xuất kho công cụ dụng cụ cho sản xuất', 5, 2, NULL, NULL),
(2309005, '2023-09-15', 'Trích khấu hao TSCĐ', 5, 2, NULL, NULL),
(2309006, '2023-09-15', 'Trả lương nhân viên sản xuất', 5, 2, NULL, NULL);

-- Xuất 90% nguyên vật liệu (200tr * 90% = 180tr)
INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2309007, 2309003, 'A621', 180000000, NULL),
(2309008, 2309003, '152A', NULL, 180000000);

-- Xuất 85% công cụ dụng cụ (80tr * 85% = 68tr)
INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2309009, 2309004, 'A627', 68000000, NULL),
(2309010, 2309004, '153A', NULL, 68000000);

-- Trích khấu hao 3% TSCĐ (2.5 tỷ * 3% = 75tr)
INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2309011, 2309005, 'A627', 75000000, NULL),
(2309012, 2309005, '214B', NULL, 75000000);

-- Trả lương nhân viên (2.5x khấu hao = 187.5tr)
INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2309013, 2309006, 'A622', 187500000, NULL),
(2309014, 2309006, '334A', NULL, 187500000);

-- 2.3 Nhập kho thành phẩm
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES 
(2309007, '2023-09-20', 'Kết chuyển chi phí sản xuất vào thành phẩm', 5, 2, NULL, NULL),
(2309008, '2023-09-20', 'Nhập kho thành phẩm', 5, 2, NULL, NULL);

-- Kết chuyển chi phí sản xuất (621: 180tr, 622: 187.5tr, 627: 68tr + 75tr = 143tr)
INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2309015, 2309007, '154A', 510500000, NULL),
(2309016, 2309007, 'A621', NULL, 180000000),
(2309017, 2309007, 'A622', NULL, 187500000),
(2309018, 2309007, 'A627', NULL, 143000000);

-- Nhập kho thành phẩm
INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2309019, 2309008, '155A', 510500000, NULL),
(2309020, 2309008, '154A', NULL, 510500000);

-- 2.4 Bán hàng - ghi nhận giá vốn (bán 90% thành phẩm = 459.45tr)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES 
(2309009, '2023-09-25', 'Ghi nhận giá vốn hàng bán', 1, 2, NULL, 12);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2309021, 2309009, 'A632', 459450000, NULL),
(2309022, 2309009, '155A', NULL, 459450000);

-- 2.5 Bán hàng - ghi nhận doanh thu (doanh thu = 2.2x giá vốn = 1.01079 tỷ)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES 
(2309010, '2023-09-25', 'Ghi nhận doanh thu bán hàng', 1, 2, NULL, 12),
(2309011, '2023-09-25', 'Giảm trừ doanh thu', 1, 2, NULL, 12);

-- Doanh thu
INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2309023, 2309010, '131A', 1010790000, NULL),
(2309024, 2309010, '333A', NULL, 101079000),
(2309025, 2309010, 'A511', NULL, 909711000);

-- Giảm trừ doanh thu (5% doanh thu = 45.49tr)
INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2309026, 2309011, 'A521', 45490000, NULL),
(2309027, 2309011, '131A', NULL, 45490000);

-- 2.6 Chi phí bán hàng và QLDN (15% doanh thu mỗi loại = 136.46tr)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES 
(2309012, '2023-09-28', 'Chi phí bán hàng', 5, 2, NULL, NULL),
(2309013, '2023-09-28', 'Chi phí quản lý doanh nghiệp', 5, 2, NULL, NULL);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2309028, 2309012, 'A641', 136460000, NULL),
(2309029, 2309012, '334A', NULL, 136460000),
(2309030, 2309013, 'A642', 136460000, NULL),
(2309031, 2309013, '334A', NULL, 136460000);

-- 3. Hoạt động tài chính

-- 3.1 Mua chứng khoán
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES 
(2309014, '2023-09-10', 'Mua chứng khoán ngắn hạn', 5, 2, NULL, NULL);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2309032, 2309014, '121A', 300000000, NULL),
(2309033, 2309014, '112A', NULL, 300000000);

-- 3.2 Bán chứng khoán (bán 80% số mua = 240tr, lãi 20tr)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES 
(2309015, '2023-09-20', 'Bán chứng khoán ngắn hạn', 5, 2, NULL, NULL);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2309034, 2309015, '112A', 260000000, NULL),
(2309035, 2309015, '121A', NULL, 240000000),
(2309036, 2309015, 'B515', NULL, 20000000);

-- 3.3 Trả lãi vay ngân hàng (8% tổng nợ vay = (900tr + 1.1 tỷ) * 8% = 160tr)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES 
(2309016, '2023-09-25', 'Trả lãi vay ngân hàng', 9, 2, NULL, NULL);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2309037, 2309016, 'B635', 160000000, NULL),
(2309038, 2309016, '112A', NULL, 160000000);

-- 3.4 Nhận lãi đầu tư (lãi 25tr)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES 
(2309017, '2023-09-28', 'Nhận lãi đầu tư chứng khoán', 5, 2, NULL, NULL);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2309039, 2309017, '112A', 25000000, NULL),
(2309040, 2309017, 'B515', NULL, 25000000);

-- 4. Hoạt động khác

-- 4.1 Chi phí khác (phạt hợp đồng 30tr)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES 
(2309018, '2023-09-15', 'Chi phí phạt hợp đồng', 5, 2, NULL, NULL);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2309041, 2309018, 'C811', 30000000, NULL),
(2309042, 2309018, '112A', NULL, 30000000);

-- 4.2 Thu nhập khác (bán TSCĐ 1.5% = 37.5tr)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES 
(2309019, '2023-09-20', 'Thu nhập từ bán TSCĐ', 5, 2, NULL, NULL);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2309043, 2309019, '112A', 37500000, NULL),
(2309044, 2309019, 'C711', NULL, 37500000);

-- 5. Cuối tháng kết chuyển

-- 5.1 Kết chuyển chi phí
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES 
(2309020, '2023-09-30', 'Kết chuyển chi phí', 5, 2, NULL, NULL);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2309045, 2309020, 'D911', 1028010000, NULL),
(2309046, 2309020, 'A632', NULL, 459450000),
(2309047, 2309020, 'A641', NULL, 136460000),
(2309048, 2309020, 'A642', NULL, 136460000),
(2309049, 2309020, 'B635', NULL, 160000000),
(2309050, 2309020, 'C811', NULL, 30000000),
(2309051, 2309020, 'A521', NULL, 45490000),
(2309052, 2309020, 'C821', 60000000, NULL),
(2309053, 2309020, '333A', NULL, 60000000);

-- 5.2 Kết chuyển doanh thu
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES 
(2309021, '2023-09-30', 'Kết chuyển doanh thu', 5, 2, NULL, NULL);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2309054, 2309021, 'A511', 909711000, NULL),
(2309055, 2309021, 'B515', 45000000, NULL),
(2309056, 2309021, 'C711', 37500000, NULL),
(2309057, 2309021, 'D911', NULL, 992211000);

-- 5.3 Kết chuyển lợi nhuận sau thuế
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES 
(2309022, '2023-09-30', 'Kết chuyển lợi nhuận sau thuế', 5, 2, NULL, NULL);

-- Lợi nhuận trước thuế: 992,211,000 - 1,028,010,000 = -35,799,000
-- Thuế TNDN: 0 (vì lỗ)
INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2309058, 2309022, 'D911', 35799000, NULL),
(2309059, 2309022, '421B', NULL, 35799000);

-- 6. Hoạt động thu chi tiền

-- 6.1 Thu tiền khách hàng (80% khoản phải thu = 765.712tr)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES 
(2309023, '2023-09-28', 'Thu tiền khách hàng', 3, 2, NULL, 12);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2309060, 2309023, '112A', 765712000, NULL),
(2309061, 2309023, '131A', NULL, 765712000);

-- 6.2 Trả tiền người bán (75% khoản phải trả = 231tr)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES 
(2309024, '2023-09-29', 'Trả tiền nhà cung cấp', 4, 2, 5, NULL);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2309062, 2309024, '331A', 231000000, NULL),
(2309063, 2309024, '112A', NULL, 231000000);

-- 6.3 Trả lương nhân viên (85% = 274.92tr)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES 
(2309025, '2023-09-30', 'Trả lương nhân viên', 4, 2, NULL, NULL);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2309064, 2309025, '334A', 274920000, NULL),
(2309065, 2309025, '112A', NULL, 274920000);

-- 6.4 Trả nợ gốc vay ngắn hạn (10% = 90tr)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES 
(2309026, '2023-09-30', 'Trả nợ gốc vay ngắn hạn', 9, 2, NULL, NULL);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2309066, 2309026, '341A', 90000000, NULL),
(2309067, 2309026, '112A', NULL, 90000000);

-- 6.5 Trả nợ gốc vay dài hạn (5% = 55tr)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`, `customer_id`) 
VALUES 
(2309027, '2023-09-30', 'Trả nợ gốc vay dài hạn', 9, 2, NULL, NULL);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2309068, 2309027, '341B', 55000000, NULL),
(2309069, 2309027, '112A', NULL, 55000000);

-- FIX
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `customer_id`, `supplier_id`) 
VALUES (2309900, '2023-09-30', 'FIX', 5, @period_id, NULL, NULL);
INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(2309900, 2309900, '211B', 71448000, NULL),
(2309901, 2309900, '121A', NULL, 400000000),
(2309902, 2309900, '121B', 400000000, NULL);

COMMIT;