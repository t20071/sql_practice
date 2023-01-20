# CHAPTER 9 SELECT STATEMENT DATE 20 OCT 2022
# 66. SELECT
USE employees;
SELECT 
    first_name, last_name
FROM
    employees;

SELECT 
    *
FROM
    employees;

-- Excercise 
-- Select the information from the “dept_no” column of the “departments” table.
-- Select all data from the “departments” table.
SELECT 
    dept_no
FROM
    departments;
    
SELECT 
    *
FROM
    departments;

 -----------------------------------  break -------------------------------------  

# 69. WHERE statements
SELECT 
    *
FROM
    employees
WHERE
    first_name = 'Denis';
    
-- Exercise 
SELECT 
    *
FROM
    employees
WHERE
    first_name = 'elvis';
    
 -----------------------------------  break -------------------------------------  

# 72. AND Operator - should use in defferent column 
SELECT 
    *
FROM
    emoployees
WHERE
    first_name = 'Denis' AND gender = 'M';
    
-- Exercise - Retrieve a list with all female employees whose first name is Kellie. 
SELECT 
    *
FROM
    employees
WHERE
    first_name = 'Kellie' AND gender = 'F';
    
 -----------------------------------  break -------------------------------------  
    
# 75. OR operator  - should use in same column
SELECT 
    *
FROM
    employees
WHERE
    first_name = 'Denis'
		OR first_name = 'Elvis';

-- Excercise 
-- Retrieve a list with all employees whose first name is either Kellie or Aruna.
SELECT 
    *
FROM
    employees
WHERE
    first_name = 'Aruna'
        OR first_name = 'Kellie';
        
 -----------------------------------  break -------------------------------------  
        
# 78. Both AND-OR operator simultaneously  AND>OR 
SELECT 
    *
FROM
    employees
WHERE
    last_name = 'Denis'
        AND (gender = 'M' OR gender = 'F');

# EXCERCISE 
-- Retrieve a list with all female employees whose first name is either Kellie or Aruna.
SELECT 
    *
FROM
    employees
WHERE
    (first_name = 'Aruna' OR first_name = 'Kellie')
        AND gender = 'F';
        
 -----------------------------------  break -------------------------------------  
        
# 81. IN AND NOT IN OPERATOR 
-- IN OPERATOR is faster than the OR operator 
SELECT 
    *
FROM
    employees
WHERE
    first_name IN ('cathie' , 'Mark', 'Nathan');
 
-----------------------------------  break -------------------------------------

# 84. NOT IN operator    
SELECT 
    *
FROM
    employees
WHERE
    first_name NOT IN ('cathie' , 'Mark', 'Nathan');
    
-- Excercise 
-- Use the IN operator to select all individuals from the “employees” 
-- table, whose first name is either “Denis”, or “Elvis”.
SELECT 
    *
FROM
    employees
WHERE
    first_name IN ('Denis' , 'Elvis');

-- Extract all records from the ‘employees’ table, aside from those 
-- with employees named 
-- John, Mark, or Jacob.
SELECT 
    *
FROM
    employees
WHERE
    first_name NOT IN ('John' , 'Mark', 'Jacob');
    
 -----------------------------------  break -------------------------------------  

# 86. (LIKE - NOT LIKE) operator  - Pattern Matching
-- _ for matching single word bofore and after the string.  _ark_
-- % for matching the remaining word before or after 
SELECT 
    *
FROM
    employees
WHERE
    first_name LIKE ('_ark%');
    
# Exercise 
-- Working with the “employees” table, use the LIKE operator to select 
-- the data about all individuals, whose first name starts with “Mark”; 
-- specify that the name can be succeeded by any sequence of characters.
SELECT 
    *
FROM
    employees
WHERE
    first_name LIKE ('Mark%');
-- Retrieve a list with all employees who have been hired in the year 2000.
SELECT 
    *
FROM
    employees
WHERE
    hire_date LIKE ('%2000%'); 

-- Retrieve a list with all employees whose employee number is 
-- written with 5 characters, and starts with “1000”. 
SELECT 
    *
FROM
    employees
WHERE
    emp_no LIKE ('1000__');
 
  -----------------------------------  break -------------------------------------  
    
# 89. Wildcard character are  % _ and *
# Exercise 
-- Extract all individuals from the ‘employees’ table whose first name 
-- contains “Jack”.
SELECT 
    *
FROM
    employees
WHERE
    first_name LIKE ('%Jack%');
    
-- Once you have done that, extract another list containing the names 
-- of employees that do not contain “Jack”.
SELECT 
    *
FROM
    employees
WHERE
    first_name NOT LIKE ('%Jack%');
    
 -----------------------------------  break -------------------------------------  
    
# 92. BETWEEN.... AND... 
USE employees;
SELECT 
    *
FROM
    employees
WHERE
    hire_date BETWEEN '1990-01-01' AND '2000-01-01'; 
    
# NOT BETWEEN.... AND... - It can be used for string and number also
SELECT 
    *
FROM
    employees
WHERE
    hire_date NOT BETWEEN '1990-01-01' AND '2000-01-01'; 
    
-- Exercise_1
-- Select all the information from the “salaries” table regarding contracts from 66,000 to 
-- 70,000 dollars per year
SELECT 
    *
FROM
    salaries
WHERE
    salary BETWEEN 66000 AND 70000;
    
    
-- Exercise 2 
-- Retrieve a list with all individuals whose employee number is not between ‘10004’ and 
-- ‘10012’.
SELECT 
    *
FROM
    employees
WHERE
    emp_no NOT BETWEEN 10004 AND 10012;
    

-- Exercise 3 
-- Select the names of all departments with numbers between ‘d003’ and ‘d006’.
SELECT 
    *
FROM
    departments
WHERE
    dept_no BETWEEN 'd003' AND 'd006';
 
 -----------------------------------  break -------------------------------------  
 
#96. IS NULL AND IS NOT NULL 
SELECT 
    *
FROM
    employees
WHERE
    first_name IS NOT NULL;
    
# IS NULL 
SELECT 
    *
FROM
    employees
WHERE
    first_name IS NULL;
    
-- Exercise 
-- Select the names of all departments whose department number value is not null.
SELECT 
    *
FROM
    departments
WHERE
    dept_no IS NOT NULL;
    
 -----------------------------------  break -------------------------------------  

# 98. All Mathematical operator in sql 
SELECT 
    *
FROM
    employees
WHERE
    first_name = 'Mark';
    
SELECT 
    *
FROM
    employees
WHERE
    first_name != 'Mark';  

-- Hire the empolyees after the 2000-01-01
SELECT 
    *
FROM
    employees
WHERE
    hire_date > '2000-01-01';
    
SELECT 
    *
FROM
    employees
WHERE
    hire_date <= '1985-02-01';
    
-- Exercise 1 
-- Retrieve a list with data about all female employees who were hired in the year 2000 or --  after.
SELECT 
    *
FROM
    employees
WHERE
    gender = 'F'
        AND hire_date >= '2000-01-01';
        
-- Exercise 
-- Extract a list with all employees’ salaries higher than $150,000 per annum.
SELECT 
    *
FROM
    salaries
WHERE
     salary > 150000;
     
 -----------------------------------  break -------------------------------------       
     
# 101 SELECT DISTINCT
SELECT DISTINCT
    gender
FROM
    employees;
    
-- Excercise 
-- Obtain a list with all different “hire dates” from the “employees” table.

--- Expand this list and click on “Limit to 1000 rows”. This way you will set the limit of output rows 
--- displayed back to the default of 1000.

--- In the next lecture, we will show you how to manipulate the limit rows count.


SELECT hire_date FROM employees;
SELECT DISTINCT hire_date FROM employees;

 -----------------------------------  break -------------------------------------  
# 104. Aggregate Function like - count, sum, average, min and max
SELECT 
    COUNT(emp_no)
FROM
    employees;
    
SELECT 
    COUNT(first_name)
FROM
    employees;
    
SELECT 
    COUNT(distinct first_name)
FROM
    employees;
    
-- exercise 1 
-- How many annual contracts with a value higher than or equal to $100,000 have been registered in the salaries table?
SELECT 
    COUNT(*)
FROM
    salaries
WHERE
    salary > 100000;
    
-- How many managers do we have in the “employees” database? Use the star symbol (*) in your code to solve this exercise.
SELECT 
    COUNT(*)
FROM
    dept_manager;

 -----------------------------------  break -------------------------------------  
 
# 107 Order by 
SELECT 
    *
FROM
    employees
ORDER BY first_name ; 

SELECT 
    *
FROM
    employees
ORDER BY emp_no DESC; 

SELECT 
    *
FROM
    employees
ORDER BY first_name,last_name ; 

-- ORDER BY - exercise
-- Select all data from the “employees” table, ordering it by “hire date” in descending order. /*
SELECT 
    *
FROM
    employees
ORDER BY hire_date DESC;

 -----------------------------------  break -------------------------------------  
 
# 110. Group by method 
SELECT first_name FROM employees Group by first_name;
SELECT COUNT(first_name) FROM employees Group by first_name;
SELECT 
    first_name, COUNT(first_name)
FROM
    employees
GROUP BY first_name
ORDER BY first_name DESC;

 -----------------------------------  break -------------------------------------  

# 111. Using Aliases (AS)
SELECT 
    first_name, COUNT(first_name) AS names_count
FROM
    employees
GROUP BY first_name
ORDER BY first_name DESC;

-- Using Aliases (AS) - exercise
-- This will be a slightly more sophisticated task.

-- Write a query that obtains two columns. The first column must contain annual salaries higher than 80,000 dollars. The second column, renamed to “emps_with_same_salary”, must show the number of employees contracted to that salary. Lastly, sort the output by the first column.
SELECT 
    salary, COUNT(emp_no) AS emps_with_same_salary
FROM
    salaries
WHERE
    salary > 80000
GROUP BY salary
ORDER BY salary;

 -----------------------------------  break -------------------------------------  
 
# 114. HAVING - use after group by method 
SELECT 
    first_name, COUNT(first_name) AS names_count
FROM
    employees
WHERE
	COUNT(first_name) > 250 # IT WILL SHOW ERROR
GROUP BY first_name
ORDER BY first_name DESC;


SELECT 
    first_name, COUNT(first_name) AS names_count
FROM
    employees
GROUP BY first_name
HAVING COUNT(first_name) > 250
ORDER BY first_name;
-- WHEN aggregate function will be there then do not use where , use having.

-- HAVING - exercise
-- Select all employees whose average salary is higher than $120,000 per annum.
-- Hint: You should obtain 101 records.
SELECT 
    emp_no, AVG(salary) AS Average_salary
FROM
    salaries
GROUP BY emp_no
HAVING AVG(salary) > 120000
ORDER BY emp_no;

 -----------------------------------  break -------------------------------------  

# WHERE VS HAVING
-- Extract a list of all name  that are encounter less than 200 times.
-- let the data refer to the people hire after the 1st of january 1999.
SELECT 
    first_name, COUNT(first_name) AS name_count
FROM
    employees
WHERE
    hire_date > '1999-01-01'
GROUP BY first_name
HAVING COUNT(first_name) < 200
ORDER BY first_name DESC;

-- WHERE vs HAVING - Part II - exercise
-- Select the employee numbers of all individuals who have signed more than 1 -- contract after the 1st of January 2000.
-- Hint: To solve this exercise, use the “dept_emp” table.
SELECT 
    emp_no
FROM
    dept_emp
WHERE
    from_date > '2000-01-01'
GROUP BY emp_no
HAVING COUNT(from_date) > 1
ORDER BY emp_no;

 -----------------------------------  break -------------------------------------  
 
# 121. LIMIT
SELECT * FROM employees;
SELECT 
    *
FROM
    salaries
order by emp_no DESC
LIMIT 10;

SELECT 
    emp_no
FROM
    dept_emp
WHERE
    from_date > '2000-01-01'
GROUP BY emp_no
HAVING COUNT(from_date) > 1
ORDER BY emp_no
LIMIT 100;

-- LIMIT - exercise
-- Select the first 100 rows from the ‘dept_emp’ table. 
SELECT 
    *
FROM
    dept_emp
LIMIT 100;

 -----------------------------------  break -------------------------------------  
