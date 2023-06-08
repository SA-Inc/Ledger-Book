# Ledger Book
Simple Database to store Ledger Records and get reports of Money Stash. All values are in common currency unit (EuroDollar).

**The Database does not involve storing multiple Accounts and is not a personal finance Tracker (purchasing Goods, paying Bills, etc.)**

**The main Goal is tracking the savings Account**

- DB: SQLite or PostgreSQL
- PostgREST (if need HTTP Interface for PostgreSQL)
- Grafana

##  Table of Contents
- [Database Structure](#database-structure)
  - [Account](#account)
  - [Transaction](#transaction)
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
- [Pivot Tables](#pivot-tables)
  - [Running Balance](#running-balance)
  - [Year Income Outcome](#year-income-outcome)
  - [Year Month Income Outcome](#year-month-income-outcome)

# Database Structure
## Account
- id - auto inc Value
- name - text Value
- currency - text Value

## Transaction
- id - auto inc Value
- account_id - link to Account Entity
- date - ISO 8601 Date (YYYY-MM-DD), without Time
- amount - only Integer (Why count Сents?)


# Overview

*The main Approach is quick get main Measurements and using in big Numbers in Grafana*

![Ledger Overview](https://github.com/SA-Inc/Ledger-Book/blob/main/img/Ledger%20Overview.png)

- Account Currency
- Total Transactions
- Last Transaction Type
- Current Balance
- Total Outcome
- Total Income
- Total Outcome Transactions
- Total Income Transactions
- Unique Transaction Dates
- First Transaction Date
- Last Transaction Date
- Days of Last Transaction


# Pivot Tables
## Running Balance

Shows Running Balance (Running Total/Cumulative Sum/Prefix Sum) and Delta in Percents between current and previous Running Balances

![Running Balance](https://github.com/SA-Inc/Ledger-Book/blob/main/img/Running%20Balance.png)

*Field difference is commented because is actualy amount*

```sql
SELECT
  CONCAT(EXTRACT(YEAR FROM date), '-', LPAD(EXTRACT(MONTH FROM date)::text, 2, '0'), '-', LPAD(EXTRACT(DAY FROM date)::text, 2, '0')) AS "date",
  "amount",
  "balance",
-- COALESCE(("balance" - "previous_balance"), 0) AS "difference",
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
    FROM ledger
    ORDER BY id ASC
  ) s
)f
```

## Year Income Outcome

![Running Balance](https://github.com/SA-Inc/Ledger-Book/blob/main/img/Year%20Income%20Outcome.png)

```sql
SELECT
  EXTRACT(YEAR FROM date) AS "year",
  COUNT("id") AS "transactions",
  SUM(CASE WHEN amount < 0 THEN amount ELSE 0 END) AS "outcome",
  SUM(CASE WHEN amount > 0 THEN amount ELSE 0 END) AS "income",
  SUM(amount) AS "sum"
FROM ledger
GROUP BY EXTRACT(YEAR FROM date)
ORDER BY "year" ASC
```

## Year Month Income Outcome

![Running Balance](https://github.com/SA-Inc/Ledger-Book/blob/main/img/Year%20Month%20Income%20Outcome.png)

```sql
SELECT
  CONCAT(EXTRACT(YEAR FROM date), '-', LPAD(EXTRACT(MONTH FROM date)::text, 2, '0')) AS "date",
  COUNT("id") AS "transactions",
  SUM(CASE WHEN amount < 0 THEN amount ELSE 0 END) AS "outcome",
  SUM(CASE WHEN amount > 0 THEN amount ELSE 0 END) AS "income",
  SUM(amount) AS "sum"
FROM ledger
GROUP BY EXTRACT(YEAR FROM date), EXTRACT(MONTH FROM date)
ORDER BY EXTRACT(YEAR FROM date), EXTRACT(MONTH FROM date)
```
