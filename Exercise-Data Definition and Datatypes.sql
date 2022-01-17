TRUNCATE TABLE users;

SELECT * FROM users;

ALTER TABLE users 
DROP PRIMARY KEY,
ADD CONSTRAINT pk_users
PRIMARY KEY (id,username);

ALTER TABLE `users`
CHANGE COLUMN `last_login_time` `last_login_time` DATETIME  DEFAULT NOW();

ALTER TABLE users 
DROP PRIMARY KEY,
ADD CONSTRAINT pk_users
PRIMARY KEY users(id);

ALTER TABLE users
CHANGE COLUMN `username` `username` VARCHAR(30) UNIQUE; 

drop table minions;

CREATE DATABASE Movies;
USE Movies;

CREATE TABLE directors(
id INT PRIMARY KEY AUTO_INCREMENT,
director_name VARCHAR(50) NOT NULL,
notes TEXT);

CREATE TABLE genres(
id INT PRIMARY KEY AUTO_INCREMENT,
genre_name VARCHAR(50) NOT NULL,
notes TEXT);

CREATE TABLE categories(
id INT PRIMARY KEY AUTO_INCREMENT,
category_name VARCHAR(50) NOT NULL,
notes TEXT);

CREATE TABLE movies (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(30) NOT NULL,
    director_id INT,
    copyright_year YEAR,
    length INT,
    genre_id INT,
    category_id INT,
    rating DOUBLE,
    notes TEXT
);

INSERT INTO directors(`id`,`director_name`)
VALUES (1,'az'),(2,'ti'),(3,'toi'),(4,'tq'),(5,'nie');


INSERT INTO genres(`id`,`genre_name`)
VALUES (1,'comedy'),(2,'action'),(3,'drama'),(4,'thriller'),(5,'documental');


INSERT INTO categories(`id`,`category_name`)
VALUES (1,'comedy'),(2,'action'),(3,'drama'),(4,'thriller'),(5,'documental');


INSERT INTO movies(`id`,`title`)
VALUES (1,'az'),(2,'ti'),(3,'toi'),(4,'tq'),(5,'nie');

ALTER TABLE movies
ADD CONSTRAINT fk_director1
FOREIGN KEY movies(director_id)
REFERENCES directors(id);

ALTER TABLE movies
DROP FOREIGN KEY fk_director1;

CREATE DATABASE car_rental;
USE car_rental;

CREATE TABLE categories (
id INT PRIMARY KEY AUTO_INCREMENT,  
category VARCHAR(30) NOT NULL, 
daily_rate DOUBLE, 
weekly_rate DOUBLE, 
monthly_rate DOUBLE, 
weekend_rate DOUBLE
);

CREATE TABLE cars (
id INT PRIMARY KEY AUTO_INCREMENT,
 plate_number VARCHAR(10) NOT NULL, 
 make VARCHAR(10), 
 model VARCHAR(10),
 car_year YEAR,
 category_id INT,
 doors INT,
 picture BLOB,
 car_condition TEXT, 
 available BOOLEAN
 );
 
 CREATE TABLE employees (
    id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(40) NOT NULL,
    last_name VARCHAR(40) NOT NULL,
    title VARCHAR(40),
    notes TEXT
);

CREATE TABLE customers (
    id INT PRIMARY KEY AUTO_INCREMENT,
    driver_licence_number VARCHAR(10) NOT NULL,
    full_name VARCHAR(70) NOT NULL,
    address VARCHAR(50),
    city VARCHAR(50),
    zip_code INT,
    notes TEXT
);

CREATE TABLE rental_orders (
    id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT,
    customer_id INT,
    car_id INT,
    car_condition TEXT,
    tank_level INT,
    kilometrage_start INT,
    kilometrage_end INT,
    total_kilometrage INT,
    start_date DATETIME,
    end_date DATETIME,
    total_days INT,
    rate_applied DOUBLE,
    tax_rate DOUBLE,
    order_status BOOLEAN,
    notes TEXT
);

INSERT INTO categories(`id`,`category`)
VALUES (1,'SUV'), 
(2,'Sedan'), 
(3,'Cabrio'); 

INSERT INTO cars(`id`,`plate_number`)
VALUES (1,'PB4421KR'), 
(2,'PB4451KR'), 
(3,'PB4471KR'); 

INSERT INTO employees(`id`,`first_name`,`last_name`)
VALUES (1,'Ivan','Ivanov'), 
(2,'Georgi','Draganov'), 
(3,'Nikolay','Nikolov');

INSERT INTO customers(`id`,`driver_licence_number`,`full_name`)
VALUES (1,'1231451','Ivan Ivanov'), 
(2,'12314351','Dragan Ivanov'), 
(3,'123143551','Dimitar Ivanov');

INSERT INTO rental_orders(`id`,`order_status`)
VALUES (1,false), 
(2,true), 
(3,true);

CREATE DATABASE soft_uni;
USE soft_uni;

CREATE TABLE towns (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(30) NOT NULL
);

CREATE TABLE addresses (
    id INT PRIMARY KEY AUTO_INCREMENT,
    address_text TEXT,
    town_id INT
);

ALTER TABLE addresses
ADD CONSTRAINT fk_addresses_town
FOREIGN KEY addresses(town_id)
REFERENCES towns(id);

CREATE TABLE departments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(30) NOT NULL
);

CREATE TABLE employees (
    id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(40),
    middle_name VARCHAR(40),
    last_name VARCHAR(40),
    job_title VARCHAR(30),
    department_id INT,
    hire_date DATE,
    salary INT,
    address_id INT
);


INSERT INTO towns(`name`)
VALUES ('Sofia'),('Plovdiv'),('Varna'),('Burgas');

INSERT INTO departments(`name`)
VALUES 
('Engineering'),
('Sales'),
('Marketing'),
('Software Development'),
('Quality Assurance');

ALTER TABLE employees
ADD CONSTRAINT fk_dep_id
FOREIGN KEY employees(department_id)
REFERENCES departments(id);

ALTER TABLE employees
CHANGE COLUMN `salary` `salary` DOUBLE;  

INSERT INTO employees(`first_name`,
`middle_name`,
`last_name`,
`job_title`,
`department_id`,
`hire_date`,
`salary`)
VALUES ('Ivan','Ivanov','Ivanov','.NET Developer',4,'2013/02/01',3500.00),
('Petar','Petrov','Petrov','Senior Engineer',1,'2004/03/02',4000.00),
('Maria','Petrova','Ivanova','Intern',5,'2016/08/28',525.25),
('Georgi','Terziev','Ivanov','CEO',2,'2007/12/09',3000.00),
('Peter','Pan','Pan','Intern',3,'2016/08/28',599.88);

SELECT * FROM towns
ORDER BY name ASC;

SELECT * FROM departments
ORDER BY name ASC;

SELECT * FROM employees
ORDER BY salary DESC;

SELECT name FROM towns
ORDER BY name ASC;

SELECT name FROM departments
ORDER BY name ASC;

SELECT first_name,last_name,job_title,salary FROM employees
ORDER BY salary DESC;

UPDATE `employees`
SET `salary` = `salary` * 1.1;

SELECT salary FROM employees;

DELETE FROM employees;