-- Triggers
-- Special stored procedure (set of statements) that automatically runs in response to a specific event on a table or view.

/*
Trigger Types:
1) DML Triggers: Insert - Update - Delete 
2) DDL Triggers: Create - Alter - Drop 
3- LogOn Trigger
*/

/*
Syntax:
Create Trigger TriggerName On TableName
[After | Instead of] Insert, Update, Delete
Begin
	Sql Statement
	End
*/

-- Dml Triggers:
/* 
There are 2 DML Triggers:
1) After: Runs after an event
2) Instead Of: Runs during an event
*/

-- Use Case: Logging 
-- Step 1 Create Log Table 
Create Table Sales.EmployeeLogs 
(
	LogID Int Identity(1,1) Primary Key,
	EmployeeID Int,
	LogMessage Varchar(255),
	LogDate Date
)

-- Step 2: Create Trigger
-- Inserted: Virtual table that holds a copy of the rows that are being inserted into the target table
Create Trigger trg_AfterInsertEmployee On Sales.Employees
After Insert 
As 
Begin
	Insert Into Sales.EmployeeLogs(EmployeeID, LogMessage, LogDate)
	Select
		EmployeeID,
		'New Employee Added = ' + Cast(EmployeeID as Varchar),
		GETDATE()
	From inserted
End

-- Step 3: Insert New Data into Employees
Select * From Sales.EmployeeLogs

Insert Into Sales.Employees Values
(7, 'Sajy', 'Elmelegy', 'IT', '2002-10-29', 'M', 80000, 3)
