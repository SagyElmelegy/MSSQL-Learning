Create View Sales.V_Monthly_Summary As 
(
Select
DATETRUNC(month,OrderDate) OrderMonth,
Sum(Sales) TotalSales,
Count(OrderID) as TotalOrders,
Sum(Quantity) as TotalQuantities
From Sales.Orders
Group By DATETRUNC(month,OrderDate)
)

-- To edit the content of the view and replace the logic
If OBJECT_ID ('Sales.V_Monthly_Summary','V') Is Not Null
	Drop View Sales.V_Monthly_Summary
Go
Create View Sales.V_Monthly_Summary As 
(
Select
DATETRUNC(month,OrderDate) OrderMonth,
Sum(Sales) TotalSales,
Count(OrderID) as TotalOrders
From Sales.Orders
Group By DATETRUNC(month,OrderDate)
)