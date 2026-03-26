select * from customers
-- Where Conditions 

-- 1) Comparison Operators

-- '=' checks if two values are equal

-- Retrieve all customers from Germany
Select * 
From customers
Where country = 'Germany'

-- '<> or !=' checks if two values are not equal

--Retrieve all customers who are not from Germany
Select *
From customers
Where country <> 'Germany'
-- Also can be
Select *
From customers
Where country != 'Germany'

-- '>' checks if a value is greater than another value

-- Retrieve all customers with a score greater than 500
Select * 
From customers
Where score > 500

-- '>=' checks if a value is greater than or equal to another value

-- Retrieve all customers with a score of 500 or more
Select *
From customers
Where score >= 500

-- '<' checks if a value is smaller than another value

-- Retrieve all customers with a score less than 500
Select * 
From customers
Where score < 500

-- '<=' checks if a value is smaller than or equal to another value

-- Retrieve all customers with a score of 500 or less
Select * 
From customers
Where score >= 500

----------------------------------------------------------------------------

-- 2) Logical Operators

-- And: All conditions must be true

-- Retrieve all customers from USA and have score greater than 500
Select *
From customers
Where country = 'USA' And score > 500

-- Or: At least one condition must be true

-- Retrieve all customers who are either from USA or have score greater than 500
Select *
From customers
Where country = 'USA' Or score > 500

-- Not: Excludes any matching values

-- Retrieve all customers who are not from USA
Select *
From customers
Where Not country = 'USA'

-- Retrieve all customers with score not less than 500
Select *
From customers
Where Not score < 500

------------------------------------------------------------------------------

-- 3) Range Operators

-- Between: Checks if a value is within a specific range (Inclusive)

-- Retrieve all customers whose score falls in the range between 100 and 500
Select *
From customers
Where score Between 100 And 500
--Another way of solving without using between
Select *
From customers
Where score >= 100 And score <= 500

------------------------------------------------------------------------------

-- 4) Membership Operators

-- In: Checks if a value exists in a list

-- Retrieve all customers from either germany or USA
Select *
From customers
Where country In ('Germany','USA')

-- Not In: Checks if a value doesn't exist in a list

-- Retrieve all customers who are not from either Germany or USA
Select *
From customers
Where country Not In ('Germany','USA')

------------------------------------------------------------------------------

-- Search Operators 

-- Like: Searches for a pattern in text
-- '%' Expects anything (0,1,many)
-- '_' Expects ceratin number of chars

-- Find all customers whose first name starts with M
Select *
From customers
Where first_name Like 'M%'

-- Find all customers whose first name ends with n
Select *
From customers
Where first_name Like '%n'

-- find al customers whose first name contains r
Select *
From customers
Where first_name Like '%r%'

-- Find all customers whose first name has r in the third position 
Select *
From customers
Where first_name Like '__r%'