# 285. MySQL Common Table Expressions - Introduction

/* How many salary contract have been signed by female condidate whose salary is above
the average salary of all emp in the company? */

SELECT AVG(salary) FROM salaries; # get to know average salary of all emp in company

-- -----------------------------------------------------------------------------------------------------------

WITH c AS( SELECT AVG(salary) AS average_salary FROM salaries)
SELECT 
	SUM(CASE WHEN s.salary > c.average_salary THEN 1 ELSE 0 END )  AS no_female_salary_above_avg_salary,
    COUNT(s.salary) AS number_of_salary_contracts
FROM 
	salaries s 
		JOIN 
	employees e ON e.emp_no = s.emp_no AND e.gender = 'F'
	CROSS JOIN 
       c;
       
-- ---------------------------------------------------------------------------------------------------------------

-- another solution  - cte as c 

WITH ctc  AS( SELECT AVG(salary) AS average_salary FROM salaries)
SELECT 
	SUM(CASE WHEN s.salary > c.average_salary THEN 1 ELSE 0 END )  AS no_female_salary_above_avg_salary,
    COUNT(s.salary) AS number_of_salary_contracts
FROM 
	salaries s 
		JOIN 
	employees e ON e.emp_no = s.emp_no AND e.gender = 'F'
	CROSS JOIN 
        ctc  c ;
-- -----------------------------------------------------------------------------------------------------------

-- another solution  - only  c 

WITH c AS( SELECT AVG(salary) AS average_salary FROM salaries)
SELECT 
	SUM(CASE WHEN s.salary > c.average_salary THEN 1 ELSE 0 END )  AS no_female_salary_above_avg_salary,
    COUNT(s.salary) AS number_of_salary_contracts
FROM 
	salaries s 
		JOIN 
	employees e ON e.emp_no = s.emp_no AND e.gender = 'F'
	CROSS JOIN 
        c;
        
-- ------------------------------------------------------------------------------------------------

WITH cte AS( SELECT AVG(salary) AS average_salary FROM salaries)
SELECT * FROM cte c; /*resutt same as*/ SELECT AVG(salary) FROM salaries;

-- ---------------------------------------------------------------------------------------------------------------

WITH cte AS( SELECT AVG(salary) AS average_salary FROM salaries)
SELECT 
	* 
FROM  salaries s 
	JOIN 
    cte c;

-- -----------------------------------------------------------------------------------------------------------

WITH cte AS( SELECT AVG(salary) AS average_salary FROM salaries)
SELECT 
	* 
FROM  salaries s 
		JOIN 
    employees e ON e.emp_no = s.emp_no AND e.gender = 'F'
		JOIN
    cte c;
    
-- --------------------------------------------------------------------------------------------

WITH cte AS( SELECT AVG(salary) AS average_salary FROM salaries)
SELECT 
	SUM(CASE WHEN s.salary > c.average_salary
		THEN 1 ELSE 0 
		END) AS n_f_emp_salary_more_than_avg,
	COUNT(s.salary) AS NO_OF_contract_signed
    
FROM  salaries s 
		JOIN 
    employees e ON e.emp_no = s.emp_no AND e.gender = 'F'
		JOIN
    cte c;
    
-- -----------------------------------------------------------------------------------------------------------------
-- 2nd solution
SELECT 
	SUM(CASE WHEN s.salary > a.average_salary
		THEN 1 ELSE 0 
		END) AS n_f_emp_salary_more_than_avg,
	COUNT(s.salary) AS NO_OF_contract_signed
    
FROM  salaries s 
		JOIN 
    employees e ON e.emp_no = s.emp_no AND e.gender = 'F'
		JOIN
    (SELECT AVG(salary) AS average_salary FROM salaries) as a;
    
#########################################

# 286. An Alternative Solution to the Same Task
WITH cte AS( SELECT AVG(salary) AS average_salary FROM salaries)
SELECT 
	SUM(CASE WHEN s.salary > a.average_salary
		THEN 1 ELSE 0 
		END) AS n_f_emp_salary_more_than_avg,
	COUNT(CASE WHEN s.salary > a.average_salary
		THEN s.salary ELSE NULL
		END) AS n_f_emp_salary_more_than_avg,
	COUNT(s.salary) AS NO_OF_contract_signed
    
FROM  salaries s 
		JOIN 
    employees e ON e.emp_no = s.emp_no AND e.gender = 'F'
		JOIN
		cte a;
-- ----------------------------------------------------------------------------------------------------------

# 287. Using Multiple Subclauses in a WITH Clause - Part I

/* How many female employees' highest contract salary values were higher than the all-time company 
salary average (across all genders)? 
Note -  Highest salary value of an employee may not have been higher than the all-time 
company average. So, we'll only be interested in the rest of the cases for our task.*/

SELECT AVG(salary) AS avg_salary FROM salaries; # get output about avg salary of all gender salary 

-- Furthur quary will give result about all female emp highest salary 
SELECT 
	 s.emp_no,gender, MAX(salary)
FROM salaries s
		JOIN 
      employees e ON e.emp_no = s.emp_no AND gender = 'F'
GROUP BY emp_no; 

-- NOW COMBINE all by with cte 

WITH cte_1 AS ( SELECT AVG(salary) AS avg_salary FROM salaries),
     cte_2 AS ( SELECT 
					 s.emp_no,gender, MAX(salary) AS f_highest_salary
				FROM salaries s
						JOIN 
					  employees e ON e.emp_no = s.emp_no AND gender = 'F'
				GROUP BY emp_no)
SELECT 
	  SUM( CASE WHEN c2.f_highest_salary > c1.avg_salary THEN 1 ELSE 0 END) AS f_emp_maxsalary_more_than_avgsalary,
      COUNT(e.emp_no) as total_no_of_f_contracts
FROM 
	 employees e 
      JOIN 
      cte_2  c2 ON c2.emp_no = e.emp_no
      JOIN 
      cte_1  c1;
      
#####################################################################################

# 288. Using Multiple Subclauses in a WITH Clause - Part II

-- use count instead sum 

WITH cte_1 AS ( SELECT AVG(salary) AS avg_salary FROM salaries),
     cte_2 AS ( SELECT 
					 s.emp_no,gender, MAX(salary) AS f_highest_salary
				FROM salaries s
						JOIN 
					  employees e ON e.emp_no = s.emp_no AND gender = 'F'
				GROUP BY emp_no)
SELECT 
	  COUNT( CASE WHEN c2.f_highest_salary > c1.avg_salary THEN c2.f_highest_salary ELSE NULL END) AS f_emp_maxsalary_more_than_avgsalary,
      COUNT(e.emp_no) as total_no_of_f_contracts
FROM 
	 employees e 
      JOIN 
      cte_2  c2 ON c2.emp_no = e.emp_no
      JOIN 
      cte_1  c1;
      
-- -----------------------------------------------------------------------------------------------

-- ADD percentage

WITH cte_1 AS ( SELECT AVG(salary) AS avg_salary FROM salaries),
     cte_2 AS ( SELECT 
					 s.emp_no,gender, MAX(salary) AS f_highest_salary
				FROM salaries s
						JOIN 
					  employees e ON e.emp_no = s.emp_no AND gender = 'F'
				GROUP BY emp_no)
SELECT 
	  COUNT( CASE WHEN c2.f_highest_salary > c1.avg_salary THEN c2.f_highest_salary ELSE NULL END) AS f_emp_maxsalary_more_than_avgsalary,
      COUNT(e.emp_no) as total_no_of_f_contracts,
      (SUM( CASE WHEN c2.f_highest_salary > c1.avg_salary THEN 1 ELSE 0 END) / COUNT(e.emp_no)) * 100 AS percentage_of_fem_whose_condition_met
FROM 
	 employees e 
      JOIN 
      cte_2  c2 ON c2.emp_no = e.emp_no
      JOIN 
      cte_1  c1;
      
-- ROUND ---------------------------------------------------------------------------

-- ROUND

WITH cte_1 AS ( SELECT AVG(salary) AS avg_salary FROM salaries),
     cte_2 AS ( SELECT 
					 s.emp_no,gender, MAX(salary) AS f_highest_salary
				FROM salaries s
						JOIN 
					  employees e ON e.emp_no = s.emp_no AND gender = 'F'
				GROUP BY emp_no)
SELECT 
	  COUNT( CASE WHEN c2.f_highest_salary > c1.avg_salary THEN c2.f_highest_salary ELSE NULL END) AS f_emp_maxsalary_more_than_avgsalary,
      COUNT(e.emp_no) as total_no_of_f_contracts,
      ROUND((SUM( CASE WHEN c2.f_highest_salary > c1.avg_salary THEN 1 ELSE 0 END) / COUNT(e.emp_no)) * 100,2) AS percentage_of_fem_whose_condition_met
FROM 
	 employees e 
      JOIN 
      cte_2  c2 ON c2.emp_no = e.emp_no
      JOIN 
      cte_1  c1;
      
-- -------------------------------------------------------------------------------------------

-- add % sign  BY CONCAT FUNCTION 

WITH cte_1 AS ( SELECT AVG(salary) AS avg_salary FROM salaries),
     cte_2 AS ( SELECT 
					 s.emp_no,gender, MAX(salary) AS f_highest_salary
				FROM salaries s
						JOIN 
					  employees e ON e.emp_no = s.emp_no AND gender = 'F'
				GROUP BY emp_no)
SELECT 
	  COUNT( CASE WHEN c2.f_highest_salary > c1.avg_salary THEN c2.f_highest_salary ELSE NULL END) AS f_emp_maxsalary_more_than_avgsalary,
      COUNT(e.emp_no) as total_no_of_f_contracts,
      CONCAT(ROUND((SUM( CASE WHEN c2.f_highest_salary > c1.avg_salary THEN 1 ELSE 0 END) / COUNT(e.emp_no)) * 100,2), ' %') AS percentage_of_fem_whose_condition_met
FROM 
	 employees e 
      JOIN 
      cte_2  c2 ON c2.emp_no = e.emp_no
      JOIN 
      cte_1  c1;
      
-- ---------------------------------------------------------------------------------------------------------

-- USE meaning full name for the cte 

WITH cte_avg_salary AS ( SELECT AVG(salary) AS avg_salary FROM salaries),
     cte_f_highet_salary AS ( SELECT 
					 s.emp_no,gender, MAX(salary) AS f_highest_salary
				FROM salaries s
						JOIN 
					  employees e ON e.emp_no = s.emp_no AND gender = 'F'
				GROUP BY emp_no)
SELECT 
	  COUNT( CASE WHEN c2.f_highest_salary > c1.avg_salary THEN c2.f_highest_salary ELSE NULL END) AS f_emp_maxsalary_more_than_avgsalary,
      COUNT(e.emp_no) as total_no_of_f_contracts,
      CONCAT(ROUND((SUM( CASE WHEN c2.f_highest_salary > c1.avg_salary THEN 1 ELSE 0 END) / COUNT(e.emp_no)) * 100,2), ' %') AS percentage_of_fem_whose_condition_met
FROM 
	 employees e 
      JOIN 
      cte_f_highet_salary  c2 ON c2.emp_no = e.emp_no
      JOIN 
      cte_avg_salary  c1;
      
-- ---------------------------------------------------------------------------------------------------

# 289. Referring to Common Table Expressions in a WITH Clause

-- Retrieve the highest contract salary values of all employees hired in 2000 or later.
SELECT * FROM employees WHERE hire_date >= '2000-01-01' ;

WITH emp_hire_from_jan2000 AS (SELECT * FROM employees WHERE hire_date >= '2000-01-01'),
     higher_contract_salary_value  AS ( SELECT e.emp_no,
												MAX(s.salary)
										FROM 
												salaries s 
                                                   JOIN 
										       emp_hire_from_jan2000 e ON e.emp_no = s.emp_no
										GROUP BY e.emp_no)
SELECT * FROM higher_contract_salary_value;

---------------------------------------------- END OF SECTION ---------------------------------------------- 
