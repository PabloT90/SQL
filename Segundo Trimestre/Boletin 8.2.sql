--1. Numero de libros que tratan de cada tema
SELECT * FROM titles
SELECT COUNT(type) AS[Libros Temas] FROM titles
	GROUP BY Type

--2. Número de autores diferentes en cada ciudad y estado
SELECT * FROM authors
SELECT city, COUNT(city) AS[Nº Autores]  FROM authors
	GROUP BY city

--3. Nombre, apellidos, nivel y antigüedad en la empresa de los empleados con un nivel entre 100 y 150.
SELECT * FROM Employee
SELECT fname,lname, job_lvl, DATEDIFF(DAY,hire_date,CURRENT_TIMESTAMP) AS[Antiguedad] FROM Employee
	WHERE job_lvl BETWEEN 100 AND 150

--4. Número de editoriales en cada país. Incluye el país.
SELECT * FROM publishers
SELECT country,COUNT(country) AS[Editoriales en el Pais] FROM publishers
	GROUP BY country

--5. Número de unidades vendidas de cada libro en cada año (title_id, unidades y año).
SELECT * FROM Sales
SELECT YEAR(ord_date) AS[Año], SUM(qty)  AS[Libros Vendidos] FROM Sales
	GROUP BY YEAR(ord_date)

--6. Número de autores que han escrito cada libro (title_id y numero de autores).
SELECT * FROM titleauthor
SELECT DISTINCT title_id, MAX(au_ord) AS[Cantidad Autores] FROM titleauthor
	GROUP BY title_id
		ORDER BY [Cantidad Autores] ASC

--7. ID, Titulo, tipo y precio de los libros cuyo adelanto inicial (advance) tenga un valor superior a $7.000,
--ordenado por tipo y título
SELECT * FROM titles
SELECT title_id, title, type,price FROM titles
	WHERE advance >= 7000
		ORDER BY type, title
