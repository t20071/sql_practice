CREATE DATABASE zomato;
USE zomato;

drop table if exists goldusers_signup;
CREATE TABLE goldusers_signup(userid integer,gold_signup_date date); 

INSERT INTO goldusers_signup(userid,gold_signup_date) 
 VALUES (1,'2017-09-22'),
(3,'2017-04-21');

drop table if exists users;
CREATE TABLE users(userid integer,signup_date date); 

INSERT INTO users(userid,signup_date) 
 VALUES (1,'2014-09-02'),
(2,'2015-01-15'),
(3,'2014-04-11');

drop table if exists sales;
CREATE TABLE sales(userid integer,created_date date,product_id integer); 

INSERT INTO sales(userid,created_date,product_id) 
 VALUES (1,'2017-04-19',2),
(3,'2019-12-18',1),
(2,'2020-07-20',3),
(1,'2019-10-23',2),
(1,'2018-03-19',3),
(3,'2016-12-20',2),
(1,'2016-11-09',1),
(1,'2016-05-20',3),
(2,'2017-09-24',1),
(1,'2017-03-11',2),
(1,'2016-03-11',1),
(3,'2016-11-10',1),
(3,'2017-12-07',2),
(3,'2016-12-15',2),
(2,'2017-11-08',2),
(2,'2018-09-10',3);


drop table if exists product;
CREATE TABLE product(product_id integer,product_name text,price integer); 

INSERT INTO product(product_id,product_name,price) 
 VALUES
(1,'p1',980),
(2,'p2',870),
(3,'p3',330);

# QUESTIONS AND SOLUTION

-- 1.  What is the total amouont each customer spend on zomato?
SELECT s.userid, sum(p.price) as spend_on_zomato
FROM sales s
		JOIN 
	product p ON s.product_id = p.product_id
GROUP BY userid;

-- -----------------------------------------------------------------------------------

-- 2. How many days each customer visited zomato?
SELECT userid, count(distinct(created_date))  as days
FROM sales 
group by userid;

-- -----------------------------------------------------------------------------------

-- 3. what was the first product purchase by user?
SELECT *
FROM 
	(SELECT s.userid,
			s.created_date AS first_date,
			s.product_id,
			p.product_name AS produnt_name, 
			RANK() OVER(PARTITION BY s.userid ORDER BY s.created_date) as rnk
	FROM sales s 
			join 
			product p on s.product_id = p.product_id) AS a  
WHERE rnk = 1;

-- -----------------------------------------------------------------------------------

-- 4.What is the most purchase item and how many times it purchase by all customer?

SELECT   product_id, count(product_id) as count_by_id
FROM sales
GROUP BY product_id
ORDER BY count_by_id DESC
LIMIT 1;

-- How many times most purchase product, purchase by each customes?
SELECT userid,COUNT(product_id) as cnt from sales where product_id  = (SELECT   product_id FROM sales GROUP BY product_id LIMIT 1)
GROUP BY userid
ORDER BY userid;

-- -----------------------------------------------------------------------------------

-- 5. Which items is more popular for each customer?

SELECT * FROM SALES ;
SELECT 
    userid,product_id, COUNT(product_id) AS cnt
FROM
    sales
GROUP BY userid,product_id;

################################# 
SELECT b.*
FROM (
	SELECT a.*, RANK() OVER(PARTITION BY userid ORDER BY cnt DESC) AS rnk
	FROM  ( 
		SELECT 
			userid,product_id, COUNT(product_id) AS cnt
		FROM
			sales
		GROUP BY userid,product_id) AS a) AS b
WHERE b.rnk = 1;

-- --------------------------------------- end -----------------------------------------
 


	