--Ejercicio 1 
--Indica el número de estaciones por las que pasa cada línea


--Ejercicio 2 
--Indica el número de trenes diferentes que han circulado en cada línea


--Ejercicio 3 
--Indica el número medio de trenes de cada clase que pasan al día por cada estación. 
SELECT * FROM LM_Trenes
SELECT * FROM LM_Recorridos
SELECT * FROM LM_Estaciones
--Media por dia.
SELECT AVG(TC.[Veces que Pasa un Tren]) AS[Media Dias], TC.Denominacion, TC.Tipo FROM (
	--numero de trenes de cada clase(denominacion) en cada estacion.
	SELECT COUNT(R.estacion) AS[Veces que Pasa un Tren], DAY(Momento) AS[Dia], Tipo, Denominacion FROM LM_Trenes AS[T]
		INNER JOIN LM_Recorridos AS[R] ON T.ID = R.Tren
		INNER JOIN LM_Estaciones AS[E] ON R.estacion = E.ID
	GROUP BY DAY(Momento), Tipo, Denominacion) AS[TC]
GROUP BY Denominacion, Tipo
ORDER BY Denominacion

--Ejercicio 4 
--Calcula el tiempo necesario para recorrer una línea completa, contando con el tiempo estimado de cada itinerario y considerando que cada parada en una estación dura 30 s.


--Ejercicio 5 
--Indica el número total de pasajeros que entran (a pie) cada día por cada estación y los que salen del metro en la misma.
SELECT * FROM LM_Viajes
SELECT * FROM LM_Estaciones

--Los que entran
GO
CREATE VIEW [Los que entran] AS
SELECT Denominacion, COUNT(IDEstacionEntrada) AS[Personas], DAY(MomentoEntrada) AS[Dia] FROM LM_Viajes AS[V]
	INNER JOIN LM_Estaciones AS[E] ON V.IDEstacionEntrada = E.ID
GROUP BY IDEstacionEntrada, Denominacion, DAY(MomentoEntrada)
GO

--Los que salen
GO
CREATE VIEW [Los que salen] AS
SELECT Denominacion, COUNT(IDEstacionSalida) AS[Personas], DAY(MomentoSalida) AS[Dia] FROM LM_Viajes AS[V]
	INNER JOIN LM_Estaciones AS[E] ON V.IDEstacionSalida = E.ID
GROUP BY IDEstacionSalida, Denominacion, DAY(MomentoSalida)
GO

SELECT S.Personas AS[Salen], E.Personas AS[Entran], E.Denominacion FROM [Los que entran] AS[E]
	INNER JOIN [Los que salen] AS[S] ON E.Denominacion = S.Denominacion

--Ejercicio 6 
--Calcula la media de kilómetros al día que hace cada tren. Considera únicamente los días que ha estado en servicio 



--Ejercicio 7 
--Calcula cuál ha sido el intervalo de tiempo en que más personas registradas han estado en el metro al mismo tiempo. 
--Considera intervalos de una hora (de 12:00 a 12:59, de 13:00 a 13:59, etc). Si hay varios momentos con el número máximo de 
--personas, muestra el más reciente.


--Ejercicio 8 
--Calcula el dinero gastado por cada usuario en el mes de febrero de 2017. El precio de un viaje es el de la zona más 
--cara que incluya. Incluye a los que no han viajado.
SELECT * FROM LM_Pasajeros
SELECT * FROM LM_Tarjetas
SELECT * FROM LM_Viajes

SELECT SUM(Importe_Viaje) AS[Dinero Gastado], Nombre FROM LM_Pasajeros AS[P]
	LEFT JOIN LM_Tarjetas AS[T] ON P.ID = T.IDPasajero
	INNER JOIN LM_Viajes AS[V] ON T.ID = V.IDTarjeta
	WHERE YEAR(MomentoEntrada) = 2017 AND MONTH(MomentoEntrada) = 2
	GROUP BY IDTarjeta, Nombre
	ORDER BY Nombre

--Ejercicio 9 
--Calcula el tiempo medio diario que cada pasajero pasa en el sistema de metro y el número de veces que accede al mismo.
--Última modificación: lunes, 4 de febrero de 2019, 13:37

