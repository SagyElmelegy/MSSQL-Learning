-- String Functions: Manipulation - Calculation - String Extraction

-- 1] Manipulation: Concat - Upper - Lower - Trim - Replace

-- Concat: Combines multiple strings into one
-- Concatenate first name and country into one column
Select 
first_name,
country,
CONCAT(first_name,' ',country)
From customers

-- Upper: Converts all characters to uppercase
-- Lower: Converts all characters to lowercase
-- Convert the customers' first names into lowercase
Select 
first_name,
Lower(first_name)
from customers
-- Convert the customers' first names into uppercase
Select 
first_name,
Upper(first_name)
From customers

-- Trim: Removes the leading and trailing spaces
-- Find customers wwhose first name contains leading or trailing spaces
Select 
first_name
From customers
Where first_name != TRIM(first_name)
-- Another way
Select 
first_name,
Len(first_name),
Len(Trim(first_name)),
Len(first_name) - Len(Trim(first_name)) Flag 
From customers

-- Replace: Replaces specific character with a new character or remove it
--Remove dashes from a phone number
-- Replace(value, char to be replaced, the replacement)
Select 
'123-456-789',
REPLACE('123-456-789','-','')
--Replace File Extension from .txt to .csv
Select 
'Report.txt',
Replace('Report.txt','txt','csv')

-- 2] Calculation: Len

-- Len: Counts how many characters in the string
Select 
'Sagy',
Len('Sagy')
-- Calculate the length of each customer's first name
Select 
first_name,
Len(trim(first_name))
From customers

-- 3] String Extraction: Left - Right - Substring

-- Left: Extracts specific number of characters from the start
-- Right: Extracts specific number of characters from the end
Select
'Sagy',
Left('Sagy',2);

Select
'Sagy',
Right('Sagy',2)

-- Retrieve the first two characters of each first name
Select 
first_name,
Left(Trim(first_name),2)
From customers

-- Retrieve the last two characters of each first name
Select 
first_name,
Right(Trim(first_name),2)
From customers

-- Substring: Extracts a part of string at a specified position
-- Substring(Value,Start,Length)
Select
'Mohamed',
Substring('Mohamed',2,2);
-- To start from a starting position to the end of the string
Select
'Mohamed',
Substring('Mohamed',3,len('Mohamed'));
-- Retrieve a list of customers' first names removing the first character
Select
first_name,
Substring(Trim(first_name),2,len(first_name))
From customers
