CREATE DATABASE URBANIZACION
GO
USE URBANIZACION
GO

CREATE TABLE VIVIENDAS(
id tinyint IDENTITY(1,1)not null CONSTRAINT PK_viviendas PRIMARY KEY,
dormitorios tinyint null,
id_persona tinyint null,

CONSTRAINT FK_viviendas_personas FOREIGN KEY (id_persona) REFERENCES personas(id)
)

CREATE TABLE PERSONAS(
id tinyint IDENTITY(1,1)not null CONSTRAINT PK_personas PRIMARY KEY,
nombre varchar(10) not null,
apellidos varchar(20)not null,
id_vivienda tinyint not null,

CONSTRAINT FK_personas_viviendas FOREIGN KEY (id_vivienda) REFERENCES viviendas(id)
)

CREATE TABLE VEHICULOS(
id smallint IDENTITY(1,1)not null CONSTRAINT PK_vehiculos PRIMARY KEY,
matricula char(7) not null,
marca varchar(10) null,
id_persona tinyint not null,

CONSTRAINT FK_vehiculos_persona FOREIGN KEY (id_persona) REFERENCES personas(id)
)

CREATE TABLE RECIBOS(
id tinyint IDENTITY(1,1)not null CONSTRAINT PK_recibos PRIMARY KEY,
cantidad tinyint not null,
id_vivienda tinyint not null,
esAbonado bit not null,

CONSTRAINT FK_recibos_vivienda FOREIGN KEY (id_vivienda) REFERENCES viviendas(id)
)