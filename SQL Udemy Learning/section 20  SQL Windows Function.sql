# 257. Introduction to MySQL Window Functions
# 258. The ROW_NUMBER() Ranking Window Function and the Relevant MySQL Syntax

USE employees;
-- ----------------------

SELECT emp_no,
	salary,
	ROW_NUMBER() OVER() AS row_num
FROM salaries;

-- -------------------------

SELECT emp_no,salary,
	ROW_NUMBER() OVER(PARTITION BY emp_no) AS row_num
FROM salaries;

-- In row number 15 and 16, salary was not in ordered
-- ----------------------------

SELECT emp_no,salary,
	ROW_NUMBER() OVER(PARTITION BY emp_no ORDER BY salary DESC) AS row_num
FROM salaries;

-- -----------------------------------

/* Exercise #1 :
Write a query that upon execution, assigns a row number to all managers 
we have information for in the "employees" database 
(regardless of their department).

Let the numbering disregard the department the managers have 
worked in. Also, let it start from the value of 1. 
Assign that value to the manager with the lowest employee number.*/

SELECT *, 
	ROW_NUMBER() OVER(ORDER BY emp_no) AS row_num
FROM 
	dept_manager;

-- --------------------------------------------

/* Exercise #2:
Write a query that upon execution, assigns a sequential number for 
each employee number registered in the "employees" table. 
Partition the data by the employee's first name and order it by 
their last name in ascending order (for each partition).*/

SELECT *, 
		ROW_NUMBER() OVER(PARTITION  BY first_name ORDER BY last_name) as row_num
FROM 
	employees;

-- -------------------------------------------------------------

# 261. A Note on Using Several Window Functions in a Query

SELECT emp_no,
		salary, 
        ROW_NUMBER() OVER() AS row_num_1,
        ROW_NUMBER() OVER(PARTITION BY emp_no) AS row_num_2,
        ROW_NUMBER() OVER(PARTITION BY emp_no ORDER BY salary DESC) AS row_num_3,
        ROW_NUMBER() OVER(ORDER BY salary DESC) AS row_num_4
FROM salaries;

# very messi output
-- -----------------------------------------------------------------
SELECT emp_no,
		salary, 
        # ROW_NUMBER() OVER() AS row_num_1,
        ROW_NUMBER() OVER(PARTITION BY emp_no ORDER BY salary) AS row_num_2,
        ROW_NUMBER() OVER(PARTITION BY emp_no ORDER BY salary DESC) AS row_num_3
        # ROW_NUMBER() OVER(ORDER BY salary DESC) AS row_num_4
FROM salaries
ORDER BY emp_no,salary;

-- -------------------------------------------------------------------------------------------
-- QUE IS  VEY EASY JUST READ CAREFULLY
/*Exercise #1:

Obtain a result set containing the salary values each manager has signed a contract for. 
To obtain the data, refer to the "employees" database.

Use window functions to add the following two columns to the final output:

- a column containing the row number of each row from the obtained dataset, starting from 1.

- a column containing the sequential row numbers associated to the rows for each manager, 
where their highest salary has been given a number equal to the number of rows in the given 
partition, and their lowest - the number 1.

Finally, while presenting the output, make sure that the data has been ordered by the 
values in the first of the row number columns, and then by the salary values for each 
partition in ascending order.*/

SELECT dm.*,
		s.salary,
		ROW_NUMBER() OVER() AS row_num_1,
        ROW_NUMBER() OVER(PARTITION BY emp_no ORDER BY s.salary) AS row_num_2
FROM dept_manager dm
		JOIN
	salaries s ON dm.emp_no = s.emp_no
ORDER BY emp_no,salary;

-- ---------------------------------------------------------------------------------------------

/* Exercise #2:

Obtain a result set containing the salary values each manager has signed a contract for. 
To obtain the data, refer to the "employees" database.

Use window functions to add the following two columns to the final output:

- a column containing the row numbers associated to each manager, where their highest salary 
has been given a number equal to the number of rows in the given partition, and their lowest - 
the number 1.

- a column containing the row numbers associated to each manager, where their highest salary 
has been given the number of 1, and the lowest - a value equal to the number of rows in the given
partition.

Let your output be ordered by the salary values associated to each manager in descending order.

Hint: Please note that you don't need to use an ORDER BY clause in your SELECT statement 
to retrieve the desired output.*/

SELECT dm.*,
		s.salary,
		ROW_NUMBER() OVER(PARTITION BY emp_no ORDER BY s.salary ASC) AS row_num_1,
        ROW_NUMBER() OVER(PARTITION BY emp_no ORDER BY s.salary DESC) AS row_num_2
FROM dept_manager dm
		JOIN
	salaries s ON dm.emp_no = s.emp_no;
    
-- ----------------------------------------------------------------------------------------
##########
# 264. MySQL Window Functions Syntax

SELECT emp_no,
		salary,
        ROW_NUMBER() OVER(PARTITION BY emp_no ORDER BY salary DESC)  AS row_num
FROM salaries;

-- -- another method 
SELECT emp_no,
		salary,
        ROW_NUMBER() OVER w AS row_num
FROM salaries
WINDOW w AS (PARTITION BY emp_no ORDER BY salary DESC);

/* Exercise #1:
Write a query that provides row numbers for all workers from the "employees" table, 
partitioning the data by their first names and ordering each partition by their employee 
number in ascending order.

NB! While writing the desired query, do *not* use an ORDER BY clause in the relevant 
SELECT statement. At the same time, do use a WINDOW clause to provide the required window 
specification. */

SELECT emp_no,
	first_name,
	ROW_NUMBER() OVER w AS row_num
FROM employees
WINDOW w as (PARTITION BY first_name ORDER BY emp_no ASC);

-- ----------------------------------------------------------------------------------------
#################
# 267. The PARTITION BY Clause VS the GROUP BY Clause
SELECT * FROM employees ;
SELECT * FROM salaries;
SELECT * FROM salaries GROUP BY emp_no;

-- ------------------------

SELECT emp_no, 
		salary,
		ROW_NUMBER() OVER(PARTITION BY emp_no ORDER BY  salary) AS row_num
FROM 
	salaries;
-- -------------------------------------------------
# 1st
SELECT a.emp_no,
		MAX(salary) as max_salary
FROM    (SELECT emp_no, 
			salary,
			ROW_NUMBER() OVER w AS row_num
	FROM 
		salaries
	WINDOW w as (PARTITION BY emp_no ORDER BY  salary)) AS a
GROUP BY emp_no;
-- -------------------------------------------------------------------
# 2nd
SELECT a.emp_no,
		MAX(salary) as max_salary
FROM    (SELECT emp_no, 
			salary,
			ROW_NUMBER() OVER (PARTITION BY emp_no ORDER BY  salary) AS row_num
	FROM 
		salaries) AS a
GROUP BY emp_no;

-- LAST two code will give same result
-- -----------------------------------------------------------------------------------
-- without partition 
# 3rd
SELECT 
	B.emp_no, 
    max(salary) as max_salary
FROM (SELECT * FROM salaries) as B
GROUP BY emp_no;

-- --------------------------------------------------------------------------------------
# 4th sol
SELECT a.emp_no,
		a.salary as max_salary
FROM    (SELECT emp_no, 
			salary,
			ROW_NUMBER() OVER (PARTITION BY emp_no ORDER BY  salary DESC)  AS row_num
	FROM 
		salaries) AS a
WHERE  a.row_num = 1;

-- 1st,2nd,3rd and 4th will give the same result

-- -------------------------------------------------------------------------------------------

/* Exercise #1:

Find out the lowest salary value each employee has ever signed a contract for. 
To obtain the desired output, use a subquery containing a window function, as well 
as a window specification introduced with the help of the WINDOW keyword.

Also, to obtain the desired result set, refer only to data from the “salaries” table.*/
SELECT A.emp_no,
		MIN(salary) AS min_salary
FROM 
	(SELECT emp_no,
			salary, 
			ROW_NUMBER() OVER w AS row_num 
	FROM salaries 
	WINDOW w as (PARTITION BY emp_no ORDER BY salary ASC)) AS A
GROUP BY emp_no;
-- ---------------------------------------------------------------------------------------------------

/* Exercise #2:

Again, find out the lowest salary value each employee has ever signed a contract for. 
Once again, to obtain the desired output, use a subquery containing a window function. 
This time, however, introduce the window specification in the field list of the given subquery.

To obtain the desired result set, refer only to data from the “salaries” table. */

SELECT A.emp_no,
	   MIN(salary) AS min_salary
FROM 
	(SELECT emp_no,
			salary, 
			ROW_NUMBER() OVER (PARTITION BY emp_no ORDER BY salary ASC) AS row_num 
	FROM salaries ) AS A
GROUP BY emp_no;
-- -----------------------------------------------------------------------------------------
/* Exercise #3:
Once again, find out the lowest salary value each employee has ever signed 
a contract for. This time, to obtain the desired output, avoid using a window function.
Just use an aggregate function and a subquery.

To obtain the desired result set, refer only to data from the “salaries” table.*/
SELECT 
	a.emp_no,MIN(salary) AS min_salary
FROM 
	(SELECT emp_no,salary FROM salaries) AS a 
GROUP BY emp_no;
-- --------------------------------------------------------------------------------------------
/* Exercise #4:

Once more, find out the lowest salary value each employee has ever signed a contract for. 
To obtain the desired output, use a subquery containing a window function, as well as a 
window specification introduced with the help of the WINDOW keyword. Moreover, obtain the 
output without using a GROUP BY clause in the outer query.

To obtain the desired result set, refer only to data from the “salaries” table. */

SELECT A.emp_no,
		A.salary
FROM 
	(SELECT emp_no,
			salary, 
			ROW_NUMBER() OVER w AS row_num 
	FROM salaries 
	WINDOW w as (PARTITION BY emp_no ORDER BY salary ASC)) AS A
WHERE A.row_num = 1;
-- ----------------------------------------------------------------------------------------
/* Exercise #5:

Find out the second-lowest salary value each employee has ever signed a contract for. 
To obtain the desired output, use a subquery containing a window function, as well as 
a window specification introduced with the help of the WINDOW keyword. Moreover, obtain 
the desired result set without using a GROUP BY clause in the outer query.

To obtain the desired result set, refer only to data from the “salaries” table.*/

SELECT A.emp_no,
		A.salary
FROM 
	(SELECT emp_no,
			salary, 
			ROW_NUMBER() OVER w AS row_num 
	FROM salaries 
	WINDOW w as (PARTITION BY emp_no ORDER BY salary ASC)) AS A
WHERE A.row_num = 2;

-- --------------------------------------------------------------------------------------------------
############## 

# 270. The MySQL RANK() and DENSE_RANK() Window Functions
-- Return output of those emp who has worked in more than 1 contract without salary hike
SELECT 
	emp_no, (COUNT(salary) - COUNT(DISTINCT salary)) AS diff
FROM 
	salaries
GROUP BY emp_no
HAVING diff > 0
ORDER BY emp_no;
-- 205 emp sign contract without salary hike from the previous contract 
-- -----------------------------------------------------------------------------------------------------
SELECT * FROM salaries WHERE emp_no = 11839;

SELECT 
	emp_no, salary, 
    ROW_NUMBER() OVER(PARTITION BY emp_no ORDER BY salary DESC) as row_num
FROM 
	salaries
WHERE emp_no = 11839 ;
-- ROW 3 and 4 have same salary entry 
-- ----------------------------------------------------------------------------

SELECT 
	emp_no, salary, 
    RANK() OVER(PARTITION BY emp_no ORDER BY salary DESC) as rank_num
FROM 
	salaries
WHERE emp_no = 11839 ;

-- now rank of row 3 and 4 is same which is 3. but there is no rank_num = 4 it shift to 5 so comes demce_rank function
-- --------------------------------------------------------------------------

SELECT 
	emp_no, salary, 
    DENSE_RANK() OVER(PARTITION BY emp_no ORDER BY salary DESC) as rank_num
FROM 
	salaries
WHERE emp_no = 11839 ;
-- NOW RANK NUM = 4 is visible.

-- -----------------------------------------------------------------

/* Exercise #1:

Write a query containing a window function to obtain all salary values that employee number 
10560 has ever signed a contract for.

Order and display the obtained salary values from highest to lowest.*/
SELECT 
	emp_no, salary,
    ROW_NUMBER() OVER(PARTITION BY emp_no ORDER BY salary DESC) AS row_num
FROM 
	salaries
WHERE emp_no = 10560;
-- --------------------------------------------------------------------------------------------

/* Exercise #2:

Write a query that upon execution, displays the number of salary contracts that each manager 
has ever signed while working in the company.*/

SELECT 	
		dm.emp_no, count(s.salary) AS no_of_contract
FROM 
	salaries s
		JOIN
	dept_manager dm ON s.emp_no = dm.emp_no
GROUP BY emp_no
ORDER BY emp_no;

-- ------------------------------------------------------------------------

/* Exercise #3:

Write a query that upon execution retrieves a result set containing all salary values that employee 10560 
has ever signed a contract for. Use a window function to rank all salary values from highest to lowest in 
a way that equal salary values bear the same rank and that gaps in the obtained ranks for subsequent rows 
are allowed. */

SELECT
	emp_no, salary,
    RANK() OVER(PARTITION BY emp_no ORDER BY salary) AS rank_num
FROM 
	salaries
WHERE emp_no = 10560;
-- -----------------------------------------------------------------------------------------
# 2ND Sol

SELECT
	emp_no,
	salary,
	RANK() OVER w AS rank_num
FROM
	salaries
WHERE emp_no = 10560
WINDOW w AS (PARTITION BY emp_no ORDER BY salary DESC);

-----------------------------------------------------------------------------------------

/* Exercise #4:

Write a query that upon execution retrieves a result set containing all salary values that employee 10560 
has ever signed a contract for. Use a window function to rank all salary values from highest to lowest in a 
way that equal salary values bear the same rank and that gaps in the obtained ranks for subsequent rows are 
not allowed. */

SELECT
	emp_no, salary,
    DENSE_RANK() OVER(PARTITION BY emp_no ORDER BY salary) AS rank_num
FROM 
	salaries
WHERE emp_no = 10560;

-- --------------------------------------------------------------------------------------

######################### 

# 273. Working with MySQL Ranking Window Functions and Joins Together

SELECT 
		d.dept_no,
        d.dept_name,
        dm.emp_no,
        RANK() OVER w AS dept_wise_salary_rank,
        s.salary AS salary,
        s.from_date AS salary_from_date,
        s.to_date AS salary_to_date,
        dm.from_date AS dept_from_date,
        dm.to_date AS dept_to_date
        
FROM dept_manager dm
		JOIN 
	salaries s  ON s.emp_no = dm.emp_no
		JOIN 
	departments d ON dm.dept_no = d.dept_no
    
WINDOW w AS (PARTITION  BY dm.dept_no order by s.salary DESC);

-- some of the obtained salary values may have been taken 
-- from periods when these people had occupied differernt positions in the bussiness
-- so 
SELECT 
		d.dept_no,
        d.dept_name,
        dm.emp_no,
        RANK() OVER w AS dept_wise_salary_rank,
        s.salary AS salary,
        s.from_date AS salary_from_date,
        s.to_date AS salary_to_date,
        dm.from_date AS dept_from_date,
        dm.to_date AS dept_to_date
        
FROM salaries s
		JOIN 
	dept_manager dm   ON s.emp_no = dm.emp_no                    
    AND s.from_date BETWEEN dm.from_date AND dm.to_date         # CHANGE
    AND s.to_date BETWEEN  dm.from_date AND dm.to_date
		JOIN 
	departments d ON dm.dept_no = d.dept_no
    
WINDOW w AS (PARTITION  BY dm.dept_no order by s.salary DESC);
-- ------------------------------------------------------------------------------------------------------
/* Exercise #1:

Write a query that ranks the salary values in descending order of all contracts signed by employees numbered 
between 10500 and 10600 inclusive. Let equal salary values for one and the same employee bear the same rank. 
Also, allow gaps in the ranks obtained for their subsequent rows.

Use a join on the “employees” and “salaries” tables to obtain the desired result.*/

SELECT
		e.emp_no,
        RANK() OVER w AS salary_rank,
        s.salary
FROM employees e
		JOIN
	  salaries s ON e.emp_no = s.emp_no
WHERE e.emp_no BETWEEN 10500 AND 10600
WINDOW w AS (PARTITION BY e.emp_no ORDER BY s.salary DESC) 
ORDER BY e.emp_no;

-- -------------------------------------------------------------------------------------------------------

/* Exercise #2:

Write a query that ranks the salary values in descending order of the following contracts from 
the "employees" database:

- contracts that have been signed by employees numbered between 10500 and 10600 inclusive.

- contracts that have been signed at least 4 full-years after the date when the given employee 
was hired in the company for the first time.

In addition, let equal salary values of a certain employee bear the same rank. 
Do not allow gaps in the ranks obtained for their subsequent rows.

Use a join on the “employees” and “salaries” tables to obtain the desired result. */
SELECT
		e.emp_no,
        DENSE_RANK() OVER w AS salary_rank,
        s.salary,
        e.hire_date,
        s.from_date,
        (YEAR(s.from_date )- YEAR(e.hire_date))  AS year_from_start
FROM employees e
		JOIN
	  salaries s ON e.emp_no = s.emp_no
      AND (YEAR(s.from_date )- YEAR(e.hire_date)) >= 5
WHERE e.emp_no BETWEEN 10500 AND 10600
WINDOW w AS (PARTITION BY e.emp_no ORDER BY s.salary DESC) 
ORDER BY e.emp_no;

-- -----------------------------------------------------------------------------------------------------

# 276. The LAG() and LEAD() Value Window Functions

SELECT * FROM salaries LIMIT 10;

SELECT 
	  emp_no,
      salary,
      LAG(salary) OVER w AS previous_salary,
      LEAD(salary) OVER w AS next_salary,
      salary - LAG(salary) OVER w AS diff_salary_curr_previous,
      LEAD(salary) OVER w - salary AS diff_salary_next_curr
      
FROM
    salaries
WHERE emp_no = 10001
WINDOW w AS (ORDER BY salary);

/* Exercise #1:

Write a query that can extract the following information from the "employees" database:

- the salary values (in ascending order) of the contracts signed by all employees 
numbered between 10500 and 10600 inclusive

- a column showing the previous salary from the given ordered list

- a column showing the subsequent salary from the given ordered list

- a column displaying the difference between the current salary of a certain 
employee and their previous salary

- a column displaying the difference between the next salary of a 
certain employee and their current salary

Limit the output to salary values higher than $80,000 only.

Also, to obtain a meaningful result, partition the data by employee number.*/

SELECT 
	  emp_no,
      salary,
      LAG(salary) OVER w AS previous_salary,
      LEAD(salary) OVER w AS next_salary,
      salary - LAG(salary) OVER w AS diff_salary_curr_previous,
      LEAD(salary) OVER w - salary AS diff_salary_next_curr
      
FROM
    salaries
WHERE (emp_no BETWEEN 10500 and 10600) AND salary > 80000
WINDOW w AS (ORDER BY salary);

-- --------------------------------------------------------------------------------------

/* Exercise #2:

The MySQL LAG() and LEAD() value window functions can have a second argument, 
designating how many rows/steps back (for LAG()) or forth (for LEAD()) we'd like 
to refer to with respect to a given record.

With that in mind, create a query whose result set contains data arranged by the 
salary values associated to each employee number (in ascending order). 
Let the output contain the following six columns:

- the employee number

- the salary value of an employee's contract 
(i.e. which we’ll consider as the employee's current salary)

- the employee's previous salary

- the employee's contract salary value preceding their previous salary

- the employee's next salary

- the employee's contract salary value subsequent to their next salary

Restrict the output to the first 1000 records you can obtain.*/

SELECT
	emp_no,
    salary,
    LAG(salary) OVER w AS previous_salary,
	LAG(salary, 2) OVER w AS 1_before_previous_salary,
	LEAD(salary) OVER w AS next_salary,
    LEAD(salary, 2) OVER w AS 1_after_next_salary
FROM
	salaries
WINDOW w AS (PARTITION BY emp_no ORDER BY salary)
LIMIT 1000;
-- -------------------------------------------------------------------------------- 

############################################################

# 279. MySQL Aggregate Functions in the Context of Window Functions - Part I

/*Create  a MySQL query that will extract the follwing information about all 
current employed workers registered in the dept_emp table:

- emp_no
- dept 
- salary  latest
- all time avg salary */
SELECT SYSDATE();
SELECT * FROM salaries WHERE to_date > SYSDATE();
-- -----------------------------

SELECT 
    emp_no, salary, MAX(to_date), from_date
FROM
    salaries
WHERE
    to_date > SYSDATE()
GROUP BY emp_no ;
-- --------------------------------------------
SELECT s1.emp_no,s.salary,s.to_date,s.from_date
FROM salaries s 
		JOIN 
	( SELECT 
		emp_no, salary, MAX(to_date), from_date
	FROM
		salaries
	WHERE
		to_date > SYSDATE()
	GROUP BY emp_no) AS s1
WHERE s.to_date > SYSDATE()
	AND s.from_date = s1.from_date;
    
-- ----------------------------------------- 

/* Exercise #1:

Create a query that upon execution returns a result set containing the employee numbers,
 contract salary values, start, and end dates of the first ever contracts that 
 each employee signed for the company.

To obtain the desired output, refer to the data stored in the "salaries" table. */
SELECT
    s1.emp_no, s.salary, s.from_date, s.to_date
FROM
    salaries s
        JOIN
    (SELECT
        emp_no, MIN(from_date) AS from_date
    FROM
        salaries
    GROUP BY emp_no) s1 ON s.emp_no = s1.emp_no
WHERE
    s.from_date = s1.from_date;
    
-- ------------------------------------------------------------------------------

 
 /* Exercise #1:

Consider the employees' contracts that have been signed after the 1st of January 2000 
and terminated before the 1st of January 2002 (as registered in the "dept_emp" table).

Create a MySQL query that will extract the following information about these employees:

- Their employee number

- The salary values of the latest contracts they have signed during the suggested 
time period

- The department they have been working in (as specified in the latest contract they've 
signed during the suggested time period)

- Use a window function to create a fourth field containing the average salary paid 
in the department the employee was last working in during the suggested time period. Name that field "average_salary_per_department".



Note1: This exercise is not related neither to the query you created nor to the output 
you obtained while solving the exercises after the previous lecture.

Note2: Now we are asking you to practically create the same query as the one we worked 
on during the video lecture; the only difference being to refer to contracts that have been valid within the period between the 1st of January 2000 and the 1st of January 2002.

Note3: We invite you solve this task after assuming that the "to_date" values stored in 
the "salaries" and "dept_emp" tables are greater than the "from_date" values stored in 
these same tables. If you doubt that, you could include a couple of lines in your code 
to ensure that this is the case anyway!

Hint: If you've worked correctly, you should obtain an output containing 200 rows. */
 
SELECT
    de2.emp_no, d.dept_name, s2.salary, 
    AVG(s2.salary) OVER w AS average_salary_per_department
FROM
    (SELECT
		de.emp_no, de.dept_no, de.from_date, de.to_date
	FROM
		dept_emp de
        JOIN
	(SELECT
		emp_no, MAX(from_date) AS from_date
	FROM
		dept_emp
	GROUP BY emp_no) de1 ON de1.emp_no = de.emp_no
WHERE
    de.to_date < '2002-01-01'
AND de.from_date > '2000-01-01'
AND de.from_date = de1.from_date) de2

JOIN
    (SELECT
		s1.emp_no, s.salary, s.from_date, s.to_date
	FROM
		salaries s
    JOIN
    (SELECT
			emp_no, MAX(from_date) AS from_date
	FROM
		salaries
    GROUP BY emp_no) s1 ON s.emp_no = s1.emp_no
WHERE
    s.to_date < '2002-01-01'
AND s.from_date > '2000-01-01'
AND s.from_date = s1.from_date) s2 ON s2.emp_no = de2.emp_no

JOIN

    departments d ON d.dept_no = de2.dept_no

	GROUP BY de2.emp_no, d.dept_name

WINDOW w AS (PARTITION BY de2.dept_no)

ORDER BY de2.emp_no, salary;

-- -------------------------- end of section ----------------------------------