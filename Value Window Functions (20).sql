-- Value Window Functions (Window Analytical Functions)
-- Lead(), Lag(), First_Value(), Last_Value()
-- They access a value from other row
/*Syntax: Expression contains all data types , Partition Clause is optional, Order Clause is required
		  Frame Clause is not allowed in Lead() and Lag(), optional in First_Value(), should be used in Last_Value()*/

-- 1) Lead(): Access a value from the next row within a window
-- 2) Lag(): Access a value from a previous row within a window
/* ex: Lead(Sales,2,10) Over (Partition By ProductId Order By OrderDate)
       Sales --> Expression (required)
	   2 --> Offset (optional) Number of rows forward or backward from the current row (default = 1)
	   10 --> Default Value (optional) Returns default value if the next\previous row is not available (default = null)*/

/* Use Case: Time Series Analysis --> Process of analyzing the data to understand patterns, trends and behaviour over time.
			 Year-Over-Year(YoY): Analyze the overall growth or decline of the business performance over time.
			 Month-Over-Month(MoM): Analyze short-term trends and discover patterns in seasonality. */
-- Task: Analyze the Month-over-Month(MoM) performance by finding the percentage change in sales between the current and the previous month
Select
*,
TotalSales - PrevMonthSales as Mom_Change,
Concat(Round(Cast((TotalSales - PrevMonthSales) as Float) / PrevMonthSales * 100,2),'%') as PercentChange 
From(
	Select 
	Month(OrderDate) OrderMonth,
	Sum(Sales) as TotalSales,
	Lag(Sum(Sales)) Over (Order By Month(OrderDate)) PrevMonthSales
	From Sales.Orders
	Group By Month(OrderDate)) t

-- Use Case: Customer Retention Analysis --> Measure the customer's behaviour and loyalty to help businesses build strong relationships with customers.
-- Task: Analyze the customer loyalty by ranking customers based on the average number of days between orders.
Select
CustomerID,
Avg(DaysUntilNextOrder) as AvgDays,
Rank() Over (Order By Avg(DaysUntilNextOrder)) RankAvg
From(
	Select
	OrderID,
	CustomerID,
	OrderDate as CurrentOrder,
	Lead(OrderDate) Over (Partition By CustomerID Order By OrderDate) as NextOrder,
	DATEDIFF(DAY, OrderDate, Lead(OrderDate) Over (Partition By CustomerID Order By OrderDate)) as DaysUntilNextOrder
	From Sales.Orders) t
Group By CustomerID

-- 3) First_Value(): Access a value from the first row within a window
-- 4) Last_Value(): Access a value from the last row within a window
-- Default Frame: Rows Between Unbounded Preceding and Current Row
/* To solve the issue with Last_value() the frame should be edited to: 
   Rows Between Current Row And Unbounded Following */
-- Find the lowest and highest sales for each product
Select
ProductID,
Sales,
FIRST_VALUE(Sales) Over (Partition By ProductID Order By Sales) as LowestSale,
LAST_VALUE(Sales) Over (Partition By ProductID Order By Sales Rows Between Current Row And Unbounded Following) as HighestSale
From Sales.Orders
-- Another way of finding the highest sales (obviously the easier one)
-- First_Value() can be used instead
Select
ProductID,
Sales,
FIRST_VALUE(Sales) Over (Partition By ProductID Order By Sales Desc) as HighestSale
From Sales.Orders
-- Solving the task with Min and Max
Select
ProductID,
Sales,
Min(Sales) Over (Partition By ProductID) as LowestSale,
Max(Sales) Over (Partition By ProductID) as HighestSale
From Sales.Orders

-- Task: Find the difference between the current and lowest sales
Select
ProductID,
Sales,
FIRST_VALUE(Sales) Over (Partition By ProductID Order By Sales) as LowestSale,
Sales - FIRST_VALUE(Sales) Over (Partition By ProductID Order By Sales) as SalesDifference
From Sales.Orders