-- Running Balance with Percent Delta
SELECT "date", "amount", "balance",
CASE WHEN "previous_balance" = 0
  THEN 0
  ELSE ROUND(COALESCE(100.0 * ("balance" - "previous_balance") / "previous_balance", 0), 2) 
  END AS "delta"
FROM (
  SELECT "id", "date", "amount", "balance",
  LAG("balance", 1, 0) OVER (ORDER BY "id") AS "previous_balance"
  FROM (
    SELECT "id", "date", "amount",
      SUM(amount) OVER (ORDER BY "id") AS "balance"
    FROM "transaction"
	  WHERE account_id = $get_accounts
    ORDER BY id ASC
  ) s
) f


-- Year Income/Outcome
SELECT
  DATE_TRUNC('year', "date") AS "date",
  COUNT("id") AS "transactions",
  SUM(CASE WHEN amount < 0 THEN amount ELSE 0 END) AS "outcome",
  SUM(CASE WHEN amount > 0 THEN amount ELSE 0 END) AS "income",
  SUM(amount) AS "sum"
FROM "transaction"
WHERE account_id = $get_accounts
GROUP BY DATE_TRUNC('year', "date")
ORDER BY DATE_TRUNC('year', "date")


-- Year-Month Income/Outcome
SELECT
  DATE_TRUNC('month', "date") AS "date",
  COUNT("id") AS "transactions",
  SUM(CASE WHEN amount < 0 THEN amount ELSE 0 END) AS "outcome",
  SUM(CASE WHEN amount > 0 THEN amount ELSE 0 END) AS "income",
  SUM(amount) AS "sum"
FROM "transaction"
WHERE account_id = $get_accounts
GROUP BY DATE_TRUNC('month', "date")
ORDER BY DATE_TRUNC('month', "date")
