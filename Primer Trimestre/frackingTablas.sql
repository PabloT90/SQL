CREATE DATABASE fracking
go
--use universidades
--drop DATABASE fracking
USE fracking
go

CREATE TABLE parcelas(
id tinyint IDENTITY not null PRIMARY KEY,
nombreZona varchar(15) null,
extension smallint not null,
)

CREATE TABLE limites(
id smallint not null,
latitud tinyint not null,
longitud tinyint not null,

CONSTRAINT pk_limites PRIMARY KEY (id)
)

CREATE TABLE propietarios(
id smallint not null PRIMARY KEY,
nombre varchar(15) null,
apellidos varchar(20) null,
tlfno char(8) not null,
numSondeo tinyint not null,

CONSTRAINT ck_telefono2 CHECK(tlfno LIKE '[0-9],[0-9],[0-9],[0-9],[0-9],[0-9],[0-9],[0-9],[0-9]'),
--Numsondeo debe ser un numero entre 1 y 10
CONSTRAINT ck_numSonde CHECK(numSondeo between 1 and 10)
)

CREATE TABLE parcelasPropietarios(
id_propietario smallint not null,
id_parcela tinyint not null,

CONSTRAINT pk_parcelasPropietarios PRIMARY KEY(id_propietario,id_parcela),
CONSTRAINT fk_parcelasPropietarios FOREIGN KEY (id_propietario) REFERENCES propietarios(id)
	ON DELETE NO ACTION ON UPDATE CASCADE,
CONSTRAINT fk_parcelasPropietarios2 FOREIGN KEY (id_parcela) REFERENCES parcelas(id)
	ON DELETE NO ACTION ON UPDATE CASCADE,
)

CREATE TABLE parcelasLimites(
id_limite smallint not null,
id_parcela tinyint not null,

CONSTRAINT pk_parcelasLimites PRIMARY KEY (id_parcela),
CONSTRAINT fk_idParcelaLimites FOREIGN KEY (id_parcela) REFERENCES parcelas(id)
	ON DELETE NO ACTION ON UPDATE CASCADE,
CONSTRAINT fk_idLimites FOREIGN KEY (id_limite) REFERENCES limites(id)
	ON DELETE NO ACTION ON UPDATE CASCADE,
)

CREATE TABLE ecologistas(
id tinyint not null PRIMARY KEY,
nombre char(15) not null,
tlfno char(9) not null,

CONSTRAINT ck_telefono3 CHECK(tlfno LIKE '[0-9],[0-9],[0-9],[0-9],[0-9],[0-9],[0-9],[0-9],[0-9]')
)

CREATE TABLE parcelasEcologistas(
id_parcela tinyint not null,
id_ecologista tinyint not null,

CONSTRAINT pk_parcelasEcologistas PRIMARY KEY (id_parcela,id_ecologista),
CONSTRAINT fk_parcelaEcologista FOREIGN KEY (id_parcela) REFERENCES parcelas(id)
	ON DELETE NO ACTION ON UPDATE CASCADE,
CONSTRAINT fk_parcelaecologista2 FOREIGN KEY (id_ecologista) REFERENCES ecologistas(id)
	ON DELETE NO ACTION ON UPDATE CASCADE,
)

CREATE TABLE instituciones(
id tinyint not null PRIMARY KEY,
tlfno char(9) not null,

CONSTRAINT ck_telefono4 CHECK(tlfno LIKE '[0-9],[0-9],[0-9],[0-9],[0-9],[0-9],[0-9],[0-9],[0-9]')
)

CREATE TABLE parcelaInstituciones(
id_institucion tinyint not null,
id_parcela tinyint not null,

CONSTRAINT pk_parcelaInstituciones PRIMARY KEY (id_institucion,id_parcela),
CONSTRAINT fk_parcelaInstituciones FOREIGN KEY (id_parcela) REFERENCES parcelas(id)
	ON DELETE NO ACTION ON UPDATE CASCADE,
CONSTRAINT fk_parcelaInstituciones2 FOREIGN KEY (id_institucion) REFERENCES instituciones(id)
	ON DELETE NO ACTION ON UPDATE CASCADE,
)

CREATE TABLE espias(
nombre_clave char(15) not null PRIMARY KEY,
edad tinyint null,
)

CREATE TABLE actos(
id tinyint not null PRIMARY KEY,
lugar char(10) not null,
hora datetime not null,
id_ecologista tinyint not null,

CONSTRAINT fk_idParcela FOREIGN KEY (id_ecologista) REFERENCES ecologistas(id),

)

CREATE TABLE espiasActos(
nombre_clave_espia char(15) not null,
id_acto tinyint not null,

CONSTRAINT pk_espiasActos PRIMARY KEY (nombre_clave_espia,id_acto),
CONSTRAINT fk_espiasActos FOREIGN KEY (nombre_clave_espia) REFERENCES espias(nombre_clave)
	ON DELETE NO ACTION ON UPDATE CASCADE,
CONSTRAINT fk_espiasActos2 FOREIGN KEY (id_acto) REFERENCES actos(id)
	ON DELETE NO ACTION ON UPDATE CASCADE,
)

CREATE TABLE trabajadores(
id smallint not null PRIMARY KEY,
nombre char(15) not null,
apellidos char(20) not null,
tlfno char(9) null,
categoria varchar(15) not null,
id_institucion tinyint null,

CONSTRAINT fk_trabajadoresInstitucion FOREIGN KEY (id_institucion) REFERENCES instituciones(id),

--El telefono debe tener 9 cifras del 1 al 9.
CONSTRAINT ck_telefono CHECK(tlfno LIKE '[0-9],[0-9],[0-9],[0-9],[0-9],[0-9],[0-9],[0-9],[0-9]')
)

CREATE TABLE puntos_debiles(
nombre char(30) not null PRIMARY KEY,
)

CREATE TABLE DebilidadTrabajador(
nombre_puntoDebil char(30) not null,
id_trabajador smallint not null,

CONSTRAINT pk_DebilidadTrabajador PRIMARY KEY (nombre_puntoDebil,id_trabajador),
CONSTRAINT fk_DebilidadTrabajador FOREIGN KEY (nombre_puntoDebil) REFERENCES puntos_debiles(nombre)
	ON DELETE NO ACTION ON UPDATE CASCADE,
CONSTRAINT fk_DebilidadTrabajador2 FOREIGN KEY (id_trabajador) REFERENCES trabajadores(id)
	ON DELETE NO ACTION ON UPDATE CASCADE,
)

CREATE TABLE ActosTrabajadores(
id_acto tinyint not null,
id_trabajador smallint not null,

CONSTRAINT pk_ActosTrabajadores PRIMARY KEY (id_acto,id_trabajador),
CONSTRAINT fk_ActosTrabajadores FOREIGN KEY (id_acto) REFERENCES actos(id)
	ON DELETE NO ACTION ON UPDATE CASCADE,
CONSTRAINT fk_ActosTrabajadores2 FOREIGN KEY (id_trabajador) REFERENCES trabajadores(id)
	ON DELETE NO ACTION ON UPDATE CASCADE,
)
--Hacer las restricciones check. y ya estaria.