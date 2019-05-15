use AdventureWorks2014
--Шикунов Николай
--1 запрос
GO
SELECT person.FirstName, person.MiddleName, person.LastName, phone.PhoneNumber, ctype.[Name] --BusinessEntityID
From Person.Person person
JOIN Person.PersonPhone phone
ON person.BusinessEntityID = phone.BusinessEntityID
JOIN Person.PhoneNumberType phtype
ON phone.PhoneNumberTypeID = phtype.PhoneNumberTypeID
JOIN Person.BusinessEntityContact bcontact
ON bcontact.PersonID = person.BusinessEntityID
JOIN Person.ContactType ctype
ON ctype.ContactTypeID = bcontact.ContactTypeID
WHERE phtype.[Name] = 'Work' AND person.MiddleName != '' AND ctype.[Name] = 'Owner'
ORDER BY person.LastName, person.FirstName

--2 запрос
GO
SELECT DISTINCT ProductName, SUM_pr/SUM_Cat * 100 as [SalesRatio, %], ProductCategory 
FROM(
	SELECT prcat.Name as [ProductCategory], product.ProductID, product.[Name] AS [ProductName], prcat.[Name], 
	SUM(salesd.LineTotal) OVER (PARTITION BY product.ProductId) [SUM_pr],
	SUM(salesd.LineTotal) OVER (PARTITION BY prcat.ProductCategoryId) [SUM_Cat]
	From Production.Product product
	JOIN Production.ProductSubcategory subcat
	ON subcat.ProductSubcategoryID = product.ProductSubcategoryID
	JOIN Production.ProductCategory prcat
	ON prcat.ProductCategoryID = subcat.ProductCategoryID
	JOIN Sales.SalesOrderDetail salesd
	ON salesd.ProductID = product.ProductID ) as [initial]
ORDER BY ProductCategory, [SalesRatio, %] DESC

--3 запрос
GO
SELECT prcat.[Name] as [ProductCategory], product.[Name] as [ProductName],
AVG(prcost.StandardCost) as [ProductAverageCost]
FROM Production.Product product
JOIN Production.ProductSubcategory subcat
ON product.ProductSubcategoryID = subcat.ProductSubcategoryID
JOIN Production.ProductCategory prcat
ON prcat.ProductCategoryID = subcat.ProductCategoryID
JOIN Production.ProductCostHistory prcost
ON prcost.ProductID = product.ProductID
WHERE prcat.[Name] =  'Bikes' OR prcat.[Name] =  'Components'
GROUP BY prcat.[Name], product.[Name]
ORDER BY ProductCategory

--4 запрос
GO
SELECT orders.OrderYear, orders.OrderMonth, orders.SalesOrderNumber,
 orders.DistinctProductsAmount, orders.OrderCost
FROM (
		SELECT YEAR(head.OrderDate) AS OrderYear, MONTH(head.OrderDate) AS OrderMonth,
		COUNT(det.SalesOrderID) as DistinctProductsAmount, head.SalesOrderNumber, head.TotalDue as OrderCost, 
		DENSE_RANK() OVER (PARTITION BY YEAR(head.OrderDate), MONTH(head.OrderDate)
		ORDER BY head.TotalDue DESC) AS Rating
		FROM Sales.SalesOrderHeader head
		JOIN Sales.SalesOrderDetail det
		ON head.SalesOrderID = det.SalesOrderID		
		GROUP BY det.SalesOrderID, head.OrderDate, head.OrderDate, head.SalesOrderNumber, head.TotalDue
		
		) orders
WHERE orders.Rating = 1 or orders.Rating = 2 or orders.Rating = 3 
ORDER BY OrderYear, OrderMonth, Rating

--5 запрос 
-- В тексте задания опечатка!
-- "...о заказах, в которых нет продуктов, купленных со скидкой."
-- Но на скриншоте ответа даны заказы, в которых есть товар по скидке 
-- Мой запрос сделан, как на скриншоте
-- Если что, вся разница лишь в слове "NOT" перед exists 
GO
SELECT DISTINCT head.SalesOrderID, head.OrderDate, head.TotalDue
FROM Sales.SalesOrderHeader head
JOIN Sales.SalesOrderDetail det
ON head.SalesOrderID = det.SalesOrderID	
WHERE EXISTS ( 
	SELECT * 
	FROM Sales.SalesOrderDetail 
	WHERE SalesOrderID = head.SalesOrderID AND UnitPriceDiscount > 0 )
ORDER BY head.SalesOrderID 

--6 запрос
--Уверен, что не самое рациональное решение
GO
DECLARE @initial TABLE(ProductName nvarchar(max), ProductOrdersAmount int, [Year] int)
INSERT INTO @initial
SELECT DISTINCT product.[Name] as ProductName, COUNT(head.SalesOrderID) OVER(PARTITION BY YEAR(head.OrderDate), product.productID) as ProductOrdersAmount,
	YEAR(head.OrderDate) as [Year]
	FROM Production.Product product
	JOIN Sales.SalesOrderDetail det
	ON det.ProductID = product.ProductID
	JOIN Sales.SalesOrderHeader head
	ON head.SalesOrderID = det.SalesOrderID

DECLARE @final TABLE(ProductName nvarchar(max), ProductOrdersAmount int, [Year] int, maximum int)
INSERT INTO @final
SELECT ProductName, ProductOrdersAmount, [Year], 
MAX(ProductOrdersAmount) OVER(PARTITION BY [Year]) as maximum
FROM @initial

SELECT ProductName, ProductOrdersAmount, [Year]
FROM @final
WHERE maximum = ProductOrdersAmount



