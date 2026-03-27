-- Ranking Window Functions 
/* There are two types of ranking:
   1) Integer-Based Ranking: Assign an integer for each row (ex:1,2,3,4 --> Discrete Values) Top/Bottom N Analysis
   - Row_Number(), Rank(), Dense_Rank(), NTile()
   2) Percentage-Based Ranking: Assign a percentage to each row (ex:0,0.25,0.5,0.75,1 --> Continous Values) Distribution Analysis
   - Cume_Dist(), Percent_Rank() */
/* Syntax: Rank() Over (Partition By ProductID Order By Sales)
   Expression must be empty (ex: Rank()) except in Ntile() there must be a number
   Partition By is optional
   Order By is required
   Frame Clause is not allowed */

-- 1] Integer-Based Ranking

-- 1) Row_Number(): It assigns a unique number to each row but doesn't handle ties.
-- Task: Rank the orders based on their sales from the highest to the lowest
Select
OrderID,
Sales,
ROW_NUMBER() Over (Order By Sales Desc) as SalesRow_Rank
From Sales.Orders

-- 2) Rank(): It assign a rank to each row and handle the ties but leaves gaps in the ranking.
-- Task: Rank the orders based on their sales from the highest to the lowest
Select
OrderID,
Sales,
Rank() Over (Order By Sales Desc) as SalesRank
From Sales.Orders

-- 3) Dense_Rank(): It assigns a rank to each row and handlie the ties without leaving gaps in the ranking.
-- Task: Rank the orders based on their sales from the highest to the lowest
Select
OrderID,
Sales,
Dense_Rank() Over (Order By Sales Desc) as SalesDense_Rank
From Sales.Orders

-- Use Case: Top-N Analysis --> Analyze the top performers to do targeted marketing
-- Task: Find the top highest sales for each product
Select
OrderID,
ProductID,
Sales,
Row_Number() Over (Partition By ProductId Order By Sales Desc) as TopProducts
From Sales.Orders
-- Task: Find the top highest sale for each product
Select 
*
From(
	Select
	OrderID,
	ProductID,
	Sales,
	Row_Number() Over (Partition By ProductId Order By Sales Desc) as TopProducts
	From Sales.Orders) t
Where TopProducts = 1

-- Use Case: Bottom-N Analysis --> Help analyze the underperformance to manage risks and to do optimizations
-- Task: Find the lowest 2 customers based on their total sales
Select 
*
From (
	Select
	CustomerID,
	Sum(Sales) TotalSales,
	ROW_NUMBER() Over (Order By Sum(Sales)) RankCust
	From Sales.Orders
	Group By CustomerID ) t 
Where RankCust <= 2

-- Use Case: Generate unique IDs --> Help to assign unique identifier for each row to help paginating
-- Paginating: Process of breaking down a large data into smaller more manageable chunks
-- Task: Assign unique IDs to the rows of the 'OrdersArchive' table
Select
ROW_NUMBER() Over (Order By OrderID,OrderDate) as New_ID,
*
From Sales.OrdersArchive

-- Use Case: Identifying Duplicates --> Identify and remove duplicate rows to improve data quality
-- Task: Identify duplicate rows in the table 'OrderArchive' and return a clean result without any duplicates.
Select
*
From(
	Select
	Row_Number() Over (Partition By OrderID Order By CreationTime Desc) RN,
	*
	From Sales.OrdersArchive) t
Where RN = 1

-- 4) NTile(): Divides the rows into a specified number of approximately equal groups (Buckets)
-- Bucket Size = number of rows / number of buckets
Select
OrderID,
Sales,
NTILE(1) Over (Order By Sales Desc) OneBucket, -- 10/1 = 10 --> 10
NTILE(2) Over (Order By Sales Desc) TwoBuckets, -- 10/2 = 5 --> 5,5
Ntile(3) Over (Order By Sales Desc) ThreeBuckets, -- 10/3 = 3.3 --> 4,3,3
NTILE(4) Over (Order By Sales Desc) FourBuckets -- 10/4 = 2.5 --> 3,2,2,2
From Sales.Orders

-- Use Case: Data Segmentation (Analysis) 
-- Data Segmentation: Divides a dataset into distinct subsets based on certain criteria.
-- Task: Segment all orders into 3 Categories: High, Medium, Low
Select
*,
Case 
	When Buckets = 1 Then 'High'
	When Buckets = 2 Then 'Medium'
	Else 'Low'
End as SalesSegmentations
From(
	Select 
	OrderID,
	Sales,
	NTILE(3) Over (Order By Sales Desc) Buckets
	From Sales.Orders) t

-- Use Case: Equalizing Load Processing(Engineering)
-- Equalizing Load Processing: Helps in dividing and transforming data  in chunks
-- Task: In order to export data, divide the orders into 2 groups
Select
NTILE(2) Over (Order By OrderID) as Buckets, 
*
From Sales.Orders

-- 2] Percentage-Based Ranking

-- 1) Cume_Dist(): Cumulative Distribution calculates the distribution of data points within a window
-- Cume_Dist() = position Nr / number of Rows (Nr: Number of value)
-- Tie Rule: The calculation is based on the position of the last occurence of the same value
-- It focuses on the distribution of data points
-- It is inclusive
Select 
OrderID,
Sales,
CUME_DIST() Over (Order By Sales Desc) SalesCume_Dist
From Sales.Orders

-- 2) Percent_Rank(): Calculates the relative position of each row
-- Percent_Rank() = position Nr - 1 / Number of rows - 1
-- Tie Rule: The calculation is based on the position of the first occurence of the same value 
-- It focuses on the relative position of each row
-- It is exclusive
Select 
OrderID,
Sales,
Round(PERCENT_RANK() Over (Order By Sales Desc),2) SalesPercent_Rank
From Sales.Orders

-- Task: Find the products that fall within the highest 40% of the prices
-- Using Cume_Dist()
Select
*,
CONCAT(ProductCume_Dist * 100, '%') as Percentage
From (
	Select
	ProductID,
	Product,
	Price,
	CUME_DIST() Over (Order By Price Desc) as ProductCume_Dist
	From Sales.Products ) t
Where ProductCume_Dist <= 0.4
-- Using Percent_Rank()
Select
*,
CONCAT(ProductCume_Dist * 100, '%') as Percentage
From (
	Select
	ProductID,
	Product,
	Price,
	Percent_Rank() Over (Order By Price Desc) as ProductCume_Dist
	From Sales.Products ) t
Where ProductCume_Dist <= 0.4