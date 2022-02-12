-- 1
CREATE TABLE drivers (
    id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(30) NOT NULL,
    last_name VARCHAR(30) NOT NULL,
    age INT NOT NULL,
    rating FLOAT DEFAULT 5.5
);
CREATE TABLE addresses (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);
CREATE TABLE clients (
    id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(50) NOT NULL,
    phone_number VARCHAR(20) NOT NULL
);
CREATE TABLE categories (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(10) NOT NULL
);
CREATE TABLE cars (
    id INT PRIMARY KEY AUTO_INCREMENT,
    make VARCHAR(20) NOT NULL,
    model VARCHAR(20),
    `year` INT NOT NULL DEFAULT 0,
    mileage INT DEFAULT 0,
    `condition` CHAR(1) NOT NULL,
    category_id INT NOT NULL,
    CONSTRAINT fk_cars_categories FOREIGN KEY (category_id)
        REFERENCES categories (id)
);
CREATE TABLE courses (
    id INT PRIMARY KEY AUTO_INCREMENT,
    from_address_id INT NOT NULL,
    start DATETIME NOT NULL,
    bill DECIMAL(10 , 2 ) DEFAULT 10,
    car_id INT NOT NULL,
    client_id INT NOT NULL,
    CONSTRAINT fk_courses_clients FOREIGN KEY (client_id)
        REFERENCES clients (id),
    CONSTRAINT fk_courses_cars FOREIGN KEY (car_id)
        REFERENCES cars (id),
        CONSTRAINT fk_courses_addresses
        FOREIGN KEY (from_address_id) REFERENCES addresses(id)
);
CREATE TABLE cars_drivers (
    car_id INT NOT NULL,
    driver_id INT NOT NULL,
    CONSTRAINT fk_carsDrivers_cars FOREIGN KEY (car_id)
        REFERENCES cars (id),
    CONSTRAINT fk_carsDrivers_drivers FOREIGN KEY (driver_id)
        REFERENCES drivers (id),
    CONSTRAINT PRIMARY KEY (car_id , driver_id)
);
-- 2 
INSERT INTO clients(full_name,phone_number)
(SELECT 
    CONCAT(first_name, ' ', last_name),
    CONCAT('(088) 9999', id * 2)
FROM
    drivers
WHERE
    id BETWEEN 10 AND 20);
    
-- 3
UPDATE cars AS c 
SET 
    `condition` = 'C'
WHERE
    mileage >= 800000 OR mileage IS NULL
        OR c.year > 2009
        OR c.make = 'Mercedes-Benz';

-- 4 
DELETE FROM clients as cc 
WHERE cc.id IN (SELECT id FROM (
SELECT 
    c.id
FROM
    clients AS c
        LEFT JOIN
    courses AS cr ON cr.client_id = c.id
WHERE
    cr.id IS NULL) as c );
-- 5
SELECT 
    make, model, `condition`
FROM
    cars
ORDER BY id;
-- 6
SELECT 
    d.first_name, d.last_name, c.make, c.model, c.mileage
FROM
    drivers AS d
        JOIN
    cars_drivers AS cd ON cd.driver_id = d.id
        JOIN
    cars AS c ON c.id = cd.car_id
WHERE
    c.mileage IS NOT NULL
ORDER BY c.mileage DESC , d.first_name ASC;
-- 7
SELECT 
    c.id,
    c.make,
    c.mileage,
    COUNT(car_id) AS counts,
    ROUND(AVG(cr.bill),2)
FROM
    cars AS c
        LEFT JOIN
    courses AS cr ON cr.car_id = c.id
GROUP BY c.id
HAVING counts != 2
ORDER BY counts DESC , c.id ASC;
-- 8
SELECT 
    cl.full_name,
    COUNT(c.client_id) AS count_of_cars,
    SUM(c.bill)
FROM
    courses AS c
        JOIN
    clients AS cl ON cl.id = c.client_id
WHERE
    cl.full_name LIKE '_a%'
GROUP BY c.client_id
HAVING count_of_cars > 1
ORDER BY cl.full_name ASC;
-- 9
SELECT 
    a.name,
    CASE
        WHEN HOUR(c.start) BETWEEN 6 AND 20 THEN 'Day'
        WHEN HOUR(c.start) IN (21 , 22, 23, 0, 1, 2, 3, 4, 5) THEN 'Night'
    END AS day_time,
    c.bill,
    cl.full_name,
    cr.make,
    cr.model,
    ctg.name
FROM
    courses AS c
        JOIN
    addresses AS a ON a.id = c.from_address_id
        JOIN
    clients AS cl ON cl.id = c.client_id
        JOIN
    cars AS cr ON cr.id = c.car_id
        JOIN
    categories AS ctg ON ctg.id = cr.category_id
ORDER BY c.id;
-- 10 
DELIMITER $$
CREATE FUNCTION udf_courses_by_client (phone_num VARCHAR (20)) 
RETURNS INTEGER
DETERMINISTIC
BEGIN
RETURN(SELECT 
    IF(COUNT(cr.client_id) = 0,
        0,
        COUNT(cr.client_id))
FROM
    clients AS c
        LEFT JOIN
    courses AS cr ON cr.client_id = c.id
WHERE
    c.phone_number = phone_num
GROUP BY cr.client_id);
END
$$
-- 11
CREATE PROCEDURE udp_courses_by_address(address_name VARCHAR(100))
BEGIN
SELECT 
    a.name,cl.full_name,
    CASE
        WHEN c.bill <= 20 THEN 'Low'
        WHEN c.bill <=30 THEN 'Medium'
        WHEN c.bill > 30 THEN 'High'
    END AS level_of_bill,
    cr.make,
    cr.`condition`,
    ctg.name
FROM
    courses AS c
        JOIN
    addresses AS a ON a.id = c.from_address_id
        JOIN
    clients AS cl ON cl.id = c.client_id
        JOIN
    cars AS cr ON cr.id = c.car_id
        JOIN
    categories AS ctg ON ctg.id = cr.category_id
    WHERE a.name = address_name
ORDER BY cr.make,cl.full_name;
END
$$ 