-- Advanced Joins (Cont. Joins)

-- 1) Left Anti Join: Returns rows from the left table that has no match in the right table
-- Check for existence

-- Get all customers who haven't placed any order
Select id, first_name, order_id, sales
From customers
Left Join orders
On id = customer_id
Where customer_id Is Null

-- 2) Right Anti Join: Returns rows from the right table that has no match in the left table
-- Check for Existence

-- Get all orders without matching customers
Select id, first_name, order_id, sales
From customers
Right Join orders
On id = customer_id
Where id Is Null

-- 3) Full Anti Join: Returns all the rows that don't match in either tables (Order doesn't matter)
-- 

-- Find the customers without orders and orders without customers
Select id, first_name, order_id, sales
From customers
Full Join orders 
On id = customer_id
Where id Is Null or customer_id Is Null

-- Challenge:
-- Get all the customers along with their orders but only for customers who have placed an order without using Inner Join
Select id, first_name, order_id, sales
from customers
Left Join orders
On id = customer_id
Where customer_id Is Not Null

-- 4) Cross Join (Cartesian Join): Combine every row from the left table with every row from the right table (Order doesn't matter)

-- Generate all possible combinations of customers and orders
Select id, first_name, order_id, sales
From customers
Cross Join orders