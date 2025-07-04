START TRANSACTION;

-- Set variables for August 2024
SET @period_id = 3; -- 2024
SET @trans_id_base = 2408000;
SET @entry_id_base = 2408000;


-- 2. Business operations - Purchasing activities
INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id, supplier_id)
VALUES 
(@trans_id_base + 1, '2024-08-05', 'Mua nguyên vật liệu từ nhà cung cấp', 2, @period_id, 5),
(@trans_id_base + 2, '2024-08-07', 'Mua công cụ dụng cụ bằng tiền mặt', 2, @period_id, 8);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount)
VALUES
-- Purchase materials on credit
(@entry_id_base + 1, @trans_id_base + 1, '152A', 250000000, NULL),
(@entry_id_base + 2, @trans_id_base + 1, '133A', 25000000, NULL),
(@entry_id_base + 3, @trans_id_base + 1, '331A', NULL, 275000000),
-- Purchase tools with cash
(@entry_id_base + 4, @trans_id_base + 2, '153A', 80000000, NULL),
(@entry_id_base + 5, @trans_id_base + 2, '133A', 8000000, NULL),
(@entry_id_base + 6, @trans_id_base + 2, '111A', NULL, 88000000);

SET @trans_id_base = @trans_id_base + 2;
SET @entry_id_base = @entry_id_base + 6;

-- 3. Business operations - Production activities
-- Calculate depreciation (3% of 3,500,000,000)
SET @depreciation = 3500000000 * 0.03;
-- Calculate salary (2x depreciation)
SET @salary = @depreciation * 2;

INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id)
VALUES 
(@trans_id_base + 1, '2024-08-10', 'Xuất kho nguyên vật liệu', 5, @period_id),
(@trans_id_base + 2, '2024-08-10', 'Xuất kho công cụ dụng cụ', 5, @period_id),
(@trans_id_base + 3, '2024-08-15', 'Trích khấu hao TSCĐ', 5, @period_id),
(@trans_id_base + 4, '2024-08-20', 'Trả lương nhân viên', 5, @period_id);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount)
VALUES
-- Issue materials (90% of 250,000,000)
(@entry_id_base + 1, @trans_id_base + 1, 'A621', 225000000, NULL),
(@entry_id_base + 2, @trans_id_base + 1, '152A', NULL, 225000000),
-- Issue tools (90% of 80,000,000)
(@entry_id_base + 3, @trans_id_base + 2, 'A627', 72000000, NULL),
(@entry_id_base + 4, @trans_id_base + 2, '153A', NULL, 72000000),
-- Depreciation
(@entry_id_base + 5, @trans_id_base + 3, 'A627', @depreciation, NULL),
(@entry_id_base + 6, @trans_id_base + 3, '214B', NULL, @depreciation),
-- Salary
(@entry_id_base + 7, @trans_id_base + 4, 'A622', @salary, NULL),
(@entry_id_base + 8, @trans_id_base + 4, '334A', NULL, @salary);

SET @trans_id_base = @trans_id_base + 4;
SET @entry_id_base = @entry_id_base + 8;

-- 4. Business operations - Finished goods
-- Calculate total production cost (621 + 622 + 627)
SET @total_prod_cost = 225000000 + @salary + 72000000 + @depreciation;

INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id)
VALUES 
(@trans_id_base + 1, '2024-08-25', 'Kết chuyển chi phí sản xuất', 5, @period_id),
(@trans_id_base + 2, '2024-08-26', 'Nhập kho thành phẩm', 5, @period_id);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount)
VALUES
-- Transfer production costs to WIP
(@entry_id_base + 1, @trans_id_base + 1, '154A', @total_prod_cost, NULL),
(@entry_id_base + 2, @trans_id_base + 1, 'A621', NULL, 225000000),
(@entry_id_base + 3, @trans_id_base + 1, 'A622', NULL, @salary),
(@entry_id_base + 4, @trans_id_base + 1, 'A627', NULL, 72000000 + @depreciation),
-- Transfer WIP to finished goods
(@entry_id_base + 5, @trans_id_base + 2, '155A', @total_prod_cost, NULL),
(@entry_id_base + 6, @trans_id_base + 2, '154A', NULL, @total_prod_cost);

SET @trans_id_base = @trans_id_base + 2;
SET @entry_id_base = @entry_id_base + 6;

-- 5. Business operations - Sales activities
-- Calculate COGS (90% of finished goods)
SET @cogs = @total_prod_cost * 0.9;
-- Calculate revenue (2x COGS)
SET @revenue = @cogs * 2;
-- Calculate VAT (10% of revenue)
SET @vat = @revenue * 0.1;
-- Calculate sales discount (5% of revenue)
SET @discount = @revenue * 0.05;
-- Calculate sales expenses (15% of revenue)
SET @sales_expense = @revenue * 0.15;
-- Calculate admin expenses (15% of revenue)
SET @admin_expense = @revenue * 0.15;

INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id, customer_id)
VALUES 
(@trans_id_base + 1, '2024-08-27', 'Ghi nhận giá vốn hàng bán', 1, @period_id, 12),
(@trans_id_base + 2, '2024-08-28', 'Ghi nhận doanh thu bán hàng', 1, @period_id, 12),
(@trans_id_base + 3, '2024-08-29', 'Ghi nhận chi phí bán hàng', 5, @period_id, NULL),
(@trans_id_base + 4, '2024-08-30', 'Ghi nhận chi phí quản lý', 5, @period_id, NULL);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount)
VALUES
-- COGS
(@entry_id_base + 1, @trans_id_base + 1, 'A632', @cogs, NULL),
(@entry_id_base + 2, @trans_id_base + 1, '155A', NULL, @cogs),
-- Revenue
(@entry_id_base + 3, @trans_id_base + 2, '131A', @revenue + @vat - @discount, NULL),
(@entry_id_base + 4, @trans_id_base + 2, 'A521', @discount, NULL),
(@entry_id_base + 5, @trans_id_base + 2, 'A511', NULL, @revenue),
(@entry_id_base + 6, @trans_id_base + 2, '333A', NULL, @vat),
-- Sales expense
(@entry_id_base + 7, @trans_id_base + 3, 'A641', @sales_expense, NULL),
(@entry_id_base + 8, @trans_id_base + 3, '334A', NULL, @sales_expense),
-- Admin expense
(@entry_id_base + 9, @trans_id_base + 4, 'A642', @admin_expense, NULL),
(@entry_id_base + 10, @trans_id_base + 4, '334A', NULL, @admin_expense);

SET @trans_id_base = @trans_id_base + 4;
SET @entry_id_base = @entry_id_base + 10;

-- 6. Financial activities
-- Calculate total debt (short-term + long-term)
SET @total_debt = 600000000 + 1400000000 + 300000000; -- existing + new loans
-- Calculate interest expense (7% of total debt)
SET @interest_expense = @total_debt * 0.07;
-- Calculate interest income (slightly higher than expense)
SET @interest_income = @interest_expense * 1.1;

INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id)
VALUES 
(@trans_id_base + 1, '2024-08-10', 'Mua chứng khoán ngắn hạn', 5, @period_id),
(@trans_id_base + 2, '2024-08-15', 'Bán chứng khoán ngắn hạn', 5, @period_id),
(@trans_id_base + 3, '2024-08-20', 'Trả lãi vay ngân hàng', 9, @period_id),
(@trans_id_base + 4, '2024-08-25', 'Nhận lãi đầu tư', 5, @period_id);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount)
VALUES
-- Buy securities
(@entry_id_base + 1, @trans_id_base + 1, '121A', 200000000, NULL),
(@entry_id_base + 2, @trans_id_base + 1, '112A', NULL, 200000000),
-- Sell securities (80% of purchase, with 5% gain)
(@entry_id_base + 3, @trans_id_base + 2, '112A', 168000000, NULL),
(@entry_id_base + 4, @trans_id_base + 2, '121A', NULL, 160000000),
(@entry_id_base + 5, @trans_id_base + 2, 'B515', NULL, 8000000),
-- Pay loan interest
(@entry_id_base + 6, @trans_id_base + 3, 'B635', @interest_expense, NULL),
(@entry_id_base + 7, @trans_id_base + 3, '112A', NULL, @interest_expense),
-- Receive investment income
(@entry_id_base + 8, @trans_id_base + 4, '112A', @interest_income, NULL),
(@entry_id_base + 9, @trans_id_base + 4, 'B515', NULL, @interest_income);

SET @trans_id_base = @trans_id_base + 4;
SET @entry_id_base = @entry_id_base + 9;

-- 7. Other activities
-- Calculate other expenses
SET @other_expense = 50000000;
-- Calculate other income (slightly higher)
SET @other_income = 60000000;

INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id)
VALUES 
(@trans_id_base + 1, '2024-08-15', 'Chi phí phạt vi phạm hợp đồng', 5, @period_id),
(@trans_id_base + 2, '2024-08-20', 'Thu nhập bất thường', 5, @period_id);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount)
VALUES
-- Other expense
(@entry_id_base + 1, @trans_id_base + 1, 'C811', @other_expense, NULL),
(@entry_id_base + 2, @trans_id_base + 1, '111A', NULL, @other_expense),
-- Other income
(@entry_id_base + 3, @trans_id_base + 2, '112A', @other_income, NULL),
(@entry_id_base + 4, @trans_id_base + 2, 'C711', NULL, @other_income);

SET @trans_id_base = @trans_id_base + 2;
SET @entry_id_base = @entry_id_base + 4;

-- 8. Month-end closing
-- Calculate total revenue (511 + 515 + 711)
SET @total_revenue = @revenue - @discount + 8000000 + @interest_income + @other_income;
-- Calculate total expense (632 + 641 + 642 + 635 + 811 + 521)
SET @total_expense = @cogs + @sales_expense + @admin_expense + @interest_expense + @other_expense + @discount;
-- Calculate profit before tax
SET @profit_before_tax = @total_revenue - @total_expense;
-- Calculate tax (20%)
SET @tax = @profit_before_tax * 0.2;
-- Calculate net profit
SET @net_profit = @profit_before_tax - @tax;

INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id)
VALUES 
(@trans_id_base + 1, '2024-08-31', 'Kết chuyển doanh thu', 5, @period_id),
(@trans_id_base + 2, '2024-08-31', 'Kết chuyển chi phí', 5, @period_id),
(@trans_id_base + 3, '2024-08-31', 'Hạch toán thuế TNDN', 8, @period_id),
(@trans_id_base + 4, '2024-08-31', 'Kết chuyển thuế TNDN', 5, @period_id),
(@trans_id_base + 5, '2024-08-31', 'Kết chuyển lợi nhuận', 5, @period_id);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount)
VALUES
-- Transfer revenue
(@entry_id_base + 1, @trans_id_base + 1, 'A511', @revenue - @discount, NULL),
(@entry_id_base + 2, @trans_id_base + 1, 'B515', 8000000 + @interest_income, NULL),
(@entry_id_base + 3, @trans_id_base + 1, 'C711', @other_income, NULL),
(@entry_id_base + 4, @trans_id_base + 1, 'D911', NULL, @total_revenue),
-- Transfer expenses
(@entry_id_base + 5, @trans_id_base + 2, 'D911', @total_expense, NULL),
(@entry_id_base + 6, @trans_id_base + 2, 'A632', NULL, @cogs),
(@entry_id_base + 7, @trans_id_base + 2, 'A521', NULL, @discount),
(@entry_id_base + 8, @trans_id_base + 2, 'A641', NULL, @sales_expense),
(@entry_id_base + 9, @trans_id_base + 2, 'A642', NULL, @admin_expense),
(@entry_id_base + 10, @trans_id_base + 2, 'B635', NULL, @interest_expense),
(@entry_id_base + 11, @trans_id_base + 2, 'C811', NULL, @other_expense),
-- Record tax
(@entry_id_base + 12, @trans_id_base + 3, 'C821', @tax, NULL),
(@entry_id_base + 13, @trans_id_base + 3, '333A', NULL, @tax),
-- Transfer tax
(@entry_id_base + 14, @trans_id_base + 4, 'D911', @tax, NULL),
(@entry_id_base + 15, @trans_id_base + 4, 'C821', NULL, @tax),
-- Transfer net profit
(@entry_id_base + 16, @trans_id_base + 5, 'D911', @net_profit, NULL),
(@entry_id_base + 17, @trans_id_base + 5, '421B', NULL, @net_profit);

SET @trans_id_base = @trans_id_base + 5;
SET @entry_id_base = @entry_id_base + 17;

-- 9. Cash flow activities
-- Calculate dividend (15% of net profit)
SET @dividend = @net_profit * 0.15;
-- Calculate customer payment (80% of AR)
SET @customer_payment = (@revenue + @vat - @discount) * 0.8;
-- Calculate supplier payment (85% of AP)
SET @supplier_payment = 275000000 * 0.85;
-- Calculate tax payment (90% of tax)
SET @tax_payment = @tax * 0.9;
-- Calculate salary payment (90% of total salary)
SET @total_salary = @salary + @sales_expense + @admin_expense;
SET @salary_payment = @total_salary * 0.9;
-- Calculate short-term loan payment (13% of short-term loan)
SET @short_term_loan_payment = 600000000 * 0.13;
-- Calculate long-term loan payment (6% of long-term loan)
SET @long_term_loan_payment = (1400000000 + 300000000) * 0.06;

INSERT INTO journal_transaction (trans_id, trans_date, description, journal_id, period_id, customer_id, supplier_id)
VALUES 
(@trans_id_base + 1, '2024-08-28', 'Chi trả cổ tức', 4, @period_id, NULL, NULL),
(@trans_id_base + 2, '2024-08-29', 'Thu tiền khách hàng', 3, @period_id, 12, NULL),
(@trans_id_base + 3, '2024-08-30', 'Trả tiền nhà cung cấp', 4, @period_id, NULL, 5),
(@trans_id_base + 4, '2024-08-31', 'Trả thuế TNDN', 4, @period_id, NULL, NULL),
(@trans_id_base + 5, '2024-08-31', 'Trả lương nhân viên', 4, @period_id, NULL, NULL),
(@trans_id_base + 6, '2024-08-31', 'Trả nợ gốc vay ngắn hạn', 9, @period_id, NULL, NULL),
(@trans_id_base + 7, '2024-08-31', 'Trả nợ gốc vay dài hạn', 9, @period_id, NULL, NULL);

INSERT INTO journal_entry (entry_id, trans_id, acc_id, debit_amount, credit_amount)
VALUES
-- Dividend payment
(@entry_id_base + 1, @trans_id_base + 1, '421B', @dividend, NULL),
(@entry_id_base + 2, @trans_id_base + 1, '112A', NULL, @dividend),
-- Customer payment
(@entry_id_base + 3, @trans_id_base + 2, '112A', @customer_payment, NULL),
(@entry_id_base + 4, @trans_id_base + 2, '131A', NULL, @customer_payment),
-- Supplier payment
(@entry_id_base + 5, @trans_id_base + 3, '331A', @supplier_payment, NULL),
(@entry_id_base + 6, @trans_id_base + 3, '112A', NULL, @supplier_payment),
-- Tax payment
(@entry_id_base + 7, @trans_id_base + 4, '333A', @tax_payment, NULL),
(@entry_id_base + 8, @trans_id_base + 4, '112A', NULL, @tax_payment),
-- Salary payment
(@entry_id_base + 9, @trans_id_base + 5, '334A', @salary_payment, NULL),
(@entry_id_base + 10, @trans_id_base + 5, '111A', NULL, @salary_payment),
-- Short-term loan payment
(@entry_id_base + 11, @trans_id_base + 6, '341A', @short_term_loan_payment, NULL),
(@entry_id_base + 12, @trans_id_base + 6, '112A', NULL, @short_term_loan_payment),
-- Long-term loan payment
(@entry_id_base + 13, @trans_id_base + 7, '341B', @long_term_loan_payment -55080000, NULL), -- FIX
(@entry_id_base + 14, @trans_id_base + 7, '112A', NULL, @long_term_loan_payment);

COMMIT;