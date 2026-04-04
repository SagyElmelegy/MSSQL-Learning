-- Subquery: A query inside another query
/* Categories of Subqueries:
   1) Dependancy --> Non-correlated(independent subquery) / Correlated(dependent subquery)
   2) Result Types --> Scalar(One single value) / Row(Multiple rows in the result) / Table(Returns multiple rows and columns)
   3) Location | Clauses --> Where the subquery is going to be used (Select, From, Join, Where)
						 --> Subqueries can be used together with the comparison and logical operators in the where clause */

-- 1] Result Types:
-- 1) Scalar Subquery: Returns only a single value
Select
Avg(Sales)
From Sales.Orders
-- 2) Row Subquery: Returns multiple rows and a single column
Select
CustomerID
From Sales.Orders
-- 3) Table Subquery: Retruns multiple rows and columns
Select
*
From Sales.Orders

-- 2] Location | Clauses
-- 1) From Subquery: Used as temporary table for the main query
-- Task: Find the products that have a higher price than the average price of all products
Select
*
From(
	Select
	ProductID,
	Price,
	Avg(Price) Over () AvgPrice
	From Sales.Products) as t
Where Price > AvgPrice
-- Task: Rank customers based on their total amount of sales
Select
*
From(
	Select
	CustomerID,
	Sum(Sales) as TotalSales
	From Sales.Orders
	Group By CustomerID)t
Order By TotalSales Desc
-- Or
Select
*,
Rank() Over (Order By TotalSales Desc) CustomerRank 
From(
	Select
	CustomerID,
	Sum(Sales) as TotalSales
	From Sales.Orders
	Group By CustomerID)t 

-- 2) Select Subquery: Used to aggregate data side by side with the main query's data, allowing for direct comparison.
-- Only scalar subqueries are allowed to be used.
-- Task: Show the productID, names, prices and total number of orders
Select 
ProductID,
Product,
Price,	
	(Select 
	Count(OrderID) as TotalOrders
	From Sales.Orders) as NumberofOrders 
From Sales.Products

-- 3) Join Subquery: Used to prepare the data (filtering or aggregation) before joining it with other tables.
-- Task: Show all the customers' details and find the total orders of each customer.
Select 
c.*,
o.TotalOrders
From Sales.Customers as c
Left Join (
		  Select 
		  CustomerID,
		  Count(OrderID) as TotalOrders
		  From Sales.Orders
		  Group By CustomerID) as o
On c.CustomerID = o.CustomerID

Select * From Sales.Customers

-- 4) Where Subquery: Used for complex filtering logic and makes query more flexible and dynamic.
-- 1- Comparison Operators: Used to filter data by comparing two values (=,!= <>, <, >, <=, >=)
-- Only scalar subqueries are allowed to be used
-- Find the products that have a higher price than the average price of all products
Select 
ProductID,
Price,
(Select Avg(Price) From Sales.Products) as AvgPrice
From Sales.Products 
Where Price > ( Select 
			    Avg(Price) as AvgPrice
				From Sales.Products)
-- 2- Logical Operators (In, Any, All, Exists)
-- 1} In Operator: Checks whether a value matches any value from a list
-- Task: Show the details of orders made by customers from Germany
Select
*
From Sales.Orders
Where CustomerID In (
					Select
					CustomerID
					From Sales.Customers
					Where Country = 'Germany')
-- Or
Select
o.*
From Sales.Orders as o
Left Join Sales.Customers as c
On o.CustomerID = c.CustomerID
Where Country = 'Germany'
-- Show the details of orders for customers who are not from Germany
Select
*
From Sales.Orders
Where CustomerID Not In (
					Select
					CustomerID 
					From Sales.Customers
					Where Country = 'Germany')
-- Or 
Select
*
From Sales.Orders
Where CustomerID In (
					Select
					CustomerID 
					From Sales.Customers
					Where Country != 'Germany')

-- 2} Any: Checks if a value matches any value within a list.
--		 : Used to check if a value is true for at least one of the values in a list
-- Task: Find female employees whose salaries are greater than salaries of any male employees
Select
EmployeeID,
FirstName,
Gender,
Salary
From Sales.Employees
Where Gender = 'F'
And Salary > Any (Select Salary From Sales.Employees Where Gender = 'M')

-- 3} All Operator: Checks if a value matches all the values within a list.
-- Task: Find female employees whose salaries are greater than the salaries of all male employees
Select
EmployeeID,
FirstName,
Salary
From Sales.Employees
Where Gender = 'F'
And Salary > All (Select Salary From Sales.Employees Where Gender = 'M')

-- 4} Exist: Checks if a subquery returns any rows
-- Correlated Subquery in Where Clause 
-- Task: Show the order details for customers in Germany
Select
*
From Sales.Orders o
Where Exists 
(Select * From Sales.Customers c 
 Where Country = 'Germany' And o.CustomerID = c.CustomerID)
-- Another Way
Select
o.*
From Sales.Orders o
Left Join Sales.Customers c
On o.CustomerID = c.CustomerID
Where Country = 'Germany'

-- 3] Dependancy
-- 1) Non-Correlated Subquery: A subquery that can run independently from the main query
-- 2) Correlated Subquery: A subquery that relies on values from the main query
-- Task: Show all the customer details and find the total orders of each customer.
Select
*,
(Select Count(*) From Sales.Orders o Where o.CustomerID = c.CustomerID) as TotalSales
From Sales.Customers c
-- Another way
Select Distinct
c.*,
Count(o.OrderID) Over (Partition By o.CustomerID) as TotalOrders
From Sales.Customers as c
Left Join Sales.Orders as o
on c.CustomerID = o.CustomerID