-- Creating Tables

CREATE TABLE Student (
    Stud_no VARCHAR(10) PRIMARY KEY CHECK (Stud_no LIKE 'C%'),  -- must start with 'C'
    Stud_name VARCHAR(100),
    dept_no INTEGER,
    Year INTEGER,
    Semester INTEGER
);

CREATE TABLE Department (
    dept_no INTEGER PRIMARY KEY,
    dept_name VARCHAR(100),
    building_no INTEGER
);

CREATE TABLE Membership (
    Member_no VARCHAR(10) PRIMARY KEY,
    Stud_no VARCHAR(10),
    Member_date DATE,
    FOREIGN KEY (Stud_no) REFERENCES Student(Stud_no)
);

CREATE TABLE Book (
    book_no VARCHAR(10) PRIMARY KEY,
    book_name VARCHAR(100),
    author_name VARCHAR(100)
);

CREATE TABLE Book_issue (
    issue_no INTEGER PRIMARY KEY,
    iss_date DATE DEFAULT CURRENT_DATE,
    Member_no VARCHAR(10),
    book_no VARCHAR(10),
    FOREIGN KEY (Member_no) REFERENCES Membership(Member_no),
    FOREIGN KEY (book_no) REFERENCES Book(book_no)
);

CREATE TABLE Return_renew (
    Member_no VARCHAR(10),
    book_no VARCHAR(10),
    return_date DATE,
    renew_date DATE,
    FOREIGN KEY (Member_no) REFERENCES Membership(Member_no),
    FOREIGN KEY (book_no) REFERENCES Book(book_no)
);

-- Inserting Values
-- Insert into Student table (10 records)
INSERT INTO Student VALUES 
('C033001', 'Alice', 1, 2022, 1),
('C033002', 'Bob', 2, 2022, 1),
('C033003', 'Charlie', 1, 2023, 2),
('C033004', 'David', 2, 2021, 2),
('C033005', 'Eve', 1, 2022, 3),
('C033006', 'Frank', 2, 2023, 4),
('C033007', 'Grace', 1, 2021, 4),
('C033008', 'Hank', 3, 2022, 2),
('C033009', 'Ivy', 3, 2021, 1),
('C033010', 'Jack', 1, 2023, 3);

-- Insert into Department table (10 records)
INSERT INTO Department VALUES 
(1, 'Computer Science', 101),
(2, 'Electrical Engineering', 102),
(3, 'Mechanical Engineering', 103),
(4, 'Civil Engineering', 104),
(5, 'Mathematics', 105),
(6, 'Physics', 106),
(7, 'Chemistry', 107),
(8, 'Biology', 108),
(9, 'Economics', 109),
(10, 'History', 110);

-- Insert into Membership table (10 records)
INSERT INTO Membership VALUES 
('M001', 'C033001', '2023-01-10'),
('M002', 'C033002', '2023-02-15'),
('M003', 'C033003', '2023-03-01'),
('M004', 'C033004', '2023-03-20'),
('M005', 'C033005', '2023-04-12'),
('M006', 'C033006', '2023-05-14'),
('M007', 'C033007', '2023-06-10'),
('M008', 'C033008', '2023-07-01'),
('M009', 'C033009', '2023-08-11'),
('M010', 'C033010', '2023-09-05');

-- Insert into Book table (10 records)
INSERT INTO Book VALUES 
('B001', 'Operating Systems', 'Tanenbum'),
('B002', 'Database Systems', 'Silberschatz'),
('B003', 'Introduction to Algorithms', 'Cormen'),
('B004', 'Computer Networks', 'Andrew S. Tanenbaum'),
('B005', 'Artificial Intelligence', 'Stuart Russell'),
('B006', 'Data Structures', 'Mark Allen Weiss'),
('B007', 'Discrete Mathematics', 'Kenneth H. Rosen'),
('B008', 'Calculus', 'James Stewart'),
('B009', 'Linear Algebra', 'Gilbert Strang'),
('B010', 'Digital Logic Design', 'M. Morris Mano');

-- Insert into Book_issue table (10 records)
INSERT INTO Book_issue VALUES 
(1, DEFAULT, 'M001', 'B001'),
(2, DEFAULT, 'M002', 'B002'),
(3, DEFAULT, 'M003', 'B003'),
(4, DEFAULT, 'M004', 'B004'),
(5, DEFAULT, 'M005', 'B005'),
(6, DEFAULT, 'M006', 'B006'),
(7, DEFAULT, 'M007', 'B007'),
(8, DEFAULT, 'M008', 'B008'),
(9, DEFAULT, 'M009', 'B009'),
(10, DEFAULT, 'M010', 'B010');



-- Insert into Return_renew table (10 records)
INSERT INTO Return_renew VALUES 
('M001', 'B001', '2023-04-15', '2023-03-01'),
('M002', 'B002', '2023-04-10', '2023-03-15'),
('M003', 'B003', '2023-05-12', '2023-04-12'),
('M004', 'B004', '2023-06-15', '2023-05-10'),
('M005', 'B005', '2023-06-25', '2023-05-20'),
('M006', 'B006', '2023-07-20', '2023-06-10'),
('M007', 'B007', '2023-08-14', '2023-07-12'),
('M008', 'B008', '2023-09-15', '2023-08-10'),
('M009', 'B009', '2023-10-05', '2023-09-01'),
('M010', 'B010', '2023-10-20', '2023-09-15');





-- queries:

-- q1: List all the student and Book name, Author issued on date (e.g., 01-01-2013)
SELECT s.`Stud_name`, b.book_name, b.author_name, bi.iss_date 
FROM student s
JOIN membership m 
    ON s.`Stud_no`= m.`Stud_no`
JOIN book_issue bi 
    ON m.`Member_no`= bi.`Member_no`
JOIN book b 
    ON bi.book_no = b.book_no
WHERE bi.iss_date="2013-01-01"



-- q2: List the details of students who borrowed book whose author is Tanenbum 
SELECT s.`Stud_name`, b.book_name, b.author_name
FROM student s
JOIN membership m 
    ON s.`Stud_no`= m.`Stud_no`
JOIN book_issue bi 
    ON m.`Member_no`= bi.`Member_no`
JOIN book b 
    ON bi.book_no = b.book_no
WHERE b.author_name = "Tanenbum"



-- q3: Give a count of how many books have been borrowed by each student
-- stud_name | count(book_no)
SELECT s.`Stud_name`, count(bi.book_no) as Books_Borrowed
FROM student s
JOIN membership m 
    ON s.`Stud_no`= m.`Stud_no`
JOIN book_issue bi 
    ON m.`Member_no`= bi.`Member_no`
GROUP BY bi.`Member_no` -- or GROUP BY s.`Stud_no`


-- q4: List the students who reached the borrowed limit 3 (i.e., none can borrow more than 3 books)

SELECT s.`Stud_name`
FROM student s
JOIN membership m 
    ON s.`Stud_no`= m.`Stud_no`
JOIN book_issue bi 
    ON m.`Member_no`= bi.`Member_no`
GROUP BY bi.`Member_no` -- or GROUP BY s.`Stud_no`
HAVING COUNT(bi.book_no) >= 3;



-- q5: List the students who returned the borrowed book after 30 days from his/her issuance.
SELECT s.`Stud_name`, bi.iss_date, rr.return_date
FROM student s
JOIN membership m 
    ON s.`Stud_no`= m.`Stud_no`
JOIN book_issue bi
    ON m.`Member_no`= bi.`Member_no`
JOIN return_renew rr
    ON m.`Member_no`= rr.`Member_no`
WHERE DATEDIFF(rr.return_date, bi.iss_date) > 30;



-- q6: Calculate the penalty of each student who exceeds the borrowed period 30 days. Apply 25 Paisa per day for the penalty.
SELECT s.`Stud_name`, 
        DATEDIFF(rr.return_date, bi.iss_date) AS total_days, 
        (DATEDIFF(rr.return_date, bi.iss_date) * 0.25) AS penalty
FROM student s
JOIN membership m 
    ON s.`Stud_no`= m.`Stud_no`
JOIN book_issue bi
    ON m.`Member_no`= bi.`Member_no`
JOIN return_renew rr
    ON m.`Member_no`= rr.`Member_no`
WHERE DATEDIFF(rr.return_date, bi.iss_date) > 30;



-- q7: Give a list of books taken by student with stud_no C033002
-- stud_name | book_name
SELECT s.`Stud_name`, b.book_name
FROM student s
JOIN membership m 
    ON s.`Stud_no`= m.`Stud_no`
JOIN book_issue bi 
    ON m.`Member_no`= bi.`Member_no`
JOIN book b 
    ON bi.book_no = b.book_no
WHERE s.`Stud_no` = 'C033002';



-- q8: consider the renew_date as the new issue date during penalty calculation.
SELECT s.`Stud_name`, 
        DATEDIFF(rr.return_date, rr.renew_date) AS total_days, 
        (DATEDIFF(rr.return_date, rr.renew_date) * 0.25) AS penalty
FROM student s
JOIN membership m 
    ON s.`Stud_no`= m.`Stud_no`
JOIN book_issue bi
    ON m.`Member_no`= bi.`Member_no`
JOIN return_renew rr
    ON m.`Member_no`= rr.`Member_no`
WHERE DATEDIFF(rr.return_date, rr.renew_date) > 30;