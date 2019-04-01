USE pubs
--Tienes que ir recorriendo la tabla con un bucle, leer cada fila y realizar la actualización que se indique.
--Si la columna TipoActualiza contiene una "I" hay que insertar una nueva fila en titles con todos los datos leídos de esa 
--fila de ActualizaTitles.
--Si TipoActualiza contiene una "D" hay que eliminar la fila cuyo código (title_id) se incluye.
--Si TipoActualiza es "U" hay que actualizar la fila identificada por title_id con las columnas que no sean Null. 
--Las que sean Null se dejan igual.

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
			UPDATE titles
				SET
					title_id = isnull(AT.title_id,T.title_id),
					title = isnull(AT.title,T.title),
					type =  isnull(AT.type,T.type),
					pub_id = isnull(AT.pub_id,T.pub_id),
					price = isnull(AT.price,T.price),
					advance = isnull(AT.advance,T.advance),
					royalty = isnull(AT.royalty,T.royalty),
					ytd_sales = isnull(AT.ytd_sales,T.ytd_sales),
					notes = isnull(AT.notes,T.notes),
					pubdate = isnull(AT.pubdate,T.pubdate)
				FROM ActualizaTitles AS AT
					INNER JOIN titles AS[T] ON T.title_id = AT.title_id
				WHERE NumActualiza = @cont
	--Actualizar el contador a 1 numero mas.
	SET @cont = @cont +1
END --fin del while

ROLLBACK