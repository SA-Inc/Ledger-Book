# Ledger Book
Simple Database to store Ledger Records and get reports of Money Stash. All values are in common currency unit (EuroDollar). Created for SQLite DB


# Database Structure
## Create Table Structure
```sql
CREATE TABLE "ledger" (
  "id" INTEGER,
  "date" TEXT NOT NULL,
  "amount" INTEGER NOT NULL,
  PRIMARY KEY("id" AUTOINCREMENT)
)
```


# Data Manipulation 
## Insert Ledger Record
```sql
INSERT INTO ledger ("date", amount)
VALUES ('2022-06-25', -18)
```

## Delete Ledger Record
```sql
DELETE FROM ledger
WHERE id = 52
```

## Update Ledger Record
```sql
UPDATE ledger
SET "date" = '2022-06-25', "amount" = '1000'
WHERE id = 23
```


# Overview
## Count Total Rows and Unique Dates
```sql
SELECT
  COUNT(date) AS 'total_rows',
  COUNT(DISTINCT date) AS 'unique_dates'
FROM ledger
```

## Total Income/Outcome
```sql
SELECT 'date' AS 'date', COUNT(*) AS 'records',
  SUM(CASE WHEN amount < 0 THEN amount ELSE 0 END) AS 'minus',
  SUM(CASE WHEN amount > 0 THEN amount ELSE 0 END) AS 'plus',
  SUM(amount) AS 'sum'
FROM ledger
```

## Year Income/Outcome
```sql
SELECT strftime('%Y', date) AS 'date', COUNT(*) AS 'records',
  SUM(CASE WHEN amount < 0 THEN amount ELSE 0 END) AS 'minus',
  SUM(CASE WHEN amount > 0 THEN amount ELSE 0 END) AS 'plus',
  SUM(amount) AS 'sum'
FROM ledger
GROUP BY strftime('%Y', date)
```

## Year and Month Income/Outcome
```sql
SELECT strftime('%Y-%m', date) AS 'date', COUNT(*) AS 'records',
  SUM(CASE WHEN amount < 0 THEN amount ELSE 0 END) AS 'minus',
  SUM(CASE WHEN amount > 0 THEN amount ELSE 0 END) AS 'plus',
  SUM(amount) AS 'sum'
FROM ledger
GROUP BY strftime('%Y-%m', date)
```

## Total Sum by Years
```sql
SELECT strftime('%Y', date) AS 'date', COUNT(*) AS 'records', SUM(amount) AS 'sum'
FROM ledger
GROUP BY strftime('%Y', date)
```

## Total Sum by Year and Month
```sql
SELECT strftime('%Y-%m', date) AS 'date', COUNT(*) AS 'records', SUM(amount) AS 'sum'
FROM ledger
GROUP BY strftime('%Y-%m', date)
```


# All Ledger Records
## Select all Ledger Records (with Pagination)
```sql
SELECT id, "date", amount
FROM ledger
ORDER BY id ASC
-- LIMIT 5 OFFSET 0
```


## Select Ledger Records between Dates
```sql
SELECT id, "date", amount
FROM ledger
WHERE date BETWEEN '2022-02-01' AND '2022-03-01'
ORDER BY id ASC
LIMIT 100 OFFSET 0
```

## Filter by Year Month Sum
```sql
SELECT strftime('%Y-%m', date) AS 'Year', COUNT(*) AS 'Rows', SUM(amount) AS 'Sum'
FROM ledger
GROUP BY strftime('%Y-%m', date)
HAVING SUM(amount) > 500
ORDER BY SUM(amount) DESC
```


# Balances
## Ledger Records running Balance
```sql
SELECT id, "date", amount,
  SUM(amount) OVER (ORDER BY id) AS 'balance'
FROM ledger
```

## Select Ledger Records running Balance and Difference
```sql
WITH ledger_balance AS (
  SELECT id, "date", amount,
    SUM(amount) OVER (ORDER BY id) AS 'current_balance'
  FROM ledger
),
ledger_balance_previous AS (
  SELECT id, "date", amount, current_balance,
    LAG(current_balance, 1, 0) OVER (ORDER BY id) AS 'previous_balance'
  FROM ledger_balance
)

SELECT id, "date", amount, current_balance, previous_balance,
  COALESCE((current_balance - previous_balance), 0) AS 'difference',
  ROUND(COALESCE(100.0 * (current_balance - previous_balance) / previous_balance, 0), 2) AS 'difference_perc'
FROM ledger_balance_previous
```
