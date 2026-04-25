create schema mydatabase;
show search_path;
set search_path to mydatabase;

-- Create Table customers
create table customers (
	id INT not null,
	first_name VARCHAR(50) not null,
	country VARCHAR(50),
	score INT,
	constraint pk_customers primary key (id)
);

-- Insert customers data
insert into customers (id, first_name, country, score) values
	(1, 'Maria', 'Germany', 350),
	(2, 'John', 'USA', 900),
	(3, 'George', 'UK', 750),
	(4, 'Martin', 'Germany', 500),
	(5, 'Peter', 'USA', 0);

select * from customers;

-- Create Table orders
create table orders (
	order_id INT not null,
	customer_id INT not null,
	order_date DATE,
	sales INT,
	constraint pk_orders primary key (order_id)
	);

-- Insert orders data
insert into orders (order_id, customer_id, order_date, sales) values
	(1001, 1, '2021-01-11', 35),
	(1002, 2, '2021-04-05', 15),
	(1003, 3, '2021-06-18', 20),
	(1004, 6, '2021-08-31', 10);

select * from orders;

/* ==============================================================================
   SQL SELECT Query
-------------------------------------------------------------------------------
   This covers various SELECT query techniques used for retrieving, 
   filtering, sorting, and aggregating data efficiently. Table of Contents:
     1. SELECT ALL COLUMNS
     2. SELECT SPECIFIC COLUMNS
     3. WHERE CLAUSE
     4. ORDER BY
     5. GROUP BY
     6. HAVING
     7. DISTINCT
     8. TOP
     9. Combining Queries
	 10. COOL STUFF - Additional SQL Features
=================================================================================
*/

/* ==============================================================================
 1.  SELECT ALL COLUMNS - retrieves all columns.
=============================================================================== */

-- Retrieve all customer data
select *
from customers;

-- Retrieve all orders data
select *
from orders;

/* ==============================================================================
  2. SELECT FEW COLUMNS - picks only the columns you need instead of all columns.
=============================================================================== */

-- Retrieve customer's name, country and score.
select
	first_name,
	country,
	score
from customers;

/* ==============================================================================
  3. WHERE - filters your data based on a condition.
=============================================================================== */

-- Retrieve customers with a score not eual to zero (0)
select *
from customers
where score != 0;

-- Retrieve customers from Germany
select *
from customers
where country = 'Germany';

-- Retrieve the name and country of customers from Germany
select
	first_name,
	country
from customers
where country = 'Germany';

/* ==============================================================================
 4.  ORDER BY - sort your data in ASC(lowest to highest) or DESC(highest to lowest) order.
   			- default setting is ASC.
   			- column order irder by is crucial, as sorting is sequential.
=============================================================================== */

-- Retrieve all customers and sort the results by the highest score first.
select *
from customers
order by score desc;

-- Retrieve all customers and sort the results by the lowest score first.
select *
from customers
order by score asc;

-- Retrieve all customers and sort the results by the country.
select *
from customers
order by country asc;

-- Retrieve all customers and sort the results by the country and then by the highest score.
select *
from customers
order by
	country asc,
	score desc;

/* Retrieve the name, country, and score of customers whose score is not equal to 0
   and sort the results by the highest score first. */
select
	first_name,
	country,
	score
from customers
where score != 0
order by score desc;

/* ==============================================================================
 5.  GROUP BY - Combines Rows with the same value.
   			- Aggregates your data.
   			- AS (alias)shorthand name (label) assigned to a column or table in a query. 
=============================================================================== */
-- Find the total score for each country
select 
	country,
	SUM(score) as total_score 
from customers
group by country;

/* This will not work because 'first_name' is neither part of the GROUP BY 
   nor wrapped in an aggregate function. SQL doesn't know how to handle this column.
   All columns in the SELECT must be either aggregated or included in the GROUP BY. 
   The result of GROUP BY is determined by the unique values of the grouped columns.*/
select 
    country,
    first_name,
    SUM(score) as total_score
from customers
group by country;

-- Find the total score and total number of customers for each country
select 
	country,
	SUM(score) as total_score,
	COUNT(id) as total_customers
from customers
group by country;

/* ==============================================================================
 6.  HAVING - Filters data after aggregation.
		  - can be used only with GROUP BY.
		  - If you want to filter your data before the aggregation(GROUP BY) use WHERE
		   									after the GROUP BY use HAVING
=============================================================================== */

/* Find the average score for each country
   and return only those countries with an average score greater than 430 */
select 
	country,
	AVG(score) as avg_score
from customers
group by country 
having AVG(score) > 430;

/* Find the average score for each country
   considering only customers with a score not equal to 0
   and return only those countries with an average score greater than 430 */
select 
	country,
	AVG(score) as avg_score
from customers
where score != 0
group by country 
having AVG(score) > 430;

/* ==============================================================================
 7.   DISTINCT - Removes dupliactes / repeated values.
 			   - each value appears only once. 
 			   - do not use DISTINCT unless necessary; it can slow down your query.
=============================================================================== */

-- Return Unique list of all countries
select distinct 
	country
from customers;

/* ==============================================================================
   LIMIT - Limit your data, restrict the number of rows returned.
   		 - Other versions of SQL use TOP
=============================================================================== */

-- Retrieve only 3 Customers
select *
from customers
limit 3;

-- TOP
select TOP 3 *
from customers

-- Retrieve the Top 3 Customers with the Highest Scores
select *
from customers
order by score desc
limit 3;

-- Retrieve the Lowest 2 Customers based on the score
select *
from customers
order by score asc
limit 2;

-- Get the Two Most Recent Orders
select *
from orders
order by order_date desc 
limit 2;

/* ==============================================================================
   All Together
=============================================================================== */

/* Calculate the average score for each country 
   considering only customers with a score not equal to 0
   and return only those countries with an average score greater than 430
   and sort the results by the highest average score first. */
select 
	 country,
	 AVG(score) as avg_score
from customers
where score != 0
group by country
having avg(score) > 430
order by avg_score desc;

/* ============================================================================== 
   COOL STUFF - Additional SQL Features
=============================================================================== */

-- Execute multiple queries at once (Highlight both lines of code and run)
select * from customers;
select * from orders;

/* Selecting Static Data */
-- Select a static or constant value without accessing any table
select 123 as static_number;

select 'Hello' as static_string;

-- Assign a constant value to a column in a query
select
    id,
    first_name,
    'New Customer' as customer_type
from customers;

-- or
select
    id,
    first_name,
    'New Customer' as customer_type
from customers
where first_name in ('Maria', 'George');

-- 0r
select *,
    case 
        when  first_name in ('Maria', 'George') then 'New Customer'
        else 'Existing Customer'
    end as customer_type
from customers;