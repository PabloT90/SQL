--1. Nombre de la compa��a y direcci�n completa (direcci�n, cuidad, pa�s) de todos los
--clientes que no sean de los Estados Unidos.
SELECT contactName, Address,city, Country, CompanyName FROM Customers
	WHERE Country <> 'USA'

--2. La consulta anterior ordenada por pa�s y ciudad.
SELECT contactName, Address,city, Country, CompanyName FROM Customers
	WHERE Country <> 'USA'
		ORDER BY Country, city

--3. Nombre, Apellidos, Ciudad y Edad de todos los empleados, ordenados por antig�edad en la empresa.
SELECT FirstName,LastName, city, (year(CURRENT_TIMESTAMP-BirthDate)) - 1900 AS [Edad] FROM Employees
	ORDER BY HireDate desc

--4. Nombre y precio de cada producto, ordenado de mayor a menor precio.


--5. Nombre de la compa��a y direcci�n completa de cada proveedor de alg�n pa�s de Am�rica del Norte.


--6. Nombre del producto, n�mero de unidades en stock y valor total del stock, de los
--productos que no sean de la categor�a 4.


--7. Clientes (Nombre de la Compa��a, direcci�n completa, persona de contacto) que no
--residan en un pa�s de Am�rica del Norte y que la persona de contacto no sea el
--propietario de la compa��a 