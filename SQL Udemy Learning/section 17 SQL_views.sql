# 1 jan 2023
# 215. Views
-- View - a virtual table whose contents are obtained from an existing table or
-- tables, called base tables.

SELECT 
    *
FROM
    dept_emp;
    
SELECT 
    emp_no, from_date, to_date, COUNT(emp_no) AS N
FROM
    dept_emp
GROUP BY emp_no
HAVING N > 1;

#############

CREATE OR REPLACE VIEW V_dept_man_latest_date AS
    SELECT 
        emp_no, MAX(from_date) AS from_date, MAX(to_date) AS to_date
    FROM
        dept_emp
    GROUP BY emp_no;
    
SELECT * FROM employees.v_dept_man_latest_date;
    
/*
Views - exercise
Create a view that will extract the average salary of all managers 
registered in the database. Round this value to the nearest cent.

If you have worked correctly, after executing the view from the “Schemas” 
section in Workbench, you should obtain the value of 66924.27. */
-- 1st sol    

CREATE OR REPLACE VIEW v_manager_avg_salary AS
    SELECT 
        ROUND(AVG(salary), 2)
    FROM
        salaries s
            JOIN
        dept_manager m ON s.emp_no = m.emp_no;
        

SELECT * FROM employees.v_manager_avg_salary;
        
-- ----------------------------------end ------------------------------------