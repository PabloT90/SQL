--N�mero de veces que ha actuado cada cantaor en cada festival de la provincia de C�diz,
--incluyendo a los que no han actuado nunca.
SELECT * FROM F_Cantaores
SELECT * FROM F_Festivales_Cantaores
SELECT * FROM F_Festivales
SELECT COUNT(FC.Cod_Festival) AS[Veces Cantadas], C.Nombre_Artistico FROM F_Cantaores AS[C]
	LEFT JOIN F_Festivales_Cantaores AS[FC] ON C.Codigo = FC.Cod_Cantaor
	LEFT JOIN F_Festivales AS[F] ON FC.Cod_Festival = F.Cod AND F.Provincia = 'CA'
		--WHERE F.Provincia = 'CA'
		GROUP BY C.Nombre_Artistico
--Si le ponemos la condicion en el WHERE estamos eliminando los que no han cantado en Cadiz.

--Ejercicio 2
--Crea un nuevo palo llamado �Ton�.
--Haz que todos los cantaores que cantaban Bamberas o Peteneras canten Ton�s. No utilices
--los c�digos de los palos, sino sus nombres.


--Ejercicio 3
--N�mero de cantaores mayores de 30 a�os que han actuado cada a�o en cada pe�a. Se
--contar� la edad que ten�an en el a�o de la actuaci�n.


--Ejercicio 4
--Cantaores (nombre, apellidos y nombre art�stico) que hayan actuado m�s de dos veces en
--pe�as de la provincia de Sevilla y canten Fandangos o Buler�as. S�lo se incluyen las
--actuaciones directas en Pe�as, no los festivales.


--Ejercicio 5
--N�mero de actuaciones que se han celebrado en cada pe�a, incluyendo actuaciones directas
--y en festivales. Incluye el nombre de la pe�a y la localidad.
