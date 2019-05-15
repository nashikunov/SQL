use [airport_task]
--Запрос№1. Самые 'популярные' самолеты в аэропорте
GO
SELECT model.[Name], SUM([count]) [Visiting amount]
FROM (SELECT Aircraft_id, Count(Aircraft_id) [count]
	FROM Flight
	Group By Aircraft_id) plane
JOIN Aircraft air
ON air.Aircraft_id = plane.Aircraft_id
JOIN Model model
ON model.Model_id = air.Model_id
GROUP BY model.[Name]
ORDER BY [Visiting amount] DESC

--Запрос №2
go
EXECUTE [dbo].Proc_Table '15.12.2018', 'a'


--Запрос №4
go
SELECT city.[Name], COUNT(city.City_id) [Amount]
FROM Flight flight
JOIN [Path] p ON p.Path_id = flight.Path_id
JOIN Airport airport
ON p.Airport_id = airport.Airport_id
JOIN City city
ON city.City_id = airport.City_id
GROUP BY city.[Name]
ORDER BY Amount DESC

GO
SELECT m.[Name], SUM(f.Passangers_amount) AS [Total amount of passengers]
FROM Flight f
JOIN Aircraft a ON a.Aircraft_id = f.Aircraft_id
JOIN Model m ON m.Model_id = a.Model_id
GROUP BY m.[Name]
ORDER BY [Total amount of passengers] DESC


GO 
SELECT air.[Name], air.Code, COUNT(*) AS [Flight amount], 
SUM(f.Passangers_amount) AS [Total passengers amount], AVG(f.Passangers_amount) AS [Average passengers amount]
FROM Flight f
JOIN Aircraft a ON a.Aircraft_id = f.Aircraft_id
JOIN Airline air ON a.Airline_id = air.Airline_id
GROUP BY air.Name, air.Code

