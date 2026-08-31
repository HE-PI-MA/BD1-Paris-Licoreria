-- ============================================================
-- PARÍS LICORERÍA V2
-- ESCENARIO INTEGRAL REPRODUCIBLE
-- ============================================================

USE paris_licoreria;
SET NAMES utf8mb4;

SET @fecha_compra_antigua = DATE_SUB(DATE_ADD(CURRENT_DATE, INTERVAL 10 HOUR), INTERVAL 26 DAY);
SET @fecha_compra_nueva = DATE_SUB(DATE_ADD(CURRENT_DATE, INTERVAL 10 HOUR), INTERVAL 12 DAY);
SET @fecha_compra_caja = DATE_SUB(DATE_ADD(CURRENT_DATE, INTERVAL 10 HOUR), INTERVAL 5 DAY);
SET @fecha_compra_peso = DATE_SUB(DATE_ADD(CURRENT_DATE, INTERVAL 10 HOUR), INTERVAL 4 DAY);
SET @fecha_compra_libra = DATE_SUB(DATE_ADD(CURRENT_DATE, INTERVAL 10 HOUR), INTERVAL 3 DAY);
SET @fecha_compra_vencida = DATE_SUB(DATE_ADD(CURRENT_DATE, INTERVAL 10 HOUR), INTERVAL 40 DAY);
SET @fecha_apertura = DATE_ADD(CURRENT_DATE, INTERVAL 8 HOUR);
SET @fecha_cierre = DATE_ADD(CURRENT_DATE, INTERVAL 12 HOUR);

SELECT id_rol INTO @rol_admin FROM rol WHERE nombre = 'ADMINISTRADOR';
SELECT id_rol INTO @rol_venta FROM rol WHERE nombre = 'ENCARGADO_VENTA';
SELECT id_categoria INTO @categoria_alcohol FROM categoria WHERE nombre = 'Bebidas alcohólicas';
SELECT id_categoria INTO @categoria_otros FROM categoria WHERE nombre = 'Otros';
SELECT id_unidad_medida INTO @unidad FROM unidad_medida WHERE nombre = 'Unidad';
SELECT id_unidad_medida INTO @gramo FROM unidad_medida WHERE nombre = 'Gramo';
SELECT id_ubicacion INTO @refrigerador FROM ubicacion WHERE nombre = 'Refrigerador';
SELECT id_ubicacion INTO @almacen FROM ubicacion WHERE nombre = 'Almacén';
SELECT id_ubicacion INTO @estante FROM ubicacion WHERE nombre = 'Estante';

INSERT INTO usuario (
    id_rol, nombre, apellido, nombre_usuario, contrasena, estado
) VALUES
(@rol_admin, 'Gabriel', 'Administrador', 'admin_paris',
 '$2y$12$HASH_DE_DEMOSTRACION_NO_UTILIZABLE_ADMIN', 'ACTIVO'),
(@rol_venta, 'Carlos', 'Vendedor', 'carlos_venta',
 '$2y$12$HASH_DE_DEMOSTRACION_NO_UTILIZABLE_VENTA', 'ACTIVO');

SELECT id_usuario INTO @usuario_admin FROM usuario WHERE nombre_usuario = 'admin_paris';
SELECT id_usuario INTO @usuario_vendedor FROM usuario WHERE nombre_usuario = 'carlos_venta';

INSERT INTO proveedor (nombre, contacto, telefono, direccion, estado)
VALUES ('Distribuidora Central', 'Juan Pérez', '70000001',
        'Santa Cruz - Bolivia', 'ACTIVO');
SET @proveedor = LAST_INSERT_ID();

-- ------------------------------------------------------------
-- Productos y presentaciones
-- ------------------------------------------------------------

INSERT INTO producto (
    id_categoria, id_unidad_medida, nombre, descripcion, stock_minimo, estado
) VALUES (
    @categoria_alcohol, @unidad, 'Cerveza Paceña 330 ml',
    'Controlada en unidades base', 10, 'ACTIVO'
);
SET @producto_cerveza = LAST_INSERT_ID();

INSERT INTO presentacion_producto (
    id_producto, nombre_presentacion, factor_conversion,
    codigo_barras, precio_venta, estado
) VALUES
(@producto_cerveza, 'Unidad', 1.000, '7771234567890', 12.00, 'ACTIVO'),
(@producto_cerveza, 'Caja de 24', 24.000, '012345678905', 250.00, 'ACTIVO');

SELECT id_presentacion INTO @presentacion_cerveza_unidad
  FROM presentacion_producto
 WHERE id_producto = @producto_cerveza AND nombre_presentacion = 'Unidad';
SELECT id_presentacion INTO @presentacion_cerveza_caja
  FROM presentacion_producto
 WHERE id_producto = @producto_cerveza AND nombre_presentacion = 'Caja de 24';

INSERT INTO producto (
    id_categoria, id_unidad_medida, nombre, descripcion, stock_minimo, estado
) VALUES (
    @categoria_otros, @gramo, 'Maní a granel',
    'Producto por peso controlado en gramos', 500, 'ACTIVO'
);
SET @producto_mani = LAST_INSERT_ID();

INSERT INTO presentacion_producto (
    id_producto, nombre_presentacion, factor_conversion,
    codigo_barras, precio_venta, estado
) VALUES
(@producto_mani, 'Gramo', 1.000, NULL, 0.03, 'ACTIVO'),
(@producto_mani, 'Kilogramo', 1000.000, 'INT-MANI-KG', 20.00, 'ACTIVO'),
(@producto_mani, 'Libra', 453.592, 'INT-MANI-LB', 10.00, 'ACTIVO');

SELECT id_presentacion INTO @presentacion_mani_gramo
  FROM presentacion_producto
 WHERE id_producto = @producto_mani AND nombre_presentacion = 'Gramo';
SELECT id_presentacion INTO @presentacion_mani_kg
  FROM presentacion_producto
 WHERE id_producto = @producto_mani AND nombre_presentacion = 'Kilogramo';
SELECT id_presentacion INTO @presentacion_mani_libra
  FROM presentacion_producto
 WHERE id_producto = @producto_mani AND nombre_presentacion = 'Libra';

INSERT INTO producto (
    id_categoria, id_unidad_medida, nombre, descripcion, stock_minimo, estado
) VALUES (
    @categoria_otros, @unidad, 'Producto de control cruzado',
    'Utilizado para probar integridad producto-lote', 1, 'ACTIVO'
);
SET @producto_control = LAST_INSERT_ID();

INSERT INTO presentacion_producto (
    id_producto, nombre_presentacion, factor_conversion,
    codigo_barras, precio_venta, estado
) VALUES (
    @producto_control, 'Unidad', 1.000, '12345670', 5.00, 'ACTIVO'
);
SET @presentacion_control = LAST_INSERT_ID();

-- ------------------------------------------------------------
-- Compras seguras: cada lote queda expresado en unidad base
-- ------------------------------------------------------------

CALL sp_registrar_compra(
    @proveedor, @usuario_admin, @fecha_compra_antigua, 'Lote FIFO antiguo',
    JSON_ARRAY(JSON_OBJECT(
        'id_presentacion', @presentacion_cerveza_unidad,
        'cantidad', 10.000,
        'costo_unitario', 8.00,
        'codigo_lote', 'LOTE-ANTIGUO-001',
        'fecha_vencimiento', DATE_ADD(CURRENT_DATE, INTERVAL 120 DAY),
        'id_ubicacion', @refrigerador
    )),
    @compra_cerveza_antigua
);

CALL sp_registrar_compra(
    @proveedor, @usuario_admin, @fecha_compra_nueva, 'Lote FIFO nuevo',
    JSON_ARRAY(JSON_OBJECT(
        'id_presentacion', @presentacion_cerveza_unidad,
        'cantidad', 10.000,
        'costo_unitario', 8.50,
        'codigo_lote', 'LOTE-NUEVO-002',
        'fecha_vencimiento', DATE_ADD(CURRENT_DATE, INTERVAL 180 DAY),
        'id_ubicacion', @refrigerador
    )),
    @compra_cerveza_nueva
);

-- 1 caja x factor 24 = 24 unidades base.
CALL sp_registrar_compra(
    @proveedor, @usuario_admin, @fecha_compra_caja, 'Conversión caja de 24',
    JSON_ARRAY(JSON_OBJECT(
        'id_presentacion', @presentacion_cerveza_caja,
        'cantidad', 1.000,
        'costo_unitario', 180.00,
        'codigo_lote', 'LOTE-CAJA-024',
        'fecha_vencimiento', DATE_ADD(CURRENT_DATE, INTERVAL 200 DAY),
        'id_ubicacion', @almacen
    )),
    @compra_cerveza_caja
);

-- El lote vencido permanece como stock físico, pero no es vendible.
CALL sp_registrar_compra(
    @proveedor, @usuario_admin, @fecha_compra_vencida, 'Lote físico vencido',
    JSON_ARRAY(JSON_OBJECT(
        'id_presentacion', @presentacion_cerveza_unidad,
        'cantidad', 5.000,
        'costo_unitario', 7.50,
        'codigo_lote', 'LOTE-VENCIDO-001',
        'fecha_vencimiento', DATE_SUB(CURRENT_DATE, INTERVAL 1 DAY),
        'id_ubicacion', @almacen
    )),
    @compra_cerveza_vencida
);

-- 2 kg x 1000 = 2000 gramos base.
CALL sp_registrar_compra(
    @proveedor, @usuario_admin, @fecha_compra_peso, 'Ingreso de maní por kilogramo',
    JSON_ARRAY(JSON_OBJECT(
        'id_presentacion', @presentacion_mani_kg,
        'cantidad', 2.000,
        'costo_unitario', 14.00,
        'codigo_lote', 'MANI-KG-001',
        'fecha_vencimiento', DATE_ADD(CURRENT_DATE, INTERVAL 90 DAY),
        'id_ubicacion', @estante
    )),
    @compra_mani_kg
);

-- 1 libra x 453.592 = 453.592 gramos base.
CALL sp_registrar_compra(
    @proveedor, @usuario_admin, @fecha_compra_libra, 'Ingreso de maní por libra',
    JSON_ARRAY(JSON_OBJECT(
        'id_presentacion', @presentacion_mani_libra,
        'cantidad', 1.000,
        'costo_unitario', 8.00,
        'codigo_lote', 'MANI-LB-001',
        'fecha_vencimiento', DATE_ADD(CURRENT_DATE, INTERVAL 100 DAY),
        'id_ubicacion', @estante
    )),
    @compra_mani_libra
);

CALL sp_registrar_compra(
    @proveedor, @usuario_admin, @fecha_compra_libra, 'Producto para cruce negativo',
    JSON_ARRAY(JSON_OBJECT(
        'id_presentacion', @presentacion_control,
        'cantidad', 5.000,
        'costo_unitario', 3.00,
        'codigo_lote', 'CONTROL-001',
        'fecha_vencimiento', DATE_ADD(CURRENT_DATE, INTERVAL 365 DAY),
        'id_ubicacion', @almacen
    )),
    @compra_control
);

SELECT lu.id_lote_ubicacion INTO @lu_lote_antiguo
  FROM lote_ubicacion lu INNER JOIN lote_producto lp ON lp.id_lote = lu.id_lote
 WHERE lp.codigo_lote = 'LOTE-ANTIGUO-001';
SELECT lu.id_lote_ubicacion INTO @lu_lote_nuevo
  FROM lote_ubicacion lu INNER JOIN lote_producto lp ON lp.id_lote = lu.id_lote
 WHERE lp.codigo_lote = 'LOTE-NUEVO-002';
SELECT lu.id_lote_ubicacion INTO @lu_lote_caja
  FROM lote_ubicacion lu INNER JOIN lote_producto lp ON lp.id_lote = lu.id_lote
 WHERE lp.codigo_lote = 'LOTE-CAJA-024';
SELECT lu.id_lote_ubicacion INTO @lu_lote_vencido
  FROM lote_ubicacion lu INNER JOIN lote_producto lp ON lp.id_lote = lu.id_lote
 WHERE lp.codigo_lote = 'LOTE-VENCIDO-001';
SELECT lu.id_lote_ubicacion INTO @lu_mani_kg
  FROM lote_ubicacion lu INNER JOIN lote_producto lp ON lp.id_lote = lu.id_lote
 WHERE lp.codigo_lote = 'MANI-KG-001';
SELECT lu.id_lote_ubicacion INTO @lu_mani_libra
  FROM lote_ubicacion lu INNER JOIN lote_producto lp ON lp.id_lote = lu.id_lote
 WHERE lp.codigo_lote = 'MANI-LB-001';
SELECT lu.id_lote_ubicacion INTO @lu_control
  FROM lote_ubicacion lu INNER JOIN lote_producto lp ON lp.id_lote = lu.id_lote
 WHERE lp.codigo_lote = 'CONTROL-001';

-- ------------------------------------------------------------
-- Caja y ventas positivas
-- ------------------------------------------------------------

INSERT INTO sesion_caja (
    id_usuario, fecha_hora_apertura, monto_inicial, estado, observacion
) VALUES (
    @usuario_vendedor, @fecha_apertura, 100.00, 'ABIERTA', 'Sesión V2 principal'
);
SET @sesion_principal = LAST_INSERT_ID();

-- FIFO 12 unidades: 10 del lote antiguo y 2 del nuevo. Pago mixto.
CALL sp_registrar_venta(
    @sesion_principal,
    JSON_ARRAY(JSON_OBJECT(
        'id_presentacion', @presentacion_cerveza_unidad,
        'cantidad', 12.000
    )),
    JSON_ARRAY(
        JSON_OBJECT('metodo_pago', 'EFECTIVO', 'monto', 100.00),
        JSON_OBJECT('metodo_pago', 'QR', 'monto', 44.00,
                    'comprobante_qr', 'comprobantes/venta_fifo.png')
    ),
    @venta_fifo
);

-- 0.250 kg x 1000 = 250 g; 0.250 x 20 Bs = 5 Bs.
CALL sp_registrar_venta(
    @sesion_principal,
    JSON_ARRAY(JSON_OBJECT(
        'id_presentacion', @presentacion_mani_kg,
        'cantidad', 0.250
    )),
    JSON_ARRAY(JSON_OBJECT(
        'metodo_pago', 'EFECTIVO', 'monto', 5.00
    )),
    @venta_mani_decimal
);

-- Pago QR completo.
CALL sp_registrar_venta(
    @sesion_principal,
    JSON_ARRAY(JSON_OBJECT(
        'id_presentacion', @presentacion_cerveza_unidad,
        'cantidad', 1.000
    )),
    JSON_ARRAY(JSON_OBJECT(
        'metodo_pago', 'QR', 'monto', 12.00,
        'comprobante_qr', 'comprobantes/venta_qr.png'
    )),
    @venta_qr
);

-- Venta que se anula: el pago queda como historial y el stock se devuelve.
SELECT stock_disponible INTO @stock_antes_anulacion
  FROM vw_stock_producto WHERE id_producto = @producto_cerveza;

CALL sp_registrar_venta(
    @sesion_principal,
    JSON_ARRAY(JSON_OBJECT(
        'id_presentacion', @presentacion_cerveza_unidad,
        'cantidad', 2.000
    )),
    JSON_ARRAY(JSON_OBJECT(
        'metodo_pago', 'EFECTIVO', 'monto', 24.00
    )),
    @venta_anulada
);

SELECT stock_disponible INTO @stock_despues_venta_anulable
  FROM vw_stock_producto WHERE id_producto = @producto_cerveza;

CALL sp_anular_venta(@venta_anulada, 'Prueba de devolución exacta V2');

SELECT stock_disponible INTO @stock_despues_anulacion
  FROM vw_stock_producto WHERE id_producto = @producto_cerveza;

-- Ajustes seguros: uno disponible y uno vencido.
CALL sp_registrar_ajuste_inventario(
    @lu_lote_caja, @usuario_admin, 'DAÑADO', 1.000,
    'Unidad dañada en almacén', @ajuste_danado
);

CALL sp_registrar_ajuste_inventario(
    @lu_lote_vencido, @usuario_admin, 'VENCIDO', 1.000,
    'Retiro parcial de lote vencido', @ajuste_vencido
);

-- Efectivo vigente: 100 inicial + 100 FIFO + 5 maní = 205.
SELECT id_denominacion INTO @denominacion_200
  FROM denominacion WHERE valor = 200.00;
SELECT id_denominacion INTO @denominacion_5
  FROM denominacion WHERE valor = 5.00;

CALL sp_cerrar_sesion_caja(
    @sesion_principal,
    @fecha_cierre,
    'Arqueo V2 sin diferencia',
    JSON_ARRAY(
        JSON_OBJECT('id_denominacion', @denominacion_200, 'cantidad', 1),
        JSON_OBJECT('id_denominacion', @denominacion_5, 'cantidad', 1)
    ),
    @arqueo_principal
);

-- Sesión abierta utilizada exclusivamente por las pruebas negativas.
INSERT INTO sesion_caja (
    id_usuario, fecha_hora_apertura, monto_inicial, estado, observacion
) VALUES (
    @usuario_vendedor, DATE_ADD(@fecha_cierre, INTERVAL 1 MINUTE),
    0.00, 'ABIERTA', 'Sesión para pruebas negativas V2'
);
SET @sesion_pruebas = LAST_INSERT_ID();
