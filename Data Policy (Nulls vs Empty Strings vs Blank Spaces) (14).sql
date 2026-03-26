-- Data Policies: Set of rules that define how data should be handled.

-- Data Policy 1: Only use nulls and empty strings but avoid using blank spaces.
With Orders as (
Select 1 Id, 'A' Category Union
Select 2, Null Union
Select 3, '' Union
Select 4, ' ' 
)
Select 
*,
DATALENGTH(Category) BeforeTrim,
Trim(Category) as Trimmed,
DATALENGTH(Trim(Category)) as Policy1
From Orders;

-- Data Policy 2: Only use nullsa and avoid using empty strings and blank spaces
-- Handling with empty strings and blank spaces 
With Orders as (
Select 1 Id, 'A' Category Union
Select 2, Null Union
Select 3, '' Union
Select 4, ' ' 
)
Select 
*,
Trim(Category) as Trimmed,
NullIf(Trim(Category),'') as Policy2
From Orders;

-- Data Policy 3: Use the default value 'unkown' and avoid using nulls, empty strings and blank spaces
With Orders as (
Select 1 Id, 'A' Category Union
Select 2, Null Union
Select 3, '' Union
Select 4, ' ' 
)
Select 
*,
Trim(Category) as Policy1,
NullIf(Trim(Category),'') as Policy2,
Coalesce(NullIf(Trim(Category),''),'Unkown') as Policy3
From Orders;

-- Use either policy 2 or 3 depends on the project constraints and rules

-- Data Policy Use Case:
/* 1- Replacing empty strings and blanks with Null during
	  data preparation before inserting into a database to
	  optimize storage and performance. (For Databases)
   2- Replacing empty strings, blanks and Null with default value
	  during data preparation before using it in reporting to
	  improve readibility and reduce confusion. (For Users)*/
