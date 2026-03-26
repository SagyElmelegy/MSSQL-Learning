-- DML Data Manipulation Language: Insert - Update - Delete

-- Insert: Used to add data to a table

-- 1) Manual Entry
Select *
From customers

Insert Into customers (id,first_name,country,score)
Values
(9, 'Andreas', 'Germany',Null)

-- 2) Insert using Select
-- Copy data from customers table into persons table
Create Table persons(
id Int Not Null,
person_name Varchar(50) Not Null,
birth_date Date Null,
phone Varchar(15) Not Null
Constraint pk_persons Primary Key (id)
)

Insert into persons(id, person_name, birth_date, phone)
Select 
id,
first_name,
Null,
'Unkown'
From customers

select * from persons

-- Update: Edit the content of the column

-- Change the score of customer of id 6 to 0
Update customers
Set score = 0
Where id = 6

/*
Change the score of the customer with id 8 to 0 
and the country of customer with id 7 to USA 
*/
Update customers
Set score = 0 
Where id = 9

Update customers
Set country = 'USA'
Where id = 7

select * from customers

-- Changinge the score and country of customer with id 10
Insert Into customers (id,first_name)
Values(10,'Sarah')

Update customers
Set 
score = 0 ,
country = 'USA'
Where id = 10

-- Update all customers with a null score to be 0
Update customers 
Set score = 0
where score is null

-- Delete: Used to delete certain rows in a table 

-- Delete all the customers with an ID greater than 5
Delete From customers
Where id > 5

select * from customers 

-- Delete all data from persons table
-- Truncate: Clears the whole table at once without checking any logs thus it is faster than delete
Truncate Table persons

select * from persons