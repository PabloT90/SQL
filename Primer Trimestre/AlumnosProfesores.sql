CREATE DATABASE AlumnosProfesores
GO
USE AlumnosProfesores
GO

create table obligaciones(
codigo char(3) not null PRIMARY KEY,
denominacion char(10) not null,
isPuntual bit not null,
)

create table alumnos(
id tinyint not null PRIMARY KEY,
nombre varchar(10) not null,
apellidos varchar(20) not null,
direccion varchar(30) null,
telefono char(9) not null,
grupo tinyint not null,
)

create table obligacionesAlumnos(
idAlumno tinyint not null,
codigoObligacion char(3) not null,

CONSTRAINT pk_obligacionesAlumnos PRIMARY KEY(idAlumno,codigoObligacion),
CONSTRAINT fk_obligacionesAlumnos FOREIGN KEY (idAlumno) REFERENCES alumnos(id)
	ON DELETE NO ACTION ON UPDATE CASCADE,
CONSTRAINT fk_obligacionesAlumnos2 FOREIGN KEY (codigoObligacion) REFERENCES obligaciones(codigo)
	ON DELETE NO ACTION ON UPDATE CASCADE,
)

create table aulas(
id tinyint not null PRIMARY KEY,
numero tinyint not null,
superficie tinyint null,
tipo char(10) null,
)

create table profesores(
id tinyint not null PRIMARY KEY,
nombre varchar(10) not null,
apellidos varchar(20) not null,
direccion varchar(30) null,
telefono char(9) not null,
nombrePareja varchar(10) null,
)

create table alumProfAula(
idAlumno tinyint not null,
idProfesor tinyint not null,
idAula tinyint not null,

CONSTRAINT pk_alumProfAula PRIMARY KEY(idAlumno,idProfesor),
CONSTRAINT fk_alumProfAula FOREIGN KEY (idAlumno) REFERENCES alumnos(id)
	ON DELETE NO ACTION ON UPDATE CASCADE,
CONSTRAINT fk_alumProfAula2 FOREIGN KEY (idAula) REFERENCES aulas(id)
	ON DELETE NO ACTION ON UPDATE CASCADE,
CONSTRAINT fk_alumProfAula3 FOREIGN KEY (idProfesor) REFERENCES profesores(id)
	ON DELETE NO ACTION ON UPDATE CASCADE,
)

create table regalos(
id tinyint not null PRIMARY KEY,
nombre char(10)null,
precio tinyint null,
tipo char(10) not null,
idProfesor tinyint not null,

CONSTRAINT fk_regalos FOREIGN KEY (idProfesor) REFERENCES profesores(id)
	ON DELETE NO ACTION ON UPDATE CASCADE,
)

create table regalosAlumnos(
idAlumno tinyint not null,
idRegalo tinyint not null,

CONSTRAINT pk_regalosAlumnos PRIMARY KEY(idAlumno,idRegalo),
CONSTRAINT fk_regalosAlumnos FOREIGN KEY(idAlumno) REFERENCES alumnos(id)
	ON DELETE NO ACTION ON UPDATE CASCADE,
CONSTRAINT fk_regalosAlumnos2 FOREIGN KEY(idRegalo) REFERENCES regalos(id)
	ON DELETE NO ACTION ON UPDATE CASCADE,
)

create table NoComestibles(
idRegalo tinyint not null PRIMARY KEY,

CONSTRAINT fk_noComestibles FOREIGN KEY(idRegalo) REFERENCES regalos(id)
	ON DELETE NO ACTION ON UPDATE CASCADE,
)

create table comestibles(
idRegalo tinyint not null PRIMARY KEY,
fechaCaducidad datetime not null,

CONSTRAINT fk_Comestibles FOREIGN KEY(idRegalo) REFERENCES regalos(id)
	ON DELETE NO ACTION ON UPDATE CASCADE,
)
create table categorias(
nombre char(10) not null PRIMARY KEY,
)

create table catagoriasNoComestibles(
NombreCat char(10) not null,
IDregalo tinyint not null,
CONSTRAINT pk_categoriasNoComestibles PRIMARY KEY(nombreCat,IDregalo),
CONSTRAINT fk_catagoriasNoComestibles FOREIGN KEY(idRegalo) REFERENCES regalos(id)
	ON DELETE NO ACTION ON UPDATE CASCADE,
CONSTRAINT fk_catagoriasNoComestibles2 FOREIGN KEY(NombreCat) REFERENCES categorias(nombre)
	ON DELETE NO ACTION ON UPDATE CASCADE,
)

--Duda: en la generalizacion como la he dividido en 3 tablas creo que no llevan UNIQUE(?)

