# Section 7 clean code 19 oct 2022

CREATE TABLE sales 
(
    purchase_number 	INT AUTO_INCREMENT,
    date_of_purchase 	DATE,
    customer_id 	INT,
    item_id 		VARCHAR(10),
PRIMARY KEY (purchase_number)
);

USE sales;

SELECT 
	*
FROM 
	companies;

/* ... */  for multiline code
# and --   for one- line code
