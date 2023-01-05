-- Creating DATABASE 
-- Drop database Details_of_XYZ_Mall;
CREATE DATABASE Details_of_XYZ_Mall;
USE Details_of_XYZ_Mall;
/*DROP TABLE BRANCH;
DROP TABLE Employee;
DROP TABLE Product;*/

-- Creating TABLE with CONSTRAINTS and DATA TYPES
 CREATE TABLE Branch
(Branch_ID INT PRIMARY KEY,
 Branch_Name VARCHAR(100) NOT NULL,
 Branch_Addr VARCHAR(500),
 New_Product_ID DECIMAL(10,4));

CREATE TABLE Employee
(Emp_ID INT PRIMARY KEY AUTO_INCREMENT,
 Emp_Name VARCHAR(100),
 Hire_Date DATE,
 Job_desc VARCHAR(100) DEFAULT "Unassigned",
 Salary INT,
 Branch_IDs INT,
  -- creating FOREIGN KEY Constraint that refers the "Branch" Table
 CONSTRAINT FK_branchID FOREIGN KEY (Branch_IDs) REFERENCES Branch(Branch_ID));

 CREATE TABLE Product
 (New_Product_ID DECIMAL(10,4) PRIMARY KEY,
  Product_Name VARCHAR(100) UNIQUE,
  Sale_count INT,
  PEmp_ID INT,
  -- using CHECK constraint to Limit the value range of the "Sale_count" column
  CHECK(Sale_count > 1000));
  
  -- Adding FOREIGN KEY Constraint to Branch table(pre-existing table)
  ALTER TABLE Branch
  ADD CONSTRAINT FK_product_ID FOREIGN KEY (New_Product_ID) REFERENCES Product(New_Product_ID);
  
  -- Adding AUTO_INCREMENT to pre-existing table , the starting value is 1000
  ALTER TABLE Employee AUTO_INCREMENT = 1000;
  
-- Inserting values into the Tables
INSERT INTO Product Values(1.0,"SUGR",100000,1002),(2.0,"H&M",700000,1009),(3.0,"Tace Bell",1000000,1013),(4.0,"Apple",50000,1017),(5.0,"CROMA",150000,1016);

SELECT * FROM Product;

INSERT INTO branch VALUES(001,"Chennai","16 ABC Road",1.0);
INSERT INTO branch VALUES(002,"Coimbatore","120 15th Block",5.0),
(003,"Mumbai","25 XYZ Road",2.0),(004,"Hydrabad","32 10th Street",3.0);  
 
 SELECT * FROM Branch;
 
  INSERT INTO Employee(Emp_Name,Hire_Date,Job_desc,Salary,Branch_IDs) Values('Gerald','1980-07-12','Manager',850000,001),
('William','1985-08-24','Cashier',400000,003),
 ('Irene','1981-09-06','Worker',278000,004),
 ('Tuner','1981-09-06','Manager',830000,002),
('Adams','1982-09-09' ,'Sale_Rep',700000,001),
 ('Sarath','1981-01-05','Cus_Ser_Rep',780000,003),
('James','1981-06-25','Worker',345000,001),
 ('Renske','1987-06-18','Cashier',450000,004),
 ('Jones','1981-02-22','Manager',800000,001),
 ('Anthony','1981-09-06','Worker',306000,002),
('Adam','1981-10-06','Worker',370000,004),
 ('Alexis','1981-09-06','Worker',300800,004),
('Martin','1981-03-12' ,'Sale_Rep',630000,002),
 ('Shelley','1981-09-06','Worker',203600,003),
 ('Scott','1981-02-22','Manager',800000,001),
 ('Allen','1981-02-02','Cus_Ser_Rep',700000,003),
 ('Payam','1982-01-11','Worker',235600,001),
 ('Shanta','1981-09-11','Worker',367000,004),
 ('Ward','1981-11-17','Cus_Ser_Rep',730000,003),
 ('Martin','1981-03-12' ,'Sale_Rep',650000,002);
 
SELECT * FROM Employee;

-- displaying the DISTINCT values
SELECT DISTINCT(Job_desc) Job 
FROM Employee;

-- Using AGGREGATE Function, displaying AVERAGE , MINIMUM, MAXIMUM Salary from "Employee" table.
SELECT AVG(Salary) "Average Salary", MIN(Salary) "Minimum Salary", Max(Salary) "Maximum Salary" 
FROM Employee;

-- Using WHILDCARDS charaters with LIKE operators in WHERE Clause which extracts the specific values
SELECT * FROM Employee
WHERE Branch_IDs LIKE "%2";

-- using SUBQUERY in WHERE Clause to Display "Employee" Table where "Salary" is more than it's Average
SELECT * FROM Employee
WHERE Salary > (Select AVG(SALARY) FROM Employee);

/* 
Creating VIEW (Virtual) TABLE "Job_Avg_Salary" that has Average Salary as "SALARY" of their respective "Job_desc" 
using UNION that combines the result of multiple SELECT Statement
 */
CREATE VIEW Job_Avg_Salary AS
SELECT AVG(Salary),Job_Desc FROM Employee 
WHERE Job_desc = "Manager"
UNION
SELECT AVG(Salary),Job_Desc FROM Employee 
WHERE Job_desc = "Worker"
UNION
SELECT AVG(Salary),Job_Desc FROM Employee 
WHERE Job_desc LIKE "C%Rep"
UNION
SELECT AVG(Salary),Job_Desc FROM Employee 
WHERE Job_desc LIKE "S%Rep"
UNION
SELECT AVG(Salary),Job_Desc FROM Employee 
WHERE Job_desc LIKE "CA%";

-- Sorting "Job_desc" column using ORDER BY in customized Order.
SELECT * FROM Job_avg_salary
ORDER BY (CASE Job_desc WHEN 'Manager' THEN 1
                        WHEN 'Cus_Ser_Rep' THEN 2
                        WHEN 'Sale_Rep' THEN 3
                        WHEN 'Cashier' THEN 4
                        ELSE 100 END);
 
-- Grouping "Job_desc" with it's respective count in Descending order and with it's Branch_IDs
SELECT count(Job_desc) Job_Count, Job_desc,Branch_IDs FROM Employee
Group by Job_desc
ORDER BY JOB_COUNT DESC;

-- Adding FOREIGN KEY Constraint to "Product" table
ALTER TABLE Product 
ADD CONSTRAINT FK_EmpId FOREIGN KEY (PEmp_ID) REFERENCES employee(Emp_ID);

/* Displaying selected columns which are Grouped by Product_name with HAVING Clause in Ascending order.
Here two tables are Joined by INNER JOIN*/
SELECT e.Emp_Name, p.product_name,P.sale_count 
FROM Employee E 
INNER JOIN PRODUCT p WHERE Emp_id = PEMP_ID
GROUP BY Product_Name
Having sale_count >= 120000
ORDER BY Sale_count;

-- Creating VIEW Table "emp_pro_sale"
CREATE VIEW emp_pro_sale AS
SELECT e.Emp_Name, p.product_name,P.sale_count 
FROM Employee E 
INNER JOIN PRODUCT p WHERE Emp_id = PEMP_ID
GROUP BY Product_Name
Having sale_count >= 120000
ORDER BY Sale_count;

-- Altering the VIEW table "emp_pro_sale"
CREATE OR REPLACE VIEW emp_pro_sale AS 
SELECT e.Emp_Name, p.product_name,P.sale_count,p.new_product_id
FROM Employee E 
INNER JOIN PRODUCT p WHERE Emp_id = PEMP_ID
GROUP BY Product_Name
ORDER BY Sale_count;

SELECT * FROM emp_pro_sale;

-- Displaying the selected columns using INNER JOIN of "Branch" and "emp_pro_sale" (view table)
SELECT branch_name Branch,Emp_Name Name, product_name Product,sale_count Count
FROM Branch b JOIN emp_pro_sale em
ON b.new_product_id = em.new_product_id
GROUP BY Product; 

-- Displaying Distinct "Job_desc" between the range
SELECT distinct(JOB_DESC) FROM Employee
Where Salary between 400000 and 900000;

-- Displaying First 3 rows in "Product" Table
SELECT * FROM PRODUCT LIMIT 3;

-- Joining Tables in desire manner using INNER JOIN, LEFT JOIN, and RIGHT JOIN
SELECT * FROM PRODUCT p LEFT JOIN BRANCH b ON p.new_product_ID = b.new_product_ID;
SELECT * FROM BRANCH b RIGHT JOIN Product p ON p.new_product_ID = b.new_product_ID;
SELECT * FROM PRODUCT P RIGHT JOIN Employee E ON P.PEMP_ID = E.EMP_ID;

-- Creating VIEW Table that has new "Incentive" column where Employee_ID are similar in Employee and Product Table
CREATE VIEW Incentive AS
SELECT Salary , Salary + 20000 Incentive FROM employee WHERE Emp_id =  ANY(SELECT EMP_ID FROM Employee E JOIN Product P ON E.Emp_ID = P.PEMP_ID);

-- Altering VIEW Table
CREATE OR REPLACE VIEW Incentive AS
SELECT Emp_ID,Salary , Salary + 20000 Incentive FROM employee WHERE Emp_id =  ANY(SELECT EMP_ID FROM Employee E JOIN Product P ON E.Emp_ID = P.PEMP_ID);

SELECT * FROM Incentive;
SELECT * FROM Employee;

-- Adding new Column in pre-existing Table
ALTER TABLE Employee 
ADD COLUMN Incentive INT;

-- Deleting the column
ALTER TABLE Employee 
DROP COLUMN Incentive;

-- Changing the particular value of "emp_name" 
UPDATE Employee SET Emp_name = 'Marten' WHERE Emp_ID = 1019;

-- Changing the particular date of "Hire_date"
UPDATE Employee SET Hire_date = "1981-12-17" WHERE Emp_ID = 1012;

-- using ANY operator selecting Branch_ID which match both Tables and Salary which is less than 5L. 
SELECT B.Branch_Name, P.Product_Name FROM Branch B
JOIN Product P
WHERE Branch_ID = ANY(SELECT Branch_id FROM Employee WHERE Salary < 500000) 
                      AND B.New_Product_ID = P.New_Product_ID;
					
-- Displaying "Job_desc" in UPPERCASE
 SELECT UCASE(Job_desc) AS Job,SUM(salary) FROM Employee
 WHERE Job_desc='worker';
 
 -- Concating additional attachment "Rs." with "Salary" column using "CONCAT".
  select Emp_Name,Job_desc,CONCAT("Rs.",salary) salary
 from employee;
 
 -- Using CONCAT to display "Rs." with Salary column.
 SELECT Emp_Name, Job_desc, CONCAT("Rs.",Salary) Salary FROM Employee;
 
-- Creating INDEX for unique vales on Emp_Name column.
 CREATE UNIQUE INDEX name_index ON Employee(Emp_Name);
 
 -- Droping Index from the Emp_Name table
 ALTER TABLE Employee
 DROP Index Name_index ;

-- Displaying Table where "Job_desc" is either "Cashier" or "Cus_Ser_Rep" or both.
SELECT * FROM Employee
WHERE job_desc IN ('Cashier','Cus_Ser_Rep'); 

-- Displaying Table where "Job_desc" is not "MANAGER" and "WOrker"
SELECT * FROM employee
WHERE job_desc NOT IN ('MANAGER','WOrker');

-- Using LEFT() to display only year from "Hire_date" column
SELECT Emp_name,LEFT(hire_date,4)
FROM Employee;

-- Trying to Delete "PEmp_ID" column from Product Table shows ERROR as it linked with "Employee" Table
ALTER TABLE Product
DROP COLUMN PEmp_ID; 

-- Droping FOREIGN KEY from "Product" Table
ALTER TABLE Product
DROP FOREIGN KEY FK_EmpID;

/* Adding FOREIGN KEY Constraint with "ON DELETE SET NULL" 
"ON DELETE SET NULL" allows "Employee" Table to DELETE a value from REFERENCES column  
and set Null to the corresponing value in "Product" table */
ALTER TABLE Product
ADD CONSTRAINT Fk_EmpID FOREIGN KEY(PEmp_ID) REFERENCES Employee(Emp_ID)
ON DELETE SET NULL;

-- We can delete values from both "Employee" and "Product" Table
DELETE FROM Employee WHERE Emp_ID = 1018;
DELETE FROM PRODUCT WHERE PEmp_ID = 1017;

SELECT * FROM Employee;
SELECT * FROM Product;
SELECT * FROM Branch;

ALTER TABLE Employee
DROP FOREIGN KEY FK_BranchID;

/* Adding FOREIGN KEY Constraint with "ON DELETE CASCADE" 
it's similar to "ON DELETE SET NULL", instead of setting NULL it DELETES the corresponing value */
ALTER TABLE Employee
ADD CONSTRAINT Fk_BranchID FOREIGN KEY(Branch_IDs) REFERENCES Branch(Branch_ID)
ON DELETE CASCADE;

-- Here by deleting the details in Branch Table , Corresponding rows get deleted in Employee Table.
DELETE FROM Branch WHERE Branch_Name = "Mumbai";

-- Displaying selected "Branch" Table columns if "job_desc" is "Manager" and "Branch_id" of "Employee" table similar to Branch Table are EXIST
SELECT Branch_id,Branch_name
FROM Branch B
WHERE EXISTS 
( SELECT * FROM Employee E
WHERE job_desc="Manager" AND B.Branch_id = E.Branch_ids);
