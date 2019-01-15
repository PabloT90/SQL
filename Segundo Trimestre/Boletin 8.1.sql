--1. Nombre del pa�s y n�mero de clientes de cada pa�s, ordenados alfab�ticamente por el nombre del pa�s.
SELECT * FROM Customers
SELECT country, COUNT(Country) AS [Numero de clientes] FROM Customers --Count cuenta todas las filas que no sean null
	GROUP BY Country
		ORDER BY Country 

--2. ID de producto y n�mero de unidades vendidas de cada producto. 
SELECT * FROM [Order Details]
SELECT ProductID, SUM(Quantity) AS [Unidades vendidas] FROM [Order Details] --Suma el valor de las filas numericas no nulas.
	GROUP BY ProductID
		ORDER BY ProductID

--3. ID del cliente y n�mero de pedidos que nos ha hecho.
SELECT * FROM Orders
SELECT CustomerID, COUNT(CustomerID) AS[N� pedidos] FROM Orders
	GROUP BY CustomerID

--4. ID del cliente, a�o y n�mero de pedidos que nos ha hecho cada a�o.
SELECT * FROM Orders
SELECT CustomerID, YEAR(OrderDate) as[A�o], COUNT(CustomerID) as[Pedidos x A�o] FROM Orders
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

--7. N�mero de pedidos registrados mes a mes de cada a�o.
SELECT * FROM Orders
SELECT COUNT(MONTH(OrderDate)) AS[Pedidos Mes],MONTH(OrderDate) AS[Mes], YEAR(OrderDate) AS [A�o] FROM Orders
	GROUP BY YEAR(OrderDate),MONTH(OrderDate), YEAR(OrderDate)
		ORDER BY YEAR(OrderDate)

--8. A�o y tiempo medio transcurrido entre la fecha de cada pedido (OrderDate) y la fecha en la que lo hemos enviado (ShipDate), en d�as para cada a�o.
SELECT * FROM Orders
SELECT YEAR(OrderDate) AS [A�o], DATEDIFF(DAY, OrderDate,ShippedDate) AS [Media] FROM Orders
	GROUP BY OrderDate, ShippedDate

--9. ID del distribuidor y n�mero de pedidos enviados a trav�s de ese distribuidor.
SELECT * FROM Products
SELECT SupplierID, COUNT(SupplierID) AS[Numero pedidos] FROM Products
	GROUP BY SupplierID
--Creo que se necesita INNER JOIN

--10. ID de cada proveedor y n�mero de productos distintos que nos suministra.
SELECT * FROM Products
SELECT SupplierID, COUNT(CategoryID) AS[N� Productos] FROM Products
	GROUP BY SupplierID