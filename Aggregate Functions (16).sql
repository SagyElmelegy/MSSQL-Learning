-- Aggregate Functions (count, sum, avg, max, min)

-- Task: Find total number of orders
Select 
Count(*) as TotalNumberOfOrders
from Sales.Orders

-- Task: Find the total sales of all orders
Select 
Sum(Sales) as TotalNumberOfSales
From Sales.Orders

-- Task: Find the average sales of all orders
Select
Avg(Sales) as AverageOfSales
From Sales.Orders

-- Task: Find the highest sales of all orders
Select 
Max(Sales) as HighestSale
From Sales.Orders

-- Task: Find the lowest sales of all orders
Select 
Min(Sales) as HighestSale
From Sales.Orders

-- Task: Find all these details for each customer
Select
CustomerID,
Count(*) as TotalNumberOfOrders,
Sum(Sales) as TotalNumberOfSales,
Avg(Sales) as AverageOfSales,
Max(Sales) as HighestSale,
Min(Sales) as HighestSale
From Sales.Orders
Group By CustomerID