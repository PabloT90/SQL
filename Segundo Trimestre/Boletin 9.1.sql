use Northwind
--Nombre de los proveedores y n�mero de productos que nos vende cada uno
SELECT * FROM Suppliers
SELECT * FROM Products
SELECT S.ContactName, COUNT(P.SupplierID) AS[Numero Productos] FROM Suppliers AS[S]
INNER JOIN Products AS[P] ON S.SupplierID = P.SupplierID
	GROUP BY ContactName
		ORDER BY [Numero Productos]

--Nombre completo y telefono de los vendedores que trabajen en New York, Seattle, Vermont, Columbia, Los Angeles, Redmond o Atlanta.
SELECT * FROM Employees
SELECT * FROM EmployeeTerritories
SELECT * FROM Territories
SELECT DISTINCT E.FirstName, E.LastName, E.HomePhone FROM Employees AS[E]
INNER JOIN EmployeeTerritories AS[ET] ON  E.EmployeeID = ET.EmployeeID
INNER JOIN Territories AS[T] ON T.TerritoryID = ET.TerritoryID
	WHERE T.TerritoryDescription IN('New York','Seattle','Vermont','Columbia',' Los Angeles','Redmond','Atlanta')

--N�mero de productos de cada categor�a y nombre de la categor�a.
SELECT * FROM Categories
SELECT * FROM Products
SELECT COUNT(P.CategoryID) AS[Numero Productos], C.CategoryName FROM Products AS[P]
INNER JOIN Categories AS[C] ON C.CategoryID = P.CategoryID
	GROUP BY c.CategoryName

--Nombre de la compa��a de todos los clientes que hayan comprado queso de cabrales o tofu.
SELECT * FROM Products
SELECT * FROM Customers
SELECT DISTINCT C.CompanyName, P.ProductName FROM Customers AS[C]
	INNER JOIN Orders AS[O] ON O.CustomerID = C.CustomerID
	INNER JOIN [Order Details] AS[OD] ON OD.OrderID = O.OrderID
	INNER JOIN Products AS[P] ON P.ProductID = OD.ProductID
		WHERE P.ProductName IN('Queso cabrales','Tofu')

--Empleados (ID, nombre, apellidos y tel�fono) que han vendido algo a Bon app' o Meter Franken.
SELECT * FROM Employees
SELECT * FROM Orders
SELECT * FROM Customers
SELECT DISTINCT E.EmployeeID, E.LastName, E.FirstName, E.HomePhone FROM Employees AS[E]
	INNER JOIN Orders AS[O] ON E.EmployeeID = O.EmployeeID
	INNER JOIN Customers AS[C] ON O.CustomerID = C.CustomerID
		WHERE CompanyName IN('Bon app''','Meter Franken')

--Empleados (ID, nombre, apellidos, mes y d�a de su cumplea�os) que no han vendido nunca nada a ning�n cliente de Francia. *
--Se necesitan subconsultas (aun no dadas)

--Total de ventas en US$ de productos de cada categor�a (nombre de la categor�a).
SELECT * FROM Categories
SELECT * FROM Products
SELECT * FROM [Order Details]
SELECT C.CategoryName, SUM(OD.Quantity*OD.UnitPrice) as[Total $] FROM [Order Details] AS[OD]
	INNER JOIN Products AS[P] ON OD.ProductID = P.ProductID
	INNER JOIN Categories AS[C] ON C.CategoryID = P.CategoryID
		GROUP BY C.CategoryName

--Total de ventas en US$ de cada empleado cada a�o (nombre, apellidos, direcci�n).
SELECT * FROM Employees
SELECT * FROM Orders
SELECT * FROM [Order Details]
SELECT SUM(UnitPrice*Quantity) AS[Total $], E.FirstName, E.LastName, E.Address, YEAR(O.OrderDate) AS[A�o]  FROM [Order Details] AS[OD]
	INNER JOIN Orders AS[O] ON OD.OrderID = O.OrderID
	INNER JOIN Employees AS[E] ON O.EmployeeID = E.EmployeeID
		GROUP BY E.EmployeeID, E.FirstName, E.LastName, E.Address, YEAR(O.OrderDate)
			ORDER BY YEAR(O.OrderDate)

--Ventas de cada producto en el a�o 97. Nombre del producto y unidades.
SELECT * FROM Products
SELECT * FROM [Order Details]
SELECT * FROM Orders
SELECT SUM(OD.Quantity) AS[Total Producto], P.ProductName FROM Orders AS[O]
	INNER JOIN [Order Details] as[OD] ON O.OrderID = OD.OrderID
	INNER JOIN Products AS[P] ON OD.ProductID = P.ProductID
		WHERE YEAR(O.OrderDate) = 1997
		GROUP BY P.ProductName

--Cu�l es el producto del que hemos vendido m�s unidades en cada pa�s. *
--Se necesitan subconsultas (aun no dadas)

--Empleados (nombre y apellidos) que trabajan a las �rdenes de Andrew Fuller.
SELECT * FROM Employees
SELECT LastName, FirstName FROM Employees
	WHERE ReportsTo = 2 --Esta forma no me gusta pero es las mas facil en esta situacion

--N�mero de subordinados que tiene cada empleado, incluyendo los que no tienen ninguno. Nombre, apellidos, ID.

