                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                USE LeoMetroV2
SET DATEFORMAT YMD
--Ejercicio 0
--La dimisión de Esperanza Aguirre ha causado tal conmoción entre los directivos de LeoMetro que han decidido conceder una 
--amnistía a todos los pasajeros que tengan un saldo negativo en sus tarjetas.
--Crea un procedimiento que racargue la cantidad necesaria para dejar a 0 el saldo de las tarjetas que tengan un saldo negativo 
--y hayan sido recargadas al menos una vez en los últimos dos meses.
--Ejercicio elaborado en colaboración con Sefran.
SELECT * FROM LM_Recargas
SELECT * FROM LM_Tarjetas
GO
CREATE PROCEDURE RecargarSaldo AS
BEGIN

	DECLARE @cantidad SMALLMONEY
	SET @cantidad = (SELECT Saldo FROM LM_Tarjetas WHERE )

	UPDATE LM_Tarjetas
	SET Saldo = Saldo - (@cantidad)
	FROM LM_Tarjetas AS[T]
		INNER JOIN LM_Recargas AS[R] ON T.ID = R.ID_Tarjeta
	WHERE Saldo < 0  AND YEAR(Momento_Recarga) = YEAR(CURRENT_TIMESTAMP) AND (MONTH(CURRENT_TIMESTAMP)-MONTH(Momento_Recarga)) < 2 --Asi es un poco mierda pero weno.
END
GO
--Ejercicio 1
--Crea un procedimiento RecargarTarjeta que reciba como parámetros el ID de una tarjeta y un importe y actualice el saldo 
--de la tarjeta sumándole dicho importe, además de grabar la correspondiente recarga

--Nombre: RecargarTarjeta
--Entradas: int ID, importe SMALLMONEY
--Salidas: no hay.
--Precondiciones: el importe debe ser positivo.
--Precondiciones: actualiza el saldo a una tarjeta e inserta un nuevo registro de recarga.
GO
CREATE PROCEDURE RecargarTarjeta (@ID INT, @importe SMALLMONEY) AS
BEGIN
	DECLARE @saldoResultante SMALLMONEY
	--Actualizo el saldo sumandole el importe.
	UPDATE LM_Tarjetas
	SET Saldo = Saldo + @Importe
	WHERE ID = @ID
	--Obtengo el saldo que tiene despues de actualizarlo.
	SET @SaldoResultante = (SELECT Saldo FROM LM_Tarjetas WHERE ID = @ID)
	--Inserto una nueva recarga.
	INSERT INTO LM_Recargas VALUES
	(newID(), @ID, @Importe, CURRENT_TIMESTAMP, @SaldoResultante)
END
GO

--Ejercicio 2
--Crea un procedimiento almacenado llamado PasajeroSale que reciba como parámetros el ID de una tarjeta, el ID de una estación(salida) 
--y una fecha/hora (opcional). El procedimiento se llamará cuando un pasajero pasa su tarjeta por uno de los tornos de salida del metro. 
--Su misión es grabar la salida en la tabla LM_Viajes. Para ello deberá localizar la entrada que corresponda, que será la última 
--entrada correspondiente al mismo pasajero y hará un update de las columnas que corresponda. Si no existe la entrada, grabaremos 
--una nueva fila en LM_Viajes dejando a NULL la estación y el momento de entrada y cobraremos por la estacion de la zona 1.
--Si se omite el parámetro de la fecha/hora, se tomará la actual.
SELECT * FROM LM_Viajes
GO
CREATE PROCEDURE PasajeroSale (@ID INT, @IDestacion SMALLINT, @fecha SMALLDATETIME) AS
BEGIN
	--Si es opcional se pone asi en caso de ser una fecha:
	IF @fecha = NULL
		SET @fecha = GETDATE() --No se puede poner en la entrada de parametros porque es una funcion.


END
GO

--Ejercicio 3
--A veces, un pasajero reclama que le hemos cobrado un viaje de forma indebida. Escribe un procedimiento que reciba como 
--parámetro el ID de un pasajero y la fecha y hora de la entrada en el metro y anule ese viaje, actualizando además el saldo 
--de la tarjeta que utilizó.
/*
Nombre: ReclamarCobro
Cabecera: CREATE PROCEDURE ReclamarCobro @IDpasajero INT, @fecha SMALLDATETIME AS
Entrada: IDpasajero INT, fecha SMALLDATETIME
Precondiciones:
	- El IDpasajero tiene que existir.
Salida: no hay.
*/
GO
CREATE PROCEDURE ReclamarCobro (@IDpasajero INT, @fecha SMALLDATETIME) AS
BEGIN
	--Establezco el dinero a devolver
	DECLARE @dineroADevolver SMALLMONEY
	SET @dineroADevolver = (SELECT Importe_Viaje FROM LM_Viajes WHERE ID = @IDpasajero AND MomentoEntrada = @fecha)
	--Añado el dinero del viaje
	UPDATE LM_Tarjetas
	SET Saldo = Saldo + @dineroADevolver
	WHERE ID = @IDpasajero
	--Borro el registro de ese viaje.
	DELETE FROM LM_Viajes
	WHERE IDTarjeta = @IDpasajero AND MomentoEntrada = @fecha
END
GO

--EXECUTE ReclamarCobro 1,'2017-02-24 16:50' --Asi no funciona, da error

--Asi no da error.
BEGIN TRAN
DECLARE @Fecha SMALLDATETIME
SET @Fecha = SMALLDATETIMEFROMPARTS(2017, 02, 24, 16, 50)
EXECUTE ReclamarCobro 1, @fecha
ROLLBACK

**
--Ejercicio 4
--La empresa de Metro realiza una campaña de promoción para pasajeros fieles.
--Crea un procedimiento almacenado que recargue saldo a los pasajeros que cumplan determinados requisitos. 
--Se recargarán N1 euros a los pasajeros que hayan consumido más de 30 euros en el mes anterior (considerar mes completo, del día 1 al fin) 
--y N2 euros a los que hayan utilizado más de 10 veces alguna estación de las zonas 3 o 4. 
--Los valores de N1 y N2 se pasarán como parámetros. Si se omiten, se tomará el valor 5.
--Ambos premios son excluyentes. Si algún pasajero cumple ambas condiciones se le aplicará la que suponga mayor bonificación de las dos.
SELECT * FROM LM_Viajes
--El update ya recorre toda la tabla.
--Solo hay que crear una funcion escalar al que le pasamos un ID del pasajero y ella misma se encarga de hacer las actualizaciones.
--Si se omiten N1 o N2, se tomara como valor el 5. Seria asi:

/*
Esta funcion permite saber si el fiel con ID pasado como parametro hay que recargarle dinero o no.
*/
GO
CREATE FUNCTION RecargaFieles (@IDtarjeta INT, @N1 SMALLMONEY = 5, @N2 SMALLMONEY = 5) RETURNS INT AS
BEGIN
	DECLARE @dinero SMALLMONEY
	SET @dinero = 0 --Esto es por si algun fiel no cumple algun requisito, que devuelva 0.

	--Buscamos los que hayan usado mas de 10 veces alguna estacion de las zonas 3 y 4.
	IF EXISTS (SELECT COUNT(IDTarjeta) AS[Veces Viajada] FROM LM_Viajes AS[V]
					INNER JOIN LM_Estaciones AS [E] ON V.IDEstacionEntrada = E.ID OR V.IDEstacionSalida = E.ID
				WHERE E.Zona_Estacion IN(3,4) AND V.IDTarjeta = @IDtarjeta
				GROUP BY IDTarjeta
				HAVING COUNT(IDTarjeta) >= 10)
		SET @dinero = @N2

	--Buscamos los que hayan consumido mas de 30 euros en el mes anterior.
	IF EXISTS (SELECT SUM(Importe_Viaje) AS[Gastado] FROM LM_Viajes AS[V]
					WHERE CAST(V.MomentoSalida AS DATE) BETWEEN '2017-02-01' AND '2017-02-28' AND V.IDTarjeta = @IDTarjeta
				GROUP BY IDTarjeta
				HAVING SUM(Importe_Viaje) >= 30)
		SET @dinero = @N1

	--En la cabecera ya les asigno un valor por defecto, asi que no necesito comprobar si algun valor es nulo. Simplemente comparo que valor es mas grande y lo asigno.
	IF (@N1 >= @N2)
		SET @dinero = @N1
	ELSE
		SET @dinero = @N2

	RETURN @dinero
END
GO

/*
Esta funcion actualiza los fieles que cumplan las condiciones del enunciado.
*/
GO
CREATE PROCEDURE ActualizarFieles (@N1 SMALLMONEY = 5, @N2 SMALLMONEY = 5) AS
BEGIN
	UPDATE LM_Tarjetas
	SET Saldo = Saldo + dbo.RecargaFieles(ID, @N1, @N2)
END
GO

BEGIN TRAN
EXECUTE ActualizarFieles 3,5
SELECT * FROM LM_Tarjetas
ROLLBACK

--Ejercicio 5
--Crea una función que nos devuelva verdadero si es posible que un pasajero haya subido a un tren en un determinado viaje. 
--Se pasará como parámetro el código del viaje y la matrícula del tren.
/*
Descripcion: nos dice si es posible que un pasajero haya subido a un tren en un determinado viaje.
Entrada: @idViaje INT, @matricula char(7)
Salida: subida BIT
Precondiciones: asociado al nombre devuelve 1 si es posible que hubiera pasajeros y 0 en caso contrario.
*/
GO
CREATE FUNCTION subidaAlTren (@idViaje INT,@matricula char(7)) RETURNS BIT AS
BEGIN
	DECLARE @subida BIT
	IF EXISTS(SELECT * FROM LM_Trenes AS[T]
				INNER JOIN LM_Recorridos AS[R] ON T.ID = R.Tren
				INNER JOIN LM_Estaciones AS[E] ON R.estacion = E.ID
				INNER JOIN LM_Viajes AS[V] ON E.ID = V.IDEstacionEntrada
				WHERE T.Matricula = @matricula AND V.ID = @idViaje
			 )
		SET @subida = 1
	ELSE
		SET @subida = 0
	RETURN @subida
END
GO

--Para dejar constancia de que he hecho mas pruebas hay que ponerlas todas una debajo de otra.
DECLARE @subido BIT
SET @subido = dbo.subidaAlTren (1,'0100FRY')
PRINT @subido


--Ejercicio 6
--Crea un procedimiento SustituirTarjeta que Cree una nueva tarjeta y la asigne al mismo usuario y con el mismo saldo que otra 
--tarjeta existente. El código de la tarjeta a sustituir se pasará como parámetro.
SELECT * FROM LM_Tarjetas
GO
CREATE PROCEDURE SustituirTarjeta (@codTarjeta INT) AS
BEGIN
	INSERT INTO LM_Tarjetas (saldo, IDPasajero)
	SELECT Saldo, IDPasajero FROM LM_Tarjetas
		WHERE ID = @codTarjeta
--No se si hay que hacer algo mas.
END
GO

--Pruebo el procedimiento
BEGIN TRAN
EXECUTE SustituirTarjeta 12
--ROLLBACK

--Ejercicio 7
--Las estaciones de la zona 3 tienen ciertas deficiencias, lo que nos ha obligado a introducir una serie de modificaciones en 
--los trenes  para cumplir las medidas de seguridad.
--A consecuencia de estas modificaciones, la capacidad de los trenes se ha visto reducida en 6 plazas para los trenes 
--de tipo 1 y 4 plazas para los trenes de tipo 2.
--Realiza un procedimiento al que se pase un intervalo de tiempo y modifique la capacidad de todos los trenes que hayan 
--circulado más de una vez por alguna estación de la zona 3 en ese intervalo.
SELECT * FROM LM_Trenes
SELECT * FROM LM_Recorridos
SELECT * FROM LM_Estaciones
SELECT * FROM LM_Viajes
GO
CREATE PROCEDURE ModificarTren (@intervalo1 SMALLDATETIME, @intervalo2 SMALLDATETIME) AS
BEGIN

	--Guardo los trenes que han circulado mas de una vez por la zona 3
	CREATE TYPE trenes AS
	TABLE(idTren INT)

	DECLARE @numTrenes trenes
	SET @numTrenes = (SELECT Tren ,COUNT(Tren) AS[Veces en Zona 3] FROM LM_Trenes AS[T]
		INNER JOIN LM_Recorridos AS[R] ON T.ID = R.Tren
		INNER JOIN LM_Estaciones AS[E] ON R.estacion = E.ID
		INNER JOIN LM_Viajes AS[V] ON E.ID = V.IDEstacionEntrada OR E.ID = V.IDEstacionSalida
	WHERE T.Tipo = 1 AND E.Zona_Estacion = 3 --AND (R.Momento BETWEEN @intervalo1 AND @intervalo2)
	GROUP BY Tren)
END
GO