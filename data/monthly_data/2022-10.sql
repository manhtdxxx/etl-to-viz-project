START TRANSACTION;

-- Set period_id for 2022 (1)
SET @period_id = 1;

-- Set transaction and entry IDs starting from 2210000 (yy=22, mm=10)
SET @trans_id = 2210000;
SET @entry_id = 2210000;

-- 1. Capital mobilization and fixed asset investment (only in month 1)
-- Note: Since this is October, we'll skip these as they should only be in January

-- 2. Business operations
-- 2.1 Purchasing activities
-- Purchase materials on credit (including VAT)
INSERT INTO journal_transaction VALUES 
(@trans_id, '2022-10-05', 'Mua nguyên vật liệu từ nhà cung cấp A', 2, @period_id, 5, NULL);
INSERT INTO journal_entry VALUES 
(@entry_id, @trans_id, '152A', 200000000, NULL),
(@entry_id+1, @trans_id, '133A', 20000000, NULL),
(@entry_id+2, @trans_id, '331A', NULL, 220000000);
SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 3;

-- Purchase tools with cash (including VAT)
INSERT INTO journal_transaction VALUES 
(@trans_id, '2022-10-06', 'Mua công cụ dụng cụ bằng tiền mặt', 2, @period_id, 8, NULL);
INSERT INTO journal_entry VALUES 
(@entry_id, @trans_id, '153A', 50000000, NULL),
(@entry_id+1, @trans_id, '133A', 5000000, NULL),
(@entry_id+2, @trans_id, '111A', NULL, 55000000);
SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 3;

-- 2.2 Production activities
-- Issue materials to production (80% of purchased materials)
INSERT INTO journal_transaction VALUES 
(@trans_id, '2022-10-10', 'Xuất kho nguyên vật liệu cho sản xuất', 5, @period_id, NULL, NULL);
INSERT INTO journal_entry VALUES 
(@entry_id, @trans_id, 'A621', 160000000, NULL),
(@entry_id+1, @trans_id, '152A', NULL, 160000000);
SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 2;

-- Issue tools to production (90% of purchased tools)
INSERT INTO journal_transaction VALUES 
(@trans_id, '2022-10-11', 'Xuất kho công cụ dụng cụ cho sản xuất', 5, @period_id, NULL, NULL);
INSERT INTO journal_entry VALUES 
(@entry_id, @trans_id, 'A627', 45000000, NULL),
(@entry_id+1, @trans_id, '153A', NULL, 45000000);
SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 2;

-- Depreciation of fixed assets (3% of 1,500,000,000)
INSERT INTO journal_transaction VALUES 
(@trans_id, '2022-10-15', 'Trích khấu hao TSCĐ tháng 10/2022', 5, @period_id, NULL, NULL);
INSERT INTO journal_entry VALUES 
(@entry_id, @trans_id, 'A627', 45000000, NULL),
(@entry_id+1, @trans_id, '214B', NULL, 45000000);
SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 2;

-- Payroll expenses (2x depreciation)
INSERT INTO journal_transaction VALUES 
(@trans_id, '2022-10-20', 'Tính lương nhân viên sản xuất tháng 10/2022', 5, @period_id, NULL, NULL);
INSERT INTO journal_entry VALUES 
(@entry_id, @trans_id, 'A622', 90000000, NULL),
(@entry_id+1, @trans_id, '334A', NULL, 90000000);
SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 2;

-- 2.3 Finished goods inventory
-- Transfer production costs to WIP (154)
INSERT INTO journal_transaction VALUES 
(@trans_id, '2022-10-25', 'Kết chuyển chi phí sản xuất vào CPSXDD', 5, @period_id, NULL, NULL);
INSERT INTO journal_entry VALUES 
(@entry_id, @trans_id, '154A', 340000000, NULL), -- 160 + 45 + 45 + 90
(@entry_id+1, @trans_id, 'A621', NULL, 160000000),
(@entry_id+2, @trans_id, 'A622', NULL, 90000000),
(@entry_id+3, @trans_id, 'A627', NULL, 90000000);
SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 4;

-- Transfer WIP to finished goods (155)
INSERT INTO journal_transaction VALUES 
(@trans_id, '2022-10-26', 'Nhập kho thành phẩm từ CPSXDD', 5, @period_id, NULL, NULL);
INSERT INTO journal_entry VALUES 
(@entry_id, @trans_id, '155A', 340000000, NULL),
(@entry_id+1, @trans_id, '154A', NULL, 340000000);
SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 2;

-- 2.4 Sales activities - COGS (85% of finished goods)
INSERT INTO journal_transaction VALUES 
(@trans_id, '2022-10-27', 'Xuất kho thành phẩm bán cho khách hàng B', 1, @period_id, NULL, 3);
INSERT INTO journal_entry VALUES 
(@entry_id, @trans_id, 'A632', 289000000, NULL), -- 340 * 0.85
(@entry_id+1, @trans_id, '155A', NULL, 289000000);
SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 2;

-- 2.5 Sales activities - Revenue (2.2x COGS)
INSERT INTO journal_transaction VALUES 
(@trans_id, '2022-10-28', 'Bán hàng cho khách hàng B', 1, @period_id, NULL, 3);
INSERT INTO journal_entry VALUES 
(@entry_id, @trans_id, '131A', 635800000, NULL), -- 289 * 2.2 = 635.8
(@entry_id+1, @trans_id, 'A521', 20000000, NULL), -- Sales discount
(@entry_id+2, @trans_id, 'A511', NULL, 600000000), -- Revenue
(@entry_id+3, @trans_id, '333A', NULL, 55800000); -- VAT 10%
SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 4;

-- 2.6 Sales and administrative expenses (13% of revenue each)
INSERT INTO journal_transaction VALUES 
(@trans_id, '2022-10-29', 'Chi phí bán hàng và QLDN tháng 10/2022', 5, @period_id, NULL, NULL);
INSERT INTO journal_entry VALUES 
(@entry_id, @trans_id, 'A641', 78000000, NULL), -- 600 * 0.13
(@entry_id+1, @trans_id, 'A642', 78000000, NULL), -- 600 * 0.13
(@entry_id+2, @trans_id, '334A', NULL, 100000000), -- Salary
(@entry_id+3, @trans_id, '111A', NULL, 56000000); -- Other expenses
SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 4;

-- 3. Financial activities
-- 3.1 Purchase securities
INSERT INTO journal_transaction VALUES 
(@trans_id, '2022-10-05', 'Đầu tư chứng khoán ngắn hạn', 5, @period_id, NULL, NULL);
INSERT INTO journal_entry VALUES 
(@entry_id, @trans_id, '121A', 100000000, NULL),
(@entry_id+1, @trans_id, '112A', NULL, 100000000);
SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 2;

-- 3.2 Sell securities (less than purchase, with profit)
INSERT INTO journal_transaction VALUES 
(@trans_id, '2022-10-20', 'Bán chứng khoán ngắn hạn', 5, @period_id, NULL, NULL);
INSERT INTO journal_entry VALUES 
(@entry_id, @trans_id, '112A', 60000000, NULL),
(@entry_id+1, @trans_id, '121A', NULL, 50000000),
(@entry_id+2, @trans_id, 'B515', NULL, 10000000); -- Profit
SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 3;

-- 3.3 Pay loan interest (8% of total loans 1,200,000,000)
INSERT INTO journal_transaction VALUES 
(@trans_id, '2022-10-25', 'Trả lãi vay ngân hàng', 9, @period_id, NULL, NULL);
INSERT INTO journal_entry VALUES 
(@entry_id, @trans_id, 'B635', 96000000, NULL), -- 1,200 * 0.08
(@entry_id+1, @trans_id, '112A', NULL, 96000000);
SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 2;

-- 3.4 Receive investment income (higher than interest paid)
INSERT INTO journal_transaction VALUES 
(@trans_id, '2022-10-30', 'Nhận lãi đầu tư chứng khoán', 5, @period_id, NULL, NULL);
INSERT INTO journal_entry VALUES 
(@entry_id, @trans_id, '112A', 100000000, NULL),
(@entry_id+1, @trans_id, 'B515', NULL, 100000000);
SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 2;

-- 4. Other activities
-- 4.1 Other expenses
INSERT INTO journal_transaction VALUES 
(@trans_id, '2022-10-15', 'Phạt vi phạm hợp đồng', 5, @period_id, NULL, NULL);
INSERT INTO journal_entry VALUES 
(@entry_id, @trans_id, 'C811', 50000000, NULL),
(@entry_id+1, @trans_id, '111A', NULL, 50000000);
SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 2;

-- 4.2 Other income (from selling fixed assets - 2.5% of 1,500,000,000)
INSERT INTO journal_transaction VALUES 
(@trans_id, '2022-10-20', 'Bán TSCĐ không còn sử dụng', 5, @period_id, NULL, NULL);
INSERT INTO journal_entry VALUES 
(@entry_id, @trans_id, '112A', 37500000, NULL),
(@entry_id+1, @trans_id, '211B', NULL, 30000000),
(@entry_id+2, @trans_id, '214B', NULL, 5000000),
(@entry_id+3, @trans_id, 'C711', NULL, 12500000); -- Gain
SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 4;

-- 5. Month-end closing entries
-- 5.1 Transfer all expenses to 911
INSERT INTO journal_transaction VALUES 
(@trans_id, '2022-10-31', 'Kết chuyển chi phí tháng 10/2022', 5, @period_id, NULL, NULL);
INSERT INTO journal_entry VALUES 
(@entry_id, @trans_id, 'D911', 717000000, NULL), -- 289 + 20 + 78 + 78 + 96 + 50
(@entry_id+1, @trans_id, 'A632', NULL, 289000000),
(@entry_id+2, @trans_id, 'A521', NULL, 20000000),
(@entry_id+3, @trans_id, 'A641', NULL, 78000000),
(@entry_id+4, @trans_id, 'A642', NULL, 78000000),
(@entry_id+5, @trans_id, 'B635', NULL, 96000000),
(@entry_id+6, @trans_id, 'C811', NULL, 50000000);
SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 7;

-- 5.2 Transfer all revenues to 911
INSERT INTO journal_transaction VALUES 
(@trans_id, '2022-10-31', 'Kết chuyển doanh thu tháng 10/2022', 5, @period_id, NULL, NULL);
INSERT INTO journal_entry VALUES 
(@entry_id, @trans_id, 'A511', 600000000, NULL),
(@entry_id+1, @trans_id, 'B515', 110000000, NULL), -- 10 + 100
(@entry_id+2, @trans_id, 'C711', 12500000, NULL),
(@entry_id+3, @trans_id, 'D911', NULL, 722500000);
SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 4;

-- 5.3 Calculate and record income tax (20% of profit before tax)
-- Profit before tax = 722,500,000 - 717,000,000 = 5,500,000
INSERT INTO journal_transaction VALUES 
(@trans_id, '2022-10-31', 'Tính thuế TNDN tháng 10/2022', 5, @period_id, NULL, NULL);
INSERT INTO journal_entry VALUES 
(@entry_id, @trans_id, 'C821', 1100000, NULL), -- 5,500,000 * 20%
(@entry_id+1, @trans_id, '333A', NULL, 1100000);
SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 2;

-- 5.4 Transfer income tax to 911
INSERT INTO journal_transaction VALUES 
(@trans_id, '2022-10-31', 'Kết chuyển thuế TNDN', 5, @period_id, NULL, NULL);
INSERT INTO journal_entry VALUES 
(@entry_id, @trans_id, 'D911', 1100000, NULL),
(@entry_id+1, @trans_id, 'C821', NULL, 1100000);
SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 2;

-- 5.5 Transfer net profit to retained earnings
-- Net profit = 5,500,000 - 1,100,000 = 4,400,000
INSERT INTO journal_transaction VALUES 
(@trans_id, '2022-10-31', 'Kết chuyển lợi nhuận sau thuế', 5, @period_id, NULL, NULL);
INSERT INTO journal_entry VALUES 
(@entry_id, @trans_id, 'D911', 4400000, NULL),
(@entry_id+1, @trans_id, '421B', NULL, 4400000);
SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 2;

-- 6. Cash flow activities
-- 6.1 Pay dividends (30% of net profit)
INSERT INTO journal_transaction VALUES 
(@trans_id, '2022-10-31', 'Chi trả cổ tức', 4, @period_id, NULL, NULL);
INSERT INTO journal_entry VALUES 
(@entry_id, @trans_id, '421B', 1320000, NULL), -- 4,400,000 * 30%
(@entry_id+1, @trans_id, '111A', NULL, 1320000);
SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 2;

-- 6.2 Collect from customers (80% of receivables)
INSERT INTO journal_transaction VALUES 
(@trans_id, '2022-10-31', 'Thu tiền khách hàng B', 3, @period_id, NULL, 3);
INSERT INTO journal_entry VALUES 
(@entry_id, @trans_id, '112A', 508640000, NULL), -- 635,800,000 * 80%
(@entry_id+1, @trans_id, '131A', NULL, 508640000);
SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 2;

-- 6.3 Pay suppliers (75% of payables)
INSERT INTO journal_transaction VALUES 
(@trans_id, '2022-10-31', 'Trả tiền nhà cung cấp A', 4, @period_id, 5, NULL);
INSERT INTO journal_entry VALUES 
(@entry_id, @trans_id, '331A', 165000000, NULL), -- 220,000,000 * 75%
(@entry_id+1, @trans_id, '112A', NULL, 165000000);
SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 2;

-- 6.4 Pay income tax (90% of tax payable)
INSERT INTO journal_transaction VALUES 
(@trans_id, '2022-10-31', 'Nộp thuế TNDN', 8, @period_id, NULL, NULL);
INSERT INTO journal_entry VALUES 
(@entry_id, @trans_id, '333A', 990000, NULL), -- 1,100,000 * 90%
(@entry_id+1, @trans_id, '112A', NULL, 990000);
SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 2;

-- 6.5 Pay salaries (85% of salary payable)
INSERT INTO journal_transaction VALUES 
(@trans_id, '2022-10-31', 'Trả lương nhân viên', 4, @period_id, NULL, NULL);
INSERT INTO journal_entry VALUES 
(@entry_id, @trans_id, '334A', 161500000, NULL), -- (90,000,000 + 100,000,000) * 85%
(@entry_id+1, @trans_id, '111A', NULL, 161500000);
SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 2;

-- 6.6 Pay short-term loan principal (10% of 700,000,000)
INSERT INTO journal_transaction VALUES 
(@trans_id, '2022-10-31', 'Trả nợ gốc vay ngắn hạn', 9, @period_id, NULL, NULL);
INSERT INTO journal_entry VALUES 
(@entry_id, @trans_id, '341A', 70000000, NULL),
(@entry_id+1, @trans_id, '112A', NULL, 70000000);
SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 2;

-- 6.7 Pay long-term loan principal (5% of 500,000,000)
INSERT INTO journal_transaction VALUES 
(@trans_id, '2022-10-31', 'Trả nợ gốc vay dài hạn', 9, @period_id, NULL, NULL);
INSERT INTO journal_entry VALUES 
(@entry_id, @trans_id, '341B', 25000000, NULL),
(@entry_id+1, @trans_id, '112A', NULL, 25000000);
SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 2;


-- FIX
INSERT INTO journal_transaction VALUES 
(2210900, '2022-10-31', 'FIX', 5, @period_id, NULL, NULL);

INSERT INTO journal_entry VALUES 
(2210900, 2210900, '338A', NULL, 96000000);

INSERT INTO journal_entry VALUES 
(2210901, 2210900, '112A', 300000000, NULL),
(2210902, 2210900, '121A', NULL, 300000000);

INSERT INTO journal_entry VALUES 
(2210903, 2210900, '333A', 300000000, NULL),
(2210904, 2210900, '334A', 300000000, NULL),
(2210905, 2210900, '341A', NULL, 600000000);

COMMIT;