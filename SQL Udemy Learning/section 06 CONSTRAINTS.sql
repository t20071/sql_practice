# SECTION 6 PRIMARY KEY CONSTRAINTS 17 OCT 2022

USE sales;
CREATE TABLE sales
(
	purchase_number INT AUTO_INCREMENT,
	date_of_purchase DATE,
	customer_id INT,
	item_id VARCHAR(10),
PRIMARY KEY(purchase_number)
);


# Creating customer table 
CREATE TABLE customer
(   
    customer_id INT,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    phone_number VARCHAR(255),
    email VARCHAR(255),
    number_of_complaints INT,
PRIMARY KEY (customer_id)
);


# Creating item table
CREATE table item
(
    item_code VARCHAR(255),
    item VARCHAR(255),
    unit_price NUMERIC(10,2),
    company_id VARCHAR(255),
PRIMARY KEY(item_code)
);


# create the company table
CREATE TABLE comapanies
(
    company_id VARCHAR(255),
    comapany_name VARCHAR(255),
    headquarters_phone_number INT(12),
PRIMARY KEY(company_id)
);


# FOREIGN KEY CONSTRAINTS

# 1ST METHEOD
DROP TABLE SALES;
CREATE TABLE sales
(
	purchase_number INT,
        date_of_purchase DATE,
	customer_id INT,
	item_id VARCHAR(255),
 PRIMARY KEY(purchase_number),
 FOREIGN KEY sales(customer_id) REFERENCES customer(customer_id) ON DELETE CASCADE 
 );

# 2ND METHOD
ALTER TABLE SALES
ADD FOREIGN KEY sales(customer_id) REFERENCES customer(customer_id) ON DELETE CASCADE;

# Drop foreign key
ALTER TABLE sales
DROP FOREIGN KEY sales_ibfk_1;

-- Excercise - Drop all the table 
DROP TABLE sales;
DROP TABLE customers;
DROP TABLE item;
DROP TABLE comapanies;

# 18 OCT 2022
-- lecture
# UNIQUE KEY CONSTRAINTS 1ST METHOD
USE sales;
CREATE TABLE customers
(
    customer_id INT AUTO_INCREMENT,
    First_name VARCHAR(255),
    Last_name VARCHAR(255),
    email_address VARCHAR(255),
    Number_of_complaints INT,
PRIMARY KEY (customer_id),
UNIQUE KEY (email_address)
);

# 2nd Method
ALTER TABLE customers
ADD UNIQUE KEY (email_address);

# INDEX METHOD FOR REMOVING THE UNIQUE KEY 
ALTER TABLE customers
DROP INDEX email_address;

-- add a column
ALTER TABLE customers
ADD COLUMN gender ENUM('M','F') AFTER last_name;

-- add values
INSERT INTO customers (first_name,last_name,gender,email_address,Number_of_complaints)
VALUES ('Sharad','Pardhe','M','sharadpardhe08@gmail.com',0);

# DEFAULT CONSTRAINTS
-- 1ST METHOD 
DROP TABLE customers;
USE sales;
CREATE TABLE customers
(
    customer_id INT AUTO_INCREMENT,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    email_address VARCHAR(255),
    number_of_complaints INT DEFAULT 0,
PRIMARY KEY (customer_id)
);
-- 2ND METHOD
ALTER TABLE customerS
CHANGE COLUMN number_of_complaiNts Pending_complaints INT DEFAULT 0;

INSERT INTO customers (first_name,last_name,gender,email_address)
VALUES ('Sharad','Pardhe','M','sharadpardhe08@gmail.com');

ALTER TABLE customers
ALTER COLUMN Pending_complaints DROP DEFAULT;

# EXCERCISE 
USE sales;
CREATE TABLE companies
( 
    company_id VARCHAR(255),
    company_name VARCHAR(255) DEFAULT 'X',
    head_quarters_phonenumber VARCHAR(255),
PRIMARY KEY (company_id),
UNIQUE KEY (head_quarters_phonenumber)
);
DROP TABLE companies;

# NOT NULL constraints  19 oct 2022
USE sales;
CREATE TABLE companies
(
    company_id INT AUTO_INCREMENT,
    headquarter_phone_number VARCHAR(255),
    company_name VARCHAR(255) NOT NULL,
PRIMARY KEY (company_id)
);

-- remove NOT NULL constraints
ALTER TABLE companies
MODIFY company_name VARCHAR(255) NULL;

-- 2nd method to add NOT NULL constraints
ALTER TABLE companies
CHANGE COLUMN company_name company_name VARCHAR(255) NOT NULL;
    
-- Now let try not null constraint 
INSERT INTO companies (headquarter_phone_number)
VALUES ('8989969327');   # THIS WILL THROUGH ERROR

INSERT INTO companies (headquarter_phone_number,company_name)
VALUES ('8989969327','ENERGY');

SELECT * FROM companies;

# NOT NULL Constraint - Part I - exercise
-- Using ALTER TABLE, first add the NULL constraint to the headquarters_phone_number field in the “companies” table, and then drop that same constraint.
ALTER TABLE companies
CHANGE COLUMN headquarter_phone_number phone_number VARCHAR(255) NOT NULL;

-- Remove NOT NULL constraints
ALTER TABLE companies
MODIFY phone_number VARCHAR(255) NULL;

------End of section 6-------
