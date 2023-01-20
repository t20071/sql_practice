# SECTION 11
# 133. TCL's COMMIT and ROLLBACK
# 134. The UPDATE Statement - Part I
SELECT * FROM employees WHERE emp_no = 99901;

UPDATE employees 
SET first_name = 'Atul',
    last_name = 'Dhar',
    gender = 'M',
    hire_date = '2013-01-01',
    birth_date = '1983-10-08'
WHERE emp_no = 99901;

SELECT * FROM employees WHERE emp_no = 99901;

# 136. The UPDATE Statement - Part II
SELECT * FROM departments ORDER BY dept_no; 

COMMIT;

UPDATE departments
SET 
 dept_no = 'd001',
 dept_name = 'Quality check';
 
 ROLLBACK;
 COMMIT;
 
-- The UPDATE Statement – Part II - exercise
-- Change the “Business Analysis” department name to “Data Analysis”.
-- Hint: To solve this exercise, use the “departments” table.
UPDATE departments
set dept_name = 'Data Analysis'
WHERE dept_name = 'Business Analysis';

SELECT * FROM departments where dept_name = 'Data Analysis';

------------------------------ Break ------------------------------
