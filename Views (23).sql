-- Views

-- Database Server: Stores, manages and provides access to databases for users or apps.
-- Database: Collection of information that is stored in a structured way.
-- Schema: A logical layer that groups related objects together.
-- Table: The place where data is stored and organized into rows and columns.
-- View: A virtual table that shows data without storing it physically.
-- DDL (Data Definition Language): A set of commands that allows us to define and manage the structure of a database.
-- DDL: Create - Alter - Drop

/* The 3 Level Architecture of Database:
1) Physical Level (Internal): The lowest level in db where the actual data is stored (Data Files, Partitions, Logs, Catalog, Blocks, Caches)
2) Logical level (Conceptual): This is where the data is organized (Creating Tables, Defining Relationships, Creating Indexes, Procedures, Functions)
3) View level (External): The highest level in db and this is what the end user access and see */

-- View: A virtual table based on the result set of a query without storing data in the database.
--	   : They are persisted SQL queries in the database (Persisted Logic)
--     : No persisted data, easy to maintain, slow response, read only

-- Use Case:
-- 1] Central Complex Query Logic: Store central complex query logic in the database for access by multiple queries reducing project complexity.

-- Syntax: Create View View_Name As (Select.. From.. Where..)

-- Task: Find the running total of sales for each month
-- Using CTE:
With CTE_Monthly_Summary As
(
Select
DATETRUNC(month,OrderDate) OrderMonth,
Sum(Sales) TotalSales,
Count(OrderID) as TotalOrders,
Sum(Quantity) as TotalQuantities
From Sales.Orders
Group By DATETRUNC(month,OrderDate)
)
Select
OrderMonth,
TotalSales,
Sum(TotalSales) Over (Order By OrderMonth) as RunningTotal
From CTE_Monthly_Summary
-- Using View: To create it must be in a batch (query) alone
Select
OrderMonth,
TotalSales,
Sum(TotalSales) Over (Order By OrderMonth) as RunningTotal
From V_Monthly_Summary

-- Note: If a table or a view is created without specifying a schema, it defaults to DBO
-- T-SQL: Transact-SQL is an extension of SQL that adds programming features.

-- Use Case:
-- 2] Hide Complexity: View can be used to hide complexity of database tables and offers users more friendly and easy-to-consume objects.
-- Task: Provide a view that combines detais from orders, products, customers and employees.
Select 
*
From Sales.V_Details

-- Use Case:
-- 3] Data Security: Views are used to enforce security and protect sensitive data by hiding columns and rows from the table.
-- Task: Provide a View for the EU Sales Team that combines details from all tables and excludes data related to the USA.
Select
*
From Sales.V_Details_EU

-- Use Case:
-- 4] Flexibility & Dynamic: Views offers the users stable view and gives the freedom to the developers to edit and change the data models without affecting the users.

-- Use Case:
-- 5] Multiple Languages: Viewws can offer multiple languages for the objects in case of multi-national developers working.

-- Use Case:
-- 6] Virtual Data Marts in Data Warehouse: View can be used as data marts in data warehouse system because they provide a flexible and efficient way to present data.