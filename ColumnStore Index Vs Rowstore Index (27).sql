-- Indexes - Rowstore Vs Columnstore

-- 1] Columnstore
/*
Process:-
Step 1: The dataset is divided into row groups
Step 2: Column segmentation occurs (Dividing each divided dataset into separate columns)
Step 3: Data compression 
Step 4: Storing the data in data pages called LOB pages (Large Object Page)
*/
-- LOB Page: It contains segment header which includes: Segment ID - Rowgroup ID - Dictionary ID - Data Stream
-- Dictionary ID points to the dictionary page which have the mapping between the original values and smaller values
-- Columnstore Index can represented as both Clustered colunstore index and non-clustered columnstore index

/*
Columnstore Vs Rowstore
1- ColumnStore: Organizes and store data column by column
			  : High efficiency with compression
			  : Fast read performance and Slow write performance
			  : Higher I/O efficiency since it retrieves specific columns
			  : It is better for OLAP (Analytical Systems like Data warehouse, reporting and analytics)
			  : Used in Big data analytics, Scanning of large datasets, Fast aggregation
2- RowStore: Organizes and stores data row by row
		   : Less efficiency win storage
		   : Fair speed for read and write operations
		   : Less I/O efficiency since it retrieves all columns
		   : It is better for OLTP (Transactional Systems like banking and financial systems)
		   : Used in High-Frequency transacation applications, Quick access to complete records
*/

-- Syntax: Create [Clustered | Nonclustered] Columnstore Index index_name On table_name (col1, col2, ..)
-- Rowstore is the default
/*
Ex:
Rowstore: Create Nonclustered Index Idx_Customers_Country On Customers (Country)
		: Create Clustered Index Idx_Customers_ID On Customers (ID)
Columnstore: Create Nonclustered Columnstore Index Idx_Customers_Country On Customers (Country)
		   : Create Clustered Columnstore Index Idx_Customers On Customers 
Note: You can't specify columns in Clustered Index Columnstore.
    : Only one columnstore can be created for each table.
*/

Drop Index [Idx_DBCustomers_CustomerID] On Sales.DBCustomers
Create Clustered Columnstore Index Idx_DBCustomers_CS On Sales.DBCustomers

-- To Create another columnstore you have to drop the first columnstore 
Drop Index [Idx_DBCustomers_CS] On Sales.DBCustomers
Create NonClustered Columnstore Index Idx_DBCustomers_CS_FirstName On Sales.DBCustomers (Firstname)

-- To showcase the fact that the columnstore compressed the data and uses less storage than Rowstore
-- Heap Vs Rowstore Vs Columnstore
Use AdventureWorksDW2022
-- Heap
Select
*
Into FactInternetSales_HP
From FactInternetSales

-- Rowstore
Select
*
Into FactInternetSales_RS
From FactInternetSales

Create Clustered Index Idx_FactInternetSales_RS_PK 
On FactInternetSales_RS 
(SalesOrderNumber, SalesOrderLineNumber)

-- Columnstore
Select
*
Into FactInternetSales_CS
From FactInternetSales

Create Clustered Columnstore Index Idx_FactInternetSales_CS_PK 
On FactInternetSales_CS 

-- In Conclusion: Storage Efficiency -> 1) Columnstore Index  2) Heap Table  3) Rowstore Clustered Index