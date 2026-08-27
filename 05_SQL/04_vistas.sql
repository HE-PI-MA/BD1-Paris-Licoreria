-- ============================================================
-- PARÍS LICORERÍA
-- VISTAS DEL SISTEMA
-- ============================================================

USE paris_licoreria;


-- ============================================================
-- 1. STOCK ACTUAL POR PRODUCTO
-- ============================================================
-- El stock se expresa en la unidad base definida para el producto.
-- No se almacena PRODUCTO.stock_actual para evitar redundancia.

CREATE OR REPLACE VIEW vw_stock_producto AS
SELECT
    p.id_producto,
    p.nombre AS producto,
    c.nombre AS categoria,
    um.nombre AS unidad_medida,
    um.abreviatura,
    p.stock_minimo,
    COALESCE(SUM(lu.cantidad_actual), 0) AS stock_actual,

    CASE
        WHEN COALESCE(SUM(lu.cantidad_actual), 0) = 0
            THEN 'AGOTADO'

        WHEN COALESCE(SUM(lu.cantidad_actual), 0) <= p.stock_minimo
            THEN 'STOCK BAJO'

        ELSE 'DISPONIBLE'
    END AS estado_stock

FROM producto p

INNER JOIN categoria c
    ON c.id_categoria = p.id_categoria

INNER JOIN unidad_medida um
    ON um.id_unidad_medida = p.id_unidad_medida

LEFT JOIN presentacion_producto pp
    ON pp.id_producto = p.id_producto

LEFT JOIN detalle_compra dc
    ON dc.id_presentacion = pp.id_presentacion

LEFT JOIN lote_producto lp
    ON lp.id_detalle_compra = dc.id_detalle_compra

LEFT JOIN lote_ubicacion lu
    ON lu.id_lote = lp.id_lote

GROUP BY
    p.id_producto,
    p.nombre,
    c.nombre,
    um.nombre,
    um.abreviatura,
    p.stock_minimo;


-- ============================================================
-- 2. PRODUCTOS CON STOCK BAJO O AGOTADO
-- ============================================================

CREATE OR REPLACE VIEW vw_productos_stock_bajo AS
SELECT
    id_producto,
    producto,
    categoria,
    unidad_medida,
    abreviatura,
    stock_minimo,
    stock_actual,
    estado_stock
FROM vw_stock_producto
WHERE stock_actual <= stock_minimo;


-- ============================================================
-- 3. STOCK POR LOTE Y UBICACIÓN
-- ============================================================

CREATE OR REPLACE VIEW vw_stock_lote_ubicacion AS
SELECT
    lu.id_lote_ubicacion,
    p.id_producto,
    p.nombre AS producto,
    pp.id_presentacion,
    pp.nombre_presentacion,
    lp.id_lote,
    lp.codigo_lote,
    lp.fecha_vencimiento,
    u.id_ubicacion,
    u.nombre AS ubicacion,
    lu.cantidad_actual,
    dc.costo_unitario

FROM lote_ubicacion lu

INNER JOIN lote_producto lp
    ON lp.id_lote = lu.id_lote

INNER JOIN detalle_compra dc
    ON dc.id_detalle_compra = lp.id_detalle_compra

INNER JOIN presentacion_producto pp
    ON pp.id_presentacion = dc.id_presentacion

INNER JOIN producto p
    ON p.id_producto = pp.id_producto

INNER JOIN ubicacion u
    ON u.id_ubicacion = lu.id_ubicacion;


-- ============================================================
-- 4. LOTES PRÓXIMOS A VENCER
-- ============================================================

CREATE OR REPLACE VIEW vw_lotes_proximos_vencer AS
SELECT
    p.id_producto,
    p.nombre AS producto,
    lp.id_lote,
    lp.codigo_lote,
    lp.fecha_vencimiento,
    u.nombre AS ubicacion,
    lu.cantidad_actual,

    DATEDIFF(lp.fecha_vencimiento, CURDATE()) AS dias_restantes

FROM lote_producto lp

INNER JOIN detalle_compra dc
    ON dc.id_detalle_compra = lp.id_detalle_compra

INNER JOIN presentacion_producto pp
    ON pp.id_presentacion = dc.id_presentacion

INNER JOIN producto p
    ON p.id_producto = pp.id_producto

INNER JOIN lote_ubicacion lu
    ON lu.id_lote = lp.id_lote

INNER JOIN ubicacion u
    ON u.id_ubicacion = lu.id_ubicacion

WHERE lp.fecha_vencimiento IS NOT NULL
  AND lu.cantidad_actual > 0;


-- ============================================================
-- 5. TOTAL DE CADA COMPRA
-- ============================================================

CREATE OR REPLACE VIEW vw_compras_totales AS
SELECT
    c.id_compra,
    c.fecha_hora,
    pr.id_proveedor,
    pr.nombre AS proveedor,
    u.id_usuario,
    CONCAT(u.nombre, ' ', u.apellido) AS usuario,
    SUM(dc.cantidad * dc.costo_unitario) AS total_compra

FROM compra c

INNER JOIN proveedor pr
    ON pr.id_proveedor = c.id_proveedor

INNER JOIN usuario u
    ON u.id_usuario = c.id_usuario

INNER JOIN detalle_compra dc
    ON dc.id_compra = c.id_compra

GROUP BY
    c.id_compra,
    c.fecha_hora,
    pr.id_proveedor,
    pr.nombre,
    u.id_usuario,
    u.nombre,
    u.apellido;


-- ============================================================
-- 6. TOTAL DE CADA VENTA
-- ============================================================

CREATE OR REPLACE VIEW vw_ventas_totales AS
SELECT
    v.id_venta,
    v.fecha_hora,
    v.estado,
    v.motivo_anulacion,
    sc.id_sesion_caja,
    u.id_usuario,
    CONCAT(u.nombre, ' ', u.apellido) AS usuario,
    SUM(dv.cantidad * dv.precio_unitario) AS total_venta

FROM venta v

INNER JOIN sesion_caja sc
    ON sc.id_sesion_caja = v.id_sesion_caja

INNER JOIN usuario u
    ON u.id_usuario = sc.id_usuario

INNER JOIN detalle_venta dv
    ON dv.id_venta = v.id_venta

GROUP BY
    v.id_venta,
    v.fecha_hora,
    v.estado,
    v.motivo_anulacion,
    sc.id_sesion_caja,
    u.id_usuario,
    u.nombre,
    u.apellido;


-- ============================================================
-- 7. PAGOS POR VENTA
-- ============================================================

CREATE OR REPLACE VIEW vw_pagos_venta AS
SELECT
    v.id_venta,
    v.fecha_hora,
    v.estado,
    p.id_pago,
    p.metodo_pago,
    p.monto,
    p.comprobante_qr

FROM venta v

INNER JOIN pago p
    ON p.id_venta = v.id_venta;


-- ============================================================
-- 8. PRODUCTOS MÁS VENDIDOS
-- ============================================================

CREATE OR REPLACE VIEW vw_productos_mas_vendidos AS
SELECT
    p.id_producto,
    p.nombre AS producto,
    pp.id_presentacion,
    pp.nombre_presentacion,
    SUM(dv.cantidad) AS cantidad_vendida,
    SUM(dv.cantidad * dv.precio_unitario) AS ingreso_generado

FROM detalle_venta dv

INNER JOIN venta v
    ON v.id_venta = dv.id_venta

INNER JOIN presentacion_producto pp
    ON pp.id_presentacion = dv.id_presentacion

INNER JOIN producto p
    ON p.id_producto = pp.id_producto

WHERE v.estado = 'VIGENTE'

GROUP BY
    p.id_producto,
    p.nombre,
    pp.id_presentacion,
    pp.nombre_presentacion;


-- ============================================================
-- 9. EFECTIVO ESPERADO POR SESIÓN DE CAJA
-- ============================================================
-- Monto inicial + pagos en efectivo correspondientes
-- únicamente a ventas vigentes.

CREATE OR REPLACE VIEW vw_efectivo_esperado_sesion AS
SELECT
    sc.id_sesion_caja,
    sc.id_usuario,
    sc.fecha_hora_apertura,
    sc.fecha_hora_cierre,
    sc.monto_inicial,
    sc.estado,

    sc.monto_inicial +
    COALESCE(
        SUM(
            CASE
                WHEN v.estado = 'VIGENTE'
                     AND pg.metodo_pago = 'EFECTIVO'
                THEN pg.monto
                ELSE 0
            END
        ),
        0
    ) AS efectivo_esperado

FROM sesion_caja sc

LEFT JOIN venta v
    ON v.id_sesion_caja = sc.id_sesion_caja

LEFT JOIN pago pg
    ON pg.id_venta = v.id_venta

GROUP BY
    sc.id_sesion_caja,
    sc.id_usuario,
    sc.fecha_hora_apertura,
    sc.fecha_hora_cierre,
    sc.monto_inicial,
    sc.estado;


-- ============================================================
-- 10. EFECTIVO CONTADO EN ARQUEO
-- ============================================================

CREATE OR REPLACE VIEW vw_efectivo_contado_arqueo AS
SELECT
    ac.id_arqueo,
    ac.id_sesion_caja,
    ac.fecha_hora,

    COALESCE(
        SUM(d.valor * da.cantidad),
        0
    ) AS efectivo_contado

FROM arqueo_caja ac

LEFT JOIN detalle_arqueo da
    ON da.id_arqueo = ac.id_arqueo

LEFT JOIN denominacion d
    ON d.id_denominacion = da.id_denominacion

GROUP BY
    ac.id_arqueo,
    ac.id_sesion_caja,
    ac.fecha_hora;


-- ============================================================
-- 11. DIFERENCIAS DE CAJA
-- ============================================================

CREATE OR REPLACE VIEW vw_diferencias_caja AS
SELECT
    sc.id_sesion_caja,
    CONCAT(u.nombre, ' ', u.apellido) AS usuario,
    sc.fecha_hora_apertura,
    sc.fecha_hora_cierre,
    ee.efectivo_esperado,
    ec.efectivo_contado,

    ec.efectivo_contado - ee.efectivo_esperado AS diferencia,

    CASE
        WHEN ec.efectivo_contado - ee.efectivo_esperado = 0
            THEN 'CUADRA'

        WHEN ec.efectivo_contado - ee.efectivo_esperado > 0
            THEN 'SOBRANTE'

        ELSE 'FALTANTE'
    END AS resultado

FROM sesion_caja sc

INNER JOIN usuario u
    ON u.id_usuario = sc.id_usuario

INNER JOIN vw_efectivo_esperado_sesion ee
    ON ee.id_sesion_caja = sc.id_sesion_caja

INNER JOIN vw_efectivo_contado_arqueo ec
    ON ec.id_sesion_caja = sc.id_sesion_caja;