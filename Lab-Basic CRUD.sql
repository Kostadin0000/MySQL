SELECT id,first_name,last_name,job_title FROM employees
ORDER BY id ASC;

SELECT id, concat_ws(' ', first_name,last_name) AS full_name,
job_title,
salary FROM employees WHERE salary > 1000
ORDER BY id;

UPDATE employees
SET salary = salary + 100
WHERE job_title = 'Manager';
SELECT salary FROM employees;


CREATE VIEW `top_paid` AS
SELECT * FROM employees
ORDER BY salary DESC LIMIT 1;

SELECT * FROM employees
ORDER BY salary DESC LIMIT 1;

SELECT * FROM employees
WHERE salary >=1000 AND department_id = 4;

DELETE FROM employees
WHERE department_id BETWEEN 1 AND 2;
SELECT * FROM employees;

DROP SCHEMA soft_uni;