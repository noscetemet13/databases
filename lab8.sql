-- 1.A
CREATE or REPLACE FUNCTION incrmnt(x INTEGER)
RETURNS INTEGER AS
    $$
        BEGIN
        RETURN $1 + 1;
    END;
    $$
LANGUAGE 'plpgsql';
SELECT incrmnt(6) AS ans1a;

-- 1.B
CREATE OR REPLACE FUNCTION sumoftwo(INTEGER, INTEGER)
RETURNS INTEGER AS
    $$
        BEGIN
            RETURN $1 + $2;
        END
    $$
LANGUAGE 'plpgsql';
SELECT sumoftwo(4, 26) AS ans1b;

-- 1.C
CREATE OR replace FUNCTION divisibleby2(x INTEGER)
RETURNS boolean AS
    $$
        BEGIN
            if x % 2 = 0 THEN RETURN TRUE;
            ELSE RETURN FALSE;
            END if;
        END;

    $$
LANGUAGE 'plpgsql';
SELECT divisibleby2(6) as ans1c, divisibleby2(7) as anss1c;

-- 1. D
CREATE OR replace FUNCTION passvalid(x VARCHAR)
RETURNS boolean AS
    $$
        BEGIN
            if LENGTH(x) >= 8 AND LENGTH(x) <= 15 THEN RETURN TRUE;
            ELSE RETURN FALSE;
            END if;
        END;
    $$
LANGUAGE 'plpgsql';
SELECT passvalid('Aa123ab6');

-- 1. E
CREATE FUNCTION twooutputs(a INTEGER, OUT a_square INTEGER, OUT a_dividingitself INTEGER) AS
    $$
    BEGIN
        a_square = a * a;
        a_dividingitself = a / a;
    END;
    $$
    LANGUAGE 'plpgsql';
SELECT * FROM twooutputs(4);

-- 2
CREATE TABLE random_people(
    id INTEGER PRIMARY KEY,
    age INT,
    first_name TEXT,
    last_name TEXT,
    birthday DATE,
    today DATE DEFAULT now()
);

-- 2. А
CREATE OR REPLACE FUNCTION timestampp()
RETURNS TRIGGER AS
    $$
        BEGIN
            if(last_name!= NEW.last_name) THEN NEW.today = CURRENT_DATE;
            END if;
            RETURN NEW;
        END;
    $$
LANGUAGE 'plpgsql';

INSERT INTO random_people(id, age, first_name, last_name) VALUES (1, 19, 'Amina', 'Orazgali');
UPDATE random_people SET last_name = 'Zholdaskalieva' WHERE id = 1;

CREATE TRIGGER today_upd
    BEFORE UPDATE
    ON random_people
    FOR EACH ROW
    EXECUTE PROCEDURE timestampp();

-- 2. B
CREATE TABLE people(
   first_name VARCHAR(40) ,
   last_name VARCHAR(40) ,
   date_of_birth date,
    age INTEGER
);
CREATE OR REPLACE FUNCTION age_add()
  RETURNS TRIGGER
  AS
$$
BEGIN
    UPDATE people
    SET
        age = round((current_date - people.date_of_birth) / 365.25)
    WHERE
          first_name = new.first_name;
	RETURN NEW;
END;
$$LANGUAGE PLPGSQL;
CREATE TRIGGER in_age
  AFTER INSERT
  ON people
  FOR EACH ROW
  EXECUTE FUNCTION age_add();

INSERT INTO people (first_name,last_name,date_of_birth)
VALUES ('Amina', 'Orazgali','2001-12-13');

INSERT INTO people (first_name, last_name,date_of_birth)
VALUES ('Aidana', 'Nurzhanova','2002-04-05');

SELECT * FROM people;

-- 2. C
CREATE TABLE products(
    id INTEGER PRIMARY KEY,
    name_of_product VARCHAR(80),
    price INTEGER,
    with_tax INTEGER
);

CREATE OR replace FUNCTION pricechange()
RETURNS TRIGGER AS
    $$
        BEGIN
            UPDATE products
            SET with_tax = price + 0.12 * price
            WHERE id = NEW.id;
            RETURN NEW;
        END;
    $$
LANGUAGE 'plpgsql';

CREATE TRIGGER cost AFTER INSERT ON products
    FOR EACH ROW EXECUTE PROCEDURE pricechange();
INSERT INTO products(id, name_of_product, price) VALUES(1, 'milk', 350);

INSERT INTO products(id, name_of_product, price) VALUES(2, 'cheese', 1260);

SELECT * FROM products;

-- 2. D
CREATE OR REPLACE FUNCTION check_deleting_row()
  RETURNS TRIGGER
  AS
$$
BEGIN
    RAISE EXCEPTION 'You cannot delete this row';
END
$$LANGUAGE PLPGSQL;
CREATE TRIGGER check_deletion
  BEFORE DELETE
  ON products
  FOR EACH ROW
  EXECUTE FUNCTION check_deleting_row();

SELECT * FROM products;
DELETE from products where name_of_product = 'cheese';

-- 2. E
CREATE TABLE functionseandd(
  name VARCHAR(255),
  password VARCHAR(255),
  number INTEGER,
  twooutputss VARCHAR(255),
  isValid boolean
);
CREATE OR replace FUNCTION functionsexecute() RETURNS trigger AS $emp_stamp$
    BEGIN
        new.isValid= passvalid(new.password);
        new.twooutputss = twooutputs(new.number);
        RETURN NEW;
    END;
$emp_stamp$ LANGUAGE 'plpgsql';
CREATE TRIGGER fuctionexecute BEFORE INSERT OR UPDATE ON functionseandd
    FOR EACH ROW EXECUTE FUNCTION functionsexecute();
INSERT INTO functionseandd(name, password, number)
VALUES ('Amina','Aa123abc',4);
SELECT * FROM functionseandd;

--3
/*
 The procedure enables both SELECT and DML (INSERT/UPDATE/DELETE) statements,
 whereas the function only accepts SELECT statements.
A SELECT statement cannot contain a procedure, although it can contain a function.
 */

-- 4
CREATE TABLE employee(
    salary INT,
    id INT PRIMARY KEY,
    name VARCHAR(120),
    birthday DATE,
    workexp INT,
    discount INT,
    age INT
);
INSERT INTO employee(salary, id, name, birthday, workexp, discount, age)
VALUES (1000000, 1, 'Amina', '2001-12-13', 9, 0, round((current_date - '2001-12-13') / 365.25));
INSERT INTO employee(salary, id, name, birthday, workexp, discount, age)
VALUES (1000000, 2, 'Aidana','2002-04-05', 6, 0, round((current_date - '2002-04-05') / 365.25));
-- 4. A
CREATE or REPLACE PROCEDURE diss() AS $$
    BEGIN
        UPDATE employee
        SET salary = (employee.workexp/2)*0.1*salary+salary,
            discount = 10
            WHERE employee.workexp >= 2;
        UPDATE employee
            SET
            discount = employee.discount+(employee.workexp/5)
                where employee.workexp >= 5;
        COMMIT;
    END;$$
LANGUAGE 'plpgsql';
CALL diss();
SELECT * FROM employee;

-- 4. B
CREATE OR replace PROCEDURE sallarry() AS
    $$
        BEGIN
            UPDATE employee
            SET salary = salary*1.15
            WHERE age >= 40;
            UPDATE employee
            SET salary = salary * 1.15 * (workexp / 8);
            UPDATE employee
            SET discount = 20 WHERE workexp >= 8;
            COMMIT;
        END;
    $$
LANGUAGE 'plpgsql';

INSERT INTO employee(salary, id, name, birthday, workexp, discount, age)
VALUES (1000000, 3, 'Madina','1974-09-03', 24, 0, round((current_date - '1974-09-03') / 365.25));
CALL sallarry();
SELECT * FROM employee;

-- 5
CREATE TABLE members(
    memid INTEGER,
    surname VARCHAR(200),
    firstname VARCHAR(200),
    address VARCHAR(300),
    zipcode INTEGER,
    telephone VARCHAR(20),
    recommendedby INTEGER,
    joindate TIMESTAMP
);
CREATE TABLE bookings(
    facid INTEGER,
    memid INTEGER,
    starttime TIMESTAMP,
    slots INTEGER
);
CREATE TABLE facilities(
    facid INTEGER,
    name VARCHAR(200),
    membercost NUMERIC,
    guestcost NUMERIC,
    initialoutlay NUMERIC,
    monthlymaintenance NUMERIC
);
WITH RECURSIVE recommenders(recommender, member) AS(
	SELECT recommendedby, memid
		FROM members
	UNION ALL
	SELECT mems.recommendedby, recs.member
		FROM recommenders recs
		INNER JOIN members mems
			ON mems.memid = recs.recommender
)
SELECT recs.member member, recs.recommender, mems.firstname, mems.surname
	FROM recommenders recs
	INNER JOIN members mems
		ON recs.recommender = mems.memid
	WHERE recs.member = 22 OR recs.member = 12
ORDER BY recs.member ASC, recs.recommender DESC