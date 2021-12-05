CREATE OR REPLACE FUNCTION TOP20STORES(idstore INT)
RETURNS TABLE(
    product_upc INT,
    product_name VARCHAR,
    amount INT
    )
AS $$
    BEGIN
        RETURN QUERY SELECT c.product_upc:: INT, p.product_name:: VARCHAR, count(*):: INT
        FROM payments INNER JOIN cart c on payments.payment_id = c.id_payment INNER JOIN products p on c.product_upc = p.product_upc
        WHERE store_id = idstore
        GROUP BY  c.product_upc, p.product_name ORDER BY count(*) DESC
        LIMIT 20;
    END;
$$
LANGUAGE plpgsql;
SELECT * FROM TOP20STORES(1);

CREATE OR REPLACE FUNCTION TOP20CITIES(cityname VARCHAR)
RETURNS TABLE(
    product_upc INT,
    product_name VARCHAR,
    amount INT
    )
AS $$
    BEGIN
        RETURN QUERY SELECT c.product_upc:: INT, p.product_name:: VARCHAR, count(*):: INT
        FROM payments INNER JOIN cart c on payments.payment_id = c.id_payment INNER JOIN products p on c.product_upc = p.product_upc INNER JOIN stores s on payments.store_id = s.store_id
        WHERE city = cityname
        GROUP BY c.product_upc, p.product_name ORDER BY count(*) DESC
        LIMIT 20;
    END;
$$
LANGUAGE plpgsql;
SELECT * FROM TOP20CITIES('Almaty');

SELECT store_id, count(*)
FROM project.payments WHERE date_part("YYYY", date_of_payment) = 2021 GROUP BY store_id ORDER BY count(*) DESC
LIMIT 5;

SELECT count(*)
FROM(
    SELECT store_id FROM stores WHERE store_id IN (
        SELECT cokee.id from (SELECT payments.store_id as id, count(*) as cnt FROM payments INNER JOIN cart c on payments.payment_id = c.id_payment INNER JOIN products p on c.product_upc = p.product_upc
        WHERE product_name = 'coca-cola' GROUP BY payments.store_id
        ) AS cokee
        INNER JOIN
        (
        SELECT payments.store_id as id1, count(*) as cnt FROM payments INNER JOIN cart c on payments.payment_id = c.id_payment INNER JOIN products p on c.product_upc = p.product_upc
        WHERE product_name = 'pepsi' GROUP BY payments.store_id
        ) AS pepsii
        ON cokee.id = pepsii.id1
        WHERE cokee.cnt > pepsii.cnt
    )
) AS foo;

SELECT type, count(*) FROM(
    SELECT product_type.type_name AS type,cart.id_payment FROM product_type INNER JOIN cart ON product_type.product_upc = cart.product_upc
    WHERE cart.id_payment IN (
            SELECT cart.id_payment
            FROM cart INNER JOIN product_type pt ON cart.product_upc = pt.product_upc
            WHERE product_type.type_name = 'milk'
        )
) AS foo
GROUP BY type
ORDER BY count(*) DESC
limit 5;