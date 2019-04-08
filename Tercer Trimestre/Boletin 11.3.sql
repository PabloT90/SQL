USE CentroDeportivo
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

