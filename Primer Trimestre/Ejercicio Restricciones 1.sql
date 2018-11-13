If Not Exists (SELECT * From Sys.databases Where name = 'Ejemplos' )
	Create Database Ejemplos
GO
USE Ejemplos
GO

CREATE TABLE CriaturitasRaras(
	ID tinyint NOT NULL,
	Nombre nvarchar(30) NULL,
	FechaNac Date NULL, 
	NumeroPie SmallInt NULL,
	NivelIngles NChar(2) NULL,
	Historieta VarChar(30) NULL,
	NumeroChico TinyInt NULL,
	NumeroGrande BigInt NULL,
	NumeroIntermedio SmallInt NULL,
CONSTRAINT [PK_CriaturitasEx] PRIMARY KEY(ID),

--NumeroPie debe estar entre 25 y 60
CONSTRAINT CK_numeroPie check (NumeroPie between 25 and 60),

--NumeroChico debe ser menor que 1.000
CONSTRAINT CK_numeroChico check (numeroChico < 1000),

--NumeroGrande debe ser mayor que NumeroChico multiplicado por 100.
CONSTRAINT ck_numeroGrande check (numeroGrande > NumeroChico*1000),

--NumeroMediano debe ser par y estar comprendido entre NumeroChico y NumeroGrande
CONSTRAINT ck_numeroMediano check(NumeroIntermedio %2 !=0 and (NumeroIntermedio between NumeroChico and NumeroGrande)),

--FechaNacimiento tienen que ser anterior a la actual (CURRENT_TIMESTAMP)
CONSTRAINT ck_fechaNacimiento check (FechaNac < CURRENT_TIMESTAMP),

--El nivel de inglés debe tener uno de los siguientes valores: A0, A1, A2, B1, B2, C1 o C2.
CONSTRAINT ck_NivelIngles check (NivelIngles in ('A0','A1','A2','B1','B2','C1','C2')),

--Historieta no puede contener las palabras "oscuro" ni "apocalipsis"
CONSTRAINT ck_Historieta check (historieta not in('oscuro','apocalipsis')),

--Temperatura debe estar comprendido entre 32.5 y 44.
--¿Temperatura?
) 
GO