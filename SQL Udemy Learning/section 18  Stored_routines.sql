# 218. Introduction to stored routines
-- Stored routines - an SQL statement, or a set of SQL statements, that can be stored on the
-- database server

# 219. The MySQL syntax for stored procedures

DELIMITER $$
CREATE PROCEDURE procedure_name()
BEGIN
	SELECT * FROM employees
	LIMIT 1000;
END$$


# 220. Stored procedures - Example - Part I

USE employees;

DROP PROCEDURE  IF EXISTS select_employees;

DELIMITER $$
CREATE PROCEDURE select_employees()
BEGIN 
	SELECT * FROM employees 
    LIMIT 1000;
END$$ 
DELIMITER ;


# 221. Stored procedures - Example - Part II

call employees.select_employees();
-- OR
call select_employees();

# Stored procedures - Example - Part II - exercise
-- Create a procedure that will provide the average salary of all 
-- employees.Then, call the procedure.

DROP PROCEDURE  IF EXISTS avg_salary;

DELIMITER $$
CREATE PROCEDURE avg_salary()
BEGIN
	SELECT AVG(salary) FROM salaries;
END$$
DELIMITER ;

-- CALLING 
CALL employees.avg_salary();
-- or 
Call avg_salary();

# 224. Another way to create a procedure
-- through Stored Procedure option 

##################################################################################################

# 225. Stored procedures with an input parameter

DROP PROCEDURE  IF EXISTS get_info;
DELIMITER $$
CREATE PROCEDURE get_info(IN p_emp_no INT)
BEGIN 
	SELECT 
		e.emp_no,
		e.birth_date,
		e.first_name,
		e.last_name,
		e.gender,
		e.hire_date
	FROM
		employees e
			JOIN
		salaries s ON e.emp_no = s.emp_no
	WHERE
		e.emp_no = p_emp_no;
END$$
DELIMITER ;

call get_info(10001);

############## 
DROP PROCEDURE  IF EXISTS get_info_avg;

DELIMITER $$
CREATE PROCEDURE get_info_avg(IN p_emp_no INT)
BEGIN 
	SELECT 
		e.emp_no,
		e.first_name,
        e.last_name,
		AVG(s.salary)
	FROM
		employees e
			JOIN
		salaries s ON e.emp_no = s.emp_no
	WHERE
		e.emp_no = p_emp_no;
END$$
DELIMITER ;

call get_info_avg(10001);

##################################################################################################

# 226. Stored procedures with an output parameter

DELIMITER $$
CREATE PROCEDURE get_info_avg_out(IN p_emp_no INT,out p_average_salary DECIMAL(10,2))
BEGIN 
	SELECT AVG(salary) INTO p_average_salary
	FROM salaries s 
    join 
    employees e ON e.emp_no = s.emp_no
    where e.emp_no = p_emp_no;
END $$
DELIMITER ;

/* 
Create a procedure called ‘emp_info’ that uses as parameters the 
first and the last name of an individual, and returns their employee 
number. */

DROP PROCEDURE if exists emp_info;

DELIMITER $$

CREATE PROCEDURE emp_info(in p_first_name varchar(255), in p_last_name varchar(255), out p_emp_no integer)

BEGIN
    SELECT e.emp_no INTO p_emp_no 
    FROM employees e
    WHERE e.first_name = p_first_name AND e.last_name = p_last_name;
END$$
DELIMITER ;

##################################################################################################

# 229. Variables 

SET @v_avg_salary = 0;
call employees.get_info_avg_out(10001,@v_avg_salary);
SELECT @v_avg_salary;

/* Exercise
Create a variable, called ‘v_emp_no’, where you will store the output of the 
procedure you created in the last exercise.

Call the same procedure, inserting the values ‘Aruna’ and ‘Journel’ as a first and 
last name respectively.

Finally, select the obtained output. */

SET @v_emp_no = 0;
CALL emp_info('Aruna','Journel',@v_emp_no);
SELECT @v_emp_no;

##################################################################################################

# 232. User-defined functions in MySQL

DELIMITER $$
CREATE FUNCTION f_emp_avg_salary(p_emp_no INT) RETURNS DECIMAL(10,3)
DETERMINISTIC
BEGIN 
DECLARE p_avg_salary DECIMAL(10,3);

    SELECT AVG(s.salary) INTO  p_avg_salary 
    FROM salaries s 
		JOIN
	employees e ON s.emp_no = e.emp_no
	WHERE s.emp_no = p_emp_no;
    
RETURN p_avg_salary;

END $$
DELIMITER ;

# CALLING the function 
SELECT f_emp_avg_salary(10001);


# 233. Error Code: 1418.
/*
DETERMINISTIC – it states that the function will always return identical result given the same input
NO SQL – means that the code in our function does not contain SQL (rarely the case)
READS SQL DATA – this is usually when a simple SELECT statement is present. */

/* Exercise 
Create a function called ‘emp_info’ that takes for parameters the first and 
last name of an employee, and returns the salary from the newest contract of that employee.

Hint: In the BEGIN-END block of this program, you need to declare and use 
two variables – v_max_from_date that will be of the DATE type, and v_salary, that will be 
of the DECIMAL (10,2) type.

Finally, select this function. */

DELIMITER $$

CREATE FUNCTION emp_info(p_first_name varchar(255), p_last_name varchar(255)) RETURNS decimal(10,2)
DETERMINISTIC 

BEGIN
DECLARE v_max_from_date date;
DECLARE v_salary decimal(10,2);

	SELECT 
		MAX(from_date)
	INTO v_max_from_date FROM
		employees e
			JOIN
		salaries s ON e.emp_no = s.emp_no
	WHERE
		e.first_name = p_first_name
			AND e.last_name = p_last_name;


	SELECT 
		s.salary
	INTO v_salary FROM
		employees e
			JOIN
		salaries s ON e.emp_no = s.emp_no
	WHERE
		e.first_name = p_first_name
			AND e.last_name = p_last_name
			AND s.from_date = v_max_from_date;

RETURN v_salary;
END$$

DELIMITER ;

SELECT EMP_INFO('Aruna', 'Journel');


# 236. Stored routines - conclusion
/*
- if you need to obtain more than one value as a result of a
calculation, you are better off using a procedure
- if you need to just one value to be returned, then you can use a
function. */

-------------------------------------- End of the section --------------------------------------