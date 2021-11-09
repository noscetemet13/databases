--TASK 1
--1a
SELECT * FROM dealer CROSS JOIN client;

--1b
SELECT c.name as client,c.city,c.priority,d.name as dealer ,s.id,s.date,s.amount FROM client c RIGHT OUTER JOIN dealer d ON c.dealer_id=d.id RIGHT OUTER JOIN sell s ON s.client_id = c.id;

--1c
SELECT dealer.id, dealer.name,client.id,client.name,client.city FROM dealer CROSS JOIN client WHERE dealer.location=client.city;

--1d
SELECT sell.id,amount,client.name,client.city FROM sell,client WHERE sell.client_id=client.id AND sell.amount BETWEEN 100 AND 500;

--1e
SELECT d.id, d.name, count(c.id) as "Clients number" FROM dealer d LEFT OUTER JOIN client c ON d.id = c.dealer_id GROUP BY d.id, d.name;

--1f
SELECT client.name,client.city,dealer.name, dealer.charge as "commission" FROM dealer INNER JOIN client ON dealer.id = client.dealer_id;

--1g
SELECT client.name,client.city,dealer.name, dealer.charge as "commission" FROM dealer,client WHERE dealer.id = client.dealer_id AND dealer.charge*100>12;

--1h
SELECT c.name, c.city,s.id,s.date,s.amount,d.name,d.charge as commission FROM client c LEFT OUTER JOIN sell s ON c.id = s.client_id LEFT OUTER JOIN dealer d on d.id = s.dealer_id;

--1i
SELECT c.name, c.priority,d.name,s.id,s.amount FROM client c RIGHT OUTER JOIN dealer d ON d.id=c.dealer_id LEFT OUTER JOIN sell s ON s.client_id= c.id WHERE s.amount>=2000 AND c.priority IS NOT NULL;

--TASK 2
--2a
CREATE TEMP VIEW by_date AS
SELECT date,count(DISTINCT client_id) clients,sum(amount) AS total,avg(amount) FROM sell GROUP BY date;

SELECT * from by_date;
--DROP VIEW by_date;

--2b
CREATE TEMP VIEW top5dates AS
SELECT * FROM by_date ORDER BY total DESC LIMIT 5;

SELECT * FROM top5dates;
--DROP VIEW top5dates;

--2c
CREATE VIEW dealers AS
SELECT d.id,d.name,count(DISTINCT s.id),sum(s.amount),avg(s.amount) FROM dealer d INNER JOIN sell s ON d.id = s.dealer_id GROUP BY d.id, d.name;

SELECT * FROM dealers;

--2d
CREATE VIEW dd AS
SELECT location,SUM(charge*amount) FROM dealer d LEFT JOIN sell s ON d.id = s.dealer_id GROUP BY location;

--2e
CREATE VIEW ee AS
SELECT location,count(DISTINCT s.id),SUM(amount) as sales,AVG(amount) FROM dealer d LEFT JOIN sell s ON d.id = s.dealer_id GROUP BY location;

--2f
CREATE VIEW ff AS
SELECT city,count(s.id),SUM(amount) as expenses,AVG(amount) FROM client c LEFT OUTER JOIN sell s ON s.client_id=c.id GROUP BY city;

--2g
CREATE VIEW comp AS
SELECT location as "Seller",city as "consumer",sales as "income", expenses as "consumption" FROM ee FULL OUTER JOIN ff ON location=city WHERE expenses>sales or sales is NULL or sales=0;

SELECT * FROM comp;
--DROP VIEW comp;