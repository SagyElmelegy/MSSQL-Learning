Create View Sales.V_Details_EU As 
(
Select 
o.OrderID,
o.OrderDate,
o.Sales,
o.Quantity,
p.Product,
p.Category,
p.Price,
Coalesce(c.FirstName,'') + ' ' + Coalesce(c.LastName,'') as CustomerName,
c.Country,
c.Score,
Coalesce(e.FirstName,'') + ' ' + Coalesce(e.LastName,'') as EmployeeName,
e.Gender,
e.BirthDate,
e.Department,
e.Salary
From Sales.Orders o
Left Join Sales.Products p
On o.ProductID = p.ProductID
Left Join Sales.Customers c
On o.CustomerID = c.CustomerID
Left Join Sales.Employees e
On o.SalesPersonID = e.EmployeeID
Where c.Country != 'USA'
)