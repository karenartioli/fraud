-- visualising distinct types of transactions
SELECT DISTINCT type
FROM transactions;

-- created table for unique transaction types
CREATE TABLE transaction_type (
  type_id serial,
  type varchar(255)
);

-- added unique types of transaction to transaction_type table
INSERT INTO transaction_type (type)
SELECT DISTINCT type FROM transactions;

-- created dummy table to test code before overwriting the actual table
CREATE TABLE dummy AS 
SELECT *
FROM transactions
LIMIT 20;

-- ***DRAFT*** for replacing the transaction type by transaction id on the main table
UPDATE dummy
SET type = CASE
  WHEN type = 'PAYMENT' THEN 1
  WHEN type ='TRANSFER' THEN 2
  WHEN type ='CASH_IN' THEN 3
  WHEN type ='DEBIT' THEN 4
  WHEN type ='CASH_OUT' THEN 5
END;

-- Replacing the transaction type by transaction id on the main table
UPDATE transactions
SET type = CASE
  WHEN type = 'PAYMENT' THEN 1
  WHEN type ='TRANSFER' THEN 2
  WHEN type ='CASH_IN' THEN 3
  WHEN type ='DEBIT' THEN 4
  WHEN type ='CASH_OUT' THEN 5
END;


-- accounts → all distinct origin and destination accounts. Make sure to remove duplicates between nameOrg and nameDest.

-- union to be used as subquery in future code
SELECT DISTINCT nameorig
FROM transactions
UNION
SELECT DISTINCT namedest
FROM transactions;

-- created table for unique customer accounts
CREATE TABLE accounts (
  account_id serial,
  account_name varchar(200)
);

-- added unique account names to accounts table
INSERT INTO accounts (account_name)
SELECT DISTINCT nameorig
FROM transactions
UNION
SELECT DISTINCT namedest
FROM transactions;

-- Counting unique account numbers (9,073,900) and confirmed XXX duplicates were removed 3,651,340
SELECT COUNT(DISTINCT account_name)
FROM accounts;

SELECT *
FROM dummy
LEFT JOIN accounts ON dummy.nameorig = accounts.account_name;

ALTER TABLE dummy
RENAME COLUMN account_id to origin_id;

-- Replace account name by account id on nameorig
UPDATE transactions
SET nameorig = accounts.account_id
FROM accounts
WHERE transactions.nameorig = accounts.account_name;

-- Replace account name by account id on namedest
UPDATE transactions
SET namedest = accounts.account_id
FROM accounts
WHERE transactions.namedest = accounts.account_name;

-- Rename columns
ALTER TABLE transactions
RENAME COLUMN nameorig TO origin_id;
ALTER TABLE transactions
RENAME COLUMN namedest TO destination_id;

-- Drop dummy
DROP TABLE dummy;

-- Question 1
SELECT COUNT(*)
FROM transactions
WHERE isflaggedfraud = 'false' AND isfraud = 'true';

-- Question 2
SELECT 	type, ROUND(AVG(amount),2) AS average, 
				percentile_cont(0.5) WITHIN GROUP (ORDER BY amount) AS median
FROM transactions AS t
GROUP BY type, isfraud
HAVING isfraud = 'true';

SELECT COUNT(amount)
FROM transactions
WHERE isfraud = 'true' AND type='5';

SELECT CONCAT(origin_id,destination_id) as pair,
			COUNT(CONCAT(origin_id,destination_id))
FROM transactions
GROUP BY CONCAT(origin_id,destination_id)
HAVING COUNT(CONCAT(origin_id,destination_id))>1
ORDER BY COUNT(CONCAT(origin_id,destination_id)) DESC;

SELECT origin_id, destination_id, count(*) as num
FROM transactions
GROUP BY origin_id, destination_id
HAVING COUNT(*)>1;

select max(step)
FROM transactions;
