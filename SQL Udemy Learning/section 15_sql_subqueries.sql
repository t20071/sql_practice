# 203. SQL Subqueries with IN nested inside WHERE
SELECT * FROM dept_manager;

-- now find out the last and first name of the employees 
-- whose name is in dept_manager table 
SELECT 
    e.first_name, e.last_name
FROM
    employees e
WHERE
    e.emp_no IN (SELECT 
            dm.emp_no
        FROM
            dept_manager dm);

SELECT dm.emp_no FROM dept_manager dm;

/* SQL Subqueries with IN nested inside WHERE - exercise
Extract the information about all department managers who were hired 
between the 1st of January 1990 and the 1st of January 1995. */
SELECT dm.*
FROM dept_manager dm
WHERE dm.emp_no IN (SELECT e.emp_no FROM employees e WHERE e.hire_date BETWEEN '1990-01-01' AND '1995-01-01');

-- -------------------------------------- end----------------------------------------------------------------

# 206. SQL Subqueries with EXISTS-NOT EXISTS nested inside WHERE
-- Exists use for large dataset where as IN used for smaller dataset
-- Exists check Boolean values
SELECT 
    *
FROM
    employees e
WHERE
    EXISTS( SELECT 
            dm.emp_no
        FROM
            dept_manager dm
        WHERE
            e.emp_no = dm.emp_no);
            
            

SELECT 
    *
FROM
    employees e
WHERE
    EXISTS( SELECT 
            dm.emp_no
        FROM
            dept_manager dm
        WHERE
            e.emp_no = dm.emp_no
        ORDER BY emp_no);

-- Above is not a good practice for order by clouse but below code is good practice
SELECT 
    *
FROM
    employees e
WHERE
    EXISTS( SELECT 
            dm.emp_no
        FROM
            dept_manager dm
        WHERE
            e.emp_no = dm.emp_no)
ORDER BY emp_no;  

/* SQL Subqueries with EXISTS-NOT EXISTS nested inside WHERE - exercise
Select the entire information for all employees whose job title is “Assistant Engineer”. 

Hint: To solve this exercise, use the 'employees' table. */
-- Solution 1
SELECT 
    *
FROM
    employees e
WHERE
    emp_no IN (SELECT 
            t.emp_no
        FROM
            titles t
        WHERE
            t.title = 'Assistant Engineer');

-- 2ND solution
SELECT 
    *
FROM
    employees e
WHERE
    EXISTS( SELECT 
            t.emp_no
        FROM
            titles t
        WHERE
            t.emp_no = e.emp_no
                AND title = 'Assistant Engineer');

-- -------------------------------------- end----------------------------------------------------------------

# 209. SQL Subqueries nested in SELECT and FROM
-- Que - Assign emplooyee number 110022 as a manage to all employees from 10001 to 10020
-- and employees number 110039 as a manager to employees from 10021 to 10040
SELECT 
    A.*
FROM
    (SELECT 
        e.emp_no AS employee_ID,
            MIN(de.dept_no) AS department_code,
            (SELECT 
                    emp_no
                FROM
                    dept_manager
                WHERE
                    emp_no = 110022) AS manager_ID
    FROM
        employees e
    JOIN dept_emp de ON e.emp_no = de.emp_no
    WHERE
        e.emp_no <= 10020
    GROUP BY e.emp_no
    ORDER BY e.emp_no) AS A
UNION 
SELECT 
    B.*
FROM
    (SELECT 
        e.emp_no AS employee_ID,
            MIN(de.dept_no) AS department_code,
            (SELECT 
                    emp_no
                FROM
                    dept_manager
                WHERE
                    emp_no = 110039) AS manager_ID
    FROM
        employees e
    JOIN dept_emp de ON e.emp_no = de.emp_no
    WHERE
        e.emp_no > 10020
    GROUP BY e.emp_no
    ORDER BY e.emp_no
    LIMIT 20) AS B;
    
/* 
SQL Subqueries nested in SELECT and FROM - exercise 1
Starting your code with “DROP TABLE”, create a table called “emp_manager” 
(emp_no – integer of 11, not null; dept_no – CHAR of 4, null; manager_no – integer of 11, not null). */
DROP TABLE if exists emp_manager;
CREATE TABLE emp_manager (
    emp_no INT(11) NOT NULL,
    dept_no CHAR(4) NULL,
    manager_no INT(11) NOT NULL
);

/*
SQL Subqueries nested in SELECT and FROM - exercise 2
Fill emp_manager with data about employees, the number 
of the department they are working in, and their managers.

Your query skeleton must be:

Insert INTO emp_manager SELECT
U.*
FROM
	(A)
UNION (B) UNION (C) UNION (D) AS U;

A and B should be the same subsets used in the last lecture (SQL Subqueries Nested in SELECT and FROM).
 In other words, assign employee number 110022 as a manager to all employees from 10001 to 10020 
 (this must be subset A), and employee number 110039 as a manager to all employees from 10021 to 
 10040 (this must be subset B).

Use the structure of subset A to create subset C, where you must assign employee number 110039 as 
a manager to employee 110022.

Following the same logic, create subset D. Here you must do the opposite - assign employee 110022 
as a manager to employee 110039.

Your output must contain 42 rows.

Good luck!
*/
Insert INTO emp_manager SELECT
U.* 
FROM 
( SELECT 
    A.*
FROM
    (SELECT 
        e.emp_no AS employee_ID,
            MIN(de.dept_no) AS department_code,
            (SELECT 
                    emp_no
                FROM
                    dept_manager
                WHERE
                    emp_no = 110022) AS manager_ID
    FROM
        employees e
    JOIN dept_emp de ON e.emp_no = de.emp_no
    WHERE
        e.emp_no <= 10020
    GROUP BY e.emp_no
    ORDER BY e.emp_no) AS A
UNION 
SELECT 
    B.*
FROM
    (SELECT 
        e.emp_no AS employee_ID,
            MIN(de.dept_no) AS department_code,
            (SELECT 
                    emp_no
                FROM
                    dept_manager
                WHERE
                    emp_no = 110039) AS manager_ID
    FROM
        employees e
    JOIN dept_emp de ON e.emp_no = de.emp_no
    WHERE
        e.emp_no > 10020
    GROUP BY e.emp_no
    ORDER BY e.emp_no
    LIMIT 20) AS B
UNION 
SELECT 
    C.*
FROM
    (SELECT 
        e.emp_no AS employee_ID,
            MIN(de.dept_no) AS department_code,
            (SELECT 
                    emp_no
                FROM
                    dept_manager
                WHERE
                    emp_no = 110039) AS manager_ID
    FROM
        employees e
    JOIN dept_emp de ON e.emp_no = de.emp_no
    WHERE
        e.emp_no = 110022
    GROUP BY e.emp_no
    ORDER BY e.emp_no) AS C
union
SELECT 
    D.*
FROM
    (SELECT 
        e.emp_no AS employee_ID,
            MIN(de.dept_no) AS department_code,
            (SELECT 
                    emp_no
                FROM
                    dept_manager
                WHERE
                    emp_no = 110022) AS manager_ID
    FROM
        employees e
    JOIN dept_emp de ON e.emp_no = de.emp_no
    WHERE
        e.emp_no = 110039
    GROUP BY e.emp_no
    ORDER BY e.emp_no) AS D) AS U;
    
SELECT 
    *
FROM
    emp_manager;
    
-- --------------------------------------------------end of the section----------------------------------------------------
