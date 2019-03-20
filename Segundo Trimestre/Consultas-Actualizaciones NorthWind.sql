USE Northwind
--1) Vista que nos devuelva los nombres de todos los clientes que nos han comprado algún  producto de la categoría "Dairy Products”, 
--así como las fechas de la primera y la última compra.
SELECT * FROM Customers
SELECT * FROM Categories

--Vista con la ultima compra de la categoria Dairy Products
GO
CREATE VIEW [UltimaCompra] AS
SELECT DISTINCT MAX(O.OrderDate) AS[Ultima Compra], C.CustomerID FROM Customers AS[C]
	INNER JOIN Orders AS[O] ON C.CustomerID = O.CustomerID
	INNER JOIN [Order Details] AS[OD] ON O.OrderID = OD.OrderID
	INNER JOIN Products AS[P] ON OD.ProductID = P.ProductID
	INNER JOIN Categories AS[Ca] ON P.CategoryID = Ca.CategoryID
WHERE Ca.CategoryID = 4
GROUP BY C.CustomerID
GO

--Vista con la primera compra.
GO
CREATE VIEW [PrimeraCompra] AS
SELECT DISTINCT MIN(O.OrderDate) AS[Primera Compra], C.CustomerID FROM Customers AS[C]
	INNER JOIN Orders AS[O] ON C.CustomerID = O.CustomerID
	INNER JOIN [Order Details] AS[OD] ON O.OrderID = OD.OrderID
	INNER JOIN Products AS[P] ON OD.ProductID = P.ProductID
	INNER JOIN Categories AS[Ca] ON P.CategoryID = Ca.CategoryID
WHERE Ca.CategoryID = 4
GROUP BY C.CustomerID
GO

GO
CREATE VIEW [ClientesDairyProducts] AS
SELECT DISTINCT C.CustomerID, UC.[Ultima Compra], PC.[Primera Compra] FROM Customers AS[C]
	INNER JOIN Orders AS[O] ON C.CustomerID = O.CustomerID
	INNER JOIN [Order Details] AS[OD] ON O.OrderID = OD.OrderID
	INNER JOIN Products AS[P] ON OD.ProductID = P.ProductID
	INNER JOIN Categories AS[Ca] ON P.CategoryID = Ca.CategoryID
	INNER JOIN UltimaCompra AS[UC] ON C.CustomerID = UC.CustomerID
	INNER JOIN PrimeraCompra AS[PC] ON C.CustomerID = PC.CustomerID
WHERE Ca.CategoryID = 4
GO

--2) Además de todo lo anterior, queremos saber también el nombre del distribuidor con el que hicimos el envío. 
--Si hay varios pedidos para el mismo cliente, tomar el distribuidor con el que hicimos el primero de ellos.

--Esta la tengo que revisar
SELECT DISTINCT S.SupplierID,CDP.CustomerID, CDP.[Primera Compra], CDP.[Ultima Compra] FROM ClientesDairyProducts AS[CDP]
	INNER JOIN Orders AS[O] ON CDP.CustomerID = O.CustomerID
	INNER JOIN [Order Details] AS[OD] ON O.OrderID = OD.OrderID
	INNER JOIN Products AS[P] ON OD.ProductID = P.ProductID
	INNER JOIN Suppliers AS[S] ON P.SupplierID = S.SupplierID
GROUP BY CDP.CustomerID, CDP.[Primera Compra], CDP.[Ultima Compra], S.SupplierID
HAVING MIN(OrderDate) = CDP.[Primera Compra]

-- 3)Vista que nos devuelva nombre, ID y número de unidades vendidas de cada producto en el año 1997.
GO
CREATE VIEW [UnidadesVentas97] AS
SELECT SUM(OD.Quantity) AS[Ventas], P.ProductID, P.ProductName FROM Products AS[P]
	INNER JOIN [Order Details] AS[OD] ON P.ProductID = OD.ProductID
	INNER JOIN Orders AS[O] ON OD.OrderID = O.OrderID
WHERE YEAR(O.OrderDate) = 1997
GROUP BY P.ProductID, P.ProductName
GO

--4) Modifica la vista anterior para incluir también los productos de los que no hayamos vendido nada, especificando "0” 
--en las unidades.

--Esta la tengo que mirar
SELECT * FROM Products
GO
ALTER VIEW [UnidadesVentas97] AS
SELECT SUM(OD.Quantity) AS[Ventas], P.ProductID, P.ProductName FROM Products AS[P]
	INNER JOIN [Order Details] AS[OD] ON P.ProductID = OD.ProductID
	INNER JOIN Orders AS[O] ON OD.OrderID = O.OrderID AND YEAR(O.OrderDate) = 1996
--WHERE YEAR(O.OrderDate) = 1996
GROUP BY P.ProductID, P.ProductName
GO