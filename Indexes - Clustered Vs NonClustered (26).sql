-- Indexes It stores key values (Pointers)
-- It is a data structure that provides quick access to data, optimizing the speed of the queries 

/*
 Index Types: Structure - Storage - Functions 
 Structure: Clustered Index - Non-Clustered Index
 Storage: Rowstore Index - Columnstore Index
 Functions: Unique Index - Filtered Index 
 Some Indexes are better for reading, others are better for performance
 */

-- 1] Structure 
-- Page: The smallest unit of data storage in database (8kb), it stores everything (Data, Metadata, Indexes, etc)
-- Page Types: Data Page - Index Page
/*
Heap Table: It is a table without clustered index (Data is stored randomly in the pages without any order)
		  : Good write but bad read 
Full Table Scan: It is scanning the entire table page by page and row by row searching for data 
*/

-- 1) Clustered Index: It arranges the data in the pages from the lowest ot the highest
-- Note: Reading a data page is much slower than reading an index page.
/*
Balance Tree (B-Tree): Hierarchical structure storing data at leaves to help quickly locate data.
It starts from the root node themn to the intermediate nodes down until the leaf nodes
1- Leaf nodes: This is where the data is stored
2- Index Page: It stores key values (Pointers) to another page.
		     : It doesn't store the actual rows.
		     : They reside at the intermediate nodes.
3- Root Node: It points to another index page in the intermediate nodes.
*/

-- 2) Non-Clustered Index: It will not reorganize or change anything on the data page, it creates a pointer for each ID.
-- This pointer consists of (ID -> Index Page : Offset of the ID) ex: 1 -> 1 : 102 : 96
/*
1- Base Data Pages: This is where the index pages containing the row identifier reside (pointers to the actual data)
2- Leaf nodes: Points towards certain data pages in the base.
3- Intermediate nodes: Do the same as in clustered index.
4- Root Node: Does the same as root node in the clustered index.
*/

-- Clustered Index Vs Non-Clustered Index
/* 
Clustered: Root Node (Index Page) -> Intermediate Nodes (Index Pages) -> Leaf Nodes (Data Pages)
		 : It physically sorts and arranges the data in the data pages
		 : One index can be created per table
		 : Faster read performance but slower write performance due to potential data row reordering
		 : More storage-efficient
		 : Better used with unique columns, not frequently modified columns, improving range query performance

Non-Clustered: Root Node (Index Page) -> Intermediate Nodes (Index Pages) -> Leaf Nodes (Index Pages) -> Base Data Pages
             : Base Data Pages are not part of the B-Tree
			 : Separate structure with pointers to the data
			 : Multiple indexes can be created per table
			 : Slower read performance but faster write performance since physical data order is not affected
			 : Requires additional storage space
			 : Better used with columns frequently used in search conditions and joins, exact match queries
*/

-- Syntax: Create [Clustered | Nonclustered] Index index_name On table_name (col1, col2, ..)
-- Default is Nonclustered
/*
ex: Create Clustered Index Ix_Customers_Id On Customers (ID)
  : Create Nonclustered Index Ix_Customers_City On Customers (City)
  : Create Index Ix_Customers_Name On Customers (LastName Asc, FirstName Desc)
*/
-- A PK automatically creates a clustered index by default.

-- Loading Customers table into a new table 
Select
*
Into Sales.DBCustomers
From Sales.Customers

-- Creating a clustered index based on ID
Create Clustered Index Idx_DBCustomers_CustomerID On Sales.DBCustomers (CustomerID)
-- Creating a clustered index based on first name
Drop Index Idx_DBCustomers_CustomerID On Sales.DBCustomers 
Create Clustered Index Idx_DBCustomers_CustomerFN On Sales.DBCustomers (FirstName)
-- Creating a non-clustered index based on last name
Create Nonclustered Index Idx_DBCustomers_CustomerLN On Sales.DbCustomers (LastName)

-- Composite Index: It is an index that has multiple columns in the same index 
Select 
*
From Sales.DBCustomers
Where Country = 'USA' And Score > 500

Create Index Idx_DBCustomers_CountryScore On Sales.DBCustomers (Country , Score)

-- Leftmost Prefix Rule: Index works only if the query filters start from the first column in the index and follow its order
