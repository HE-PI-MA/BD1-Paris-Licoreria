-- ============================================================
-- PARÍS LICORERÍA V2
-- PRUEBAS AUTOMÁTICAS CON ASSERTIONS Y SIGNAL
-- ============================================================
-- El mensaje final solo se ejecuta dentro de sp_ejecutar_pruebas_v2.
-- Cualquier assertion fallida aborta ese procedimiento antes del mensaje.

USE paris_licoreria;
SET NAMES utf8mb4;

DELIMITER //

DROP PROCEDURE IF EXISTS sp_assert_true//
CREATE PROCEDURE sp_assert_true(
    IN p_condicion BOOLEAN,
    IN p_mensaje VARCHAR(255)
)
BEGIN
    IF p_condicion IS NULL OR p_condicion = FALSE THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = p_mensaje;
    END IF;
END//

DROP PROCEDURE IF EXISTS test_stock_insuficiente//
CREATE PROCEDURE test_stock_insuficiente()
BEGIN
    DECLARE v_error BOOLEAN DEFAULT FALSE;
    DECLARE v_venta INT UNSIGNED;
    DECLARE v_stock_antes DECIMAL(18,3);
    DECLARE v_stock_despues DECIMAL(18,3);

    SELECT stock_disponible INTO v_stock_antes
      FROM vw_stock_producto WHERE id_producto = @producto_cerveza;

    BEGIN
        DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET v_error = TRUE;
        CALL sp_registrar_venta(
            @sesion_pruebas,
            JSON_ARRAY(JSON_OBJECT(
                'id_presentacion', @presentacion_cerveza_caja,
                'cantidad', 1000.000
            )),
            JSON_ARRAY(JSON_OBJECT(
                'metodo_pago', 'EFECTIVO', 'monto', 250000.00
            )),
            v_venta
        );
    END;

    SELECT stock_disponible INTO v_stock_despues
      FROM vw_stock_producto WHERE id_producto = @producto_cerveza;

    CALL sp_assert_true(v_error, 'FALLO: se permitió vender más stock del disponible');
    CALL sp_assert_true(v_venta IS NULL, 'FALLO: la venta insuficiente no hizo rollback');
    CALL sp_assert_true(v_stock_antes = v_stock_despues,
                        'FALLO: el rollback de stock insuficiente no fue completo');
END//

DROP PROCEDURE IF EXISTS test_pago_incompleto//
CREATE PROCEDURE test_pago_incompleto()
BEGIN
    DECLARE v_error BOOLEAN DEFAULT FALSE;
    DECLARE v_venta INT UNSIGNED;
    DECLARE v_count_antes INT;
    DECLARE v_count_despues INT;
    DECLARE v_stock_antes DECIMAL(18,3);
    DECLARE v_stock_despues DECIMAL(18,3);

    SELECT COUNT(*) INTO v_count_antes FROM venta;
    SELECT stock_disponible INTO v_stock_antes
      FROM vw_stock_producto WHERE id_producto = @producto_cerveza;

    BEGIN
        DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET v_error = TRUE;
        CALL sp_registrar_venta(
            @sesion_pruebas,
            JSON_ARRAY(JSON_OBJECT(
                'id_presentacion', @presentacion_cerveza_unidad,
                'cantidad', 1.000
            )),
            JSON_ARRAY(JSON_OBJECT(
                'metodo_pago', 'EFECTIVO', 'monto', 11.00
            )),
            v_venta
        );
    END;

    SELECT COUNT(*) INTO v_count_despues FROM venta;
    SELECT stock_disponible INTO v_stock_despues
      FROM vw_stock_producto WHERE id_producto = @producto_cerveza;

    CALL sp_assert_true(v_error, 'FALLO: se permitió pago incompleto');
    CALL sp_assert_true(v_venta IS NULL AND v_count_antes = v_count_despues,
                        'FALLO: el pago incompleto dejó una venta parcial');
    CALL sp_assert_true(v_stock_antes = v_stock_despues,
                        'FALLO: el pago incompleto no restauró el stock');
END//

DROP PROCEDURE IF EXISTS test_lote_vencido//
CREATE PROCEDURE test_lote_vencido()
BEGIN
    DECLARE v_error BOOLEAN DEFAULT FALSE;
    DECLARE v_venta INT UNSIGNED;
    DECLARE v_detalle INT UNSIGNED;

    START TRANSACTION;
    INSERT INTO venta (id_sesion_caja, fecha_hora, estado, motivo_anulacion)
    VALUES (@sesion_pruebas, CURRENT_TIMESTAMP, 'VIGENTE', NULL);
    SET v_venta = LAST_INSERT_ID();

    INSERT INTO detalle_venta (id_venta, id_presentacion, cantidad, precio_unitario)
    VALUES (v_venta, @presentacion_cerveza_unidad, 1.000, 12.00);
    SET v_detalle = LAST_INSERT_ID();

    BEGIN
        DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET v_error = TRUE;
        INSERT INTO detalle_venta_lote (
            id_detalle_venta, id_lote_ubicacion, cantidad_base
        ) VALUES (v_detalle, @lu_lote_vencido, 1.000);
    END;
    ROLLBACK;

    CALL sp_assert_true(v_error, 'FALLO: se permitió vender un lote vencido');
END//

DROP PROCEDURE IF EXISTS test_producto_lote_cruzado//
CREATE PROCEDURE test_producto_lote_cruzado()
BEGIN
    DECLARE v_error BOOLEAN DEFAULT FALSE;
    DECLARE v_venta INT UNSIGNED;
    DECLARE v_detalle INT UNSIGNED;

    START TRANSACTION;
    INSERT INTO venta (id_sesion_caja, fecha_hora, estado, motivo_anulacion)
    VALUES (@sesion_pruebas, CURRENT_TIMESTAMP, 'VIGENTE', NULL);
    SET v_venta = LAST_INSERT_ID();

    INSERT INTO detalle_venta (id_venta, id_presentacion, cantidad, precio_unitario)
    VALUES (v_venta, @presentacion_cerveza_unidad, 1.000, 12.00);
    SET v_detalle = LAST_INSERT_ID();

    BEGIN
        DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET v_error = TRUE;
        INSERT INTO detalle_venta_lote (
            id_detalle_venta, id_lote_ubicacion, cantidad_base
        ) VALUES (v_detalle, @lu_control, 1.000);
    END;
    ROLLBACK;

    CALL sp_assert_true(v_error, 'FALLO: se permitió cruzar venta y lote de productos distintos');
END//

DROP PROCEDURE IF EXISTS test_caja_cerrada//
CREATE PROCEDURE test_caja_cerrada()
BEGIN
    DECLARE v_error BOOLEAN DEFAULT FALSE;
    DECLARE v_venta INT UNSIGNED;

    BEGIN
        DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET v_error = TRUE;
        CALL sp_registrar_venta(
            @sesion_principal,
            JSON_ARRAY(JSON_OBJECT(
                'id_presentacion', @presentacion_cerveza_unidad,
                'cantidad', 1.000
            )),
            JSON_ARRAY(JSON_OBJECT(
                'metodo_pago', 'EFECTIVO', 'monto', 12.00
            )),
            v_venta
        );
    END;

    CALL sp_assert_true(v_error, 'FALLO: se permitió vender en una sesión cerrada');
    CALL sp_assert_true(v_venta IS NULL, 'FALLO: la venta en caja cerrada dejó datos');
END//

DROP PROCEDURE IF EXISTS test_stock_negativo//
CREATE PROCEDURE test_stock_negativo()
BEGIN
    DECLARE v_error BOOLEAN DEFAULT FALSE;

    START TRANSACTION;
    BEGIN
        DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET v_error = TRUE;
        UPDATE lote_ubicacion
           SET cantidad_actual = -1
         WHERE id_lote_ubicacion = @lu_lote_caja;
    END;
    ROLLBACK;

    CALL sp_assert_true(v_error, 'FALLO: se permitió stock negativo');
END//

DROP PROCEDURE IF EXISTS test_ajuste_superior//
CREATE PROCEDURE test_ajuste_superior()
BEGIN
    DECLARE v_error BOOLEAN DEFAULT FALSE;
    DECLARE v_ajuste INT UNSIGNED;
    DECLARE v_stock_antes DECIMAL(18,3);
    DECLARE v_stock_despues DECIMAL(18,3);

    SELECT cantidad_actual INTO v_stock_antes
      FROM lote_ubicacion WHERE id_lote_ubicacion = @lu_lote_caja;

    BEGIN
        DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET v_error = TRUE;
        CALL sp_registrar_ajuste_inventario(
            @lu_lote_caja, @usuario_admin, 'DAÑADO',
            v_stock_antes + 1.000, 'Debe fallar', v_ajuste
        );
    END;

    SELECT cantidad_actual INTO v_stock_despues
      FROM lote_ubicacion WHERE id_lote_ubicacion = @lu_lote_caja;

    CALL sp_assert_true(v_error, 'FALLO: se permitió un ajuste superior al stock');
    CALL sp_assert_true(v_ajuste IS NULL AND v_stock_antes = v_stock_despues,
                        'FALLO: el ajuste inválido no hizo rollback');
END//

DROP PROCEDURE IF EXISTS test_doble_anulacion//
CREATE PROCEDURE test_doble_anulacion()
BEGIN
    DECLARE v_error BOOLEAN DEFAULT FALSE;

    BEGIN
        DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET v_error = TRUE;
        CALL sp_anular_venta(@venta_anulada, 'Segundo intento inválido');
    END;

    CALL sp_assert_true(v_error, 'FALLO: se permitió anular dos veces una venta');
END//

DROP PROCEDURE IF EXISTS test_qr_sin_comprobante//
CREATE PROCEDURE test_qr_sin_comprobante()
BEGIN
    DECLARE v_error BOOLEAN DEFAULT FALSE;
    DECLARE v_venta INT UNSIGNED;

    BEGIN
        DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET v_error = TRUE;
        CALL sp_registrar_venta(
            @sesion_pruebas,
            JSON_ARRAY(JSON_OBJECT(
                'id_presentacion', @presentacion_cerveza_unidad,
                'cantidad', 1.000
            )),
            JSON_ARRAY(JSON_OBJECT(
                'metodo_pago', 'QR', 'monto', 12.00
            )),
            v_venta
        );
    END;

    CALL sp_assert_true(v_error, 'FALLO: se permitió QR sin comprobante');
END//

DROP PROCEDURE IF EXISTS test_estado_caja_inconsistente//
CREATE PROCEDURE test_estado_caja_inconsistente()
BEGIN
    DECLARE v_error BOOLEAN DEFAULT FALSE;

    START TRANSACTION;
    BEGIN
        DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET v_error = TRUE;
        UPDATE sesion_caja
           SET estado = 'CERRADA', fecha_hora_cierre = NULL
         WHERE id_sesion_caja = @sesion_pruebas;
    END;
    ROLLBACK;

    CALL sp_assert_true(v_error, 'FALLO: se permitió cerrar caja sin fecha de cierre');
END//

DROP PROCEDURE IF EXISTS sp_ejecutar_pruebas_v2//
CREATE PROCEDURE sp_ejecutar_pruebas_v2()
BEGIN
    DECLARE v_count INT;
    DECLARE v_decimal DECIMAL(18,3);
    DECLARE v_monto DECIMAL(18,2);

    -- 1. Estructura física.
    SELECT COUNT(*) INTO v_count
      FROM information_schema.tables
     WHERE table_schema = 'paris_licoreria' AND table_type = 'BASE TABLE';
    CALL sp_assert_true(v_count = 21, 'FALLO: cantidad de tablas distinta de 21');

    SELECT COUNT(*) INTO v_count
      FROM information_schema.views
     WHERE table_schema = 'paris_licoreria';
    CALL sp_assert_true(v_count = 14, 'FALLO: cantidad de vistas distinta de 14');

    SELECT COUNT(*) INTO v_count
      FROM information_schema.routines
     WHERE routine_schema = 'paris_licoreria'
       AND routine_type = 'PROCEDURE'
       AND routine_name IN (
           'sp_registrar_compra', 'sp_registrar_venta',
           'sp_anular_venta', 'sp_registrar_ajuste_inventario',
           'sp_cerrar_sesion_caja'
       );
    CALL sp_assert_true(v_count = 5, 'FALLO: faltan procedimientos operativos V2');

    SELECT COUNT(*) INTO v_count
      FROM information_schema.triggers
     WHERE trigger_schema = 'paris_licoreria';
    CALL sp_assert_true(v_count = 21, 'FALLO: cantidad de triggers distinta de 21');

    SELECT COUNT(*) INTO v_count
      FROM information_schema.table_constraints
     WHERE constraint_schema = 'paris_licoreria'
       AND constraint_type = 'FOREIGN KEY';
    CALL sp_assert_true(v_count = 23, 'FALLO: cantidad de claves foráneas distinta de 23');

    SELECT COUNT(*) INTO v_count
      FROM information_schema.table_constraints
     WHERE constraint_schema = 'paris_licoreria'
       AND constraint_type = 'CHECK';
    CALL sp_assert_true(v_count >= 40, 'FALLO: faltan restricciones CHECK V2');

    -- 2. UTF-8 y códigos de barras VARCHAR con cero inicial.
    SELECT COUNT(*) INTO v_count FROM categoria WHERE nombre = 'Bebidas alcohólicas';
    CALL sp_assert_true(v_count = 1, 'FALLO: codificación UTF-8');
    SELECT COUNT(*) INTO v_count
      FROM presentacion_producto WHERE codigo_barras = '012345678905';
    CALL sp_assert_true(v_count = 1, 'FALLO: código UPC perdió su cero inicial');

    -- 3. Compra y conversiones.
    SELECT COUNT(*) INTO v_count FROM compra;
    CALL sp_assert_true(v_count = 7, 'FALLO: compras normales no registradas');

    SELECT lp.cantidad_inicial INTO v_decimal
      FROM lote_producto lp
     WHERE lp.codigo_lote = 'LOTE-CAJA-024';
    CALL sp_assert_true(v_decimal = 24.000, 'FALLO: caja de 24 no produjo 24 unidades');

    SELECT lp.cantidad_inicial INTO v_decimal
      FROM lote_producto lp
     WHERE lp.codigo_lote = 'MANI-KG-001';
    CALL sp_assert_true(v_decimal = 2000.000, 'FALLO: 2 kg no produjeron 2000 g');

    SELECT lp.cantidad_inicial INTO v_decimal
      FROM lote_producto lp
     WHERE lp.codigo_lote = 'MANI-LB-001';
    CALL sp_assert_true(v_decimal = 453.592, 'FALLO: 1 libra no produjo 453.592 g');

    -- 4. Venta decimal, precio y stock por peso.
    SELECT SUM(dvl.cantidad_base) INTO v_decimal
      FROM detalle_venta_lote dvl
      INNER JOIN detalle_venta dv ON dv.id_detalle_venta = dvl.id_detalle_venta
     WHERE dv.id_venta = @venta_mani_decimal;
    CALL sp_assert_true(v_decimal = 250.000, 'FALLO: 0.250 kg no descontó 250 g');

    SELECT cantidad_actual INTO v_decimal
      FROM lote_ubicacion WHERE id_lote_ubicacion = @lu_mani_kg;
    CALL sp_assert_true(v_decimal = 1750.000, 'FALLO: stock restante de maní distinto de 1750 g');

    SELECT total_venta INTO v_monto
      FROM vw_ventas_totales WHERE id_venta = @venta_mani_decimal;
    CALL sp_assert_true(v_monto = 5.00, 'FALLO: total monetario de venta decimal');

    -- 5. FIFO exacto usando dos lotes.
    SELECT COALESCE(SUM(CASE WHEN lp.codigo_lote = 'LOTE-ANTIGUO-001'
                             THEN dvl.cantidad_base ELSE 0 END), 0)
      INTO v_decimal
      FROM detalle_venta_lote dvl
      INNER JOIN detalle_venta dv ON dv.id_detalle_venta = dvl.id_detalle_venta
      INNER JOIN lote_ubicacion lu ON lu.id_lote_ubicacion = dvl.id_lote_ubicacion
      INNER JOIN lote_producto lp ON lp.id_lote = lu.id_lote
     WHERE dv.id_venta = @venta_fifo;
    CALL sp_assert_true(v_decimal = 10.000, 'FALLO: FIFO no agotó primero el lote antiguo');

    SELECT COALESCE(SUM(CASE WHEN lp.codigo_lote = 'LOTE-NUEVO-002'
                             THEN dvl.cantidad_base ELSE 0 END), 0)
      INTO v_decimal
      FROM detalle_venta_lote dvl
      INNER JOIN detalle_venta dv ON dv.id_detalle_venta = dvl.id_detalle_venta
      INNER JOIN lote_ubicacion lu ON lu.id_lote_ubicacion = dvl.id_lote_ubicacion
      INNER JOIN lote_producto lp ON lp.id_lote = lu.id_lote
     WHERE dv.id_venta = @venta_fifo;
    CALL sp_assert_true(v_decimal = 2.000, 'FALLO: FIFO no tomó 2 unidades del lote nuevo');

    -- 6. Stock físico, disponible y vencido.
    SELECT stock_disponible INTO v_decimal
      FROM vw_stock_producto WHERE id_producto = @producto_cerveza;
    CALL sp_assert_true(v_decimal = 30.000, 'FALLO: stock disponible de cerveza');

    SELECT stock_vencido INTO v_decimal
      FROM vw_stock_producto WHERE id_producto = @producto_cerveza;
    CALL sp_assert_true(v_decimal = 4.000, 'FALLO: stock vencido físico');

    SELECT stock_fisico INTO v_decimal
      FROM vw_stock_producto WHERE id_producto = @producto_cerveza;
    CALL sp_assert_true(v_decimal = 34.000, 'FALLO: stock físico total');

    -- 7. Pagos efectivo, QR y mixto.
    SELECT COUNT(*) INTO v_count
      FROM pago WHERE id_venta = @venta_mani_decimal AND metodo_pago = 'EFECTIVO';
    CALL sp_assert_true(v_count = 1, 'FALLO: pago efectivo');

    SELECT COUNT(*) INTO v_count
      FROM pago
     WHERE id_venta = @venta_qr AND metodo_pago = 'QR'
       AND comprobante_qr IS NOT NULL;
    CALL sp_assert_true(v_count = 1, 'FALLO: pago QR');

    SELECT COUNT(DISTINCT metodo_pago) INTO v_count
      FROM pago WHERE id_venta = @venta_fifo;
    CALL sp_assert_true(v_count = 2, 'FALLO: pago mixto');

    SELECT ABS(SUM(p.monto) - vt.total_venta) INTO v_monto
      FROM pago p
      INNER JOIN vw_ventas_totales vt ON vt.id_venta = p.id_venta
     WHERE p.id_venta = @venta_fifo
     GROUP BY vt.total_venta;
    CALL sp_assert_true(v_monto = 0, 'FALLO: pagos no igualan venta FIFO');

    -- 8. Anulación y devolución exacta.
    CALL sp_assert_true(
        @stock_antes_anulacion - @stock_despues_venta_anulable = 2.000,
        'FALLO: la venta anulable no descontó 2 unidades'
    );
    CALL sp_assert_true(
        @stock_antes_anulacion = @stock_despues_anulacion,
        'FALLO: la anulación no devolvió exactamente el stock'
    );
    SELECT COUNT(*) INTO v_count
      FROM venta WHERE id_venta = @venta_anulada AND estado = 'ANULADA'
       AND motivo_anulacion IS NOT NULL;
    CALL sp_assert_true(v_count = 1, 'FALLO: estado o motivo de anulación');
    SELECT COUNT(*) INTO v_count FROM pago WHERE id_venta = @venta_anulada;
    CALL sp_assert_true(v_count = 1, 'FALLO: la anulación eliminó pagos históricos');

    -- 9. Ajustes y caja.
    SELECT COUNT(*) INTO v_count
      FROM ajuste_inventario
     WHERE id_ajuste = @ajuste_danado AND tipo_ajuste = 'DAÑADO';
    CALL sp_assert_true(v_count = 1, 'FALLO: ajuste DAÑADO');

    SELECT COUNT(*) INTO v_count
      FROM ajuste_inventario
     WHERE id_ajuste = @ajuste_vencido AND tipo_ajuste = 'VENCIDO';
    CALL sp_assert_true(v_count = 1, 'FALLO: ajuste VENCIDO');

    SELECT diferencia INTO v_monto
      FROM vw_diferencias_caja WHERE id_sesion_caja = @sesion_principal;
    CALL sp_assert_true(v_monto = 0, 'FALLO: arqueo de caja no cuadra');

    SELECT efectivo_esperado INTO v_monto
      FROM vw_efectivo_esperado_sesion WHERE id_sesion_caja = @sesion_principal;
    CALL sp_assert_true(v_monto = 205.00, 'FALLO: efectivo esperado incluye pagos anulados/QR');

    -- 10. Pruebas negativas obligatorias.
    CALL test_stock_insuficiente();
    CALL test_lote_vencido();
    CALL test_producto_lote_cruzado();
    CALL test_caja_cerrada();
    CALL test_pago_incompleto();
    CALL test_stock_negativo();
    CALL test_ajuste_superior();
    CALL test_doble_anulacion();
    CALL test_qr_sin_comprobante();
    CALL test_estado_caja_inconsistente();

    -- 11. Ninguna prueba negativa debe haber dejado existencias inválidas.
    SELECT COUNT(*) INTO v_count FROM lote_ubicacion WHERE cantidad_actual < 0;
    CALL sp_assert_true(v_count = 0, 'FALLO: quedaron existencias negativas');

    SELECT 'BASE DE DATOS PARÍS LICORERÍA V2 VALIDADA' AS resultado_final;
END//

DELIMITER ;

CALL sp_ejecutar_pruebas_v2();

DROP PROCEDURE sp_ejecutar_pruebas_v2;
DROP PROCEDURE test_estado_caja_inconsistente;
DROP PROCEDURE test_qr_sin_comprobante;
DROP PROCEDURE test_doble_anulacion;
DROP PROCEDURE test_ajuste_superior;
DROP PROCEDURE test_stock_negativo;
DROP PROCEDURE test_caja_cerrada;
DROP PROCEDURE test_producto_lote_cruzado;
DROP PROCEDURE test_lote_vencido;
DROP PROCEDURE test_pago_incompleto;
DROP PROCEDURE test_stock_insuficiente;
DROP PROCEDURE sp_assert_true;
