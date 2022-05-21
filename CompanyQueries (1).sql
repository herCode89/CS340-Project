-- List the Fname and Salary of three highest paid employees
SELECT Fname, Salary
FROM EMPLOYEE
ORDER BY Salary DESC
LIMIT 3;

-- Average Salary for each department

SELECT Dno, AVG(Salary), Count(*) As 'Number of Emp', Fname
FROM EMPLOYEE
GROUP BY Dno
					  
-- List departments with average salary over $50,000

SELECT E.Dno, D.Dname, AVG(Salary), Count(*) As 'Number of Emp'
FROM EMPLOYEE E, DEPARTMENT D
WHERE E.Dno = D.Dnumber
GROUP BY E.Dno
HAVING AVG(Salary) > 50000
ORDER BY AVG(Salary) ASC

-- Employees with salaries greater than or equal to all employees in dno 4
SELECT E.Fname, E.Salary
FROM EMPLOYEE E
WHERE E.Salary >= ALL (SELECT Salary
                      FROM EMPLOYEE
                      WHERE Dno = 4)


-- Show the resulting salaries if every employee working on the ‘ProductX’ project 
-- is given a 10 percent raise.

SELECT  E.Fname, E.Lname, 1.1 * E.Salary AS Increased_sal
FROM  EMPLOYEE AS E, WORKS_ON AS W, PROJECT AS P
WHERE  E.Ssn=W.Essn AND W.Pno=P.Pnumber AND P.Pname='ProductX';

-- Retrieve the name and address of all employees 
-- who work for the 'Research' department
SELECT Fname, Lname, Address
FROM EMPLOYEE, DEPARTMENT
WHERE Dname = 'Research' AND Dnumber=Dno;


-- Use of UNION
-- List each Project and number of hours worked on that projects
-- At the bottom list total hours worked on all projects

SELECT Pno As 'Project', Sum(Hours) AS 'Hours'
FROM WORKS_ON
GROUP BY Pno
UNION
SELECT 'Total', Sum(Hours)
FROM WORKS_ON


-- Employees without a Supervisor
SELECT Fname, Lname
FROM EMPLOYEE
WHERE Super_ssn IS NULL;

-- Project numbers of projects with at least 3 employees working on them
SELECT Pno 
FROM WORKS_ON
GROUP BY Pno
HAVING Count(Essn) >= 3


-- Use of In 
SELECT Pnumber, Pname
FROM PROJECT
WHERE Pnumber IN (1, 2, 3)
				  
-- Pnumber and Pname of projects that employee 123456789 works on

SELECT Pnumber, Pname
FROM PROJECT
WHERE Pnumber IN ( SELECT Pno
                   FROM WORKS_ON
                   WHERE Essn = '123456789')
				  -- Correlated nested subquery

SELECT E.Ssn, E.Fname, E.Lname 
FROM EMPLOYEE E
WHERE NOT EXISTS ( SELECT Dependent_name
                   FROM DEPENDENT D 
                   WHERE D.Essn = E.Ssn )

-- Names of projects with at least 3 employees working on them
SELECT Pname
FROM PROJECT
WHERE Pnumber IN ( SELECT Pno 
                  FROM WORKS_ON
                  GROUP BY Pno
                  HAVING Count(Essn) >= 3 )
				  
-- Names of employees with no dependents
SELECT Fname, Lname 
FROM EMPLOYEE
WHERE Ssn NOT IN ( SELECT Essn
                  FROM DEPENDENT )
				  
				  
-- Projects Managed by Smith or that Smith works on

SELECT 	DISTINCT Pnumber
FROM 	PROJECT
WHERE 	Pnumber IN 
		( SELECT	Pnumber
          FROM PROJECT, DEPARTMENT, EMPLOYEE
          WHERE Dnum = Dnumber AND Mgr_ssn = Ssn AND Lname = 'Smith')
         OR
         Pnumber IN 
		( SELECT	Pno
          FROM WORKS_ON, EMPLOYEE
          WHERE Essn = Ssn AND Lname = 'Smith');
		  


-- List the ssn, first and last name of employees who work on ALL
-- projects controlled by Dno 4
						  						  
SELECT E.Ssn, E.Lname, E.Fname
FROM EMPLOYEE E
WHERE NOT EXISTS(SELECT Pnumber
				 FROM PROJECT P
				 WHERE Dnum=4 AND NOT EXISTS (SELECT * 
                                              FROM WORKS_ON WO
                                              WHERE WO.Essn = E.Ssn
                                              AND P.Pnumber = WO.Pno ) )
																   

-- Join on specified condition
SELECT Fname, Lname
FROM (EMPLOYEE JOIN DEPARTMENT ON Dno = Dnumber)
WHERE Dname = 'Research'

-- Attempt a Natural Join but no matching attribute names
SELECT Fname, Lname
FROM (EMPLOYEE NATURAL JOIN DEPARTMENT)
WHERE Dname = 'Research'

-- Natural JOIN on matching attribute names
SELECT Dname, Dlocation
FROM (DEPARTMENT NATURAL JOIN DEPT_LOCATIONS)


-- Left "Outer" Join  the word outer is optional in MariaDB
--  Every row in the left is kept even if no match
-- List employee's Snn, Firstname and Dependent's name
SELECT Ssn, Fname AS 'Emp Name', Dependent_name
FROM EMPLOYEE E LEFT OUTER JOIN DEPENDENT D ON E.Ssn = D.Essn

-- List every employees name and number of Dependents
SELECT E.Ssn, E.Fname AS 'Emp Name', COUNT(D.Dependent_name)
FROM EMPLOYEE E LEFT OUTER JOIN DEPENDENT D ON E.Ssn = D.Essn
GROUP BY E.Ssn

-- List every employees name and number of Dependents and totals
SELECT E.Ssn, E.Fname AS 'Emp Name', COUNT(D.Dependent_name) AS '# dependents'
FROM EMPLOYEE E LEFT OUTER JOIN DEPENDENT D ON E.Ssn = D.Essn
GROUP BY E.Ssn
UNION 
SELECT ' ', 'Total', COUNT(*)
FROM DEPENDENT

-- List Supervisors firstname and Employees firstname
SELECT S.Fname As 'Super Name', E.Fname as 'Emp Name'
FROM EMPLOYEE S RIGHT JOIN EMPLOYEE E ON S.Ssn = E.Super_ssn;


--  Employees that manage a project in Stafford
SELECT Pnumber, Dnum, Lname, Address, Bdate
FROM((PROJECT JOIN DEPARTMENT ON Dnum=Dnumber)  JOIN EMPLOYEE ON Mgr_ssn=Ssn)
WHERE Plocation='Stafford'

-- View are virtual tables linked to another table
-- Some views are updatable

CREATE VIEW  ProductX_Emp
AS	SELECT Ssn, Fname, Lname, Salary
	FROM PROJECT, EMPLOYEE, WORKS_ON
    WHERE PROJECT.Pnumber=WORKS_ON.Pno AND EMPLOYEE.Ssn = WORKS_ON.Essn
    	  AND PROJECT.Pname = 'ProductX'

UPDATE ProductX_Emp
SET Salary = 31000

	
CREATE VIEW TopEmployees
AS 	SELECT Ssn, Fname, Lname, Bdate, Address, Sex, Salary, Dno
	FROM EMPLOYEE
    WHERE Salary > 50000
WITH CHECK OPTION

INSERT INTO `TopEmployees` (`Ssn`, `Fname`, `Lname`, `Bdate`, `Address`, `Sex`, `Salary`, `Dno`) VALUES ('111558888', 'Mary', 'Jones', '2020-07-05', '454', 'M', '32000', '4'

-- Names that are used for both employees and dependents
-- There is no intersection in MySQL

(SELECT Fname as name FROM EMPLOYEE)
INTERSECT
(SELECT Dependent_name as name FROM DEPENDENT)

SELECT Fname as name FROM EMPLOYEE
WHERE Fname IN (SELECT Dependent_name FROM DEPENDENT)

-- Names used for employees but not dependents

(SELECT Fname as name FROM EMPLOYEE)
MINUS
(SELECT Dependent_name as name FROM DEPENDENT)

(SELECT Fname as name FROM EMPLOYEE)
EXCEPT
(SELECT Dependent_name as name FROM DEPENDENT)

-- Names used for employees or dependents
(SELECT Fname as name FROM EMPLOYEE)
UNION
(SELECT Dependent_name as name FROM DEPENDENT)

-- For each department that has more than two employees, retrive the department number 
-- and the number of it's employees who are making more than $40000																   
SELECT Dno, COUNT(*)
FROM EMPLOYEE
WHERE Salary>40000 AND Dno IN ( SELECT Dno
                                 FROM EMPLOYEE 
                                 GROUP BY Dno
                                 HAVING COUNT(*) >2)
GROUP By Dno;

WITH BIGDEPTS(Dno) AS
(	SELECT	Dno
	FROM	EMPLOYEE
	GROUP BY Dno
	HAVING	COUNT(*) > 2)
SELECT		Dno, COUNT(*)
FROM		EMPLOYEE
WHERE Salary>40000 AND Dno IN (SELECT Dno FROM BIGDEPTS)
GROUP BY Dno