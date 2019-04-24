USE CentroDeportivo
SET DATEFORMAT YMD
--Ejercicio 1
--Escribe un procedimiento EliminarUsuario que reciba como parámetro el DNI de un usuario, le coloque un NULL en la 
--columna Sex y borre todas las reservas futuras de ese usuario. Ten en cuenta que si alguna de esas reservas tiene 
--asociado un alquiler de material habrá que borrarlo también.
 
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
--Escribe un procedimiento que reciba como parámetros el código de una instalación y una fecha/hora (SmallDateTime) y 
--devuelva en otro parámetro de salida el ID del usuario que la tenía alquilada si en ese momento la instalación estaba ocupada. 
--Si estaba libre, devolverá un NULL.
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
--Escribe un procedimiento que reciba como parámetros el código de una instalación y dos fechas (DATE) y devuelva en 
--otro parámetro de salida el número de horas que esa instalación ha estado alquilada entre esas dos fechas, ambas incluidas. 
--Si se omite la segunda fecha, se tomará la actual con GETDATE().
--Devuelve con return códigos de error si el código de la instalación es erróneo  o si la fecha de inicio es posterior a la de fin.
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

		ELSE IF @Fecha2 = NULL --Si @fecha2 es omitido, se tomará la fecha actual.
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
--Escribe un procedimiento EfectuarReserva que reciba como parámetro el DNI de un usuario, el código de la instalación, 
--la fecha/hora de inicio de la reserva y la fecha/hora final.
--El procedimiento comprobará que los datos de entradas son correctos y grabará la correspondiente reserva. 
--Devolverá el código de reserva generado mediante un parámetro de salida. Para obtener el valor generado usar 
--la función @@identity tras el INSERT.
--Devuelve un cero si la operación se realiza con éxito y un código de error según la lista siguiente:

--3: La instalación está ocupada para esa fecha y hora
--4: El código de la instalación es incorrecto
--5: El usuario no existe
--8: La fecha/hora de inicio del alquiler es posterior a la de fin
--11: La fecha de inicio y de fin son diferentes

/*
 prototipo: create procedure EfectuarReserva @Dni char(9),@CodigoInstalacion int,@Fecha_horaInicio smalldatetime,@Fecha_horaFin smalldatetime,@CodigoReserva as int output
 comentarios: procedimiento para grabar una nueva reserva
 precondiciones: no hay
 entradas: @Dni char(9),@CodigoInstalacion int,@Fecha_horaInicio smalldatetime,@Fecha_horaFin smalldatetime
 salidas:@Error as int,codigo de reserva
 entr/sal: no hay
 postcondiciones: devuelve un 0 si se ha grabado correctamente la reserva,3 si la instalacion esta ocupada,
     4 si el codigo de instalacion es incorrecto,
     5 si el usuario no existe,8 sila fecha de inicio  es posteriora a la de fin y 
     11 si si la fecha de inicio y de fin son diferentes
*/
GO
ALTER PROCEDURE EfectuarReserva @Dni CHAR(9),@CodigoInstalacion INT,@Fecha_horaInicio SMALLDATETIME,@Fecha_horaFin SMALLDATETIME,@CodigoReserva INT OUTPUT AS
BEGIN 
 DECLARE @Error INT

IF NOT EXISTS(SELECT Cod_Instalacion FROM Reservas
       WHERE Fecha_Hora BETWEEN @Fecha_horaInicio AND @Fecha_horaFin)
BEGIN 
	IF EXISTS (SELECT Codigo FROM Instalaciones
		WHERE @CodigoInstalacion = Codigo)
		BEGIN
			IF EXISTS (SELECT DNI FROM Usuarios
				WHERE @Dni = DNI)
			BEGIN
				IF @Fecha_horaInicio < @Fecha_horaFin
				BEGIN
					IF CAST(@Fecha_horaFin AS DATE) = CAST(@Fecha_horaInicio AS DATE)
					BEGIN
						--SET IDENTITY_INSERT Reservas ON
						INSERT INTO Reservas
						(Tiempo,Fecha_Hora,ID_Usuario,Cod_Instalacion)
						VALUES(DATEPART(HOUR,@Fecha_horaFin)-DATEPART(HOUR,@Fecha_horaInicio),@Fecha_horaInicio,(SELECT ID FROM Usuarios WHERE @Dni = DNI),@CodigoInstalacion)
						SET @CodigoReserva = @@IDENTITY
						--SET IDENTITY_INSERT Reservas OFF
						SET @Error = 0
					END
					ELSE
					BEGIN --Si la fecha de inicio y la de fin son diferentes:
						SET @Error = 11
					END
				END
				ELSE
				BEGIN
					SET @Error = 8
				END
			END
			ELSE
			BEGIN
				SET @Error = 5
			END
		END
	ELSE
	BEGIN
		SET @Error = 4
	END
END
ELSE
BEGIN
	SET @Error = 3
END

RETURN @Error
END

GO
DECLARE @Error INT
DECLARE @CodigoReserva INT 
EXECUTE @Error = EfectuarReserva '59544420G', 1, '2019-12-12 15:00:00', '2019-12-12 17:00:00', @CodigoReserva OUTPUT
SELECT @Error,@CodigoReserva