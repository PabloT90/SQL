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


--5.Número de productos de cada categoría


--6.Igual a la anterior, pero considerando las categorías generales (categorías de categorías).


--7.Número de unidades vendidas de cada producto cada año.


--8.Nombre completo, compañía y total facturado a cada cliente


--9.Número de producto, nombre y precio de todos aquellos en cuya descripción aparezcan las palabras "race”, "competition” o 
--"performance”


--10.Facturación total en cada país


--11.Facturación total en cada Estado


--12.Margen medio de beneficios y total facturado en cada país

