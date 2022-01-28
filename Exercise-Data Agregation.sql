SELECT COUNT(*) AS 'count' FROM wizzard_deposits;

SELECT MAX(magic_wand_size) AS 'longest_magic_wand' FROM wizzard_deposits;

SELECT deposit_group,MAX(magic_wand_size) AS 'longest_magic_wand' 
FROM wizzard_deposits
GROUP BY deposit_group
ORDER BY longest_magic_wand asc,
deposit_group;

SELECT deposit_group FROM wizzard_deposits
GROUP BY deposit_group 
HAVING AVG(magic_wand_size) LIMIT 1;

SELECT deposit_group,SUM(deposit_amount) AS total_sum FROM wizzard_deposits
GROUP BY deposit_group
ORDER BY total_sum; 

SELECT deposit_group,SUM(deposit_amount) AS total_sum FROM wizzard_deposits
WHERE magic_wand_creator = 'Ollivander family'
GROUP BY deposit_group
ORDER BY deposit_group;

SELECT deposit_group,SUM(deposit_amount) AS total_sum FROM wizzard_deposits
WHERE magic_wand_creator = 'Ollivander family'
GROUP BY deposit_group
HAVING total_sum < 150000
ORDER BY total_sum DESC;

SELECT deposit_group,magic_wand_creator,MIN(deposit_charge) AS min_deposit_charge
FROM wizzard_deposits 
GROUP BY deposit_group,magic_wand_creator
ORDER BY magic_wand_creator,
deposit_group;

--
SELECT 
    CASE
        WHEN age BETWEEN 0 AND 10 THEN '[0-10]'
        WHEN age BETWEEN 11 AND 20 THEN '[11-20]'
        WHEN age BETWEEN 21 AND 30 THEN '[21-30]'
        WHEN age BETWEEN 31 AND 40 THEN '[31-40]'
        WHEN age BETWEEN 41 AND 50 THEN '[41-50]'
        WHEN age BETWEEN 51 AND 60 THEN '[51-60]'
        ELSE '[61+]'
    END AS age_group,
    COUNT(*) AS age_count
FROM
    wizzard_deposits
GROUP BY age_group
ORDER BY age_count;

SELECT LEFT(first_name,1) as 'first_letter' FROM wizzard_deposits
WHERE deposit_group = 'Troll Chest'
GROUP BY first_letter
ORDER BY first_letter;

SELECT 
    deposit_group,
    is_deposit_expired,
    AVG(deposit_interest) AS 'average_interest'
FROM
    wizzard_deposits
WHERE
 -- YEAR(deposit_start_date) >= 1985
 `deposit_start_date` > '1985-01-01'
GROUP BY  deposit_group, is_deposit_expired
ORDER BY deposit_group DESC , is_deposit_expired ASC;

 -- --------------------------------------------

-- Part 2 Softuni database

SELECT department_id,MIN(salary) FROM employees
WHERE department_id IN(2,5,7) AND  YEAR(hire_date) >= 2000
        and MONTH(hire_date) >= 1
        and DAY(hire_date) >= 1
GROUP BY department_id
ORDER BY department_id asc;


SELECT department_id,MAX(salary) AS 'max_salary' FROM employees
GROUP BY department_id
HAVING max_salary NOT BETWEEN 30000 AND 70000
ORDER BY department_id;

SELECT 
    COUNT(*)
FROM
    employees
GROUP BY manager_id
HAVING manager_id IS NULL;

SELECT department_id,MAX(salary) as 's' FROM employees
GROUP BY department_id 
ORDER BY salary asc ;

SELECT department_id,SUM(salary) as total_salary
FROM employees
GROUP BY department_id
ORDER BY department_id;


SELECT department_id, IF(department_id = 1,AVG(salary) + 5000,AVG(salary)) FROM employees
WHERE salary > 30000 AND manager_id != 42
GROUP BY  department_id
ORDER BY department_id;

SELECT 
    department_id,
    (SELECT DISTINCT
            salary
        FROM
            employees AS e2
        WHERE
            e1.department_id = e2.department_id
        ORDER BY salary DESC
        LIMIT 2 , 1) AS 'third_highest_salary'
FROM
    employees AS e1
GROUP BY department_id
HAVING third_highest_salary
ORDER BY department_id;

SELECT 
    e1.first_name, e1.last_name, e1.department_id
FROM
    employees AS e1
        JOIN
    (SELECT 
        e2.department_id, AVG(e2.salary) AS salary
    FROM
        employees AS e2
    GROUP BY e2.department_id) AS dep_average ON e1.department_id = dep_average.department_id
WHERE
    e1.salary > dep_average.salary
ORDER BY e1.department_id , e1.employee_id
LIMIT 10;