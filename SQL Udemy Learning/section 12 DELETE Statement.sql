# 139. The DELETE Statement - Part I
SELECT * FROM employees WHERE emp_no = 99903;
SELECT * FROM titles WHERE emp_no = 99903;

commit; # IT IS A SAFE PATH 

DELETE FROM employees
WHERE emp_no = 99903;

SELECT * FROM employees WHERE emp_no = 99903; # from employees table record deleted
SELECT * FROM titles WHERE emp_no = 99903;  # as well as from titles table

ROLLBACK; # IF YOU have commit then rollback will undo, otherwise it will not.

-- if a specific value from the parent table’s primary key has been
-- deleted, all the records from the child table referring to this value
-- will be removed as well. 

## take care of where statement otherwise selected table will be deleted.

DELETE FROM employees; # This will delete entire employees table

-- The DELETE Statement – Part II - exercise
-- Remove the department number 10 record from the “departments” table.
DELETE FROM departments 
WHERE
    dept_no = 'd010';
    
# 143. DROP vs TRUNCATE vs DELETE
# DROP
-- you won’t be able to roll back to its initial state, or to the last COMMIT statement.
-- use DROP TABLE only when you are sure you aren’t going to use the table in question anymore database.database

# TRUNCATE ~ DELETE without WHERE
-- when truncating, auto-increment values will be reset

# DELETE
-- removes records row by row
------------------------------ Break ------------------------------
