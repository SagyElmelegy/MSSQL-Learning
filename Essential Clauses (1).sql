	-- Choose the database you gonna work on
	Use MyDatabase

	-- Retrieve all customers data
	Select *
	From customers

	-- Retrieve all orders data
	Select *
	From orders

	-- Retrieve each customer's name, country and score
	Select 
	first_name,
	country,
	score
	From customers

	-- WHERE clause : Used to filter data
	
	-- Retrieve customers with a score not equal to 0
	Select *
	From customers
	Where score != 0
	-- Also can be
	Select *
	From customers
	Where not score = 0

	-- Retrieve customers from Germany
	Select 
	first_name,
	country
	From customers
	Where country = 'Germany'

	-- Order By: Used to sort data
	
	-- Retrieve all customers and sort the results by the highest score
	Select *
	From customers
	Order By score Desc

	-- Retrieve all customers and sort the results by the lowest score
	Select *
	From customers
	Order By score Asc
	-- Also can be
	Select *
	From customers
	Order By score
	-- It is sorted ascendingly by default

	-- Retrieve all customers and sort the results by the country and then by the highest score
	Select *
	From customers
	Order By country Asc, score Desc 

	-- Group By: Used to aggregate data (Combining the 'rows' with the same value)

	-- Find the total score for each country
	Select 
	country,
	Sum(score) as TotalScore
	From customers
	Group By country
	Order By Sum(score)

	-- The result of Group By is determined by the 'unique' values of the grouped columns

	-- Find the total score and total number of customers for each country
	Select
	country,
	Sum(score) as TotalScore,
	Count(id) as NumberofCustomers
	From customers
	Group by country

	-- Having: Used to filter the aggregated data
	-- Where clause filters 'before' aggregation while Having clause filters 'after' aggregation
	
	/*
	Find the average score for each country considering only the customers with a score 
	not equal to 0 and return only those countries with an average score greater than 430
	*/
	Select 
	country,
	Avg(score)
	From customers
	Where score != 0
	Group By country
	Having Avg(score) > 430

	-- Distinct: Used to remove duplicates

	-- Return unique list of all countries
	Select Distinct 
	country
	From customers

	-- Top: Used to limit data (restict the number of rows returned)

	-- Retieve only 3 customers
	Select Top 3 *
	From customers

	-- Retrieve the top 3 customers with the highest scores
	Select Top 3 *
	From customers
	Order By score Desc
	-- Also can be
	Select *
	From customers
	Where score >= 500
	Order By score Desc

	-- Retrieve the lowest 2 customers based on the score
	Select Top 2 *
	From customers
	Order By score Asc
	-- Also can be
	Select *
	From customers
	Where score < 500
	Order By score Asc

	-- Get the two most recent orders
	Select Top 2 *
	From orders
	Order By order_date Desc