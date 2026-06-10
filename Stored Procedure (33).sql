-- Stored Procedures

-- Stored Procedure: A script that is stored in the database (Server-Side) holding multiple commands and statments which starts implementing upon execution without the need of repeating htem over and over again.

-- Stored Procedure Vs Query
-- Query: It is a one time command that has its job done for once only
-- Stored Procedure: It is a script of multiple commands stored that can be done multiple times without the need for rewriting them.

-- Stored Proccedure Vs Python
/*
Stored Procedure: Faster since it doesn't require a connection to the database and the scripts are already recompiled
Python Scripts: It requires a connection first to the database 
			  : It is better in case of flexibilty, Version Control and Complex Logics.
*/
-- It is better to use Python in big projects instead of Stored Procedures

-- Syntax: Create Procedure procedure_name As Begin ..... End 
-- To execute : Exec procdure_name 

-- Step 1: Writing a query
-- Find the total number of customers and average score for US customers
Select 
Count(*) as CustomersCount,
Avg(Score) as AvgScore
From Sales.Customers
Where Country = 'USA'

-- Step 2: Turning the query into a Stored Procedure
Create Procedure CustomersSummary As
Begin 
Select 
Count(*) as CustomersCount,
Avg(Score) as AvgScore
From Sales.Customers
Where Country = 'USA'
End

-- Step3: Execute(Call) the Stored Procedure
Exec CustomersSummary

-- Parameters: Placeholders used to pass values as inputs from the caller to the procedure allowing dynamic data to be processed 

-- Task: Find the total number of customers and average score for german customers 
Create Procedure GermanCustomersSummary As
Begin
Select 
Count(*) as CustomersCount,
Avg(Score) as AvgScore
From Sales.Customers
Where Country = 'Germany'
End

Exec GermanCustomersSummary

-- Note: Avoid Repetition -> If there is a repeated code in the project, this is a sign that the code can be improved 

Alter Procedure CustomersSummary @Country NVarchar(50) As
Begin
Select 
Count(*) as CustomersCount,
Avg(Score) as AvgScore
From Sales.Customers
Where Country = @Country
End

Exec CustomersSummary @Country = 'Germany'
Exec CustomersSummary @Country = 'USA'

-- To drop a procedure 
Drop Procedure GermanCustomersSummary

-- To add a frequently used value in the stored procedure 
Alter Procedure CustomersSummary @Country NVarchar(50) = 'USA' As
Begin
Select 
Count(*) as CustomersCount,
Avg(Score) as AvgScore
From Sales.Customers
Where Country = @Country
End

Exec CustomersSummary
-- If you want the German customers
Exec CustomersSummary @country = 'Germany'

-- Multiple Statements
-- Find the total number of orders and total sales in addition to the previous requirments
Alter Procedure CustomersSummary @Country Nvarchar(50) = 'USA' As
Begin
Select 
Count(*) as TotalCustomers,
Avg(Score) as AvgScore
From Sales.Customers
Where Country = @Country;

Select 
Count(OrderID) as TotalOrders,
Sum(Sales) as TotalSales
From Sales.Orders o
Inner Join Sales.Customers c
On o.CustomerID = c.CustomerID
Where c.Country = @Country;
End

Exec CustomersSummary -- In case of USA
Exec CustomersSummary @Country = 'Germany' -- In case of Germany

-- Variables: Placeholders used to store values to be used later in the procedure. 
/*
Variables Vs Parameters
Parameters: Pass values into a stored procedure or return values back to the caller
Variables: Temporarily store and manipulate data during its execution
*/
-- Print a message of the result 
Alter Procedure CustomersSummary @Country Nvarchar(50) = 'USA' As
Begin

Declare @TotalCustomers int, @AverageScore Float

Select 
@TotalCustomers = Count(*),
@AverageScore = Avg(Score)
From Sales.Customers
Where Country = @Country;

Print 'Total Customers from ' + @Country + ': ' + Cast(@TotalCustomers as NVarchar);
Print 'Average Score from ' + @Country + ': ' + Cast(@AverageScore as Nvarchar);

Select 
Count(OrderID) as TotalOrders,
Sum(Sales) as TotalSales
From Sales.Orders o
Inner Join Sales.Customers c
On o.CustomerID = c.CustomerID
Where c.Country = @Country;
End

Exec CustomersSummary
Exec CustomersSummary @Country = 'Germany'

--It can also be done outside of a procedure
Declare @TotalOrders int, @TotalSales float;
Select 
@TotalOrders = Count(*),
@TotalSales = SUM(Sales)
From Sales.Orders o
Inner Join Sales.Customers c
On o.CustomerID = c.CustomerID

Print 'Total Orders : ' + Cast(@TotalOrders As Nvarchar);
Print 'TotalSales : ' + Cast(@TotalSales As Nvarchar);

-- Control Flow (IF Else)

Alter Procedure CustomersSummary @Country Nvarchar(50) = 'USA' As
Begin

Declare @TotalCustomers int, @AverageScore Float;
-- Preparing & Cleaning Up Data
If Exists(Select 1 From Sales.Customers Where Score Is Null And Country = @Country)
Begin
Print('Updating Null Scores to 0');
Update Sales.Customers
Set Score = 0
Where Score Is Null And Country = @Country;
End

Else
Begin
Print('No Null Scores found!')
End;

-- Generating Report
Select 
@TotalCustomers = Count(*),
@AverageScore = Avg(Score)
From Sales.Customers
Where Country = @Country;

Print 'Total Customers from ' + @Country + ': ' + Cast(@TotalCustomers as NVarchar);
Print 'Average Score from ' + @Country + ': ' + Cast(@AverageScore as Nvarchar);

Select 
Count(OrderID) as TotalOrders,
Sum(Sales) as TotalSales
From Sales.Orders o
Inner Join Sales.Customers c
On o.CustomerID = c.CustomerID
Where c.Country = @Country;
End

Exec CustomersSummary
Exec CustomersSummary @Country = 'Germany'

-- Error Handling (Try Catch)
-- Syntax: Begin Try ..SQL Statement.. End Try 
--		   Begin Catch ..SQL Statement.. End Catch

Alter Procedure CustomersSummary @Country Nvarchar(50) = 'USA' As
Begin
Begin Try

Declare @TotalCustomers int, @AverageScore Float;
-- Preparing & Cleaning Up Data
If Exists(Select 1 From Sales.Customers Where Score Is Null And Country = @Country)
Begin
Print('Updating Null Scores to 0');
Update Sales.Customers
Set Score = 0
Where Score Is Null And Country = @Country;
End

Else
Begin
Print('No Null Scores found!')
End;

-- Generating Report
Select 
@TotalCustomers = Count(*),
@AverageScore = Avg(Score)
From Sales.Customers
Where Country = @Country;

Print 'Total Customers from ' + @Country + ': ' + Cast(@TotalCustomers as NVarchar);
Print 'Average Score from ' + @Country + ': ' + Cast(@AverageScore as Nvarchar);

Select 
Count(OrderID) as TotalOrders,
Sum(Sales) as TotalSales,
1/0
From Sales.Orders o
Inner Join Sales.Customers c
On o.CustomerID = c.CustomerID
Where c.Country = @Country;
End Try
Begin Catch
Print('An error occured');
Print('Error Message: ' + Error_Message());
Print('Error Number: ' + Cast(Error_Number() as Nvarchar));
Print('Error Line: ' + Cast(Error_Line() as NVarchar));
Print('Error Procedure: ' + Error_Procedure());
End Catch
End

Exec CustomersSummary
Exec CustomersSummary @Country = 'Germany'

-- Styling : Enhance the readiblity

Alter Procedure CustomersSummary @Country Nvarchar(50) = 'USA' As
	Begin
		Begin Try
			Declare @TotalCustomers int, @AverageScore Float;
			-- ============================
			-- Preparing & Cleaning Up Data
			-- ============================
			If Exists(Select 1 From Sales.Customers Where Score Is Null And Country = @Country)
			Begin
				Print('Updating Null Scores to 0');
				Update Sales.Customers
				Set Score = 0
				Where Score Is Null And Country = @Country;
			End

			Else
			Begin
				Print('No Null Scores found!')
			End;

			-- =================
			-- Generating Report
			-- =================
			Select 
			@TotalCustomers = Count(*),
			@AverageScore = Avg(Score)
			From Sales.Customers
			Where Country = @Country;

			Print 'Total Customers from ' + @Country + ': ' + Cast(@TotalCustomers as NVarchar);
			Print 'Average Score from ' + @Country + ': ' + Cast(@AverageScore as Nvarchar);

			Select 
			Count(OrderID) as TotalOrders,
			Sum(Sales) as TotalSales
			From Sales.Orders o
			Inner Join Sales.Customers c
			On o.CustomerID = c.CustomerID
			Where c.Country = @Country;
		End Try
		Begin Catch
			-- ==============
			-- Error Handling
			-- ==============
			Print('An error occured');
			Print('Error Message: ' + Error_Message());
			Print('Error Number: ' + Cast(Error_Number() as Nvarchar));
			Print('Error Line: ' + Cast(Error_Line() as NVarchar));
			Print('Error Procedure: ' + Error_Procedure());
		End Catch
	End