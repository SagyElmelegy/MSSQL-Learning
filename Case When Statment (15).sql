-- Case Statement: Evaluates a list of conditions and returns 
--				   a value when the first condition is met

/* Syntax:
Case 
	When Condition1 Then Result1
	When Condition2 Then Result2
	When Condition3 Then Result3
	Else Result --> Optional
End */

-- Use Case1: Categorizing Data
-- Main purpose is Data Transformation --> Derive new info
-- Create new columns based on existing data

-- Categorizing Data: Group the data into different categories 
--					  based on certain conditions.

/* Task: Generate a report showing the total sales of each category:
		 High: sales > 50
		 Medium: 20 < sales < 50
		 Low: sales < 20
		 and sort the result from the highest to the lowest */
Select 
Category,
Sum(Sales) as TotalSales
From (
	 Select 
	 OrderID,
	 Sales,
	 Case
		 When Sales > 50 Then 'High'
		 When Sales > 20 Then 'Medium'
		 Else 'Low'
	 End as Category
From Sales.Orders
)t
Group By Category
Order By TotalSales Desc

-- Case Statment Rule: The data type of the results must be matching

-- Use Case2: Mapping Values
-- Transform the values from one form to another

-- Task: Retrieve the employee details with gender displayed as full text
Select 
EmployeeID,
FirstName,
LastName,
Department,
BirthDate,
Case
	When Gender = 'M' Then 'Male'
	Else 'Female'
End as Gender,
Salary,
ManagerID
From Sales.Employees

-- Task: Retrieve customer details with abbreciated country code 
Select
CustomerID,
FirstName,
LastName,
Case
	When Country = 'Germany' Then 'DE'
	When Country = 'USA' Then 'US'
	Else 'N/A'
End as CountryAbbreviation,
Score
From Sales.Customers

-- Quick Form of Case Statment
Select
CustomerID,
FirstName,
LastName,
Case Country
	When 'Germany' Then 'DE'
	When 'USA' Then 'US'
	Else 'N/A'
End as CountryAbbreviation,
Score
From Sales.Customers;

-- Use Case3: Handling Nulls
-- Replacing Nulls with a specific value.

-- Task: Find the average scores of customers and treat Nulls as 0
--		 and additional provide details such CustomersID & Lastname
Select 
CustomerID,
FirstName,
LastName,
Case
	When Score Is Null Then 0
	Else Score
End as Score,
AVG(Case
		When Score Is Null Then 0
		Else Score
End ) Over() AvgCustomer
From Sales.Customers

-- Use Case4: Conditional Aggregation
-- Applying aggregate functions only on subsets of data that fulfill 
-- certain conditions

-- Task: Count how many times each customer has made an order 
--		 with sales greater than 30.
Select 
CustomerID,
Sum(Case 
	When Sales > 30 Then 1
	Else 0
End) HighSales,
Count(*) TotalOrders
From Sales.Orders
Group By CustomerID