-- Window Aggregate Functions

-- 1) Count(): Returns the number of rows within a window.
-- Count(*): Counts all rows in a table regardless of wether any value is Null.
-- Count(column): Counts the number of non--Null values in the column.
-- Count(1) = Count(*)
-- Count(): Counts the number of the values in a column regardless of their data types including duplicates.

-- Task: Find the total number of orders.
Select
Count(OrderID) as TotalOrders
From Sales.Orders
-- Use Case 1: Performs overall analysis (quick snapshot of the entire dataset)

-- Task: Find the total number of orders and provide details such as orderID & OrderDate
Select 
OrderID,
OrderDate,
Count(*) over () TotalOrders
From Sales.Orders

-- Task: Find the total orders for each customer
Select
OrderID,
CustomerID,
COUNT(OrderID) over (Partition by CustomerID) OrdersByCustomers
From Sales.Orders
-- Use Case 2: Performs group-wise analysis to understand the patterns within different categories

-- Task: Find the total number of customers and provide the customer's details
Select
*,
Count(*) over () TotalCustomers
From Sales.Customers

-- Task: Find the total number of scores for the customers
Select
*,
Count(*) over () TotalCustomers,
Count(Score) over () TotalScores
From Sales.Customers;
-- And to solve the issue
Select
Count(Coalesce(Score,'')) over () TotalScores
From Sales.Customers;
-- Use Case 3: Performs data quality check by detecting the number of nulls by comparing to total number of rows

-- Use Case 4: Data Quality Issue: Duplicates leads to inaccuracies in analysis
--								 : Count() can be used to identify duplicates

-- Task: Check whether the table Orders contains any duplicate rows
Select 
OrderID,
Count(*) Over (Partition by OrderID) CheckPK
From Sales.Orders;

Select
OrderID,
Count(*) Over (Partition by OrderID) CheckPK
From Sales.OrdersArchive
-- To point out exactly the duplicates only
Select
*
From (
	 Select
	 OrderID,
	 Count(*) Over (Partition by OrderID) CheckPK
	 From Sales.OrdersArchive )t 
Where CheckPK > 1

-- 2) Sum(): Returns the sum of all values within a window
-- Task: Find the total sales across all orders and total sales for each productand provide details such as OrderID and OrderDate.
Select
OrderID,
OrderDate,
ProductID,
Sales,
Sum(Sales) over () as OrdersSales,
Sum(Sales) over (Partition by ProductID) ProductSales
From Sales.Orders
-- Use Case 1: Overall Analysis (quick summary of the entire dataset)

-- Use Case2: Comparison Analysis (Compare the current value to the total aggregated value)
-- Use Case3: Part-To-Whole Analysis (shows the contribution of each data point to the overall dataset)
-- Task: Find the percentage contribution of each product's sales to the total sales
-- Contribution Percent = (Product Sales / Total Sales) * 100
Select
OrderID,
ProductID,
Sales,
Sum(Sales) over () as OrdersSales,
Round(Cast(Sales as float) / Sum(Sales) over () * 100,2) as ContributionPercent
From Sales.Orders

-- 3) Avg(): Returns the average of values within a window
-- Task: Find the average sales across all orders and the average sales for each product and provide details such as OrderId and OrderDate.
Select
OrderID,
OrderDate,
ProductID,
Sales,
Avg(Sales) Over () AvgSales,
Avg(Sales) Over (Partition By ProductID) As AvgPerProduct
From Sales.Orders
-- Use Case 1: Overall Analysis
-- Use Case 2: Group-Wise Analysis to understand patterns within different categories

-- Task: Find the average scores of customers and provide details such as CustomerId and last name
Select
CustomerID,
LastName,
Score,
Avg(Coalesce(Score,0)) Over () CustomersAvg
From Sales.Customers

-- Find all orders where sales are higher than the average sales across all orders
Select
*
From(
	Select
	OrderId,
	Sales,
	Avg(Sales) Over () AvgSales
	From Sales.Orders
	)t
Where Sales > AvgSales
-- Use Case 3: Compare to Average (Helps to evaluate whether a value is above or below the average)

-- 4) Min(): Returns the lowest value within a window
--	  Max(): Returns the highest value within a window

-- Task: Find the Highest & Lowest sales across all orders
--	   : Find the Highest & Lowest sales for each product and provide details such as OrderId and OrderDate
Select
OrderID,
OrderDate,
ProductID,
Sales,
Max(Sales) Over () MaxSale,
Min(Sales) Over () MinSale,
Max(Sales) Over (Partition By ProductID) MaxProduct,
Min(Sales) Over (Partition By ProductID) MinProduct
From Sales.Orders
-- Use Case 1: Overall Analysis
-- Use Case 2: Group-Wise Analysis 

-- Task: Show the employees who have the highest salaries
Select
*
From (
	Select
	*,
	Max(Salary) Over () HighestSalary
	From Sales.Employees 
	) t
Where Salary = HighestSalary

-- Task: Calculate the deviation of each sale from both the minimum and maximum sales amount
Select
OrderID,
OrderDate,
ProductID,
Sales,
Max(Sales) Over () HighestSales,
Min(Sales) Over () LowestSales,
Sales - Min(Sales) Over () as MinDeviation,
Max(Sales) Over () - Sales as MaxDeviation
From Sales.Orders
-- Use Case 3: Compare to extremes (Help to evaluate how well a values is performing relative to the extremes)

-- Analytical Use Case: Running & Rolling Total
-- Tracking: Tracking The current sales with target sales
-- Trend Analysis: Providing insights into historical patterns
-- Running & Rolling Total: They aggregate sequence of members and the aggregation is updated each time a new member is added.
-- Can be also called Analysis-Over-Time
-- Running Total: Aggregate all values from the beginning up to the current point without dropping off older data.
-- Rolling Total: Aggregate all values within a fixed time window (e.g:30 days) and as new data is added, the oldest data point will be dropped. (Rolling/Shifting Window)
-- Ex: Running Total--> Sum(Sales) Over (Order By Month)
--   : Rolling Total--> Sum(Sales) Over (Order By Month Rows Between 2 Preceding and Current Row)

-- Analytical Use Case: Moving Average
-- Calculate the moving average of sales for each product over time.
Select
OrderID,
ProductID,
Sales,
OrderDate,
Avg(Sales) Over (Partition By ProductId) ProductAvg,
Avg(Sales) Over (Partition By ProductId Order By OrderDate) MovingAvg
From Sales.Orders

-- Task: Calculate the moving average of sales for eeach product over time including only the next order
Select
OrderID,
ProductID,
Sales,
OrderDate,
Avg(Sales) Over (Partition By ProductId) ProductAvg,
Avg(Sales) Over (Partition By ProductId Order By OrderDate Rows Between Current Row And 1 Following) MovingAvg
From Sales.Orders