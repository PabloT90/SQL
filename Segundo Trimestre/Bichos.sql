--Introduce dos nuevos clientes. Asígnales los códigos que te parezcan adecuados.
SELECT * FROM BI_Clientes

BEGIN TRAN Prueba1
INSERT INTO BI_Clientes VALUES
	(107,658004984, 'calle la parga,27',null,'JOSEMA'),
	(108,658004987, 'calle la parga,26',null,'Charlotte LinLin')

COMMIT TRAN prueba1
--Introduce una mascota para cada uno de ellos. Asígnales los códigos que te parezcan adecuados.
SELECT * FROM BI_Mascotas

BEGIN TRAN
INSERT INTO BI_Mascotas VALUES
	('PM006','Arabe','perro','2009-02-10',null,'Bigotes',107),
	('PM007','Arabe','perro','2009-02-10',null,'Matute',108)

COMMIT TRAN
--Escribe un SELECT para obtener los IDs de las enfermedades que ha sufrido alguna mascota (una cualquiera). Los IDs no deben repetirse
SELECT DISTINCT IDEnfermedad FROM BI_Mascotas_Enfermedades

--El cliente Josema Ravilla ha llevado a visita a todas sus mascotas.
	--Escribe un SELECT para averiguar el código de Josema Ravilla.
	SELECT Codigo FROM BI_Clientes
		WHERE Nombre IN ('Josema Ravilla')
	--Escribe otro SELECT para averiguar los códigos de las mascotas de Josema Ravilla.
	SELECT Codigo FROM BI_Mascotas
		WHERE CodigoPropietario = 102
	--Con los códigos obtenidos en la consulta anterior, escribe los INSERT correspondientes en la tabla BI_Visitas. La fecha y hora se tomarán del sistema.
	SELECT * FROM BI_Visitas
	begin tran
	INSERT INTO BI_Visitas VALUES
		(CURRENT_TIMESTAMP,38, 12,'GM002'),
		(CURRENT_TIMESTAMP,38, 12,'PH002')
--Todos los perros del cliente 104 han enfermado el 20 de diciembre de sarna.
	--Escribe un SELECT para averiguar los códigos de todos los perros del cliente 104
	
	SELECT Codigo FROM BI_Mascotas
		WHERE CodigoPropietario = 104 
	--Con los códigos obtenidos en la consulta anterior, escribe los INSERT correspondientes en la tabla BI_Mascotas_Enfermedades
	SELECT * FROM BI_Mascotas_Enfermedades
	SELECT * FROM BI_Enfermedades --Tener en cuenta el IDEnfermedad de la sarna.

	begin tran
	INSERT INTO BI_Mascotas_Enfermedades VALUES
		(4,'GH004','2014-06-02','2014-07-01'),
		(4,'PH004','2014-06-04','2014-07-01'),
		(4,'PH104','2014-06-06','2014-07-01'),
		(4,'PM004','2014-06-08','2014-07-01')

		commit tran
--Escribe una consulta para obtener el nombre, especie y raza de todas las mascotas, ordenados por edad.
SELECT Alias, Especie, Raza, FechaNacimiento FROM BI_Mascotas
	ORDER BY FechaNacimiento
--Escribe los códigos de todas las mascotas que han ido alguna vez al veterinario un lunes o un viernes.
--Para averiguar el dia de la semana de una fecha se usa la función DATEPART (WeekDay, fecha) que devuelve un entero 
--entre 1 y 7 donde el 1 corresponde al lunes, el dos al martes y así sucesivamente.
--NOTA: El servidor se puede configurar para que la semana empiece en lunes o domingo.
SELECT * FROM BI_Visitas
SELECT Mascota, Fecha FROM BI_Visitas
	WHERE DATEPART(DW,Fecha) = 1 OR DATEPART(DW,Fecha) = 5