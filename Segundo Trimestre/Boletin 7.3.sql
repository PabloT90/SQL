--Título, precio y notas de los libros (titles) que tratan de cocina, ordenados de mayor a menor precio.
SELECT * FROM TITLES
SELECT title, price, notes FROM titles
	WHERE type IN('mod_cook','trad_cook')
		ORDER BY price desc

--ID, descripción y nivel máximo y mínimo de los puestos de trabajo (jobs) que pueden tener un nivel 110.
SELECT * FROM JOBS
SELECT * FROM JOBS
	WHERE 110 BETWEEN min_lvl AND max_lvl

--Título, ID y tema de los libros que contengan la palabra "and” en las notas
SELECT * FROM TITLES
SELECT title, title_id, type FROM TITLES
	WHERE Notes like('%and%')

--Nombre y ciudad de las editoriales (publishers) de los Estados Unidos que no estén en California ni en Texas
SELECT * FROM PUBLISHERS
SELECT pub_name, city FROM publishers
	WHERE COUNTRY in('USA') and State NOT IN ('TX','CA')

--Título, precio, ID de los libros que traten sobre psicología o negocios y cuesten entre diez y 20 dólares.
SELECT * FROM titles
SELECT title, price, title_id FROM Titles
	WHERE price between 10 and 20 AND Type in('psychology','business')

--Nombre completo (nombre y apellido) y dirección completa de todos los autores que no viven en California ni en Oregón.
SELECT * FROM Authors
SELECT au_fname, au_lname, address FROM Authors
	WHERE State NOT IN('CA','OR')

--Nombre completo y dirección completa de todos los autores cuyo apellido empieza por D, G o S.
SELECT au_fname, au_lname, address FROM Authors
	WHERE au_lname LIKE('[DGS]%')

--ID, nivel y nombre completo de todos los empleados con un nivel inferior a 100, ordenado alfabéticamente
SELECT * FROM Employee
SELECT emp_id, job_lvl, fname, lname FROM Employee
	WHERE job_lvl < 100 
		ORDER BY lname

--Modificaciones de datos
--Inserta un nuevo autor.
SELECT * FROM Authors
BEGIN TRAN	
INSERT INTO Authors VALUES
	('172-32-1175','Prats','Pablo','408 496-7223','10932 Bigge Rd','Menlo Park','CA',94025,1)
COMMIT TRAN
--Inserta dos libros, escritos por el autor que has insertado antes y publicados por la editorial "Ramona publishers”.


--Modifica la tabla jobs para que el nivel mínimo sea 90.
ALTER TABLE Jobs DROP CONSTRAINT CK__jobs__min_lvl__2C3393D0

UPDATE JOBS
	SET min_lvl = 90
		WHERE min_lvl < 90 --Emosido engañados

ALTER TABLE JOBS ADD CONSTRAINT CK__jobs__min_lvl__2C3393D1 CHECK(min_lvl >=90)

--Crea una nueva editorial (publihers) con ID 9908, nombre Mostachon Books y sede en Utrera.


--Cambia el nombre de la editorial con sede en Alemania para que se llame "Machen Wücher" y traslasde su sede a Stuttgart