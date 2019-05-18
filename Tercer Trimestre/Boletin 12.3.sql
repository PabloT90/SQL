--Sobre NorthWind
USE Northwind
--1.- Haz un trigger para que un pedido (order) no pueda incluir más de 10 productos diferentes.
SELECT * FROM [Order Details]
SELECT * FROM Orders
GO
CREATE TRIGGER NoMasDeDiez ON [Order Details] AFTER INSERT, UPDATE AS
BEGIN
	IF EXISTS (SELECT * FROM [Order Details] --Tenemos que tener en cuenta los que ya habia de antes.
				WHERE OrderID IN(SELECT OrderID FROM inserted)
				GROUP BY OrderID
				HAVING COUNT(DISTINCT ProductID) > 10)
	BEGIN
		ROLLBACK
	END --Fin_si
END
GO


--Pruebas
BEGIN TRAN
SET IDENTITY_INSERT ORDERS ON --Para un error que da por el INSERT-IDENTITY OFF
INSERT INTO Orders (OrderID)VALUES(12001)
--BEGIN TRAN
INSERT INTO [Order Details] VALUES
(12001,1,1,1,0),(12001,2,1,1,0),(12001,3,1,1,0),(12001,4,4,1,0),(12001,5,1,1,0),(12001,12,1,1,0),
(12001,7,1,1,0),(12001,8,1,1,0),(12001,9,1,1,0),(12001,10,1,1,0),(12001,6,1,1,0)
ROLLBACK


--2.- Haz un trigger para que un cliente no pueda hacer más de 10 pedidos al año (años naturales) de la misma categoría
GO
CREATE TRIGGER DiezXAnho ON [Order Details] AFTER INSERT AS
BEGIN
	DECLARE @anio INT
	DECLARE @cliente NCHAR(5)

	--Cogemos el año, el CustomerID de la tabla inserted
	SELECT @cliente = CustomerID, @anio = YEAR(OrderDate) FROM inserted AS[I]
		INNER JOIN Orders AS[O] ON I.OrderID = O.OrderID
	PRINT @cliente
	PRINT @anio

	--Miramos que no tenga mas de 10 pedidos con productos 
	IF EXISTS(SELECT CategoryID FROM Orders AS [O]
				  INNER JOIN [Order Details] AS[OD] ON O.OrderID = OD.OrderID
				  INNER JOIN Products AS[P] ON OD.ProductID = P.ProductID
			  WHERE CustomerID = @cliente AND YEAR(OrderDate) = @anio
			  GROUP BY CategoryID
			  HAVING COUNT(CategoryID) > 10)
	ROLLBACK
END
GO
SET DATEFORMAT YMD
--Pruebas
SELECT * FROM [Order Details]
SELECT * FROM Products
	WHERE CategoryID = 1
--Pruebas
BEGIN TRAN
SET IDENTITY_INSERT ORDERS ON --Para un error que da por el INSERT-IDENTITY OFF
INSERT INTO Orders (OrderID, CustomerID, OrderDate)VALUES(12001, 'VINET', DATETIMEFROMPARTS(2019,05,16,16,00,00,00))
--BEGIN TRAN
INSERT INTO [Order Details] VALUES
(12001,1,1,1,0),(12001,2,1,1,0),(12001,24,1,1,0),(12001,34,4,1,0),(12001,35,1,1,0),(12001,38,1,1,0),
(12001,39,1,1,0),(12001,43,1,1,0),(12001,67,1,1,0),(12001,70,1,1,0),(12001,75,1,1,0)
ROLLBACK

--No haya pedido productos de la misma categoria mas de 10 veces ese año.
SELECT COUNT(CategoryID) FROM Orders AS [O]
	INNER JOIN [Order Details] AS[OD] ON O.OrderID = OD.OrderID
	INNER JOIN Products AS[P] ON OD.ProductID = P.ProductID
	WHERE CustomerID = 'VINET' AND YEAR(OrderDate) = 2019
	GROUP BY CategoryID
	HAVING COUNT(CategoryID) > 10

--3.- Haz un trigger que no permita que un empleado sea superior de otro (ReportsTo) si el segundo es su superior 
--(en uno o varios niveles). --De esto ultimo voy a pasar, por ahora.
SELECT * FROM Employees
GO
--Este trigger solamente es válido para 1 solo nivel y un unico update. Si queremos hacerlo en mas niveles tendriamos que hacer un procedimiento que nos devuelva una tabla y luego en en WHERE
-- poner NOT IN("Datos de la tabla")
CREATE TRIGGER EmpleadoSuperior ON Employees AFTER UPDATE AS
BEGIN
	DECLARE @id SMALLINT
	DECLARE @superior SMALLINT
	--Guardo el EmployeeID del actualizado
	SELECT @id = EmployeeID, @superior = ReportsTo FROM inserted

	--Ahora miro que el ReportsTo sea igual al employeeID obtenido arriba, en ese caso haremos ROLLBACK
	IF(SELECT ReportsTo FROM Employees
		WHERE EmployeeID = @superior) = @id
	BEGIN
		ROLLBACK
	END --Fin_si
END
GO

--4.- Haz un trigger que impida que la primera venta a un cliente de fuera de USA pueda tener un importe superior a 500 $
SELECT * FROM Orders
SELECT * FROM [Order Details]

GO
CREATE TRIGGER FueraUSA ON [Order Details] AFTER INSERT AS
BEGIN
	DECLARE @cliente NCHAR(5)
	DECLARE @filas SMALLINT
	--CustomerID del recien insertado
	SELECT @cliente = O.CustomerID FROM inserted AS[I]
		INNER JOIN Orders AS[O] ON I.OrderID = O.OrderID

	--Vemos si es la primera compra del cliente fuera de USA
	SET @filas = (SELECT COUNT(*) FROM [Order Details] AS[OD]
		INNER JOIN Orders AS[O] ON OD.OrderID = O.OrderID
	WHERE ShipCountry <> 'USA' AND O.CustomerID = @cliente)

	--Si es la primera venta vemos el dinero gastado.
	IF(@filas = 1)
		BEGIN
			--Calculamos el dinero gastado en la primera venta, si es superior a 500$ se hará ROLLBACK
			IF(SELECT SUM(OD.Quantity * UnitPrice) FROM [Order Details] AS[OD]
				INNER JOIN Orders AS[O] ON OD.OrderID = O.OrderID
			WHERE ShipCountry <> 'USA' AND O.CustomerID = 'VINET') > 500
				ROLLBACK
		END --Fin_si
END
GO

--5.- Haz un trigger que impida que pueda haber a la venta más de 30 productos de una misma categoría. Los productos que 
--están a la venta son los que tienen un "0” en la columna "discontinued”
SELECT * FROM Products
	order by CategoryID
GO
CREATE TRIGGER MismaCategoria ON Products AFTER UPDATE,INSERT AS
BEGIN
	--Si es insert solo tengo que mirar que no hayan 30 productos en venta
	IF (SELECT COUNT(*) FROM Products 
				WHERE Discontinued = 0
				GROUP BY CategoryID) >= 30
		ROLLBACK
END
GO

--Sobre CasinOnLine
USE CasinOnLine2
--6.- Haz un trigger que asegure que una vez se introduce el número de una apuesta, no pueda cambiarse.


--7.- Haz untrigger que garantice que no se puedan hacer más apuestas en una jugada si la columna NoVaMas tiene el valor 1.


--8.- Haz un trigger que garantice que entre dos jugadas sucesivas en una misma mesa pasen al menos 5 minutos.


--9.- Haz un trigger que asegure que, cuando se actualiza el número de una jugada, se paguen todas las apuestas, 
--incrementando los saldos que correspondan. Se puede utilizar el procedimiento creado al efecto.


--10.- Haz un trigger que impida que en una jugada se puedan hacer apuestas que puedan provocar que se supere el límite de la mesa. 
--Se recomienda modular.

