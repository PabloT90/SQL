--1. T�tulo y tipo de todos los libros en los que alguno de los autores vive en California (CA).
SELECT * FROM titles
SELECT * FROM titleauthor
SELECT * FROM authors
SELECT DISTINCT T.type, T.title FROM titles AS[T]
	INNER JOIN titleauthor AS[TA] ON T.title_id = TA.title_id
	INNER JOIN authors AS[A] ON TA.au_id = A.au_id
	WHERE A.State = 'CA'

--2. T�tulo y tipo de todos los libros en los que ninguno de los autores vive en California (CA).
SELECT type, title FROM titles
except
SELECT T.type, T.title FROM titles AS[T]
	INNER JOIN titleauthor AS[TA] ON T.title_id = TA.title_id
	INNER JOIN authors AS[A] ON TA.au_id = A.au_id
	WHERE A.state = 'CA'

--3. N�mero de libros en los que ha participado cada autor, incluidos los que no han publicado nada.
SELECT * FROM Titles
SELECT * FROM titleauthor
SELECT DISTINCT A.au_id, COUNT(TA.title_id) as[Numero Libros] FROM titles AS[T]
	LEFT JOIN titleauthor AS[TA] ON T.title_id = TA.title_id
	LEFT JOIN authors AS[A] ON A.au_id = TA.au_id
	GROUP BY A.au_id
--4. N�mero de libros que ha publicado cada editorial, incluidas las que no han publicado ninguno.
--5. N�mero de empleados de cada editorial.
--6. Calcular la relaci�n entre n�mero de ejemplares publicados y n�mero de empleados de cada editorial, 
--incluyendo el nombre de la misma.
SELECT * FROM Employee
SELECT * FROM publishers
SELECT * FROM Titles
SELECT P.pub_name,CAST(COUNT(DISTINCT T.title_id)AS REAL)/COUNT(DISTINCT E.emp_id) AS [Ejemplares publicados/Empleados],COUNT(distinct E.emp_id) AS [Numero de empleados]
	FROM publishers AS P
	INNER JOIN employee AS E ON P.pub_id = E.pub_id
	LEFT JOIN titles AS T ON T.pub_id = P.pub_id
		GROUP BY P.pub_name

--7. Nombre, Apellidos y ciudad de todos los autores que han trabajado para la editorial "Binnet & Hardley� o "Five Lakes Publishing�
--8. Empleados que hayan trabajado en alguna editorial que haya publicado alg�n libro en el que alguno de los autores fuera Marjorie Green o Michael O'Leary.
--9. N�mero de ejemplares vendidos de cada libro, especificando el t�tulo y el tipo.

--10. N�mero de ejemplares de todos sus libros que ha vendido cada autor.
SELECT * FROM Authors
SELECT * FROM titleauthor
SELECT * FROM titles
--Ventas totales de cada autor
SELECT SUM(V.[Cantidad Vendida]) AS[Total Vendido], au_fname, au_lname FROM Authors AS[A]
INNER JOIN titleauthor AS[TA] ON A.au_id = TA.AU_ID
INNER JOIN Titles AS[T] ON TA.title_id = t.title_id
INNER JOIN(
	--Ventas de cada libro.
	SELECT SUM(S.qty) AS[Cantidad Vendida], title FROM titles AS[T]
		INNER JOIN sales AS[S] ON T.title_id = S.title_id
	GROUP BY T.title) AS[V] ON V.title = T.title
GROUP BY au_fname, au_lname


--11. N�mero de empleados de cada categor�a (jobs).

--12. N�mero de empleados de cada categor�a (jobs) que tiene cada editorial, incluyendo aquellas categor�as en las que no haya ning�n empleado.

--13. Autores que han escrito libros de dos o m�s tipos diferentes

--14. Empleados que no trabajan actualmente en editoriales que han publicado libros cuya columna notes contenga la palabra "and�