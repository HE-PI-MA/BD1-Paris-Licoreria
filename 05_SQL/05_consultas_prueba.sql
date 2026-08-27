-- ============================================================
-- PARÍS LICORERÍA
-- CONSULTAS DE PRUEBA Y REPORTES
-- ============================================================

USE paris_licoreria;


-- ============================================================
-- 1. VER TODOS LOS PRODUCTOS
-- ============================================================

SELECT *
FROM producto
ORDER BY nombre;


-- ============================================================
-- 2. VER PRESENTACIONES Y PRECIOS
-- ============================================================

SELECT
    p.nombre AS producto,
    pp.nombre_presentacion,
    pp.codigo_barras,
    pp.factor_conversion,
    pp.precio_venta
FROM presentacion_producto pp
INNER JOIN producto p
    ON p.id_producto = pp.id_producto
ORDER BY p.nombre, pp.nombre_presentacion;


-- ============================================================
-- 3. STOCK ACTUAL
-- ============================================================

SELECT *
FROM vw_stock_producto
ORDER BY producto;


-- ============================================================
-- 4. PRODUCTOS CON STOCK BAJO
-- ============================================================

SELECT *
FROM vw_productos_stock_bajo
ORDER BY stock_actual ASC;


-- ============================================================
-- 5. STOCK DETALLADO POR LOTE Y UBICACIÓN
-- ============================================================

SELECT *
FROM vw_stock_lote_ubicacion
ORDER BY producto, fecha_vencimiento, ubicacion;


-- ============================================================
-- 6. LOTES VENCIDOS
-- ============================================================

SELECT *
FROM vw_lotes_proximos_vencer
WHERE fecha_vencimiento < CURDATE()
ORDER BY fecha_vencimiento;


-- ============================================================
-- 7. LOTES QUE VENCEN EN LOS PRÓXIMOS 30 DÍAS
-- ============================================================

SELECT *
FROM vw_lotes_proximos_vencer
WHERE fecha_vencimiento BETWEEN CURDATE()
                            AND DATE_ADD(CURDATE(), INTERVAL 30 DAY)
ORDER BY fecha_vencimiento;


-- ============================================================
-- 8. HISTORIAL DE COMPRAS
-- ============================================================

SELECT *
FROM vw_compras_totales
ORDER BY fecha_hora DESC;


-- ============================================================
-- 9. TOTAL COMPRADO A CADA PROVEEDOR
-- ============================================================

SELECT
    proveedor,
    COUNT(*) AS cantidad_compras,
    SUM(total_compra) AS total_comprado
FROM vw_compras_totales
GROUP BY proveedor
ORDER BY total_comprado DESC;


-- ============================================================
-- 10. HISTORIAL DE VENTAS
-- ============================================================

SELECT *
FROM vw_ventas_totales
ORDER BY fecha_hora DESC;


-- ============================================================
-- 11. VENTAS VÁLIDAS DEL DÍA
-- ============================================================

SELECT
    COUNT(*) AS cantidad_ventas,
    COALESCE(SUM(total_venta), 0) AS total_vendido
FROM vw_ventas_totales
WHERE estado = 'VIGENTE'
  AND DATE(fecha_hora) = CURDATE();


-- ============================================================
-- 12. VENTAS DE LA SEMANA
-- ============================================================

SELECT
    COUNT(*) AS cantidad_ventas,
    COALESCE(SUM(total_venta), 0) AS total_vendido
FROM vw_ventas_totales
WHERE estado = 'VIGENTE'
  AND YEARWEEK(fecha_hora, 1) = YEARWEEK(CURDATE(), 1);


-- ============================================================
-- 13. VENTAS DEL MES
-- ============================================================

SELECT
    COUNT(*) AS cantidad_ventas,
    COALESCE(SUM(total_venta), 0) AS total_vendido
FROM vw_ventas_totales
WHERE estado = 'VIGENTE'
  AND YEAR(fecha_hora) = YEAR(CURDATE())
  AND MONTH(fecha_hora) = MONTH(CURDATE());


-- ============================================================
-- 14. PRODUCTOS MÁS VENDIDOS
-- ============================================================

SELECT *
FROM vw_productos_mas_vendidos
ORDER BY cantidad_vendida DESC;


-- ============================================================
-- 15. LOS 10 PRODUCTOS/PRESENTACIONES MÁS VENDIDOS
-- ============================================================

SELECT
    producto,
    nombre_presentacion,
    cantidad_vendida,
    ingreso_generado
FROM vw_productos_mas_vendidos
ORDER BY cantidad_vendida DESC
LIMIT 10;


-- ============================================================
-- 16. INGRESOS POR MÉTODO DE PAGO
-- ============================================================

SELECT
    pg.metodo_pago,
    SUM(pg.monto) AS total
FROM pago pg

INNER JOIN venta v
    ON v.id_venta = pg.id_venta

WHERE v.estado = 'VIGENTE'

GROUP BY pg.metodo_pago
ORDER BY total DESC;


-- ============================================================
-- 17. VENTAS CON PAGO MIXTO
-- ============================================================

SELECT
    id_venta,
    COUNT(*) AS cantidad_formas_pago,
    SUM(monto) AS total_pagado
FROM pago
GROUP BY id_venta
HAVING COUNT(*) > 1;


-- ============================================================
-- 18. VENTAS ANULADAS
-- ============================================================

SELECT
    id_venta,
    fecha_hora,
    motivo_anulacion
FROM venta
WHERE estado = 'ANULADA'
ORDER BY fecha_hora DESC;


-- ============================================================
-- 19. SESIONES DE CAJA
-- ============================================================

SELECT
    sc.id_sesion_caja,
    CONCAT(u.nombre, ' ', u.apellido) AS usuario,
    sc.fecha_hora_apertura,
    sc.fecha_hora_cierre,
    sc.monto_inicial,
    sc.estado
FROM sesion_caja sc

INNER JOIN usuario u
    ON u.id_usuario = sc.id_usuario

ORDER BY sc.fecha_hora_apertura DESC;


-- ============================================================
-- 20. DIFERENCIAS DE CAJA
-- ============================================================

SELECT *
FROM vw_diferencias_caja
ORDER BY fecha_hora_apertura DESC;


-- ============================================================
-- 21. SESIONES CON FALTANTE
-- ============================================================

SELECT *
FROM vw_diferencias_caja
WHERE resultado = 'FALTANTE'
ORDER BY diferencia ASC;


-- ============================================================
-- 22. SESIONES CON SOBRANTE
-- ============================================================

SELECT *
FROM vw_diferencias_caja
WHERE resultado = 'SOBRANTE'
ORDER BY diferencia DESC;


-- ============================================================
-- 23. AJUSTES DE INVENTARIO
-- ============================================================

SELECT
    ai.id_ajuste,
    ai.fecha_hora,
    p.nombre AS producto,
    u.nombre AS ubicacion,
    ai.tipo_ajuste,
    ai.cantidad,
    CONCAT(us.nombre, ' ', us.apellido) AS usuario,
    ai.observacion

FROM ajuste_inventario ai

INNER JOIN lote_ubicacion lu
    ON lu.id_lote_ubicacion = ai.id_lote_ubicacion

INNER JOIN lote_producto lp
    ON lp.id_lote = lu.id_lote

INNER JOIN detalle_compra dc
    ON dc.id_detalle_compra = lp.id_detalle_compra

INNER JOIN presentacion_producto pp
    ON pp.id_presentacion = dc.id_presentacion

INNER JOIN producto p
    ON p.id_producto = pp.id_producto

INNER JOIN ubicacion u
    ON u.id_ubicacion = lu.id_ubicacion

INNER JOIN usuario us
    ON us.id_usuario = ai.id_usuario

ORDER BY ai.fecha_hora DESC;


-- ============================================================
-- 24. PÉRDIDAS, DAÑOS Y VENCIDOS
-- ============================================================

SELECT
    tipo_ajuste,
    COUNT(*) AS cantidad_registros,
    SUM(cantidad) AS cantidad_total
FROM ajuste_inventario
GROUP BY tipo_ajuste
ORDER BY cantidad_total DESC;


-- ============================================================
-- 25. TRAZABILIDAD FIFO DE UNA VENTA
-- ============================================================

SELECT
    v.id_venta,
    v.fecha_hora,
    p.nombre AS producto,
    pp.nombre_presentacion,
    dv.cantidad AS cantidad_vendida,
    lp.id_lote,
    lp.codigo_lote,
    lp.fecha_vencimiento,
    u.nombre AS ubicacion,
    dvl.cantidad_base AS cantidad_descontada_base

FROM detalle_venta_lote dvl

INNER JOIN detalle_venta dv
    ON dv.id_detalle_venta = dvl.id_detalle_venta

INNER JOIN venta v
    ON v.id_venta = dv.id_venta

INNER JOIN presentacion_producto pp
    ON pp.id_presentacion = dv.id_presentacion

INNER JOIN producto p
    ON p.id_producto = pp.id_producto

INNER JOIN lote_ubicacion lu
    ON lu.id_lote_ubicacion = dvl.id_lote_ubicacion

INNER JOIN lote_producto lp
    ON lp.id_lote = lu.id_lote

INNER JOIN ubicacion u
    ON u.id_ubicacion = lu.id_ubicacion

ORDER BY
    v.id_venta,
    lp.fecha_vencimiento,
    lp.id_lote;


-- ============================================================
-- 26. VALIDAR PAGOS CONTRA EL TOTAL DE LA VENTA
-- ============================================================

SELECT
    vt.id_venta,
    vt.total_venta,
    COALESCE(SUM(pg.monto), 0) AS total_pagado,

    COALESCE(SUM(pg.monto), 0) - vt.total_venta AS diferencia_pago

FROM vw_ventas_totales vt

LEFT JOIN pago pg
    ON pg.id_venta = vt.id_venta

GROUP BY
    vt.id_venta,
    vt.total_venta

HAVING ABS(COALESCE(SUM(pg.monto), 0) - vt.total_venta) > 0.001;


-- ============================================================
-- 27. PRODUCTOS SIN STOCK
-- ============================================================

SELECT *
FROM vw_stock_producto
WHERE stock_actual = 0
ORDER BY producto;