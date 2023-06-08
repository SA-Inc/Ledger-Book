
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
