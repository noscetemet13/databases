 CREATE TABLE stores(
     store_id INT PRIMARY KEY,
     city VARCHAR(15) NOT NULL,
     street_name VARCHAR(15) NOT NULL,
     street_num INT NOT NULL,
     opening_time VARCHAR(60) NOT NULL,
     closing_time VARCHAR(60) NOT NULL
);
CREATE TABLE brands(
    brand_id INT NOT NULL PRIMARY KEY,
    brand_name VARCHAR(16) NOT NULL
);
CREATE TABLE products(
    product_upc INT NOT NULL PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    package_type VARCHAR(20) NOT NULL,
    package_size VARCHAR(20) NOT NULL,
    product_price INT NOT NULL,
    brand_id INT NOT NULL REFERENCES brands(brand_id)
);
CREATE TABLE products_in_stock(
    store_id INT REFERENCES stores(store_id),
    product_upc INT NOT NULL REFERENCES products(product_upc),
    amount INT,
    PRIMARY KEY(store_id,product_upc)
);
CREATE TABLE product_type(
    type_id INT NOT NULL PRIMARY KEY,
    type_name VARCHAR(16) NOT NULL,
    product_upc INT NOT NULL REFERENCES products(product_upc)
);
CREATE TABLE vendors(
    vendor_id INT NOT NULL,
    vendor_name VARCHAR(30) NOT NULL,
    brand_id INT NOT NULL REFERENCES brands(brand_id),
    store_id INT NOT NULL REFERENCES stores(store_id),
    PRIMARY KEY (vendor_id, vendor_name)
);
CREATE TABLE customer(
    customer_id INT NOT NULL PRIMARY KEY,
    first_name VARCHAR(20) NOT NULL,
    last_name VARCHAR(20) NOT NULL
);
CREATE TABLE frequent_customer(
    customer_id INT NOT NULL PRIMARY KEY REFERENCES customer(customer_id),
    date_of_birth DATE NOT NULL,
    age INT,
    bonus_card_upc INT NOT NULL
);
CREATE TABLE phone_numbers(
    customer_id INT NOT NULL REFERENCES customer(customer_id),
    phone_number VARCHAR(20) NOT NULL PRIMARY KEY
);

CREATE TABLE online_customer(
    id INT NOT NULL PRIMARY KEY REFERENCES customer(customer_id),
    city VARCHAR(15) NOT NULL,
    street_name VARCHAR(15) NOT NULL,
    street_num INT NOT NULL,
    app_num INT NOT NULL,
    email VARCHAR(60) NOT NULL
);
CREATE TABLE payments(
    payment_id INT NOT NULL PRIMARY KEY,
    customer_id INT NOT NULL REFERENCES customer(customer_id),
    sum INT NOT NULL,
    payment_type VARCHAR(20) NOT NULL,
    store_id INT NOT NULL REFERENCES stores(store_id),
    date_of_payment DATE NOT NULL
);
CREATE TABLE cart(
    id INT NOT NULL PRIMARY KEY,
    product_upc INT NOT NULL REFERENCES products(product_upc),
    id_payment INT NOT NULL REFERENCES payments(payment_id),
    amount INT NOT NULL
);

CREATE INDEX payment_search ON payments(payment_id);
CREATE INDEX customer_search ON customer(customer_id);
CREATE INDEX product_search ON products(product_upc);

CREATE OR REPLACE FUNCTION age_add()
  RETURNS TRIGGER
  AS
$$
BEGIN
    UPDATE frequent_customer
    SET
        age = floor((current_date - frequent_customer.date_of_birth) / 365.25)
    WHERE
          customer_id = new.customer_id;
	RETURN NEW;
END;
$$LANGUAGE PLPGSQL;
CREATE TRIGGER in_age
  AFTER INSERT
  ON frequent_customer
  FOR EACH ROW
  EXECUTE FUNCTION age_add();