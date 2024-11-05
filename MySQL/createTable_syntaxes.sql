CREATE TABLE students (
    id int PRIMARY KEY AUTO_INCREMENT,
    name varchar(255) NOT NULL,
    age int NOT NULL
);

CREATE TABLE IF NOT EXISTS courses (
    id int PRIMARY KEY AUTO_INCREMENT,
    dept_name varchar(255) NOT NULL
);


-- Add a new column
ALTER TABLE students
ADD COLUMN grades INT

ALTER TABLE students
ADD COLUMN city VARCHAR(255);


-- Add a new column with foreign key constraint
ALTER TABLE students
ADD COLUMN course_id int,
ADD FOREIGN KEY (course_id) REFERENCES courses (id) 
ON UPDATE CASCADE 
ON DELETE CASCADE;

INSERT INTO
    students (name, age, course_id, grades, city)
VALUES ('Alice', 20, 4, 85, 'New York'),
    ('Bob', 21, 2, 90, 'New York'),
    ('Charlie', 22, 1, 95, 'Chicago'),
    ('David', 23, 4, 92, "New York"),
    ('Eve', 24, 10, 85, 'Los Angeles');


SELECT * FROM students;

INSERT INTO
    courses (dept_name)
VALUES ('Math'),
    ('Science'),
    ('History'),
    ('English');

SELECT * FROM students;

CREATE TABLE employees (
    id int PRIMARY KEY AUTO_INCREMENT,
    name varchar(255),
    manager_id int
);

INSERT INTO
    employees (name, manager_id)
VALUES ('Alice', 3),
    ('Bob', 4),
    ('Charlie', 1),
    ('David', 1),
    ('Eve', 2);


SELECT * FROM students;



