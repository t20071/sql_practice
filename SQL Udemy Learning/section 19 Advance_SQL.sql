# 237. Types of MySQL Variables - 

-- LOCAL, GLOBAL AND SESSION VARIABLE

# Local Variables

DELIMITER $$
CREATE FUNCTION emp_avg_salary(p_emp_no INT) RETURNS DECIMAL(10,2)
DETERMINISTIC

BEGIN 
DECLARE v_salary DECIMAL (10,2);

			SELECT 
		AVG(s.salary)
	INTO v_salary FROM
		salaries s
			JOIN
		employees e ON s.emp_no = e.emp_no
	WHERE
		e.emp_no = p_emp_no;

RETURN v_salary;
END $$
DELIMITER ;


SELECT v_salary;  # Its local variable so error occured
-- Error Code: 1054. Unknown column 'v_salary' in 'field list'

#################################### 

DROP FUNCTION IF EXISTS emp_avg_salary;
DELIMITER $$
CREATE FUNCTION emp_avg_salary(p_emp_no INT) RETURNS DECIMAL(10,2)
DETERMINISTIC

BEGIN 
	DECLARE v_salary DECIMAL (10,2);
BEGIN 
	DECLARE v_salary_2 DECIMAL(10,2);
END;

	SELECT 
		AVG(s.salary)
	INTO v_salary FROM
		salaries s
			JOIN
		employees e ON s.emp_no = e.emp_no
	WHERE
		e.emp_no = p_emp_no;

RETURN v_salary;
END $$
DELIMITER ;


# 238. Session Variables
/*
Session - a series of information exchange interactions, or a dialogue, between a
computer and a user  */
SET @var = 1;
select @var;

-- Note - while defining the local variable we dont use @ sign before the var.

# 239. Global Variables
-- global variables apply to all connections related to a specific server.

SET GLOBAL max_connections = 1000;
SET @@global.max_connections = 1;


# 240. User-Defined vs System Variables
/* 
User-Defined variables that can be set by the user manually.
System Variables variables that are pre-defined on our system – the MySQL server. */


################################################################################

# 241. MySQL Triggers

-- By definition, a MySQL trigger is a type of stored program, associated with a table, 
-- that will be activated automatically once a specific event related to the table of association occurs. 

USE employees;

COMMIT;
################## 

-- BEFORE INSERT 
-- if salary inserted -ve then trigger 0 instead -ve

DELIMITER $$

CREATE TRIGGER before_salary_insert
BEFORE INSERT ON salaries
FOR EACH ROW
BEGIN 
	IF NEW.salary < 0 THEN 
		SET NEW.salary = 0;
	END IF ;
END $$

DELIMITER ;

SELECT * FROM salaries WHERE emp_no = 10001;
INSERT INTO salaries VALUE(10001, -99999,'2023-01-01','2099-05-01');
SELECT * FROM salaries WHERE emp_no = 10001;

############## 
# BEFORE UPDATE 

DELIMITER $$

CREATE TRIGGER before_salary_update
BEFORE UPDATE ON salaries
FOR EACH ROW 
BEGIN 
	IF NEW.salary < 0 THEN
		SET NEW.salary = OLD.salary;
	END IF;
END $$

DELIMITER ;

SELECT * FROM salaries WHERE emp_no = 10001 AND from_date = '2002-06-22';
UPDATE salaries SET salary = 198765 WHERE emp_no = 10001 AND from_date = '2002-06-22';
SELECT * FROM salaries WHERE emp_no = 10001 AND from_date = '2002-06-22';

-- NOW CHANGE         
UPDATE salaries SET salary = '-10000' WHERE emp_no = 10001 AND from_date = '2002-06-22';
SELECT * FROM salaries WHERE emp_no = 10001 AND from_date = '2002-06-22';

-- Built in FUNCTION 
SELECT SYSDATE();

SELECT DATE_FORMAT(SYSDATE(), '%Y-%M-%d'); 

######################## 

-- AFTER INSERT 
DELIMITER $$
CREATE TRIGGER trig_int_dept_manage
AFTER INSERT ON dept_manager
FOR EACH ROW 
BEGIN 
	DECLARE v_curr_salary INT;
    
	SELECT MAX(salary) INTO v_curr_salary
    FROM salaries 
    WHERE emp_no = NEW.emp_no;
    
    IF v_curr_salary IS NOT NULL THEN 
		UPDATE salaries SET from_date = SYSDATE() WHERE emp_no = NEW.emp_no AND from_date = NEW.from_date;
        
	INSERT INTO salaries 
		VALUE (NEW.emp_no, v_curr_salary + 20000, NEW.from_date,NEW.to_date);
        
	END IF;
END $$
DELIMITER ;

INSERT INTO dept_manager VALUES('111534', 'd009', date_format(SYSDATE(), '%y-%m-%d'), '9999-01-01');

SELECT * FROM dept_manager WHERE emp_no = '111534';

SELECT * FROM salaries WHERE emp_no = '111534'; 

/* MySQL Triggers - exercise
Create a trigger that checks if the hire date of an employee is higher than the current date. 
If true, set this date to be the current date. Format the output appropriately (YY-MM-DD).*/

DELIMITER $$
CREATE TRIGGER Before_hire_date_inset
BEFORE INSERT ON  employees 
FOR EACH ROW 
BEGIN 
	IF NEW.hire_date > DATE_FORMAT(SYSDATE(), '%y-%m-%d') THEN
		SET NEW.hire_date = DATE_FORMAT(SYSDATE(), '%y-%m-%d');
	END IF;
END $$
DELIMITER ;


INSERT INTO employees VALUES( 2007189, '1995-10-08','SHARAD','PARDHE','M','9999-01-01');
SELECT * FROM employees WHERE emp_no = 2007189;

###################################################################################################################################

# 245. MySQL Indexes

SELECT * FROM employees WHERE hire_date > '2000-01-01';  # took 0.437 sec 
CREATE INDEX i_hire_date ON employees(hire_date);
SELECT * FROM employees WHERE hire_date > '2000-01-01';  # took 0.000 sec 

SELECT * FROM employees WHERE first_name = 'Georgi' AND last_name = 'Facello';  # took 0.375 sec 
CREATE INDEX i_composite ON employees(first_name,last_name);
SELECT * FROM employees WHERE first_name = 'Georgi' AND last_name = 'Facello';  # took 0.000 sec 

-- index in perticular column
SHOW INDEX FROM salaries FROM employees;
SHOW INDEX FROM employees;

/* MySQL Indexes - exercise 1
Drop the ‘i_hire_date’ index.*/
ALTER TABLE employees
DROP INDEX i_hire_date;

/* MySQL Indexes - exercise 2
Select all records from the ‘salaries’ table of people whose salary is higher than $89,000 per annum.
Then, create an index on the ‘salary’ column of that table, and check if it has sped up the search of the same SELECT statement.*/

SELECT * FROM salaries WHERE salary > 89000; 
CREATE INDEX i_salary ON salaries(salary);
SELECT * FROM salaries WHERE salary > 89000;

############################################################################################################################

# 250. The CASE Statement

SELECT emp_no,
	   first_name, 
	   last_name,
       CASE gender 
		WHEN gender = 'M' THEN 'MALE' 
        ELSE 'FEMALE' 
	END AS gender
FROM employees;
-- ---------------------------------------
SELECT 
    e.emp_no,
    e.first_name,
    e.last_name,
    CASE
        WHEN dm.emp_no IS NOT NULL THEN 'MANAGER'
        ELSE 'EMPLOYEES'
    END AS is_manager
FROM
    employees e
        LEFT JOIN
    dept_manager dm ON e.emp_no = dm.emp_no
WHERE
    dm.emp_no > 109990;
-- ----------------------------------------
SELECT 
    first_name,
    last_name,
    IF(gender = 'M', 'Male', 'Female') AS Gender
FROM
    employees;
-- ----------------------------------------------
SELECT 
    e.emp_no,
    e.first_name,
    e.last_name,
    MAX(s.salary) - MIN(s.salary) AS salary_differance,
    CASE
        WHEN MAX(s.salary) - MIN(s.salary) > 30000 THEN 'More than 30000'
        WHEN MAX(s.salary) - MIN(s.salary) BETWEEN 20000 AND 30000 THEN 'BW 20000 AND 30000'
        WHEN MAX(s.salary) - MIN(s.salary) < 20000 THEN 'Less than 20000'
    END AS differance_by
FROM
    employees e
        JOIN
    salaries s ON e.emp_no = s.emp_no
GROUP BY e.emp_no;

/* The CASE Statement - exercise 1
Similar to the exercises done in the lecture, obtain a result set containing the employee number, 
first name, and last name of all employees with a number higher than 109990. Create a fourth column 
in the query, indicating whether this employee is also a manager, according to the data provided in 
the dept_manager table, or a regular employee. */
SELECT 
    e.emp_no,
    e.first_name,
    e.last_name,
    CASE
        WHEN dm.emp_no IS NOT NULL THEN 'Manager'
        ELSE 'Employee'
    END AS is_manager
FROM
    employees e
        LEFT JOIN
    dept_manager dm ON dm.emp_no = e.emp_no
WHERE
    e.emp_no > 109990;
    
    
/* The CASE Statement - exercise 2
Extract a dataset containing the following information about the managers: employee number, first name, 
and last name. Add two columns at the end – one showing the difference between the maximum and minimum 
salary of that employee, and another one saying whether this salary raise was higher than $30,000 or NOT.

If possible, provide more than one solution.*/
SELECT 
    dm.emp_no,
    e.first_name,
    e.last_name,
    MAX(s.salary) - MIN(s.salary) AS salary_difference,
    CASE
        WHEN MAX(s.salary) - MIN(s.salary) > 30000 THEN 'Salary was raised by more than $30,000'
        ELSE 'Salary was NOT raised by more than $30,000'
    END AS salary_raise
FROM
    dept_manager dm
        JOIN
    employees e ON e.emp_no = dm.emp_no
        JOIN
    salaries s ON s.emp_no = dm.emp_no
GROUP BY s.emp_no;  

 -- -------------------------------------------------------------------   

SELECT 
    dm.emp_no,
    e.first_name,
    e.last_name,
    MAX(s.salary) - MIN(s.salary) AS salary_difference,
    IF(MAX(s.salary) - MIN(s.salary) > 30000,
        'Salary was raised by more then $30,000',
        'Salary was NOT raised by more then $30,000') AS salary_increase
FROM
    dept_manager dm
        JOIN
    employees e ON e.emp_no = dm.emp_no
        JOIN
    salaries s ON s.emp_no = dm.emp_no
GROUP BY s.emp_no;

/* The CASE Statement - exercise 3
Extract the employee number, first name, and last name of the first 100 employees, and add 
a fourth column, called “current_employee” saying “Is still employed” if the employee is 
still working in the company, or “Not an employee anymore” if they aren’t.

Hint: You’ll need to use data from both the ‘employees’ and the ‘dept_emp’ table to solve this exercise. */

SELECT 
    e.emp_no,
    e.first_name,
    e.last_name,
    CASE
        WHEN MAX(de.to_date) > SYSDATE() THEN 'Is still employed'
        ELSE 'Not an employee anymore'
    END AS current_employee
FROM
    employees e
        JOIN
    dept_emp de ON de.emp_no = e.emp_no
GROUP BY de.emp_no
LIMIT 100;
-- ------------------------------------ end of section -- ------------------------------------