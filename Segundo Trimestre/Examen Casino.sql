--Cada apuesta tiene una serie de n�meros (entre 1 y 24 n�meros) asociados en la tabla COL_NumerosApuestas. La apuesta es ganadora 
--si alguno de esos n�meros coincide con el n�mero ganador de la jugada y perdedora en caso contrario.
--Si la apuesta es ganadora, el jugador recibe lo apostado (Importe) multiplicado por el valor de la columna Premio de la tabla 
--COL_TiposApuestas que corresponda con el tipo de la apuesta. Si la apuesta es perdedora, el jugador pierde lo que haya apostado (Importe)

--Ejercicio 1
--Escribe una consulta que nos devuelva el n�mero de veces que se ha apostado a cada n�mero con apuestas de los tipos 10, 13 o 15.
--Ordena el resultado de mayor a menos popularidad.
SELECT * FROM  COL_Apuestas
SELECT * FROM COL_Jugadas

SELECT J.Numero, A.Tipo, COUNT(*) AS [Veces Apostados] FROM COL_Jugadas AS J
	INNER JOIN COL_Apuestas AS A ON J.IDJugada = A.IDJugada AND J.IDMesa = A.IDMesa
WHERE A.Tipo IN(10, 13, 15)
GROUP BY J.Numero, A.Tipo
ORDER BY [Veces Apostados] DESC

--Ejercicio 2
--El casino quiere fomentar la participaci�n y decide regalar saldo extra a los jugadores que hayan apostado m�s de tres veces 
--en el �ltimo mes. Se considera el mes de febrero.
--La cantidad que se les regalar� ser� un 5% del total que hayan apostado en ese mes

--Extra: lo mismo pero que sea una funcion inline
GO
CREATE FUNCTION [Cantidad a Regalar] (@mes AS SMALLINT) RETURNS TABLE AS RETURN
	SELECT SUM(A.Importe) AS[Total Apostado], A.IDJugador, SUM(A.Importe)*0.05 AS[A Regalar] FROM COL_Apuestas AS[A]
	INNER JOIN COL_Jugadas AS[J] ON A.IDJugada = J.IDJugada
	WHERE MONTH(MomentoJuega) = @mes
GROUP BY A.IDJugador
HAVING COUNT(A.IDjugador) > 3
GO

SELECT * FROM [Cantidad a Regalar] (2)
--------------------------------------------------------------
--------------------------------------------------------------
GO
CREATE VIEW [VecesApostadosPorJugador] AS
SELECT A.IDJugador, COUNT(*) [Veces apostados] FROM COL_Apuestas AS A
	INNER JOIN COL_Jugadas AS J ON A.IDJugada = J.IDJugada AND A.IDMesa = J.IDMesa
WHERE YEAR(J.MomentoJuega) = 2018 AND MONTH(J.MomentoJuega) = 2
GROUP BY A.IDJugador


GO
CREATE VIEW [CantidadApostadoEnFebrero] AS
SELECT A.IDJugador, SUM(A.Importe) [Cantidad total apostados], SUM(A.Importe) * 0.05 AS [5%] FROM COL_Apuestas AS A
	INNER JOIN COL_Jugadas AS J ON A.IDJugada = J.IDJugada AND A.IDMesa = J.IDMesa
WHERE YEAR(J.MomentoJuega) = 2018 AND MONTH(J.MomentoJuega) = 2
GROUP BY A.IDJugador
GO

SELECT ID, Saldo FROM COL_Jugadores

BEGIN TRAN

UPDATE COL_Jugadores
	SET Saldo=saldo + CAF.[5%]
		FROM COL_Jugadores AS J
			INNER JOIN VecesApostadosPorJugador AS VAJ ON J.ID = VAJ.IDJugador
			INNER JOIN CantidadApostadoEnFebrero AS CAF ON VAJ.IDJugador = CAF.IDJugador
		WHERE VAJ.[Veces apostados] > 3

SELECT ID, Saldo FROM COL_Jugadores

ROLLBACK
--Ejercicio 3
--El d�a 2 de febrero se celebr� el d�a de la marmota. Para conmemorarlo, el casino ha decidido volver a repetir todas las jugadas 
--que se hicieron ese d�a, pero poni�ndoles fecha de ma�ana (con la misma hora) y permitiendo que los jugadores apuesten. 
--El n�mero ganador de cada jugada se pondr� a NULL y el NoVaMas a 0.
--Crea esas nuevas filas con una instrucci�n INSERT-SELECT
GO

INSERT INTO COL_Jugadas
(IDMesa, IDJugada, MomentoJuega, NoVaMas, Numero)
SELECT IDMesa, IDJugada + 2000,
		DATEADD(MINUTE, DATEPART(MINUTE, MomentoJuega), DATEADD(HOUR, DATEPART(HOUR, MomentoJuega), CAST(CAST (CURRENT_TIMESTAMP AS DATE) AS DATETIME)))
		, 0, NULL
FROM COL_Jugadas 
WHERE CAST(MomentoJuega AS DATE) = '02-02-2018'

ROLLBACK

--Ejercicio 4
--Crea una vista que nos muestre, para cada jugador, nombre, apellidos, Nick, n�mero de apuestas realizadas, total de dinero apostado y 
--total de dinero ganado/perdido.
SELECT * FROM COL_Jugadores
SELECT * FROM COL_Apuestas
SELECT * FROM COL_Jugadas --La jugada que ha hecho la persona
SELECT * FROM COL_NumerosApuesta --El numero que ha salido en cada jugada.

--Nombre, apellidos, nick, numero de apuestas realizadas y total dinero apostado
GO
CREATE VIEW [Total Apostado] AS
SELECT J.ID,J.Nombre, J.Apellidos, J.Nick, SUM(A.Importe) AS[Dinero apostado], COUNT(A.IDJugador) AS[Numero Apuestas] FROM COL_Jugadores AS[J]
	INNER JOIN COL_Apuestas AS[A] ON J.ID = A.IDJugador
GROUP BY ID, J.Nombre, J.Apellidos, J.Nick
GO

--Dinero ganado
CREATE VIEW [Dinero Ganado] AS
SELECT SUM(Importe*Premio) AS[Dinero Ganado], A.IDJugador FROM COL_Jugadas AS[J]
	INNER JOIN COL_Apuestas AS[A] ON J.IDMesa = A.IDMesa AND J.IDJugada = A.IDJugada
	INNER JOIN COL_NumerosApuesta AS[NA] ON A.IDJugada = NA.IDJugada AND A.IDJugador = NA.IDJugador AND A.IDMesa = NA.IDMesa
	INNER JOIN COL_TiposApuesta AS[TA] ON A.Tipo = TA.ID
WHERE J.Numero = NA.Numero
GROUP BY  A.IDJugador
--ORDER BY A.IDJugador
GO

SELECT TA.Nombre, TA.Apellidos, TA.Nick, TA.[Dinero apostado], TA.[Numero Apuestas], DG.[Dinero Ganado]/TA.[Dinero apostado] AS[Balance]  FROM [Total Apostado] AS[TA]
	INNER JOIN [Dinero Ganado] AS[DG] ON TA.ID = DG.IDJugador

--Ejercicio 5
--Nos comunican que la polic�a ha detenido a nuestro cliente Ombligo Pato por delitos de estafa, falsedad, administraci�n desleal y 
--mal gusto para comprar ba�adores. 
--Dado que nuestro casino est� en Gibraltar, siguiendo la tradici�n de estas tierras, queremos borrar todo rastro de su paso 
--por nuestro casino.
--Borra todas las apuestas que haya realizado, pero no busques su ID a mano en la tabla COL_Clientes. Utiliza su Nick (bankiaman) 
--para identificarlo en la instrucci�n DELETE.


--Ejercicio 6
--Crea una funci�n a la que pasemos como par�metros una fecha de inicio y otra de fin y nos devuelva el n�meros de jugadas, 
--el total de dinero apostado y las ganancias (del casino) de cada una de las mesas en ese periodo.

--Lo que ha ganado el casino
GO
CREATE VIEW [PerdidoXMesa] AS
SELECT SUM(Importe*Premio) AS [Dinero perdido], A.IDMesa FROM  COL_Jugadas AS[J] 
	INNER JOIN COL_Apuestas AS [A] ON J.IDJugada = A.IDJugada AND J.IDMesa = A.IDMesa
	INNER JOIN COL_NumerosApuesta AS NA ON NA.IDJugador = A.IDJugador AND A.IDJugada = NA.IDJugada AND A.IDMesa = NA.IDMesa
	INNER JOIN COL_TiposApuesta AS[TA] ON A.Tipo = TA.ID
WHERE J.Numero = NA.Numero
GROUP BY  A.IDMesa
GO



--Ganado por mesa
GO
CREATE VIEW [GanadoXMesa] AS
SELECT SUM(Importe) AS [Dinero ganado], A.IDMesa FROM COL_Jugadas AS[J]
	INNER JOIN COL_Apuestas AS[A] ON J.IDMesa = A.IDMesa AND J.IDJugada = A.IDJugada
	INNER JOIN COL_NumerosApuesta AS[NA] ON A.IDJugada = NA.IDJugada AND A.IDJugador = NA.IDJugador AND A.IDMesa = NA.IDMesa
WHERE J.Numero != NA.Numero
GROUP BY  A.IDMesa
GO


GO
CREATE FUNCTION FNCasino (@fechaFin DATE, @fechaInicio DATE) RETURNS TABLE AS RETURN
SELECT A.IDMesa,COUNT(A.IDJugador) AS [N�mero de Apuestas Realizadas],SUM(A.Importe) AS [Total de dinero apostado]
    ,G.[Dinero Ganado]-P.[Dinero perdido] AS [Ganado/Perdido] FROM COL_Apuestas AS[A]  
	INNER JOIN COL_Jugadas AS[JA] ON JA.IDMesa = A.IDMesa AND JA.IDJugada = A.IDJugada
	INNER JOIN COL_NumerosApuesta AS[NA] ON A.IDJugada = NA.IDJugada AND A.IDJugador = NA.IDJugador AND A.IDMesa = NA.IDMesa
	INNER JOIN PerdidoXMesa AS P ON NA.IDMesa=P.IDMesa
	INNER JOIN GanadoXMesa AS G ON G.IDMesa = P.IDMesa
WHERE MomentoJuega BETWEEN @fechaInicio AND @fechaFin
GROUP BY A.IDMesa, P.[Dinero perdido], G.[Dinero ganado]
GO

SELECT * FROM FNCasino('2018-01-14', '2018-01-01')
ORDER BY IDMesa


--Ejercicio 7
--El casino sospecha que algunos croupiers favorecen a ciertos jugadores. Para ello buscamos si algunos jugadores han sido especialmente 
--afortunados cuando han jugado en una mesa determinada.
--Haz una consulta que nos devuelva los nombres e IDs de los jugadores que han ganado un 30% m�s en una mesa en particular que en 
--la media de las otras.