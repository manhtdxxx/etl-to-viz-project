START TRANSACTION;

-- 1. Capital mobilization and fixed asset investment (only in month 1)

-- 2. Business operations
-- Mua nguyên vật liệu, công cụ dụng cụ (300 triệu) - Nợ TK 152, 153, 133 - Có TK 112 (200) và TK 331A (100)
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id, supplier_id) 
VALUES (2209005, '2022-09-05', 'Mua nguyên vật liệu và công cụ dụng cụ', 2, 1, 5);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount) 
VALUES 
(2209013, 2209005, '152A', 200000000, NULL),
(2209014, 2209005, '153A', 50000000, NULL),
(2209015, 2209005, '133A', 30000000, NULL),
(2209016, 2209005, '112A', NULL, 200000000),
(2209017, 2209005, '331A', NULL, 80000000);

-- Hoạt động sản xuất: xuất kho nguyên vật liệu (85% = 170tr), công cụ dụng cụ (85% = 42.5tr)
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id) 
VALUES (2209006, '2022-09-10', 'Xuất kho nguyên vật liệu và công cụ dụng cụ cho sản xuất', 5, 1);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount) 
VALUES 
(2209018, 2209006, 'A621', 170000000, NULL),
(2209019, 2209006, 'A627', 42500000, NULL),
(2209020, 2209006, '152A', NULL, 170000000),
(2209021, 2209006, '153A', NULL, 42500000);

-- Trích khấu hao TSCĐ (3% của 1.500tr = 45tr)
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id) 
VALUES (2209007, '2022-09-10', 'Trích khấu hao TSCĐ', 5, 1);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount) 
VALUES 
(2209022, 2209007, 'A627', 45000000, NULL),
(2209023, 2209007, '214B', NULL, 45000000);

-- Trả lương nhân công trực tiếp (2.5x khấu hao = 112.5tr)
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id) 
VALUES (2209008, '2022-09-10', 'Trả lương nhân công trực tiếp', 5, 1);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount) 
VALUES 
(2209024, 2209008, 'A622', 112500000, NULL),
(2209025, 2209008, '334A', NULL, 112500000);

-- Nhập kho thành phẩm: Kết chuyển chi phí sản xuất vào TK 154 (170 + 112.5 + 42.5 + 45 = 370tr)
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id) 
VALUES (2209009, '2022-09-15', 'Kết chuyển chi phí sản xuất vào thành phẩm', 5, 1);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount) 
VALUES 
(2209026, 2209009, '154A', 370000000, NULL),
(2209027, 2209009, 'A621', NULL, 170000000),
(2209028, 2209009, 'A622', NULL, 112500000),
(2209029, 2209009, 'A627', NULL, 87500000);

-- Nhập kho thành phẩm từ TK 154 sang TK 155
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id) 
VALUES (2209010, '2022-09-15', 'Nhập kho thành phẩm từ chi phí sản xuất', 5, 1);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount) 
VALUES 
(2209030, 2209010, '155A', 370000000, NULL),
(2209031, 2209010, '154A', NULL, 370000000);

-- Bán hàng ghi nhận giá vốn (85% của 370tr = 314.5tr)
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id, customer_id) 
VALUES (2209011, '2022-09-20', 'Bán hàng - ghi nhận giá vốn', 1, 1, 8);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount) 
VALUES 
(2209032, 2209011, 'A632', 314500000, NULL),
(2209033, 2209011, '155A', NULL, 314500000);

-- Bán hàng ghi nhận doanh thu (2.2x giá vốn = 691.9tr), trong đó 500tr bằng tiền, 191.9tr phải thu, giảm trừ 10tr
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id, customer_id) 
VALUES (2209012, '2022-09-20', 'Bán hàng - ghi nhận doanh thu', 1, 1, 8);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount) 
VALUES 
(2209034, 2209012, '112A', 500000000, NULL),
(2209035, 2209012, '131A', 181900000, NULL),
(2209036, 2209012, 'A521', 10000000, NULL),
(2209037, 2209012, 'A511', NULL, 691900000),
(2209038, 2209012, '333A', NULL, 10000000); -- Thuế GTGT 10%

-- Ghi nhận chi phí bán hàng (13% doanh thu = 90tr) và chi phí QLDN (13% doanh thu = 90tr)
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id) 
VALUES (2209013, '2022-09-25', 'Ghi nhận chi phí bán hàng và QLDN', 5, 1);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount) 
VALUES 
(2209039, 2209013, 'A641', 90000000, NULL),
(2209040, 2209013, 'A642', 90000000, NULL),
(2209041, 2209013, '334A', NULL, 180000000);

-- 3. Financial activities
-- Mua chứng khoán ngắn hạn 100tr
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id) 
VALUES (2209014, '2022-09-15', 'Mua chứng khoán ngắn hạn', 5, 1);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount) 
VALUES 
(2209042, 2209014, '121A', 100000000, NULL),
(2209043, 2209014, '112A', NULL, 100000000);

-- Bán chứng khoán ngắn hạn 80tr (lỗ 5tr)
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id) 
VALUES (2209015, '2022-09-20', 'Bán chứng khoán ngắn hạn bị lỗ', 5, 1);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount) 
VALUES 
(2209044, 2209015, '112A', 75000000, NULL),
(2209045, 2209015, 'B635', 5000000, NULL),
(2209046, 2209015, '121A', NULL, 80000000);

-- Trả lãi vay ngân hàng (8% tổng nợ vay = 8% * 1200tr = 96tr)
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id) 
VALUES (2209016, '2022-09-25', 'Trả lãi vay ngân hàng', 9, 1);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount) 
VALUES 
(2209047, 2209016, 'B635', 96000000, NULL),
(2209048, 2209016, '112A', NULL, 96000000);

-- Nhận lãi từ đầu tư chứng khoán (100tr)
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id) 
VALUES (2209017, '2022-09-28', 'Nhận lãi từ đầu tư chứng khoán', 5, 1);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount) 
VALUES 
(2209049, 2209017, '112A', 100000000, NULL),
(2209050, 2209017, 'B515', NULL, 100000000);

-- 4. Other activities
-- Chi phí khác (phạt vi phạm hợp đồng 20tr)
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id) 
VALUES (2209018, '2022-09-28', 'Chi phí phạt vi phạm hợp đồng', 5, 1);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount) 
VALUES 
(2209051, 2209018, 'C811', 20000000, NULL),
(2209052, 2209018, '112A', NULL, 20000000);

-- Thu nhập khác (bán TSCĐ 2.5% = 37.5tr)
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id) 
VALUES (2209019, '2022-09-29', 'Thu nhập từ bán TSCĐ', 5, 1);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount) 
VALUES 
(2209053, 2209019, '112A', 37500000, NULL),
(2209054, 2209019, 'C711', NULL, 37500000),
(2209055, 2209019, '211B', NULL, 30000000),
(2209056, 2209019, '214B', 7500000, NULL);

-- 5. Month-end closing entries
-- Kết chuyển chi phí vào TK 911
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id) 
VALUES (2209020, '2022-09-30', 'Kết chuyển chi phí vào TK 911', 5, 1);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount) 
VALUES 
(2209057, 2209020, 'D911', 314500000, NULL), -- Giá vốn
(2209058, 2209020, 'D911', 90000000, NULL),  -- Chi phí bán hàng
(2209059, 2209020, 'D911', 90000000, NULL),  -- Chi phí QLDN
(2209060, 2209020, 'D911', 101000000, NULL), -- Chi phí tài chính (96+5)
(2209061, 2209020, 'D911', 20000000, NULL),  -- Chi phí khác
(2209062, 2209020, 'D911', 10000000, NULL),  -- Giảm trừ doanh thu
(2209063, 2209020, 'A632', NULL, 314500000),
(2209064, 2209020, 'A641', NULL, 90000000),
(2209065, 2209020, 'A642', NULL, 90000000),
(2209066, 2209020, 'B635', NULL, 101000000),
(2209067, 2209020, 'C811', NULL, 20000000),
(2209068, 2209020, 'A521', NULL, 10000000);

-- Kết chuyển doanh thu vào TK 911
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id) 
VALUES (2209021, '2022-09-30', 'Kết chuyển doanh thu vào TK 911', 5, 1);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount) 
VALUES 
(2209069, 2209021, 'A511', 691900000, NULL),
(2209070, 2209021, 'B515', 100000000, NULL),
(2209071, 2209021, 'C711', 37500000, NULL),
(2209072, 2209021, 'D911', NULL, 829400000);

-- Tính thuế TNDN (20% lợi nhuận trước thuế)
-- Lợi nhuận trước thuế = 829.4tr - 625.5tr = 203.9tr
-- Thuế TNDN = 20% * 203.9tr = 40.78tr
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id) 
VALUES (2209022, '2022-09-30', 'Ghi nhận thuế TNDN phải nộp', 8, 1);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount) 
VALUES 
(2209073, 2209022, 'C821', 40780000, NULL),
(2209074, 2209022, '333A', NULL, 40780000);

-- Kết chuyển thuế TNDN vào TK 911
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id) 
VALUES (2209023, '2022-09-30', 'Kết chuyển thuế TNDN vào TK 911', 5, 1);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount) 
VALUES 
(2209075, 2209023, 'D911', 40780000, NULL),
(2209076, 2209023, 'C821', NULL, 40780000);

-- Kết chuyển lợi nhuận sau thuế (203.9tr - 40.78tr = 163.12tr)
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id) 
VALUES (2209024, '2022-09-30', 'Kết chuyển lợi nhuận sau thuế', 5, 1);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount) 
VALUES 
(2209077, 2209024, 'D911', 163120000, NULL),
(2209078, 2209024, '421B', NULL, 163120000);

-- 6. Cash flow activities
-- Chi trả cổ tức (30% lợi nhuận = 48.936tr)
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id) 
VALUES (2209025, '2022-09-30', 'Chi trả cổ tức cho chủ sở hữu', 4, 1);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount) 
VALUES 
(2209079, 2209025, '421B', 48936000, NULL),
(2209080, 2209025, '111A', NULL, 48936000);

-- Thu tiền khách hàng (80% khoản phải thu = 145.52tr)
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id, customer_id) 
VALUES (2209026, '2022-09-30', 'Thu tiền khách hàng', 3, 1, 8);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount) 
VALUES 
(2209081, 2209026, '112A', 145520000, NULL),
(2209082, 2209026, '131A', NULL, 145520000);

-- Trả tiền người bán (75% khoản phải trả = 60tr)
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id, supplier_id) 
VALUES (2209027, '2022-09-30', 'Trả tiền người bán', 4, 1, 5);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount) 
VALUES 
(2209083, 2209027, '331A', 60000000, NULL),
(2209084, 2209027, '112A', NULL, 60000000);

-- Trả thuế TNDN (90% = 36.702tr)
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id) 
VALUES (2209028, '2022-09-30', 'Trả thuế TNDN', 4, 1);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount) 
VALUES 
(2209085, 2209028, '333A', 36702000, NULL),
(2209086, 2209028, '112A', NULL, 36702000);

-- Trả lương nhân viên (85% = 153tr)
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id) 
VALUES (2209029, '2022-09-30', 'Trả lương nhân viên', 4, 1);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount) 
VALUES 
(2209087, 2209029, '334A', 153000000, NULL),
(2209088, 2209029, '111A', NULL, 153000000);

-- Trả nợ gốc vay ngắn hạn (12% = 84tr)
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id) 
VALUES (2209030, '2022-09-30', 'Trả nợ gốc vay ngắn hạn', 4, 1);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount) 
VALUES 
(2209089, 2209030, '341A', 84000000, NULL),
(2209090, 2209030, '112A', NULL, 84000000);

-- Trả nợ gốc vay dài hạn (5% = 25tr)
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id) 
VALUES (2209031, '2022-09-30', 'Trả nợ gốc vay dài hạn', 4, 1);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount) 
VALUES 
(2209091, 2209031, '341B', 25000000, NULL),
(2209092, 2209031, '112A', NULL, 25000000);

-- FIX
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id) 
VALUES (2209900, '2022-09-30', 'FIX', 5, 1);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount) 
VALUES 
(2209900, 2209900, '211B', 32500000, NULL);

COMMIT;