--1. Nombre de la compañía y dirección completa (dirección, cuidad, país) de todos los
--clientes que no sean de los Estados Unidos.
SELECT contactName, Address,city, Country, CompanyName FROM Customers
	WHERE Country <> 'USA'

--2. La consulta anterior ordenada por país y ciudad.
SELECT contactName, Address,city, Country, CompanyName FROM Customers
	WHERE Country <> 'USA'
		ORDER BY Country, city

--3. Nombre, Apellidos, Ciudad y Edad de todos los empleados, ordenados por antigüedad en la empresa.
SELECT FirstName,LastName, city, (year(CURRENT_TIMESTAMP-BirthDate)) - 1900 AS [Edad] FROM Employees
	ORDER BY HireDate desc

--4. Nombre y precio de cada producto, ordenado de mayor a menor precio.


--5. Nombre de la compañía y dirección completa de cada proveedor de algún país de América del Norte.


--6. Nombre del producto, número de unidades en stock y valor total del stock, de los
--productos que no sean de la categoría 4.


--7. Clientes (Nombre de la Compañía, dirección completa, persona de contacto) que no
--residan en un país de América del Norte y que la persona de contacto no sea el
--propietario de la compañía 