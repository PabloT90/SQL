USE CentroDeportivo
SET DATEFORMAT YMD
--Ejercicio 1
--Escribe un procedimiento EliminarUsuario que reciba como par�metro el DNI de un usuario, le coloque un NULL en la 
--columna Sex y borre todas las reservas futuras de ese usuario. Ten en cuenta que si alguna de esas reservas tiene 
--asociado un alquiler de material habr� que borrarlo tambi�n.
 
GO
CREATE PROCEDURE EliminarUsuario @DNI char(9) AS
BEGIN
	UPDATE Usuarios
	SET Sex = NULL
	WHERE DNI = @DNI

	DELETE ReservasMateriales FROM ReservasMateriales AS[RM]
		INNER JOIN Reservas AS[R] ON RM.CodigoReserva = R.Codigo
		INNER JOIN Usuarios AS[U] ON R.ID_Usuario = U.ID
	WHERE  U.DNI = @DNI AND CURRENT_TIMESTAMP < R.Fecha_Hora

	DELETE Reservas FROM Reservas AS[R]
		INNER JOIN Usuarios AS[U] ON R.ID_Usuario = U.ID
	WHERE U.DNI = @DNI AND CURRENT_TIMESTAMP < R.Fecha_Hora
	--Ahora tengo que borrar el alquiler de los materiales.
END --Fin del procedimiento
GO
EXECUTE EliminarUsuario '59544420G'

--Ejercicio 2
--Escribe un procedimiento que reciba como par�metros el c�digo de una instalaci�n y una fecha/hora (SmallDateTime) y 
--devuelva en otro par�metro de salida el ID del usuario que la ten�a alquilada si en ese momento la instalaci�n estaba ocupada. 
--Si estaba libre, devolver� un NULL.
SELECT * FROM Reservas
GO
CREATE PROCEDURE EstaAlquilado 
	@CodigoInstalacion INT,
	@Fecha SMALLDATETIME,
	@IDUsuario CHAR(12) OUTPUT AS
	BEGIN
		SELECT  @IDUsuario = R.ID_Usuario  FROM Reservas AS R
		WHERE R.Fecha_Hora = @Fecha AND @CodigoInstalacion = R.Cod_Instalacion
	END
GO
DECLARE @IDUsuario CHAR(12)
EXECUTE EstaAlquilado 1, '2008-12-12 15:00:00', @IDUsuario OUTPUT
SELECT @IDUsuario

--Ejercicio 3
--Escribe un procedimiento que reciba como par�metros el c�digo de una instalaci�n y dos fechas (DATE) y devuelva en 
--otro par�metro de salida el n�mero de horas que esa instalaci�n ha estado alquilada entre esas dos fechas, ambas incluidas. 
--Si se omite la segunda fecha, se tomar� la actual con GETDATE().
--Devuelve con return c�digos de error si el c�digo de la instalaci�n es err�neo  o si la fecha de inicio es posterior a la de fin.
GO
CREATE PROCEDURE HorasAlquilada
	@codigoInstalacion INT,
	@fecha1 DATE,
	@fecha2 DATE,
	@horas INT OUTPUT AS
	BEGIN
		--Si el codigo recibido no coincide con ninguna instalacion devuelve -1.
		IF @codigoInstalacion <> (SELECT * FROM Instalaciones)
		BEGIN
			RETURN -1
		END

		--Si la fecha1 es posterior a la fecha2 devuelve -2.
		ELSE IF @fecha1 > @fecha2
		BEGIN
			RETURN -2
		END

		ELSE IF @Fecha2 = NULL --Si @fecha2 es omitido, se tomar� la fecha actual.
		BEGIN
			SELECT @Horas = DATEDIFF(HH, @Fecha1, GETDATE()) FROM Reservas
			WHERE @Fecha1 <= GETDATE() AND @CodigoInstalacion = Cod_Instalacion
			RETURN @Horas
		END --Fin ELSE IF

		ELSE IF @Fecha2 <> NULL
		BEGIN
			SELECT @Horas = DATEDIFF(HH, @Fecha1, @Fecha2) FROM Reservas
			WHERE @Fecha1 <= @Fecha2 AND @codigoInstalacion = Cod_Instalacion
			RETURN @Horas
		END--Fin ELSE IF
	END--Fin del procedimiento.
GO

--Ejercicio 4
--Escribe un procedimiento EfectuarReserva que reciba como par�metro el DNI de un usuario, el c�digo de la instalaci�n, 
--la fecha/hora de inicio de la reserva y la fecha/hora final.
--El procedimiento comprobar� que los datos de entradas son correctos y grabar� la correspondiente reserva. 
--Devolver� el c�digo de reserva generado mediante un par�metro de salida. Para obtener el valor generado usar 
--la funci�n @@identity tras el INSERT.
--Devuelve un cero si la operaci�n se realiza con �xito y un c�digo de error seg�n la lista siguiente:
--3: La instalaci�n est� ocupada para esa fecha y hora
--4: El c�digo de la instalaci�n es incorrecto
--5: El usuario no existe
--8: La fecha/hora de inicio del alquiler es posterior a la de fin
--11: La fecha de inicio y de fin son diferentes

/*
Estudio de interfaz
Entrada: @DNI CHAR(9), @codigoInstalacion INT, @fechaInicio SMALLDATETIME, @fechaFinal SMALLDATETIME
Salida: @codigoReserva INT, @error SMALLINT
Precondiciones: no hay.
Postcondiciones: devuelve un 0 si se ha grabado correctamente la reserva,3 si la instalacion esta ocupada,
				 4 si el codigo de instalacion es incorrecto,
				 5 si el usuario no existe,8 sila fecha de inicio  es posteriora a la de fin y 
				 11 si si la fecha de inicio y de fin son diferentes
*/
GO
ALTER PROCEDURE EfectuarReserva (@DNI CHAR(9), @codigoInstalacion INT, @fechaInicio SMALLDATETIME, @fechaFinal SMALLDATETIME, @codigoReserva INT OUTPUT) AS
BEGIN
DECLARE @error SMALLINT
IF NOT EXISTS(SELECT ID FROM Usuarios WHERE DNI = @DNI)
	SET @error = 5
ELSE IF NOT EXISTS (SELECT * FROM Instalaciones WHERE Codigo = @codigoInstalacion)
	SET @error = 4
ELSE IF @fechaInicio > @fechaFinal
	SET @error = 8
ELSE IF CAST(@fechaInicio AS DATE) <> CAST(@fechaFinal AS DATE)
	SET @error = 11
ELSE IF (SELECT Cod_Instalacion FROM Reservas WHERE Cod_Instalacion = @codigoInstalacion AND (Fecha_Hora BETWEEN @fechaInicio AND @fechaFinal)) IS NOT NULL
	SET @error = 3
ELSE
BEGIN
	INSERT INTO Reservas
	VALUES(DATEPART(HH,@fechaFinal)-DATEPART(HH, @fechaInicio), @fechaInicio, (SELECT ID FROM Usuarios WHERE DNI = @DNI), @codigoInstalacion)
	SET @codigoReserva = @@IDENTITY
	SET @error = 0
END --Fin del ELSE
END
GO

--Para probar la funcion:
--Declaro los parametros de salida para luego mostrarlos.
BEGIN TRAN
DECLARE @error SMALLINT
DECLARE @codigoReserva INT
EXECUTE @error = EfectuarReserva '59544420G',1,'2019-12-12 15:00:00','2019-12-12 17:00:00',@CodigoReserva output
SELECT @error, @codigoReserva
ROLLBACK