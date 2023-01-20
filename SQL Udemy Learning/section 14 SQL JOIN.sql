# Section 14 SQL JOIN

/*Intro to JOINs - exercise 1
If you currently have the ‘departments_dup’ table set up, 
use DROP COLUMN to remove the ‘dept_manager’ column from the 
‘departments_dup’ table.*/

ALTER TABLE department_dup 
DROP COLUMN dept_manager;

/*Then, use CHANGE COLUMN to change the ‘dept_no’ and ‘dept_name’ 
columns to NULL.*/

ALTER TABLE department_dup
CHANGE COLUMN dept_no dept_no CHAR(4) NULL;

ALTER TABLE department_dup
CHANGE COLUMN dept_name dept_name VARCHAR(40) NULL;

-- Then, insert a record whose department name is “Public Relations”.
INSERT INTO department_dup(dept_name)
VALUES('Public Relations');

-- Delete the record(s) related to department number two.
DELETE FROM department_dup where dept_no = 'd002';

-- Intro to JOINs - exercise 2
-- Create and fill in the ‘dept_manager_dup’ table, using the 
-- following code:
CREATE TABLE dept_manager_dup
(
emp_no int(11) NOT NULL,
dept_no char(4) NULL,
from_date date NOT NULL,
to_date date NULL
);

INSERT INTO dept_manager_dup 
SELECT * FROM dept_manager;

INSERT INTO dept_manager_dup (emp_no, from_date)
VALUES (999904, '2017-01-01'),
	   (999905, '2017-01-01'),
       (999906, '2017-01-01'),
       (999907, '2017-01-01');
       
DELETE FROM dept_manager_dup
WHERE dept_no = 'd001';

INSERT INTO department_dup (dept_name)
VALUES ('Public Relations');

DELETE FROM department_dup
WHERE dept_no = 'd002'; 

---------------------- Break ----------------------

# 171. INNER JOIN - Part II
SELECT 
    m.emp_no, m.dept_no, d.dept_name
FROM
    dept_manager_dup m
        INNER JOIN
    department_dup d ON m.dept_no = d.dept_no;
    
/* INNER JOIN - Part II - exercise
Extract a list containing information about all managers’ employee 
number, first and last name, department number, and hire date.*/
SELECT 
    m.emp_no, e.first_name, e.last_name, m.dept_no, e.hire_date
FROM
    dept_manager m
        INNER JOIN
    employees e ON m.emp_no = e.emp_no
ORDER BY emp_no;

# JOIN by defalut means INNER JOIN

SELECT 
    m.emp_no, e.first_name, e.last_name, m.dept_no, e.hire_date
FROM
    dept_manager m
        JOIN   # SAME AS INNER JOIN
    employees e ON m.emp_no = e.emp_no
ORDER BY emp_no;

---------------------- Break ----------------------

# 175. Duplicate Records
-- lets insert some duplicate record in dup table
INSERT INTO dept_manager_dup
VALUES ('110183', 'd003', '1985-01-01', '1992-03-21');

INSERT INTO department_dup
VALUES ('d009', 'Customer Service');

-- CHECK both table 
SELECT * FROM dept_manager_dup ORDER BY dept_no ASC;
SELECT * FROM department_dup ORDER BY dept_no;

-- inner join
SELECT 
    m.emp_no, m.dept_no, d.dept_name
FROM
    dept_manager_dup m
        INNER JOIN
    department_dup d ON m.dept_no = d.dept_no;
    
-- use GROUP BY 
SELECT 
    m.emp_no, m.dept_no, d.dept_name
FROM
    dept_manager_dup m
        INNER JOIN
    department_dup d ON m.dept_no = d.dept_no
GROUP BY m.emp_no
ORDER BY m.emp_no;

---------------------- Break ----------------------

# 176. LEFT JOIN - Part - 1
-- Remove the dup record from both the table 
DELETE FROM dept_manager_dup where dept_no = 'd003';

DELETE FROM department_dup where dept_no = 'd009';

-- now insert back 
INSERT INTO dept_manager_dup
VALUES ('110183', 'd003', '1985-01-01', '1992-03-21');

INSERT INTO department_dup
VALUES ('d009', 'Customer Service');

-- left join
SELECT 
    m.emp_no, m.dept_no, d.dept_name
FROM
    dept_manager_dup m
        LEFT JOIN
    department_dup d ON m.dept_no = d.dept_no
GROUP BY m.emp_no
ORDER BY m.dept_no;

-- change the direction
SELECT 
    m.emp_no, m.dept_no, d.dept_name
FROM
     department_dup d 
        LEFT JOIN
    dept_manager_dup m ON m.dept_no = d.dept_no
ORDER BY m.dept_no;

-- change the alias
SELECT 
    d.dept_no,d.dept_name, m.emp_no
FROM
     department_dup d 
        LEFT JOIN
    dept_manager_dup m ON m.dept_no = d.dept_no
ORDER BY d.dept_no;

-- left join and left outer join are same 

-- where is null
SELECT 
    m.emp_no, m.dept_no, d.dept_name
FROM
    dept_manager_dup m
        LEFT JOIN
    department_dup d ON m.dept_no = d.dept_no
WHERE 
     dept_name IS NULL
ORDER BY m.dept_no;

-- where is not null
SELECT 
    m.emp_no, m.dept_no, d.dept_name
FROM
    dept_manager_dup m
        LEFT JOIN
    department_dup d ON m.dept_no = d.dept_no
WHERE 
     dept_name IS NOT NULL
ORDER BY m.dept_no;

#  LEFT JOIN - Part II - exercise
/* Join the 'employees' and the 'dept_manager' tables to return a subset 
of all the employees whose last name is Markovitch. See if the output 
contains a manager with that name.  

Hint: Create an output containing information corresponding to the following 
fields: ‘emp_no’, ‘first_name’, ‘last_name’, ‘dept_no’, ‘from_date’. 
Order by 'dept_no' descending, and then by 'emp_no'.*/
SELECT 
    m.dept_no, e.emp_no, e.first_name, e.last_name, m.from_date
FROM
    employees e
        LEFT JOIN
    dept_manager m ON e.emp_no = m.emp_no
WHERE
    e.last_name = 'Markovitch'
ORDER BY m.dept_no DESC , e.emp_no; 

---------------------- Break ----------------------

# 180. RIGHT JOIN
SELECT 
     d.dept_no, m.emp_no, d.dept_name
FROM
    dept_manager_dup m
        RIGHT JOIN
    department_dup d ON  m.dept_no = d.dept_no 
ORDER BY dept_no;

select * from department_dup order by dept_no;
select * from dept_manager_dup order by dept_no;
    
-- no sence of using right join because
SELECT 
     d.dept_no, m.emp_no, d.dept_name
FROM
    department_dup d 
        LEFT JOIN
     dept_manager_dup m ON d.dept_no = m.dept_no
ORDER BY dept_no;
     
-- Same output 

---------------------- Break ----------------------

# 181. The new and the old join syntax
SELECT 
     d.dept_no, m.emp_no, d.dept_name
FROM
    department_dup d,
	dept_manager_dup m 
WHERE 
	d.dept_no = m.dept_no
ORDER BY dept_no;

-- same result as inner join or join .
-- but where is more time consuming so avoid this.
/* The new and the old join syntax - exercise

Extract a list containing information about all managers’ 
employee number, first and last name, department number, and hire date. 
Use the old type of join syntax to obtain the result. */
SELECT 
    e.emp_no, e.first_name, e.last_name, m.dept_no, e.hire_date
FROM
    employees e,
    dept_manager m
WHERE
    e.emp_no = m.emp_no
ORDER BY emp_no;

-- 2nd solution
SELECT 
    e.emp_no, e.first_name, e.last_name, m.dept_no, e.hire_date
FROM
    employees e
    INNER JOIN  # OR ONLY JOIN
    dept_manager m ON e.emp_no = m.emp_no
ORDER BY emp_no;

---------------------- Break ----------------------

#  184. JOIN and WHERE Used Together
SELECT 
    e.emp_no, e.first_name, e.last_name, s.salary
FROM
    employees e
        JOIN
    salaries s ON e.emp_no = s.emp_no
WHERE
    s.salary > 145000
ORDER BY first_name;

/* JOIN and WHERE Used Together - exercise
Select the first and last name, the hire date, and the job title of all employees whose 
first name is “Margareta” and have the last name “Markovitch”.*/
SELECT 
    e.first_name, e.last_name, e.hire_date, t.title
FROM
    employees E
        JOIN
    titles t ON e.emp_no = t.emp_no
WHERE
    first_name = 'Margareta'
        AND last_name = 'Markovitch'
ORDER BY e.emp_no;

---------------------- Break ----------------------

# 188. CROSS JOIN
-- 1 
SELECT 
    dm.*, d.*
FROM
    dept_manager dm
        CROSS JOIN
    departments d
ORDER BY dm.emp_no , d.dept_no;

-- 2 
SELECT 
    dm.*, d.*
FROM
    dept_manager dm,
    departments d
ORDER BY dm.emp_no , d.dept_no;

-- 3
SELECT 
    dm.*, d.*
FROM
    dept_manager dm
		JOIN  
    departments d
ORDER BY dm.emp_no , d.dept_no;

-- 1,2,3 all code give same result but 1 is the best preactice for readability

-- in the above code dept_no is not matching in the both the table 

SELECT 
    dm.*, d.*
FROM
    dept_manager dm
        CROSS JOIN
    departments d
WHERE
    dm.dept_no <> d.dept_no  # <> Means not equal to 
ORDER BY dm.emp_no , d.dept_no;

-- CROSS JOIN AND JOIN BOTH or (crossing more than two table )
SELECT 
    e.*, d.*
FROM
    departments d
        CROSS JOIN
    dept_manager dm
        JOIN
    employees e
    ON e.emp_no = dm.emp_no
WHERE
    dm.dept_no = d.dept_no
ORDER BY dm.emp_no , d.dept_no;

-- we have just run the condition not the employees whose working in a 
-- specific department.

/* CROSS JOIN - exercise 1
Use a CROSS JOIN to return a list with all possible combinations between 
managers from the dept_manager table and department number 9. */
SELECT 
    dm.*, d.*
FROM
    dept_manager dm
        CROSS JOIN
    departments d
WHERE
    d.dept_no = 'd009'
ORDER BY dm.emp_no;

/* CROSS JOIN - exercise 2
Return a list with the first 10 employees with all the departments 
they can be assigned to.

Hint: Don’t use LIMIT; use a WHERE clause.*/
SELECT 
    e.*, d.*
FROM
    employees E
        CROSS JOIN
    departments D
WHERE
    e.emp_no < 10011
ORDER BY e.emp_no , d.dept_no;

---------------------- Break ----------------------

# 193. Using Aggregate Functions with Joins
SELECT 
    e.gender, AVG(s.salary) AS salary_by_gender
FROM
    employees e
        JOIN
    salaries s ON e.emp_no = s.emp_no
GROUP BY e.gender;  

---------------------- Break ----------------------

# 194. JOIN more than two tables in SQL
-- display first_name, last_name, hire_date, from_date, dept_name
SELECT 
    e.first_name,
    e.last_name,
    e.hire_date,
    m.from_date,
    d.dept_name
FROM
    employees e
        JOIN
    dept_manager m ON e.emp_no = m.emp_no
        JOIN
    departments d ON m.dept_no = d.dept_no;
    
-- 2nd way 
SELECT 
    e.first_name,
    e.last_name,
    e.hire_date,
    m.from_date,
    d.dept_name
FROM
    departments d
        JOIN
    dept_manager m ON d.dept_no = m.dept_no
        JOIN
    employees e ON m.emp_no = e.emp_no;

-- same way, joinig of left and right join can be done but 
-- the result will be different

/* Join more than two tables in SQL - exercise
Select all managers’ first and last name, hire date, job title, start date, 
and department name.*/
SELECT 
    e.first_name,
    e.last_name,
    e.hire_date,
    t.title,
    m.from_date,
    d.dept_name
FROM
    employees e
        JOIN
    dept_manager m ON e.emp_no = m.emp_no
        JOIN
    departments d ON m.dept_no = d.dept_no
        JOIN
    titles t ON e.emp_no = t.emp_no
WHERE
    t.title = 'manager'
ORDER BY e.first_name;

---------------------- Break ----------------------

# 197. Tips and tricks for joins
SELECT 
    d.dept_name, AVG(salary) AS average_salary
FROM
    departments d
        JOIN
    dept_manager m ON d.dept_no = m.dept_no
        JOIN
    salaries s ON m.emp_no = s.emp_no;
-- only get one department avg salary 

SELECT 
    d.dept_name, AVG(salary) AS average_salary
FROM
    departments d
        JOIN
    dept_manager m ON d.dept_no = m.dept_no
        JOIN
    salaries s ON m.emp_no = s.emp_no
GROUP BY d.dept_name
ORDER BY AVG(salary) DESC;


-- USE OF HAVING IN THE PREVIOUS CODE
SELECT 
    d.dept_name, AVG(salary) AS average_salary
FROM
    departments d
        JOIN
    dept_manager m ON d.dept_no = m.dept_no
        JOIN
    salaries s ON m.emp_no = s.emp_no
GROUP BY d.dept_name
HAVING average_salary > 60000
ORDER BY average_salary DESC;

/* Tips and tricks for joins - exercise
How many male and how many female managers do we have in 
the ‘employees’ database? */
SELECT 
    e.gender, COUNT(gender) AS count_by_gender
FROM
    employees e
        JOIN
    dept_manager m ON e.emp_no = m.emp_no
GROUP BY e.gender;

---------------------- Break ----------------------

# 200. UNION vs UNION ALL
-- for this lesson lets create employees_dup tabel
DROP TABLE IF EXISTS employees_dup;
CREATE TABLE employees_dup (
    emp_no INT,
    birth_date DATE,
    first_name VARCHAR(14),
    last_name VARCHAR(16),
    gender ENUM('M', 'F'),
    hire_date DATE
);
-- insert 20  values from employees table 
INSERT INTO employees_dup 
SELECT e.* 
FROM employees e 
LIMIT 20;

-- Now insert a rom 1 one for creating a duplicate row
INSERT INTO employees_dup 
VALUES (10001, '1953-09-02', 'Georgi', 'Facello', 'M', '1986-06-26');

-- NOW LOOK into the table 
SELECT 
    *
FROM
    employees_dup
ORDER BY emp_no;

-- Now union all
SELECT 
    e.emp_no,
    e.first_name,
    e.last_name,
    NULL AS dept_no,
    NULL AS from_date
FROM
    employees_dup e
WHERE
    emp_no = 10001 
UNION ALL SELECT 
    NULL AS emp_no,
    NULL AS first_name,
    NULL AS last_name,
    m.dept_no,
    m.from_date
FROM
    dept_manager m;

-- union
SELECT 
    e.emp_no,
    e.first_name,
    e.last_name,
    NULL AS dept_no,
    NULL AS from_date
FROM
    employees_dup e
WHERE
    emp_no = 10001 
UNION SELECT       # UNION WILL NOT RETURN DUPLICATE ROW BUT union all will return
    NULL AS emp_no,
    NULL AS first_name,
    NULL AS last_name,
    m.dept_no,
    m.from_date
FROM
    dept_manager m;
    
/* UNION vs UNION ALL - exercise
Go forward to the solution and execute the query. 
What do you think is the meaning of the minus sign 
before subset A in the last row (ORDER BY -a.emp_no DESC)? */
SELECT * 
FROM 
(
SELECT 
    e.emp_no,
    e.first_name,
    e.last_name,
    NULL AS dept_no,
    NULL AS from_date
FROM
    employees_dup e
WHERE
    emp_no = 10001 
UNION ALL SELECT 
    NULL AS emp_no,
    NULL AS first_name,
    NULL AS last_name,
    m.dept_no,
    m.from_date
FROM
    dept_manager m
) AS a
ORDER BY -a.emp_no DESC;

---------------------- End of the section ----------------------
