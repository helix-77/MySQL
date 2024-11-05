-- table creation:
CREATE TABLE employee (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(255)
);

CREATE TABLE department (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(255)
);

CREATE TABLE paydetails (
    emp_id INT,
    dept_id INT,
    basic INT,
    doj DATE,
    FOREIGN KEY (emp_id) REFERENCES employee (emp_id),
    FOREIGN KEY (dept_id) REFERENCES department (dept_id)
);

CREATE TABLE payroll (
    emp_id INT,
    pay_date DATE,
    FOREIGN KEY (emp_id) REFERENCES employee (emp_id)
);




-- query : 1
INSERT INTO
    employee (emp_id, emp_name)
VALUES (1, 'John Doe'),
    (2, 'Jane Smith'),
    (3, 'Mike Johnson'),
    (4, 'Emily Brown'),
    (5, 'David Lee'),
    (6, 'Sarah Wilson'),
    (7, 'Chris Taylor'),
    (8, 'Lisa Anderson'),
    (9, 'Tom Harris'),
    (10, 'Emma Martinez');

INSERT INTO
    department (dept_id, dept_name)
VALUES (1, 'HR'),
    (2, 'Software'),
    (3, 'Finance'),
    (4, 'Marketing'),
    (5, 'Operations'),
    (6, 'Sales'),
    (7, 'Customer Service'),
    (8, 'Research'),
    (9, 'Legal'),
    (10, 'Executive');


INSERT INTO
    paydetails (emp_id, dept_id, basic, doj)
VALUES (1, 1, 50000, '2020-01-15'),
    (2, 2, 60000, '2020-01-20'),
    (3, 3, 55000, '2020-03-10'),
    (4, 2, 52000, '2020-12-05'),
    (5, 5, 58000, '2020-09-01'),
    (6, 2, 54000, '2020-02-28'),
    (7, 2, 51000, '2020-07-12'),
    (8, 8, 62000, '2020-4-03'),
    (9, 2, 65000, '2020-02-18'),
    (10, 1, 75000, '2020-04-22');


INSERT INTO
    payroll (emp_id, pay_date)
VALUES (1, '2023-05-31'),
    (2, '2023-05-31'),
    (3, '2023-05-31'),
    (4, '2023-05-31'),
    (5, '2023-05-31'),
    (6, '2023-05-31'),
    (7, '2023-05-31'),
    (8, '2023-05-31'),
    (9, '2023-05-31'),
    (10, '2023-05-31');


SELECT * FROM employee;
SELECT * FROM department;
SELECT * FROM paydetails;





-- query : 2 - List the name and department who are working at the Software dept
SELECT e.emp_name, d.dept_name 
FROM employee as e
JOIN paydetails as pd
    on e.emp_id=pd.emp_id
JOIN department as d
    on pd.dept_id=d.dept_id
WHERE dept_name="Software"





-- query : 3 - List name and DOJ of all the employee names who joined between 1st January and June 30
SELECT e.emp_name, pd.doj 
FROM employee as e
Join paydetails as pd 
    on e.emp_id = pd.emp_id
WHERE doj BETWEEN "2020-01-01" AND "2020-06-30"




-- query : 4 - Give names of the employees whose total salary > 60000 BDT (think basic = salary)
SELECT e.emp_name, pd.basic 
FROM employee as e
Join paydetails as pd 
    on e.emp_id = pd.emp_id
WHERE basic > 60000;



-- query :5 -  Group the name of employees whose average total salary are higher than or equal to 60000
-- we need dept name and basic salary data,
SELECT d.dept_name as emp_group, AVG(pd.basic) as avg_salary                      
FROM employee as e
JOIN paydetails as pd 
    ON e.emp_id = pd.emp_id     -- relation 1
JOIN department as d 
    ON pd.dept_id = d.dept_id   -- relation 2
GROUP BY d.dept_name
HAVING AVG(pd.basic) >= 60000

