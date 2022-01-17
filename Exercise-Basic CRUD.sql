SELECT * FROM departments
ORDER BY department_id ASC;

SELECT name FROM departments
ORDER BY department_id;

SELECT first_name,last_name,salary FROM employees
ORDER BY employee_id;

SELECT first_name,middle_name,last_name FROM employees
ORDER BY employee_id;

SELECT concat(first_name,'.',last_name,'@','softuni.bg') 
AS 'full_email_address' FROM employees;

SELECT DISTINCT salary FROM employees
ORDER BY salary asc;

SELECT * FROM employees
WHERE job_title = 'Sales Representative'
ORDER BY employee_id ;

SELECT first_name,last_name,job_title FROM employees
WHERE salary BETWEEN 20000 AND 30000;

SELECT concat_ws(' ',first_name,middle_name,last_name) 
AS 'Full Name' FROM employees
WHERE salary IN(25000,14000,12500,23600);

SELECT first_name,last_name FROM employees
WHERE manager_id IS NULL;

SELECT first_name,last_name,salary FROM employees
WHERE salary > 50000
ORDER BY salary desc;

SELECT first_name,last_name FROM employees
ORDER BY salary desc LIMIT 5;

SELECT first_name,last_name FROM employees
WHERE department_id != 4;

SELECT * FROM employees
ORDER BY salary desc,
first_name asc,
last_name desc,
middle_name asc,
employee_id;

CREATE VIEW `v_employees_salaries` AS
SELECT first_name,last_name,salary FROM employees;

CREATE VIEW `v_employees_job_titles` AS 
SELECT concat_ws(' ',first_name,middle_name,last_name) 
AS full_name,job_title FROM employees;

SELECT DISTINCT job_title FROM employees
ORDER BY job_title asc;

SELECT * FROM projects
ORDER BY start_date,
name asc LIMIT 10;

SELECT first_name,last_name,hire_date FROM employees
ORDER BY hire_date desc LIMIT 7;

UPDATE employees
SET salary = salary * 1.12
WHERE department_id IN (1,2,4,11);
SELECT salary FROM employees;

