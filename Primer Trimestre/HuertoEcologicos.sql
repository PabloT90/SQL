CREATE DATABASE HuertosEcologicos
GO
USE HuertosEcologicos
GO

CREATE TABLE agricultores(
id char(8) CONSTRAINT pk_agricultores PRIMARY KEY,
nombre varchar(10) null,
direccion varchar(15) null,
telefono char(9) not null,
)

CREATE TABLE tractores(
matricula char(7) CONSTRAINT pk_tractores PRIMARY KEY,
marca varchar(10) null,
modelo varchar(15) null,
id_agricultor char(8) not null,

CONSTRAINT fk_tractor_agricultor FOREIGN KEY (id_agricultor) REFERENCES agricultores(id)
)

CREATE TABLE fincas(
nombre char(10) CONSTRAINT pk_fincas PRIMARY KEY,
distancia tinyint not null,
municipio varchar(10) not null,
)

CREATE TABLE lotes(
id char(6) CONSTRAINT pk_lotes PRIMARY KEY,
peso tinyint null,
fecha datetime not null,
finca_procedencia char(10) not null,
variedad varchar(20) not null,
id_agricultor char(8) not null,

CONSTRAINT fk_lotes_finca FOREIGN KEY (finca_procedencia) REFERENCES fincas(nombre),
CONSTRAINT fk_lotes_agricultor FOREIGN KEY (id_agricultor) REFERENCES agricultores(id)
)

CREATE TABLE distribuidoras(
id char(3) CONSTRAINT pk_distribuidoras PRIMARY KEY,
nombre varchar(7) not null,
direccion varchar(15) not null,
telefono char(9) not null,
)

CREATE TABLE remesas(
id char(5) CONSTRAINT pk_remesas PRIMARY KEY,
acidez char(4) not null,
cantidad tinyint null,
id_lote char(6) not null,
id_distribuidora char(3) not null,

CONSTRAINT fk_remesa_lote FOREIGN KEY (id_lote) REFERENCES lotes(id),
CONSTRAINT fk_remesa_distribuidora FOREIGN KEY (id_distribuidora) REFERENCES distribuidoras(id),
)