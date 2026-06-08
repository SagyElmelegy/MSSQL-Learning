-- Index Maintenance

/*
Index Management:
1) Monitor Index Usage
2) Monitor Missing Indexes
3) Monitor Duplicate Indexes 
4) Update Statistics
5) Monitor Fragments
*/

-- Listing all indexes of a specific table
sp_helpindex 'Sales.DBCustomers'

-- 1] Monitoring Index Usage
-- 'Sys' System Schema: Contains metadata about database tables, views, indexes, etc..
Select 
tbl.name as TableName,
idx.name as IndexName,
idx.type_desc as IndexType,
idx.is_primary_key as IsPrimaryKey,
idx.is_unique as IsUnique,
idx.is_disabled as IsDisabled,
s.user_seeks User_Seek,
s.user_scans User_Scan,
s.user_lookups User_Lookups,
s.user_updates User_Updates,
Coalesce(s.last_user_seek,s.last_user_scan) LastUpdate
From sys.indexes idx 
Join sys.tables tbl
On idx.object_id = tbl.object_id
Left Join sys.dm_db_index_usage_stats s
On s.object_id = idx.object_id
And s.index_id = idx.index_id
Order By tbl.name, idx.name

-- Dynamic Management View (DMV): Provides real-time insights into database performance and system health
Select * From sys.dm_db_index_usage_stats

-- 2] Monitoring Missing Indexes 
Select 
fs.SalesOrderNumber,
dp.EnglishProductName,
dp.Color
From FactInternetSales fs
Inner Join DimProduct dp
On fs.ProductKey = dp.ProductKey
Where dp.Color = 'Black'
And fs.OrderDateKey Between 20101229 And 20101231

Select 
*
From sys.dm_db_missing_index_details
-- Evaluate the recommendations before creating any index first

-- 3] Monitor Duplicate Indexes 
Select 
tbl.name As TableName,
col.name As ColumnName,
idx.name As IndexName,
idx.type_desc As IndexType,
Count(*) Over (Partition By tbl.name, col.name) ColumnCount
From sys.indexes idx
Join sys.tables tbl 
On idx.object_id = tbl.object_id
Join sys.index_columns ic
On idx.object_id = ic.object_id And idx.index_id = ic.index_id
Join sys.columns col 
On ic.object_id = col.object_id And ic.column_id = col.column_id
Order By ColumnCount Desc

-- 4] Update Statistics
Select
SCHEMA_NAME(t.schema_id) as SchemaName,
t.name As TableName,
s.name As StatisticsName,
sp.last_updated As LastUpdate,
DateDiff(day, sp.last_updated, GETDATE()) As LastUpdateDay,
sp.rows As 'Rows',
sp.modification_counter As ModificationsSinceTheLastUpdate
From sys.stats As s
Join sys.tables As t
On s.object_id = t.object_id
Cross Apply sys.dm_db_stats_properties(s.object_id,s.stats_id) as sp
Order By sp.modification_counter Desc;

-- To update a certain statistic
Update Statistics Sales.DBCustomers _WA_Sys_00000001_5DCAEF64
-- To Update all statistics of a certain table
Update Statistics Sales.DBCustomers
-- To update the statistics of the whole database 
Exec sp_updatestats

/*
Updating Statistics:
1) Weekly job to update statistics preferably on weekends
2) After migrating data 
*/

-- 5] Monitoring Fragmentation
-- Fragmentation: Unused spaces in data pages or data pages are out of order.
/*
Fragmentation Methods:
1) Reorganize:
- Defragment leaf nodes to keep them sorted 
- 'Light' Operation
2) Rebuild: 
- Recreates index from scratch
- 'Heavy' Operation
*/

-- Checking if there any issue with the fragmentation of the indexes 
Select 
*
From sys.dm_db_index_physical_stats (DB_ID(), Null, Null, Null, 'Limited')

-- Avg_Fragmentation_in_percent: Indicates how out-of-order pages are within the index
-- 0% means there is no fragmentation which is perfect
-- 100% means index is completely fragmented (out of order)

Select 
tbl.name As TableName,
idx.name As IndexName,
s.avg_fragmentation_in_percent,
s.page_count
From sys.dm_db_index_physical_stats (DB_ID(), Null, Null, Null, 'Limited') As s
Inner Join sys.tables tbl
On s.object_id = tbl.object_id
Inner Join sys.indexes as idx
On idx.object_id = s.object_id And idx.index_id = s.index_id
Order By s.avg_fragmentation_in_percent

/*
When to Defragment?
<10% --> No Action needed
10-30% --> Reorganize 
>30% --> Rebuild 
*/

-- Reorganizing an Index
Alter Index Idx_Customers_Country On Sales.Customers Reorganize 
-- Rebuilding an Index
Alter Index Idx_DBCustomers_CountryScore On Sales.DBCustomers Rebuild 
