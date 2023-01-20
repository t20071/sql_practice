# Section 13: MySQL - Aggregate functions
# 144. COUNT()
-- returns all rows of the table, values NULL included
-- applicable to both numeric and non-numeric data
SELECT * FROM salaries LIMIT 10;

SELECT COUNT(SALARY) FROM salaries;

SELECT COUNT(from_date) FROM salaries;

SELECT COUNT(DISTINCT from_date) FROM salaries;

SELECT COUNT(*) FROM salaries;

-- COUNT() - exercise
-- How many departments are there in the “employees” database? 
-- Use the ‘dept_emp’ table to answer the question.
SELECT COUNT(DISTINCT dept_no) FROM dept_emp;

----------------------------------- Break -----------------------------------

# 147. SUM()
SELECT SUM(SALARY) FROM salaries;

-- SUM,MIN,MAX and AVG only work in numeric data 

-- SUM() - exercise
-- What is the total amount of money spent on salaries for all contracts 
-- starting after the 1st of January 1997?
SELECT SUM(salary) FROM salaries where from_date > '1997-01-01';

----------------------------------- Break -----------------------------------

# 150. MIN() and MAX()
SELECT MAX(SALARY) FROM salaries;
SELECT MIN(SALARY) FROM salaries;

-- MIN() and MAX() - exercise
-- 1. Which is the lowest employee number in the database?
SELECT MIN(emp_no) FROM employees;

-- 2. Which is the highest employee number in the database?
SELECT MAX(emp_no) FROM employees; 

----------------------------------- Break -----------------------------------

# 153. AVG()
SELECT AVG(salary) FROM salaries;

-- AVG() - exercise
-- What is the average annual salary paid to employees who started 
-- after the 1st of January 1997?
SELECT AVG(salary) FROM salaries WHERE from_date > '1997-01-01';

----------------------------------- Break -----------------------------------

# 156. ROUND()
SELECT ROUND(AVG(salary)) FROM salaries;
SELECT ROUND(AVG(salary),2) FROM salaries;

-- ROUND() - exercise
-- Round the average amount of money spent on salaries for all contracts that 
-- started after the 1st of January 1997 to a precision of cents.
SELECT ROUND(AVG(salary),2) FROM salaries WHERE from_date > '1997-01-01';

----------------------------------- Break -----------------------------------

# 159. COALESCE() - Preamble
ALTER TABLE department_dup
CHANGE column dept_name dept_name VARCHAR(40) NULL;

ALTER TABLE department_dup
CHANGE column dept_no dept_no VARCHAR(40) NULL;

INSERT INTO department_dup(dept_no) VALUES ('d010'),('d011');

SELECT * FROM department_dup;

ALTER TABLE department_dup
ADD column department_maneger VARCHAR(40) AFTER dept_name;

SELECT * FROM department_dup;

commit;

----------------------------------- Break -----------------------------------

# 160. IFNULL() and COALESCE()
SELECT * FROM department_dup;
SELECT 
    dept_no, IFNULL(dept_name, 'Remark- Data not found')
FROM
    department_dup;
    
SELECT 
    dept_no, IFNULL(dept_name, 'Remark- Data not found') as dept_name
FROM
    department_dup;
    
# IFNULL() - not allows you to insert more than 2 arguments in the parentheses.
# COALESCE() - llows you to insert N arguments in the parentheses.
-- COALESCE(expression_1, expression_2 …, expression_N)
SELECT 
    dept_no, COALESCE(dept_name, 'Remark- Data not found') as dept_name
FROM
    department_dup;
    
SELECT 
    dept_no, dept_name,
    COALESCE(department_maneger, dept_name, 'N/A') as dept_manager
FROM
    department_dup;
    
ALTER TABLE department_dup
CHANGE department_maneger dept_manager varchar(40);

SELECT 
    dept_no, dept_name,
    COALESCE('Result not found') as fake_column  # for creating fake column, nouse of it
FROM
    department_dup;  
    
# IFNULL() and COALESCE() do not make any changes to the
-- data set. They merely create an output where certain data values
-- appear in place of NULL values.

# Another example of using COALESCE() - exercise 1
-- Select the department number and name from the ‘departments_dup’ table 
-- and add a third column where you name the department number (‘dept_no’) 
-- as ‘dept_info’. If ‘dept_no’ does not have a value, use ‘dept_name’.
SELECT 
    dept_no,
    dept_name,
    COALESCE(dept_no, dept_name) AS dept_info
FROM
    department_dup
ORDER BY dept_no ASC;

-- Another example of using COALESCE() - exercise 2
-- Modify the code obtained from the previous exercise in the following way. 
-- Apply the IFNULL() function to the values from the first and second column, 
-- so that ‘N/A’ is displayed whenever a department number has no value, and 
-- ‘Department name not provided’ is shown if there is no value for ‘dept_name’.
SELECT 
	IFNULL(dept_no,'N\A') AS dept_no,
    IFNULL(dept_name,'Department name not provided') AS dept_name,
    COALESCE(dept_no, dept_name) AS dept_info
FROM
    department_dup
ORDER BY dept_no ASC;
---------------------------------- End ----------------------------------
