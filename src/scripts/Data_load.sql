USE [Martinexsa]
GO

-- LIMPIAR TABLA inv_rubro
-------------------------------------------------------------------------------
DELETE FROM tst.inv_articulo;
DELETE FROM tst.inv_sub_rubro;
DELETE FROM tst.inv_rubro;
DELETE FROM tst.vta_pedido_detalle;
DELETE FROM tst.vta_pedido;
DELETE FROM tst.vta_cliente;
DELETE FROM tst.gral_individuo;


-- tst.inv_rubro
-------------------------------------------------------------------------------
BULK INSERT tst.inv_rubro
FROM 'C:\git\sql\Data\inv_rubro.csv'
WITH (
    FIRSTROW = 2,                -- omitir encabezado
    FIELDTERMINATOR = ';',       -- separador de columnas en tu CSV
    ROWTERMINATOR = '\n',        -- fin de línea
    TABLOCK
);
GO
SELECT * FROM tst.inv_rubro;
GO

-- inv_sub_rubro
-------------------------------------------------------------------------------
BULK INSERT tst.inv_sub_rubro
FROM 'C:\git\sql\Data\inv_sub_rubro.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ';',
    ROWTERMINATOR = '\n',
    TABLOCK
);
GO
SELECT * FROM tst.inv_sub_rubro;
GO

-- inv_articulo
BULK INSERT tst.inv_articulo
FROM 'C:\git\sql\Data\inv_articulo.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ';',
    ROWTERMINATOR = '\n',
    TABLOCK
);
GO
SELECT * FROM tst.inv_articulo;
GO

---[tst].[gral_zona_venta]
-------------------------------------------------------------------------------
CREATE TABLE #raw_zona (
    id_zona INT,
    nombre NVARCHAR(100),
    cod_region_pais NVARCHAR(50),
    agrupacion NVARCHAR(100),
    ventas_acumuladas_anio NVARCHAR(50),
    ventas_anio_pasado NVARCHAR(50),
    costos_acumulados_anio NVARCHAR(50),
    costos_anio_pasado NVARCHAR(50),
    guid_fila NVARCHAR(50),
    fecha_modificacion NVARCHAR(50)
);

BULK INSERT #raw_zona
FROM 'C:\git\sql\Data\gral_zona_venta.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ';',
    ROWTERMINATOR = '\r\n',
    CODEPAGE = '65001'
);

INSERT INTO tst.gral_zona_venta
SELECT
    id_zona,
    nombre,
    cod_region_pais,
    agrupacion,
    CAST(ventas_acumuladas_anio AS DECIMAL(18,4)),
    CAST(ventas_anio_pasado AS DECIMAL(18,4)),
    CAST(costos_acumulados_anio AS DECIMAL(18,4)),
    CAST(costos_anio_pasado AS DECIMAL(18,4)),
    CAST(guid_fila AS UNIQUEIDENTIFIER),
    CAST(fecha_modificacion AS DATETIME)
FROM #raw_zona;

DROP TABLE #raw_zona;

-- [tst].[vta_cliente]
-------------------------------------------------------------------------------
BULK INSERT tst.vta_cliente
FROM 'C:\git\sql\Data\vta_cliente.csv'
WITH (
    FIRSTROW = 2,                -- omitir encabezado
    FIELDTERMINATOR = ';',       -- separador de columnas en tu CSV
    ROWTERMINATOR = '\n',        -- fin de línea
    TABLOCK
);
GO
SELECT * FROM tst.vta_cliente;
GO

-- [tst].[vta_pedido]
-------------------------------------------------------------------------------
BULK INSERT tst.vta_pedido
FROM 'C:\git\sql\Data\vta_pedido.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ';',     -- cámbialo si tu archivo usa coma o tab
    ROWTERMINATOR = '\n',      -- prueba con '\n' si '\r\n' no funciona
    CODEPAGE = '65001',
    FIELDQUOTE = '"'           -- si observaciones trae ; o , dentro de comillas
);
GO
SELECT * FROM tst.vta_pedido
GO


-- [tst].[vta_pedido_detalle]
-------------------------------------------------------------------------------
CREATE TABLE #vta_pedido_detalle_raw(
    id_detalle VARCHAR(MAX),
    id_orden VARCHAR(MAX),
    guia_rastreo VARCHAR(MAX),
    cantidad VARCHAR(MAX),
    id_articulo VARCHAR(MAX),
    id_oferta_especial VARCHAR(MAX),
    precio_unitario VARCHAR(MAX),
    descuento_unitario VARCHAR(MAX),
    total_linea VARCHAR(MAX),
    guid_fila VARCHAR(MAX),
    fecha_modificacion VARCHAR(MAX)
);

-- 2. Cargar CSV en staging
BULK INSERT #vta_pedido_detalle_raw
FROM 'C:\git\sql\Data\vta_pedido_detalle.csv'
WITH(
    FIRSTROW = 2,
    FIELDTERMINATOR = ';',     -- cámbialo si tu archivo usa coma o tab
    ROWTERMINATOR = '\n',      -- prueba con '\n' si '\r\n' no funciona
    CODEPAGE = '65001',
    FIELDQUOTE = '"'           -- si observaciones trae ; o , dentro de comillas
);


INSERT INTO tst.vta_pedido_detalle(
    id_detalle,
    id_orden,
    guia_rastreo,
    cantidad,
    id_articulo,
    id_oferta_especial,
    precio_unitario,
    descuento_unitario,
    total_linea,
    guid_fila,
    fecha_modificacion
)
SELECT
    CAST(id_detalle AS INT),
    CAST(id_orden AS INT),
    guia_rastreo,
    CAST(cantidad AS INT),
    CAST(id_articulo AS INT),
    CAST(id_oferta_especial AS INT),
    CAST(precio_unitario AS DECIMAL(12,2)),
    CAST(descuento_unitario AS DECIMAL(12,2)),
    CAST(total_linea AS DECIMAL(12,2)),
    CAST(guid_fila AS UNIQUEIDENTIFIER),
    CAST(fecha_modificacion AS DATETIME)
FROM #vta_pedido_detalle_raw;
DROP TABLE  #vta_pedido_detalle_raw
go

select * from tst.vta_pedido_detalle