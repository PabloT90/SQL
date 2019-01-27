USE Bichos
--1.N�mero de mascotas que han sufrido cada enfermedad.
SELECT * FROM BI_Mascotas_Enfermedades
SELECT * FROM BI_Enfermedades
SELECT E.Nombre, COUNT(Mascota) AS[Numero de Enfermos] FROM BI_Enfermedades AS[E]
	INNER JOIN BI_Mascotas_Enfermedades AS[ME] ON E.ID = ME.IDEnfermedad
		GROUP BY E.ID, e.Nombre

--2.N�mero de mascotas que han sufrido cada enfermedad incluyendo las enfermedades que no ha sufrido ninguna mascota.

--3.N�mero de mascotas de cada cliente. Incluye nombre completo y direcci�n del cliente.

--4.N�mero de mascotas de cada especie de cada cliente. Incluye nombre completo y direcci�n del cliente.

--5.N�mero de mascotas de cada especie que han sufrido cada enfermedad.

--6.N�mero de mascotas de cada especie que han sufrido cada enfermedad incluyendo las enfermedades que no ha sufrido ninguna 
--mascota de alguna especie.

--7.Queremos saber cu�l es la enfermedad m�s com�n en cada especie. Incluye cuantos casos se han producido

--8.Duraci�n media, en d�as, de cada enfermedad, desde que se detecta hasta que se cura. Incluye solo los casos en que el animal se haya curado. 
--Se entiende que una mascota se ha curado si tiene fecha de curaci�n y est� viva o su fecha de fallecimiento es posterior a la fecha de curaci�n.

--9.N�mero de veces que ha acudido a consulta cada cliente con alguna de sus mascotas. Incluye nombre y apellidos del cliente.

--10.N�mero de visitas a las que ha acudido cada mascota, fecha de su primera y de su �ltima visita

--11.Incremento (o disminuci�n) de peso que ha experimentado cada mascota entre cada dos consultas sucesivas. 
--Incluye nombre de la mascota, especie, fecha de las dos consultas sucesivas e incremento o disminuci�n de peso.
SELECT * FROM BI_Visitas
SELECT * FROM BI_Mascotas
SELECT DISTINCT M.Alias, M.Especie, V.Peso, V.Mascota FROM BI_Mascotas AS[M]
	INNER JOIN BI_Visitas AS[V] ON M.Codigo = V.Mascota
		ORDER BY m.Alias
		
--Los ordeno por mascota y asi obtengo las visitas de cada animal parejas
SELECT Mascota, Peso, Fecha FROM BI_Visitas
	WHERE IDVisita % 2 != 1 AND Mascota = (SELECT Mascota, Peso, Fecha FROM BI_Visitas
	WHERE IDVisita % 2 != 0
		ORDER BY Mascota)
		ORDER BY Mascota

SELECT Mascota, Peso, Fecha FROM BI_Visitas
	WHERE IDVisita % 2 != 0
		ORDER BY Mascota
-- Primero peso del animal en una de las visitas.

--Hacer una subconsulta de todos menos(except) distinct la misma consulta.

	