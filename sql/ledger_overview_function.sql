CREATE OR REPLACE FUNCTION get_ledger_overview(account_id_arg INT)
  RETURNS TABLE (key TEXT, value TEXT)
AS $$
BEGIN



SELECT
  'currency' AS "key", currency AS "value"
FROM account
WHERE id = account_id_arg

UNION

SELECT
  'total_transactions' AS "key", CAST (COUNT(date) AS TEXT) AS "value"
FROM "transaction"
WHERE account_id = account_id_arg

UNION

SELECT
  'total_outcome' AS "key", CAST (SUM(CASE WHEN amount < 0 THEN amount ELSE 0 END) AS TEXT) AS "value"
FROM "transaction"
WHERE account_id = account_id_arg

UNION

SELECT
  'total_income' AS "key", CAST (SUM(CASE WHEN amount > 0 THEN amount ELSE 0 END) AS TEXT) AS "value"
FROM "transaction"
WHERE account_id = account_id_arg

UNION

SELECT
  'balance' AS "key", CAST (SUM(amount) AS TEXT) AS "value"
FROM "transaction"
WHERE account_id = account_id_arg

UNION

SELECT
  'total_outcome_transactions' AS "key", CAST (SUM(CASE WHEN amount < 0 THEN 1 ELSE 0 END) AS TEXT) AS "value"
FROM "transaction"
WHERE account_id = account_id_arg

UNION

SELECT
  'unique_transaction_dates' AS "key", CAST (COUNT(DISTINCT date) AS TEXT) AS "value"
FROM "transaction"
WHERE account_id = account_id_arg

UNION

SELECT
  'total_income_transactions' AS "key", CAST (SUM(CASE WHEN amount > 0 THEN 1 ELSE 0 END) AS TEXT) AS "value"
FROM "transaction"
WHERE account_id = account_id_arg

UNION

SELECT "key", "value"
FROM (
SELECT 'total_income_transactions' AS "key", CAST ("date" AS TEXT) AS "value"
FROM "transaction"
WHERE account_id = account_id_arg
ORDER BY "date" ASC
LIMIT 1
) AS s

UNION

SELECT "key", "value"
FROM (
SELECT 'total_income_transactions' AS "key", CAST (CURRENT_DATE - "date" AS TEXT) AS "value"
FROM "transaction"
WHERE account_id = account_id_arg
ORDER BY "date" DESC
LIMIT 1
) AS s

UNION

SELECT "key", "value"
FROM (
SELECT 'total_income_transactions' AS "key", CAST ("date" AS TEXT) AS "value"
FROM "transaction"
WHERE account_id = account_id_arg
ORDER BY "date" DESC
LIMIT 1
) AS s

UNION

SELECT "key", "value"
FROM (
SELECT
  'last_transaction_type' AS "key", CASE WHEN amount < 0 THEN 'outcome' ELSE 'income' END AS "value"
FROM "transaction"
WHERE account_id = account_id_arg
ORDER BY "date" DESC
LIMIT 1
) AS s;



END
$$ LANGUAGE plpgsql;
