# Ledger Book
Simple Database to store Ledger Records and get reports of Money Stash. All values are in common currency unit (EuroDollar).

**The Database does not involve storing multiple Accounts and is not a personal finance Tracker (purchasing Goods, paying Bills, etc.)**

**The main Goal is tracking the savings Account**

- DB: SQLite or PostgreSQL
- PostgREST (if need HTTP Interface for PostgreSQL)
- Grafana

##  Table of Contents
- [Database Structure](#database-structure)
  - [Create Table Structure](#create-table-structure)
- [Data Manipulation](#data-manipulation)
  - [Insert Ledger Record](#insert-ledger-record)
  - [Delete Ledger Record](#delete-ledger-record)
  - [Update Ledger Record](#update-ledger-record)
- [Overview](#overview)
  - [Current Balance](#current-balance)
  - [Total Income](#total-income)
  - [Total Outcome](#total-outcome)
  - [Total Transactions](#total-transactions)
  - [Total Income Transactions](#total-income-transactions)
  - [Total Outcome Transactions](#total-outcome-transactions)
  - [Unique Transaction Dates](#unique-transaction-dates)
  - [First Transaction Date](#first-transaction-date)
  - [Last Transaction Date](#last-transaction-date)

# Database Structure
## Create Table Structure

- id - auto inc Value
- date - ISO 8601 Date (YYYY-MM-DD)
- amount - only Integer (Why count Сents?)

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
Uses in big Numbers in Grafana
## Current Balance
```sql
SELECT
  SUM(amount) AS "balance"
FROM ledger
```

## Total Income
```sql
SELECT
  SUM(CASE WHEN amount > 0 THEN amount ELSE 0 END) AS "income"
FROM ledger
```

## Total Outcome
```sql
SELECT
  SUM(CASE WHEN amount < 0 THEN amount ELSE 0 END) AS "outcome"
FROM ledger
```

## Total Transactions
```sql
SELECT
  COUNT(date) AS "total_transactions"
FROM ledger
```

## Total Income Transactions
```sql
SELECT
  SUM(CASE WHEN amount > 0 THEN 1 ELSE 0 END) AS "total_income_transactions"
FROM ledger
```

## Total Outcome Transactions
```sql
SELECT
  SUM(CASE WHEN amount < 0 THEN 1 ELSE 0 END) AS "total_outcome_transactions"
FROM ledger
```

## Unique Transaction Dates
```sql
SELECT
  COUNT(DISTINCT date) AS "unique_transaction_dates"
FROM ledger
```

## First Transaction Date
```sql
SELECT
  CONCAT(
    EXTRACT(
      YEAR FROM date), '-',
      LPAD(EXTRACT(MONTH FROM date)::text, 2, '0'), '-',
      LPAD(EXTRACT(DAY FROM date)::text, 2, '0')
  ) AS "first_transaction_date"
FROM ledger
ORDER BY "date" ASC
LIMIT 1
```

## Last Transaction Date
```sql
SELECT
  CONCAT(
    EXTRACT(
      YEAR FROM date), '-',
      LPAD(EXTRACT(MONTH FROM date)::text, 2, '0'), '-',
      LPAD(EXTRACT(DAY FROM date)::text, 2, '0')
  ) AS "last_transaction_date"
FROM ledger
ORDER BY "date" DESC
LIMIT 1
```
