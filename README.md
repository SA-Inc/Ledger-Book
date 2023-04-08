# Ledger Book
Simple Database to store Ledger Records and get reports of Money Stash. All values are in common currency unit (EuroDollar). Created for SQLite DB and PostgreSQL


# Database Structure
## Create Table Structure
### SQLite
```sql
CREATE TABLE "ledger" (
  "id" INTEGER,
  "date" TEXT NOT NULL,
  "amount" INTEGER NOT NULL,
  PRIMARY KEY("id" AUTOINCREMENT)
)
```

### PostgreSQL
```sql
CREATE TABLE "ledger" (
  "id" SERIAL PRIMARY KEY,
  "date" DATE NOT NULL,
  "amount" INT NOT NULL
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
### SQLite
```sql
SELECT
  COUNT(date) AS 'total_rows',
  COUNT(DISTINCT date) AS 'unique_dates'
FROM ledger
```

### PostgreSQL
```sql
SELECT
  COUNT(date) AS "total_rows"
  COUNT(DISTINCT date) AS "unique_dates"
FROM ledger
```

## Total Income/Outcome
### SQLite
```sql
SELECT
  COUNT(*) AS 'records',
  SUM(CASE WHEN amount < 0 THEN amount ELSE 0 END) AS 'minus',
  SUM(CASE WHEN amount > 0 THEN amount ELSE 0 END) AS 'plus',
  SUM(amount) AS 'sum'
FROM ledger
```

### PostgreSQL
```sql
SELECT
  COUNT(*) AS "records",
  SUM(CASE WHEN amount < 0 THEN amount ELSE 0 END) AS "minus",
  SUM(CASE WHEN amount > 0 THEN amount ELSE 0 END) AS "plus",
  SUM(amount) AS "sum"
FROM ledger
```

## Year Income/Outcome
### SQLite
```sql
SELECT
  strftime('%Y', date) AS 'date',
  COUNT(*) AS 'records',
  SUM(CASE WHEN amount < 0 THEN amount ELSE 0 END) AS 'minus',
  SUM(CASE WHEN amount > 0 THEN amount ELSE 0 END) AS 'plus',
  SUM(amount) AS 'sum'
FROM ledger
GROUP BY strftime('%Y', date)
```

### PostgreSQL
```sql
SELECT
  EXTRACT(YEAR FROM date) AS "date",
  COUNT(*) AS "records",
  SUM(CASE WHEN amount < 0 THEN amount ELSE 0 END) AS "minus",
  SUM(CASE WHEN amount > 0 THEN amount ELSE 0 END) AS "plus",
  SUM(amount) AS "sum"
FROM ledger
GROUP BY EXTRACT(YEAR FROM date)
```

## Year and Month Income/Outcome
### SQLite
```sql
SELECT
  strftime('%Y-%m', date) AS 'date',
  COUNT(*) AS 'records',
  SUM(CASE WHEN amount < 0 THEN amount ELSE 0 END) AS 'minus',
  SUM(CASE WHEN amount > 0 THEN amount ELSE 0 END) AS 'plus',
  SUM(amount) AS 'sum'
FROM ledger
GROUP BY strftime('%Y-%m', date)
```

### PostgreSQL
```sql
SELECT
  CONCAT(EXTRACT(YEAR FROM date), '-', LPAD(EXTRACT(MONTH FROM date)::text, 2, '0')) AS "date",
  COUNT(*) AS "records",
  SUM(CASE WHEN amount < 0 THEN amount ELSE 0 END) AS "minus",
  SUM(CASE WHEN amount > 0 THEN amount ELSE 0 END) AS "plus",
  SUM(amount) AS "sum"
FROM ledger
GROUP BY EXTRACT(YEAR FROM date), EXTRACT(MONTH FROM date)
ORDER BY EXTRACT(YEAR FROM date), EXTRACT(MONTH FROM date)
```

## Total Sum by Years
```sql
SELECT
  strftime('%Y', date) AS 'date',
  COUNT(*) AS 'records',
  SUM(amount) AS 'sum'
FROM ledger
GROUP BY strftime('%Y', date)
```

## Total Sum by Year and Month
```sql
SELECT
  strftime('%Y-%m', date) AS 'date',
  COUNT(*) AS 'records',
  SUM(amount) AS 'sum'
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
SELECT
  strftime('%Y-%m', date) AS 'Year',
  COUNT(*) AS 'Rows',
  SUM(amount) AS 'Sum'
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
