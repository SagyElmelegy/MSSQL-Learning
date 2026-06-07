-- Indexes - Unique Index & Filtered Index 

/*
1] Unique Index: Ensures that there are no duplicate values exist in a specific column
Benefits: 1) Enforce uniqueness
		  2) Slightly increase query performance
Performance: Writing to an unique index is slower than to a non-unique one.
		   : Reading from an unique index is faster than from a non-unique one.
*/

-- Syntax: Create Unique [Clustered | Nonclustered] [Columnstore] Index index_name On table_name (col1, col2, ...)
-- Ex: Create Unique Index Idx_Customers_Email On Customers (Email)
Use SalesDB

Select 
*
From Sales.Products

Create Unique Nonclustered index Idx_Products_Product On Sales.Products (Product)
-- Now you can't add duplicate value to this column

/*
2] Filtered Index: An index that includes only rows meeting specific conditions
Benefits: 1) Targeted Optimization
		  2) Reduce Storage -> Less data in the index
*/

-- Syntax: 
-- Create [Unique] [Nonclustered] Index index_name On table_name (col1, col2, ..) Where [condition]
-- Rules: 1) You can't create a filtered index on a clustered index
--		  2) You can't create a filtered index on a columnstore index

Select 
*
From Sales.Customers
Where Country = 'USA'

Create Nonclustered Index Idx_Customers_Country 
On Sales.Customers (Country)  
Where Country = 'USA'

Drop Index [Idx_Customers_Country] On Sales.Customers