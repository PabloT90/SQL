--Tabla de pruebas:
USE Ejemplos
GO
CREATE TABLE Palabras (
ID SmallInt Not Null Identity Constraint PK_Palabras Primary Key
,Palabra VarChar(30) Null
) 

--Iniciación:
--Sin usar datos modificados
--1.- Queremos que cada vez que se actualice la tabla Palabras aparezca un mensaje diciendo si
--se han añadido, borrado o actualizado filas.
--Pista: Crea tres triggers diferentes
GO
CREATE TRIGGER HaAnadido ON Palabras AFTER INSERT AS
BEGIN
	PRINT 'Se ha anadido.'
END
GO

GO
CREATE TRIGGER HaActualizado ON Palabras AFTER UPDATE AS
BEGIN
	PRINT 'Se ha actualizado.'
END
GO

GO
CREATE TRIGGER HaBorrrado ON Palabras AFTER DELETE AS
BEGIN
	PRINT 'Se ha borrado.'
END
GO

--2.- Haz un trigger que cada vez que se aumente o disminuya el número de filas de la tabla
--Palabras nos diga cuántas filas hay.
GO
CREATE TRIGGER NumeroFilas ON Palabras AFTER UPDATE AS
BEGIN
	DECLARE @filas INT
	SET @filas = (SELECT * FROM Palabras)

	PRINT 'Numero de filas' + @filas
END
GO

--Medio:
--Se usan inserted y deleted. Si es complicado procesar varias filas, supón
--que se modifica sólo una.
--3.- Cada vez que se inserte una fila queremos que se muestre un mensaje indicando
--“Insertada la palabra ________”
SELECT * FROM Palabras
GO
CREATE TRIGGER PalabraInsertada ON Palabras AFTER INSERT AS
BEGIN
	DECLARE @palabra varchar(10)
	DECLARE @cont SMALLINT
	SELECT @cont=MIN(ID) from inserted

	WHILE @cont IS NOT NULL
	BEGIN
		--Muestro las palabras que se han insertado.
		SELECT @palabra = palabra FROM inserted
			WHERE ID = @cont
		PRINT 'Insertada palabra: ' + @palabra

		--Actualizo el contador
		SELECT @cont=MIN(ID) FROM inserted
			WHERE @cont < ID
	END --Fin del bucle while
END
GO

--Pruebas
BEGIN TRAN 
INSERT INTO Palabras VALUES
('palabra1'),('palabra2'),('palabra3')
ROLLBACK
SELECT * FROM Palabras


--4.- Cada vez que se inserten filas que nos diga “XX filas insertadas”
GO
CREATE TRIGGER FilasInsertadas ON Palabras AFTER INSERT AS
BEGIN
	DECLARE @numFilas SMALLINT
	SET @numFilas = (SELECT COUNT(*) FROM inserted)
	PRINT CAST(@numFilas AS VARCHAR) + ' filas insertadas'
END
GO

--Pruebas
BEGIN TRAN
INSERT INTO Palabras VALUES
('palabra1'),
('palabra2'),
('palabra3')
INSERT INTO Palabras VALUES
('palabra1'),
('palabra2'),
('palabra3')
ROLLBACK

--5.- que no permita introducir palabras repetidas (sin usar UNIQUE).
GO
--Este está mal
ALTER TRIGGER NoRepes ON Palabras AFTER INSERT AS
BEGIN
	DECLARE @palabra varchar(10)
	DECLARE @cont SMALLINT
	SELECT @cont=MIN(ID) from inserted

	WHILE @cont IS NOT NULL
	BEGIN
		--Guardo una palabra de la pseudotabla inserted
		SELECT @palabra = palabra FROM inserted
			WHERE ID = @cont

		--Busco si esta repetida. En tal caso muestro el mensaje
		IF EXISTS(SELECT * FROM Palabras
			WHERE Palabra = @palabra AND ID <> @cont) --No puede tener el mismo ID que el de inserted
		BEGIN
			ROLLBACK
			PRINT 'La palabra: ' + @palabra + ' esta repetida'
		END --Fin del si

		--Actualizo el contador
		SELECT @cont=MIN(ID) FROM inserted
			WHERE @cont < ID
	END --Fin del bucle while
END
GO

--Pruebas
BEGIN TRAN
INSERT INTO Palabras VALUES
('palabra1'),('palabra2'),('palabra3')
BEGIN TRAN
INSERT INTO Palabras VALUES
('palabra1'),('palabra2'),('palabra3')
ROLLBACK
SELECT * FROM Palabras
DELETE FROM Palabras


----Sobre LeoMetro--
USE LeoMetroV2
--6.- Comprueba que un pasajero no pueda entrar o salir por la misma estación más de tres veces el mismo día
SELECT * FROM LM_Viajes
GO
CREATE TRIGGER NoMasDeTres ON LM_Viajes AFTER INSERT AS
BEGIN
	DECLARE @entradas INT
	DECLARE @tarjeta INT
	DECLARE @salidas INT
	DECLARE @fechaE DATE
	DECLARE @fechaS DATE
	DECLARE @cont INT
	SELECT @cont=MIN(ID) from inserted

	WHILE @cont IS NOT NULL
	BEGIN
		--Obtengo el ID de la tarjeta
		SET @tarjeta = (SELECT IDtarjeta FROM inserted WHERE ID = @cont)

		--Obtengo la fecha de entrada
		SET @fechaE = (SELECT CAST(MomentoEntrada AS DATE) FROM inserted WHERE ID = @cont)

		--Obtengo la fecha de salida
		SET @fechaS = (SELECT CAST(MomentoSalida AS DATE) FROM inserted WHERE ID = @cont)

		--Cuento las veces ha entrado por una estacion ese dia
		SET @entradas = (SELECT COUNT(IDEstacionEntrada) FROM LM_Viajes
							WHERE IDTarjeta = @tarjeta AND CAST(MomentoEntrada AS DATE) = @fechaE
						GROUP BY IDTarjeta)
		--Cuento las veces que ha salido por una estacion ese dia
		SET @salidas = (SELECT COUNT(IDEstacionSalida) FROM LM_Viajes
							WHERE IDTarjeta = @tarjeta AND CAST(MomentoSalida AS DATE) = @fechaS
						GROUP BY IDTarjeta)
		
		--Si ha entrado o salido mas de 3 veces no deja insertar.
		IF(@entradas > 3 OR @salidas > 3)
			ROLLBACK

		SELECT @cont=MIN(ID) FROM inserted
			WHERE @cont < ID
	END-- Fin del while
END
GO
--Pruebas
SET DATEFORMAT ymd
BEGIN TRAN
INSERT INTO LM_Viajes VALUES
(1,1,6, '2017-02-24 16:50:00','2017-02-24 17:50:00', 1.75),
(1,1,6, '2017-03-24','2017-03-24', 1.75)
ROLLBACK

--7.- Haz un trigger que al insertar un viaje compruebe que no hay otro viaje simultáneo
SELECT * FROM LM_Viajes
GO
CREATE TRIGGER NoSimultaneos ON LM_Viajes AFTER INSERT AS
BEGIN
	IF EXISTS (SELECT * FROM LM_Viajes AS [V]
				CROSS JOIN inserted AS [I]
				WHERE I.ID <> V.ID --El ID insertado sea diferente
				AND (I.MomentoEntrada BETWEEN V.MomentoEntrada AND V.MomentoSalida
				OR I.MomentoSalida BETWEEN V.MomentoEntrada AND V.MomentoSalida
				OR I.MomentoEntrada < V.MomentoEntrada AND I.MomentoSalida > V.MomentoSalida))
	BEGIN
		ROLLBACK
		RAISERROR ('Viaje simultaneo detectado', 16,1) --Lanzamos una excepcion.
	END --Fin_si
END --Fin_trigger
GO

--Avanzado:
--Se incluye la posibilidad de que se modifiquen varias filas y de que haya
--que consultar otras tablas.
--8.- Queremos evitar que se introduzcan palabras que terminen en “azo”
USE Ejemplos
GO
CREATE TRIGGER PalabrasSinAZO ON Palabras AFTER INSERT AS
BEGIN
	IF EXISTS(SELECT * FROM inserted WHERE Palabra LIKE('%azo'))
		ROLLBACK
END
GO

----Sobre LeoFest--
--9.- Cuando se inserte una nueva actuación de una banda hemos de comprobar que la banda
--no se ha disuelto en esa fecha.


--10 .- Comprueba mediante un trigger que en una edición no actúan más de tres bandas de la
--misma categoría. 

