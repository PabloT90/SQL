USE LeoMetroV2
SET DATEFORMAT YMD
--Ejercicio 0
--La dimisi�n de Esperanza Aguirre ha causado tal conmoci�n entre los directivos de LeoMetro que han decidido conceder una 
--amnist�a a todos los pasajeros que tengan un saldo negativo en sus tarjetas.
--Crea un procedimiento que racargue la cantidad necesaria para dejar a 0 el saldo de las tarjetas que tengan un saldo negativo 
--y hayan sido recargadas al menos una vez en los �ltimos dos meses.
--Ejercicio elaborado en colaboraci�n con Sefran.
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
--Crea un procedimiento RecargarTarjeta que reciba como par�metros el ID de una tarjeta y un importe y actualice el saldo 
--de la tarjeta sum�ndole dicho importe, adem�s de grabar la correspondiente recarga

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
--Crea un procedimiento almacenado llamado PasajeroSale que reciba como par�metros el ID de una tarjeta, el ID de una estaci�n(salida) 
--y una fecha/hora (opcional). El procedimiento se llamar� cuando un pasajero pasa su tarjeta por uno de los tornos de salida del metro. 
--Su misi�n es grabar la salida en la tabla LM_Viajes. Para ello deber� localizar la entrada que corresponda, que ser� la �ltima 
--entrada correspondiente al mismo pasajero y har� un update de las columnas que corresponda. Si no existe la entrada, grabaremos 
--una nueva fila en LM_Viajes dejando a NULL la estaci�n y el momento de entrada y cobraremos por la estacion de la zona 1.
--Si se omite el par�metro de la fecha/hora, se tomar� la actual.
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
--par�metro el ID de un pasajero y la fecha y hora de la entrada en el metro y anule ese viaje, actualizando adem�s el saldo 
--de la tarjeta que utiliz�.
SELECT * FROM LM_Viajes
SELECT * FROM LM_Tarjetas
GO
CREATE PROCEDURE ReclamarCobro (@IDpasajero INT, @fecha SMALLDATETIME) AS
BEGIN
	--Establezco el dinero a devolver
	DECLARE @dineroADevolver SMALLMONEY
	SET @dineroADevolver = (SELECT Importe_Viaje FROM LM_Viajes WHERE ID = @IDpasajero AND MomentoEntrada = @fecha)
	--A�ado el dinero del viaje
	UPDATE LM_Tarjetas
	SET Saldo = Saldo + @dineroADevolver
	WHERE ID = @IDpasajero
	--Borro el registro de ese viaje.
	DELETE FROM LM_Viajes
	WHERE IDTarjeta = @IDpasajero AND MomentoEntrada = @fecha
END
GO

BEGIN TRAN
EXECUTE ReclamarCobro 1,'2017-02-24 16:50:00'
ROLLBACK

--Ejercicio 4
--La empresa de Metro realiza una campa�a de promoci�n para pasajeros fieles.
--Crea un procedimiento almacenado que recargue saldo a los pasajeros que cumplan determinados requisitos. 
--Se recargar�n N1 euros a los pasajeros que hayan consumido m�s de 30 euros en el mes anterior (considerar mes completo, del d�a 1 al fin) 
--y N2 euros a los que hayan utilizado m�s de 10 veces alguna estaci�n de las zonas 3 o 4. 
--Los valores de N1 y N2 se pasar�n como par�metros. Si se omiten, se tomar� el valor 5.
--Ambos premios son excluyentes. Si alg�n pasajero cumple ambas condiciones se le aplicar� la que suponga mayor bonificaci�n de las dos.
SELECT * FROM LM_Viajes
GO
--Si se omiten N1 o N2, se tomara como valor el 5. Seria asi:
CREATE PROCEDURE RecargaFieles (@N1 SMALLMONEY = 5, @N2 SMALLMONEY = 5) AS
BEGIN
	
	--Buscamos los que hayan gastado ams de 30 euros en el mes anterior
	SELECT IDTarjeta, COUNT(IDTarjeta) AS[Veces Viajada] FROM LM_Viajes
END
GO


--Ejercicio 5
--Crea una funci�n que nos devuelva verdadero si es posible que un pasajero haya subido a un tren en un determinado viaje. 
--Se pasar� como par�metro el c�digo del viaje y la matr�cula del tren.



--Ejercicio 6
--Crea un procedimiento SustituirTarjeta que Cree una nueva tarjeta y la asigne al mismo usuario y con el mismo saldo que otra 
--tarjeta existente. El c�digo de la tarjeta a sustituir se pasar� como par�metro.


--Ejercicio 7
--Las estaciones de la zona 3 tienen ciertas deficiencias, lo que nos ha obligado a introducir una serie de modificaciones en 
--los trenes  para cumplir las medidas de seguridad.
--A consecuencia de estas modificaciones, la capacidad de los trenes se ha visto reducida en 6 plazas para los trenes 
--de tipo 1 y 4 plazas para los trenes de tipo 2.
--Realiza un procedimiento al que se pase un intervalo de tiempo y modifique la capacidad de todos los trenes que hayan 
--circulado m�s de una vez por alguna estaci�n de la zona 3 en ese intervalo.