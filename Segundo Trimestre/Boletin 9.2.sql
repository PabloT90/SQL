USE Northwind
--1. N�mero de clientes de cada pa�s.
SELECT * FROM Customers
SELECT COUNT(Country) AS[Clientes], country FROM Customers
	GROUP BY Country
		ORDER BY Clientes

--2. N�mero de clientes diferentes que compran cada producto. Incluye el nombre
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

--3. N�mero de pa�ses diferentes en los que se vende cada producto. Incluye el
--nombre del producto


--4. Empleados (nombre y apellido) que han vendido alguna vez
--�Gudbrandsdalsost�, �Lakkalik��ri�, �Tourti�re� o �Boston Crab Meat�.


--5. Empleados que no han vendido nunca �Northwoods Cranberry Sauce� o
--�Carnarvon Tigers�.


--6. N�mero de unidades de cada categor�a de producto que ha vendido cada
--empleado. Incluye el nombre y apellidos del empleado y el nombre de la
--categor�a.


--7. Total de ventas (US$) de cada categor�a en el a�o 97. Incluye el nombre de la
--categor�a.


--8. Productos que han comprado m�s de un cliente del mismo pa�s, indicando el
--nombre del producto, el pa�s y el n�mero de clientes distintos de ese pa�s que
--lo han comprado.


--9. Total de ventas (US$) en cada pa�s cada a�o.


--10. Producto superventas de cada a�o, indicando a�o, nombre del producto,
--categor�a y cifra total de ventas.

--Ventas de los productos por a�o
SELECT * FROM Orders
SELECT * FROM [Order Details]
SELECT * FROM Products

SELECT P.ProductName, P.CategoryID, YEAR(O.OrderDate) AS[A�o],SUM(OD.Quantity*OD.UnitPrice) AS[Importe] FROM Products AS[P]
	INNER JOIN [Order Details] AS[OD] ON P.ProductID = OD.ProductID
	INNER JOIN Orders AS[O] ON OD.OrderID = O.OrderID
	INNER JOIN( SELECT Prod.A�o, MAX(Prod.Importe) AS[Importe Maximo de un producto] FROM(
		SELECT P.ProductID, YEAR(O.OrderDate) AS[A�o], SUM(OD.Quantity*OD.UnitPrice) AS[importe] FROM Products AS[P]
		INNER JOIN[Order Details] AS[OD] ON P.ProductID = OD.ProductID
		INNER JOIN Orders AS[O] on OD.OrderID = O.OrderID
			GROUP BY P.ProductID, YEAR(O.OrderDate))AS [Prod]
		GROUP BY Prod.A�o) AS[ORR] ON YEAR(O.OrderDate) = ORR.A�o
		GROUP BY P.ProductName, P.CategoryID, YEAR(OrderDate), ORR.[Importe Maximo de un producto]
		HAVING SUM(OD.Quantity*OD.UnitPrice) = ORR.[Importe Maximo de un producto]

--11. Cifra de ventas de cada producto en el a�o 97 y su aumento o disminuci�n
--respecto al a�o anterior en US $ y en %.


--12. Mejor cliente (el que m�s nos compra) de cada pa�s.


--13. N�mero de productos diferentes que nos compra cada cliente. Incluye el
--nombre y apellidos del cliente y su direcci�n completa.


--14. Clientes que nos compran m�s de cinco productos diferentes.


--15. Vendedores (nombre y apellidos) que han vendido una mayor cantidad que la
--media en US $ en el a�o 97.


--16. Empleados que hayan aumentado su cifra de ventas m�s de un 10% entre dos
--a�os consecutivos, indicando el a�o en que se produjo el aumento.

