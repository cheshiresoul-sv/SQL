-- ROLLBACK DE BASE DE DATOS
-------------------------------------------------------------------------------
-- Elimina tablas dependientes primero (por claves foráneas), luego las bases

-- VENTAS
-------------------------------------------------------------------------------
IF OBJECT_ID(N'tst.vta_pedido_detalle', 'U') IS NOT NULL
    DROP TABLE tst.vta_pedido_detalle;
GO

IF OBJECT_ID(N'tst.vta_pedido', 'U') IS NOT NULL
    DROP TABLE tst.vta_pedido;
GO

IF OBJECT_ID(N'tst.vta_cliente', 'U') IS NOT NULL
    DROP TABLE tst.vta_cliente;
GO

-- INVENTARIO
-------------------------------------------------------------------------------
IF OBJECT_ID(N'tst.inv_articulo', 'U') IS NOT NULL
    DROP TABLE tst.inv_articulo;
GO

IF OBJECT_ID(N'tst.inv_sub_rubro', 'U') IS NOT NULL
    DROP TABLE tst.inv_sub_rubro;
GO

IF OBJECT_ID(N'tst.inv_rubro', 'U') IS NOT NULL
    DROP TABLE tst.inv_rubro;
GO

-- GENERAL
-------------------------------------------------------------------------------
IF OBJECT_ID(N'tst.gral_zona_venta', 'U') IS NOT NULL
    DROP TABLE tst.gral_zona_venta;
GO

IF OBJECT_ID(N'tst.gral_individuo', 'U') IS NOT NULL
    DROP TABLE tst.gral_individuo;
GO

-- ELIMINACIÓN DE SCHEMA
-------------------------------------------------------------------------------
IF EXISTS (SELECT * FROM sys.schemas WHERE name = 'tst')
BEGIN
    DROP SCHEMA tst;
END
GO

-- Cambiar a master para no estar dentro de Martinexsa
USE master;
GO

-- Forzar desconexión y eliminar la base
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'Martinexsa')
BEGIN
    ALTER DATABASE Martinexsa SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE Martinexsa;
END
GO

