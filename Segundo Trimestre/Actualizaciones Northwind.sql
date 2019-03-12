USE Northwind
--1. Inserta un nuevo cliente.
SELECT * FROM Customers
BEGIN TRAN
INSERT INTO Customers
	VALUES('VOKSI','Victor Calla',NULL, NULL,NULL, NULL,NULL, NULL,NULL, NULL,NULL)
COMMIT TRAN

--2. Véndele (hoy) tres unidades de "Pavlova”, diez de "Inlagd Sill” y 25 de "Filo Mix”. El distribuidor será Speedy Express y 
--el vendedor Laura Callahan.
SELECT * FROM Orders
BEGIN TRAN
INSERT INTO Orders
	VALUES('VOKSI', 8, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, NULL, 1, NULL, 'Speedy Express', null, null, null, null, null)

select * from Employees
select * from Shippers
SELECT * FROM Suppliers
--3. Ante la bajada de ventas producida por la crisis, hemos de adaptar nuestros precios según las siguientes reglas:
	--Los productos de la categoría de bebidas (Beverages) que cuesten más de $10 reducen su precio en un dólar.
	--Los productos de la categoría Lácteos que cuesten más de $5 reducen su precio en un 10%.
	--Los productos de los que se hayan vendido menos de 200 unidades en el último año, reducen su precio en un 5%


--4. Inserta un nuevo vendedor llamado Michael Trump. Asígnale los territorios de Louisville, Phoenix, Santa Cruz y Atlanta.


--5. Haz que las ventas del año 97 de Robert King que haya hecho a clientes de los estados de California y Texas se le asignen 
--al nuevo empleado.


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


--8. Todos los que han comprado "Outback Lager" han comprado cinco años después la misma cantidad de Mecca Cola al mismo vendedor
--El pasado 20 de enero, Margaret Peacock consiguió vender una caja de Nesquick Power Max a todos los clientes que le habían 
--comprado algo anteriormente. Los datos de envío (dirección, transportista, etc) son los mismos de alguna de sus ventas 
--anteriores a ese cliente).

