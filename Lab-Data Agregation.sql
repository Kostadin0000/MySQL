SELECT 
    department_id, COUNT(*) AS 'Number of employees'
FROM
    employees
GROUP BY department_id;

SELECT 
    department_id, ROUND(AVG(salary),2) AS 'Average Salary'
FROM
    employees
GROUP BY department_id;

SELECT 
    department_id, ROUND(MIN(salary),2) AS 'Min Salary'
FROM
    employees
GROUP BY department_id
HAVING `Min Salary` > 800;

SELECT COUNT(category_id) FROM products
WHERE price > 8
GROUP BY category_id
HAVING category_id = 2;

SELECT category_id,ROUND(AVG(price),2),ROUND(min(price),2),ROUND(max(price),2)
FROM products
GROUP BY category_id;