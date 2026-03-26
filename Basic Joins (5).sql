/*  Uses of Joins:
	1- Recombine Data (Complete the big picture)
	2- Data Enrichment (Getting extra data)
	3- Check for Existence (Filtering) */

-- Column Ambiguity: Add the table name before the column to avoid confusion in joins with same-named columns

-- Join Types:

-- 1) No Join: Returns data from tables without combining them

-- Retrieve all data from customers and orders as separate results 
Select *
From customers;

Select *
From orders;

-- 2) Inner Join: Returns only the matching rows from both tables (Order doesn't matter)
-- Recombinig Data - Check for Existence

-- Get all customers along with their orders but only for customers who have placed an order
Select id, first_name, order_id, sales
From customers
Inner Join orders
On customers.id = orders.customer_id

-- 3) Left Join: Returns all rows from left table and only matching from the right table
-- Recombine Data - Data Enrichment - Check for Existence (+ Where)

-- Get all customers along with their orders including those without orders
Select id, first_name, order_id, sales
From customers
Left Join orders
On id = customer_id

-- 4) Right Join: Returns all rows from right table and only matching from the left table
-- Recombine Data - Data Enrichment - Check for Existence (+ Where)

-- Get all customers along with their orders including orders without matching customers
Select id, first_name, order_id, sales
From customers
Right Join orders
On id = customer_id

-- 5) Full Join: Returns all the rows from both tables (Order doesn't matter)
-- Recombine Data - Check for Existence (+ Where)

-- Get all customers and all orders even if there's no match
Select id, first_name, order_id, sales
from customers
Full Join orders
On id = customer_id