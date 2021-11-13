create table customers (
    id integer primary key,
    name varchar(255),
    birth_date date
);

create table accounts(
    account_id varchar(40) primary key ,
    customer_id integer references customers(id),
    currency varchar(3),
    balance float,
    "limit" float
);

create table transactions (
    id serial primary key ,
    date timestamp,
    src_account varchar(40) references accounts(account_id),
    dst_account varchar(40) references accounts(account_id),
    amount float,
    status varchar(20)
);

INSERT INTO customers VALUES (201, 'John', '2021-11-05');
INSERT INTO customers VALUES (202, 'Anny', '2021-11-02');
INSERT INTO customers VALUES (203, 'Rick', '2021-11-24');

INSERT INTO accounts VALUES ('NT10204', 201, 'KZT', 1000, null);
INSERT INTO accounts VALUES ('AB10203', 202, 'USD', 100, 0);
INSERT INTO accounts VALUES ('DK12000', 203, 'EUR', 500, 200);
INSERT INTO accounts VALUES ('NK90123', 201, 'USD', 400, 0);
INSERT INTO accounts VALUES ('RS88012', 203, 'KZT', 5000, -100);

INSERT INTO transactions VALUES (1, '2021-11-05 18:00:34.000000', 'NT10204', 'RS88012', 1000, 'commited');
INSERT INTO transactions VALUES (2, '2021-11-05 18:01:19.000000', 'NK90123', 'AB10203', 500, 'rollback');
INSERT INTO transactions VALUES (3, '2021-06-05 18:02:45.000000', 'RS88012', 'NT10204', 400, 'init');

--TASKS
--1
/*
Large object(photos, videos, etc.) are stored in the following way:
blob: binary large object - object is a large collection of uninterpreted binary data (whose interpretation is left to an application outside of the database system)
clob:character large object - object is a large collection of character data
*/

--2
/*
Users define a role, which is a set of privileges. It makes privilege administration easier by allowing you to handle privilege packages.
A privilege is the ability to run a specific sort of SQL statement.
A user can login to a database and, in some cases, own objects in the database.
*/

--2.1
CREATE ROLE accountant;
CREATE ROLE administrator;
CREATE ROLE support;

GRANT SELECT, INSERT, UPDATE(status), DELETE ON transactions TO accountant;
GRANT SELECT ON accounts TO accountant;
GRANT ALL PRIVILEGES ON accounts, customers, transactions TO administrator;
GRANT SELECT ON customers TO support;
GRANT SELECT, UPDATE("limit", currency), DELETE, INSERT ON accounts TO support;

--2.2
CREATE USER Amina;
CREATE USER Amin;
CREATE USER Ami;

GRANT accountant TO Amin;
GRANT administrator TO Amina;
GRANT support TO Ami;

--2.3
ALTER ROLE administrator CREATEROLE;
ALTER ROLE support CREATEROLE;

--2.4
REVOKE DELETE, INSERT ON accounts FROM support;

--3.2
ALTER TABLE accounts
ALTER COLUMN customer_id SET NOT NULL,
ALTER COLUMN currency SET NOT NULL,
ALTER COLUMN balance SET NOT NULL,
ALTER COLUMN balance SET DEFAULT 0;

ALTER TABLE customers
ALTER COLUMN name SET NOT NULL,
ALTER COLUMN birth_date SET NOT NULL;

ALTER TABLE transactions
ALTER COLUMN date SET NOT NULL,
ALTER COLUMN src_account SET NOT NULL,
ALTER COLUMN dst_account SET NOT NULL,
ALTER COLUMN amount SET NOT NULL,
ALTER COLUMN status SET NOT NULL;

--5.1
CREATE UNIQUE INDEX cust_curr ON accounts(customer_id, currency);
--as an example
--INSERT INTO accounts VALUES ('CS10100', 201, 'USD', 200, -100)
--this should give an error as 201 already has USD account

--5.2
CREATE INDEX s_curr_bal ON accounts(currency, balance);

--6
UPDATE accounts SET balance = 2000 WHERE account_id = 'RS88012';
DELETE FROM transactions WHERE id = 3;

CALL testt(3, 'RS88012', 'NT10204', 400);

CREATE OR REPLACE PROCEDURE testt(id_name int, sr varchar(40), ds varchar(40), money_amount int)
AS $$
    DECLARE
    limitt float;
    balancee float;

    BEGIN
        INSERT INTO transactions VALUES (id_name, now(), sr, ds, money_amount, 'init');
            UPDATE accounts SET balance = balance - money_amount WHERE account_id = sr;
            UPDATE accounts SET balance = balance + money_amount WHERE account_id = ds;
        SELECT balance INTO balancee FROM accounts WHERE account_id = sr;
        SELECT "limit" INTO limitt FROM accounts WHERE account_id = sr;

        IF balancee < limitt THEN
            ROLLBACK;
            INSERT INTO transactions VALUES (id_name, now(), sr, ds, money_amount, 'rollback');
        ELSE
            UPDATE transactions SET status = 'commited' WHERE id = id_name;
        END IF;

    END;
    $$ LANGUAGE plpgsql;

