-- Currency
SELECT currency
FROM account
WHERE id = $get_accounts


-- Total Transactions
SELECT
  COUNT(date) AS "total_transactions"
FROM "transaction"
WHERE account_id = $get_accounts


-- Last Transaction Type
SELECT amount, CASE WHEN amount < 0 THEN 'Outcome' ELSE 'Income' END AS "type"
FROM "transaction"
WHERE account_id = $get_accounts
ORDER BY "date" DESC
LIMIT 1


-- Total Outcome
SELECT
  SUM(CASE WHEN amount < 0 THEN amount ELSE 0 END) AS "outcome"
FROM "transaction"
WHERE account_id = $get_accounts


-- Current Balance
SELECT
  SUM(amount) AS "balance"
FROM "transaction"
WHERE account_id = $get_accounts


-- Total Income
SELECT
  SUM(CASE WHEN amount > 0 THEN amount ELSE 0 END) AS "income"
FROM "transaction"
WHERE account_id = $get_accounts


-- Total Outcome Transactions
SELECT
  SUM(CASE WHEN amount < 0 THEN 1 ELSE 0 END) AS "total_outcome_transactions"
FROM "transaction"
WHERE account_id = $get_accounts


-- Unique Transaction Dates
SELECT
  COUNT(DISTINCT date) AS "unique_transaction_dates"
FROM "transaction"
WHERE account_id = $get_accounts


-- Total Income Transactions
SELECT
  SUM(CASE WHEN amount > 0 THEN 1 ELSE 0 END) AS "total_income_transactions"
FROM "transaction"
WHERE account_id = $get_accounts


-- First Transaction Date
SELECT "date" AS "first_transaction_date"
FROM "transaction"
WHERE account_id = $get_accounts
ORDER BY "date" ASC
LIMIT 1


-- Days of Last Transaction
SELECT CURRENT_DATE - "date" AS "days_difference"
FROM "transaction"
WHERE account_id = $get_accounts
ORDER BY "date" DESC
LIMIT 1


-- Last Transaction Date
SELECT "date" AS "last_transaction_date"
FROM "transaction"
WHERE account_id = $get_accounts
ORDER BY "date" DESC
LIMIT 1
