-- 30 SQL Tips & Tricks

/*
 Golden Rule:
 1) For small-medium tables, the query optimizer may react the same to different query styles.
 2) Always check the execution plan to confirm performance improvememnt when optimizing the query 
 3) If there's no improvement then focus on the readibility.
 */

 -- Fetching Data

 -- Tip 1: Select only what you need

 -- Tip 2: Avoid unnecessary Distinct & Order By

 -- Tip 3: For exploration purposes Limit Rows
 Select Top 10
 OrderID,
 Sales
 From Sales.Orders

 -- Filtering Data

 -- Tip 4: Create Nonclustered Index on frequently used columns in Where Clause 
 Select *
 From Sales.Orders
 Where OrderStatus = 'Delivered'

 Create Nonclustered Index Idx_Orders_OrderStatus On Sales.Orders (OrderStatus)

 -- Tip 5: Avoid applying Functions to columns in Where clause 
 -- Functions on columns can block index usage 
Select 
*
From Sales.Customers
Where SUBSTRING(FirstName,1,1) = 'A' -- Bad Practice

Select 
*
From Sales.Customers
Where FirstName Like 'A%' -- Good Practice

-- Another Example 
Select 
*
From Sales.Orders
Where Year(OrderDate) = 2025 -- Bad Practice

Select
*
From Sales.Orders
Where OrderDate Between '2025-01-01' And '2025-12-31' -- Good Practice

 -- Tip 6: Avoid leading wildcards as they prevent index usage 
 Select 
 *
 From Sales.Customers
 Where LastName Like '%Gold%' -- Bad Practice

 Select 
 *
 From Sales.Customers
 Where LastName Like 'Gold%' -- Godd Practice

 -- Tip 7: Use (In) operator instead of multiple (Or) conditions
 Select 
 *
 From Sales.Orders
 Where CustomerID = 1 Or CustomerID = 2 Or CustomerID = 3 -- Bad Practice

 Select 
 *
 From Sales.Customers
 Where CustomerID In (1,2,3) -- Good Practice

 -- Joining Data 

 -- Tip 8: Understand the speed of Joins & Use Inner Join when possible
 -- Fastest: Inner / Slightly Slower: Left, Right / Worst: Outer 
 Select 
 c.FirstName,
 o.OrderID
 From Sales.Customers c
 Inner Join Sales.Orders o 
 On c.CustomerID = o.CustomerID -- Best Performance

 -- Tip 9:Use Explicit Join (ANSI Join) instead of Implicit Join (non-ANSI Join)
 Select 
 o.OrderID,
 c.FirstName
 From Sales.Customers c, Sales.Orders o
 Where c.CustomerID = o.CustomerID -- Bad Practice

 Select 
 c.FirstName,
 o.OrderID
 From Sales.Customers c
 Inner Join Sales.Orders o 
 On c.CustomerID = o.CustomerID -- Good Practice

 -- Tip 10: Make sure to index the columns used in the ON clause
  Select 
 c.FirstName,
 o.OrderID
 From Sales.Customers c
 Inner Join Sales.Orders o 
 On c.CustomerID = o.CustomerID

 Create Nonclustered Index Idx_Orders_CustomerID On Sales.Orders (CustomerID)

 -- Tip 11: Filter before joining Big Tables
 -- Try to isolate the preparation step in a CTE or a Subquery
 -- Filtering After Join (Where) -> More preferable for small and medium tables
 Select 
 c.FirstName,
 o.OrderID
 From Sales.Customers c
 Inner Join Sales.Orders o 
 On c.CustomerID = o.CustomerID
 Where o.OrderStatus = 'Delivered'

 -- Filtering During Join (On) 
   Select 
 c.FirstName,
 o.OrderID
 From Sales.Customers c
 Inner Join Sales.Orders o 
 On c.CustomerID = o.CustomerID And o.OrderStatus = 'Delivered'

 -- Filtering Before Join (Subquery) -> More preferable for large tables
   Select 
 c.FirstName,
 o.OrderID
 From Sales.Customers c
 Inner Join 
 (
 Select 
 *
 From Sales.Orders
 Where OrderStatus = 'Delivered'
 ) o
 On c.CustomerID = o.CustomerID

 -- Tip 12: Aggregate before Joining Big Tables
 -- Same as last tip
 -- Grouping and Joining -> Small & Medium Tables
 Select
 c.CustomerID,
 c.FirstName,
 Count(o.OrderID) as OrderCount
 From Sales.Customers c
 Inner Join Sales.Orders o
 On c.CustomerID = o.CustomerID
 Group By c.CustomerID, c.FirstName

 -- Pre-aggregated Sunquery --> Big Tables 
  Select
 c.CustomerID,
 c.FirstName,
 o.OrderCount
 From Sales.Customers c
 Inner Join 
 (
 Select 
 CustomerID,
 Count(OrderID) as OrderCount
 From Sales.Orders
 Group By CustomerID
 ) o
 On c.CustomerID = o.CustomerID

 -- Correlated Subquery --> Worst Performance 
Select
c.CustomerID,
c.FirstName,
(
Select
Count(o.OrderID)
From Sales.Orders o
Where c.CustomerID = o.CustomerID
) As OrderCount
From Sales.Customers c

-- Tip 13: Use Union Instead of OR in Joins
Select 
o.OrderID,
c.FirstName
From sales.Customers c
Inner Join Sales.Orders o
On c.CustomerID = o.CustomerID
Or c.CustomerID = o.SalesPersonID -- Bad Practice

Select 
o.OrderID,
c.FirstName
From Sales.Customers c
Inner Join Sales.Orders o
On c.CustomerID = o.CustomerID
Union
Select 
o.OrderID,
c.FirstName
From Sales.Customers c
Inner Join Sales.Orders o
On c.CustomerID = o.SalesPersonID -- Good Practice

-- Tip 14: Check for Nested Loops nad use SQL Hints when necessary
-- In case of small - medium tables it is ok to use nested loops
Select 
o.OrderID,
c.FirstName
From Sales.Customers c
Inner Join Sales.Orders o
On c.CustomerID = o.CustomerID

-- In case of big tables it is better to use hash
Select 
o.OrderID,
c.FirstName
From Sales.Customers c
Inner Join Sales.Orders o
On c.CustomerID = o.CustomerID
Option (Hash Join)

-- Tip 15: Use Union All instead of Union when duplicates are acceptable
-- Union All helps making the performance faster.
-- Bad Practice
Select 
CustomerID 
From Sales.Orders
Union 
Select
CustomerID
From Sales.OrdersArchive

-- Best Practice
Select 
CustomerID 
From Sales.Orders
Union All
Select
CustomerID
From Sales.OrdersArchive

-- Tip 16: Use Union All + Distinct instead of Union when duplicates are not acceptable
Select Distinct 
CustomerID
From 
(
Select
CustomerID
From Sales.Orders
Union All 
Select 
CustomerID
From Sales.OrdersArchive
) t

-- Aggregating Data 

-- Tip 17: Use Columnstore Index for aggregations on large tables
Select
CustomerID,
Count(OrderID) as OrderCount
From Sales.Orders
Group By CustomerID

Create Clustered Columnstore Index Idx_Orders_Columnstore On Sales.Orders

-- Tip 18: Pre-Aggregate data and store it in a new table for reporting
Select 
Month(OrderDate) OrderMonth,
Sum(Sales) as TotalSales
Into Sales.SalesSummary
From Sales.Orders
Group By MONTH(OrderDate)

Select 
*
From Sales.SalesSummary

-- Subqueries

-- Tip 19: Join Vs Exists Vs In
-- Join 
-- More preferable for medium tables
Select 
o.OrderID,
o.Sales
From Sales.Orders o
Inner Join Sales.Customers c
On o.CustomerID = c.CustomerID
Where Country = 'USA'

-- Exists 
-- More preferable for large tables
-- Exists stops at girst match and avoid data duplication
Select
o.OrderID,
o.Sales
From Sales.Orders o
Where Exists 
(
Select
1
From Sales.Customers c
Where o.CustomerID = c.CustomerID
And c.Country = 'USA'
)

-- IN (Bad Practice)
-- In opertor processes and evaluates all rows, lacks an early exit mechanism
Select 
o.OrderID,
o.Sales
From Sales.Orders o
Where o.CustomerID In
(
Select
CustomerID
From Sales.Customers
Where Country = 'USA'
)

-- Tip 20: Avoid redundant logic in your query
-- Bad Practice
Select 
EmployeeID,
FirstName,
'Above Average' as Status
From Sales.Employees
Where Salary > (Select AVG(Salary) From Sales.Employees)
Union All 
Select 
EmployeeID,
FirstName,
'Below Average' as Status
From Sales.Employees
Where Salary < (Select AVG(Salary) From Sales.Employees)

-- Good Practice
Select 
EmployeeID,
FirstName,
Case
	When Salary > Avg(Salary) Over () Then 'Above Average'
	When Salary < Avg(Salary) Over () Then 'Below Average'
	Else 'Average'
End as Status
From Sales.Employees

-- Creating Tables (DDL)

-- Tip 21: Avoid Varchar & Text
-- Tip 22: Avoid using (Max) unnecessarily
-- Tip 23: Use Not Null constraint where applicable
-- Tip 24: Ensure all the tables have a clustered primary key
-- Tip 25: Create a non-clustered index for foreign keys that are used frequently

-- Bad Practice
Create Table CustomerInfo (
CustomerID int,
Firstname varchar(Max),
Lastname text,
Country varchar(255),
TotalPurchases Float,
Score varchar(255),
BirthDate varchar(255),
EmployeeID int,
Constraint FK_CustomerInfo_EmployeeID Foreign Key (EmployeeID)
References Sales.Employees (EmployeeID)
);

-- Good Practice
Create Table CustomersInfo (
CustomerID int Primary Key Clustered,
Firstname varchar(50) Not Null,
Lastname varchar(50) Not Null,
Country varchar(50) Not Null,
TotalPurchases Float,
Score int,
BirthDate date,
EmployeeID int,
Constraint FK_CustomerInfo_EmployeeID Foreign Key (EmployeeID)
References Sales.Employees (EmployeeID)
)
Create Nonclustered Index Idx_Customers_EmployeeID
On CustomersInfo (EmployeeID)

-- Indexing 

-- Tip 26: Avoid over indexing
-- Tip 27: Drop unused indexes 
-- Tip 28: Update statistics weekly 
-- Tip 29: Reorganize & Rebuild indexes weekly

-- Tip 30: Partition large tables (Facts) to improve performance then apply a columnstore index for the best results

-- Final Thoughts & Conclusion:
/*
1) Focus on writing clear queries
2) Optimize performance only when necessary
3) Always test using execution plan
*/