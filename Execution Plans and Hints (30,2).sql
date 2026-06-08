Select 
* 
From FactResellerSales

-- Index Scan: Scans all data in an index to find matching rows 

-- Heap vs Clustered Index 
-- Clustered Index Execution Plan
Select 
*
From FactResellerSales
Order By SalesOrderNumber

-- NonClustered Index
Select 
*
From FactResellerSales
Where CarrierTrackingNumber = '4911-403C-98' 

Create NonClustered Index Idx_FactReseller_CTA On FactResellerSales (CarrierTrackingNumber)

-- Index Seek: A targeted search within an index retrieving only specific rows.

-- To get rid of the Key Lookup just choose a single column to query

-- Rowstore Vs Columnstore
Select 
p.EnglishProductName As ProductName,
Sum(s.SalesAmount) As TotalSales
From FactResellerSales s
Join DimProduct p
On p.ProductKey = s.ProductKey
Group By p.EnglishProductName