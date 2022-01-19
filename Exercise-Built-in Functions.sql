-- PART 1 soft_uni database
SELECT first_name,last_name FROM employees
WHERE first_name LIKE 'Sa%'
ORDER BY employee_id;

SELECT first_name,last_name FROM employees
WHERE last_name LIKE '%ei%'
ORDER BY employee_id;

SELECT 
    first_name
FROM
    employees
WHERE
    department_id IN (3 , 10)
        AND YEAR(hire_date) BETWEEN 1995 AND 2005
        ORDER BY employee_id;
 
SELECT first_name,last_name FROM employees
WHERE job_title NOT LIKE '%engineer%'
ORDER BY employee_id;

SELECT name FROM towns
WHERE char_length(name) IN (5,6)
ORDER BY name asc;

SELECT * FROM towns
WHERE name LIKE 'M%' 
OR name LIKE 'K%' 
OR name LIKE 'B%' 
OR name LIKE 'E%'
ORDER BY name asc;

SELECT * FROM towns
WHERE name NOT LIKE 'R%' 
AND name NOT LIKE 'B%' 
AND name NOT LIKE 'D%'
ORDER BY name asc;

CREATE VIEW v_employees_hired_after_2000 AS 
SELECT first_name,last_name FROM employees
WHERE YEAR(hire_date) > 2000;

SELECT first_name,last_name FROM employees
WHERE char_length(last_name) = 5;

-- Part 2 Geography Database 

SELECT country_name,iso_code FROM countries
WHERE country_name LIKE '%a%a%a%'
ORDER BY iso_code;

SELECT 
    peak_name,
    river_name,
    CONCAT(LOWER(peak_name), LOWER(substring(river_name,2))) AS mix
FROM
    peaks
        INNER JOIN
    rivers ON SUBSTRING(REVERSE(peak_name), 1, 1) = SUBSTRING(river_name, 1, 1)
    ORDER BY mix asc;
    
-- Part 3 Diablo database

SELECT name,date_format(start, '%Y-%m-%d') as start FROM games
WHERE YEAR(start) IN(2011,2012)
ORDER BY start,
name asc LIMIT 50;

SELECT 
    user_name,
    SUBSTRING(email,
        LOCATE('@', email) + 1,
        CHAR_LENGTH(email)) AS 'email provider'
FROM
    users
ORDER BY `email provider` ASC , user_name ASC;

SELECT user_name,ip_address FROM users
WHERE ip_address LIKE '___.1%.%.___'
ORDER BY user_name asc; 

SELECT 
    name AS game,
    CASE
        WHEN HOUR(start) >= 0 AND HOUR(start) < 12 THEN 'Morning'
        WHEN HOUR(start) >= 12 AND HOUR(start) < 18 THEN 'Afternoon'
        ELSE 'Evening'
    END AS 'Part of the Day',
    CASE
        WHEN duration <= 3 THEN 'Extra Short'
        WHEN duration > 3 AND duration <= 6 THEN 'Short'
        WHEN duration > 6 AND duration <= 10 THEN 'Long'
        ELSE 'Extra Long'
    END AS 'Duration'
FROM
    games;

-- Part 4 Orders

SELECT product_name,order_date,
date_add(order_date, INTERVAL 3 DAY) AS pay_due,
date_add(order_date,INTERVAL 1 MONTH) AS delivery_due
 FROM orders;
 
 