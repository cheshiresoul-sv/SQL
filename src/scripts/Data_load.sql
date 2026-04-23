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

-- IMPORTAR CSV A LA TABLA inv_rubro
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

-- LIMPIAR Y CARGAR inv_sub_rubro
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

-- Paso único: cargar en tabla temporal y luego insertar en la final
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
