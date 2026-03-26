-- Null Functions: Replacement - Checking

-- 1) IsNull(): Replaces 'Null' with a specific value
-- IsNull(value, replacement_value) --> IsNull(ShipAddress, 'unknown')
									--> IsNull(ShipAddress, BillingAddress)

-- 2) Coalesce(): Returns the first non-null value from a list
-- Coalesce(value1, value2, value3, ...) --> Coalesce(ShippingAddress, BillingAddress, 'Unknown')

-- Use Case: IsNull and Coalesce are both cane be used to handle the null values before doing data aggregations

-- Task: Find the average scores of the customers
Select 
CustomerID,
FirstName,
Score,
AVG(Score) over () AvgScores,
Coalesce(Score,0) as Score2,
AVG(Coalesce(score,0)) over () AvgScores2
From Sales.Customers

-- Use Case: IsNull and Coalesce can be used to handle nulls before performing any mathematical opeartions
-- ex: Null + 5 = Null 
--	 : Null + 'B' = Null 

/* Task: Display the full name of customers in a single field 
		 by merging their first and last names 
		 and add 10 bonus points to each customer's score
*/
Select 
FirstName,
LastName,
FirstName + ' ' + LastName as FullName1, 
FirstName + ' ' + Coalesce(LastName,'') as FullName2, 
Score,
Coalesce(Score,0) as BeforeBonus,
Coalesce(Score,0) + 10 as AfterBonus
From Sales.Customers

-- Use Case: IsNull and Coalesce can be used to handle the nulls before joining tables
/* Let Table1 (Year, Type, Orders) and Table2 (Year, Type, Sales)
Select 
a.year , a.type , a.orders , b.sales
From Table1 as a
Join Table2 as b
On a.year = b.year
And IsNull(a.type,'') = IsNull(b.type,'') */

-- UseCase: IsNull and Coalesce can be used to handle the nulls before sorting data
/* 
Task: Sort the customers from the lowest to the highest scores
with Nulls appearing last. 
*/
Select 
CustomerID,
Score
From Sales.Customers
Order By Score
-- Method1: Replace the Null with a big value (Lazy and not professional)
Select 
CustomerID,
Score,
Coalesce(Score,100000)
From Sales.Customers
Order By Coalesce(Score,100000)
--Method2
Select 
CustomerID,
Score,
Case When Score IS NULL Then 1 Else 0 End as Flag
From Sales.Customers
Order By Case When Score IS NULL Then 1 Else 0 End , Score

/* NullIf(): Compares two expressions and returns 
- Null, if they are equal 
- First Value, if they are not equal 
Syntax: NullIf(value1.value2)
- NullIf(Shipping_Address, 'unknown') --> Column with a static value
- NullIf(Shipping_Address, Billing_Address) --> Column with column
*/
-- UseCase: Preventing the error of dividing by zero 
-- Task: Find the sales price of each order by dividing the sales by the quantity .
Select 
OrderID,
Sales,
Quantity,
Sales / NullIf(Quantity,0) as Price 
From Sales.Orders

-- Is Null & Is Not Null
/* 
Is Null: Returns True if the value is null
Is not Null: Returns True if the value is not null
Synatx: Value Is Null 
ex: Shipping_Address Is Null
*/
-- UseCase: Used in filtering data (searching for missing values)
-- Task: Identify the customers who have no scores
Select 
CustomerID,
FirstName,
Score
From Sales.Customers
Where Score is Null 
-- Task: List all customers who have scores
Select 
CustomerID,
FirstName,
Score
From Sales.Customers
Where Score is not null 
Order By Score
-- UseCase: Is Null can be used in anti joins by finding the unmatched rows between two tables
-- Task: List all details for customers who have not placed any orders
Select 
c.*,
o.OrderID
From Sales.Customers as c
Left Join Sales.Orders as o
on c.CustomerID = o.CustomerID 
-- Left Anti Join: Shows all rows from the left table without matches in the right table
Where o.CustomerID is Null