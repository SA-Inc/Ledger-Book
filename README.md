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
