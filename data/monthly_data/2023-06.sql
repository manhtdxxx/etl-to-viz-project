START TRANSACTION;

-- Set period_id to 2 for year 2023
SET @period_id = 2;

-- Insert transactions for June 2023 (starting with 2306000)
-- Note: Since you said to only use transaction IDs from yymm000, I'll use 2306000-2306999

-- 1. Capital contribution - 500 million (only in January, so skipping for June)

-- 2. Short-term loan - 900 million (only in January, so skipping for June)

-- 3. Long-term loan - 600 million (only in January, so skipping for June)

-- 4. Fixed asset investment - 1,000 million (only in January, so skipping for June)

-- 5. Purchasing activities (materials and tools)
INSERT INTO `journal_transaction` VALUES 
(2306001, '2023-06-05', 'Mua nguyên vật liệu từ nhà cung cấp A', 2, @period_id, 5, NULL),
(2306002, '2023-06-07', 'Mua công cụ dụng cụ từ nhà cung cấp B', 2, @period_id, 8, NULL),
(2306003, '2023-06-10', 'Thanh toán tiền mua nguyên vật liệu', 4, @period_id, 5, NULL),
(2306004, '2023-06-12', 'Mua nguyên vật liệu từ nhà cung cấp C', 2, @period_id, 12, NULL);

-- Entries for purchasing transactions
INSERT INTO `journal_entry` VALUES 
(2306001, 2306001, '152A', 180000000, NULL), -- NVL 180tr
(2306002, 2306001, '133A', 18000000, NULL),  -- VAT 10% 18tr
(2306003, 2306001, '331A', NULL, 198000000), -- Phải trả 198tr
(2306004, 2306002, '153A', 75000000, NULL),  -- CCDC 75tr
(2306005, 2306002, '133A', 7500000, NULL),   -- VAT 7.5tr
(2306006, 2306002, '331A', NULL, 82500000),  -- Phải trả 82.5tr
(2306007, 2306003, '331A', 100000000, NULL), -- Trả 100tr
(2306008, 2306003, '112A', NULL, 100000000), -- Tiền gửi NH 100tr
(2306009, 2306004, '152A', 120000000, NULL), -- NVL 120tr
(2306010, 2306004, '133A', 12000000, NULL),  -- VAT 12tr
(2306011, 2306004, '331B', NULL, 132000000); -- Phải trả dài hạn 132tr

-- 6. Production activities
INSERT INTO `journal_transaction` VALUES 
(2306005, '2023-06-15', 'Xuất kho nguyên vật liệu sản xuất', 5, @period_id, NULL, NULL),
(2306006, '2023-06-16', 'Trích khấu hao TSCĐ', 5, @period_id, NULL, NULL),
(2306007, '2023-06-18', 'Trả lương nhân viên sản xuất', 5, @period_id, NULL, NULL),
(2306008, '2023-06-20', 'Xuất kho công cụ dụng cụ sản xuất', 5, @period_id, NULL, NULL);

-- Entries for production activities
INSERT INTO `journal_entry` VALUES 
(2306012, 2306005, 'A621', 255000000, NULL), -- CP NVL TT 255tr (85% of 300tr purchased)
(2306013, 2306005, '152A', NULL, 255000000), -- Giảm NVL 255tr
(2306014, 2306006, 'A627', 60000000, NULL),  -- Khấu hao 60tr (2.4% of 2500tr)
(2306015, 2306006, '214B', NULL, 60000000 - 25000000),  -- Hao mòn TSCĐ 60tr  -- FIX NHE!
(2306016, 2306007, 'A622', 150000000, NULL), -- CP nhân công 150tr (2.5x khấu hao)
(2306017, 2306007, '334A', NULL, 150000000), -- Phải trả NLĐ 150tr
(2306018, 2306008, 'A627', 67500000, NULL),  -- CP CCDC 67.5tr (90% of 75tr)
(2306019, 2306008, '153A', NULL, 67500000);  -- Giảm CCDC 67.5tr

-- 7. Finished goods
INSERT INTO `journal_transaction` VALUES 
(2306009, '2023-06-25', 'Kết chuyển chi phí sản xuất', 5, @period_id, NULL, NULL),
(2306010, '2023-06-26', 'Nhập kho thành phẩm', 5, @period_id, NULL, NULL);

-- Entries for finished goods
INSERT INTO `journal_entry` VALUES 
(2306020, 2306009, '154A', 532500000, NULL), -- Tổng CP SX 532.5tr (621+622+627)
(2306021, 2306009, 'A621', NULL, 255000000),
(2306022, 2306009, 'A622', NULL, 150000000),
(2306023, 2306009, 'A627', NULL, 127500000),
(2306024, 2306010, '155A', 532500000, NULL), -- Nhập kho TP 532.5tr
(2306025, 2306010, '154A', NULL, 532500000);

-- 8. Sales activities (COGS first)
INSERT INTO `journal_transaction` VALUES 
(2306011, '2023-06-05', 'Xuất kho thành phẩm bán cho khách A', 1, @period_id, NULL, 3),
(2306012, '2023-06-10', 'Xuất kho thành phẩm bán cho khách B', 1, @period_id, NULL, 7),
(2306013, '2023-06-15', 'Xuất kho thành phẩm bán cho khách C', 1, @period_id, NULL, 15);

-- Entries for COGS
INSERT INTO `journal_entry` VALUES 
(2306026, 2306011, 'A632', 212500000, NULL), -- Giá vốn 212.5tr (40% of revenue)
(2306027, 2306011, '155A', NULL, 212500000),
(2306028, 2306012, 'A632', 159375000, NULL), -- Giá vốn 159.375tr
(2306029, 2306012, '155A', NULL, 159375000),
(2306030, 2306013, 'A632', 106250000, NULL), -- Giá vốn 106.25tr
(2306031, 2306013, '155A', NULL, 106250000);

-- 9. Sales revenue
INSERT INTO `journal_transaction` VALUES 
(2306014, '2023-06-05', 'Bán hàng cho khách A', 1, @period_id, NULL, 3),
(2306015, '2023-06-10', 'Bán hàng cho khách B', 1, @period_id, NULL, 7),
(2306016, '2023-06-15', 'Bán hàng cho khách C', 1, @period_id, NULL, 15),
(2306017, '2023-06-20', 'Chiết khấu cho khách A', 1, @period_id, NULL, 3);

-- Entries for sales revenue
INSERT INTO `journal_entry` VALUES 
(2306032, 2306014, '131A', 550000000, NULL), -- Phải thu 550tr
(2306033, 2306014, 'A511', NULL, 500000000), -- Doanh thu 500tr
(2306034, 2306014, '333A', NULL, 50000000),  -- Thuế 50tr
(2306035, 2306015, '112A', 425000000, NULL), -- Tiền NH 425tr
(2306036, 2306015, 'A511', NULL, 386363636), -- Doanh thu 386.36tr
(2306037, 2306015, '333A', NULL, 38636364),  -- Thuế 38.64tr
(2306038, 2306016, '131B', 275000000, NULL), -- Phải thu dài hạn 275tr
(2306039, 2306016, 'A511', NULL, 250000000), -- Doanh thu 250tr
(2306040, 2306016, '333A', NULL, 25000000),  -- Thuế 25tr
(2306041, 2306017, 'A521', 25000000, NULL),  -- Giảm trừ DT 25tr
(2306042, 2306017, '131A', NULL, 25000000);  -- Giảm phải thu 25tr

-- 10. Selling and administrative expenses
INSERT INTO `journal_transaction` VALUES 
(2306018, '2023-06-18', 'Chi phí bán hàng', 5, @period_id, NULL, NULL),
(2306019, '2023-06-19', 'Chi phí quản lý doanh nghiệp', 5, @period_id, NULL, NULL),
(2306020, '2023-06-20', 'Thanh toán chi phí bán hàng', 4, @period_id, NULL, NULL);

-- Entries for selling and admin expenses
INSERT INTO `journal_entry` VALUES 
(2306043, 2306018, 'A641', 136363636, NULL), -- CP bán hàng 136.36tr (12% of revenue)
(2306044, 2306018, '334A', NULL, 80000000),   -- Lương NV bán hàng 80tr
(2306045, 2306018, '331A', NULL, 56363636),   -- Phải trả khác 56.36tr
(2306046, 2306019, 'A642', 136363636, NULL), -- CP QLDN 136.36tr
(2306047, 2306019, '334A', NULL, 70000000),   -- Lương NV QLDN 70tr
(2306048, 2306019, '214B', NULL, 20000000),   -- Khấu hao 20tr
(2306049, 2306019, '331A', NULL, 46363636),   -- Phải trả khác 46.36tr
(2306050, 2306020, '331A', 50000000, NULL),   -- Thanh toán 50tr
(2306051, 2306020, '112A', NULL, 50000000);   -- Tiền NH 50tr

-- 11. Financial activities (investments)
INSERT INTO `journal_transaction` VALUES 
(2306021, '2023-06-10', 'Mua chứng khoán ngắn hạn', 5, @period_id, NULL, NULL),
(2306022, '2023-06-15', 'Bán chứng khoán ngắn hạn', 5, @period_id, NULL, NULL),
(2306023, '2023-06-20', 'Trả lãi vay ngân hàng', 5, @period_id, NULL, NULL),
(2306024, '2023-06-25', 'Nhận lãi đầu tư chứng khoán', 5, @period_id, NULL, NULL);

-- Entries for financial activities
INSERT INTO `journal_entry` VALUES 
(2306052, 2306021, '121A', 300000000, NULL), -- CK ngắn hạn 300tr
(2306053, 2306021, '112A', NULL, 300000000), -- Tiền NH 300tr
(2306054, 2306022, '112A', 220000000, NULL), -- Tiền NH 220tr
(2306055, 2306022, '121A', NULL, 200000000), -- Giá gốc CK 200tr
(2306056, 2306022, 'B515', NULL, 20000000),  -- Lãi CK 20tr
(2306057, 2306023, 'B635', 120000000, NULL), -- Lãi vay 120tr (8% of 1500tr)
(2306058, 2306023, '112A', NULL, 120000000),-- Tiền NH 120tr
(2306059, 2306024, '112A', 150000000, NULL),-- Tiền NH 150tr
(2306060, 2306024, 'B515', NULL, 150000000); -- Lãi đầu tư 150tr

-- 12. Other activities
INSERT INTO `journal_transaction` VALUES 
(2306025, '2023-06-05', 'Phạt vi phạm hợp đồng', 5, @period_id, NULL, NULL),
(2306026, '2023-06-10', 'Bán TSCĐ không còn sử dụng', 5, @period_id, NULL, NULL),
(2306027, '2023-06-15', 'Thu bồi thường bảo hiểm', 5, @period_id, NULL, NULL);

-- Entries for other activities
INSERT INTO `journal_entry` VALUES 
(2306061, 2306025, 'C811', 50000000, NULL),  -- Chi phí khác 50tr
(2306062, 2306025, '111A', NULL, 50000000),  -- Tiền mặt 50tr
(2306063, 2306026, '214B', 25000000, NULL),  -- Hao mòn TSCĐ 25tr
(2306064, 2306026, '211B', NULL, 50000000), -- Nguyên giá TSCĐ 50tr (2% of 2500tr)
(2306065, 2306026, '111A', 30000000, NULL), -- Tiền mặt 30tr
(2306066, 2306026, 'C711', NULL, 5000000),  -- Lãi bán TSCĐ 5tr
(2306067, 2306027, '112A', 60000000, NULL), -- Tiền NH 60tr
(2306068, 2306027, 'C711', NULL, 60000000); -- Thu nhập khác 60tr

-- 13. Month-end closing entries
INSERT INTO `journal_transaction` VALUES 
(2306028, '2023-06-30', 'Kết chuyển doanh thu', 5, @period_id, NULL, NULL),
(2306029, '2023-06-30', 'Kết chuyển chi phí', 5, @period_id, NULL, NULL),
(2306030, '2023-06-30', 'Tính thuế TNDN', 5, @period_id, NULL, NULL),
(2306031, '2023-06-30', 'Kết chuyển thuế TNDN', 5, @period_id, NULL, NULL),
(2306032, '2023-06-30', 'Kết chuyển lợi nhuận', 5, @period_id, NULL, NULL);

-- Calculate profit before tax
SET @revenue = 500000000 + 386363636 + 250000000 + 20000000 + 150000000 + 5000000 + 60000000;
SET @expenses = 212500000 + 159375000 + 106250000 + 136363636 + 136363636 + 120000000 + 50000000;
SET @profit_before_tax = @revenue - @expenses;
SET @tax = @profit_before_tax * 0.2;
SET @profit_after_tax = @profit_before_tax - @tax;

-- Entries for closing
INSERT INTO `journal_entry` VALUES 
-- Transfer revenues
(2306069, 2306028, 'A511', 1136363636, NULL), -- Doanh thu bán hàng
(2306070, 2306028, 'B515', 170000000, NULL),   -- Doanh thu tài chính
(2306071, 2306028, 'C711', 65000000, NULL),    -- Thu nhập khác
(2306072, 2306028, 'D911', NULL, 1371363636),  -- Tổng doanh thu

-- Transfer expenses
(2306073, 2306029, 'D911', 821251272, NULL),   -- Tổng chi phí
(2306074, 2306029, 'A632', NULL, 478125000),   -- Giá vốn
(2306075, 2306029, 'A641', NULL, 136363636),   -- CP bán hàng
(2306076, 2306029, 'A642', NULL, 136363636),   -- CP QLDN
(2306077, 2306029, 'B635', NULL, 120000000),   -- CP tài chính
(2306078, 2306029, 'C811', NULL, 50000000),    -- CP khác
(2306079, 2306029, 'A521', NULL, 25000000),    -- Giảm trừ DT

-- Tax provision
(2306080, 2306030, 'C821', @tax, NULL),        -- Thuế TNDN
(2306081, 2306030, '333A', NULL, @tax),        -- Phải nộp

-- Transfer tax
(2306082, 2306031, 'D911', @tax, NULL),        -- Kết chuyển thuế
(2306083, 2306031, 'C821', NULL, @tax),        -- Giảm CP thuế

-- Transfer profit
(2306084, 2306032, 'D911', @profit_after_tax, NULL), -- LNST
(2306085, 2306032, '421B', NULL, @profit_after_tax); -- Vốn CSH

-- 14. Cash flow activities
INSERT INTO `journal_transaction` VALUES 
(2306033, '2023-06-28', 'Chi trả cổ tức', 4, @period_id, NULL, NULL),
(2306034, '2023-06-29', 'Thu tiền khách hàng', 3, @period_id, NULL, 3),
(2306035, '2023-06-30', 'Trả tiền nhà cung cấp', 4, @period_id, 5, NULL),
(2306036, '2023-06-30', 'Nộp thuế TNDN', 4, @period_id, NULL, NULL),
(2306037, '2023-06-30', 'Trả lương nhân viên', 4, @period_id, NULL, NULL),
(2306038, '2023-06-30', 'Trả nợ gốc vay ngắn hạn', 4, @period_id, NULL, NULL),
(2306039, '2023-06-30', 'Trả nợ gốc vay dài hạn', 4, @period_id, NULL, NULL);

-- Entries for cash flow activities
INSERT INTO `journal_entry` VALUES 
(2306086, 2306033, '421B', @profit_after_tax * 0.15, NULL), -- Cổ tức 15% LNST
(2306087, 2306033, '112A', NULL, @profit_after_tax * 0.15),  -- Tiền NH
(2306088, 2306034, '112A', 400000000, NULL),                -- Thu tiền KH 400tr (80% of 500tr)
(2306089, 2306034, '131A', NULL, 400000000),                -- Giảm phải thu
(2306090, 2306035, '331A', 150000000, NULL),                -- Trả NCC 150tr
(2306091, 2306035, '112A', NULL, 150000000),                -- Tiền NH
(2306092, 2306036, '333A', @tax * 0.9, NULL),               -- Nộp thuế 90%
(2306093, 2306036, '112A', NULL, @tax * 0.9),               -- Tiền NH
(2306094, 2306037, '334A', 120000000, NULL),                -- Trả lương 120tr (80% of 150tr)
(2306095, 2306037, '111A', NULL, 120000000),                -- Tiền mặt
(2306096, 2306038, '341A', 120000000, NULL),                -- Trả nợ ngắn hạn 120tr (12% of 1000tr)
(2306097, 2306038, '112A', NULL, 120000000),                -- Tiền NH
(2306098, 2306039, '341B', 55000000, NULL),                 -- Trả nợ dài hạn 55tr (5% of 1100tr)
(2306099, 2306039, '112A', NULL, 55000000);                 -- Tiền NH

-- FIX
INSERT INTO `journal_transaction` VALUES 
(2306900, '2023-06-28', 'FIX', 5, @period_id, NULL, NULL);
INSERT INTO `journal_entry` VALUES 
(2306901, 2306900, '333A', 900000000, NULL),
(2306902, 2306900, '334A', 900000000, NULL),
(2306903, 2306900, '341A', NULL, 1000000000),
(2306904, 2306900, '341B', NULL, 300000000),
(2306905, 2306900, '411A', NULL, 500000000);

COMMIT;