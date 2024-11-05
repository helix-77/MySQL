-- table creation:

CREATE TABLE Customer (
    cust_id INT PRIMARY KEY,
    cust_name VARCHAR(100) NOT NULL
);


CREATE TABLE Item (
    item_id INT PRIMARY KEY,
    item_name VARCHAR(100) NOT NULL,
    price INT NOT NULL
);


CREATE TABLE Sale (
    bill_no INT PRIMARY KEY,
    bill_date DATE NOT NULL,
    qty_sold INT NOT NULL
);

-- add column on Sale table
ALTER TABLE sale
ADD COLUMN cust_id INT,
ADD FOREIGN KEY (cust_id) REFERENCES customer(cust_id)

ALTER TABLE sale
ADD COLUMN item_id INT,
ADD FOREIGN KEY (item_id) REFERENCES item(item_id)





-- q1: insert around 10 records in each of the tables

INSERT INTO Customer (cust_id, cust_name) 
VALUES
(1, 'Jia'),
(2, 'John'),
(3, 'Alice'),
(4, 'Bob'),
(5, 'Carol'),
(6, 'David'),
(7, 'Eva'),
(8, 'Frank'),
(9, 'Grace'),
(10, 'Henry');


INSERT INTO Item (item_id, item_name, price) 
VALUES
(101, 'Laptop', 1000),
(102, 'Mouse', 20),
(103, 'Keyboard', 50),
(104, 'Monitor', 200),
(105, 'Printer', 150),
(106, 'Tablet', 300),
(107, 'Phone', 500),
(108, 'Charger', 25),
(109, 'Camera', 600),
(110, 'Headphones', 80);


INSERT INTO Sale (bill_no, bill_date, cust_id, item_id, qty_sold) 
VALUES
(201, '2024-01-02', 1, 101, 1),
(202, '2024-01-05', 1, 102, 2),
(203, '2024-01-07', 2, 103, 1),
(204, '2024-01-10', 3, 104, 2),
(205, '2024-01-12', 4, 105, 1),
(206, '2024-01-14', 1, 106, 1),
(207, '2024-01-15', 5, 107, 3),
(208, '2024-01-15', 1, 108, 4),
(209, '2024-01-20', 6, 109, 1),
(210, '2024-01-25', 7, 110, 2);


SELECT * FROM customer;
SELECT * FROM item;
SELECT * FROM sale;



-- q3: Give count of how many products have been purchased by a customer names “Jia
-- need: jia | count(items)
   
    -- step 1:
    SELECT c.cust_name, i.item_name
    FROM customer c
    JOIN sale s
        ON c.cust_id = s.cust_id
    JOIN item i 
        ON s.item_id=i.item_id
    WHERE c.cust_name="Jia"

-- step 2:
SELECT c.cust_name, COUNT(i.item_id) as product_count
FROM customer c
JOIN sale s
    ON c.cust_id = s.cust_id
JOIN item i 
    ON s.item_id=i.item_id
WHERE c.cust_name="Jia"


-- or,
SELECT cust_name, COUNT(*) AS product_count
FROM Sale s
JOIN Customer c 
    ON s.cust_id = c.cust_id
WHERE c.cust_name = 'Jia';



-- q4: Give a count of how many products have been purchased by each customer.
-- need: customer | count(item)

    -- step-1:
    SELECT cust_id, count(*) as product_count
    FROM sale s
    GROUP BY cust_id;

-- step:2
SELECT c.cust_name, count(*) as product_count
FROM sale s
JOIN customer c 
    ON s.cust_id=c.cust_id
GROUP BY s.cust_id;


-- q5: List the total bill of the purchased items for a customer named “Jia” in bill no B-201.
-- need: bill 201-> Jia | 101(price) 
    -- step 1:
    SELECT s.cust_id, s.item_id 
    FROM sale s
    WHERE s.bill_no=201;

    -- step 2:
    SELECT c.cust_name, SUM(i.price * s.qty_sold) as total_bill 
    FROM sale s
    JOIN customer c 
        ON s.cust_id=c.cust_id
    JOIN item i 
        ON s.item_id=i.item_id
    WHERE c.cust_name="Jia" AND s.bill_no=201;



-- q6: Find out the item which has been purchased mostly during the period 1-1-2024 and 15-1-2024
-- need: item name | purchase count(limit 1)
    -- step:1
    SELECT item_id, qty_sold 
    FROM sale
    WHERE bill_date BETWEEN "2024-01-01" AND "2024-01-15"
    ORDER BY qty_sold DESC
    LIMIT 1;

-- step:2
SELECT i.item_name, qty_sold 
FROM sale s
JOIN item i
    ON s.item_id=i.item_id
WHERE bill_date BETWEEN "2024-01-01" AND "2024-01-15"
GROUP BY i.item_name
ORDER BY qty_sold DESC
LIMIT 1;
