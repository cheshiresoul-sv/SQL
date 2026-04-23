USE master
-- CREACIÓN DE BASE DE DATOS
-------------------------------------------------------------------------------
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'Martinexsa')
BEGIN
    CREATE DATABASE Martinexsa;
END
GO

-- CONEXIÓN A LA BASE
-------------------------------------------------------------------------------
USE Martinexsa;
GO

-- CREACIÓN DE SCHEMA PRINCIPAL
-------------------------------------------------------------------------------
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'tst')
BEGIN
    EXEC('CREATE SCHEMA tst');
END
GO

-- GENERAL (tablas base)
-------------------------------------------------------------------------------
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'tst.gral_individuo') AND type = 'U')
BEGIN
    CREATE TABLE tst.gral_individuo (
        id_entidad              INT             PRIMARY KEY,
        tipo_sujeto             VARCHAR(50),
        estilo_nombre           VARCHAR(50),
        tratamiento             VARCHAR(50),
        primer_nombre           VARCHAR(100),
        segundo_nombre          VARCHAR(100),
        primer_apellido         VARCHAR(100),
        sufijo                  VARCHAR(50),
        suscripcion_email       VARCHAR(100),    
        info_contacto_extra     VARCHAR(MAX),
        datos_demograficos      VARCHAR(MAX),
        guid_fila               UNIQUEIDENTIFIER,
        fecha_modificacion      DATETIME
    );
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'tst.gral_zona_venta') AND type = 'U')
BEGIN
      CREATE TABLE tst.gral_zona_venta (
        id_zona                 INT             PRIMARY KEY,
        nombre                  VARCHAR(100),
        cod_region_pais         VARCHAR(50),
        agrupacion              VARCHAR(100),
        ventas_acumuladas_anio  DECIMAL(18,4),   -- antes 12,2
        ventas_anio_pasado      DECIMAL(18,4),
        costos_acumulados_anio  DECIMAL(18,4),
        costos_anio_pasado      DECIMAL(18,4),
        guid_fila               UNIQUEIDENTIFIER,
        fecha_modificacion      DATETIME
    );
END
GO

-- INVENTARIO
-------------------------------------------------------------------------------
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'tst.inv_rubro') AND type = 'U')
BEGIN
    CREATE TABLE tst.inv_rubro (
        id_rubro                INT             PRIMARY KEY,
        nombre                  VARCHAR(100),
        guid_fila               UNIQUEIDENTIFIER,
        fecha_modificacion      DATETIME
    );
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'tst.inv_sub_rubro') AND type = 'U')
BEGIN
    CREATE TABLE tst.inv_sub_rubro (
        id_sub_rubro            INT             PRIMARY KEY,
        id_rubro                INT             FOREIGN KEY REFERENCES tst.inv_rubro(id_rubro),
        nombre                  VARCHAR(100),
        guid_fila               UNIQUEIDENTIFIER,
        fecha_modificacion      DATETIME
    );
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'tst.inv_articulo') AND type = 'U')
BEGIN
    CREATE TABLE tst.inv_articulo (
        id_articulo             INT             PRIMARY KEY,
        descripcion             VARCHAR(255),
        codigo_interno          VARCHAR(100),
        es_fabricado            VARCHAR(50),
        es_producto_final       VARCHAR(50),
        color                   VARCHAR(50),
        nivel_stock_seguridad   INT,
        punto_reorden           INT,
        costo_base              DECIMAL(12,2),
        precio_venta            DECIMAL(12,2),
        talla                   VARCHAR(50),
        unidad_medida_talla     VARCHAR(50),
        unidad_medida_pisa      VARCHAR(50),
        peso                    DECIMAL(12,2),
        dias_produccion         INT,
        linea_mercancia         VARCHAR(100),
        clase                   VARCHAR(100),
        estilo                  VARCHAR(100),
        id_subcategoria         INT,
        id_modelo               INT,
        fecha_inicio_venta      DATE,
        fecha_fin_venta         DATE,
        fecha_descontinuado     DATE,
        guid_fila               UNIQUEIDENTIFIER,
        fecha_modificacion      DATETIME
    );
END
GO

-- VENTAS
-------------------------------------------------------------------------------
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'tst.vta_cliente') AND type = 'U')
BEGIN
    CREATE TABLE tst.vta_cliente (
        id_cliente              INT             PRIMARY KEY,
        id_persona              INT             NULL FOREIGN KEY REFERENCES tst.gral_individuo(id_entidad), -- ahora permite NULL
        id_tienda               INT,
        id_territorio           INT             FOREIGN KEY REFERENCES tst.gral_zona_venta(id_zona),
        numero_cuenta           VARCHAR(100),
        guid_fila               UNIQUEIDENTIFIER,
        fecha_modificacion      DATETIME
    );
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'tst.vta_pedido') AND type = 'U')
BEGIN
    CREATE TABLE tst.vta_pedido (
        id_orden                INT             PRIMARY KEY,
        num_revision            INT,
        fecha_pedido            DATE,
        fecha_vencimiento       DATE,
        fecha_envio             DATE,
        estado                  VARCHAR(50),
        es_pedido_online        VARCHAR(10),     
        folio_pedido            VARCHAR(100),
        orden_compra_cliente    VARCHAR(100),
        numero_cuenta           VARCHAR(100),
        id_cliente              INT             FOREIGN KEY REFERENCES tst.vta_cliente(id_cliente),
        id_vendedor             INT,
        id_territorio           INT             FOREIGN KEY REFERENCES tst.gral_zona_venta(id_zona),
        id_direccion_facturacion INT,
        id_direccion_envio      INT,
        id_metodo_envio         INT,
        id_tarjeta_credito      INT,
        codigo_autorizacion_tc  VARCHAR(100),
        id_tasa_cambio          INT,
        sub_total               DECIMAL(18,4),
        impuestos               DECIMAL(18,4),
        flete                   DECIMAL(18,4),
        total_neto              DECIMAL(18,4),
        observaciones           VARCHAR(MAX),
        guid_fila               UNIQUEIDENTIFIER,
        fecha_modificacion      DATETIME

    );
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'tst.vta_pedido_detalle') AND type = 'U')
BEGIN
CREATE TABLE [tst].[vta_pedido_detalle](
	[id_detalle] [int] NOT NULL,
	[id_orden] [int] NOT NULL,
	[guia_rastreo] [varchar](100) NULL,
	[cantidad] [int] NULL,
	[id_articulo] [int] NULL,
	[id_oferta_especial] [int] NULL,
	[precio_unitario] [decimal](12, 2) NULL,
	[descuento_unitario] [decimal](12, 2) NULL,
	[total_linea] [decimal](12, 2) NULL,
	[guid_fila] [uniqueidentifier] NULL,
	[fecha_modificacion] [datetime] NULL,
 CONSTRAINT [PK_vta_pedido_detalle] PRIMARY KEY CLUSTERED 
(
	[id_detalle] ASC,
	[id_orden] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

END
GO

ALTER TABLE [tst].[vta_pedido_detalle]  WITH CHECK ADD FOREIGN KEY([id_articulo])
REFERENCES [tst].[inv_articulo] ([id_articulo])
GO



use master
go