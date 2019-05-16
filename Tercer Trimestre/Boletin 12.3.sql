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


--3.- Haz un trigger que no permita que un empleado sea superior de otro (ReportsTo) si el segundo es su superior 
--(en uno o varios niveles).


--4.- Haz un trigger que impida que la primera venta a un cliente de fuera de USA pueda tener un importe superior a 500 $


--5.- Haz un trigger que impida que pueda haber a la venta más de 30 productos de una misma categoría. Los productos que 
--están a la venta son los que tienen un "0” en la columna "discontinued”
SELECT * FROM Products
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

