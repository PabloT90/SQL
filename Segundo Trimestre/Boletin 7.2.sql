--Introducir unos datos dados.
SELECT * FROM Carros
BEGIN TRAN
INSERT INTO Carros VALUES
	(1,'seat','ibiza',2014,'blanco',null),
	(2,'ford','focus',2016,'rojo',1),
	(3,'toyota','prius',2014,'blanco',4),
	(5,'renault','megane',2014,'azul',2),
	(8,'mitsubishi','colt',2014,'rojo',6)
commit tran

SELECT * FROM People

begin tran
INSERT INTo People VALUES
	(1,'Eduardo','Mingo','14-07-1990'),
	(2,'Margarita','padera','11-11-1992'),
	(4,'Eloisa','lamandra','02-03-2000'),
	(5,'jordi','videndo','28-05-1989'),
	(6,'alfonso','sito','10-10-1978')
commit tran

begin tran
INSERT INTO Libros VALUES
	(2,'el corazon de las tinieblas','Joseph Conrad'),
	(4,'Cien años de soledad','Gabriel García Márquez'),
	(8,'Harry Potter y la cámara de los secretos','J. K. Rowling'),
	(16,'Evangelio del Flying Spaguetti Monster','Bobby Henderson')
commit tran