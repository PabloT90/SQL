--1. Nombre del país y número de clientes de cada país, ordenados alfabéticamente por el nombre del país.
SELECT * FROM Customers
SELECT country, COUNT(Country) AS [Numero de clientes] FROM Customers --Count cuenta todas las filas que no sean null
	GROUP BY Country
		ORDER BY Country 

--2. ID de producto y número de unidades vendidas de cada producto. 
SELECT * FROM [Order Details]
SELECT ProductID, SUM(Quantity) AS [Unidades vendidas] FROM [Order Details] --Suma el valor de las filas numericas no nulas.
	GROUP BY ProductID
		ORDER BY ProductID

--3. ID del cliente y número de pedidos que nos ha hecho.
SELECT * FROM Orders
SELECT CustomerID, COUNT(CustomerID) AS[Nº pedidos] FROM Orders
	GROUP BY CustomerID

--4. ID del cliente, año y número de pedidos que nos ha hecho cada año.
SELECT * FROM Orders
SELECT CustomerID, YEAR(OrderDate) as[Año], COUNT(CustomerID) as[Pedidos x Año] FROM Orders
	GROUP BY CustomerID,YEAR(OrderDate)

--5. ID del producto, precio unitario y total facturado de ese producto, ordenado por cantidad facturada de mayor a menor.
--Si hay varios precios unitarios para el mismo producto tomaremos el mayor.
SELECT * FROM [Order Details]
SELECT ProductID, MAX(UnitPrice) AS [Precio Unitario], SUM(UnitPrice*Quantity-((UnitPrice*Discount)/100)) AS[Facturado] FROM [Order Details]
	GROUP BY ProductID

--6. ID del proveedor e importe total del stock acumulado de productos correspondientes a ese proveedor.
SELECT * FROM Products
SELECT SupplierID, SUM(UnitPrice*UnitsInStock) AS [Importe Stock] FROM Products
	GROUP BY SupplierID

--7. Número de pedidos registrados mes a mes de cada año.
SELECT * FROM Orders
SELECT COUNT(MONTH(OrderDate)) AS[Pedidos Mes],MONTH(OrderDate) AS[Mes], YEAR(OrderDate) AS [Año] FROM Orders
	GROUP BY YEAR(OrderDate),MONTH(OrderDate), YEAR(OrderDate)
		ORDER BY YEAR(OrderDate)

--8. Año y tiempo medio transcurrido entre la fecha de cada pedido (OrderDate) y la fecha en la que lo hemos enviado (ShipDate), en días para cada año.
SELECT * FROM Orders
SELECT YEAR(OrderDate) AS [Año], DATEDIFF(DAY, OrderDate,ShippedDate) AS [Media] FROM Orders
	GROUP BY OrderDate, ShippedDate

--9. ID del distribuidor y número de pedidos enviados a través de ese distribuidor.
SELECT * FROM Products
SELECT SupplierID, COUNT(SupplierID) AS[Numero pedidos] FROM Products
	GROUP BY SupplierID
--Creo que se necesita INNER JOIN

--10. ID de cada proveedor y número de productos distintos que nos suministra.
SELECT * FROM Products
SELECT SupplierID, COUNT(CategoryID) AS[Nº Productos] FROM Products
	GROUP BY SupplierID