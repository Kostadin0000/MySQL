SELECT title FROM books
WHERE title LIKE 'The%'
ORDER BY id;

SELECT replace(title,'The','***') AS title FROM books
WHERE title LIKE 'The%'
ORDER BY id;

SELECT ROUND(SUM(cost),2) from books;

SELECT concat(first_name,' ',last_name) AS 'Full Name',
timestampdiff(day,born,died) AS 'Days Lived' FROM authors;

SELECT title FROM books
WHERE title LIKE 'Harry Potter%'
ORDER BY id;