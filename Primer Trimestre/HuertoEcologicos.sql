CREATE DATABASE HuertosEcologicos
GO
USE HuertosEcologicos
GO

CREATE TABLE agricultores(
id tinyint IDENTITY(1,1) CONSTRAINT pk_agricultores PRIMARY KEY,
nombre varchar(10) null,
direccion varchar(15) null,
telefono char(9) not null,
)

CREATE TABLE tractores(
matricula char(7) CONSTRAINT pk_tractores PRIMARY KEY,
marca varchar(10) null,
modelo varchar(15) null,
id_agricultor tinyint not null,

CONSTRAINT fk_tractor_agricultor FOREIGN KEY (id_agricultor) REFERENCES agricultores(id)
	ON DELETE NO ACTION ON UPDATE CASCADE
)

CREATE TABLE fincas(
nombre char(10) CONSTRAINT pk_fincas PRIMARY KEY,
distancia tinyint not null,
municipio varchar(10) not null,
)

CREATE TABLE lotes(
id tinyint IDENTITY(1,1) CONSTRAINT pk_lotes PRIMARY KEY,
peso tinyint null,
fecha datetime not null,
finca_procedencia char(10) not null,
variedad varchar(20) not null,
id_agricultor tinyint not null,

CONSTRAINT fk_lotes_finca FOREIGN KEY (finca_procedencia) REFERENCES fincas(nombre)
	ON DELETE NO ACTION ON UPDATE CASCADE,
CONSTRAINT fk_lotes_agricultor FOREIGN KEY (id_agricultor) REFERENCES agricultores(id)
	ON DELETE NO ACTION ON UPDATE CASCADE
)

CREATE TABLE distribuidoras(
id tinyint not null IDENTITY(1,1) CONSTRAINT pk_distribuidoras PRIMARY KEY,
nombre varchar(7) not null,
direccion varchar(15) not null,
telefono char(9) not null,
)

CREATE TABLE remesas(
id char(5) CONSTRAINT pk_remesas PRIMARY KEY,
acidez char(4) not null,
cantidad tinyint null,
id_lote tinyint not null,
id_distribuidora tinyint null,

CONSTRAINT uq_remesa_lote UNIQUE (id_lote),
CONSTRAINT fk_remesa_lote FOREIGN KEY (id_lote) REFERENCES lotes(id)
	ON DELETE NO ACTION ON UPDATE CASCADE,
CONSTRAINT fk_remesa_distribuidora FOREIGN KEY (id_distribuidora) REFERENCES distribuidoras(id)
	ON DELETE NO ACTION ON UPDATE CASCADE
)

--Cuando tenemos una 1:1 y las cardinalidades son (1,1) desde donde propagamos la clave, su clave foranea debe ser NOT NULL.
--Recordar poner las restriccion UNIQUE cuando se trata de 1:1