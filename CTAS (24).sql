-- CTAS (Create Table As Select)

-- DB Table: It is a structured collection of data similar to a speadsheet or grid

-- Table Types: Permanent Tables - Temporary Tables
/* 1] Permanent Tables: They can be created by 
1) Create / Insert : It is the classical way of creating and defining tables
- Create: Define the structure of table.
- Insert: Insert data into the table.
2) CTAS : Create a new table based on the result of an SQL query. */

/* CTAS Vs Views
- Views: Stores the query not the result data
       : If the user queries the view, it fetches the data from the original table and then present it
	   : If data is updated, the views show the updated data instantly in the result
- CTAS: Stores the result data into a new permanent table
	  : If the user queries the CTAS, the is directly fetched from the CTAS table and then presented to the user
	  : If data is updated, the CTAS show the old data until the CTA itself is updatd
-> Views are slower than the CTAS */

/* Syntax:
- Create / Insert:
Create Table Table-name (Id int, Name varchar, ..) Insert Into Table-name Values (1, 'Sajy', ..)
- CTAS
Create Table Name As (Select.. From.. Where..) --> MySQL | Postgres | Oracle
Select .. Into New-Table From .. Where .. --> MSServer */

-- Use Cases:
-- 1] Optimize Performance
-- Task: Create a CTA that shows the total numbers of orders of each month
Select
DATENAME(month, OrderDate) as OrderMonth,
Count(OrderId) as TotalOrders
Into Sales.MonthlyOrders
From Sales.Orders
Group By DATENAME(month, OrderDate);
-- After executing the CTA
Select 
* 
From Sales.MonthlyOrders
-- To drop the table 
Drop Table Sales.MonthlyOrders

-- To update a CTA you have to drop it first then recreate it with the updated data 
-- Another way is to update the CTA is by using TransactSQL (extension where you can do some programming in SQL)
If OBJECT_ID('Sales.MonthlyOrders','U') Is Not Null
	Drop Table Sales.MonthlyOrders;
Go
Select
DATENAME(month, OrderDate) as OrderMonth,
Count(OrderId) as TotalOrders
Into Sales.MonthlyOrders
From Sales.Orders
Group By DATENAME(month, OrderDate)

-- 2] Creating a Snapshot
-- CTAs can be used to create a persisted snapshot of the data at a specific time in order to analyze data quality issue 

-- 3] Physical Data Marts in Data Warehouse 
-- Persisting the data marts in DWH improves the speed of data retrieval compared to using views.
