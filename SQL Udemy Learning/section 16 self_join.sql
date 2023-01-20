# 214. Self Join
-- FROM the emp_manager table, extract the record only data only of  
-- those employee who are manager as well.

SELECT 
    e1.*
FROM
    emp_manager e1
        JOIN
    emp_manager e2 ON e1.emp_no = e2.manager_no;
    

-- not the right one , ONLY 2 row we want but 42 was given 

-- 1st solution
SELECT DISTINCT
    e1.*
FROM
    emp_manager e1
        JOIN
    emp_manager e2 ON e1.emp_no = e2.manager_no;
  
-- 2nd solution 
SELECT 
    e1.*
FROM
    emp_manager e1
        JOIN
    emp_manager e2 ON e1.emp_no = e2.manager_no
WHERE
    e2.emp_no IN (SELECT 
            manager_no
        FROM
            emp_manager);
            
--------------------------------- End -----------------------------------