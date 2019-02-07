USE Bichos
--1.Número de mascotas que han sufrido cada enfermedad.
SELECT * FROM BI_Mascotas_Enfermedades
SELECT * FROM BI_Enfermedades
SELECT E.Nombre, COUNT(Mascota) AS[Numero de Enfermos] FROM BI_Enfermedades AS[E]
	INNER JOIN BI_Mascotas_Enfermedades AS[ME] ON E.ID = ME.IDEnfermedad
		GROUP BY E.ID, e.Nombre

--2.Número de mascotas que han sufrido cada enfermedad incluyendo las enfermedades que no ha sufrido ninguna mascota.
SELECT * FROM BI_Mascotas
SELECT * FROM BI_Mascotas_Enfermedades
SELECT * FROM BI_Enfermedades
SELECT COUNT(ME.IDEnfermedad) AS[Numero de Enfermos], E.Nombre FROM BI_Mascotas AS[M]
	RIGHT JOIN BI_Mascotas_Enfermedades AS[ME] ON M.Codigo = ME.Mascota
	RIGHT JOIN BI_Enfermedades AS[E] ON ME.IDEnfermedad = E.ID
		GROUP BY Nombre
		ORDER BY [Numero de Enfermos]

--3.Número de mascotas de cada cliente. Incluye nombre completo y dirección del cliente.
SELECT * FROM BI_Clientes
SELECT * FROM BI_Mascotas
SELECT C.Nombre, C.Direccion, COUNT(M.CodigoPropietario) AS[Nº Mascotas] FROM BI_Clientes AS[C]
	INNER JOIN BI_Mascotas AS[M] ON C.Codigo = M.CodigoPropietario
		GROUP BY C.Nombre, Direccion

--4.Número de mascotas de cada especie de cada cliente. Incluye nombre completo y dirección del cliente.


--5.Número de mascotas de cada especie que han sufrido cada enfermedad.


--6.Número de mascotas de cada especie que han sufrido cada enfermedad incluyendo las enfermedades que no ha sufrido ninguna 
--mascota de alguna especie.


--7.Queremos saber cuál es la enfermedad más común en cada especie. Incluye cuantos casos se han producido
SELECT * FROM BI_Enfermedades
SELECT * FROM BI_Mascotas_Enfermedades
SELECT * FROM BI_Mascotas
--Lo que nos pide
SELECT E.Nombre, COUNT(ME.IDEnfermedad) AS[Numero Enfermos], M.Especie  FROM  BI_Enfermedades AS[E]
			INNER JOIN BI_Mascotas_Enfermedades AS[ME] ON E.ID = ME.IDEnfermedad
			INNER JOIN BI_Mascotas AS[M] ON ME.Mascota = M.Codigo
			INNER JOIN (
	--La mas comun y los casos
	SELECT DISTINCT ET.Especie, MAX([Numero Enfermos]) AS[Casos] FROM(
		--Enfermedades totales de cada especie
		SELECT E.Nombre, COUNT(*) AS[Numero Enfermos], M.Especie  FROM  BI_Enfermedades AS[E]
			INNER JOIN BI_Mascotas_Enfermedades AS[ME] ON E.ID = ME.IDEnfermedad
			INNER JOIN BI_Mascotas AS[M] ON ME.Mascota = M.Codigo
		GROUP BY M.Especie, E.Nombre) AS[ET]
	GROUP BY ET.Especie) AS[MA] ON M.Especie = MA.Especie
GROUP BY M.Especie, E.Nombre, MA.Casos
HAVING COUNT(ME.IDEnfermedad) = MA.Casos

--8.Duración media, en días, de cada enfermedad, desde que se detecta hasta que se cura. Incluye solo los casos en que el animal se haya curado. 
--Se entiende que una mascota se ha curado si tiene fecha de curación y está viva o su fecha de fallecimiento es posterior a la fecha de curación.


--9.Número de veces que ha acudido a consulta cada cliente con alguna de sus mascotas. Incluye nombre y apellidos del cliente.


--10.Número de visitas a las que ha acudido cada mascota, fecha de su primera y de su última visita


--11.Incremento (o disminución) de peso que ha experimentado cada mascota entre cada dos consultas sucesivas. 
--Incluye nombre de la mascota, especie, fecha de las dos consultas sucesivas e incremento o disminución de peso.
SELECT * FROM BI_Visitas
SELECT * FROM BI_Mascotas
SELECT Fecha, V.Mascota FROM BI_Mascotas AS[M]
	INNER JOIN BI_Visitas AS[V] ON V.Mascota = M.Codigo
	Order by V.Mascota
