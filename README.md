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

![Ledger Overview](https://github.com/SA-Inc/Ledger-Book/blob/main/img/Ledger%20Overview.png?raw=true)

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

## Year Income Outcome

![Running Balance](https://github.com/SA-Inc/Ledger-Book/blob/main/img/Year%20Income%20Outcome.png)

## Year Month Income Outcome

![Running Balance](https://github.com/SA-Inc/Ledger-Book/blob/main/img/Year%20Month%20Income%20Outcome.png)
