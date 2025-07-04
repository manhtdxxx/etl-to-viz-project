-- Start transaction
START TRANSACTION;

-- Set variables for December 2024
SET @period_id = 3; -- 2024
SET @trans_id_base = 2412000;
SET @entry_id_base = 2412000;

-- 1. Hoạt động mua sắm: Mua nguyên vật liệu và công cụ dụng cụ
-- Transaction 1: Mua NVL trị giá 150 triệu, thuế GTGT 15 triệu, thanh toán bằng tiền mặt 50 triệu và nợ ngắn hạn 115 triệu
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`) 
VALUES (@trans_id_base+1, '2024-12-05', 'Mua nguyên vật liệu từ nhà cung cấp', 2, @period_id, 5);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_id_base+1, @trans_id_base+1, '152A', 150000000, NULL),
(@entry_id_base+2, @trans_id_base+1, '133A', 15000000, NULL),
(@entry_id_base+3, @trans_id_base+1, '111A', NULL, 50000000),
(@entry_id_base+4, @trans_id_base+1, '331A', NULL, 115000000);

-- Transaction 2: Mua công cụ dụng cụ trị giá 80 triệu, thuế GTGT 8 triệu, thanh toán bằng chuyển khoản
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`) 
VALUES (@trans_id_base+2, '2024-12-07', 'Mua công cụ dụng cụ từ nhà cung cấp', 2, @period_id, 8);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_id_base+5, @trans_id_base+2, '153A', 80000000, NULL),
(@entry_id_base+6, @trans_id_base+2, '133A', 8000000, NULL),
(@entry_id_base+7, @trans_id_base+2, '112A', NULL, 88000000);

-- 2. Hoạt động sản xuất
-- Transaction 3: Xuất kho NVL (90% của 150 triệu = 135 triệu)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_id_base+3, '2024-12-10', 'Xuất kho nguyên vật liệu cho sản xuất', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_id_base+8, @trans_id_base+3, 'A621', 135000000, NULL),
(@entry_id_base+9, @trans_id_base+3, '152A', NULL, 135000000);

-- Transaction 4: Xuất kho công cụ dụng cụ (85% của 80 triệu = 68 triệu)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_id_base+4, '2024-12-10', 'Xuất kho công cụ dụng cụ cho sản xuất', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_id_base+10, @trans_id_base+4, 'A627', 68000000, NULL),
(@entry_id_base+11, @trans_id_base+4, '153A', NULL, 68000000);

-- Transaction 5: Trích khấu hao TSCĐ (3% của 3,500 triệu = 105 triệu)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_id_base+5, '2024-12-15', 'Trích khấu hao TSCĐ tháng 12/2024', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_id_base+12, @trans_id_base+5, 'A627', 105000000, NULL),
(@entry_id_base+13, @trans_id_base+5, '214B', NULL, 105000000);

-- Transaction 6: Trả lương nhân viên (2.5x khấu hao = 262.5 triệu)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_id_base+6, '2024-12-15', 'Trả lương nhân viên tháng 12/2024', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_id_base+14, @trans_id_base+6, 'A622', 262500000, NULL),
(@entry_id_base+15, @trans_id_base+6, '334A', NULL, 262500000);

-- 3. Hoạt động nhập kho thành phẩm
-- Transaction 7: Kết chuyển chi phí sản xuất vào TK 154 (621: 135tr, 622: 262.5tr, 627: 173tr)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_id_base+7, '2024-12-20', 'Kết chuyển chi phí sản xuất vào chi phí dở dang', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_id_base+16, @trans_id_base+7, '154A', 570500000, NULL),
(@entry_id_base+17, @trans_id_base+7, 'A621', NULL, 135000000),
(@entry_id_base+18, @trans_id_base+7, 'A622', NULL, 262500000),
(@entry_id_base+19, @trans_id_base+7, 'A627', NULL, 173000000);

-- Transaction 8: Nhập kho thành phẩm từ TK 154
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_id_base+8, '2024-12-20', 'Nhập kho thành phẩm từ chi phí sản xuất', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_id_base+20, @trans_id_base+8, '155A', 570500000, NULL),
(@entry_id_base+21, @trans_id_base+8, '154A', NULL, 570500000);

-- 4. Hoạt động bán hàng
-- Transaction 9: Ghi nhận giá vốn (90% của 570.5 triệu = 513.45 triệu)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `customer_id`) 
VALUES (@trans_id_base+9, '2024-12-22', 'Xuất kho thành phẩm bán cho khách hàng', 1, @period_id, 12);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_id_base+22, @trans_id_base+9, 'A632', 513450000, NULL),
(@entry_id_base+23, @trans_id_base+9, '155A', NULL, 513450000);

-- Transaction 10: Ghi nhận doanh thu (1.8x giá vốn = 924.21 triệu), thuế GTGT 10% = 92.421 triệu
-- Thanh toán 50% bằng tiền mặt, 50% nợ ngắn hạn
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `customer_id`) 
VALUES (@trans_id_base+10, '2024-12-22', 'Ghi nhận doanh thu bán hàng', 1, @period_id, 12);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_id_base+24, @trans_id_base+10, '111A', 508315500, NULL),
(@entry_id_base+25, @trans_id_base+10, '131A', 508315500, NULL),
(@entry_id_base+26, @trans_id_base+10, 'A511', NULL, 924210000),
(@entry_id_base+27, @trans_id_base+10, '333A', NULL, 92421000);

-- Transaction 11: Giảm trừ doanh thu (chiết khấu 2% = 18.4842 triệu)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `customer_id`) 
VALUES (@trans_id_base+11, '2024-12-22', 'Giảm trừ doanh thu cho khách hàng', 1, @period_id, 12);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_id_base+28, @trans_id_base+11, 'A521', 18484200, NULL),
(@entry_id_base+29, @trans_id_base+11, '131A', NULL, 18484200);

-- 5. Ghi nhận chi phí bán hàng và QLDN (15% doanh thu mỗi loại)
-- Transaction 12: Chi phí bán hàng (15% của 924.21 triệu = 138.6315 triệu)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_id_base+12, '2024-12-25', 'Ghi nhận chi phí bán hàng tháng 12/2024', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_id_base+30, @trans_id_base+12, 'A641', 138631500, NULL),
(@entry_id_base+31, @trans_id_base+12, '334A', NULL, 100000000),
(@entry_id_base+32, @trans_id_base+12, '111A', NULL, 38631500);

-- Transaction 13: Chi phí quản lý doanh nghiệp (15% của 924.21 triệu = 138.6315 triệu)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_id_base+13, '2024-12-25', 'Ghi nhận chi phí quản lý doanh nghiệp tháng 12/2024', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_id_base+33, @trans_id_base+13, 'A642', 138631500, NULL),
(@entry_id_base+34, @trans_id_base+13, '334A', NULL, 100000000),
(@entry_id_base+35, @trans_id_base+13, '111A', NULL, 38631500);

-- 6. Hoạt động tài chính
-- Transaction 14: Mua chứng khoán ngắn hạn 200 triệu
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_id_base+14, '2024-12-03', 'Mua chứng khoán ngắn hạn', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_id_base+36, @trans_id_base+14, '121A', 200000000 -80802800, NULL), -- FIX
(@entry_id_base+37, @trans_id_base+14, '112A', NULL, 200000000);

-- Transaction 15: Bán chứng khoán ngắn hạn 150 triệu (lãi 10 triệu)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_id_base+15, '2024-12-18', 'Bán chứng khoán ngắn hạn', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_id_base+38, @trans_id_base+15, '112A', 150000000, NULL),
(@entry_id_base+39, @trans_id_base+15, '121A', NULL, 140000000),
(@entry_id_base+40, @trans_id_base+15, 'B515', NULL, 10000000);

-- Transaction 16: Trả lãi vay ngân hàng (7% tổng nợ vay = 2,000 triệu * 7% = 140 triệu)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_id_base+16, '2024-12-20', 'Trả lãi vay ngân hàng tháng 12/2024', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_id_base+41, @trans_id_base+16, 'B635', 140000000, NULL),
(@entry_id_base+42, @trans_id_base+16, '112A', NULL, 140000000);

-- Transaction 17: Nhận lãi từ đầu tư chứng khoán (150 triệu)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_id_base+17, '2024-12-28', 'Nhận lãi từ đầu tư chứng khoán', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_id_base+43, @trans_id_base+17, '112A', 150000000, NULL),
(@entry_id_base+44, @trans_id_base+17, 'B515', NULL, 150000000);

-- 7. Hoạt động khác
-- Transaction 18: Chi phí khác (phạt hợp đồng 50 triệu)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_id_base+18, '2024-12-15', 'Phạt vi phạm hợp đồng với nhà cung cấp', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_id_base+45, @trans_id_base+18, 'C811', 50000000, NULL),
(@entry_id_base+46, @trans_id_base+18, '112A', NULL, 50000000);

-- Transaction 19: Thu nhập khác (bán TSCĐ 35 triệu - 1% của 3,500 triệu)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_id_base+19, '2024-12-20', 'Bán TSCĐ không còn sử dụng', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_id_base+47, @trans_id_base+19, '112A', 35000000, NULL),
(@entry_id_base+48, @trans_id_base+19, '211B', NULL, 30000000),
(@entry_id_base+49, @trans_id_base+19, 'C711', NULL, 5000000);

-- 8. Kết chuyển cuối kỳ
-- Transaction 20: Kết chuyển chi phí
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_id_base+20, '2024-12-31', 'Kết chuyển chi phí tháng 12/2024', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_id_base+50, @trans_id_base+20, 'D911', 1080000000, NULL),
(@entry_id_base+51, @trans_id_base+20, 'A632', NULL, 513450000),
(@entry_id_base+52, @trans_id_base+20, 'A641', NULL, 138631500),
(@entry_id_base+53, @trans_id_base+20, 'A642', NULL, 138631500),
(@entry_id_base+54, @trans_id_base+20, 'B635', NULL, 140000000),
(@entry_id_base+55, @trans_id_base+20, 'C811', NULL, 50000000),
(@entry_id_base+56, @trans_id_base+20, 'A521', NULL, 18484200);

-- Transaction 21: Kết chuyển doanh thu
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_id_base+21, '2024-12-31', 'Kết chuyển doanh thu tháng 12/2024', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_id_base+57, @trans_id_base+21, 'A511', NULL, 924210000),
(@entry_id_base+58, @trans_id_base+21, 'B515', NULL, 160000000),
(@entry_id_base+59, @trans_id_base+21, 'C711', NULL, 5000000),
(@entry_id_base+60, @trans_id_base+21, 'D911', NULL, 1089210000);

-- Transaction 22: Tính thuế TNDN (20% lợi nhuận trước thuế = 20% * (1089.21 - 1080) = 1.842 triệu)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_id_base+22, '2024-12-31', 'Tính thuế TNDN tháng 12/2024', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_id_base+61, @trans_id_base+22, 'C821', 1842000, NULL),
(@entry_id_base+62, @trans_id_base+22, '333A', NULL, 1842000);

-- Transaction 23: Kết chuyển thuế TNDN
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_id_base+23, '2024-12-31', 'Kết chuyển thuế TNDN tháng 12/2024', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_id_base+63, @trans_id_base+23, 'D911', 1842000, NULL),
(@entry_id_base+64, @trans_id_base+23, 'C821', NULL, 1842000);

-- Transaction 24: Kết chuyển lợi nhuận sau thuế (Lợi nhuận trước thuế 9.21tr - thuế 1.842tr = 7.368tr)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_id_base+24, '2024-12-31', 'Kết chuyển lợi nhuận sau thuế tháng 12/2024', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_id_base+65, @trans_id_base+24, 'D911', 7368000, NULL),
(@entry_id_base+66, @trans_id_base+24, '421B', NULL, 7368000);

-- 9. Hoạt động thu chi tiền
-- Transaction 25: Chi trả cổ tức (15% lợi nhuận = 1.1052 triệu)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_id_base+25, '2024-12-31', 'Chi trả cổ tức cho chủ sở hữu', 4, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_id_base+67, @trans_id_base+25, '421B', 1105200, NULL),
(@entry_id_base+68, @trans_id_base+25, '111A', NULL, 1105200);

-- Transaction 26: Thu tiền khách hàng (80% khoản phải thu = 80% * 508.3155tr = 406.6524 triệu)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `customer_id`) 
VALUES (@trans_id_base+26, '2024-12-28', 'Thu tiền từ khách hàng', 3, @period_id, 12);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_id_base+69, @trans_id_base+26, '112A', 406652400, NULL),
(@entry_id_base+70, @trans_id_base+26, '131A', NULL, 406652400);

-- Transaction 27: Trả tiền người bán (85% khoản phải trả = 85% * 115tr = 97.75 triệu)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`) 
VALUES (@trans_id_base+27, '2024-12-29', 'Trả tiền cho nhà cung cấp', 4, @period_id, 5);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_id_base+71, @trans_id_base+27, '331A', 97750000, NULL),
(@entry_id_base+72, @trans_id_base+27, '112A', NULL, 97750000);

-- Transaction 28: Trả thuế TNDN (90% = 1.6578 triệu)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_id_base+28, '2024-12-30', 'Nộp thuế TNDN', 4, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_id_base+73, @trans_id_base+28, '333A', 1657800, NULL),
(@entry_id_base+74, @trans_id_base+28, '112A', NULL, 1657800);

-- Transaction 29: Trả lương nhân viên (90% = 236.25 triệu)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_id_base+29, '2024-12-30', 'Thanh toán lương nhân viên', 4, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_id_base+75, @trans_id_base+29, '334A', 236250000, NULL),
(@entry_id_base+76, @trans_id_base+29, '111A', NULL, 236250000);

-- Transaction 30: Trả nợ gốc vay ngắn hạn (12% = 12% * 600tr = 72 triệu)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_id_base+30, '2024-12-30', 'Trả nợ gốc vay ngắn hạn', 4, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_id_base+77, @trans_id_base+30, '341A', 72000000, NULL),
(@entry_id_base+78, @trans_id_base+30, '112A', NULL, 72000000);

-- Transaction 31: Trả nợ gốc vay dài hạn (6% = 6% * 1,400tr = 84 triệu)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_id_base+31, '2024-12-30', 'Trả nợ gốc vay dài hạn', 4, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_id_base+79, @trans_id_base+31, '341B', 84000000, NULL),
(@entry_id_base+80, @trans_id_base+31, '112A', NULL, 84000000);

-- Commit all transactions
COMMIT;