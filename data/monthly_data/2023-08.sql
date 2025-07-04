START TRANSACTION;

-- Set period_id for 2023 (value 2)
SET @period_id = 2;

-- Set base transaction and entry IDs for August 2023 (yymm = 2308)
SET @trans_base = 2308000;
SET @entry_base = 2308000;

-- 1. Hoạt động huy động vốn và đầu tư TSCĐ (only in January, so we'll skip this for August)

-- 2. Hoạt động sản xuất kinh doanh

-- 2.1 Hoạt động mua sắm nguyên vật liệu, công cụ dụng cụ
-- Transaction 1: Mua nguyên vật liệu trị giá 150 triệu, công cụ dụng cụ 50 triệu từ nhà cung cấp 5, thuế GTGT 10%
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`) 
VALUES (@trans_base+1, '2023-08-05', 'Mua nguyên vật liệu và công cụ dụng cụ từ nhà cung cấp 5', 2, @period_id, 5);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_base+1, @trans_base+1, '152A', 150000000, NULL), -- Nguyên vật liệu
(@entry_base+2, @trans_base+1, '153A', 50000000, NULL),  -- Công cụ dụng cụ
(@entry_base+3, @trans_base+1, '133A', 20000000, NULL),  -- Thuế GTGT được khấu trừ
(@entry_base+4, @trans_base+1, '331A', NULL, 220000000); -- Phải trả người bán

SET @entry_base = @entry_base + 4;
SET @trans_base = @trans_base + 1;

-- Transaction 2: Mua nguyên vật liệu trị giá 120 triệu bằng tiền mặt, thuế GTGT 10%
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`) 
VALUES (@trans_base+1, '2023-08-10', 'Mua nguyên vật liệu bằng tiền mặt', 2, @period_id, 8);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_base+1, @trans_base+1, '152A', 120000000, NULL), -- Nguyên vật liệu
(@entry_base+2, @trans_base+1, '133A', 12000000, NULL),  -- Thuế GTGT được khấu trừ
(@entry_base+3, @trans_base+1, '111A', NULL, 132000000); -- Tiền mặt

SET @entry_base = @entry_base + 3;
SET @trans_base = @trans_base + 1;

-- 2.2 Hoạt động sản xuất
-- Giả sử TSCĐ tổng là 2,500 triệu, khấu hao 3% = 75 triệu
-- Lương nhân viên gấp 2x khấu hao = 150 triệu

-- Transaction 3: Xuất kho nguyên vật liệu (90% của 270 triệu = 243 triệu)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_base+1, '2023-08-15', 'Xuất kho nguyên vật liệu cho sản xuất', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_base+1, @trans_base+1, 'A621', 243000000, NULL), -- Chi phí NVL trực tiếp
(@entry_base+2, @trans_base+1, '152A', NULL, 243000000); -- Giảm nguyên vật liệu

SET @entry_base = @entry_base + 2;
SET @trans_base = @trans_base + 1;

-- Transaction 4: Xuất kho công cụ dụng cụ (85% của 50 triệu = 42.5 triệu)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_base+1, '2023-08-15', 'Xuất kho công cụ dụng cụ cho sản xuất', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_base+1, @trans_base+1, 'A627', 42500000, NULL), -- Chi phí sản xuất chung
(@entry_base+2, @trans_base+1, '153A', NULL, 42500000); -- Giảm công cụ dụng cụ

SET @entry_base = @entry_base + 2;
SET @trans_base = @trans_base + 1;

-- Transaction 5: Trích khấu hao TSCĐ 75 triệu
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_base+1, '2023-08-20', 'Trích khấu hao TSCĐ', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_base+1, @trans_base+1, 'A627', 75000000, NULL), -- Chi phí sản xuất chung
(@entry_base+2, @trans_base+1, '214B', NULL, 75000000); -- Hao mòn TSCĐ

SET @entry_base = @entry_base + 2;
SET @trans_base = @trans_base + 1;

-- Transaction 6: Trả lương nhân viên sản xuất 150 triệu
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_base+1, '2023-08-25', 'Trả lương nhân viên sản xuất', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_base+1, @trans_base+1, 'A622', 150000000, NULL), -- Chi phí nhân công trực tiếp
(@entry_base+2, @trans_base+1, '334A', NULL, 150000000); -- Phải trả người lao động

SET @entry_base = @entry_base + 2;
SET @trans_base = @trans_base + 1;

-- 2.3 Hoạt động nhập kho thành phẩm
-- Tổng chi phí sản xuất: 243 (NVL) + 150 (lương) + 75 (khấu hao) + 42.5 (CCDC) = 510.5 triệu

-- Transaction 7: Kết chuyển chi phí sản xuất vào chi phí dở dang
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_base+1, '2023-08-28', 'Kết chuyển chi phí sản xuất', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_base+1, @trans_base+1, '154A', 510500000, NULL), -- Chi phí SXKD dở dang
(@entry_base+2, @trans_base+1, 'A621', NULL, 243000000),  -- Giảm chi phí NVL trực tiếp
(@entry_base+3, @trans_base+1, 'A622', NULL, 150000000), -- Giảm chi phí nhân công trực tiếp
(@entry_base+4, @trans_base+1, 'A627', NULL, 117500000);  -- Giảm chi phí sản xuất chung

SET @entry_base = @entry_base + 4;
SET @trans_base = @trans_base + 1;

-- Transaction 8: Nhập kho thành phẩm từ chi phí dở dang
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_base+1, '2023-08-29', 'Nhập kho thành phẩm', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_base+1, @trans_base+1, '155A', 510500000, NULL), -- Thành phẩm
(@entry_base+2, @trans_base+1, '154A', NULL, 510500000); -- Giảm chi phí SXKD dở dang

SET @entry_base = @entry_base + 2;
SET @trans_base = @trans_base + 1;

-- 2.4 Hoạt động bán hàng (bán 90% thành phẩm = 459.45 triệu giá vốn)
-- Doanh thu gấp 2.2 lần giá vốn = 1,010.79 triệu

-- Transaction 9: Ghi nhận giá vốn hàng bán
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `customer_id`) 
VALUES (@trans_base+1, '2023-08-30', 'Ghi nhận giá vốn hàng bán cho khách hàng 3', 1, @period_id, 3);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_base+1, @trans_base+1, 'A632', 459450000, NULL), -- Giá vốn hàng bán
(@entry_base+2, @trans_base+1, '155A', NULL, 459450000); -- Giảm thành phẩm

SET @entry_base = @entry_base + 2;
SET @trans_base = @trans_base + 1;

-- Transaction 10: Ghi nhận doanh thu bán hàng (70% bằng tiền, 30% nợ)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `customer_id`) 
VALUES (@trans_base+1, '2023-08-30', 'Ghi nhận doanh thu bán hàng cho khách hàng 3', 1, @period_id, 3);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_base+1, @trans_base+1, '112A', 707553000, NULL),    -- Tiền gửi ngân hàng (70% doanh thu)
(@entry_base+2, @trans_base+1, '131A', 303237000, NULL),    -- Phải thu khách hàng (30% doanh thu)
(@entry_base+3, @trans_base+1, 'A511', NULL, 1010790000),   -- Doanh thu bán hàng
(@entry_base+4, @trans_base+1, '333A', NULL, 100790000);    -- Thuế phải nộp (10% doanh thu)

SET @entry_base = @entry_base + 4;
SET @trans_base = @trans_base + 1;

-- Transaction 11: Ghi nhận giảm trừ doanh thu (2% doanh thu = 20.2158 triệu)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `customer_id`) 
VALUES (@trans_base+1, '2023-08-31', 'Ghi nhận giảm trừ doanh thu', 1, @period_id, 3);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_base+1, @trans_base+1, 'A521', 20215800, NULL),    -- Giảm trừ doanh thu
(@entry_base+2, @trans_base+1, '131A', NULL, 20215800);    -- Giảm phải thu khách hàng

SET @entry_base = @entry_base + 2;
SET @trans_base = @trans_base + 1;

-- 2.5 Hoạt động ghi nhận chi phí bán hàng và quản lý
-- Chi phí bán hàng 15% doanh thu = 151.6185 triệu
-- Chi phí QLDN 15% doanh thu = 151.6185 triệu

-- Transaction 12: Ghi nhận chi phí bán hàng (tiền lương 100 triệu, chi phí khác 51.6185 triệu)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_base+1, '2023-08-31', 'Ghi nhận chi phí bán hàng', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_base+1, @trans_base+1, 'A641', 100000000, NULL),   -- Chi phí bán hàng (lương)
(@entry_base+2, @trans_base+1, 'A641', 51618500, NULL),    -- Chi phí bán hàng (khác)
(@entry_base+3, @trans_base+1, '334A', NULL, 100000000),    -- Phải trả người lao động
(@entry_base+4, @trans_base+1, '111A', NULL, 51618500);     -- Tiền mặt

SET @entry_base = @entry_base + 4;
SET @trans_base = @trans_base + 1;

-- Transaction 13: Ghi nhận chi phí quản lý doanh nghiệp (tiền lương 100 triệu, chi phí khác 51.6185 triệu)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_base+1, '2023-08-31', 'Ghi nhận chi phí quản lý doanh nghiệp', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_base+1, @trans_base+1, 'A642', 100000000, NULL),   -- Chi phí QLDN (lương)
(@entry_base+2, @trans_base+1, 'A642', 51618500, NULL),    -- Chi phí QLDN (khác)
(@entry_base+3, @trans_base+1, '334A', NULL, 100000000),   -- Phải trả người lao động
(@entry_base+4, @trans_base+1, '111A', NULL, 51618500);    -- Tiền mặt

SET @entry_base = @entry_base + 4;
SET @trans_base = @trans_base + 1;

-- 3. Hoạt động tài chính

-- 3.1 Mua chứng khoán 200 triệu (ngắn hạn)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_base+1, '2023-08-15', 'Mua chứng khoán ngắn hạn', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_base+1, @trans_base+1, '121A', 200000000, NULL),   -- Chứng khoán kinh doanh
(@entry_base+2, @trans_base+1, '112A', NULL, 200000000);  -- Tiền gửi ngân hàng

SET @entry_base = @entry_base + 2;
SET @trans_base = @trans_base + 1;

-- 3.2 Bán chứng khoán 150 triệu (lãi 10 triệu)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_base+1, '2023-08-20', 'Bán chứng khoán ngắn hạn', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_base+1, @trans_base+1, '112A', 160000000, NULL),   -- Tiền gửi ngân hàng
(@entry_base+2, @trans_base+1, '121A', NULL, 150000000),   -- Giảm chứng khoán kinh doanh
(@entry_base+3, @trans_base+1, 'B515', NULL, 10000000);    -- Doanh thu hoạt động tài chính

SET @entry_base = @entry_base + 3;
SET @trans_base = @trans_base + 1;

-- 3.3 Trả lãi vay ngân hàng (8% tổng nợ vay = 8% * (900 + 1,100) = 160 triệu)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_base+1, '2023-08-25', 'Trả lãi vay ngân hàng', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_base+1, @trans_base+1, 'B635', 160000000, NULL),  -- Chi phí tài chính
(@entry_base+2, @trans_base+1, '112A', NULL, 160000000);  -- Tiền gửi ngân hàng

SET @entry_base = @entry_base + 2;
SET @trans_base = @trans_base + 1;

-- 3.4 Nhận lãi từ đầu tư chứng khoán (170 triệu)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_base+1, '2023-08-28', 'Nhận lãi từ đầu tư chứng khoán', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_base+1, @trans_base+1, '112A', 170000000, NULL),  -- Tiền gửi ngân hàng
(@entry_base+2, @trans_base+1, 'B515', NULL, 170000000);  -- Doanh thu hoạt động tài chính

SET @entry_base = @entry_base + 2;
SET @trans_base = @trans_base + 1;

-- 4. Hoạt động khác

-- 4.1 Chi phí khác (phạt vi phạm hợp đồng 50 triệu)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_base+1, '2023-08-10', 'Chi phí phạt vi phạm hợp đồng', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_base+1, @trans_base+1, 'C811', 50000000, NULL),   -- Chi phí khác
(@entry_base+2, @trans_base+1, '112A', NULL, 50000000);   -- Tiền gửi ngân hàng

SET @entry_base = @entry_base + 2;
SET @trans_base = @trans_base + 1;

-- 4.2 Thu nhập khác (bán TSCĐ 1.5% = 37.5 triệu)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_base+1, '2023-08-20', 'Thu nhập từ bán TSCĐ', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_base+1, @trans_base+1, '112A', 37500000, NULL),    -- Tiền gửi ngân hàng
(@entry_base+2, @trans_base+1, '211B', NULL, 30000000),    -- Giảm TSCĐ (giá gốc)
(@entry_base+3, @trans_base+1, '214B', NULL, 5000000),     -- Giảm hao mòn TSCĐ
(@entry_base+4, @trans_base+1, 'C711', NULL, 12500000);   -- Thu nhập khác

SET @entry_base = @entry_base + 4;
SET @trans_base = @trans_base + 1;

-- 5. Cuối tháng kết chuyển

-- 5.1 Kết chuyển chi phí vào TK 911
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_base+1, '2023-08-31', 'Kết chuyển chi phí', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_base+1, @trans_base+1, 'D911', 459450000, NULL),   -- Giá vốn hàng bán
(@entry_base+2, @trans_base+1, 'D911', 151618500, NULL),  -- Chi phí bán hàng
(@entry_base+3, @trans_base+1, 'D911', 151618500, NULL),  -- Chi phí QLDN
(@entry_base+4, @trans_base+1, 'D911', 160000000, NULL),  -- Chi phí tài chính
(@entry_base+5, @trans_base+1, 'D911', 50000000, NULL),   -- Chi phí khác
(@entry_base+6, @trans_base+1, 'D911', 20215800, NULL),   -- Giảm trừ doanh thu
(@entry_base+7, @trans_base+1, 'A632', NULL, 459450000),  -- Giảm giá vốn hàng bán
(@entry_base+8, @trans_base+1, 'A641', NULL, 151618500),  -- Giảm chi phí bán hàng
(@entry_base+9, @trans_base+1, 'A642', NULL, 151618500),  -- Giảm chi phí QLDN
(@entry_base+10, @trans_base+1, 'B635', NULL, 160000000), -- Giảm chi phí tài chính
(@entry_base+11, @trans_base+1, 'C811', NULL, 50000000),  -- Giảm chi phí khác
(@entry_base+12, @trans_base+1, 'A521', NULL, 20215800);  -- Giảm giảm trừ doanh thu

SET @entry_base = @entry_base + 12;
SET @trans_base = @trans_base + 1;

-- 5.2 Kết chuyển doanh thu vào TK 911
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_base+1, '2023-08-31', 'Kết chuyển doanh thu', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_base+1, @trans_base+1, 'A511', 1010790000, NULL), -- Doanh thu bán hàng
(@entry_base+2, @trans_base+1, 'B515', 180000000, NULL),  -- Doanh thu tài chính
(@entry_base+3, @trans_base+1, 'C711', 12500000, NULL),   -- Thu nhập khác
(@entry_base+4, @trans_base+1, 'D911', NULL, 1203290000); -- Kết chuyển vào TK 911

SET @entry_base = @entry_base + 4;
SET @trans_base = @trans_base + 1;

-- 5.3 Tính và hạch toán thuế TNDN (20% lợi nhuận trước thuế)
-- Lợi nhuận trước thuế = 1,203,290,000 - 992,902,300 = 210,387,700
-- Thuế TNDN = 20% * 210,387,700 = 42,077,540

INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_base+1, '2023-08-31', 'Hạch toán thuế TNDN', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_base+1, @trans_base+1, 'C821', 42077540, NULL),    -- Chi phí thuế TNDN
(@entry_base+2, @trans_base+1, '333A', NULL, 42077540);    -- Thuế phải nộp

SET @entry_base = @entry_base + 2;
SET @trans_base = @trans_base + 1;

-- 5.4 Kết chuyển chi phí thuế TNDN
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_base+1, '2023-08-31', 'Kết chuyển chi phí thuế TNDN', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_base+1, @trans_base+1, 'D911', 42077540, NULL),   -- Kết chuyển vào TK 911
(@entry_base+2, @trans_base+1, 'C821', NULL, 42077540);   -- Giảm chi phí thuế TNDN

SET @entry_base = @entry_base + 2;
SET @trans_base = @trans_base + 1;

-- 5.5 Kết chuyển lợi nhuận sau thuế
-- Lợi nhuận sau thuế = 210,387,700 - 42,077,540 = 168,310,160

INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_base+1, '2023-08-31', 'Kết chuyển lợi nhuận sau thuế', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_base+1, @trans_base+1, 'D911', 168310160, NULL),   -- Kết chuyển từ TK 911
(@entry_base+2, @trans_base+1, '421B', NULL, 168310160);  -- Lợi nhuận sau thuế

SET @entry_base = @entry_base + 2;
SET @trans_base = @trans_base + 1;

-- 6. Hoạt động thu chi tiền

-- 6.1 Chi trả cổ tức (15% lợi nhuận = 25,246,524)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_base+1, '2023-08-31', 'Chi trả cổ tức', 4, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_base+1, @trans_base+1, '421B', 25246524, NULL),   -- Giảm lợi nhuận sau thuế
(@entry_base+2, @trans_base+1, '111A', NULL, 25246524);   -- Tiền mặt

SET @entry_base = @entry_base + 2;
SET @trans_base = @trans_base + 1;

-- 6.2 Thu tiền khách hàng (80% khoản phải thu = 80% * (303,237,000 - 20,215,800) = 226,416,960)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `customer_id`) 
VALUES (@trans_base+1, '2023-08-31', 'Thu tiền từ khách hàng', 3, @period_id, 3);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_base+1, @trans_base+1, '112A', 226416960, NULL),   -- Tiền gửi ngân hàng
(@entry_base+2, @trans_base+1, '131A', NULL, 226416960);   -- Giảm phải thu khách hàng

SET @entry_base = @entry_base + 2;
SET @trans_base = @trans_base + 1;

-- 6.3 Trả tiền người bán (75% khoản phải trả = 75% * 220,000,000 = 165,000,000)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`) 
VALUES (@trans_base+1, '2023-08-31', 'Trả tiền cho nhà cung cấp', 4, @period_id, 5);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_base+1, @trans_base+1, '331A', 165000000, NULL),   -- Giảm phải trả người bán
(@entry_base+2, @trans_base+1, '112A', NULL, 165000000);  -- Tiền gửi ngân hàng

SET @entry_base = @entry_base + 2;
SET @trans_base = @trans_base + 1;

-- 6.4 Trả thuế TNDN (90% = 37,869,786)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_base+1, '2023-08-31', 'Trả thuế TNDN', 4, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_base+1, @trans_base+1, '333A', 37869786, NULL),    -- Giảm thuế phải nộp
(@entry_base+2, @trans_base+1, '112A', NULL, 37869786);   -- Tiền gửi ngân hàng

SET @entry_base = @entry_base + 2;
SET @trans_base = @trans_base + 1;

-- 6.5 Trả lương nhân viên (85% = 85% * 350,000,000 = 297,500,000)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_base+1, '2023-08-31', 'Trả lương nhân viên', 4, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_base+1, @trans_base+1, '334A', 297500000, NULL),   -- Giảm phải trả người lao động
(@entry_base+2, @trans_base+1, '111A', NULL, 297500000);  -- Tiền mặt

SET @entry_base = @entry_base + 2;
SET @trans_base = @trans_base + 1;

-- 6.6 Trả nợ gốc vay ngắn hạn (10% = 90 triệu)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_base+1, '2023-08-31', 'Trả nợ gốc vay ngắn hạn', 4, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_base+1, @trans_base+1, '341A', 90000000, NULL),    -- Giảm vay ngắn hạn
(@entry_base+2, @trans_base+1, '112A', NULL, 90000000);    -- Tiền gửi ngân hàng

SET @entry_base = @entry_base + 2;
SET @trans_base = @trans_base + 1;

-- 6.7 Trả nợ gốc vay dài hạn (5% = 55 triệu)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (@trans_base+1, '2023-08-31', 'Trả nợ gốc vay dài hạn', 4, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(@entry_base+1, @trans_base+1, '341B', 55000000, NULL),    -- Giảm vay dài hạn
(@entry_base+2, @trans_base+1, '112A', NULL, 55000000);    -- Tiền gửi ngân hàng

SET @entry_base = @entry_base + 2;
SET @trans_base = @trans_base + 1;


-- FIX
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `customer_id`, `supplier_id`) 
VALUES (2308900, '2023-08-30', 'FIX', 5, @period_id, NULL, NULL);
INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES (2308900, 2308900, '211B', 110790500, NULL);

COMMIT;