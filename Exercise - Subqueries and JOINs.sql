-- 1
SELECT 
    employee_id, job_title, e.address_id, address_text
FROM
    employees AS e
        JOIN
    addresses AS a ON e.address_id = a.address_id
ORDER BY address_id ASC LIMIT 5; 

-- 2
SELECT 
    first_name, last_name, t.name, a.address_text
FROM
    employees AS e
        JOIN
    addresses AS a ON e.address_id = a.address_id
        JOIN
    towns AS t ON a.town_id = t.town_id
ORDER BY first_name ASC,last_name
LIMIT 5; 

-- 3
SELECT employee_id , first_name,last_name,d.name
FROM employees as e
JOIN departments as d ON e.department_id = d.department_id
WHERE d.name = 'Sales'
ORDER BY employee_id desc;
-- 4
SELECT employee_id,first_name,salary,d.name FROM employees as e
JOIN departments as d on e.department_id = d.department_id
WHERE salary > 15000
ORDER BY d.department_id desc LIMIT 5;
-- 5
SELECT 
    e.employee_id, first_name
FROM
    employees AS e
        LEFT JOIN
    employees_projects AS p ON e.employee_id = p.employee_id
WHERE
    project_id IS NULL
ORDER BY employee_id DESC
LIMIT 3;
-- 6
SELECT first_name , last_name , hire_date,d.name FROM
employees as e
JOIN departments as d ON e.department_id = d.department_id
WHERE (d.name = 'Sales' or d.name = 'Finance' ) and hire_date > '1999-01-01'
ORDER BY hire_date asc;
-- 7
SELECT 
    e.employee_id, e.first_name, p1.name 
FROM
    employees AS e
       RIGHT JOIN
    employees_projects AS p ON e.employee_id = p.employee_id
        JOIN
    projects AS p1 ON p1.project_id = p.project_id
WHERE
    DATE(p1.start_date) > '2002-08-13'
        AND end_date IS NULL 
ORDER BY e.first_name asc , p1.name asc
LIMIT 5;

-- 8
SELECT 
    e.employee_id,
    e.first_name,
    IF(YEAR(p1.start_date) > 2004,
        NULL,
        p1.name) as project_name
FROM
    employees AS e
        LEFT JOIN
    employees_projects AS p ON e.employee_id = p.employee_id
        LEFT JOIN
    projects AS p1 ON p1.project_id = p.project_id
WHERE
    e.employee_id = 24
ORDER BY project_name ASC;
-- 9
SELECT employee_id , first_name,manager_id as `m`,(SELECT first_name FROM employees
where employee_id = `m`)
FROM employees as e
WHERE manager_id in(3,7)
order by first_name asc;
-- 10
SELECT 
    e.employee_id,
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    CONCAT(e1.first_name, ' ', e1.last_name) AS manager_name,
    d.name
FROM
    employees AS e
        JOIN
    departments AS d ON e.department_id = d.department_id
        JOIN
    employees AS e1 ON e.manager_id = e1.employee_id
     where e.manager_id is not null
ORDER BY employee_id LIMIT 1000;
-- 11
SELECT avg(salary) as min_average_salary from employees
GROUP BY department_id order by min_average_salary limit 1;
-- 12
USE geography;
SELECT country_code,mountain_range,peak_name,elevation
FROM mountains_countries as mc
JOIN mountains as m on mc.mountain_id = m.id
JOIN peaks as p on p.mountain_id = m.id
WHERE country_code = 'BG' and elevation > 2835 
order by elevation desc;

-- 13
SELECT country_code,COUNT(mountain_range) as count FROM mountains_countries
as mc JOIN mountains as m on m.id = mc.mountain_id
WHERE mc.country_code in('BG','RU','US')
GROUP BY mc.country_code
ORDER BY count desc;

-- 14
SELECT country_name,river_name FROM countries
as c LEFT JOIN countries_rivers as cr on c.country_code = cr.country_code
LEFT JOIN rivers as r on r.id = cr.river_id
WHERE c.continent_code = 'AF'
order by country_name asc limit 5;
-- 15
SELECT 
    continent_code, currency_code, COUNT(*) AS c
FROM
    countries AS c
GROUP BY currency_code , continent_code
HAVING c = (SELECT 
        COUNT(currency_code) AS coun
    FROM
        countries AS c1
    WHERE
        c1.continent_code = c.continent_code
    GROUP BY currency_code
    ORDER BY coun DESC
    LIMIT 1)
    AND c > 1
ORDER BY continent_code , currency_code;



-- 16
SELECT count(*) from countries
as c LEFT join mountains_countries as mc
on mc.country_code = c.country_code
WHERE mc.mountain_id is null;
-- 17
SELECT
    c.country_name AS C,
    MAX(p.elevation) as ma, MAX(r.length) as na
FROM
    countries AS c
        RIGHT JOIN
    mountains_countries AS mc ON c.country_code = mc.country_code
        RIGHT JOIN
    peaks AS p ON mc.mountain_id = p.mountain_id
        RIGHT JOIN
    countries_rivers AS cr ON cr.country_code = c.country_code
        RIGHT JOIN
    rivers AS r ON r.id = cr.river_id
    GROUP BY c.country_code
ORDER BY ma DESC , na DESC , c.country_name ASC
limit 5;