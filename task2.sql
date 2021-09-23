CREATE TABLE customers (
    id INT PRIMARY KEY,
    full_name VARCHAR(50) NOT NULL,
    timestamp TIMESTAMP NOT NULL,
    delivery_address TEXT NOT NULL)

CREATE TABLE orders (
    code INT PRIMARY KEY,
    customer_id INT NOT NULL,
    total_sum DOUBLE PRECISION NOT NULL CHECK ( total_sum>0 ),
    is_paid BOOLEAN NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers)

CREATE TABLE order_items (
    order_code INT,
    product_id VARCHAR NOT NULL,
    quantity INT NOT NULL CHECK ( quantity>0 ),
    PRIMARY KEY (order_code, product_id),
    FOREIGN KEY (order_code) REFERENCES orders,
    FOREIGN KEY (product_id) REFERENCES products)

CREATE TABLE products (
    id VARCHAR PRIMARY KEY,
    name VARCHAR NOT NULL,
    description TEXT NOT NULL,
    price DOUBLE PRECISION NOT NULL CHECK ( price>0 ))