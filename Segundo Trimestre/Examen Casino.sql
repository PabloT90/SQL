--Cada apuesta tiene una serie de números (entre 1 y 24 números) asociados en la tabla COL_NumerosApuestas. La apuesta es ganadora 
--si alguno de esos números coincide con el número ganador de la jugada y perdedora en caso contrario.
--Si la apuesta es ganadora, el jugador recibe lo apostado (Importe) multiplicado por el valor de la columna Premio de la tabla 
--COL_TiposApuestas que corresponda con el tipo de la apuesta. Si la apuesta es perdedora, el jugador pierde lo que haya apostado (Importe)

--Ejercicio 1
--Escribe una consulta que nos devuelva el número de veces que se ha apostado a cada número con apuestas de los tipos 10, 13 o 15.
--Ordena el resultado de mayor a menos popularidad.
SELECT * FROM  COL_Apuestas
SELECT * FROM COL_Jugadas

SELECT J.Numero, A.Tipo, COUNT(*) AS [Veces Apostados] FROM COL_Jugadas AS J
	INNER JOIN COL_Apuestas AS A ON J.IDJugada = A.IDJugada AND J.IDMesa = A.IDMesa
WHERE A.Tipo IN(10, 13, 15)
GROUP BY J.Numero, A.Tipo
ORDER BY [Veces Apostados] DESC

--Ejercicio 2
--El casino quiere fomentar la participación y decide regalar saldo extra a los jugadores que hayan apostado más de tres veces 
--en el último mes. Se considera el mes de febrero.
--La cantidad que se les regalará será un 5% del total que hayan apostado en ese mes

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
--El día 2 de febrero se celebró el día de la marmota. Para conmemorarlo, el casino ha decidido volver a repetir todas las jugadas 
--que se hicieron ese día, pero poniéndoles fecha de mañana (con la misma hora) y permitiendo que los jugadores apuesten. 
--El número ganador de cada jugada se pondrá a NULL y el NoVaMas a 0.
--Crea esas nuevas filas con una instrucción INSERT-SELECT
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
--Crea una vista que nos muestre, para cada jugador, nombre, apellidos, Nick, número de apuestas realizadas, total de dinero apostado y 
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
--Nos comunican que la policía ha detenido a nuestro cliente Ombligo Pato por delitos de estafa, falsedad, administración desleal y 
--mal gusto para comprar bañadores. 
--Dado que nuestro casino está en Gibraltar, siguiendo la tradición de estas tierras, queremos borrar todo rastro de su paso 
--por nuestro casino.
--Borra todas las apuestas que haya realizado, pero no busques su ID a mano en la tabla COL_Clientes. Utiliza su Nick (bankiaman) 
--para identificarlo en la instrucción DELETE.


--Ejercicio 6
--Crea una función a la que pasemos como parámetros una fecha de inicio y otra de fin y nos devuelva el números de jugadas, 
--el total de dinero apostado y las ganancias (del casino) de cada una de las mesas en ese periodo.

--Funcion ganado x mesa
GO
CREATE FUNCTION [GanadoxMesa](@fechaInicio DATE, @fechaFin DATE) RETURNS TABLE AS RETURN
SELECT SUM(A.Importe) AS[Total Ganado], M.ID FROM COL_Mesas AS[M]
	INNER JOIN COL_Jugadas AS[J] ON M.ID = J.IDMesa
	INNER JOIN COL_Apuestas AS A ON J.IDMesa = A.IDMesa AND J.IDJugada = A.IDJugada
	INNER JOIN COL_NumerosApuesta AS NA ON A.IDJugada = NA.IDJugada AND A.IDJugador = NA.IDJugador AND A.IDMesa = NA.IDMesa
WHERE J.Numero != NA.Numero AND J.MomentoJuega BETWEEN @fechaInicio AND @fechaFin
GROUP BY M.ID
GO

--El plan es crear una funcion que me devuelva lo que ha ganado cada mesa en un periodo introducido como parametro
--Luego creo otra funcion que llame a la anterior, que sera la que reciba los parametros de fechas.
GO
ALTER FUNCTION [DineroSegunFechas](@fechaInicio DATE, @fechaFin DATE) RETURNS TABLE AS RETURN
SELECT COUNT(A.IDJugador) AS[Num Apuestas], SUM(A.Importe) AS[Dinero Apostado], GM.[Total Ganado], M.ID FROM COL_Mesas AS M
	INNER JOIN COL_Jugadas AS[J] ON M.ID = J.IDMesa
	INNER JOIN COL_Apuestas AS[A] ON J.IDMesa = A.IDMesa AND J.IDJugada = A.IDJugada
	INNER JOIN [GanadoxMesa]('2018-01-01', '2018-01-14') AS[GM] ON A.IDMesa = GM.ID
WHERE J.MomentoJuega BETWEEN (@fechaInicio) AND (@fechaFin)
GROUP BY M.ID, GM.[Total Ganado]
GO

SELECT * FROM DineroSegunFechas('2018-01-01', '2018-01-14')
ORDER BY ID

--Ejercicio 7
--El casino sospecha que algunos croupiers favorecen a ciertos jugadores. Para ello buscamos si algunos jugadores han sido especialmente 
--afortunados cuando han jugado en una mesa determinada.
--Haz una consulta que nos devuelva los nombres e IDs de los jugadores que han ganado un 30% más en una mesa en particular que en 
--la media de las otras.
SELECT * FROM COL_Jugadores
SELECT * FROM COL_Apuestas
SELECT * FROM COL_Jugadas
SELECT * FROM COL_NumerosApuesta

GO
CREATE VIEW [Media Mesas] AS
	--Ahora la media de cada mesa
	SELECT AVG(Ganado) AS[Media], M.IDMesa FROM (
		--Primero busco lo que ha ganado cada jugadador en cada mesa.
		SELECT SUM(A.Importe*TA.Premio) AS[Ganado], A.IDJugador, JU.IDMesa FROM COL_Jugadores AS[J]
			INNER JOIN COL_Apuestas AS[A] ON J.ID = A.IDJugador
			INNER JOIN COL_Jugadas AS[JU] ON A.IDJugada = Ju.IDJugada AND A.IDMesa = JU.IDMesa
			INNER JOIN COL_NumerosApuesta AS[NA] ON A.IDJugada = NA.IDJugada AND A.IDJugador = NA.IDJugador AND A.IDMesa = NA.IDMesa
			INNER JOIN COL_TiposApuesta AS[TA] ON A.Tipo = TA.ID
		WHERE JU.Numero = NA.Numero --Los que han ganado
		GROUP BY A.IDJugador, JU.IDMesa) AS[M]
	GROUP BY M.IDMesa
GO
--Tengo que obtener lo que ha ganado cada jugador en cada mesa y quedarme solo con los que han superado en un 30% la media de cada mesa.
--Ahora obtengo los que superan esa media un 30%
SELECT SUM(A.Importe*TA.Premio) AS[Ganado], A.IDJugador, JU.IDMesa FROM COL_Jugadores AS[J]
	INNER JOIN COL_Apuestas AS[A] ON J.ID = A.IDJugador
	INNER JOIN COL_Jugadas AS[JU] ON A.IDJugada = Ju.IDJugada AND A.IDMesa = JU.IDMesa
	INNER JOIN COL_NumerosApuesta AS[NA] ON A.IDJugada = NA.IDJugada AND A.IDJugador = NA.IDJugador AND A.IDMesa = NA.IDMesa
	INNER JOIN COL_TiposApuesta AS[TA] ON A.Tipo = TA.ID
	INNER JOIN [Media Mesas] AS[MM] ON Ju.IDMesa = MM.IDMesa
WHERE JU.Numero = NA.Numero
GROUP BY  A.IDJugador, JU.IDMesa, MM.Media
HAVING SUM(A.Importe*TA.Premio)*0.7 > MM.Media
ORDER BY IDJugador, IDMesa

SELECT * FROM [Media Mesas]