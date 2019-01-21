--1.Nombre del producto, código y precio, ordenado de mayor a menor precio
SELECT * FROM Production.Product
SELECT name,ProductID,ListPrice FROM Production.Product
	ORDER BY ListPrice

--2.Número de direcciones de cada Estado/Provincia
SELECT * FROM Person.Address
SELECT COUNT(*) as[Numero Direcciones], StateProvinceID FROM Person.Address
	GROUP BY StateProvinceID

--3.Nombre del producto, código, número, tamaño y peso de los productos que estaban a la venta durante todo el mes de 
--septiembre de 2002. No queremos que aparezcan aquellos cuyo peso sea superior a 2000.
SELECT * FROM Production.Product
SELECT name,ProductID,ProductNumber, size,Weight FROM Production.Product
	WHERE YEAR(SellStartDate)=2002 AND MONTH(SellStartDate)=8 or Weight < 2000

--4.Margen de beneficio de cada producto (Precio de venta menos el coste), y porcentaje que supone respecto del precio de venta.
SELECT * FROM Production.Product
SELECT ListPrice-StandardCost AS[Beneficio],(ListPrice*100)/StandardCost-100 AS[Porcentaje Beneficio] FROM Production.Product
	WHERE StandardCost <> 0 --Para no obtener una division entre 0
		ORDER BY [Porcentaje Beneficio]

--5.Número de productos de cada categoría
SELECT * FROM Production.Product
SELECT ProductSubcategoryID, COUNT(ProductSubcategoryID) AS[Productos Categoria] FROM Production.Product
	GROUP BY ProductSubcategoryID
		ORDER BY ProductSubcategoryID

--6.Igual a la anterior, pero considerando las categorías generales (categorías de categorías).
--No entiendo que pide.
SELECT * FROM Production.ProductCategory

--7.Número de unidades vendidas de cada producto cada año.
SELECT * FROM Sales.SalesOrderDetail
SELECT ProductID,YEAR(ModifiedDate) AS[Ano], COUNT(ProductID)+SUM(OrderQty) AS[Unidades vendidas] FROM Sales.SalesOrderDetail
	GROUP BY ProductID, YEAR(ModifiedDate)
		ORDER BY YEAR(ModifiedDate),ProductID --No vea si ha costado

--8.Nombre completo, compañía y total facturado a cada cliente
SELECT * FROM Person.Person
SELECT * FROM Sales.Customer
SELECT * FROM Sales.Store
SELECT P.FirstName, P.LastName, S.Name FROM Person.Person AS[P] 
INNER JOIN Sales.Customer AS[C] ON P.BusinessEntityID = C.PersonID
INNER JOIN Sales.Store AS[S] ON C.StoreID = S.BusinessEntityID

--9.Número de producto, nombre y precio de todos aquellos en cuya descripción aparezcan las palabras "race”, "competition” o 
--"performance”


--10.Facturación total en cada país


--11.Facturación total en cada Estado


--12.Margen medio de beneficios y total facturado en cada país

