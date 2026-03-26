/* Window Functions: Perform calculations (aggregation) on a specific subset of data,
					 without losing the level of details of rows. */
-- Performs Row-Level Calculations
/* Group By vs Window
   Group By: Returns a single row for each group (changes granularity)
   Window: Returns a result for each row (granularity stays the same) 
   Group By: Does Simple Data Analysis (Aggregations)
   Window: Does Advanced Data Analysis (Aggregations + Details)*/

-- Task: Find the total sales across all orders
Select
Sum(Sales) as TotalSales
From Sales.Orders

-- Task: Find the total sales across for each product
Select
ProductID,
SUM(Sales) as TotalSales
From Sales.Orders
Group By ProductID

/* Task: Find total sales for each product additionally provide details 
         such as order id & order date. */
-- Group By limits: Can't do aggregations and provide details at the same time.
-- Result Granularity: Window functions returns a result for each row.
Select
ProductID,
OrderID,
OrderDate,
SUM(Sales) over(Partition By ProductID) as TotalSalesByProduct
From Sales.Orders

/* Syntax: 
Window Function Over (Partition, Order, Frame)
ex: Avg(Sales) Over (Partition By Category Order By OrderDate Rows Unbounded Preceding)
Window Functions: Performs calculations within a window
Window Functions --> Aggregate func (Count, Sum, Avg, Max,Min) Numeric
				 --> Rank func (Row_Number, Rank, Dense_Rank, Cume_Dist, Percent_Rank, NTile) Ntile only is numeric
				 --> Value/Analytics func (Lead, Lag, First_Value, Last_Value) All Data Types
Function Expression: Arguments you pass to the function
Function Expression --> Empty
					--> Column
					--> Number
					--> Multiple Arguments
					--> Conditional Logic
Over Clause: Tells SQL that the function used is a window function
		   : It defines a window or a subset of data */

-- Partition By: Divides the result set into partitions (Windows)
/* Without Partition By: Total sales across all rows (Entire result Set)
   Partion By Single Column: Total sales for each product
   Partition By Combined-Columns: Total sales for each combination of Product and OrderStatus
   Partition By Clause is optional for all functions (agg, rank, value)*/

-- Task: Find the total sales across all orders additionally provide details such as orderID & Order Date
Select
OrderId,
OrderDate,
Sum(Sales) Over () as TotalSales
From Sales.Orders

-- Task: Find the total sales for each product additionally provide details such as orderID & Order Date
Select 
OrderID,
OrderDate,
ProductID,
Sum(Sales) Over (Partition By ProductID) as TotalSales
From Sales.Orders

-- Task: Find the total sales across all sales and for each product additionally provide details such as orderID & Order Date
Select 
OrderID,
OrderDate,
ProductID,
Sales,
Sum(Sales) Over () as TotalSales,
Sum(Sales) Over (Partition By ProductID) as TotalSalesByProduct
From Sales.Orders

-- Flexibility of Window: Allows aggregation of data at different granularities within the same query

-- Task: Find the total sales for each combination of product and order status
Select 
OrderID,
OrderDate,
ProductID,
Sales,
OrderStatus,
Sum(Sales) Over (Partition By ProductID, OrderStatus) SalesByProductsAndStatus
From Sales.Orders

-- Order By: Sort the data within a window
/* Order By clause is : Optional --> Aggregate func
						Required --> Rank & Value func */

-- Task: Rank each order based on their sales from higest to lowest
--		 additionally provide details such as OrderId & Order Date
Select
OrderID,
OrderDate,
Sales,
Rank() Over (Order By Sales Desc) RankSales
From Sales.Orders

-- Window Frame: Defines a subset of rows within each window that is relevant for the calculation
/* Avg(Sales) Over (Partition By Category Order By OrderDate Rows Between Current Row And Unbounded Preceding)
Rows --> Frame Type: Rows, Range
Current Row --> Frame Boundary (Lower Value): Current Row, N Preceding, Unbounded Preceding
Unbounded Preceding --> Frame Boundary (Higher Value): Current Row, N Following, Unbounded Following */

Select
OrderID,
OrderDate,
OrderStatus,
Sales,
Sum(Sales) Over (Partition By OrderStatus Order By OrderDate
Rows Between Current Row and 2 Following) as TotalSales
From Sales.Orders

-- Compact Frame: For only preceding and current row can be skipped
-- ex: Normal Form: Rows Between Current Row and 2 Following
--	   Short Form: Rows 2 Following
Select
OrderID,
OrderDate,
OrderStatus,
Sales,
Sum(Sales) Over (Partition By OrderStatus Order By OrderDate
Rows Between 2 Preceding and Current Row) as TotalSales
From Sales.Orders

-- Can be also

Select
OrderID,
OrderDate,
OrderStatus,
Sales,
Sum(Sales) Over (Partition By OrderStatus Order By OrderDate
Rows 2 Preceding) as TotalSales
From Sales.Orders

-- Default Frame: SQL uses Default Frame if Order By is used without Frame
--				: Rows Between Unbounded Preceding and Current Row

-- Rules: 
/* 1) Window functions in Select and Order By clauses
   - Window Functions can't be used for filtering data
   2) Nesting Window functions is not allowed
   3) SQL execute Window Functions after Where Clauses */
-- Task: Find the total sales for each order status only for two products 101 and 102
Select
OrderID,
OrderDate,
OrderStatus,
ProductID,
Sales,
Sum(Sales) Over (Partition By OrderStatus) TotalSales
From Sales.Orders
Where ProductID in (101,102)
-- 4) Window Function can be used together with Group By in the same 
--	  query only if the same columns are used
-- Task: Rank the customers based on their total sales
Select
CustomerID,
Sum(Sales) as TotalSales,
Rank() Over (Order By Sum(Sales) Desc) as CustomerRank
From Sales.Orders
Group By CustomerID