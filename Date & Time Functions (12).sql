-- Date & Time Functions

-- Sources of Date data:
-- 1) Data from Tables
Select
OrderID,
OrderDate,
ShipDate,
CreationTime
From Sales.Orders;

-- 2) Hardcoded Dates
Select
OrderID,
CreationTime,
'2025-10-29'
From Sales.Orders;

-- 3) GetDate() Function: Teturns the current date and time at the moment when the query is executed
Select
OrderID,
CreationTime,
GETDATE() Today
From Sales.Orders;

-- Date Functions perform: Part Extraction - Calculations - Format - Validation

-- 1] Part Extraction: Day - Month - Year - Datepart - Datename - Datetrunc - Eomonth

-- Day(): Returns the day from a date
-- Month(): Returns the month from a date
-- Year(): Returns the year of a date
Select
'2025-10-29' Date,
Day('2025-10-29') Day,
Month('2025-10-29') Month,
Year('2025-10-29') Year;

Select
CreationTime Date,
Day(CreationTime) Day,
Month(CreationTime) Month,
Year(CreationTime) Year
From Sales.Orders;

-- Datepart(): Returns a specific part of a date as a number
-- Datepart(part, date)
Select
'2025-10-29' Date,
Datepart(Week,'2025-10-29') Week,
Datepart(Month,'2025-10-29') Month;

Select
CreationTime,
Datepart(yy,CreationTime) Year,
Datepart(qq,CreationTime) Quarter,
Datepart(mm,CreationTime) Month,
Datepart(ww,CreationTime) Week,
Datepart(WEEKDAY,CreationTime) WeekDay,
Datepart(dd,CreationTime) Day,
Datepart(hh,CreationTime) Hours,
Datepart(mm,CreationTime) Minutes,
Datepart(ss,CreationTime) Seconds
From Sales.Orders;

-- Datename(): Returns the name of a specific part of a date
-- Datename(part, date)
Select
'2025-10-29' Date,
DATENAME(mm,'2025-10-29') Month,
Datename(dd,'2025-10-29') Day;

Select 
CreationTime Date,
Datename(mm,CreationTime) Month,
Datename(WEEKDAY,CreationTime) WeekDay
From Sales.Orders;

-- Datetrunc(): Truncates the date to the specific part
-- Datetrunc(part, date)
Select 
'2025-10-29 18:55:45' Date,
Datetrunc(dd,'2025-10-29 18:55:45')

Select
CreationTime Date,
Datetrunc(hh,CreationTime) HourTrunc,
Datetrunc(dd,CreationTime) DayTrunc,
Datetrunc(mm,CreationTime) MonthTrunc
From Sales.Orders;

-- Show the number of sales done in each month
Select
DATETRUNC(mm,CreationTime),
Count(*)
From Sales.Orders
Group by DATETRUNC(mm,CreationTime)

-- Eomonth(): Returns the last day of a month "End of Month - EoMonth"
-- Eomonth(date)
Select
'2025-10-29' Date,
EOMONTH('2025-10-29')

Select
CreationTime Date,
EOMONTH(CreationTime) EndOfMonth,
Cast(DATETRUNC(mm,CreationTime) as date) StartOfMonth
From Sales.Orders

-- Task: How many orders were placed each year?
Select
Year(OrderDate),
COUNT(*) NumberOfOrders
From Sales.Orders
Group By Year(OrderDate)
-- Task: How many orders were placed each month?
Select
Datename(mm,OrderDate),
Count(*) NumberOfOrders
From Sales.Orders
Group By Datename(mm,OrderDate)
-- Task: Show all orders that were placed during February
Select
*
From Sales.Orders
Where Month(OrderDate) = 2

-- 2] Format & Casting: Format - Convert - Cast 
-- Formatting: Changing the format of a value from one to another. (Changing how the data looks like)
-- Casting: Changing the data type from one type to another.

-- Format(): Formats a date or time value.
-- Format(value,format [,culture]) --> Format(OrderDate, 'dd/MM/yyyy') culture is optional
--								   --> Format(OrderDate, 'dd/MM/yyyy', 'ja-JP')
Select 
OrderID
OrderDate,
Format(OrderDate, 'dd') dd,
Format(OrderDate, 'ddd') ddd,
Format(OrderDate, 'dddd') dddd,
Format(OrderDate, 'MM') MM,
Format(OrderDate, 'MMM') MMM,
Format(OrderDate, 'MMMM') MMMM,
FORMAT(OrderDate, 'dd/MM/yyyy') Euro_Format,
Format(OrderDate, 'MM/dd/yyyy') USA_Format
From Sales.Orders;

-- Task: Show CreationTime using the following format: Day Wed Jan Q1 2025 12:34:56 PM
Select
OrderID,
CreationTime,
'Day ' + FORMAT(CreationTime,'ddd ') + FORMAT(CreationTime,'MMM ')
+ 'Q' + DATENAME(QUARTER,CreationTime) + FORMAT(CreationTime,' yyyy ') + FORMAT(CreationTime,'hh:')
+ FORMAT(CreationTime,'mm:') + FORMAT(CreationTime,'ss ') + FORMAT(CreationTime,'tt') as CustomFormat
From Sales.Orders

-- Use Case: Data Aggregation using Format
Select
FORMAT(OrderDate,'MMM yy'),
COUNT(*)
From Sales.Orders
Group By FORMAT(OrderDate,'MMM yy')

-- Convert(): Converts a date or time value to a different data type & formats the value.
-- Convert(data_type, value [,style]) --> Convert(INT, '123') Style is optional
--									  --> Convert(VarChar, OrderDate, '34')
Select 
CONVERT(int,'123') as [Str to Int],
CONVERT(date,'2025-10-20') as [Str to Date],
CONVERT(date,CreationTime) as [DateTime to Date],
CONVERT(varchar,CreationTime,32) as [USA Std. Style:32],
CONVERT(varchar,CreationTime,34) as [Euro Std. Style:34]
From Sales.Orders

-- Cast(): Converts a value to a specific data type
-- Cast(value as data_type) --> Cast('123' as int)
Select 
CAST('1234' as int) [Str to Int],
CAST(1234 as varchar) [Int to Str],
CAST('2025-10-29' as date) [Str to Date],
CAST('2025-10-29' as datetime2) [Str to DateTime],
CAST(CreationTime as date) [DateTime to Date]
From Sales.Orders

-- 3] Calculations: Dateadd - Datediff 
-- DateAdd(): Adds or subtracts a specific time interval to/from a date
-- Dateadd(part, interval, date) --> Dateadd(year, 2, OrderDate)
Select 
OrderID,
OrderDate,
DATEADD(YEAR,2,OrderDate) [Two Years Later],
DATEADD(MONTH,2,OrderDate) [Two Months Later],
DATEADD(DAY,2,OrderDate) [Two Days Later],
DATEADD(YEAR,-2,OrderDate) [Two Years Before],
DATEADD(MONTH,-2,OrderDate) [Two Months Before],
DATEADD(DAY,-2,OrderDate) [Two Days Before]
from Sales.Orders

-- DateDiff(): Finds the difference between two dates.
-- Datediff(part, start_date, end_date) --> DateDiff(year, OrderDate, ShipDate)
Select
OrderID,
OrderDate,
ShipDate,
DATEDIFF(DAY, OrderDate, ShipDate)
From Sales.Orders

-- Task: Get the age of the employees 
Select 
EmployeeID,
FirstName,
BirthDate,
DATEDIFF(YEAR, BirthDate, GETDATE()) Age
from Sales.Employees

-- Task: Find the average shipping duration in days for each month
Select
Month(OrderDate),
Avg(DATEDIFF(DAY,OrderDate,ShipDate)) AvgShippingDuration
From Sales.Orders
Group By Month(OrderDate)

--Task: (Time Gap Analysis) Find the number of days between each order and the previous order
-- Lag(): Access a value from the previous row
Select
OrderID,
OrderDate CurrentOrderDate,
LAG(OrderDate) Over (Order By OrderDate) PreviousOrderDate,
DATEDIFF(DAY,LAG(OrderDate) Over (Order By OrderDate),OrderDate)
From Sales.Orders

-- 4] Validation: Isdate
-- Isdate(): Checks if a value is a date.
--		   : Returns 1 if the string value is a valid date and 0 if it isn't a valid date.
-- Isdate(value) --> IsDate('2025-08-29') 
Select 
ISDATE('123') DateCheck1,
ISDATE('2025-10-29') DateCheck2,
ISDATE('2025') DateCheck3,
ISDATE('29-10-2025') DateCheck4,
ISDATE('10');

Select
	--Cast(OrderDate as Date) OrderDate
	OrderDate,
	Isdate(OrderDate),
	Case When Isdate(OrderDate) = 1 Then Cast(OrderDate as Date)
		 Else '9999-01-01'
	End NewOrderDate
From
(
Select '2025-10-29' as OrderDate Union
Select '2025-11-21' Union
Select '2025-11-23' Union
Select '2025-11'
)t
Where Isdate(OrderDate) = 0