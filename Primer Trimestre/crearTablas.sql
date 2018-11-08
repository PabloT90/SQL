CREATE DATABASE Universidades
GO
USE Universidades
GO
--drop database universidades
CREATE TABLE universidades(
id char(5) not null CONSTRAINT PK_universidades PRIMARY KEY,
nombre varchar(15) null,
fundacion datetime null,
)

CREATE TABLE modalidades(
id tinyint not null CONSTRAINT PK_modalidades PRIMARY KEY,
isIndividual bit not null,
)

CREATE TABLE deportes(
id tinyint not null CONSTRAINT PK_deportes PRIMARY KEY,
nombre varchar(10) null,
)

CREATE TABLE deportistas(
id tinyint not null CONSTRAINT PK_deportistas PRIMARY KEY,
id_universidad char(5) not null,
id_deportes tinyint not null,
nombre varchar(10) null,
apellidos varchar(15) null,
edad datetime not null,

CONSTRAINT FK_deportistas_universidades FOREIGN KEY (id_universidad) REFERENCES universidades(id)
	ON DELETE NO ACTION ON UPDATE CASCADE,
CONSTRAINT FK_deportistas_deportes FOREIGN KEY (id_deportes) REFERENCES deportes(id)
	ON DELETE NO ACTION ON UPDATE CASCADE
)

CREATE TABLE deportistas_modalidades (
id_deportistas tinyint not null,
id_modalidades tinyint not null,
clasificacion tinyint not null,

CONSTRAINT PK_deportistas_modalidades PRIMARY KEY(id_deportistas, id_modalidades),
CONSTRAINT FK_deportistas_modalidades FOREIGN KEY (id_deportistas) REFERENCES deportistas (id)
	ON DELETE NO ACTION ON UPDATE CASCADE,
CONSTRAINT FK_deportistas_modalidades2 FOREIGN KEY (id_modalidades) REFERENCES modalidades (id)
	ON DELETE NO ACTION ON UPDATE CASCADE,
)

CREATE TABLE comites(
id char(5) not null CONSTRAINT PK_comites PRIMARY KEY,
id_universidad char(5) not null,
domicilio varchar(20) null,
telefono char(9) null,

CONSTRAINT FK_comites_universidades FOREIGN KEY (id_universidad) REFERENCES universidades(id)
	ON DELETE CASCADE ON UPDATE CASCADE-- Ojo aqui, ON DELETE CASCADE porque se trata de una entidad debil.
)

CREATE TABLE presidentes(
id tinyint not null CONSTRAINT PK_presidente PRIMARY KEY,
nombre varchar(10) null,
apellidos varchar(15) null,
)

CREATE TABLE presidente_comite(
id_comite char(5) not null,
id_presidente tinyint not null,

CONSTRAINT PK_presidente_comite PRIMARY KEY (id_comite, id_presidente),
CONSTRAINT FK_presidente_comite FOREIGN KEY (id_comite) REFERENCES comites(id)
	ON DELETE NO ACTION ON UPDATE CASCADE,
CONSTRAINT FK_presidente_comite3 FOREIGN KEY (id_presidente) REFERENCES presidentes(id)
	ON DELETE NO ACTION ON UPDATE CASCADE
)

CREATE TABLE delegados(
id tinyint not null CONSTRAINT PK_delegados PRIMARY KEY,
id_comite char(5) not null,
id_deporte tinyint not null,
nombre varchar(10) null,
apellidos varchar(15) null,

CONSTRAINT FK_delegados_comite FOREIGN KEY (id_comite) REFERENCES comites(id)
	ON DELETE NO ACTION ON UPDATE CASCADE,
CONSTRAINT FK_delegados_deportes FOREIGN KEY (id_deporte) REFERENCES deportes(id)
	ON DELETE NO ACTION ON UPDATE CASCADE
)

--Si es reflexiva es no action las 2.
--Si es debil las 2 son cascade.
--Si es 1:N y al propagar la clave  del 1(depende de esta cardinalidad)  al N, debera ser null o not null segun la cardinalidad.