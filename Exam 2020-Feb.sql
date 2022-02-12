-- DROP SCHEMA fsd;
CREATE SCHEMA fsd;
USE fsd;
CREATE TABLE coaches (
    id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(10) NOT NULL,
    last_name VARCHAR(20) NOT NULL,
    salary DECIMAL(10 , 2 ) NOT NULL DEFAULT 0,
    coach_level INT NOT NULL DEFAULT 0
);
CREATE TABLE countries (
    id INT  PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(45) NOT NULL
);
CREATE TABLE towns (
    id INT  PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(45) NOT NULL,
    country_id INT NOT NULL,
    CONSTRAINT fk_countryid_countries FOREIGN KEY (country_id)
        REFERENCES countries (id)
);
CREATE TABLE stadiums (
    id INT  PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(45) NOT NULL,
    capacity INT  NOT NULL,
    town_id INT  NOT NULL,
    CONSTRAINT fk_townid_towns FOREIGN KEY (town_id)
        REFERENCES towns (id)
);
CREATE TABLE teams (
    id INT  PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(45) NOT NULL,
    established DATE NOT NULL,
    fan_base BIGINT  NOT NULL DEFAULT 0,
    stadium_id INT  NOT NULL,
    CONSTRAINT fk_stadiumid_stadiums FOREIGN KEY (stadium_id)
        REFERENCES stadiums (id)
);
CREATE TABLE skills_data (
    id INT  PRIMARY KEY AUTO_INCREMENT,
    dribbling INT  DEFAULT 0,
    pace INT  DEFAULT 0,
    passing INT  DEFAULT 0,
    shooting INT  DEFAULT 0,
    speed INT  DEFAULT 0,
    strength INT  DEFAULT 0
);

CREATE TABLE players (
    id INT  PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(10) NOT NULL,
    last_name VARCHAR(20) NOT NULL,
    age INT  NOT NULL DEFAULT 0,
    position CHAR(1) NOT NULL,
    salary DECIMAL(10 , 2 ) NOT NULL DEFAULT 0,
    hire_date DATETIME,
    skills_data_id INT  NOT NULL,
    team_id INT ,
    CONSTRAINT fk_skills_skillsdata FOREIGN KEY (skills_data_id)
        REFERENCES skills_data (id),
    CONSTRAINT fk_teamid_team FOREIGN KEY (team_id)
        REFERENCES teams (id)
);
CREATE TABLE players_coaches (
    player_id INT,
    coach_id INT,
    CONSTRAINT fk_playerid_players FOREIGN KEY (player_id)
        REFERENCES players (id),
    CONSTRAINT fk_coachid_coaches FOREIGN KEY (coach_id)
        REFERENCES coaches (id)
);
-- 4
DELETE FROM players 
WHERE age > 44;
-- 3
UPDATE coaches AS c 
SET 
    c.coach_level = c.coach_level + 1
WHERE
    SUBSTRING(c.first_name, 1, 1) = 'A'
        AND (SELECT 
            COUNT(*)
        FROM
            players_coaches AS pc
        WHERE
            c.id = pc.coach_id
        GROUP BY pc.coach_id) >= 1;
-- 2
        INSERT INTO coaches(first_name,last_name,salary,coach_level) 
((SELECT first_name,last_name,salary*2,char_length(first_name) FROM players
WHERE age > 44));
-- 5
SELECT p.first_name,p.age,p.salary FROM players as p
ORDER BY p.salary desc;
-- 6
SELECT 
    p.id,
    CONCAT(first_name, ' ', last_name) AS full_name,
    age,
    p.position,
    p.hire_date
FROM
    players AS p
        JOIN
    skills_data AS sd ON sd.id = p.skills_data_id
WHERE
    age < 23 AND position = 'A'
        AND hire_date IS NULL
        AND sd.strength > 50
ORDER BY salary ASC , age;
-- 7
SELECT 
    t.name AS team_name,
    t.established,
    t.fan_base,
    COUNT(p.id) AS players_count
FROM
    teams AS t
        LEFT JOIN
    players AS p ON t.id = p.team_id
GROUP BY t.id
ORDER BY players_count DESC , t.fan_base DESC;
-- 8 
SELECT 
    MAX(sd.speed) AS max_speed, tw.name AS town_name
FROM
    skills_data AS sd
        RIGHT JOIN
    players AS p ON p.skills_data_id = sd.id
        RIGHT JOIN
    teams AS t ON t.id = p.team_id
        RIGHT JOIN
    stadiums AS s ON s.id = t.stadium_id
        RIGHT JOIN
    towns AS tw ON tw.id = s.town_id
GROUP BY t.name
HAVING t.name != 'Devify'
ORDER BY max_speed DESC , town_name;
-- 9

SELECT 
    c.name,
    COUNT(p.id) AS total_count_of_players,
    SUM(p.salary) AS total_sum_of_salaries
FROM
    players AS p
        RIGHT JOIN
    teams AS t ON t.id = p.team_id
        RIGHT JOIN
    stadiums AS s ON s.id = t.stadium_id
        RIGHT JOIN
    towns AS tw ON tw.id = s.town_id
        RIGHT JOIN
    countries AS c ON c.id = tw.country_id
GROUP BY c.id
ORDER BY total_count_of_players DESC , c.name ASC;
-- 10
DELIMITER $$
CREATE FUNCTION udf_stadium_players_count (stadium_name VARCHAR(30))
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN (SELECT COUNT(p.id)
    FROM stadiums AS s
    LEFT JOIN teams AS t
    ON s.id = t.stadium_id
    LEFT JOIN players AS p
    ON t.id = p.team_id
    WHERE s.name = stadium_name);
END
$$
SELECT udf_stadium_players_count('Jaxworks');
$$
-- 11
CREATE PROCEDURE udp_find_playmaker(min_dribble_points INT,team_name VARCHAR(45))
BEGIN
SELECT concat(first_name,' ',last_name) as full_name,age,salary,dribbling,speed,t.name as team_name 
FROM players as p
RIGHT JOIN teams as t on t.id = p.team_id
RIGHT JOIN skills_data as sd on sd.id = p.skills_data_id
WHERE t.name = team_name and sd.dribbling > min_dribble_points
ORDER BY sd.speed desc limit 1;
END
$$
CALL udp_find_playmaker (20, 'Skyble');