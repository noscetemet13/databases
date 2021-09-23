INSERT INTO customers values('1','Orazgali Amina Yerbolatkyzy','2021-09-23 10:20:10','Brusilovski 167');
INSERT INTO orders values(1,1,2000,true);
INSERT INTO products values(1,'broccoli','Edible green plant in the cabbage family',2000.00);
INSERT INTO order_items values(1,1,1);

UPDATE customers SET delivery_address='Aymanova 140' WHERE delivery_address='Brusilovski 167';
UPDATE orders SET total_sum=2600 where code=1;
UPDATE products SET price=1300.00 where name='broccoli';
UPDATE order_items SET quantity=2 where quantity = 1;

DELETE FROM order_items WHERE order_code=1;
DELETE FROM products WHERE name='broccoli';
DELETE FROM orders WHERE code=1;
DELETE FROM customers WHERE delivery_address='Aymanova 140';