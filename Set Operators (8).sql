/* Set Operators: It combines the results of multiple queries into a single result.
	1- They can be used almost in all clauses. (Where - Join - Group by - Having)
	 - Order by is allowed only once at the end of the query
	2- Number of columns must be the same
	3- Data types of the columns in each query must be compatible
	4- The order of the columns in each query must be the same 
	5- The columns names in the result set are determined by the column names specified in the first query */
	Select 
	CustomerID as ID,
	FirstName,
	LastName,
	FirstName + ' ' + LastName as FullName
	From Sales.Customers

	Union

	Select 
	EmployeeID,
	FirstName,
	LastName,
	FirstName + ' ' + LastName
	From Sales.Employees

/*	6- Even if all rules are met and SQL shows no errors, the result still may be incorrect.
	 - Incorrect column selection leads to inaccurate results. */

-- 1) Union: Returns all distinct rows from both queries, removes duplicate rows from the result.
-- Order of queries doesn't affect the result.

-- Combine the data from employees and customers into one table.
Select * From Sales.Customers;
Select *  From Sales.Employees;

Select 
FirstName,
LastName
From Sales.Customers
Union
Select 
FirstName,
LastName
From Sales.Employees

-- 2) Union All: Returns all rows from both queries, including duplicates.
-- It is generally faster than Union
-- It is used to find duplicates and quality issues

-- Combine the data from employees and customers into one table including duplicates
Select 
FirstName,
LastName
From Sales.Customers
Union All
Select 
FirstName,
LastName
From Sales.Employees

-- 3) Except: Returns the distinct rows from the first query that are not found in the second query.
-- It is the only operator where the order of the queries affects the final result.

-- Find the employees who are not customers at the same time
Select 
FirstName,
LastName
From Sales.Employees
Except
Select 
FirstName,
LastName
From Sales.Customers

-- If we altered the order, this will result in different output 
Select 
FirstName,
LastName
From Sales.Customers
Except
Select 
FirstName,
LastName
From Sales.Employees

-- 4) Intersect: Returns only the rows that are common in both queries(tables)

-- Find the employees that are also customers
Select 
FirstName,
LastName
From Sales.Employees
Intersect
Select 
FirstName,
LastName
From Sales.Customers

-- Challenge:
-- Orders are stored in separate tables, combine all orders into one report without duplicates
-- Source Flag: Indicates the table from which each rows is coming from
Use SalesDB;
Select * From Sales.Orders;
Select * from Sales.OrdersArchive;

Select 
	   'Orders' as SourceTable
	  ,[OrderID]
	  ,[ProductID]
      ,[CustomerID]
      ,[SalesPersonID]
      ,[OrderDate]
      ,[ShipDate]
      ,[OrderStatus]
      ,[ShipAddress]
      ,[BillAddress]
      ,[Quantity]
      ,[Sales]
      ,[CreationTime]
From Sales.Orders
Union
Select 
	   'OrdersArchive' as SourceTable
	  ,[OrderID]
	  ,[ProductID]
      ,[CustomerID]
      ,[SalesPersonID]
      ,[OrderDate]
      ,[ShipDate]
      ,[OrderStatus]
      ,[ShipAddress]
      ,[BillAddress]
      ,[Quantity]
      ,[Sales]
      ,[CreationTime]
From Sales.OrdersArchive
Order By OrderID

/* Use Cases:
   1- Delta Detection: Identifying the differences or changes between two batches of data. (Except)
   2- Data Completeness Check: Except operator can be used to compare tables to detect discrepancies between databases. (Except)
   3- Combining Information (Union + Union All) */