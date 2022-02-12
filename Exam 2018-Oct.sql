-- 9
SELECT 
    REVERSE(s.name) AS reversed_name,
    CONCAT(UPPER(t.name), '-', a.name) AS full_address,
    COUNT(*) AS emp_count
FROM
    stores AS s
        JOIN
    employees AS e ON e.store_id = s.id
         JOIN
    addresses AS a ON a.id = s.address_id
         JOIN
    towns AS t ON t.id = a.town_id
GROUP BY s.id
ORDER BY full_address asc;
-- 10
DELIMITER $$
CREATE FUNCTION udf_top_paid_employee_by_store(store_name VARCHAR(50)) 
RETURNS TEXT
DETERMINISTIC
BEGIN
RETURN(SELECT 
    CONCAT(e.first_name,
            ' ',
            e.middle_name,
            '. ',
            e.last_name,
            ' works in store for ',
            ABS(YEAR(e.hire_date) - YEAR('2020-10-18')),
            ' years')
FROM
    employees AS e
        JOIN
    stores AS s ON s.id = e.store_id
WHERE
    s.name = store_name
ORDER BY e.salary DESC
LIMIT 1);
END
$$
SELECT 
    CONCAT(e.first_name,
            ' ',
            e.middle_name,
            '. ',
            e.last_name,
            'works in store for ',
            ABS(YEAR(e.hire_date) - YEAR('2020-10-18')),
            ' years')
FROM
    employees AS e
        JOIN
    stores AS s ON s.id = e.store_id
WHERE
    s.name = 'Stronghold'
ORDER BY e.salary DESC
LIMIT 1;
$$
-- 11
CREATE PROCEDURE udp_update_product_price (address_name VARCHAR (50))
BEGIN
UPDATE products AS p
        JOIN
    products_stores AS ps ON ps.product_id = p.id
        JOIN
    stores AS s ON s.id = ps.store_id
        JOIN
    addresses AS a ON a.id = s.address_id 
SET 
    p.price = IF(address_name LIKE '0%',
        p.price + 100,
        p.price + 200)
        WHERE a.name = address_name;
END
$$


UPDATE products AS p
        JOIN
    products_stores AS ps ON ps.product_id = p.id
        JOIN
    stores AS s ON s.id = ps.store_id
        JOIN
    addresses AS a ON a.id = s.address_id 
SET 
    p.price = IF('07 Armistice Parkway' LIKE '0%',
        p.price + 100.00,
        p.price + 200.00)
WHERE
    a.name = '07 Armistice Parkway';
$$


CALL udp_update_product_price('07 Armistice Parkway');
