CREATE DATABASE LeoBikes
GO
USE LeoBikes
GO
--Incluye catálogo e inventario
CREATE TABLE LB_Productos(--Incluye catálogo e inventario
	Codigo Char(5) not null 
	,Nombre VarChar(40) not null default 'Producto Generico'
	,PVP SmallMoney
	,Stock_Actual SmallInt
	,Stock_Minimo TinyInt
	,Constraint PK_Productos Primary Key (Codigo)
	)
GO

				
-- Eso. Los que pagan
CREATE TABLE LB_Clientes(
	DI Char (10) Not Null
	,Apellidos VarChar(25) Not Null
	,Nombre VarChar(15) Not Null
	,Localidad VarChar(15) Null
	,Descuento TinyInt Default 0
	,SaldoPuntos SmallInt Not Null
	,Constraint PK_Clientes Primary Key (DI)
	)
GO
						-- Pedidos recibidos de nuestros clientes
CREATE TABLE LB_Pedidos(
	Codigo Int IDENTITY Not Null
	,DI_Cliente Char(10) default '00000002'
	,Fecha_Creacion SmallDateTime not null default CURRENT_TIMESTAMP
	,Fecha_Servido SmallDateTime null
	,Constraint PK_Pedidos Primary Key (Codigo)
	,Constraint FK_Pedidos_Clientes Foreign Key (DI_Cliente) REFERENCES LB_Clientes (DI)
		ON UPDATE CASCADE ON DELETE NO ACTION
	)
GO
CREATE TABLE LB_Lineas_Pedido(
	Cod_Pedido Int Not Null
	,Cod_producto Char(5) Not Null
	,Cantidad int Not Null Default 1
	,Precio SmallMoney Not Null
	,Constraint PK_Lineas_Pedido Primary Key (Cod_Pedido, Cod_Producto)
	,Constraint FK_LineasPedido_Pedidos Foreign Key (Cod_Pedido) REFERENCES LB_Pedidos (Codigo)
		ON UPDATE CASCADE ON DELETE CASCADE
	,Constraint FK_LineasPedido_Producto Foreign Key (Cod_Producto) REFERENCES LB_Productos (Codigo)
		ON UPDATE CASCADE ON DELETE NO ACTION
	)

CREATE TABLE LB_Facturas(
	Codigo Int not null Identity Primary Key
	,DI_Cliente Char(10) default '00000001'
	,Fecha smalldatetime not null default CURRENT_TIMESTAMP
	,Fecha_Cobro Date null
	,Importe Money
	,Constraint	FK_Facturas_Clientes Foreign Key (DI_Cliente) REFERENCES LB_Clientes (DI)
		ON UPDATE CASCADE ON DELETE NO ACTION
	)
GO
-- Relación entre Facturas y Productos
CREATE TABLE LB_Lineas_Factura(
	Cod_Factura Int Not Null,
	Cod_Producto Char(5) Not Null,
	Cantidad Int Not Null default 1,
	Precio SmallMoney Not Null,
	Constraint PK_LineasFactura Primary Key (Cod_Factura, Cod_Producto),
	Constraint FK_LineasFactura_Factura Foreign Key (Cod_Factura) REFERENCES LB_Facturas (Codigo),
	Constraint FK_LineasFactura_Productos Foreign Key (Cod_Producto) REFERENCES LB_Productos (Codigo)
	)

CREATE TABLE LB_Avisos(
id_producto char(5) not null PRIMARY KEY,
fecha_creacion date null,
stockMinimo int not null,
stockActual int not null,

CONSTRAINT FK_LB_Avisos FOREIGN KEY (id_producto) REFERENCES LB_Productos(codigo)
)

--Sobre la tabla LB_Productos añade un valor por defecto a las columnas
--Stock_Actual (0) y Stock_Minimo (0).ALTER TABLE LB_Productos ADD DEFAULT '0' FOR Stock_ActualALTER TABLE LB_Productos ADD DEFAULT '0' FOR Stock_Minimo--Añade un valor por defecto a la columna SaldoPuntos de la tabla LB_Clientes
--con valor 0. Añádele también una restricción para que su valor no pueda ser
--inferior a cero.
ALTER TABLE LB_Clientes ADD DEFAULT '0' FOR SaldoPuntos
ALTER TABLE LB_Clientes ADD CONSTRAINT ck_clientes CHECK(SaldoPuntos > 0)
--En la tabla LB_Avisos, añade un valor por defecto a la columna Fecha_Crea
--que sea la fecha actual. Añade una columna Fecha_Actualiza del mismo
--tipo que Fecha_Creacion, pero que sí admita valores nulos. Esta nueva columna
--tendrá el mismo valor por defecto.
ALTER TABLE LB_Avisos ADD DEFAULT getDate() FOR Fecha_Creacion
ALTER TABLE LB_Avisos ADD COLUMN Fecha_Actualiza 