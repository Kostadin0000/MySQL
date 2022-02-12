-- 1
CREATE SCHEMA ruk_database;
USE ruk_database;

CREATE TABLE branches (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(30) UNIQUE NOT NULL
);
CREATE TABLE employees (
    id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(20) NOT NULL,
    last_name VARCHAR(20) NOT NULL,
    salary DECIMAL(10 , 2 ) NOT NULL,
    started_on DATE NOT NULL,
    branch_id INT NOT NULL,
    CONSTRAINT fk_employees_branches FOREIGN KEY (branch_id)
        REFERENCES branches (id)
);
CREATE TABLE clients (
    id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(50) NOT NULL,
    age INT NOT NULL
);
CREATE TABLE employees_clients (
    employee_id INT,
    client_id INT,
    CONSTRAINT fk_mapped_employees FOREIGN KEY (employee_id)
        REFERENCES clients (id),
    CONSTRAINT fk_mapped_clients FOREIGN KEY (client_id)
        REFERENCES clients (id)
);
CREATE TABLE bank_accounts (
    id INT PRIMARY KEY AUTO_INCREMENT,
    account_number VARCHAR(10) NOT NULL,
    balance DECIMAL(10 , 2 ) NOT NULL,
    client_id INT NOT NULL UNIQUE,
    CONSTRAINT fk_bacc_clients FOREIGN KEY (client_id)
        REFERENCES clients (id)
);
CREATE TABLE cards (
    id INT PRIMARY KEY AUTO_INCREMENT,
    card_number VARCHAR(19) NOT NULL,
    card_status VARCHAR(7) NOT NULL,
    bank_account_id INT NOT NULL,
    CONSTRAINT fk_cards_bacc FOREIGN KEY (bank_account_id)
        REFERENCES bank_accounts (id)
);
-- 2
INSERT INTO cards(card_number,card_status,bank_account_id)
(SELECT reverse(full_name),'Active',id FROM clients
WHERE id between 191 and 200);

-- 3

UPDATE clients AS c
        JOIN
    employees_clients AS ec ON ec.client_id = c.id 
SET 
    ec.employee_id = (SELECT 
            employee_id
        FROM
            (SELECT 
                employee_id, COUNT(*) AS count
            FROM
                employees_clients
            GROUP BY employee_id
            ORDER BY count ASC , employee_id ASC
            LIMIT 1) AS c)
WHERE
    ec.employee_id = ec.client_id;

SELECT 
    employee_id, COUNT(*) AS count
FROM
    employees_clients
GROUP BY employee_id
ORDER BY count ASC , employee_id ASC
LIMIT 1;

-- 4
DELETE FROM employees  as e
WHERE e.id in(SELECT id FROM
    (SELECT 
    id
FROM
    employees AS e
        LEFT JOIN
    employees_clients AS ec ON ec.employee_id = e.id
WHERE
    ec.client_id IS NULL)as c);
    
       SELECT 
    id
FROM
    employees AS e
        LEFT JOIN
    employees_clients AS ec ON ec.client_id = e.id
WHERE
    ec.client_id IS NULL;
-- 5
SELECT 
    id, full_name
FROM
    clients
ORDER BY id ASC;
-- 6
SELECT 
    id,
    CONCAT(first_name, ' ', last_name) AS full_name,
    CONCAT('$', salary) AS salary,
    started_on
FROM
    employees
WHERE
    salary >= 100000
        AND started_on >= '2018-01-01'
ORDER BY salary DESC , id;

-- 7 
SELECT 
    c.id,
    CONCAT(c.card_number, ' : ', cl.full_name) AS card_token
FROM
    clients AS cl
        JOIN
    bank_accounts AS ba ON ba.client_id = cl.id
        JOIN
    cards AS c ON c.bank_account_id = ba.id
ORDER BY c.id DESC;
-- 8
SELECT 
    CONCAT(e.first_name, ' ', e.last_name),
    e.started_on,
    COUNT(*) AS count_of_clients
FROM
    employees AS e
        JOIN
    employees_clients AS ec ON ec.employee_id = e.id
GROUP BY ec.employee_id
ORDER BY count_of_clients DESC , ec.employee_id ASC LIMIT 5;
-- 9
SELECT 
    b.name, IFNULL(COUNT(cr.bank_account_id), 0) AS count
FROM
    branches AS b
        LEFT JOIN
    employees AS e ON e.branch_id = b.id
        LEFT JOIN
    employees_clients AS ec ON ec.employee_id = e.id
        LEFT JOIN
    clients AS c ON c.id = ec.client_id
        LEFT JOIN
    bank_accounts AS ba ON ba.client_id = c.id
        LEFT JOIN
    cards AS cr ON cr.bank_account_id = ba.id
GROUP BY b.id
ORDER BY count DESC , b.name;
-- 10 
DELIMITER $$
CREATE FUNCTION udf_client_cards_count(name VARCHAR(30))
RETURNS INT
DETERMINISTIC
BEGIN 
RETURN(SELECT count(*) FROM clients as c
JOIN bank_accounts as ba on ba.client_id = c.id
JOIN cards as cr on cr.bank_account_id = ba.id 
WHERE c.full_name = name);

END 
$$
SELECT 
    c.full_name, COUNT(*)
FROM
    clients AS c
        JOIN
    bank_accounts AS ba ON ba.client_id = c.id
        JOIN
    cards AS cr ON cr.bank_account_id = ba.id
WHERE
    c.full_name = 'Baxy David';

-- 11

CREATE PROCEDURE udp_clientinfo (full_name VARCHAR(100))
BEGIN
SELECT c.full_name,c.age,ba.account_number,CONCAT('$',ba.balance) FROM clients as c
JOIN bank_accounts as ba on ba.client_id = c.id
WHERE c.full_name = full_name;
END
$$
SELECT c.full_name,c.age,ba.account_number,CONCAT('$',ba.balance)FROM clients as c
JOIN bank_accounts as ba on ba.client_id = c.id
WHERE c.full_name = 'Hunter Wesgate';

DELIMITER ;