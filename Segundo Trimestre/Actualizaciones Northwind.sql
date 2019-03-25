USE Northwind
--1. Inserta un nuevo cliente.
SELECT * FROM Customers
BEGIN TRAN
INSERT INTO Customers
	VALUES('VOKSI','Victor Calla',NULL, NULL,NULL, NULL,NULL, NULL,NULL, NULL,NULL)
COMMIT TRAN

--2. Véndele (hoy) tres unidades de "Pavlova”, diez de "Inlagd Sill” y 25 de "Filo Mix”. El distribuidor será Speedy Express y 
--el vendedor Laura Callahan.
INSERT INTO Orders
SELECT C.CustomerID, E.EmployeeID, CURRENT_TIMESTAMP, NULL, NULL, S.ShipperID, 0, S.CompanyName, C.Address, C.City, 
	NULL, C.PostalCode, C.Country FROM Shippers AS S
	CROSS JOIN Customers AS C
	CROSS JOIN Employees AS E
WHERE C.CompanyName = 'Victor Calla' AND (E.FirstName='Laura' AND E.LastName='Callahan') AND S.CompanyName='Speedy Express'
COMMIT TRAN

--Lo que hace es que la variable @id sea IDENTITY.
DECLARE @id INT
SET @id = @@IDENTITY

BEGIN TRAN
INSERT INTO [Order Details]
	SELECT @id, ProductID, UnitPrice, 3 , 0  FROM Products --Cuando le pongo los valores explicitos significa que las filas que me devuelva, el valor en esa columna es ese valor explicito.
		WHERE (ProductName='Pavlova')

INSERT INTO [Order Details]
	SELECT @id, ProductID, UnitPrice, 10 , 0  FROM Products
		WHERE (ProductName='Inlagd Sill')

INSERT INTO [Order Details]
	SELECT @id, ProductID, UnitPrice, 25 , 0  FROM Products
		WHERE (ProductName='Filo Mix')
ROLLBACK

--3. Ante la bajada de ventas producida por la crisis, hemos de adaptar nuestros precios según las siguientes reglas:
--Los productos de la categoría de bebidas (Beverages) que cuesten más de $10 reducen su precio en un dólar.
--Los productos de la categoría Lácteos que cuesten más de $5 reducen su precio en un 10%.
--Los productos de los que se hayan vendido menos de 200 unidades en el último año, reducen su precio en un 5%

--Apartado A)
BEGIN TRAN
UPDATE Products
	SET UnitPrice = UnitPrice - 1
WHERE ProductID IN(SELECT P.ProductID FROM Products AS[P] --Productos de la categoria de bebidas Beverages que cuesten mas de 10$
						INNER JOIN Categories AS[C] ON P.CategoryID = C.CategoryID
				   WHERE P.UnitPrice > 10 AND C.CategoryName = 'Beverages')
ROLLBACK

--Apartado B)
BEGIN TRAN
UPDATE Products
	SET UnitPrice = UnitPrice * 0.9
WHERE ProductID IN(SELECT P.ProductID FROM Products AS[P] --Productos de la categoria lacteos que cuesten mas de 5$
						INNER JOIN Categories AS[C] ON P.CategoryID = C.CategoryID
				   WHERE P.UnitPrice > 5 AND C.CategoryName = 'Dairy Products')
ROLLBACK

--Apartado C) Los productos de los que se hayan vendido menos de 200 unidades en el último año, reducen su precio en un 5%
BEGIN TRAN
UPDATE Products
	SET UnitPrice = UnitPrice * 0.95
WHERE ProductID IN (SELECT P.ProductID FROM Products AS[P]
						INNER JOIN [Order Details] AS[OD] ON P.ProductID = OD.ProductID
						INNER JOIN [Orders] AS[O] ON OD.OrderID = O.OrderID
					GROUP BY P.ProductID, O.OrderDate
					HAVING SUM(OD.Quantity) < 200 AND YEAR(O.OrderDate) = YEAR(CURRENT_TIMESTAMP))
ROLLBACK
--4. Inserta un nuevo vendedor llamado Michael Trump. Asígnale los territorios de Louisville, Phoenix, Santa Cruz y Atlanta.
BEGIN TRAN
INSERT INTO Employees
	VALUES('Prats','Pablo', NULL,NULL, NULL,NULL, NULL,NULL, NULL,NULL,NULL, NULL,NULL, NULL,NULL, NULL,NULL)
COMMIT TRAN

BEGIN TRAN 
INSERT INTO EmployeeTerritories
	VALUES(10,(SELECT TerritoryID FROM Territories
					WHERE TerritoryDescription = 'Louisville'))
INSERT INTO EmployeeTerritories
	VALUES(10,(SELECT TerritoryID FROM Territories
					WHERE TerritoryDescription = 'Phoenix'))
INSERT INTO EmployeeTerritories
	VALUES(10,(SELECT TerritoryID FROM Territories
					WHERE TerritoryDescription = 'Santa Cruz'))
INSERT INTO EmployeeTerritories
	VALUES(10,(SELECT TerritoryID FROM Territories
					WHERE TerritoryDescription = 'Atlanta'))
ROLLBACK

--5. Haz que las ventas del año 97 de Robert King que haya hecho a clientes de los estados de California y Texas se le asignen 
--al nuevo empleado.
SELECT * FROM ORDERS
--Consulta que me devuelva eso
BEGIN TRAN
UPDATE Orders
SET EmployeeID = (SELECT EmployeeID FROM Employees
						WHERE LastName='Prats' AND FirstName='Pablo')
WHERE OrderID IN (SELECT O.OrderID FROM Employees AS[E]
					INNER JOIN Orders AS[O] ON E.EmployeeID = O.EmployeeID
					INNER JOIN Customers AS[C] ON O.CustomerID = C.CustomerID
				 WHERE YEAR(O.OrderDate) = 1997 AND O.EmployeeID = 8 AND O.ShipRegion in ('ca','tx'))
--COMMIT TRAN
--ROLLBACK

--6. Inserta un nuevo producto con los siguientes datos:
	--ProductID: 90
	--ProductName: Nesquick Power Max
	--SupplierID: 12
	--CategoryID: 3
	--QuantityPerUnit: 10 x 300g
	--UnitPrice: 2,40
	--UnitsInStock: 38
	--UnitsOnOrder: 0
	--ReorderLevel: 0
	--Discontinued: 0
BEGIN TRANSACTION
INSERT INTO Products (ProductName, SupplierID, CategoryID, QuantityPerUnit, UnitPrice, UnitsInStock, UnitsOnOrder, ReorderLevel, Discontinued)
VALUES ('Nesquick Power Max', 12, 3, '10 x 300g', 2.40, 38, 0, 0, 0)
--ROLLBACK
--COMMIT

--7. Inserta un nuevo producto con los siguientes datos:
	--ProductID: 91
	--ProductName: Mecca Cola
	--SupplierID: 1
	--CategoryID: 1
	--QuantityPerUnit: 6 x 75 cl
	--UnitPrice: 7,35
	--UnitsInStock: 14
	--UnitsOnOrder: 0
	--ReorderLevel: 0
	--Discontinued: 0
BEGIN TRANSACTION
INSERT INTO Products (ProductName, SupplierID, CategoryID, QuantityPerUnit, UnitPrice, UnitsInStock, UnitsOnOrder, ReorderLevel, Discontinued)
VALUES ('Mecca Cola', 1, 1, '6 x 75 cl', 7.35, 14, 0, 0, 0)
--ROLLBACK
--COMMIT

--8. Todos los que han comprado "Outback Lager" han comprado cinco años después la misma cantidad de Mecca Cola al mismo vendedor
--El pasado 20 de enero, Margaret Peacock consiguió vender una caja de Nesquick Power Max a todos los clientes que le habían 
--comprado algo anteriormente. Los datos de envío (dirección, transportista, etc) son los mismos de alguna de sus ventas 
--anteriores a ese cliente).
