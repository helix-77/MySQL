-- Creating Tables 

CREATE TABLE dept (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50) NOT NULL,
    dept_location VARCHAR(100) NOT NULL
);

CREATE TABLE employee (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(100) NOT NULL,
    dept_id INT,
    type_of_work ENUM('Full Time', 'Part Time') NOT NULL,
    hourly_rate DECIMAL(10,2),
    FOREIGN KEY (dept_id) REFERENCES dept(dept_id),
    CHECK (
        (type_of_work = 'Full Time' AND hourly_rate IS NULL) OR
        (type_of_work = 'Part Time' AND hourly_rate BETWEEN 25 AND 60)
    )
);

CREATE TABLE address (
    emp_id INT PRIMARY KEY,
    street_no VARCHAR(10) NOT NULL,
    street_name VARCHAR(100) NOT NULL,
    city VARCHAR(50) NOT NULL,
    zip_code VARCHAR(10) NOT NULL,
    FOREIGN KEY (emp_id) REFERENCES employee(emp_id)
);

CREATE TABLE project (
    project_id INT PRIMARY KEY,
    project_name VARCHAR(100) NOT NULL,
    project_location VARCHAR(100) NOT NULL
);

CREATE TABLE ft_pt_work (
    project_id INT,
    emp_id INT,
    dept_id INT,
    num_of_hours DECIMAL(5,2) NOT NULL,
    PRIMARY KEY (project_id, emp_id),
    FOREIGN KEY (project_id) REFERENCES project(project_id),
    FOREIGN KEY (emp_id) REFERENCES employee(emp_id),
    FOREIGN KEY (dept_id) REFERENCES dept(dept_id)
);

CREATE TABLE salary (
    emp_no INT PRIMARY KEY,
    basic DECIMAL(10,2) NOT NULL,
    allowance DECIMAL(10,2) GENERATED ALWAYS AS (0.45 * basic) STORED,
    deduction DECIMAL(10,2) GENERATED ALWAYS AS ((0.09 * basic) + (0.25 * basic)) STORED,
    net_salary DECIMAL(10,2) GENERATED ALWAYS AS (basic + allowance - deduction) STORED,
    salary_date DATE NOT NULL,
    FOREIGN KEY (emp_no) REFERENCES employee(emp_id)
);

-- Inserting Values -

INSERT INTO dept (dept_id, dept_name, dept_location) VALUES
(1, 'Engineering', 'Canberra'),
(2, 'Foreman', 'Sydney'),
(3, 'Labour', 'Melbourne');

INSERT INTO project VALUES
(101, 'Googong Subdivision', 'Googong'),
(102, 'Burton Highway', 'Burton Canberra'),
(103, 'Greenfield Project', 'Greenfield');

INSERT INTO employee (emp_id, emp_name, dept_id, type_of_work, hourly_rate) VALUES
(1, 'Alice Johnson', 1, 'Full Time', NULL),
(2, 'Bob Smith', 2, 'Full Time', NULL),
(3, 'Charlie Davis', 3, 'Part Time', 30),
(4, 'Diana Prince', 3, 'Part Time', 45),
(5, 'Ethan Hunt', 1, 'Full Time', NULL),
(6, 'Fiona Glenanne', 2, 'Full Time', NULL),
(7, 'George Miller', 3, 'Part Time', 50),
(8, 'Hannah Brown', 1, 'Full Time', NULL),
(9, 'Ian Wright', 3, 'Part Time', 35),
(10, 'Jenny Lee', 2, 'Full Time', NULL);

INSERT INTO address (emp_id, street_no, street_name, city, zip_code) VALUES
(1, '12', 'Maple Street', 'Canberra', '2600'),
(2, '34', 'Oak Avenue', 'Sydney', '2000'),
(3, '56', 'Pine Road', 'Burton', '2900'),
(4, '78', 'Cedar Lane', 'Canberra', '2601'),
(5, '90', 'Elm Street', 'Greenfield', '2500'),
(6, '21', 'Birch Boulevard', 'Sydney', '2001'),
(7, '43', 'Spruce Drive', 'Burton', '2901'),
(8, '65', 'Willow Way', 'Canberra', '2602'),
(9, '87', 'Fir Terrace', 'Burton', '2902'),
(10, '109', 'Ash Court', 'Sydney', '2002');

INSERT INTO ft_pt_work (project_id, emp_id, dept_id, num_of_hours) VALUES
(101, 1, 1, 160),
(101, 2, 2, 160),
(101, 3, 3, 25),
(101, 4, 3, 22),
(102, 1, 1, 120),
(102, 5, 1, 160),
(102, 7, 3, 30),
(103, 6, 2, 160),
(103, 8, 1, 160),
(103, 9, 3, 28);

-- Full-Time Employees
INSERT INTO salary (emp_no, basic, salary_date) VALUES
(1, 6000, '2024-09-30'),
(2, 5500, '2024-09-30'),
(5, 7000, '2024-09-30'),
(6, 5800, '2024-09-30'),
(8, 6200, '2024-09-30'),
(10, 5600, '2024-09-30');

-- Part-Time Employees
-- Calculating basic = hourly_rate * num_of_hours (using ft_pt_work data)
INSERT INTO salary (emp_no, basic, salary_date) VALUES
(3, 30 * 25, '2024-09-30'),  -- 750
(4, 45 * 22, '2024-09-30'),  -- 990
(7, 50 * 30, '2024-09-30'),  -- 1500
(9, 35 * 28, '2024-09-30');  -- 980





-- Queries:  

-- q1: List the "names" of all "Engineers" in "Googong Subdivision" project located at "Googong city"
SELECT e.emp_name
FROM employee e
JOIN dept d 
    ON e.dept_id = d.dept_id
JOIN ft_pt_work f 
    ON e.emp_id = f.emp_id
JOIN project p 
    ON f.project_id = p.project_id
WHERE p.project_name = 'Googong Subdivision'    
    AND p.project_location = 'Googong'
    AND d.dept_name = 'Engineering'
 




-- q2 : List the "names" of all "Labour" in "Googong Subdivision" project located at "Googong city" who "work" more than 20 hours per week
SELECT e.emp_name, f.num_of_hours
FROM employee e
JOIN dept d 
    ON e.dept_id = d.dept_id
JOIN ft_pt_work f 
    ON e.emp_id = f.emp_id
JOIN project p 
    ON f.project_id = p.project_id
WHERE d.dept_name = 'Labour'
  AND p.project_name = 'Googong Subdivision'
  AND p.project_location = 'Googong'
  AND f.num_of_hours > 20;





-- q3: Retrieve the "names" and "addresses" of all employees who work on at least one project located in "Burton" Canberra
-- but whose "department" has no location in "Canberra".
SELECT DISTINCT e.emp_name, a.street_no, a.street_name, a.city, a.zip_code
FROM employee e
JOIN address a 
    ON e.emp_id = a.emp_id
JOIN ft_pt_work f 
    ON e.emp_id = f.emp_id
JOIN project p 
    ON f.project_id = p.project_id
WHERE p.project_location = 'Burton Canberra'
    AND e.dept_id NOT IN (
        SELECT dept_id
        FROM dept
        WHERE dept_location = 'Canberra'
    );






-- q4: Retrieve the "names" of employees who work on both the Googong Subdivision and Burton Highway project
-- need to use self join
SELECT e.emp_name
FROM employee e
JOIN ft_pt_work f1 
    ON e.emp_id = f1.emp_id
JOIN project p1 
    ON f1.project_id = p1.project_id
JOIN ft_pt_work f2 
    ON e.emp_id = f2.emp_id
JOIN project p2 
    ON f2.project_id = p2.project_id
WHERE p1.project_name = 'Googong Subdivision'
  AND p2.project_name = 'Burton Highway';





-- Create a view which lists out the emp_name, dept_name, type_of_work, basic, deduction, net_salary
-- from the above relational databases
CREATE VIEW employee_salary_view AS
SELECT e.emp_name, d.dept_name, e.type_of_work, s.basic,
       s.deduction, s.net_salary
FROM employee e
JOIN dept d 
    ON e.dept_id = d.dept_id
JOIN salary s 
    ON e.emp_id = s.emp_no;

SELECT * FROM employee_salary_view;







-- q6: Advise some modification/s about the ft_pt_work (e.g., no of hours spend 
-- on a project could be on different dates) and named new table as 
-- ft_pt_work_(your last name). Remove any redundant/unnecessary attributes.
/* Modification Suggestion:

    1. Add work_date to track the number of hours spent on a project on different dates.
    2. Remove dept_id as it can be inferred from the employee table, reducing redundancy.

Modified Table Creation (ft_pt_work_YOUR_LAST_NAME):
    Assuming the last name is "Doe", the table will be named ft_pt_work_Doe
 */
CREATE TABLE ft_pt_work_Doe (
    project_id INT,
    emp_id INT,
    num_of_hours DECIMAL(5,2) NOT NULL,
    work_date DATE NOT NULL,
    PRIMARY KEY (project_id, emp_id, work_date),
    FOREIGN KEY (project_id) REFERENCES project(project_id),
    FOREIGN KEY (emp_id) REFERENCES employee(emp_id)
);


INSERT INTO ft_pt_work_Doe (project_id, emp_id, num_of_hours, work_date) VALUES
(101, 1, 80, '2024-09-15'),
(101, 1, 80, '2024-09-22'),
(101, 2, 160, '2024-09-30'),
(101, 3, 25, '2024-09-20'),
(101, 4, 22, '2024-09-21'),
(102, 1, 120, '2024-09-18'),
(102, 5, 160, '2024-09-25'),
(102, 7, 30, '2024-09-27'),
(103, 6, 160, '2024-09-30'),
(103, 8, 160, '2024-09-30'),
(103, 9, 28, '2024-09-29');

SELECT * FROM ft_pt_work_doe;



