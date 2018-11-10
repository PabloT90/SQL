CREATE DATABASE URBANIZACION
GO
USE URBANIZACION
GO

--drop database urbanizacion

CREATE TABLE PERSONAS(
id tinyint IDENTITY(1,1)not null CONSTRAINT PK_personas PRIMARY KEY,
nombre varchar(10) not null,
apellidos varchar(20)not null,
--id_vivienda tinyint not null, Se añade abajo. Sino, daria un fallo
id_personaHijo tinyint null,
id_personaPareja tinyint null,

CONSTRAINT FK_personaHijo FOREIGN KEY (id_personaHijo) REFERENCES personas(id)
	ON DELETE NO ACTION ON UPDATE NO ACTION,
CONSTRAINT FK_personaPareja FOREIGN KEY (id_personaPareja) REFERENCES personas(id)
	ON DELETE NO ACTION ON UPDATE NO ACTION,
	CONSTRAINT UQ_persona_pareja UNIQUE (id_personaPareja), --Debe ser UNIQUE porque es 1:1
)

CREATE TABLE VIVIENDAS(
id tinyint IDENTITY(1,1)not null CONSTRAINT PK_viviendas PRIMARY KEY,
dormitorios tinyint null,
id_persona tinyint null,

CONSTRAINT FK_viviendas_personas FOREIGN KEY (id_persona) REFERENCES personas(id)
	ON DELETE NO ACTION ON UPDATE CASCADE
)

CREATE TABLE VEHICULOS(
id smallint IDENTITY(1,1)not null CONSTRAINT PK_vehiculos PRIMARY KEY,
matricula char(7) not null,
marca varchar(10) null,
id_persona tinyint not null,

CONSTRAINT FK_vehiculos_persona FOREIGN KEY (id_persona) REFERENCES personas(id)
	ON DELETE NO ACTION ON UPDATE CASCADE
)

CREATE TABLE RECIBOS(
id tinyint IDENTITY(1,1)not null CONSTRAINT PK_recibos PRIMARY KEY,
cantidad tinyint not null,
id_vivienda tinyint not null,
esAbonado bit not null,

CONSTRAINT FK_recibos_vivienda FOREIGN KEY (id_vivienda) REFERENCES viviendas(id)
	ON DELETE NO ACTION ON UPDATE CASCADE,
)
ALTER TABLE Personas ADD id_vivienda tinyint not null
ALTER TABLE Personas ADD CONSTRAINT FK_personas_viviendas FOREIGN KEY (id_vivienda) REFERENCES viviendas(id)
		ON DELETE NO ACTION ON UPDATE NO ACTION --Si ambas no fuesen NO ACTION se podrian producir ciclos.

--Creo que me falta poner UNIQUE en la generalizacion...