-- practice rishabh toutube
create database rishabh;
CREATE TABLE Employee (
EmpID int NOT NULL,
EmpName Varchar(50),
Gender Char,
Salary int,
City Char(20) );

INSERT INTO Employee
VALUES (1, 'Arjun', 'M', 75000, 'Pune'),
(2, 'Ekadanta', 'M', 125000, 'Bangalore'),
(3, 'Lalita', 'F', 150000 , 'Mathura'),
(4, 'Madhav', 'M', 250000 , 'Delhi'),
(5, 'Visakha', 'F', 120000 , 'Mathura');

CREATE TABLE EmployeeDetail (
EmpID int NOT NULL,
Project Varchar(100),
EmpPosition Char(20),
DOJ date );


INSERT INTO EmployeeDetail
VALUES (1, 'P1', 'Executive', '2019-01-26'),
(2, 'P2', 'Executive', '2020-05-04'),
(3, 'P1', 'Lead', '2021-10-21'),
(4, 'P3', 'Manager', '2019-11-29'),
(5, 'P2', 'Manager', '2020-08-01');




select * from Employee;


-- Q1(a): Find the list of employees whose salary ranges between 2L to 3L.

select EmpID, EmpName,Salary
from employee
where Salary between 200000 and 300000;


-- Q1(b): Write a query to retrieve the list of employees from the same city.


SElect E1.EmpID, E1.EmpName, E1.City
FROM Employee E1, Employee E2
WHERE E1.City = E2.City AND E1.EmpID != E2.EmpID;

-- Q1(c): Query to find the null values in the Employee table.
select * 
from Employee 
where EmpID is null;

-- Q2(a): Query to find the cumulative sum of employee’s salary.

select *, sum(Salary) over (Order by EmpId) as cumm_salary
from Employee;




-- Q2(b): What’s the male and female employees ratio.
SELECT
SUM(CASE WHEN gender = 'M' THEN 1 ELSE 0 END)/count(*) AS male_ratio,
SUM(CASE WHEN gender = 'F' THEN 1 ELSE 0 END)/count(*) AS female_ratio
FROM Employee;

-- Q2(c): Write a query to fetch 50% records from the Employee table.
SELECT * 
FROM Employee
WHERE EmpID<= (SELECT COUNT(EmpID)/2 FROM Employee);



-- Q3: Query to fetch the employee’s salary but replace the LAST 2 digits with ‘XX’i.e 12345 will be 123XX

SELECT Salary,
CONCAT(LEFT(Salary, LENGTH(Salary)-2), 'XX') as masked_salary
FROM Employee;




-- Q4: Write a query to fetch even and odd rows from Employee table.

select * FROM(
SELECT *,row_number() OVER(ORDER BY EmpID) AS NUM
FROM Employee)AS EVEN
 WHERE NUM %2=0;


SELECT * FROM Employee
WHERE MOD(EmpID,2)=0;

-- Q5(a): Write a query to find all the Employee names whose name:
 -- • Begin with ‘A’
-- • Contains ‘t’ alphabet at second last place
-- • Ends with ‘n’ and contains 5 alphabets
-- • Begins with ‘V’ and ends with ‘A’


select * from  Employee
 where EmpName like 'A%';
 
 select * from Employee
 where EmpName like '%t_';
 
 select * from Employee
 where EmpName like '%n' and length(EmpName)=5;

 
 select *from Employee
 where EmpName like 'V%A';
 
 -- Q5(b): Write a query to find the list of Employee names which is:
-- • starting with vowels (a, e, i, o, or u), without duplicates
-- • ending with vowels (a, e, i, o, or u), without duplicates
-- • starting & ending with vowels (a, e, i, o, or u), without duplicates


select distinct(EmpName) from Employee
where EmpName like 'a%' or 'e%' or 'i%' or 'O%' or 'u%';

-- or 

select Distinct(EmpName)
from Employee
where EmpName REGEXP '^[aeiou]';
--------
select distinct(EmpName) from Employee 
where EmpName like '%a' or'%e' or '%i' or '%o' or '%u';

-- or 


select Distinct(EmpName)
from Employee
where EmpName REGEXP '[aeiou]$';
--------

select distinct(EmpName) from Employee
where EmpName REGEXP '^[aeiou].*[aeiou]$';


-- Q6: Find Nth highest salary from employee table with and without using the TOP/LIMIT keywords.

select * from(
select * , dense_rank() over (order by Salary desc)  as rank_salary
from Employee) as r
where rank_salary = 3;



-- Q7(a): Write a query to find and remove duplicate records from a table.

select EmpID, EmpName, Gender, Salary,City, count(*) as duplicate_
from Employee
group by EmpID, EmpName, Gender, Salary,City
having count(*)>1;
------------
with a as (select EmpID, count(*) as duplicate_
from Employee
group by EmpID 
having count(*)>1) 
delete EmpID from a 
where count(*)>1;



--  Q7(b): Query to retrieve the list of employees working in same project.
with ct as 
(select  e.EmpID,e.EmpName, ed.Project 
from Employee as e
inner join EmployeeDetail as ed 
on e.EmpID= ed.EmpID)
select ct1.EmpName, ct2.EmpName ,ct1.Project
from ct ct1 , ct ct2
where ct1.Project = ct2.Project and ct1.EmpID != ct2.EmpID and ct1.EmpID <= ct2.EmpID;


-- Q8: Show the employee with the highest salary for each project
with ct as
(select  e.EmpID,e.EmpName, ed.Project ,e.Salary,
dense_rank() over (partition by Project order by Salary) as high_salary
from Employee as e
inner join EmployeeDetail as ed 
on e.EmpID= ed.EmpID)
select EmpID,EmpName,Project,Salary  from ct 
where high_salary=1;

-- Q9: Query to find the total count of employees joined each year

with a as(select e.EmpId,e.EmpName,year(ed.DOJ) as YOJ
from Employee as e
join EmployeeDetail as ed 
on e.EmpID= ed.EmpID)
select YOJ, count(EmpID) as emp_joined
from a
group by YOJ;

--- or----

select count(e.EmpID),year(DOJ)
from Employee as e
join EmployeeDetail as ed 
on e.EmpID= ed.EmpID
group by year(DOJ);

-- Q10: Create 3 groups based on salary col, salary less than 1L is low, between 1-2 L is medium and above 2L is High

select EmpId, EmpName, Salary,
case
    when Salary<100000 then 'low_salary'
    when Salary > 300000 then 'high_salary'
   else 'medium_salary'
   end as salary_type
from Employee;

































