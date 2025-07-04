START TRANSACTION;

-- Set period_id for 2023 (2)
SET @period_id = 2;


-- 2. Purchasing activities
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id, supplier_id, customer_id)
VALUES 
(2305005, '2023-05-05', 'Mua nguyên vật liệu từ NCC A', 2, @period_id, 8, NULL),
(2305006, '2023-05-08', 'Mua công cụ dụng cụ từ NCC B', 2, @period_id, 12, NULL),
(2305007, '2023-05-10', 'Thanh toán tiền mua NVL', 4, @period_id, 8, NULL),
(2305008, '2023-05-12', 'Thanh toán tiền mua CCDC', 4, @period_id, 12, NULL);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount)
VALUES
(2305013, 2305005, '152A', 150000000, NULL),
(2305014, 2305005, '133A', 15000000, NULL),
(2305015, 2305005, '331A', NULL, 165000000),
(2305016, 2305006, '153A', 80000000, NULL),
(2305017, 2305006, '133A', 8000000, NULL),
(2305018, 2305006, '331A', NULL, 88000000),
(2305019, 2305007, '331A', 165000000, NULL),
(2305020, 2305007, '112A', NULL, 165000000),
(2305021, 2305008, '331A', 88000000, NULL),
(2305022, 2305008, '111A', NULL, 88000000);

-- 3. Production activities
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id, supplier_id, customer_id)
VALUES 
(2305009, '2023-05-15', 'Xuất kho NVL cho sản xuất', 5, @period_id, NULL, NULL),
(2305010, '2023-05-15', 'Xuất kho CCDC cho sản xuất', 5, @period_id, NULL, NULL),
(2305011, '2023-05-15', 'Trích khấu hao TSCĐ', 5, @period_id, NULL, NULL),
(2305012, '2023-05-15', 'Trả lương nhân viên sản xuất', 4, @period_id, NULL, NULL),
(2305013, '2023-05-15', 'Phân bổ chi phí sản xuất', 5, @period_id, NULL, NULL);

-- Xuất 90% NVL (150tr * 90% = 135tr)
INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount)
VALUES
(2305023, 2305009, 'A621', 135000000, NULL),
(2305024, 2305009, '152A', NULL, 135000000);

-- Xuất 90% CCDC (80tr * 90% = 72tr)
INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount)
VALUES
(2305025, 2305010, 'A627', 72000000, NULL),
(2305026, 2305010, '153A', NULL, 72000000);

-- Trích khấu hao 3% TSCĐ (2.5 tỷ * 3% = 75tr)
INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount)
VALUES
(2305027, 2305011, 'A627', 75000000, NULL),
(2305028, 2305011, '214B', NULL, 75000000);

-- Trả lương nhân viên (2.5x khấu hao = 187.5tr)
INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount)
VALUES
(2305029, 2305012, 'A622', 187500000, NULL),
(2305030, 2305012, '334A', NULL, 187500000);

-- 4. Finished goods
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id, supplier_id, customer_id)
VALUES 
(2305014, '2023-05-20', 'Kết chuyển chi phí sản xuất', 5, @period_id, NULL, NULL),
(2305015, '2023-05-20', 'Nhập kho thành phẩm', 5, @period_id, NULL, NULL);

-- Kết chuyển chi phí sản xuất (135 + 187.5 + 72 + 75 = 469.5tr)
INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount)
VALUES
(2305031, 2305014, '154A', 469500000, NULL),
(2305032, 2305014, 'A621', NULL, 135000000),
(2305033, 2305014, 'A622', NULL, 187500000),
(2305034, 2305014, 'A627', NULL, 147000000);

-- Nhập kho thành phẩm (469.5tr)
INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount)
VALUES
(2305035, 2305015, '155A', 469500000, NULL),
(2305036, 2305015, '154A', NULL, 469500000);

-- 5. Sales activities
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id, supplier_id, customer_id)
VALUES 
(2305016, '2023-05-22', 'Xuất kho bán hàng cho KH X', 1, @period_id, NULL, 3),
(2305017, '2023-05-22', 'Ghi nhận doanh thu bán hàng cho KH X', 1, @period_id, NULL, 3),
(2305018, '2023-05-25', 'Xuất kho bán hàng cho KH Y', 1, @period_id, NULL, 7),
(2305019, '2023-05-25', 'Ghi nhận doanh thu bán hàng cho KH Y', 1, @period_id, NULL, 7),
(2305020, '2023-05-28', 'Ghi nhận chi phí bán hàng', 5, @period_id, NULL, NULL),
(2305021, '2023-05-28', 'Ghi nhận chi phí quản lý DN', 5, @period_id, NULL, NULL);

-- Xuất kho bán 90% thành phẩm (469.5 * 90% = 422.55tr)
INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount)
VALUES
(2305037, 2305016, 'A632', 211275000, NULL),
(2305038, 2305016, '155A', NULL, 211275000),
(2305039, 2305018, 'A632', 211275000, NULL),
(2305040, 2305018, '155A', NULL, 211275000);

-- Doanh thu (2.2x giá vốn = 422.55 * 2.2 = 929.61tr)
INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount)
VALUES
(2305041, 2305017, '131A', 929610000, NULL),
(2305042, 2305017, 'A511', NULL, 880000000),
(2305043, 2305017, 'A521', 49610000, NULL),
(2305044, 2305017, '333A', NULL, 88000000), -- VAT 10%
(2305045, 2305019, '112A', 929610000, NULL),
(2305046, 2305019, 'A511', NULL, 880000000),
(2305047, 2305019, 'A521', 49610000, NULL),
(2305048, 2305019, '333A', NULL, 88000000); -- VAT 10%

-- Chi phí bán hàng (13% doanh thu = 1.85922 tỷ * 13% = 241.7tr)
INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount)
VALUES
(2305049, 2305020, 'A641', 241700000, NULL),
(2305050, 2305020, '334A', NULL, 150000000),
(2305051, 2305020, '214B', NULL, 50000000),
(2305052, 2305020, '111A', NULL, 41700000);

-- Chi phí quản lý DN (13% doanh thu = 241.7tr)
INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount)
VALUES
(2305053, 2305021, 'A642', 241700000, NULL),
(2305054, 2305021, '334A', NULL, 150000000),
(2305055, 2305021, '214B', NULL, 50000000),
(2305056, 2305021, '111A', NULL, 41700000);

-- 6. Financial activities
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id, supplier_id, customer_id)
VALUES 
(2305022, '2023-05-10', 'Mua chứng khoán ngắn hạn', 5, @period_id, NULL, NULL),
(2305023, '2023-05-18', 'Bán chứng khoán ngắn hạn', 5, @period_id, NULL, 15),
(2305024, '2023-05-20', 'Trả lãi vay ngân hàng', 4, @period_id, NULL, NULL),
(2305025, '2023-05-22', 'Nhận lãi đầu tư chứng khoán', 3, @period_id, NULL, 15);

-- Mua chứng khoán 200tr
INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount)
VALUES
(2305057, 2305022, '121A', 200000000, NULL),
(2305058, 2305022, '112A', NULL, 200000000);

-- Bán chứng khoán 150tr (lãi 10tr)
INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount)
VALUES
(2305059, 2305023, '112A', 165000000, NULL),
(2305060, 2305023, '121A', NULL, 150000000),
(2305061, 2305023, 'B515', NULL, 15000000);

-- Trả lãi vay (8% tổng nợ vay = (900 + 600) * 8% = 120tr)
INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount)
VALUES
(2305062, 2305024, 'B635', 120000000, NULL),
(2305063, 2305024, '112A', NULL, 120000000);

-- Nhận lãi đầu tư (130tr)
INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount)
VALUES
(2305064, 2305025, '112A', 130000000, NULL),
(2305065, 2305025, 'B515', NULL, 130000000);

-- 7. Other activities
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id, supplier_id, customer_id)
VALUES 
(2305026, '2023-05-05', 'Chi phí phạt vi phạm hợp đồng', 4, @period_id, NULL, NULL),
(2305027, '2023-05-15', 'Thu nhập từ bán phế liệu', 3, @period_id, NULL, 18),
(2305028, '2023-05-25', 'Bán TSCĐ không còn sử dụng', 5, @period_id, NULL, 10);

-- Chi phí phạt 50tr
INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount)
VALUES
(2305066, 2305026, 'C811', 50000000, NULL),
(2305067, 2305026, '111A', NULL, 50000000);

-- Thu nhập phế liệu 40tr
INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount)
VALUES
(2305068, 2305027, '111A', 40000000, NULL),
(2305069, 2305027, 'C711', NULL, 40000000);

-- Bán TSCĐ (1.5% TSCĐ = 37.5tr)
INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount)
VALUES
(2305070, 2305028, '112A', 37500000, NULL),
(2305071, 2305028, '214B', 10000000, NULL),
(2305072, 2305028, '211B', NULL, 40000000),
(2305073, 2305028, 'C711', NULL, 7500000);

-- 8. Month-end closing
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id, supplier_id, customer_id)
VALUES 
(2305029, '2023-05-31', 'Kết chuyển chi phí', 5, @period_id, NULL, NULL),
(2305030, '2023-05-31', 'Kết chuyển doanh thu', 5, @period_id, NULL, NULL),
(2305031, '2023-05-31', 'Hạch toán thuế TNDN', 8, @period_id, NULL, NULL),
(2305032, '2023-05-31', 'Kết chuyển thuế TNDN', 5, @period_id, NULL, NULL),
(2305033, '2023-05-31', 'Kết chuyển lợi nhuận', 5, @period_id, NULL, NULL);

-- Kết chuyển chi phí
INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount)
VALUES
(2305074, 2305029, 'D911', 422550000, NULL), -- Giá vốn (211.275 * 2)
(2305075, 2305029, 'A632', NULL, 422550000),
(2305076, 2305029, 'D911', 241700000, NULL), -- Chi phí bán hàng
(2305077, 2305029, 'A641', NULL, 241700000),
(2305078, 2305029, 'D911', 241700000, NULL), -- Chi phí QLDN
(2305079, 2305029, 'A642', NULL, 241700000),
(2305080, 2305029, 'D911', 120000000, NULL), -- Chi phí tài chính
(2305081, 2305029, 'B635', NULL, 120000000),
(2305082, 2305029, 'D911', 50000000, NULL), -- Chi phí khác
(2305083, 2305029, 'C811', NULL, 50000000),
(2305084, 2305029, 'D911', 99220000, NULL), -- Giảm trừ doanh thu (49.61 * 2)
(2305085, 2305029, 'A521', NULL, 99220000);

-- Kết chuyển doanh thu
INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount)
VALUES
(2305086, 2305030, 'A511', 1760000000, NULL), -- Doanh thu bán hàng (880 * 2)
(2305087, 2305030, 'D911', NULL, 1760000000),
(2305088, 2305030, 'B515', 145000000, NULL), -- Doanh thu tài chính (15 + 130)
(2305089, 2305030, 'D911', NULL, 145000000),
(2305090, 2305030, 'C711', 47500000, NULL), -- Thu nhập khác (40 + 7.5)
(2305091, 2305030, 'D911', NULL, 47500000);

-- Tính lợi nhuận trước thuế và thuế TNDN (20%)
-- Lợi nhuận trước thuế = (1.76 tỷ + 145tr + 47.5tr) - (422.55tr + 241.7tr + 241.7tr + 120tr + 50tr + 99.22tr) = 776.33tr
-- Thuế TNDN = 776.33 * 20% = 155.266tr

-- Hạch toán thuế TNDN
INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount)
VALUES
(2305092, 2305031, 'C821', 155266000, NULL),
(2305093, 2305031, '333A', NULL, 155266000);

-- Kết chuyển thuế TNDN
INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount)
VALUES
(2305094, 2305032, 'D911', 155266000, NULL),
(2305095, 2305032, 'C821', NULL, 155266000);

-- Kết chuyển lợi nhuận sau thuế (776.33 - 155.266 = 621.064tr)
INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount)
VALUES
(2305096, 2305033, 'D911', 621064000, NULL),
(2305097, 2305033, '421B', NULL, 621064000);

-- 9. Cash flow activities
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id, supplier_id, customer_id)
VALUES 
(2305034, '2023-05-28', 'Chi trả cổ tức', 4, @period_id, NULL, NULL),
(2305035, '2023-05-29', 'Thu tiền khách hàng', 3, @period_id, NULL, 3),
(2305036, '2023-05-30', 'Trả tiền nhà cung cấp', 4, @period_id, 8, NULL),
(2305037, '2023-05-30', 'Trả thuế TNDN', 4, @period_id, NULL, NULL),
(2305038, '2023-05-30', 'Trả lương nhân viên', 4, @period_id, NULL, NULL),
(2305039, '2023-05-31', 'Trả nợ gốc vay ngắn hạn', 4, @period_id, NULL, NULL),
(2305040, '2023-05-31', 'Trả nợ gốc vay dài hạn', 4, @period_id, NULL, NULL);

-- Chi trả cổ tức (15% lợi nhuận = 93.16tr)
INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount)
VALUES
(2305098, 2305034, '421B', 93160000, NULL),
(2305099, 2305034, '112A', NULL, 93160000);

-- Thu tiền khách hàng (80% phải thu = 929.61 * 80% = 743.688tr)
INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount)
VALUES
(2305100, 2305035, '112A', 743688000, NULL),
(2305101, 2305035, '131A', NULL, 743688000);

-- Trả tiền NCC (75% phải trả = 165 * 75% = 123.75tr)
INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount)
VALUES
(2305102, 2305036, '331A', 123750000, NULL),
(2305103, 2305036, '112A', NULL, 123750000);

-- Trả thuế TNDN (95% = 155.266 * 95% = 147.5tr)
INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount)
VALUES
(2305104, 2305037, '333A', 147500000, NULL),
(2305105, 2305037, '112A', NULL, 147500000);

-- Trả lương nhân viên (85% = 300 * 85% = 255tr)
INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount)
VALUES
(2305106, 2305038, '334A', 255000000, NULL),
(2305107, 2305038, '111A', NULL, 255000000);

-- Trả nợ gốc vay ngắn hạn (10% = 900 * 10% = 90tr)
INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount)
VALUES
(2305108, 2305039, '341A', 90000000, NULL),
(2305109, 2305039, '112A', NULL, 90000000);

-- Trả nợ gốc vay dài hạn (5% = 600 * 5% = 30tr)
INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount)
VALUES
(2305110, 2305040, '341B', 30000000, NULL),
(2305111, 2305040, '112A', NULL, 30000000);


-- FIX
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id, supplier_id, customer_id)
VALUES 
(2305900, '2023-05-28', 'FIX', 5, @period_id, NULL, NULL);
INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount)
VALUES
(2305900, 2305900, '341A', NULL, 23440000);

COMMIT;