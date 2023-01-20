# 124. The INSERT statement - Part I
SELECT 
    *
FROM
    employees
LIMIT 10;

INSERT INTO employees
(
    emp_no,
    birth_date,
    first_name,
    last_name,
    gender,
    hire_date
) VALUES
(
     999999,
    '1995-10-08',
    'Sharad',
    'Pardhe',
    'M',
    '2023-01-01'
);
   
SELECT 
    *
FROM
    employees
ORDER BY emp_no DESC 
LIMIT 10;

INSERT INTO employees
(
    emp_no,
    birth_date,
    first_name,
    last_name,
    gender,
    hire_date
) VALUES
(
     '999999',  # NO PROBLEM AT ALL BUT NOT GOOD PRACTICE 
    '1995-10-08',
    'Sharad',
    'Pardhe',
    'M',
    '2023-01-01'
);

# 125. The INSERT statement - Part II
INSERT INTO employees # ORDER CAN BE CHANGED
(
    birth_date,
    emp_no,
    first_name,
    last_name,
    gender,
    hire_date
) VALUES
(
    '1995-10-08',
     999998, 
    'Sha',
    'Par',
    'M',
    '2023-01-01'
);

INSERT INTO employees
VALUES
( 
     999997,
    '1995-10-08',
    'Alex',
    'Hail',
    'M',
    '2023-01-01'
);

SELECT 
    *
FROM
    employees
ORDER BY emp_no DESC 
LIMIT 10;

-- The INSERT statement - exercise 1
-- 1. Select ten records from the “titles” table to get a better idea about its content.
SELECT * FROM titles LIMIT 10;

-- 2.Then, in the same table, insert information about employee number 999903. State that he/she is 
--    a “Senior Engineer”, who has started working in this position on October 1st, 1997.
INSERT INTO titles 
(
    emp_no,
    title,
    from_date
) VALUES
(
    9999903,
    'Senior Engineer',
    '1997-10-01'
);

SELECT * FROM titles ORDER BY emp_no LIMIT 10 ;

-- 3.Insert information about the individual with employee number 999903 into the “dept_emp” table. 
--    He/She is working for department number 5, and has started work on  October 1st, 1997; her/his contract is for 
--    an indefinite period of time.
--    Hint: Use the date ‘9999-01-01’ to designate the contract is for an indefinite period.
SELECT * FROM dept_emp LIMIT 10;
INSERT INTO dept_emp
(
    emp_no,
    dept_no,
    from_date,
    to_date
) VALUES
( 
     999903,
    'd005',
    '1997-10-01',
    '9999-01-01'
);

---------------------------------------------------- Break ----------------------------------------------------

# 130. Inserting data INTO a new table
CREATE TABLE department_dup
( 
    dept_no CHAR(4) NOT NULL,
    dept_name VARCHAR(11) NOT NULL
);

SELECT * FROM department_dup;

INSERT INTO department_dup
( 
    dept_no,
    dept_name
)
SELECT 
	* 
FROM 
	departments;

-- 1. Create a new department called “Business Analysis”. Register it under number ‘d010’.
-- Hint: To solve this exercise, use the “departments” table.
INSERT INTO departments VALUES ('d010', 'Business Analysis');

---------------------------------------------------- Break ----------------------------------------------------
