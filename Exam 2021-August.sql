-- 1
CREATE TABLE addresses (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL
);
CREATE TABLE categories (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(10) NOT NULL
);
CREATE TABLE offices (
    id INT PRIMARY KEY AUTO_INCREMENT,
    workspace_capacity INT NOT NULL,
    website VARCHAR(50),
    address_id INT NOT NULL,
    CONSTRAINT fk_office_address FOREIGN KEY (address_id)
        REFERENCES addresses (id)
);
CREATE TABLE employees (
    id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(30) NOT NULL,
    last_name VARCHAR(30) NOT NULL,
    age INT NOT NULL,
    salary DECIMAL(10 , 2 ) NOT NULL,
    job_title VARCHAR(20) NOT NULL,
    happiness_level CHAR(1) NOT NULL
);
CREATE TABLE teams (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(40) NOT NULL,
    office_id INT NOT NULL,
    leader_id INT UNIQUE NOT NULL,
    CONSTRAINT fk_teams_office FOREIGN KEY (office_id)
        REFERENCES offices (id),
    CONSTRAINT fk_teams_employees FOREIGN KEY (leader_id)
        REFERENCES employees (id)
);
CREATE TABLE games (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL UNIQUE,
    `description` TEXT,
    rating FLOAT NOT NULL DEFAULT 5.5,
    budget DECIMAL(10 , 2 ) NOT NULL,
    release_date DATE,
    team_id INT NOT NULL,
    CONSTRAINT fk_games_teams FOREIGN KEY (team_id)
        REFERENCES teams (id)
);
CREATE TABLE games_categories (
    game_id INT NOT NULL,
    category_id INT NOT NULL,
    CONSTRAINT PRIMARY KEY (game_id , category_id),
    CONSTRAINT fk_mapped_games FOREIGN KEY (game_id)
        REFERENCES games (id),
    CONSTRAINT fk_mapped_categories FOREIGN KEY (category_id)
        REFERENCES categories (id)
);
-- 2 
INSERT INTO games(name,rating,budget,team_id)
(SELECT lower(reverse(substring(name,2))),id,leader_id*1000,id FROM teams
WHERE id BETWEEN 1 AND 9);
-- 3
UPDATE employees AS e
        JOIN
    teams AS t ON t.leader_id = e.id 
SET 
    salary = salary + 1000
WHERE
    e.age < 40 AND e.salary < 5000;
-- 4
DELETE FROM games as g1 
WHERE g1.release_date is null and id in (SELECT id FROM(SELECT id FROM games as g
LEFT JOIN games_categories as gc on gc.game_id = g.id 
WHERE gc.category_id is null) as c);


SELECT 
    *
FROM
    games AS g
        LEFT JOIN
    games_categories AS gc ON gc.game_id = g.id
WHERE
    gc.category_id IS NULL;
-- 5
SELECT 
    first_name, last_name, age, salary, happiness_level
FROM
    employees
ORDER BY salary , id;
-- 6
SELECT 
    t.name AS team_name,
    a.name AS address_name,
    CHAR_LENGTH(a.name) AS count_of_characters
FROM
    teams AS t
        JOIN
    offices AS o ON o.id = t.office_id
        JOIN
    addresses AS a ON a.id = o.address_id
WHERE
    o.website IS NOT NULL
ORDER BY team_name , address_name;
-- 7
SELECT 
    c.name AS name,
    COUNT(*) AS games_count,
    ROUND(AVG(g.budget), 2) AS avg_budget,
    MAX(g.rating) AS max_rating
FROM
    games AS g
        JOIN
    games_categories AS gc ON gc.game_id = g.id
        JOIN
    categories AS c ON c.id = gc.category_id
GROUP BY gc.category_id
HAVING max_rating > 9.4
ORDER BY games_count DESC , name ASC;
-- 8
SELECT 
    g.name,
    g.release_date,
    CONCAT(LEFT(g.description, 10), '...') AS summary,
    CASE
        WHEN MONTH(g.release_date) IN (1 , 2, 3) THEN 'Q1'
        WHEN MONTH(g.release_date) IN (4 , 5, 6) THEN 'Q2'
        WHEN MONTH(g.release_date) IN (7 , 8, 9) THEN 'Q3'
        WHEN MONTH(g.release_date) IN (10 , 11, 12) THEN 'Q4'
    END AS `quarter`,
    t.name
FROM
    games AS g
        JOIN
    teams AS t ON t.id = g.team_id
WHERE
    g.name LIKE '%_2'
        AND MONTH(g.release_date) % 2 = 0
        AND YEAR(g.release_date) = 2022
ORDER BY `quarter`;
-- 9
SELECT 
    g.name,
    CASE
        WHEN g.budget < 50000 THEN 'Normal budget'
        WHEN g.budget >= 50000 THEN 'Insufficient budget'
    END AS budget_level,
    t.name AS team_name,
    a.name AS address_name
FROM
    games AS g
        LEFT JOIN
    games_categories AS gc ON gc.game_id = g.id
        JOIN
    teams AS t ON t.id = g.team_id
        JOIN
    offices AS o ON o.id = t.office_id
        JOIN
    addresses AS a ON a.id = o.address_id
WHERE
    gc.category_id IS NULL
        AND g.release_date IS NULL
ORDER BY g.name;
-- 10
DELIMITER $$
CREATE FUNCTION udf_game_info_by_name (game_name VARCHAR (20))
RETURNS TEXT
DETERMINISTIC
BEGIN
RETURN(SELECT 
    CONCAT_WS(' ',
            'The',
            g.name,
            'is',
            'developed by a',
            t.name,
            'in an office with an address',
            a.name) as info
FROM
    games AS g
        JOIN
    teams AS t ON g.team_id = t.id
        JOIN
    offices AS o ON o.id = t.office_id
        JOIN
    addresses AS a ON a.id = o.address_id
WHERE
    g.name = game_name);
END
$$
SELECT 
    CONCAT_WS(' ',
            'The',
            g.name,
            'is',
            'developed by a',
            t.name,
            'in an office 
                        with an address',
            a.name) as info
FROM
    games AS g
        JOIN
    teams AS t ON g.team_id = t.id
        JOIN
    offices AS o ON o.id = t.office_id
        JOIN
    addresses AS a ON a.id = o.address_id
WHERE
    g.name = 'Bitwolf';
-- 11
CREATE PROCEDURE udp_update_budget(min_game_rating FLOAT)
BEGIN
UPDATE games AS g
        LEFT JOIN
    games_categories AS gc ON gc.game_id = g.id 
SET 
    budget = budget + 100000,
    release_date = ADDDATE(release_date, INTERVAL 1 YEAR)
WHERE
    gc.category_id IS NULL
        AND g.release_date IS NOT NULL
        AND g.rating > min_game_rating;
END;
$$
UPDATE games AS g
        LEFT JOIN
    games_categories AS gc ON gc.game_id = g.id 
SET 
    budget = budget + 100000,
    release_date = ADDDATE(release_date, INTERVAL 1 YEAR)
WHERE
    gc.category_id IS NULL
        AND g.release_date IS NOT NULL
        AND g.rating > 8;