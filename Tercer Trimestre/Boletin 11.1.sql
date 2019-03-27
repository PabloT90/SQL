USE Northwind
--1) Deseamos incluir un producto en la tabla Products llamado "Cruzcampo lata” pero no estamos seguros si se ha insertado o no.
--El precio son 4,40, el proveedor es el 16, la categoría 1 y la cantidad por unidad es "Pack 6 latas” "Discontinued” toma el valor 0 y el 
--resto de columnas se dejarán a NULL.
--Escribe un script que compruebe si existe un producto con ese nombre. En caso afirmativo, actualizará el precio y en caso negativo insertarlo. 
SELECT *FROM Products

BEGIN TRAN
BEGIN
IF NOT EXISTS(SELECT * FROM Products
			  WHERE ProductName = 'Cruzcampo Lata') 
	INSERT INTO Products
		VALUES('Cruzcampo Lata', 16, 1, 'Pack 6 Latas', 4.40, NULL, NULL, NULL, 0)
ELSE
	UPDATE Products
		SET UnitPrice = 4.30
	WHERE ProductName = 'Cruzcampo Lata'
END
--COMMIT TRAN
--ROLLBACK

--2) Comprueba si existe una tabla llamada ProductSales. Esta tabla ha de tener de cada producto el ID, el Nombre, el Precio unitario, 
--el número total de unidades vendidas y el total de dinero facturado con ese producto. Si no existe, créala
IF EXISTS (SELECT * FROM sysobjects WHERE name = 'ProductSales')
	BEGIN
		PRINT 'Existe'
	END
ELSE
	BEGIN
		BEGIN TRAN
		CREATE TABLE [ProductSales](
			ID int NOT NULL,
			Nombre varchar(40) not null,
			UnitPrice money null,
			SoldUnits smallint null,
			DineroFacturado money null,
		)

		--Copio los datos de la tabla products a esta
		BEGIN TRAN
		INSERT INTO ProductSales
		SELECT ProductID, ProductName, UnitPrice, UnitsOnOrder, UnitPrice*UnitsInStock FROM Products
	END --BEGIN

--COMMIT TRAN
--ROLLBACK

--Otra forma, segun he leido es mejor que la anterior.
IF OBJECT_ID('dbo.ProductSales') IS NULL
	BEGIN
		BEGIN TRAN
		CREATE TABLE [ProductSales](
			ID int NOT NULL,
			Nombre varchar(15) not null,
			UnitPrice money null,
			SoldUnits int null,
			DineroFacturado money null,
		)
	END --BEGIN
ELSE
	BEGIN
		PRINT 'Existe'
	END --BEGIN
--COMMIT TRAN
--ROLLBACK

--3) Comprueba si existe una tabla llamada ShipShip. Esta tabla ha de tener de cada Transportista el ID, el Nombre de la compañía, 
--el número total de envíos que ha efectuado y el número de países diferentes a los que ha llevado cosas. Si no existe, créala

--Igual que el 2.

--Hasta estar seguro de que tanto el 3 como el 4 se resuelven como el 2, los dejare sin hacer.
--Creo que tienen el mismo mecanismo que el 2.

--Igual que el 2.

--4) Comprueba si existe una tabla llamada EmployeeSales. Esta tabla ha de tener de cada empleado su ID, el Nombre completo, el 
--número de ventas totales que ha realizado, el número de clientes diferentes a los que ha vendido y el total de dinero facturado. 
--Si no existe, créala


--5) Entre los años 96 y 97 hay productos que han aumentado sus ventas y otros que las han disminuido. Queremos cambiar el precio unitario 
--según la siguiente tabla:

--incremento de ventas	Incremento del precio
--negativo				-10%
--entre 0% y 10%		No varia
--entre 10% y 50%		+5%
--mayor del 50%			10% con un maximo de 2,25

SELECT * FROM VentasDel96
SELECT * FROM VentasDel97

--Realmente esta vista no haria falta pero weno.
GO
CREATE VIEW Diferencia AS(
SELECT V97.ProductName, (V96.Ventas96*100)/V97.Ventas97 AS[Porcentaje] FROM VentasDel96 AS[V96]
	INNER JOIN VentasDel97 AS[V97] ON V96.ProductName = V97.ProductName
)
GO
SELECT * FROM Products
BEGIN TRAN
UPDATE Products
	SET UnitPrice = (
		CASE  
			WHEN D.Porcentaje < 0 THEN UnitPrice * 0.9
			WHEN D.Porcentaje BETWEEN 0 AND 10 THEN UnitPrice
			WHEN D.Porcentaje BETWEEN 11 AND 50 THEN UnitPrice * 1.05
			WHEN UnitPrice * 1.1 > 2.25 THEN UnitPrice + 2.25
			WHEN UnitPrice <= 2.25 THEN UnitPrice * 1.1
		 END   
	)
FROM Diferencia AS[D] --Aqui se podria hacer un inner join con las ventas del 96 y 97 y me ahorro hacer una vista extra.
--rollback