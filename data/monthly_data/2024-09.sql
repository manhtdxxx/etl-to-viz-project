START TRANSACTION;

-- Set transaction IDs for September 2024 (prefix 2409)
-- Note: Using variables for clarity in this script, but will convert to direct values
SET @trans_id = 2409000;
SET @entry_id = 2409000;

-- Accounting period is 2024 (period_id = 3)
SET @period_id = 3;

-- 1. Capital mobilization and fixed asset investment (only in January)
-- Skipping since we're doing September transactions

-- 2. Business operations

-- 2.1 Purchasing activities (buying materials and tools)
-- Transaction 1: Purchase raw materials from supplier 5 on credit (including VAT)
INSERT INTO journal_transaction VALUES 
(@trans_id, '2024-09-01', 'Mua nguyên vật liệu từ nhà cung cấp 5', 2, @period_id, 5, NULL);
INSERT INTO journal_entry VALUES (@entry_id, @trans_id, '152A', 150000000, NULL); -- Raw materials
INSERT INTO journal_entry VALUES (@entry_id+1, @trans_id, '133A', 15000000, NULL); -- VAT input
INSERT INTO journal_entry VALUES (@entry_id+2, @trans_id, '331A', NULL, 165000000); -- Accounts payable
SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 3;

-- Transaction 2: Purchase tools with cash
INSERT INTO journal_transaction VALUES 
(@trans_id, '2024-09-02', 'Mua công cụ dụng cụ bằng tiền mặt', 2, @period_id, 8, NULL);
INSERT INTO journal_entry VALUES (@entry_id, @trans_id, '153A', 50000000, NULL); -- Tools
INSERT INTO journal_entry VALUES (@entry_id+1, @trans_id, '133A', 5000000, NULL); -- VAT input
INSERT INTO journal_entry VALUES (@entry_id+2, @trans_id, '111A', NULL, 55000000); -- Cash
SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 3;

-- 2.2 Production activities
-- Transaction 3: Issue materials to production (90% of purchased materials)
INSERT INTO journal_transaction VALUES 
(@trans_id, '2024-09-05', 'Xuất nguyên vật liệu cho sản xuất', 5, @period_id, NULL, NULL);
INSERT INTO journal_entry VALUES (@entry_id, @trans_id, 'A621', 135000000, NULL); -- Material cost (150M * 90%)
INSERT INTO journal_entry VALUES (@entry_id+1, @trans_id, '152A', NULL, 135000000); -- Raw materials
SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 2;

-- Transaction 4: Issue tools to production (85% of purchased tools)
INSERT INTO journal_transaction VALUES 
(@trans_id, '2024-09-05', 'Xuất công cụ dụng cụ cho sản xuất', 5, @period_id, NULL, NULL);
INSERT INTO journal_entry VALUES (@entry_id, @trans_id, 'A627', 42500000, NULL); -- Tools cost (50M * 85%)
INSERT INTO journal_entry VALUES (@entry_id+1, @trans_id, '153A', NULL, 42500000); -- Tools
SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 2;

-- Transaction 5: Depreciation of fixed assets (3% of 3,500M = 105M)
INSERT INTO journal_transaction VALUES 
(@trans_id, '2024-09-10', 'Trích khấu hao TSCĐ', 5, @period_id, NULL, NULL);
INSERT INTO journal_entry VALUES (@entry_id, @trans_id, 'A627', 105000000, NULL); -- Depreciation expense
INSERT INTO journal_entry VALUES (@entry_id+1, @trans_id, '214B', NULL, 105000000); -- Accumulated depreciation
SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 2;

-- Transaction 6: Payroll for production staff (2x depreciation = 210M)
INSERT INTO journal_transaction VALUES 
(@trans_id, '2024-09-10', 'Trả lương nhân viên sản xuất', 5, @period_id, NULL, NULL);
INSERT INTO journal_entry VALUES (@entry_id, @trans_id, 'A622', 210000000, NULL); -- Labor cost
INSERT INTO journal_entry VALUES (@entry_id+1, @trans_id, '334A', NULL, 210000000); -- Salaries payable
SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 2;

-- 2.3 Finished goods
-- Transaction 7: Transfer production costs to WIP (sum of 621, 622, 627)
INSERT INTO journal_transaction VALUES 
(@trans_id, '2024-09-15', 'Kết chuyển chi phí sản xuất', 5, @period_id, NULL, NULL);
INSERT INTO journal_entry VALUES (@entry_id, @trans_id, '154A', 282500000, NULL); -- WIP (135M + 210M + 42.5M + 105M)
INSERT INTO journal_entry VALUES (@entry_id+1, @trans_id, 'A621', NULL, 135000000); -- Material cost
INSERT INTO journal_entry VALUES (@entry_id+2, @trans_id, 'A622', NULL, 210000000); -- Labor cost
INSERT INTO journal_entry VALUES (@entry_id+3, @trans_id, 'A627', NULL, 147500000); -- Overhead (tools + depreciation)
SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 4;

-- Transaction 8: Transfer WIP to finished goods
INSERT INTO journal_transaction VALUES 
(@trans_id, '2024-09-15', 'Nhập kho thành phẩm', 5, @period_id, NULL, NULL);
INSERT INTO journal_entry VALUES (@entry_id, @trans_id, '155A', 282500000, NULL); -- Finished goods
INSERT INTO journal_entry VALUES (@entry_id+1, @trans_id, '154A', NULL, 282500000); -- WIP
SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 2;

-- 2.4 Sales activities - COGS (90% of finished goods = 254.25M)
INSERT INTO journal_transaction VALUES 
(@trans_id, '2024-09-20', 'Xuất kho thành phẩm bán cho khách hàng 3', 1, @period_id, NULL, 3);
INSERT INTO journal_entry VALUES (@entry_id, @trans_id, 'A632', 254250000, NULL); -- COGS
INSERT INTO journal_entry VALUES (@entry_id+1, @trans_id, '155A', NULL, 254250000); -- Finished goods
SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 2;

-- 2.5 Sales activities - Revenue (1.8x COGS = 457.65M)
INSERT INTO journal_transaction VALUES 
(@trans_id, '2024-09-20', 'Bán hàng cho khách hàng 3', 1, @period_id, NULL, 3);
-- Revenue 457.65M, VAT 10% = 45.765M, total 503.415M
INSERT INTO journal_entry VALUES (@entry_id, @trans_id, '131A', 503415000, NULL); -- Receivable
INSERT INTO journal_entry VALUES (@entry_id+1, @trans_id, 'A511', NULL, 457650000); -- Revenue
INSERT INTO journal_entry VALUES (@entry_id+2, @trans_id, '333A', NULL, 45765000); -- VAT output
SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 3;

-- 2.6 Sales discount (5% of revenue = 22.8825M)
INSERT INTO journal_transaction VALUES 
(@trans_id, '2024-09-20', 'Chiết khấu bán hàng cho khách hàng 3', 1, @period_id, NULL, 3);
INSERT INTO journal_entry VALUES (@entry_id, @trans_id, 'A521', 22882500, NULL); -- Sales discount
INSERT INTO journal_entry VALUES (@entry_id+1, @trans_id, '131A', NULL, 22882500); -- Receivable
SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 2;

-- 2.7 Selling expenses (15% of revenue = 68.6475M)
INSERT INTO journal_transaction VALUES 
(@trans_id, '2024-09-25', 'Chi phí bán hàng', 5, @period_id, NULL, NULL);
INSERT INTO journal_entry VALUES (@entry_id, @trans_id, 'A641', 68647500, NULL); -- Selling expenses
INSERT INTO journal_entry VALUES (@entry_id+1, @trans_id, '331A', NULL, 68647500); -- Payable to vendor
SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 2;

-- 2.8 Administrative expenses (15% of revenue = 68.6475M)
INSERT INTO journal_transaction VALUES 
(@trans_id, '2024-09-25', 'Chi phí quản lý doanh nghiệp', 5, @period_id, NULL, NULL);
INSERT INTO journal_entry VALUES (@entry_id, @trans_id, 'A642', 68647500, NULL); -- Admin expenses
INSERT INTO journal_entry VALUES (@entry_id+1, @trans_id, '331A', NULL, 68647500); -- Payable to vendor
SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 2;

-- 3. Financial activities
-- 3.1 Buy securities (short-term investment)
INSERT INTO journal_transaction VALUES 
(@trans_id, '2024-09-03', 'Mua chứng khoán ngắn hạn', 5, @period_id, NULL, NULL);
INSERT INTO journal_entry VALUES (@entry_id, @trans_id, '121A', 200000000, NULL); -- Short-term securities
INSERT INTO journal_entry VALUES (@entry_id+1, @trans_id, '112A', NULL, 200000000); -- Bank transfer
SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 2;

-- 3.2 Sell securities (partial, with gain)
INSERT INTO journal_transaction VALUES 
(@trans_id, '2024-09-18', 'Bán chứng khoán ngắn hạn', 5, @period_id, NULL, NULL);
-- Sell 50M cost for 60M (10M gain)
INSERT INTO journal_entry VALUES (@entry_id, @trans_id, '112A', 60000000, NULL); -- Bank receipt
INSERT INTO journal_entry VALUES (@entry_id+1, @trans_id, '121A', NULL, 50000000); -- Securities cost
INSERT INTO journal_entry VALUES (@entry_id+2, @trans_id, 'B515', NULL, 10000000); -- Gain
SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 3;

-- 3.3 Pay interest on bank loans (7% of total loans)
-- Total loans: 600M (short) + 1,400M (long) = 2,000M * 7% = 140M
INSERT INTO journal_transaction VALUES 
(@trans_id, '2024-09-15', 'Trả lãi vay ngân hàng', 9, @period_id, NULL, NULL);
INSERT INTO journal_entry VALUES (@entry_id, @trans_id, 'B635', 140000000, NULL); -- Interest expense
INSERT INTO journal_entry VALUES (@entry_id+1, @trans_id, '112A', NULL, 140000000); -- Bank transfer
SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 2;

-- 3.4 Receive investment income (slightly higher than interest paid)
INSERT INTO journal_transaction VALUES 
(@trans_id, '2024-09-20', 'Nhận lãi đầu tư chứng khoán', 5, @period_id, NULL, NULL);
INSERT INTO journal_entry VALUES (@entry_id, @trans_id, '112A', 150000000, NULL); -- Bank receipt
INSERT INTO journal_entry VALUES (@entry_id+1, @trans_id, 'B515', NULL, 150000000); -- Investment income
SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 2;

-- 4. Other activities
-- 4.1 Other expenses (contract penalty)
INSERT INTO journal_transaction VALUES 
(@trans_id, '2024-09-22', 'Phạt vi phạm hợp đồng', 5, @period_id, NULL, NULL);
INSERT INTO journal_entry VALUES (@entry_id, @trans_id, 'C811', 20000000, NULL); -- Other expenses
INSERT INTO journal_entry VALUES (@entry_id+1, @trans_id, '111A', NULL, 20000000); -- Cash
SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 2;

-- 4.2 Other income (sell fixed assets - 1% of 3,500M = 35M)
INSERT INTO journal_transaction VALUES 
(@trans_id, '2024-09-25', 'Bán TSCĐ không cần dùng', 5, @period_id, NULL, NULL);
INSERT INTO journal_entry VALUES (@entry_id, @trans_id, '112A', 35000000, NULL); -- Bank receipt
INSERT INTO journal_entry VALUES (@entry_id+1, @trans_id, 'C711', NULL, 35000000); -- Other income
SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 2;

-- 5. Month-end closing entries
-- 5.1 Transfer all expenses to 911
INSERT INTO journal_transaction VALUES 
(@trans_id, '2024-09-30', 'Kết chuyển chi phí', 5, @period_id, NULL, NULL);
INSERT INTO journal_entry VALUES (@entry_id, @trans_id, 'D911', 254250000, NULL); -- COGS
INSERT INTO journal_entry VALUES (@entry_id+1, @trans_id, 'D911', 68647500, NULL); -- Selling expenses
INSERT INTO journal_entry VALUES (@entry_id+2, @trans_id, 'D911', 68647500, NULL); -- Admin expenses
INSERT INTO journal_entry VALUES (@entry_id+3, @trans_id, 'D911', 140000000, NULL); -- Financial expenses
INSERT INTO journal_entry VALUES (@entry_id+4, @trans_id, 'D911', 20000000, NULL); -- Other expenses
INSERT INTO journal_entry VALUES (@entry_id+5, @trans_id, 'D911', 22882500, NULL); -- Sales discount
INSERT INTO journal_entry VALUES (@entry_id+6, @trans_id, 'A632', NULL, 254250000);
INSERT INTO journal_entry VALUES (@entry_id+7, @trans_id, 'A641', NULL, 68647500);
INSERT INTO journal_entry VALUES (@entry_id+8, @trans_id, 'A642', NULL, 68647500);
INSERT INTO journal_entry VALUES (@entry_id+9, @trans_id, 'B635', NULL, 140000000);
INSERT INTO journal_entry VALUES (@entry_id+10, @trans_id, 'C811', NULL, 20000000);
INSERT INTO journal_entry VALUES (@entry_id+11, @trans_id, 'A521', NULL, 22882500);
SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 12;

-- 5.2 Transfer all revenues to 911
INSERT INTO journal_transaction VALUES 
(@trans_id, '2024-09-30', 'Kết chuyển doanh thu', 5, @period_id, NULL, NULL);
INSERT INTO journal_entry VALUES (@entry_id, @trans_id, 'A511', 457650000, NULL); -- Sales revenue
INSERT INTO journal_entry VALUES (@entry_id+1, @trans_id, 'B515', 160000000, NULL); -- Financial income (10M + 150M)
INSERT INTO journal_entry VALUES (@entry_id+2, @trans_id, 'C711', 35000000, NULL); -- Other income
INSERT INTO journal_entry VALUES (@entry_id+3, @trans_id, 'D911', NULL, 457650000);
INSERT INTO journal_entry VALUES (@entry_id+4, @trans_id, 'D911', NULL, 160000000);
INSERT INTO journal_entry VALUES (@entry_id+5, @trans_id, 'D911', NULL, 35000000);
SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 6;

-- 5.3 Calculate and record corporate income tax (20% of profit)
-- Profit before tax = (457.65M + 160M + 35M) - (254.25M + 68.6475M + 68.6475M + 140M + 20M + 22.8825M) = 652.65M - 574.4275M = 78.2225M
-- Tax = 78.2225M * 20% = 15.6445M
INSERT INTO journal_transaction VALUES 
(@trans_id, '2024-09-30', 'Tính thuế TNDN', 8, @period_id, NULL, NULL);
INSERT INTO journal_entry VALUES (@entry_id, @trans_id, 'C821', 15644500, NULL); -- Tax expense
INSERT INTO journal_entry VALUES (@entry_id+1, @trans_id, '333A', NULL, 15644500); -- Tax payable
SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 2;

-- 5.4 Transfer tax expense to 911
INSERT INTO journal_transaction VALUES 
(@trans_id, '2024-09-30', 'Kết chuyển thuế TNDN', 5, @period_id, NULL, NULL);
INSERT INTO journal_entry VALUES (@entry_id, @trans_id, 'D911', 15644500, NULL); -- Tax expense
INSERT INTO journal_entry VALUES (@entry_id+1, @trans_id, 'C821', NULL, 15644500); -- Tax expense
SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 2;

-- 5.5 Calculate and transfer net profit to retained earnings
-- Net profit = 78.2225M - 15.6445M = 62.578M
INSERT INTO journal_transaction VALUES 
(@trans_id, '2024-09-30', 'Kết chuyển lợi nhuận', 5, @period_id, NULL, NULL);
INSERT INTO journal_entry VALUES (@entry_id, @trans_id, 'D911', 62578000, NULL); -- Net profit
INSERT INTO journal_entry VALUES (@entry_id+1, @trans_id, '421B', NULL, 62578000); -- Retained earnings
SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 2;

-- 6. Cash flow activities
-- 6.1 Pay dividends (15% of net profit = 9.3867M)
INSERT INTO journal_transaction VALUES 
(@trans_id, '2024-09-28', 'Chi trả cổ tức', 4, @period_id, NULL, NULL);
INSERT INTO journal_entry VALUES (@entry_id, @trans_id, '421B', 9386700, NULL); -- Retained earnings
INSERT INTO journal_entry VALUES (@entry_id+1, @trans_id, '111A', NULL, 9386700); -- Cash
SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 2;

-- 6.2 Collect receivables from customers (80% of 480.5325M = 384.426M)
INSERT INTO journal_transaction VALUES 
(@trans_id, '2024-09-28', 'Thu tiền khách hàng 3', 3, @period_id, NULL, 3);
INSERT INTO journal_entry VALUES (@entry_id, @trans_id, '112A', 384426000, NULL); -- Bank receipt
INSERT INTO journal_entry VALUES (@entry_id+1, @trans_id, '131A', NULL, 384426000); -- Receivable
SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 2;

-- 6.3 Pay suppliers (85% of 302.295M = 256.95075M)
INSERT INTO journal_transaction VALUES 
(@trans_id, '2024-09-29', 'Trả tiền nhà cung cấp 5 và 8', 4, @period_id, 5, NULL);
INSERT INTO journal_entry VALUES (@entry_id, @trans_id, '331A', 256950750, NULL); -- Payable
INSERT INTO journal_entry VALUES (@entry_id+1, @trans_id, '112A', NULL, 256950750); -- Bank transfer
SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 2;

-- 6.4 Pay corporate income tax (90% of 15.6445M = 14.08005M)
INSERT INTO journal_transaction VALUES 
(@trans_id, '2024-09-29', 'Nộp thuế TNDN', 4, @period_id, NULL, NULL);
INSERT INTO journal_entry VALUES (@entry_id, @trans_id, '333A', 14080050, NULL); -- Tax payable
INSERT INTO journal_entry VALUES (@entry_id+1, @trans_id, '112A', NULL, 14080050); -- Bank transfer
SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 2;

-- 6.5 Pay salaries (90% of 210M = 189M)
INSERT INTO journal_transaction VALUES 
(@trans_id, '2024-09-30', 'Trả lương nhân viên', 4, @period_id, NULL, NULL);
INSERT INTO journal_entry VALUES (@entry_id, @trans_id, '334A', 189000000 +210000000, NULL); -- Salaries payable -- FIX
INSERT INTO journal_entry VALUES (@entry_id+1, @trans_id, '111A', NULL, 189000000); -- Cash
SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 2;

-- 6.6 Repay short-term loan principal (12% of 600M = 72M)
INSERT INTO journal_transaction VALUES 
(@trans_id, '2024-09-30', 'Trả nợ gốc vay ngắn hạn', 4, @period_id, NULL, NULL);
INSERT INTO journal_entry VALUES (@entry_id, @trans_id, '341A', 72000000, NULL); -- Short-term loan
INSERT INTO journal_entry VALUES (@entry_id+1, @trans_id, '112A', NULL, 72000000); -- Bank transfer
SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 2;

-- 6.7 Repay long-term loan principal (6% of 1,400M = 84M)
INSERT INTO journal_transaction VALUES 
(@trans_id, '2024-09-30', 'Trả nợ gốc vay dài hạn', 4, @period_id, NULL, NULL);
INSERT INTO journal_entry VALUES (@entry_id, @trans_id, '341B', 84000000, NULL); -- Long-term loan
INSERT INTO journal_entry VALUES (@entry_id+1, @trans_id, '112A', NULL, 84000000); -- Bank transfer
SET @trans_id = @trans_id + 1;
SET @entry_id = @entry_id + 2;

COMMIT;