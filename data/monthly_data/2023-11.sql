START TRANSACTION;

-- Set period_id to 2 for year 2023
SET @period_id = 2;

-- Set transaction and entry IDs starting from 2311000
SET @trans_id = 2311000;
SET @entry_id = 2311000;


-- 5. Purchase of materials (with VAT) - paid by cash
INSERT INTO `journal_transaction` VALUES (@trans_id, '2023-11-03', 'Mua nguyên vật liệu trả bằng tiền mặt', 2, @period_id, 3, NULL);
INSERT INTO `journal_entry` VALUES 
(@entry_id, @trans_id, '152A', 150000000, NULL),
(@entry_id+1, @trans_id, '133A', 15000000, NULL),
(@entry_id+2, @trans_id, '111A', NULL, 165000000);
SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 3;

-- 6. Purchase of tools (with VAT) - on credit (short-term)
INSERT INTO `journal_transaction` VALUES (@trans_id, '2023-11-04', 'Mua công cụ dụng cụ trả chậm', 2, @period_id, 8, NULL);
INSERT INTO `journal_entry` VALUES 
(@entry_id, @trans_id, '153A', 80000000, NULL),
(@entry_id+1, @trans_id, '133A', 8000000, NULL),
(@entry_id+2, @trans_id, '331A', NULL, 88000000);
SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 3;

-- 7. Issue materials to production (90% of purchased materials)
INSERT INTO `journal_transaction` VALUES (@trans_id, '2023-11-05', 'Xuất kho nguyên vật liệu sản xuất', 5, @period_id, NULL, NULL);
INSERT INTO `journal_entry` VALUES 
(@entry_id, @trans_id, 'A621', 135000000, NULL),
(@entry_id+1, @trans_id, '152A', NULL, 135000000);
SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 2;

-- 8. Issue tools to production (85% of purchased tools)
INSERT INTO `journal_transaction` VALUES (@trans_id, '2023-11-05', 'Xuất kho công cụ dụng cụ sản xuất', 5, @period_id, NULL, NULL);
INSERT INTO `journal_entry` VALUES 
(@entry_id, @trans_id, 'A627', 68000000, NULL),
(@entry_id+1, @trans_id, '153A', NULL, 68000000);
SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 2;

-- 9. Depreciation of fixed assets (3% of 2,500 million)
INSERT INTO `journal_transaction` VALUES (@trans_id, '2023-11-06', 'Trích khấu hao TSCĐ', 5, @period_id, NULL, NULL);
INSERT INTO `journal_entry` VALUES 
(@entry_id, @trans_id, 'A627', 75000000, NULL),
(@entry_id+1, @trans_id, '214B', NULL, 75000000 -20000000); -- FIX
SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 2;

-- 10. Payroll expenses (2x depreciation)
INSERT INTO `journal_transaction` VALUES (@trans_id, '2023-11-07', 'Trả lương nhân viên sản xuất', 5, @period_id, NULL, NULL);
INSERT INTO `journal_entry` VALUES 
(@entry_id, @trans_id, 'A622', 150000000, NULL),
(@entry_id+1, @trans_id, '334A', NULL, 150000000);
SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 2;

-- 11. Transfer production costs to WIP
INSERT INTO `journal_transaction` VALUES (@trans_id, '2023-11-10', 'Kết chuyển chi phí sản xuất', 5, @period_id, NULL, NULL);
INSERT INTO `journal_entry` VALUES 
(@entry_id, @trans_id, '154A', 428000000, NULL),
(@entry_id+1, @trans_id, 'A621', NULL, 135000000),
(@entry_id+2, @trans_id, 'A622', NULL, 150000000),
(@entry_id+3, @trans_id, 'A627', NULL, 143000000);
SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 4;

-- 12. Transfer WIP to finished goods
INSERT INTO `journal_transaction` VALUES (@trans_id, '2023-11-11', 'Nhập kho thành phẩm', 5, @period_id, NULL, NULL);
INSERT INTO `journal_entry` VALUES 
(@entry_id, @trans_id, '155A', 428000000, NULL),
(@entry_id+1, @trans_id, '154A', NULL, 428000000);
SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 2;

-- 13. Record cost of goods sold (90% of finished goods)
INSERT INTO `journal_transaction` VALUES (@trans_id, '2023-11-15', 'Xuất kho thành phẩm bán', 1, @period_id, NULL, 4);
INSERT INTO `journal_entry` VALUES 
(@entry_id, @trans_id, 'A632', 385200000, NULL),
(@entry_id+1, @trans_id, '155A', NULL, 385200000);
SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 2;

-- 14. Record sales revenue (2.2x COGS)
INSERT INTO `journal_transaction` VALUES (@trans_id, '2023-11-15', 'Bán hàng thu tiền ngay', 1, @period_id, NULL, 4);
INSERT INTO `journal_entry` VALUES 
(@entry_id, @trans_id, '112A', 847440000, NULL),
(@entry_id+1, @trans_id, 'A511', NULL, 770000000),
(@entry_id+2, @trans_id, '333A', NULL, 77440000);
SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 3;

-- 15. Sales returns (2% of revenue)
INSERT INTO `journal_transaction` VALUES (@trans_id, '2023-11-16', 'Hàng bán bị trả lại', 1, @period_id, NULL, 4);
INSERT INTO `journal_entry` VALUES 
(@entry_id, @trans_id, 'A521', 15400000, NULL),
(@entry_id+1, @trans_id, '112A', NULL, 15400000);
SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 2;

-- 16. Record selling expenses (15% of revenue)
INSERT INTO `journal_transaction` VALUES (@trans_id, '2023-11-17', 'Chi phí bán hàng', 5, @period_id, NULL, NULL);
INSERT INTO `journal_entry` VALUES 
(@entry_id, @trans_id, 'A641', 113190000, NULL),
(@entry_id+1, @trans_id, '334A', NULL, 113190000);
SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 2;

-- 17. Record administrative expenses (15% of revenue)
INSERT INTO `journal_transaction` VALUES (@trans_id, '2023-11-18', 'Chi phí quản lý doanh nghiệp', 5, @period_id, NULL, NULL);
INSERT INTO `journal_entry` VALUES 
(@entry_id, @trans_id, 'A642', 113190000, NULL),
(@entry_id+1, @trans_id, '334A', NULL, 113190000);
SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 2;

-- 18. Purchase securities (short-term)
INSERT INTO `journal_transaction` VALUES (@trans_id, '2023-11-20', 'Mua chứng khoán ngắn hạn', 5, @period_id, NULL, NULL);
INSERT INTO `journal_entry` VALUES 
(@entry_id, @trans_id, '121A', 200000000, NULL),
(@entry_id+1, @trans_id, '112A', NULL, 200000000);
SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 2;

-- 19. Sell securities (80% of purchased, with profit)
INSERT INTO `journal_transaction` VALUES (@trans_id, '2023-11-21', 'Bán chứng khoán ngắn hạn', 5, @period_id, NULL, NULL);
INSERT INTO `journal_entry` VALUES 
(@entry_id, @trans_id, '112A', 180000000, NULL),
(@entry_id+1, @trans_id, '121A', NULL, 160000000),
(@entry_id+2, @trans_id, 'B515', NULL, 20000000);
SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 3;

-- 20. Pay bank loan interest (8% of total loans)
INSERT INTO `journal_transaction` VALUES (@trans_id, '2023-11-22', 'Trả lãi vay ngân hàng', 9, @period_id, NULL, NULL);
INSERT INTO `journal_entry` VALUES 
(@entry_id, @trans_id, 'B635', 120000000, NULL),
(@entry_id+1, @trans_id, '112A', NULL, 120000000);
SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 2;

-- 21. Receive investment income
INSERT INTO `journal_transaction` VALUES (@trans_id, '2023-11-23', 'Nhận lãi đầu tư', 5, @period_id, NULL, NULL);
INSERT INTO `journal_entry` VALUES 
(@entry_id, @trans_id, '112A', 130000000, NULL),
(@entry_id+1, @trans_id, 'B515', NULL, 130000000);
SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 2;

-- 22. Other expenses (penalty)
INSERT INTO `journal_transaction` VALUES (@trans_id, '2023-11-24', 'Phạt vi phạm hợp đồng', 5, @period_id, NULL, NULL);
INSERT INTO `journal_entry` VALUES 
(@entry_id, @trans_id, 'C811', 10000000, NULL),
(@entry_id+1, @trans_id, '111A', NULL, 10000000);
SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 2;

-- 23. Other income (sell fixed asset - 1.5% of total)
INSERT INTO `journal_transaction` VALUES (@trans_id, '2023-11-25', 'Bán TSCĐ', 5, @period_id, NULL, NULL);
INSERT INTO `journal_entry` VALUES 
(@entry_id, @trans_id, '112A', 37500000, NULL),
(@entry_id+1, @trans_id, '211B', NULL, 25000000),
(@entry_id+2, @trans_id, '214B', NULL, 10000000),
(@entry_id+3, @trans_id, 'C711', NULL, 22500000);
SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 4;

-- 24. Close revenue and expense accounts at month-end
-- Transfer all expenses to 911
INSERT INTO `journal_transaction` VALUES (@trans_id, '2023-11-30', 'Kết chuyển chi phí', 5, @period_id, NULL, NULL);
INSERT INTO `journal_entry` VALUES 
(@entry_id, @trans_id, 'D911', 385200000, NULL), -- COGS
(@entry_id+1, @trans_id, 'A632', NULL, 385200000),
(@entry_id+2, @trans_id, 'D911', 113190000, NULL), -- Selling expense
(@entry_id+3, @trans_id, 'A641', NULL, 113190000),
(@entry_id+4, @trans_id, 'D911', 113190000, NULL), -- Admin expense
(@entry_id+5, @trans_id, 'A642', NULL, 113190000),
(@entry_id+6, @trans_id, 'D911', 120000000, NULL), -- Financial expense
(@entry_id+7, @trans_id, 'B635', NULL, 120000000),
(@entry_id+8, @trans_id, 'D911', 10000000, NULL), -- Other expense
(@entry_id+9, @trans_id, 'C811', NULL, 10000000),
(@entry_id+10, @trans_id, 'D911', 15400000, NULL), -- Sales returns
(@entry_id+11, @trans_id, 'A521', NULL, 15400000);
SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 12;

-- Transfer all revenues to 911
INSERT INTO `journal_transaction` VALUES (@trans_id, '2023-11-30', 'Kết chuyển doanh thu', 5, @period_id, NULL, NULL);
INSERT INTO `journal_entry` VALUES 
(@entry_id, @trans_id, 'A511', 770000000, NULL),
(@entry_id+1, @trans_id, 'D911', NULL, 770000000),
(@entry_id+2, @trans_id, 'B515', 150000000, NULL),
(@entry_id+3, @trans_id, 'D911', NULL, 150000000),
(@entry_id+4, @trans_id, 'C711', 22500000, NULL),
(@entry_id+5, @trans_id, 'D911', NULL, 22500000);
SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 6;

-- Calculate and record income tax (20% of profit)
-- Profit before tax = (770,000,000 + 150,000,000 + 22,500,000) - (385,200,000 + 113,190,000 + 113,190,000 + 120,000,000 + 10,000,000 + 15,400,000) = 942,500,000 - 756,980,000 = 185,520,000
-- Tax = 185,520,000 * 20% = 37,104,000
INSERT INTO `journal_transaction` VALUES (@trans_id, '2023-11-30', 'Hạch toán thuế TNDN', 8, @period_id, NULL, NULL);
INSERT INTO `journal_entry` VALUES 
(@entry_id, @trans_id, 'C821', 37104000, NULL),
(@entry_id+1, @trans_id, '333A', NULL, 37104000);
SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 2;

-- Transfer tax expense to 911
INSERT INTO `journal_transaction` VALUES (@trans_id, '2023-11-30', 'Kết chuyển thuế TNDN', 5, @period_id, NULL, NULL);
INSERT INTO `journal_entry` VALUES 
(@entry_id, @trans_id, 'D911', 37104000, NULL),
(@entry_id+1, @trans_id, 'C821', NULL, 37104000);
SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 2;

-- Transfer net profit to retained earnings (185,520,000 - 37,104,000 = 148,416,000)
INSERT INTO `journal_transaction` VALUES (@trans_id, '2023-11-30', 'Kết chuyển lợi nhuận', 5, @period_id, NULL, NULL);
INSERT INTO `journal_entry` VALUES 
(@entry_id, @trans_id, 'D911', 148416000, NULL),
(@entry_id+1, @trans_id, '421B', NULL, 148416000);
SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 2;

-- 25. Pay dividends (15% of net profit)
INSERT INTO `journal_transaction` VALUES (@trans_id, '2023-11-30', 'Chi trả cổ tức', 4, @period_id, NULL, NULL);
INSERT INTO `journal_entry` VALUES 
(@entry_id, @trans_id, '421B', 22262400, NULL),
(@entry_id+1, @trans_id, '112A', NULL, 22262400);
SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 2;

-- 26. Collect from customers (80% of receivables)
INSERT INTO `journal_transaction` VALUES (@trans_id, '2023-11-30', 'Thu tiền khách hàng', 3, @period_id, NULL, 4);
INSERT INTO `journal_entry` VALUES 
(@entry_id, @trans_id, '112A', 616000000, NULL),
(@entry_id+1, @trans_id, '131A', NULL, 616000000);
SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 2;

-- 27. Pay suppliers (75% of payables)
INSERT INTO `journal_transaction` VALUES (@trans_id, '2023-11-30', 'Trả tiền nhà cung cấp', 4, @period_id, 8, NULL);
INSERT INTO `journal_entry` VALUES 
(@entry_id, @trans_id, '331A', 66000000, NULL),
(@entry_id+1, @trans_id, '112A', NULL, 66000000);
SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 2;

-- 28. Pay taxes (90% of tax payable)
INSERT INTO `journal_transaction` VALUES (@trans_id, '2023-11-30', 'Nộp thuế TNDN', 4, @period_id, NULL, NULL);
INSERT INTO `journal_entry` VALUES 
(@entry_id, @trans_id, '333A', 33393600, NULL),
(@entry_id+1, @trans_id, '112A', NULL, 33393600);
SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 2;

-- 29. Pay salaries (85% of salary payable)
INSERT INTO `journal_transaction` VALUES (@trans_id, '2023-11-30', 'Trả lương nhân viên', 4, @period_id, NULL, NULL);
INSERT INTO `journal_entry` VALUES 
(@entry_id, @trans_id, '334A', 192421500, NULL),
(@entry_id+1, @trans_id, '111A', NULL, 192421500);
SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 2;

-- 30. Repay short-term loan principal (10% of short-term loan)
INSERT INTO `journal_transaction` VALUES (@trans_id, '2023-11-30', 'Trả nợ gốc vay ngắn hạn', 4, @period_id, NULL, NULL);
INSERT INTO `journal_entry` VALUES 
(@entry_id, @trans_id, '341A', 90000000, NULL),
(@entry_id+1, @trans_id, '112A', NULL, 90000000);
SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 2;

-- 31. Repay long-term loan principal (5% of long-term loan)
INSERT INTO `journal_transaction` VALUES (@trans_id, '2023-11-30', 'Trả nợ gốc vay dài hạn', 4, @period_id, NULL, NULL);
INSERT INTO `journal_entry` VALUES 
(@entry_id, @trans_id, '341B', 55000000, NULL),
(@entry_id+1, @trans_id, '112A', NULL, 55000000);
SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 2;

COMMIT;