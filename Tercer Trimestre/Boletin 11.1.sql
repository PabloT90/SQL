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
		SET UnitPrice = 4.40
	WHERE ProductName = 'Cruzcampo Lata'
END
ROLLBACK
--2) Comprueba si existe una tabla llamada ProductSales. Esta tabla ha de tener de cada producto el ID, el Nombre, el Precio unitario, 
--el número total de unidades vendidas y el total de dinero facturado con ese producto. Si no existe, créala


--3) Comprueba si existe una tabla llamada ShipShip. Esta tabla ha de tener de cada Transportista el ID, el Nombre de la compañía, 
--el número total de envíos que ha efectuado y el número de países diferentes a los que ha llevado cosas. Si no existe, créala


--4) Comprueba si existe una tabla llamada EmployeeSales. Esta tabla ha de tener de cada empleado su ID, el Nombre completo, el 
--número de ventas totales que ha realizado, el número de clientes diferentes a los que ha vendido y el total de dinero facturado. 
--Si no existe, créala


--5) Entre los años 96 y 97 hay productos que han aumentado sus ventas y otros que las han disminuido. Queremos cambiar el precio unitario 
--según la siguiente tabla:

