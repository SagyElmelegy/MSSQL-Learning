-- DDL Data Definition Language: Create - Alter - Drop

-- Create: Used to create tables

-- Create a new table called persons with the stated columns
Create Table Persons(
id Int Not Null,
person_name Varchar(50) Not Null,
birth_date Date,
phone Varchar(50) Not Null,
Constraint pk_persons Primary Key (id)
)

Select *
From persons

-- Alter: Used to edit the data in the table

-- Add a new column called email to the persons table
Alter Table Persons
Add email Varchar(50) not null

Select * From Persons

-- Remove the phone column from the table
Alter Table Persons
Drop Column phone

Select * From persons

-- Drop: USed to remove a table from the database

-- Delete the table persons from the database
Drop Table persons