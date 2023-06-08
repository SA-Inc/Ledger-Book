-- Transactions
SELECT
  "date",
  CASE WHEN amount < 0 THEN amount ELSE 0 END AS "outcome",
  CASE WHEN amount > 0 THEN amount ELSE 0 END AS "income"
FROM (
  SELECT
    "date",
    SUM(amount) AS "amount"
  FROM "transaction"
  WHERE account_id = $get_accounts
  GROUP BY "date"
  ORDER BY "date" ASC
) s


-- Income/Outcome Pie Chart
SELECT
  'outcome' AS "type", SUM(CASE WHEN amount < 0 THEN 1 ELSE 0 END) AS "count"
FROM "transaction"
WHERE account_id = $get_accounts
UNION
SELECT
  'income' AS "type", SUM(CASE WHEN amount > 0 THEN 1 ELSE 0 END) AS "count"
FROM "transaction"
WHERE account_id = $get_accounts


-- Transactions Count
SELECT
  DATE_TRUNC('month', "date"),
  COUNT("id") AS "transactions"
FROM "transaction"
WHERE account_id = $get_accounts
GROUP BY DATE_TRUNC('month', "date")
ORDER BY DATE_TRUNC('month', "date")


-- Running Balance
SELECT "date",
  SUM(amount) OVER (ORDER BY id) AS "balance"
FROM "transaction"
WHERE account_id = $get_accounts


-- Running Balance Grouped
SELECT "date",
  SUM(amount_sum) OVER (ORDER BY "date") AS  "balance"
FROM (
  SELECT "date",
    SUM(amount) AS "amount_sum"
  FROM "transaction"
  WHERE account_id = $get_accounts
  GROUP BY "date"
  ORDER BY "date" ASC
) s
