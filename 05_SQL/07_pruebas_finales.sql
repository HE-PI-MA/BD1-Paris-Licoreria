-- ============================================================
-- PARÍS LICORERÍA
-- PRUEBAS FINALES DE VALIDACIÓN
-- ============================================================

USE paris_licoreria;

SET NAMES utf8mb4;


-- ============================================================
-- 1. CANTIDAD DE TABLAS
-- ============================================================

SELECT
    COUNT(*) AS cantidad_tablas,
    CASE
        WHEN COUNT(*) = 21 THEN 'OK'
        ELSE 'ERROR'
    END AS resultado
FROM information_schema.tables
WHERE table_schema = 'paris_licoreria'
AND table_type = 'BASE TABLE';


-- ============================================================
-- 2. CANTIDAD DE VISTAS
-- ============================================================

SELECT
    COUNT(*) AS cantidad_vistas,
    CASE
        WHEN COUNT(*) = 11 THEN 'OK'
        ELSE 'ERROR'
    END AS resultado
FROM information_schema.views
WHERE table_schema = 'paris_licoreria';


-- ============================================================
-- 3. CODIFICACIÓN UTF-8
-- ============================================================

SELECT
    nombre,
    HEX(nombre) AS hexadecimal
FROM categoria
WHERE nombre = 'Bebidas alcohólicas';

SELECT
    nombre,
    HEX(nombre) AS hexadecimal
FROM ubicacion
WHERE nombre = 'Almacén';


-- ============================================================
-- 4. STOCK FINAL
-- ============================================================

SELECT
    producto,
    stock_minimo,
    stock_actual,
    estado_stock,
    CASE
        WHEN stock_actual = 7 THEN 'OK'
        ELSE 'REVISAR'
    END AS prueba_stock
FROM vw_stock_producto
WHERE producto = 'Cerveza Paceña 330 ml';


-- ============================================================
-- 5. FIFO
-- ============================================================

SELECT
    lp.codigo_lote,
    lp.fecha_vencimiento,
    dvl.cantidad_base
FROM detalle_venta_lote dvl
INNER JOIN lote_ubicacion lu
    ON lu.id_lote_ubicacion = dvl.id_lote_ubicacion
INNER JOIN lote_producto lp
    ON lp.id_lote = lu.id_lote
ORDER BY lp.fecha_vencimiento;


-- ============================================================
-- 6. TOTAL DE VENTA
-- ============================================================

SELECT
    id_venta,
    total_venta,
    CASE
        WHEN total_venta = 144 THEN 'OK'
        ELSE 'REVISAR'
    END AS resultado
FROM vw_ventas_totales;


-- ============================================================
-- 7. VALIDACIÓN DE PAGOS
-- ============================================================

SELECT
    vt.id_venta,
    vt.total_venta,
    COALESCE(SUM(pg.monto), 0) AS total_pagado,
    COALESCE(SUM(pg.monto), 0) - vt.total_venta AS diferencia,
    CASE
        WHEN ABS(COALESCE(SUM(pg.monto), 0) - vt.total_venta) < 0.001
            THEN 'OK'
        ELSE 'ERROR'
    END AS resultado
FROM vw_ventas_totales vt
LEFT JOIN pago pg
    ON pg.id_venta = vt.id_venta
GROUP BY vt.id_venta, vt.total_venta;


-- ============================================================
-- 8. PAGO MIXTO
-- ============================================================

SELECT
    id_venta,
    metodo_pago,
    monto
FROM pago
ORDER BY id_pago;


-- ============================================================
-- 9. STOCK NEGATIVO
-- DEBE DEVOLVER 0
-- ============================================================

SELECT
    COUNT(*) AS existencias_negativas,
    CASE
        WHEN COUNT(*) = 0 THEN 'OK'
        ELSE 'ERROR'
    END AS resultado
FROM lote_ubicacion
WHERE cantidad_actual < 0;


-- ============================================================
-- 10. DIFERENCIA DE CAJA
-- ============================================================

SELECT
    id_sesion_caja,
    efectivo_esperado,
    efectivo_contado,
    diferencia,
    resultado
FROM vw_diferencias_caja;


-- ============================================================
-- 11. AJUSTES
-- ============================================================

SELECT
    tipo_ajuste,
    cantidad,
    observacion
FROM ajuste_inventario;


-- ============================================================
-- 12. RESUMEN
-- ============================================================

SELECT 'BASE DE DATOS PARÍS LICORERÍA VALIDADA' AS resultado_final;