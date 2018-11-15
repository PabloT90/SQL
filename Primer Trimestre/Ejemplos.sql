CREATE DATABASE Ejemplos
GO
USE Ejemplos
GO
--Drop Ejemplos
CREATE TABLE DatosRestrictivos(
ID smallint not null PRIMARY KEY,
nombre char(15) not null, --UNIQUE
NumPelos int null,
tipoRopa char(1) null,
numSuerte tinyint null,
Minutos tinyint null,

CONSTRAINT UQ_Nombre UNIQUE (nombre),
CONSTRAINT CK_ID check (ID % 2 != 0), --Se rellena con numero impares.
CONSTRAINT CK_Nombre check (Nombre NOT LIKE '[NX]%'), --No empiece por N o X
CONSTRAINT CK_NumPelos check (NumPelos between 0 and 145000),-- Comprendido entre 0 y 145.000
CONSTRAINT CK_NumSuerte check (NumSuerte % 3 = 0), --Sea divisible entre 3.
CONSTRAINT CK_Minutos check ((minutos between 20 and 58) and (minutos between 120 and 185)), --Que este entre esos intervalos.
)

CREATE TABLE DatosRelacionados(
NombreRelacionado char(15) not null,

--Deberiamos poner la misma restriccion que en la columna correspondiente?
-- No.
--Que ocurriria si la ponemos?
-- 
--Y si no la ponemos?
--

PalabraTabu varchar(20) not null,
NumRarito tinyint null,
NumMasGrande smallint not null PRIMARY KEY,
--Puede tener valores menores que 20?
--No, crearia conflictos. Debemos establecer una restriccion en NumRarito

CONSTRAINT FK_DatosRelacionados_DatosRestrictivos FOREIGN KEY (NombreRelacionado) REFERENCES DatosRestrictivos(nombre),
CONSTRAINT CK_PalabraTabu check (PalabraTabu not in('Barcenas','gurtel','punica','bankia','sobre')),
CONSTRAINT CK_NumMasGrande check (numMasGrande between NumRarito and 1000),
)

CREATE TABLE DatosAlMogollon(
ID smallint not null,
LimiteSuperior smallint null,
OtroNumero smallint null, --UNIQUE
NumeroQueVinoDelMasAlla smallint null,
Etiqueta char(3) not null,

CONSTRAINT FK_DatosAlMogollon_DtosRelacionados FOREIGN KEY (NumeroQueVinoDelMasAlla) references DatosRelacionados(NumMasGrande),
CONSTRAINT UQ_OtroNumero UNIQUE (OtroNumero),
CONSTRAINT CK_DatosMogollonID check (ID %5 != 0),
CONSTRAINT CK_LimiteSuperior check (limiteSuperior between 1500 and 2000),
CONSTRAINT CK_OtroNumero check (otroNumero > ID and otroNumero < LimiteSuperior),
CONSTRAINT CK_Etiqueta check (etiqueta not in('pao','peo','pio','puo')),
)