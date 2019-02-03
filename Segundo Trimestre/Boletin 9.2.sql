USE Northwind
--1. Número de clientes de cada país.
SELECT * FROM Customers
SELECT COUNT(Country) AS[Clientes], country FROM Customers
	GROUP BY Country
		ORDER BY Clientes

--2. Número de clientes diferentes que compran cada producto. Incluye el nombre
--del producto
SELECT * FROM Customers
SELECT * FROM Orders
SELECT * FROM [Order Details]
SELECT * FROM Products
SELECT DISTINCT COUNT(C.ContactName) AS[Numero Clientes], P.ProductName FROM Customers AS[C]
	INNER JOIN Orders AS[O] ON C.CustomerID = O.CustomerID
	INNER JOIN [Order Details] AS[OD] ON O.OrderID = OD.OrderID
	INNER JOIN Products AS[P] ON OD.ProductID = P.ProductID
		GROUP BY P.ProductName

--3. Número de países diferentes en los que se vende cada producto. Incluye el
--nombre del producto
SELECT * FROM [Order Details]
SELECT * FROM Orders

SELECT OD.ProductID, COUNT(DISTINCT O.ShipCountry)AS[Total paises diferentes]  FROM [Order Details] AS OD
	INNER JOIN Orders AS O ON OD.OrderID=O.OrderID
		GROUP BY OD.ProductID

--4. Empleados (nombre y apellido) que han vendido alguna vez
--“Gudbrandsdalsost”, “Lakkalikööri”, “Tourtière” o “Boston Crab Meat”.
SELECT * FROM Employees
SELECT * FROM Orders
SELECT * FROM [Order Details]
SELECT * FROM Products
SELECT DISTINCT E.FirstName, E.LastName, P.ProductName FROM Employees AS[E]
	INNER JOIN Orders AS[O] ON E.EmployeeID = O.EmployeeID
	INNER JOIN [Order Details] AS[OD] ON O.OrderID = OD.OrderID
	INNER JOIN Products AS[P] ON OD.ProductID = P.ProductID
		WHERE P.ProductName IN('Gudbrandsdalsost', 'Lakkalikööri', 'Tourtière','Boston Crab Meat')
		ORDER BY E.FirstName

--5. Empleados que no han vendido nunca “Northwoods Cranberry Sauce” o
--“Carnarvon Tigers”.
--Despues hago la diferencia entre el total y los obtenidos abajo.
SELECT DISTINCT E.FirstName, E.LastName FROM Employees AS[E]
EXCEPT
--Primero busco los que lo han vendido.
SELECT DISTINCT E.FirstName, E.LastName FROM Employees AS[E]
	INNER JOIN Orders AS[O] ON E.EmployeeID = O.EmployeeID
	INNER JOIN [Order Details] AS[OD] ON O.OrderID = OD.OrderID
	INNER JOIN Products AS[P] ON OD.ProductID = P.ProductID
		WHERE P.ProductName IN('Northwoods Cranberry Sauce', 'Carnarvon Tigers')

--6. Número de unidades de cada categoría de producto que ha vendido cada
--empleado. Incluye el nombre y apellidos del empleado y el nombre de la
--categoría.


--7. Total de ventas (US$) de cada categoría en el año 97. Incluye el nombre de la
--categoría.
SELECT * FROM Categories
SELECT * FROM Products
SELECT * FROM [Order Details]
SELECT * FROM Orders
SELECT C.CategoryName, SUM(OD.Quantity*OD.UnitPrice) AS[Importe] FROM Categories AS[C]
	INNER JOIN Products AS[P] ON C.CategoryID = P.CategoryID
	INNER JOIN [Order Details] AS[OD] ON P.ProductID = OD.ProductID
	INNER JOIN Orders AS[O] ON OD.OrderID = O.OrderID
		WHERE YEAR(O.OrderDate) = 1997
		GROUP BY C.CategoryName
		

--8. Productos que han comprado más de un cliente del mismo país, indicando el
--nombre del producto, el país y el número de clientes distintos de ese país que
--lo han comprado.
SELECT * FROM Products
SELECT * FROM [Order Details]
SELECT * FROM Orders
SELECT * FROM Customers
SELECT P.ProductName, C.Country, COUNT(O.ShipCountry) AS[Numero Clientes] FROM Products AS[P]
	INNER JOIN [Order Details] AS[OD] ON P.ProductID = OD.ProductID
	INNER JOIN Orders AS[O] ON OD.OrderID = O.OrderID
	INNER JOIN Customers AS[C] ON O.CustomerID = C.CustomerID
		GROUP BY P.ProductName, C.Country
		HAVING COUNT(O.ShipCountry) > 1

--9. Total de ventas (US$) en cada país cada año.
SELECT * FROM Orders
SELECT * FROM [Order Details]
SELECT SUM(OD.Quantity * OD.UnitPrice) AS[Ventas], O.ShipCountry, YEAR(O.OrderDate) AS[Año] FROM Orders AS[O]
	INNER JOIN [Order Details] AS[OD] ON O.OrderID = OD.OrderID
		GROUP BY O.ShipCountry, YEAR(O.OrderDate)
			ORDER BY Año

--10. Producto superventas de cada año, indicando año, nombre del producto,
--categoría y cifra total de ventas.
SELECT P.ProductName, P.CategoryID, YEAR(O.OrderDate) as[año], SUM(OD.Quantity) as[Ventas] FROM Products as[P]
	INNER JOIN [Order Details] AS[od] ON P.ProductID = OD.ProductID
	INNER JOIN Orders AS[O] ON OD.OrderID = O.OrderID
	INNER JOIN
	(SELECT Prod.Año, MAX(Prod.Ventas) AS[Maximo de un producto] FROM 
		(SELECT P.ProductID, YEAR(O.OrderDate) as[Año], SUM(OD.Quantity) AS[Ventas] FROM Products AS[P]
		INNER JOIN [Order Details] AS[OD] ON P.ProductID = OD.ProductID
		INNER JOIN Orders AS[O] ON OD.OrderID = O.OrderID
		GROUP BY P.ProductID, YEAR(OrderDate))AS[Prod]
	GROUP BY Prod.Año)AS[ORR] ON YEAR(O.OrderDate) = ORR.Año
GROUP BY P.ProductName, P.CategoryID, YEAR(O.OrderDate), ORR.[Maximo de un producto]
HAVING SUM(OD.Quantity) = ORR.[Maximo de un producto]
	-- Con el primer SELECT obtengo las ventas de cada producto cada año.
	--A ese SELECT le hago otro que me da el maximo importe de todos los productos de un solo año.
	--El tercer SELECT me muestra ademas el Nombre del producto y la categoria a la que pertenece.



--11. Cifra de ventas de cada producto en el año 97 y su aumento o disminución
--respecto al año anterior en US $ y en %.
--Ventas de cada producto en el 97
GO
CREATE VIEW [VentasDel97] AS
SELECT P.ProductName, SUM(OD.Quantity*OD.Quantity)AS[Ventas97] FROM Products AS[P]
	INNER JOIN [Order Details] AS[OD] ON P.ProductID = OD.ProductID
	INNER JOIN Orders AS[O] ON OD.OrderID = O.OrderID
		WHERE YEAR(OrderDate) = 1997
			GROUP BY P.ProductName
GO
--Ventas de cada producto en el 96
GO
CREATE VIEW  [VentasDel96] AS
SELECT P.ProductName, SUM(OD.Quantity*OD.Quantity)AS[Ventas96] FROM Products AS[P]
	INNER JOIN [Order Details] AS[OD] ON P.ProductID = OD.ProductID
	INNER JOIN Orders AS[O] ON OD.OrderID = O.OrderID
		WHERE YEAR(OrderDate) = 1996
			GROUP BY P.ProductName
GO

SELECT V97.ProductName,(V97.[Ventas97]-V96.[Ventas96]) AS[Diferencia] FROM [VentasDel97] AS V97
	INNER JOIN [VentasDel96] AS V96 ON V97.ProductName = V96.ProductName
--12. Mejor cliente (el que más nos compra) de cada país.
SELECT * FROM Customers
SELECT * FROM Orders
SELECT * FROM [Order Details]
--No muestra el que mas dinero se ha gastado, sino el que mas ha comprado (creo que se refiere a esto ultimo)
--Mostramos el nombre del cliente 
SELECT C.ContactName,SUM(OD.Quantity) AS[Compras], C.Country FROM Customers AS[C]
	INNER JOIN Orders AS[O] ON C.CustomerID = O.CustomerID
	INNER JOIN [Order Details] AS[OD] ON O.OrderID = OD.OrderID
	INNER JOIN(
	--El maximo de cada pais
	SELECT MAX(Prod.[Productos Comprados]) AS[Compras Pais], Country FROM (
	--Cantidad de productos que nos compra cada cliente de cada pais
		SELECT C.ContactName, SUM(OD.Quantity) AS[Productos Comprados], Country FROM Customers AS[C]
			INNER JOIN Orders AS[O] ON C.CustomerID = O.CustomerID
			INNER JOIN [Order Details] AS[OD] ON O.OrderID = OD.OrderID
		GROUP BY ContactName, Country) AS[Prod]
	GROUP BY Country) AS[Maxi] ON Maxi.Country = C.Country
GROUP BY C.Country, C.ContactName, Maxi.[Compras Pais]
HAVING SUM(OD.Quantity) = Maxi.[Compras Pais]

--13. Número de productos diferentes que nos compra cada cliente. Incluye el
--nombre y apellidos del cliente y su dirección completa.
SELECT * FROM Customers
SELECT * FROM Orders
SELECT * FROM [Order Details]
SELECT COUNT(DISTINCT OD.ProductID) AS[Productos Diferentes], C.ContactName, C.Address FROM Customers AS[C]
	INNER JOIN Orders AS[O] ON C.CustomerID = O.CustomerID
	INNER JOIN [Order Details] AS[OD] ON O.OrderID = OD.OrderID
		GROUP BY C.ContactName, C.Address

--14. Clientes que nos compran más de cinco productos diferentes.
SELECT COUNT(DISTINCT OD.ProductID) AS[Productos Diferentes], C.ContactName FROM Customers AS[C]
	INNER JOIN Orders AS[O] ON C.CustomerID = O.CustomerID
	INNER JOIN [Order Details] AS[OD] ON O.OrderID = OD.OrderID
		GROUP BY C.ContactName
			HAVING COUNT(DISTINCT OD.ProductID) > 5

--15. Vendedores (nombre y apellidos) que han vendido una mayor cantidad que la
--media en US $ en el año 97.
--Por ultimo muestro los que superen la media
SELECT SUM(OD.Quantity) AS[Media Vendida], E.FirstName, E.LastName FROM Employees AS[E]
			INNER JOIN Orders AS[O] ON E.EmployeeID = O.EmployeeID
			INNER JOIN [Order Details] AS[OD] ON O.OrderID = OD.OrderID
			WHERE YEAR(O.OrderDate) = 1997
			GROUP BY E.LastName, E.FirstName
			HAVING SUM(OD.Quantity) > (
	--Ahora calculo la media que hacen
	SELECT AVG(Total.[Media Vendida]) AS[Media]FROM (
		--Primero calculo lo que ha vendido cada uno de los vendedores
		SELECT SUM(OD.Quantity) AS[Media Vendida], E.FirstName, E.LastName FROM Employees AS[E]
			INNER JOIN Orders AS[O] ON E.EmployeeID = O.EmployeeID
			INNER JOIN [Order Details] AS[OD] ON O.OrderID = OD.OrderID
				WHERE YEAR(O.OrderDate) = 1997
				GROUP BY E.LastName, E.FirstName) AS[Total])

--16. Empleados que hayan aumentado su cifra de ventas más de un 10% entre dos
--años consecutivos, indicando el año en que se produjo el aumento.

