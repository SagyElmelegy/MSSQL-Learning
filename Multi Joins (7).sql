-- Multi-Table Join

-- Using SalesDB, Retrieve a list of all orders along with the realted customer, product and employee details>
Use SalesDB;
Select *
From Sales.Customers;

Select *
From Sales.Orders;

Select *
From Sales.Employees;

Select *
From Sales.Products

Select o.OrderID, o.Sales, c.FirstName + ' ' + c.LastName as CustomerName, p.Product as ProductName, Quantity, p.Price, e.FirstName + ' ' + e.LastName as SalespersonName
From Sales.Orders as o
Left Join Sales.Customers as c
On o.CustomerID = c.CustomerID
Left Join Sales.Employees as e
On o.SalesPersonID = e.EmployeeID 
Left Join Sales.Products as p
On o.ProductID = p.ProductID
