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
	INNER JOIN COL_Apuestas AS A ON J.IDJugada = A.IDJugada
WHERE A.Tipo IN(10, 13, 15)
GROUP BY J.Numero, A.Tipo
ORDER BY [Veces Apostados] DESC

--Ejercicio 2
--El casino quiere fomentar la participación y decide regalar saldo extra a los jugadores que hayan apostado más de tres veces 
--en el último mes. Se considera el mes de febrero.
--La cantidad que se les regalará será un 5% del total que hayan apostado en ese mes
SELECT * FROM COL_Apuestas
SELECT * FROM COL_Jugadas

SELECT * FROM COL_Jugadores
--Planteamiento:
--Sacar las veces que ha apostado y el total apostado en febero. Luego se les añade ese 5%
SELECT SUM(A.Importe) AS[Total Apostado], A.IDJugador FROM COL_Apuestas AS[A]
	INNER JOIN COL_Jugadas AS[J] ON A.IDJugada = J.IDJugada
	WHERE MONTH(MomentoJuega) = 2 --Lo pongo asi porque en este caso la BBDD trabaja solo en 2018
GROUP BY A.IDJugador
HAVING COUNT(A.IDjugador) > 3
ORDER BY IDJugador

--Faltaria añadirle el saldo a cada jugador. Aun no se hacerlo

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
--Ejercicio 3
--El día 2 de febrero se celebró el día de la marmota. Para conmemorarlo, el casino ha decidido volver a repetir todas las jugadas 
--que se hicieron ese día, pero poniéndoles fecha de mañana (con la misma hora) y permitiendo que los jugadores apuesten. 
--El número ganador de cada jugada se pondrá a NULL y el NoVaMas a 0.
--Crea esas nuevas filas con una instrucción INSERT-SELECT


--Ejercicio 4
--Crea una vista que nos muestre, para cada jugador, nombre, apellidos, Nick, número de apuestas realizadas, total de dinero apostado y 
--total de dinero ganado/perdido.


--Ejercicio 5
--Nos comunican que la policía ha detenido a nuestro cliente Ombligo Pato por delitos de estafa, falsedad, administración desleal y 
--mal gusto para comprar bañadores. 
--Dado que nuestro casino está en Gibraltar, siguiendo la tradición de estas tierras, queremos borrar todo rastro de su paso 
--por nuestro casino.
--Borra todas las apuestas que haya realizado, pero no busques su ID a mano en la tabla COL_Clientes. Utiliza su Nick (bankiaman) 
--para identificarlo en la instrucción DELETE.