-- CTE (Common Table Expression)
-- It is a temporary named result set (virtual table) that can be used multiple times within the query to simplify and organize complex query.
-- It is only available for the local queries.
/* Types of CTEs: 
1- Non-Recursive CTE --> Standalone CTE & Nested CTE
2- Recursive CTE */

-- 1] Non-Recursive CTE
-- 1) Standalone CTE: It is defined and used independently in the query as it is self-contained and doesn't rely on other CTEs or queries.
-- Syntax: With CTE_Name As (Select.. From.. Where..) 
-- Task: Find the total sales per customer
With CTE_Total_Sales As (
Select
CustomerID,
Sum(Sales) as TotalSales
From Sales.Orders
Group By CustomerID )
Select 
c.CustomerID,
c.FirstName,
c.LastName,
cts.TotalSales
From Sales.Customers as c
Left Join CTE_Total_Sales cts
On c.CustomerID = cts.CustomerID
Order By TotalSales
-- You can't use Order By directly within the CTE

-- # Multiple Standalone CTE 
-- Syntax: With CTE_Name1 As (Select.. From.. Where..), CTE_Name2 As (Select.. From.. Where..)
-- Task: Find the total sales and last order date per customer 
With CTE_Total_Sales As 
(
Select
CustomerID,
Sum(Sales) As TotalSales
From Sales.Orders 
Group By CustomerID
)
, CTE_Last_Order As
(
Select 
CustomerID,
Max(OrderDate) as LastOrder
From Sales.Orders
Group By CustomerID
)
Select
c.CustomerID,
c.FirstName,
c.LastName,
cts.TotalSales,
clo.LastOrder
From Sales.Customers c
Left Join CTE_Total_Sales cts
On c.CustomerID = cts.CustomerID
Left Join CTE_Last_Order clo
On c.CustomerID = clo.CustomerID

-- 2) Nested CTE: CTE inside another CTe
-- It uses the result of another CTE so it can run independently
-- Syntax: With CTE_Name1 As (Select.. From.. Where..), CTE_Name2 As (Select.. From CTE_Name1 Where..)
-- Task: Find the total sales, last order date per customer and rank them based on total sales per customer.
With CTE_Total_Sales AS 
(
Select
CustomerID,
Sum(Sales) as TotalSales
From Sales.Orders
Group By CustomerID
), CTE_Last_Order As
(
Select
CustomerID,
Max(OrderDate) as LastOrder
From Sales.Orders
Group By CustomerID
), CTE_Customer_Rank As 
(
Select
CustomerID,
TotalSales,
Rank() Over (Order By TotalSales Desc) Customer_Rank
From CTE_Total_Sales
)
Select 
c.CustomerID,
c.FirstName,
c.LastName,
cts.TotalSales,
clo.LastOrder,
ccr.Customer_Rank
From Sales.Customers c
Left Join CTE_Total_Sales cts
On c.CustomerID = cts.CustomerID
Left Join CTE_Last_Order clo
On c.CustomerID = clo.CustomerID
Left Join CTE_Customer_Rank ccr
On c.CustomerID = ccr.CustomerID
Order By cts.TotalSales Desc

-- Task: Do the previous requirments in addition to segmenting the customers based on total sales
With CTE_Total_Sales AS 
(
Select
CustomerID,
Sum(Sales) as TotalSales
From Sales.Orders
Group By CustomerID
), CTE_Last_Order As
(
Select
CustomerID,
Max(OrderDate) as LastOrder
From Sales.Orders
Group By CustomerID
), CTE_Customer_Rank As 
(
Select
CustomerID,
TotalSales,
Rank() Over (Order By TotalSales Desc) Customer_Rank
From CTE_Total_Sales
), CTE_Customer_Segments As 
(
Select
CustomerID,
Case When TotalSales > 100 Then 'High'
	 When TotalSales > 60 Then 'Medium'
	 Else 'Low'
End As Customer_Segment
From CTE_Total_Sales
)
Select 
c.CustomerID,
c.FirstName,
c.LastName,
cts.TotalSales,
clo.LastOrder,
ccr.Customer_Rank,
ccs.Customer_Segment
From Sales.Customers c
Left Join CTE_Total_Sales cts
On c.CustomerID = cts.CustomerID
Left Join CTE_Last_Order clo
On c.CustomerID = clo.CustomerID
Left Join CTE_Customer_Rank ccr
On c.CustomerID = ccr.CustomerID
Left Join CTE_Customer_Segments ccs
On c.CustomerID = ccs.CustomerID
Order By cts.TotalSales Desc

-- 2] Recursive CTE: A self-referencing query that repeatedly processes data until a specific condition is met
-- Syntax: With CTE_Name As (Select.. From.. Where.. Union All Select.. From CTE_Name Where(Break Condition))
--                               (Anchor Query)                     (Recursive Query)        
-- Task: Generate a sequence of numbers from 1 to 20
With CTE_Sequence As
(
Select
1 as MyNumber
Union All
Select
MyNumber + 1
From CTE_Sequence
Where MyNumber < 20
)
Select
*
From CTE_Sequence 
Option (MaxRecursion 10) -- Assigning the maximum number of recursions  

-- Show the employee hierarchy by displaying each employee's level within the organization
With CTE_Employee_Hierarchy As
(
Select
EmployeeID,
FirstName,
ManagerID,
1 as Emp_Level
From Sales.Employees
Where ManagerID Is Null
Union All 
Select
e.EmployeeID,
e.FirstName,
e.ManagerID,
Emp_Level + 1
From Sales.Employees as e
Inner Join CTE_Employee_Hierarchy as ceh
On e.ManagerID = ceh.EmployeeID
)
Select
*
From CTE_Employee_Hierarchy

Select *  From Sales.Employees