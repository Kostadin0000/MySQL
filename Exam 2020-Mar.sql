-- 1
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(30) NOT NULL UNIQUE,
    `password` VARCHAR(30) NOT NULL,
    email VARCHAR(50) NOT NULL,
    gender CHAR(1) NOT NULL,
    age INT NOT NULL,
    job_title VARCHAR(40) NOT NULL,
    ip VARCHAR(30) NOT NULL
);
CREATE TABLE addresses (
    id INT PRIMARY KEY AUTO_INCREMENT,
    address VARCHAR(30) NOT NULL,
    town VARCHAR(30) NOT NULL,
    country VARCHAR(30) NOT NULL,
    user_id INT NOT NULL,
    CONSTRAINT fk_addresses_users FOREIGN KEY (user_id)
        REFERENCES users (id)
);
CREATE TABLE photos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    `description` TEXT NOT NULL,
    `date` DATETIME NOT NULL,
    views INT NOT NULL DEFAULT 0
);
CREATE TABLE comments (
    id INT PRIMARY KEY AUTO_INCREMENT,
    `comment` VARCHAR(255) NOT NULL,
    date DATETIME NOT NULL,
    photo_id INT NOT NULL,
    CONSTRAINT fk_comments_photos FOREIGN KEY (photo_id)
        REFERENCES photos (id)
);
CREATE TABLE users_photos (
    user_id INT NOT NULL,
    photo_id INT NOT NULL,
    CONSTRAINT fk_mapped_photos FOREIGN KEY (photo_id)
        REFERENCES photos (id),
    CONSTRAINT fk_mapped_users FOREIGN KEY (user_id)
        REFERENCES users (id)
);
CREATE TABLE likes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    photo_id INT,
    user_id INT,
    CONSTRAINT fk_likes_photos FOREIGN KEY (photo_id)
        REFERENCES photos (id),
    CONSTRAINT fk_likes_users FOREIGN KEY (user_id)
        REFERENCES users (id)
);
-- 2
INSERT INTO addresses(address,town,country,user_id)
(SELECT username,password,ip,age FROM users
WHERE gender LIKE 'M');

-- 3
UPDATE addresses 
SET 
    country = CASE
        WHEN country LIKE 'B%' THEN 'Blocked'
        WHEN country LIKE 'T%' THEN 'Test'
        WHEN country LIKE 'P%' THEN 'In Progress'
    END
WHERE
    country LIKE 'B%' OR country LIKE 'T%'
        OR country LIKE 'P%';

-- 4
DELETE FROM addresses
WHERE id % 3 = 0;
-- 5
SELECT 
    username, gender, age
FROM
    users
ORDER BY age DESC , username ASC;
-- 6
SELECT 
    p.id, p.`date`, p.`description`, COUNT(*) AS commentsCount
FROM
    photos AS p
        JOIN
    comments AS c ON c.photo_id = p.id
GROUP BY p.id
ORDER BY commentsCount DESC , p.id ASC LIMIT 5;
-- 7
SELECT 
    CONCAT(u.id, ' ', u.username), email
FROM
    users AS u
        JOIN
    users_photos AS up ON up.user_id = u.id
WHERE
    up.user_id = up.photo_id
    ORDER BY u.id;
    
-- 8
    SELECT 
    p.id,
    IFNULL((SELECT 
                    COUNT(*)
                FROM
                    likes AS l
                WHERE
                    p.id = l.photo_id
                GROUP BY l.photo_id),
            0) AS likes_count,
    IFNULL((SELECT 
                    COUNT(*)
                FROM
                    comments AS c
                WHERE
                    c.photo_id = p.id
                GROUP BY c.photo_id),
            0) AS comments_count
FROM
    photos AS p
ORDER BY likes_count DESC , comments_count DESC , p.id ASC;
-- 9
SELECT 
    CONCAT(LEFT(p.`description`, 30), '...') AS summary, p.date
FROM
    photos AS p
WHERE
    DAY(p.`date`) = 10
ORDER BY p.`date` DESC;
-- 10
DELIMITER $$
CREATE FUNCTION udf_users_photos_count(username VARCHAR(30)) 
RETURNS INT
DETERMINISTIC 
BEGIN
RETURN(SELECT  COUNT(up.user_id) FROM users as u
LEFT JOIN users_photos as up on up.user_id = u.id
WHERE u.username = username
GROUP BY u.id);
END;
$$
-- 11
CREATE PROCEDURE udp_modify_user (address VARCHAR(30), town VARCHAR(30))
BEGIN
UPDATE users as u
JOIN addresses as a on a.user_id = u.id
SET u.age = u.age + 10
WHERE a.address = address and a.town = town;
END
$$
CALL udp_modify_user ('97 Valley Edge Parkway', 'Divinópolis');
SELECT 
    u.username, u.email, u.gender, u.age, u.job_title
FROM
    users AS u
WHERE
    u.username = 'eblagden21'
