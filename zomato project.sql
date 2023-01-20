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
			p.product_name AS product_name, 
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
SELECT userid,COUNT(product_id) as cnt 
from sales where product_id  = (SELECT   product_id FROM sales GROUP BY product_id LIMIT 1)
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
	SELECT a.*, 
		RANK() OVER(PARTITION BY userid ORDER BY cnt DESC) AS rnk
	FROM  ( 
		SELECT 
			userid,product_id, COUNT(product_id) AS cnt
		FROM
			sales
		GROUP BY userid,product_id) AS a) AS b
WHERE b.rnk = 1;

-- ---------------------------------------------------------------------------------------------

# 6. Which item first purchase by customer after they bUY gold memebership?
SELECT * 
FROM 
	(SELECT a.userid,
			a.product_id,
            a.created_date,
			RANK() OVER(PARTITION BY userid ORDER BY created_date) as rnk
	FROM 
		(SELECT 
			s.userid, s.created_date, s.product_id, g.gold_signup_date
		FROM
			sales s
				JOIN
			goldusers_signup g ON s.userid = g.userid AND s.created_date > g.gold_signup_date) AS a) as b 
WHERE b.rnk = 1;


select * from sales where created_date = '2017-12-07' or created_date = '2018-03-19';

-- ---------------------------------------------------------------------------------------------

# 7 which item purchase just opposite the member become gold member ?
SELECT * 
FROM	
	(SELECT a.*, 
		RANK() OVER(PARTITION BY userid order by created_date desc) as rnk
	FROM 
		(SELECT s.userid, s.created_date, s.product_id, g.gold_signup_date
		FROM sales s
			JOIN 
			goldusers_signup g ON s.userid = g.userid AND s.created_date < g.gold_signup_date) AS a) AS b 
WHERE rnk = 1;

-- ---------------------------------------------------------------------------------------------

# 8 . what is the total order and amount each customer spent before they `become gold member?
 
SELECT 
    s.userid,
    COUNT(p.product_id) AS number_of_order,
    SUM(p.price) AS spend_money
FROM
    goldusers_signup g
        JOIN
    sales s ON s.userid = g.userid
        AND s.created_date < g.gold_signup_date
        JOIN
    product p ON s.product_id = p.product_id
GROUP BY userid
ORDER BY userid;

-- ---------------------------------------------------------------------------------------------

# 9. if buying product generate point for eg 5Rs = 2 zomato point and each producnt has different zomato point 
# eg for p1 has 5Rs = 1 zomato point, for p2 has 10Rs = 5 zomato point, for p3 has 5Rs = 1 zomato point 
# calculate the point earned by each customer and for which product most point has been given till now.

SELECT e.userid, e.total_point*2.5 AS total_cashback
FROM
	(SELECT d.userid, sum(d.earned_point) as total_point
	FROM 
		(SELECT c.*, round(amt/points) AS earned_point
		FROM
			(SELECT b.*,
				CASE 
				WHEN b.product_id = 1 THEN 5 
				WHEN b.product_id = 2 THEN 2 
				WHEN b.product_id = 3 THEN 5 
				END AS points
			FROM 
				(SELECT a.userid,a.product_id,sum(a.price) AS amt
				FROM 
					(SELECT s.userid,p.product_id,p.price
					FROM
						sales s
							JOIN
						product p ON s.product_id = p.product_id) AS a
				GROUP BY a.userid,a.product_id
				ORDER BY a.userid,a.product_id) AS b) AS c) AS d
	GROUP BY userid) AS e;

-- for which product most point has been given till now.
SELECT d.product_id, sum(d.earned_point) AS total_point_earned
FROM 
	(SELECT c.*, round(amt/points) AS earned_point
			FROM
				(SELECT b.*,
					CASE 
					WHEN b.product_id = 1 THEN 5 
					WHEN b.product_id = 2 THEN 2 
					WHEN b.product_id = 3 THEN 5 
					END AS points
				FROM 
					(SELECT a.userid,a.product_id,sum(a.price) AS amt
					FROM 
						(SELECT s.userid,p.product_id,p.price
						FROM
							sales s
								JOIN
							product p ON s.product_id = p.product_id) AS a
					GROUP BY a.userid,a.product_id
					ORDER BY a.userid,a.product_id) AS b) AS c) AS d
GROUP BY product_id 
ORDER BY total_point_earned DESC
LIMIT 1;

-- ---------------------------------------------------------------------------------------------

/*
#10. In the first one year after a customer joins the gold program (including their join date) irrespective 
of what  the customer has purchased they earn 5 zomato points for every 10 rs spent,
who earned more 1 or 3 
and what was their  points earnings in thier first yr? */
SELECT 
    s.userid, s.created_date, p.product_id, g.gold_signup_date,p.price,p.price*0.5 AS total_point_earned
FROM
    goldusers_signup g
        JOIN
    sales s ON s.userid = g.userid
        AND s.created_date >= g.gold_signup_date AND s.created_date <= DATE_ADD(g.gold_signup_date, INTERVAL 1 YEAR)
        JOIN
    product p ON p.product_id = s.product_id
ORDER BY total_point_earned DESC
LIMIT 1;
     
 -- ---------------------------------------------------------------------------------------------
 
# 11. RANK All the transaction of customers? 
SELECT *,
	RANK() OVER(PARTITION BY userid ORDER BY created_date) AS rnk
FROM sales;

-- ---------------------------------------------------------------------------------------------

# 12 RANK all the transaction for each member whenever they are a gold member for every non gold member transaction 
-- as na 
SELECT a.*,
		CASE 
        WHEN a.gold_signup_date is null THEN 0
        ELSE RANK() OVER(PARTITION BY userid ORDER BY a.created_date DESC) END AS rnk
FROM
		(SELECT 
			s.userid, s.created_date, s.product_id, g.gold_signup_date
		FROM
			sales s
				LEFT JOIN
			goldusers_signup g ON g.userid = s.userid AND s.created_date >= g.gold_signup_date) AS a;