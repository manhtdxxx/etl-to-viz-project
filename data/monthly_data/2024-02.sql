START TRANSACTION;

-- Set variables for the month and year
SET @month = 2;
SET @year = 2024;
SET @period_id = 3; -- 2024
SET @trans_prefix = CONCAT(RIGHT(@year, 2), LPAD(@month, 2, '0'));
SET @entry_prefix = CONCAT(RIGHT(@year, 2), LPAD(@month, 2, '0'));


-- 5. Mua nguyên vật liệu, công cụ dụng cụ (Nợ TK 152, 153) bằng tiền và nợ người bán
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`) 
VALUES (CONCAT(@trans_prefix, '005'), CONCAT(@year, '-', @month, '-10'), 'Mua nguyên vật liệu, công cụ dụng cụ', 2, @period_id, 5);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(CONCAT(@entry_prefix, '013'), CONCAT(@trans_prefix, '005'), '152A', 180000000, NULL),
(CONCAT(@entry_prefix, '014'), CONCAT(@trans_prefix, '005'), '153A', 50000000, NULL),
(CONCAT(@entry_prefix, '015'), CONCAT(@trans_prefix, '005'), '133A', 23000000, NULL),
(CONCAT(@entry_prefix, '016'), CONCAT(@trans_prefix, '005'), '111A', NULL, 100000000),
(CONCAT(@entry_prefix, '017'), CONCAT(@trans_prefix, '005'), '331A', NULL, 153000000);

-- 6. Xuất kho nguyên vật liệu, công cụ dụng cụ (Có TK 152, 153)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (CONCAT(@trans_prefix, '006'), CONCAT(@year, '-', @month, '-12'), 'Xuất kho nguyên vật liệu, công cụ dụng cụ', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(CONCAT(@entry_prefix, '018'), CONCAT(@trans_prefix, '006'), 'A621', 153000000, NULL), -- 85% của 180tr
(CONCAT(@entry_prefix, '019'), CONCAT(@trans_prefix, '006'), 'A627', 42500000, NULL), -- 85% của 50tr
(CONCAT(@entry_prefix, '020'), CONCAT(@trans_prefix, '006'), '152A', NULL, 153000000),
(CONCAT(@entry_prefix, '021'), CONCAT(@trans_prefix, '006'), '153A', NULL, 42500000);

-- 7. Trích khấu hao TSCĐ (Có TK 214)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (CONCAT(@trans_prefix, '007'), CONCAT(@year, '-', @month, '-15'), 'Trích khấu hao TSCĐ', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(CONCAT(@entry_prefix, '022'), CONCAT(@trans_prefix, '007'), 'A627', 87500000, NULL), -- 2.5% của 3.5 tỷ
(CONCAT(@entry_prefix, '023'), CONCAT(@trans_prefix, '007'), '214B', NULL, 87500000);

-- 8. Trả lương nhân viên (Có TK 334) ghi nhận chi phí sản xuất (Nợ TK 622)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (CONCAT(@trans_prefix, '008'), CONCAT(@year, '-', @month, '-15'), 'Trả lương nhân viên', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(CONCAT(@entry_prefix, '024'), CONCAT(@trans_prefix, '008'), 'A622', 175000000, NULL), -- 2x khấu hao
(CONCAT(@entry_prefix, '025'), CONCAT(@trans_prefix, '008'), '334A', NULL, 175000000);

-- 9. Nhập kho thành phẩm (Nợ TK 154 từ TK 621, 622, 627)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (CONCAT(@trans_prefix, '009'), CONCAT(@year, '-', @month, '-20'), 'Nhập kho thành phẩm', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(CONCAT(@entry_prefix, '026'), CONCAT(@trans_prefix, '009'), '154A', 370500000, NULL), -- 153 + 175 + 42.5
(CONCAT(@entry_prefix, '027'), CONCAT(@trans_prefix, '009'), 'A621', NULL, 153000000),
(CONCAT(@entry_prefix, '028'), CONCAT(@trans_prefix, '009'), 'A622', NULL, 175000000),
(CONCAT(@entry_prefix, '029'), CONCAT(@trans_prefix, '009'), 'A627', NULL, 42500000);

-- 10. Kết chuyển thành phẩm (Có TK 154 sang Nợ TK 155)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (CONCAT(@trans_prefix, '010'), CONCAT(@year, '-', @month, '-20'), 'Kết chuyển thành phẩm', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(CONCAT(@entry_prefix, '030'), CONCAT(@trans_prefix, '010'), '155A', 370500000, NULL),
(CONCAT(@entry_prefix, '031'), CONCAT(@trans_prefix, '010'), '154A', NULL, 370500000);

-- 11. Bán hàng ghi nhận giá vốn (Có TK 155 và Nợ TK 632)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `customer_id`) 
VALUES (CONCAT(@trans_prefix, '011'), CONCAT(@year, '-', @month, '-22'), 'Bán hàng ghi nhận giá vốn', 1, @period_id, 8);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(CONCAT(@entry_prefix, '032'), CONCAT(@trans_prefix, '011'), 'A632', 314925000, NULL), -- 85% của 370.5tr
(CONCAT(@entry_prefix, '033'), CONCAT(@trans_prefix, '011'), '155A', NULL, 314925000);

-- 12. Bán hàng ghi nhận doanh thu (Có TK 511), giảm trừ doanh thu (Nợ TK 521)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `customer_id`) 
VALUES (CONCAT(@trans_prefix, '012'), CONCAT(@year, '-', @month, '-22'), 'Bán hàng ghi nhận doanh thu', 1, @period_id, 8);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(CONCAT(@entry_prefix, '034'), CONCAT(@trans_prefix, '012'), '131A', 756000000, NULL), -- 2.4x giá vốn (314.925 * 2.4)
(CONCAT(@entry_prefix, '035'), CONCAT(@trans_prefix, '012'), 'A521', 36000000, NULL), -- Giảm trừ 36tr
(CONCAT(@entry_prefix, '036'), CONCAT(@trans_prefix, '012'), '333A', NULL, 72000000), -- Thuế GTGT 10%
(CONCAT(@entry_prefix, '037'), CONCAT(@trans_prefix, '012'), 'A511', NULL, 720000000); -- Doanh thu trước thuế

-- 13. Ghi nhận chi phí bán hàng, chi phí quản lý doanh nghiệp
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (CONCAT(@trans_prefix, '013'), CONCAT(@year, '-', @month, '-25'), 'Ghi nhận chi phí bán hàng và QLDN', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(CONCAT(@entry_prefix, '038'), CONCAT(@trans_prefix, '013'), 'A641', 93600000, NULL), -- 13% doanh thu
(CONCAT(@entry_prefix, '039'), CONCAT(@trans_prefix, '013'), 'A642', 108000000, NULL), -- 15% doanh thu
(CONCAT(@entry_prefix, '040'), CONCAT(@trans_prefix, '013'), '334A', NULL, 201600000); -- Chi phí lương

-- 14. Mua chứng khoán (Nợ TK 121A bằng tiền)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (CONCAT(@trans_prefix, '014'), CONCAT(@year, '-', @month, '-18'), 'Mua chứng khoán', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(CONCAT(@entry_prefix, '041'), CONCAT(@trans_prefix, '014'), '121A', 200000000, NULL),
(CONCAT(@entry_prefix, '042'), CONCAT(@trans_prefix, '014'), '112A', NULL, 200000000);

-- 15. Bán chứng khoán (Có TK 121A nhận tiền, lãi)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (CONCAT(@trans_prefix, '015'), CONCAT(@year, '-', @month, '-20'), 'Bán chứng khoán', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(CONCAT(@entry_prefix, '043'), CONCAT(@trans_prefix, '015'), '112A', 220000000, NULL),
(CONCAT(@entry_prefix, '044'), CONCAT(@trans_prefix, '015'), '121A', NULL, 200000000),
(CONCAT(@entry_prefix, '045'), CONCAT(@trans_prefix, '015'), 'B515', NULL, 20000000); -- Lãi 20tr

-- 16. Trả lãi vay ngân hàng (Nợ TK 635)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (CONCAT(@trans_prefix, '016'), CONCAT(@year, '-', @month, '-25'), 'Trả lãi vay ngân hàng', 9, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(CONCAT(@entry_prefix, '046'), CONCAT(@trans_prefix, '016'), 'B635', 56000000, NULL), -- 7% tổng nợ vay (800tr)
(CONCAT(@entry_prefix, '047'), CONCAT(@trans_prefix, '016'), '112A', NULL, 56000000);

-- 17. Nhận lãi từ đầu tư chứng khoán (Có TK 515)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (CONCAT(@trans_prefix, '017'), CONCAT(@year, '-', @month, '-26'), 'Nhận lãi từ đầu tư chứng khoán', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(CONCAT(@entry_prefix, '048'), CONCAT(@trans_prefix, '017'), '112A', 60000000, NULL),
(CONCAT(@entry_prefix, '049'), CONCAT(@trans_prefix, '017'), 'B515', NULL, 60000000);

-- 18. Chi phí khác (Nợ TK 811)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (CONCAT(@trans_prefix, '018'), CONCAT(@year, '-', @month, '-27'), 'Chi phí khác', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(CONCAT(@entry_prefix, '050'), CONCAT(@trans_prefix, '018'), 'C811', 35000000, NULL),
(CONCAT(@entry_prefix, '051'), CONCAT(@trans_prefix, '018'), '111A', NULL, 35000000);

-- 19. Thu nhập khác (Có TK 711)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (CONCAT(@trans_prefix, '019'), CONCAT(@year, '-', @month, '-28'), 'Thu nhập khác', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(CONCAT(@entry_prefix, '052'), CONCAT(@trans_prefix, '019'), '112A', 40000000, NULL),
(CONCAT(@entry_prefix, '053'), CONCAT(@trans_prefix, '019'), 'C711', NULL, 40000000);

-- 20. Kết chuyển chi phí vào TK 911
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (CONCAT(@trans_prefix, '020'), CONCAT(@year, '-', @month, '-28'), 'Kết chuyển chi phí', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(CONCAT(@entry_prefix, '054'), CONCAT(@trans_prefix, '020'), 'D911', 314925000, NULL), -- Giá vốn
(CONCAT(@entry_prefix, '055'), CONCAT(@trans_prefix, '020'), 'A632', NULL, 314925000),
(CONCAT(@entry_prefix, '056'), CONCAT(@trans_prefix, '020'), 'D911', 93600000, NULL), -- Chi phí bán hàng
(CONCAT(@entry_prefix, '057'), CONCAT(@trans_prefix, '020'), 'A641', NULL, 93600000),
(CONCAT(@entry_prefix, '058'), CONCAT(@trans_prefix, '020'), 'D911', 108000000, NULL), -- Chi phí QLDN
(CONCAT(@entry_prefix, '059'), CONCAT(@trans_prefix, '020'), 'A642', NULL, 108000000),
(CONCAT(@entry_prefix, '060'), CONCAT(@trans_prefix, '020'), 'D911', 56000000, NULL), -- Chi phí tài chính
(CONCAT(@entry_prefix, '061'), CONCAT(@trans_prefix, '020'), 'B635', NULL, 56000000),
(CONCAT(@entry_prefix, '062'), CONCAT(@trans_prefix, '020'), 'D911', 35000000, NULL), -- Chi phí khác
(CONCAT(@entry_prefix, '063'), CONCAT(@trans_prefix, '020'), 'C811', NULL, 35000000),
(CONCAT(@entry_prefix, '064'), CONCAT(@trans_prefix, '020'), 'D911', 36000000, NULL), -- Giảm trừ doanh thu
(CONCAT(@entry_prefix, '065'), CONCAT(@trans_prefix, '020'), 'A521', NULL, 36000000);

-- 21. Kết chuyển doanh thu vào TK 911
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (CONCAT(@trans_prefix, '021'), CONCAT(@year, '-', @month, '-28'), 'Kết chuyển doanh thu', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(CONCAT(@entry_prefix, '066'), CONCAT(@trans_prefix, '021'), 'A511', 720000000, NULL),
(CONCAT(@entry_prefix, '067'), CONCAT(@trans_prefix, '021'), 'D911', NULL, 720000000),
(CONCAT(@entry_prefix, '068'), CONCAT(@trans_prefix, '021'), 'B515', 80000000, NULL), -- 20tr + 60tr
(CONCAT(@entry_prefix, '069'), CONCAT(@trans_prefix, '021'), 'D911', NULL, 80000000),
(CONCAT(@entry_prefix, '070'), CONCAT(@trans_prefix, '021'), 'C711', 40000000, NULL),
(CONCAT(@entry_prefix, '071'), CONCAT(@trans_prefix, '021'), 'D911', NULL, 40000000);

-- 22. Tính thuế TNDN (20% lợi nhuận trước thuế)
-- Lợi nhuận trước thuế = (720 + 80 + 40) - (314.925 + 93.6 + 108 + 56 + 35 + 36) = 840 - 643.525 = 196.475
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (CONCAT(@trans_prefix, '022'), CONCAT(@year, '-', @month, '-28'), 'Tính thuế TNDN', 8, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(CONCAT(@entry_prefix, '072'), CONCAT(@trans_prefix, '022'), 'C821', 39295000, NULL), -- 20% của 196.475
(CONCAT(@entry_prefix, '073'), CONCAT(@trans_prefix, '022'), '333A', NULL, 39295000);

-- 23. Kết chuyển thuế TNDN vào TK 911
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (CONCAT(@trans_prefix, '023'), CONCAT(@year, '-', @month, '-28'), 'Kết chuyển thuế TNDN', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(CONCAT(@entry_prefix, '074'), CONCAT(@trans_prefix, '023'), 'D911', 39295000, NULL),
(CONCAT(@entry_prefix, '075'), CONCAT(@trans_prefix, '023'), 'C821', NULL, 39295000);

-- 24. Kết chuyển lợi nhuận sau thuế vào TK 421
-- Lợi nhuận sau thuế = 196.475 - 39.295 = 157.180
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (CONCAT(@trans_prefix, '024'), CONCAT(@year, '-', @month, '-28'), 'Kết chuyển lợi nhuận sau thuế', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(CONCAT(@entry_prefix, '076'), CONCAT(@trans_prefix, '024'), 'D911', 157180000, NULL),
(CONCAT(@entry_prefix, '077'), CONCAT(@trans_prefix, '024'), '421B', NULL, 157180000);

-- 25. Chi trả cổ tức (15% lợi nhuận sau thuế)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (CONCAT(@trans_prefix, '025'), CONCAT(@year, '-', @month, '-28'), 'Chi trả cổ tức', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(CONCAT(@entry_prefix, '078'), CONCAT(@trans_prefix, '025'), '421B', 23577000, NULL), -- 15% của 157.180
(CONCAT(@entry_prefix, '079'), CONCAT(@trans_prefix, '025'), '111A', NULL, 23577000);

-- 26. Thu tiền khách hàng (85% khoản phải thu)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `customer_id`) 
VALUES (CONCAT(@trans_prefix, '026'), CONCAT(@year, '-', @month, '-28'), 'Thu tiền khách hàng', 6, @period_id, 8);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(CONCAT(@entry_prefix, '080'), CONCAT(@trans_prefix, '026'), '112A', 642600000, NULL), -- 85% của 756tr
(CONCAT(@entry_prefix, '081'), CONCAT(@trans_prefix, '026'), '131A', NULL, 642600000);

-- 27. Trả tiền người bán (75% khoản phải trả)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `supplier_id`) 
VALUES (CONCAT(@trans_prefix, '027'), CONCAT(@year, '-', @month, '-28'), 'Trả tiền người bán', 7, @period_id, 5);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(CONCAT(@entry_prefix, '082'), CONCAT(@trans_prefix, '027'), '331A', 114750000, NULL), -- 75% của 153tr
(CONCAT(@entry_prefix, '083'), CONCAT(@trans_prefix, '027'), '112A', NULL, 114750000);

-- 28. Trả thuế TNDN (90% khoản thuế)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (CONCAT(@trans_prefix, '028'), CONCAT(@year, '-', @month, '-28'), 'Trả thuế TNDN', 8, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(CONCAT(@entry_prefix, '084'), CONCAT(@trans_prefix, '028'), '333A', 35365500, NULL), -- 90% của 39.295
(CONCAT(@entry_prefix, '085'), CONCAT(@trans_prefix, '028'), '112A', NULL, 35365500);

-- 29. Trả lương nhân viên (85% khoản trả lương)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (CONCAT(@trans_prefix, '029'), CONCAT(@year, '-', @month, '-28'), 'Trả lương nhân viên', 5, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(CONCAT(@entry_prefix, '086'), CONCAT(@trans_prefix, '029'), '334A', 171360000, NULL), -- 85% của 201.6tr
(CONCAT(@entry_prefix, '087'), CONCAT(@trans_prefix, '029'), '111A', NULL, 171360000);

-- 30. Trả nợ gốc vay ngắn hạn (12% nợ vay ngắn hạn)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (CONCAT(@trans_prefix, '030'), CONCAT(@year, '-', @month, '-28'), 'Trả nợ gốc vay ngắn hạn', 9, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(CONCAT(@entry_prefix, '088'), CONCAT(@trans_prefix, '030'), '341A', 72000000, NULL), -- 12% của 600tr
(CONCAT(@entry_prefix, '089'), CONCAT(@trans_prefix, '030'), '112A', NULL, 72000000);

-- 31. Trả nợ gốc vay dài hạn (6% nợ vay dài hạn)
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`) 
VALUES (CONCAT(@trans_prefix, '031'), CONCAT(@year, '-', @month, '-28'), 'Trả nợ gốc vay dài hạn', 9, @period_id);

INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES 
(CONCAT(@entry_prefix, '090'), CONCAT(@trans_prefix, '031'), '341B', 18000000, NULL), -- 6% của 300tr
(CONCAT(@entry_prefix, '091'), CONCAT(@trans_prefix, '031'), '112A', NULL, 18000000);


-- FIX
INSERT INTO `journal_transaction` (`trans_id`, `trans_date`, `description`, `journal_id`, `period_id`, `customer_id`, `supplier_id`) 
VALUES (2402900, '2024-02-28', 'FIX', 5, @period_id, NULL, NULL);
INSERT INTO `journal_entry` (`entry_id`, `trans_id`, `acc_id`, `debit_amount`, `credit_amount`) 
VALUES (2402900, 2402900, '211B', 87500000, NULL);


COMMIT;