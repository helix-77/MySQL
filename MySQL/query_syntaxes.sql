-- starts with ...
SELECT name FROM students 
WHERE name LIKE 'Ra%';

SELECT * FROM students;

SELECT * FROM courses;

-- Remove the foreign key constraint
ALTER TABLE students 
DROP FOREIGN KEY students_ibfk_1;

-- Remove column
ALTER TABLE students 
DROP COLUMN course_id; 

SELECT * FROM students;

-- rename column
ALTER TABLE students 
CHANGE name first_name varchar(255);

ALTER TABLE students 
CHANGE first_name name varchar(255);

-- insert row data
INSERT INTO
    students (first_name, age, course_id)
VALUES ('Frank', 25, 3);

-- update row data
UPDATE students 
SET name = 'Alice3' 
WHERE id = 1;

UPDATE courses 
SET id = 10 
WHERE id = 3;

-- delete row data
DELETE FROM students WHERE id = 3;

DELETE FROM students WHERE age < 21;






-- filter
SELECT * FROM Students WHERE age > 22 
LIMIT 2;

-- sort
SELECT * FROM Students ORDER BY age DESC;





INSERT INTO
    students (name, age, course_id)
VALUES 
    ("Rahi", 23, 4),
    ("Mahi", 25, 10);

-- Having : only used after grouping (to apply any condition)
SELECT age, COUNT(*)
FROM Students
GROUP BY
    age
HAVING
    COUNT(*) >= 1;

-- General Order:
/* 
SELECT column(s)
FROM table_name
WHERE condition
GROUP BY column(s)
HAVING condition
ORDER BY column(s) ASC;
*/






SELECT * FROM students;
SELECT * FROM courses;
SELECT * FROM employees;

-- Join tables (inner join == default join)
SELECT s.name, c.dept_name
FROM students as s   -- left table
JOIN courses as c    -- right table
    ON s.course_id = c.id;  

-- self Join
SELECT a.name AS manager, b.name AS employee
FROM employees AS a
JOIN employees AS b 
    ON a.id = b.manager_id;

-- Union
SELECT name FROM students 
UNION 
SELECT dept_name FROM courses;


-- subquery
SELECT name, grades FROM students
WHERE grades > (  
    SELECT AVG(grades) 
    FROM students
);

-- subquery with IN (even grades)
SELECT name, grades FROM students
WHERE grades IN (   -- we use IN to compare with multiple values
    SELECT grades 
    FROM students
    WHERE grades % 2 = 0
);

SELECT * FROM students;

-- Find max marks in New York
SELECT city, MAX(grades) as max_mark FROM students
WHERE grades IN (
    SELECT grades 
    FROM students
    WHERE city = 'New York'
);
-- using From
SELECT city, MAX(grades) 
FROM (
    SELECT * FROM students
    WHERE city = 'New York'
) as temp

-- create View
CREATE VIEW students_info AS
SELECT name, age, grades, city FROM students

-- see the view
SELECT * FROM students_info;

-- drop view
DROP VIEW students_info;

-- show students all info from both table on a new view 
CREATE VIEW students_info AS
SELECT students.name, students.age, students.grades, students.city, courses.dept_name
FROM students
JOIN courses ON students.course_id = courses.id
