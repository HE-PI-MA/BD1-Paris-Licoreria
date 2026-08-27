-- ============================================================
-- PARÍS LICORERÍA
-- DATOS DE PRUEBA INTEGRAL
-- ============================================================
-- Ejecutar después de:
-- 01_creacion_bd.sql
-- 02_creacion_tablas.sql
-- 03_datos_iniciales.sql
-- 04_vistas.sql
-- ============================================================

USE paris_licoreria;

SET NAMES utf8mb4;
SET CHARACTER SET utf8mb4;

START TRANSACTION;


-- ============================================================
-- 1. OBTENER DATOS MAESTROS
-- ============================================================

SET @rol_admin = (
    SELECT id_rol
    FROM rol
    WHERE nombre = 'ADMINISTRADOR'
);

SET @rol_venta = (
    SELECT id_rol
    FROM rol
    WHERE nombre = 'ENCARGADO_VENTA'
);

SET @categoria_alcohol = (
    SELECT id_categoria
    FROM categoria
    WHERE nombre = 'Bebidas alcohólicas'
);

SET @unidad = (
    SELECT id_unidad_medida
    FROM unidad_medida
    WHERE nombre = 'Unidad'
);

SET @refrigerador = (
    SELECT id_ubicacion
    FROM ubicacion
    WHERE nombre = 'Refrigerador'
);

SET @denominacion_200 = (
    SELECT id_denominacion
    FROM denominacion
    WHERE valor = 200.00
);


-- ============================================================
-- 2. USUARIOS
-- ============================================================

INSERT INTO usuario (
    id_rol,
    nombre,
    apellido,
    nombre_usuario,
    contrasena,
    estado
)
VALUES (
    @rol_admin,
    'Gabriel',
    'Administrador',
    'admin_paris',
    'HASH_PRUEBA_ADMIN',
    'ACTIVO'
);

SET @usuario_admin = LAST_INSERT_ID();


INSERT INTO usuario (
    id_rol,
    nombre,
    apellido,
    nombre_usuario,
    contrasena,
    estado
)
VALUES (
    @rol_venta,
    'Carlos',
    'Vendedor',
    'carlos_venta',
    'HASH_PRUEBA_VENDEDOR',
    'ACTIVO'
);

SET @usuario_vendedor = LAST_INSERT_ID();


-- ============================================================
-- 3. PROVEEDOR
-- ============================================================

INSERT INTO proveedor (
    nombre,
    contacto,
    telefono,
    direccion,
    estado
)
VALUES (
    'Distribuidora Central',
    'Juan Pérez',
    '70000001',
    'Santa Cruz - Bolivia',
    'ACTIVO'
);

SET @proveedor = LAST_INSERT_ID();


-- ============================================================
-- 4. PRODUCTO
-- ============================================================

INSERT INTO producto (
    id_categoria,
    id_unidad_medida,
    nombre,
    descripcion,
    stock_minimo,
    estado
)
VALUES (
    @categoria_alcohol,
    @unidad,
    'Cerveza Paceña 330 ml',
    'Cerveza en botella de 330 ml',
    10,
    'ACTIVO'
);

SET @producto = LAST_INSERT_ID();


-- ============================================================
-- 5. PRESENTACIÓN
-- ============================================================

INSERT INTO presentacion_producto (
    id_producto,
    nombre_presentacion,
    factor_conversion,
    codigo_barras,
    precio_venta,
    estado
)
VALUES (
    @producto,
    'Unidad',
    1,
    '777000000001',
    12.00,
    'ACTIVO'
);

SET @presentacion = LAST_INSERT_ID();


-- ============================================================
-- 6. PRIMERA COMPRA
-- LOTE MÁS ANTIGUO
-- ============================================================

INSERT INTO compra (
    id_proveedor,
    id_usuario,
    fecha_hora,
    observacion
)
VALUES (
    @proveedor,
    @usuario_admin,
    '2026-08-01 10:00:00',
    'Primera compra de prueba'
);

SET @compra1 = LAST_INSERT_ID();


INSERT INTO detalle_compra (
    id_compra,
    id_presentacion,
    cantidad,
    costo_unitario
)
VALUES (
    @compra1,
    @presentacion,
    10,
    8.00
);

SET @detalle_compra1 = LAST_INSERT_ID();


INSERT INTO lote_producto (
    id_detalle_compra,
    codigo_lote,
    fecha_vencimiento,
    cantidad_inicial
)
VALUES (
    @detalle_compra1,
    'LOTE-ANTIGUO-001',
    '2027-01-15',
    10
);

SET @lote1 = LAST_INSERT_ID();


INSERT INTO lote_ubicacion (
    id_lote,
    id_ubicacion,
    cantidad_actual
)
VALUES (
    @lote1,
    @refrigerador,
    10
);

SET @lote_ubicacion1 = LAST_INSERT_ID();


-- ============================================================
-- 7. SEGUNDA COMPRA
-- LOTE MÁS NUEVO
-- ============================================================

INSERT INTO compra (
    id_proveedor,
    id_usuario,
    fecha_hora,
    observacion
)
VALUES (
    @proveedor,
    @usuario_admin,
    '2026-08-15 10:00:00',
    'Segunda compra de prueba'
);

SET @compra2 = LAST_INSERT_ID();


INSERT INTO detalle_compra (
    id_compra,
    id_presentacion,
    cantidad,
    costo_unitario
)
VALUES (
    @compra2,
    @presentacion,
    10,
    8.50
);

SET @detalle_compra2 = LAST_INSERT_ID();


INSERT INTO lote_producto (
    id_detalle_compra,
    codigo_lote,
    fecha_vencimiento,
    cantidad_inicial
)
VALUES (
    @detalle_compra2,
    'LOTE-NUEVO-002',
    '2027-03-15',
    10
);

SET @lote2 = LAST_INSERT_ID();


INSERT INTO lote_ubicacion (
    id_lote,
    id_ubicacion,
    cantidad_actual
)
VALUES (
    @lote2,
    @refrigerador,
    10
);

SET @lote_ubicacion2 = LAST_INSERT_ID();


-- ============================================================
-- STOCK ANTES DE LA VENTA
-- 10 + 10 = 20 UNIDADES
-- ============================================================


-- ============================================================
-- 8. APERTURA DE CAJA
-- ============================================================

INSERT INTO sesion_caja (
    id_usuario,
    fecha_hora_apertura,
    monto_inicial,
    estado,
    observacion
)
VALUES (
    @usuario_vendedor,
    '2026-08-27 08:00:00',
    100.00,
    'ABIERTA',
    'Sesión de caja para prueba integral'
);

SET @sesion = LAST_INSERT_ID();


-- ============================================================
-- 9. VENTA
-- SE VENDEN 12 UNIDADES
-- TOTAL = 12 x 12 Bs = 144 Bs
-- ============================================================

INSERT INTO venta (
    id_sesion_caja,
    fecha_hora,
    estado,
    motivo_anulacion
)
VALUES (
    @sesion,
    '2026-08-27 08:30:00',
    'VIGENTE',
    NULL
);

SET @venta = LAST_INSERT_ID();


INSERT INTO detalle_venta (
    id_venta,
    id_presentacion,
    cantidad,
    precio_unitario
)
VALUES (
    @venta,
    @presentacion,
    12,
    12.00
);

SET @detalle_venta = LAST_INSERT_ID();


-- ============================================================
-- 10. APLICACIÓN FIFO
-- ============================================================
-- Se necesitan 12 unidades.
--
-- Lote antiguo = 10 disponibles
-- Se descuentan las 10.
--
-- Lote nuevo = 10 disponibles
-- Se descuentan las 2 restantes.
-- ============================================================

INSERT INTO detalle_venta_lote (
    id_detalle_venta,
    id_lote_ubicacion,
    cantidad_base
)
VALUES
(
    @detalle_venta,
    @lote_ubicacion1,
    10
),
(
    @detalle_venta,
    @lote_ubicacion2,
    2
);


UPDATE lote_ubicacion
SET cantidad_actual = 0
WHERE id_lote_ubicacion = @lote_ubicacion1;


UPDATE lote_ubicacion
SET cantidad_actual = 8
WHERE id_lote_ubicacion = @lote_ubicacion2;


-- ============================================================
-- 11. PAGO MIXTO
-- TOTAL VENTA = 144 Bs
-- EFECTIVO = 100 Bs
-- QR = 44 Bs
-- ============================================================

INSERT INTO pago (
    id_venta,
    metodo_pago,
    monto,
    comprobante_qr
)
VALUES
(
    @venta,
    'EFECTIVO',
    100.00,
    NULL
),
(
    @venta,
    'QR',
    44.00,
    'comprobantes/prueba_venta_001.png'
);


-- ============================================================
-- 12. AJUSTE DE INVENTARIO
-- UNA UNIDAD DAÑADA DEL SEGUNDO LOTE
-- ============================================================

INSERT INTO ajuste_inventario (
    id_lote_ubicacion,
    id_usuario,
    fecha_hora,
    tipo_ajuste,
    cantidad,
    observacion
)
VALUES (
    @lote_ubicacion2,
    @usuario_admin,
    '2026-08-27 08:45:00',
    'DAÑADO',
    1,
    'Unidad dañada encontrada durante revisión'
);


UPDATE lote_ubicacion
SET cantidad_actual = cantidad_actual - 1
WHERE id_lote_ubicacion = @lote_ubicacion2;


-- ============================================================
-- STOCK FINAL
--
-- Inicial: 20
-- Venta:   -12
-- Daño:     -1
-- Final:     7
-- ============================================================


-- ============================================================
-- 13. ARQUEO DE CAJA
-- ============================================================
-- Monto inicial = 100 Bs
-- Venta efectivo = 100 Bs
-- Efectivo esperado = 200 Bs
--
-- Se cuenta un billete de 200 Bs.
-- Diferencia = 0 Bs.
-- ============================================================

INSERT INTO arqueo_caja (
    id_sesion_caja,
    fecha_hora,
    observacion
)
VALUES (
    @sesion,
    '2026-08-27 09:00:00',
    'Arqueo de prueba sin diferencia'
);

SET @arqueo = LAST_INSERT_ID();


INSERT INTO detalle_arqueo (
    id_arqueo,
    id_denominacion,
    cantidad
)
VALUES (
    @arqueo,
    @denominacion_200,
    1
);


-- ============================================================
-- 14. CIERRE DE CAJA
-- ============================================================

UPDATE sesion_caja
SET
    fecha_hora_cierre = '2026-08-27 09:00:00',
    estado = 'CERRADA',
    observacion = 'Sesión cerrada correctamente'
WHERE id_sesion_caja = @sesion;


COMMIT;


-- ============================================================
-- 15. VERIFICACIONES
-- ============================================================


-- STOCK FINAL
SELECT
    'STOCK FINAL' AS prueba,
    producto,
    stock_minimo,
    stock_actual,
    estado_stock
FROM vw_stock_producto;


-- LOTES Y UBICACIONES
SELECT
    'LOTES' AS prueba,
    producto,
    codigo_lote,
    fecha_vencimiento,
    ubicacion,
    cantidad_actual
FROM vw_stock_lote_ubicacion
ORDER BY fecha_vencimiento;


-- COMPRAS
SELECT
    'COMPRAS' AS prueba,
    id_compra,
    proveedor,
    total_compra
FROM vw_compras_totales
ORDER BY id_compra;


-- VENTA
SELECT
    'VENTA' AS prueba,
    id_venta,
    estado,
    total_venta
FROM vw_ventas_totales;


-- PAGOS
SELECT
    'PAGOS' AS prueba,
    id_venta,
    metodo_pago,
    monto
FROM vw_pagos_venta
ORDER BY id_pago;


-- FIFO
SELECT
    'FIFO' AS prueba,
    lp.codigo_lote,
    lp.fecha_vencimiento,
    dvl.cantidad_base
FROM detalle_venta_lote dvl
INNER JOIN lote_ubicacion lu
    ON lu.id_lote_ubicacion = dvl.id_lote_ubicacion
INNER JOIN lote_producto lp
    ON lp.id_lote = lu.id_lote
WHERE dvl.id_detalle_venta = @detalle_venta
ORDER BY lp.fecha_vencimiento;


-- EFECTIVO ESPERADO
SELECT
    'EFECTIVO ESPERADO' AS prueba,
    id_sesion_caja,
    monto_inicial,
    efectivo_esperado
FROM vw_efectivo_esperado_sesion;


-- EFECTIVO CONTADO
SELECT
    'EFECTIVO CONTADO' AS prueba,
    id_sesion_caja,
    efectivo_contado
FROM vw_efectivo_contado_arqueo;


-- DIFERENCIA DE CAJA
SELECT
    'ARQUEO' AS prueba,
    id_sesion_caja,
    efectivo_esperado,
    efectivo_contado,
    diferencia,
    resultado
FROM vw_diferencias_caja;


-- AJUSTES
SELECT
    'AJUSTE INVENTARIO' AS prueba,
    tipo_ajuste,
    cantidad,
    observacion
FROM ajuste_inventario;