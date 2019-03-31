USE pubs

--Tienes que ir recorriendo la tabla con un bucle, leer cada fila y realizar la actualización que se indique.
--Si la columna TipoActualiza contiene una "I" hay que insertar una nueva fila en titles con todos los datos leídos de esa 
--fila de ActualizaTitles.
--Si TipoActualiza contiene una "D" hay que eliminar la fila cuyo código (title_id) se incluye.
--Si TipoActualiza es "U" hay que actualizar la fila identificada por title_id con las columnas que no sean Null. 
--Las que sean Null se dejan igual.
SELECT * FROM ActualizaTitles
SELECT * FROM titles
SELECT * FROM publishers
--Lo que hay que hacer es un bucle que segun TipoActualiza haga una cosa u otra.

BEGIN TRAN
DECLARE @cont TINYINT
SET @cont = 1

WHILE @cont <= 8
BEGIN
	IF (SELECT tipoActualiza FROM ActualizaTitles
			WHERE NumActualiza = @cont) = 'I'
		BEGIN 
			--Insertamos lo que nos pide.
			INSERT INTO Titles
			SELECT title_id, title, type,pub_id, price, advance, royalty, ytd_sales, notes, pubdate FROM ActualizaTitles
				WHERE NumActualiza = @cont 
		END-- Fin del si.
	IF (SELECT tipoActualiza FROM ActualizaTitles
			WHERE NumActualiza = @cont) = 'D'
		BEGIN 
			--Hay que borrar tambien lo realacionado con la tabla titleAuthor
			DELETE FROM titleauthor
				WHERE title_id IN (SELECT title_id FROM ActualizaTitles
										WHERE NumActualiza = @cont)
			--Borrar tambien lo ralacionado con la tabla sales
			DELETE FROM sales
				WHERE title_id IN (SELECT title_id FROM ActualizaTitles
										WHERE NumActualiza = @cont)
			--Me cago ya en varios dioses, de roysched tambien hay que borrar.
			DELETE FROM roysched
				WHERE title_id IN (SELECT title_id FROM ActualizaTitles
										WHERE NumActualiza = @cont)
			--Borramos lo que nos pide.
			DELETE FROM titles
				WHERE title_id IN (SELECT title_id FROM ActualizaTitles
										WHERE NumActualiza = @cont)
		END-- Fin del si.
	IF (SELECT tipoActualiza FROM ActualizaTitles
			WHERE NumActualiza = @cont) = 'U'
			--Actualizo lo que me pide


	PRINT @COnt

	--Actualizar el contador a 1 numero mas.
	SET @cont = @cont +1
END --fin del while

ROLLBACK