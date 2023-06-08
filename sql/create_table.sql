CREATE TABLE "account" (
  "id" SERIAL PRIMARY KEY,
  "name" TEXT NOT NULL,
  "currency" TEXT NOT NULL
);


CREATE TABLE "transaction" (
  "id" SERIAL PRIMARY KEY,
  "account_id" INTEGER NOT NULL,
  "date" DATE NOT NULL,
  "amount" INTEGER NOT NULL,
  CONSTRAINT account_fkey FOREIGN KEY("account_id") REFERENCES account("id")
);
