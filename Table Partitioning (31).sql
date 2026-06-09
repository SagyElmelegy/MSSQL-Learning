-- Table Partitioning

-- SQL Partitioning: Division of big tables into small partitions while still being treated as a single logical table.
/*
Partitions allows:
1) Parallel Processing reducing the overall execution time
2) Scalability
3) Better indexing.
*/

-- Building Partitions
-- 1] Creating Partition Function
-- Partition Function: Defining the logic on how to divide the data into partitions based on the Partition Key (Column, Region, ..)
Create partition Function PartitionbyYear (Date)
As Range Left For Values ('2023-12-31','2024-12-31','2025-12-31')

-- Query with the list all existing Partition Function
Select
name,
function_id,
type,
type_desc,
boundary_value_on_right
From sys.partition_functions

-- 2] Creating Filegroups
-- Filegroup: Logical container of one or more data files to help organize partitions.
Alter Database SalesDB Add Filegroup FG_2023;
Alter Database SalesDB Add Filegroup FG_2024;
Alter Database SalesDB Add Filegroup FG_2025;
Alter Database SalesDB Add Filegroup FG_2026;

-- To drop a Filegroup
Alter Database SalesDB Remove Filegroup FG_2023;

-- Query with the list of all existing Filegroups
Select
*
From sys.filegroups
Where type = 'FG'
-- Primary Filegroup: Default filegroup where all the objects of the database is stored.

-- 3] Creating Data Files
-- Data Files: Contain the actual data and stored physically in the database.
Alter Database SalesDB Add File
(
Name = P_2023, -- Logical Name
FileName = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\P_2023.ndf'
)
To Filegroup FG_2023;

Alter Database SalesDB Add File
(
Name = P_2024, -- Logical Name
FileName = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\P_2024.ndf'
)
To Filegroup FG_2024;

Alter Database SalesDB Add File
(
Name = P_2025, -- Logical Name
FileName = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\P_2025.ndf'
)
To Filegroup FG_2025;

Alter Database SalesDB Add File
(
Name = P_2026, -- Logical Name
FileName = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\P_2026.ndf'
)
To Filegroup FG_2026;

-- Checking the Metadata
Select
fg.name As FileGroupName,
mf.name As LogicalFileName,
mf.physical_name As PhysicalFilePath,
mf.size / 128 As SizeinMB
From sys.filegroups fg
Join sys.master_files mf
On fg.data_space_id = mf.data_space_id
Where mf.database_id = DB_ID('SalesDB');

-- 4] Creating Partition Scheme
-- Partition Scheme: Maps the partitions to their filegroups.
Create Partition Scheme SchemePartitionByYear
As Partition PartitionByYear
To (FG_2023, FG_2024, FG_2025, FG_2026)
-- Note: Sort the filegroups according to the result of the Function's Partitions.
-- Note: 3 Boundaries = 4 Partitions = 4 FileGroups, The order is important

-- Query the list of all Partition Scheme
Select 
ps.name As PartitionSchemeName,
pf.name As PartitionFunctionName,
ds.destination_id As PartitionNumber,
fg.name As FilegroupName
From sys.partition_schemes ps
Join sys.partition_functions pf On ps.function_id = pf.function_id
Join sys.destination_data_spaces ds On ps.data_space_id = ds.partition_scheme_id
Join sys.filegroups fg On ds.data_space_id = fg.data_space_id;

-- 5] Creating the Partitioned Table
Create Table Sales.Orders_Partitioned
(
OrderID int,
OrderDate date,
Sales int
) 
On SchemePartitionByYear (OrderDate)

--6] Inserting Data Into the Partitioned Table 
Insert Into Sales.Orders_Partitioned Values (1, '2023-05-15', 100);
Insert Into Sales.Orders_Partitioned Values (2, '2024-05-15', 150);
Insert Into Sales.Orders_Partitioned Values (3, '2025-05-15', 200);
Insert Into Sales.Orders_Partitioned Values (4, '2026-05-15', 250);

Select * From Sales.Orders_Partitioned

-- To check which partitioned the data is stored
Select 
p.partition_number As PartitionNumber,
fg.name As PartitionFileGroup,
p.rows As NumberofRows
From sys.partitions p
Join sys.destination_data_spaces dds On p.partition_number = dds.destination_id
Join sys.filegroups fg On dds.data_space_id = fg.data_space_id
Where OBJECT_NAME(p.object_id) = 'Orders_Partitioned'

-- To Check the performance of the partition
Select 
*
Into Sales.Orders_NoPartition
From Sales.Orders_Partitioned;

Select 
*
From Sales.Orders_Partitioned
Where OrderDate = '2026-05-15';

Select 
*
From Sales.Orders_NoPartition
Where OrderDate = '2026-05-15';

Select 
*
From Sales.Orders_Partitioned
Where OrderDate In ('2026-05-15', '2025-05-15');

Select 
*
From Sales.Orders_NoPartition
Where OrderDate In ('2026-05-15', '2025-05-15');
