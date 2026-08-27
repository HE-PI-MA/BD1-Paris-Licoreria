-- ============================================================
-- PARÍS LICORERÍA
-- CREACIÓN DE TABLAS
-- Modelo normalizado hasta 3FN
-- ============================================================

USE paris_licoreria;


-- ============================================================
-- 1. ROL
-- ============================================================

CREATE TABLE rol (
    id_rol INT UNSIGNED AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL,
    descripcion VARCHAR(150) NULL,

    CONSTRAINT pk_rol
        PRIMARY KEY (id_rol),

    CONSTRAINT uq_rol_nombre
        UNIQUE (nombre)
) ENGINE=InnoDB;


-- ============================================================
-- 2. USUARIO
-- ============================================================

CREATE TABLE usuario (
    id_usuario INT UNSIGNED AUTO_INCREMENT,
    id_rol INT UNSIGNED NOT NULL,
    nombre VARCHAR(80) NOT NULL,
    apellido VARCHAR(80) NOT NULL,
    nombre_usuario VARCHAR(50) NOT NULL,
    contrasena VARCHAR(255) NOT NULL,
    estado VARCHAR(20) NOT NULL DEFAULT 'ACTIVO',

    CONSTRAINT pk_usuario
        PRIMARY KEY (id_usuario),

    CONSTRAINT uq_usuario_nombre_usuario
        UNIQUE (nombre_usuario),

    CONSTRAINT fk_usuario_rol
        FOREIGN KEY (id_rol)
        REFERENCES rol(id_rol)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB;


-- ============================================================
-- 3. CATEGORIA
-- ============================================================

CREATE TABLE categoria (
    id_categoria INT UNSIGNED AUTO_INCREMENT,
    nombre VARCHAR(80) NOT NULL,
    descripcion VARCHAR(150) NULL,
    estado VARCHAR(20) NOT NULL DEFAULT 'ACTIVO',

    CONSTRAINT pk_categoria
        PRIMARY KEY (id_categoria),

    CONSTRAINT uq_categoria_nombre
        UNIQUE (nombre)
) ENGINE=InnoDB;


-- ============================================================
-- 4. UNIDAD_MEDIDA
-- ============================================================

CREATE TABLE unidad_medida (
    id_unidad_medida INT UNSIGNED AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL,
    abreviatura VARCHAR(10) NOT NULL,

    CONSTRAINT pk_unidad_medida
        PRIMARY KEY (id_unidad_medida),

    CONSTRAINT uq_unidad_medida_nombre
        UNIQUE (nombre)
) ENGINE=InnoDB;


-- ============================================================
-- 5. PRODUCTO
-- ============================================================

CREATE TABLE producto (
    id_producto INT UNSIGNED AUTO_INCREMENT,
    id_categoria INT UNSIGNED NOT NULL,
    id_unidad_medida INT UNSIGNED NOT NULL,
    nombre VARCHAR(120) NOT NULL,
    descripcion VARCHAR(255) NULL,
    stock_minimo DECIMAL(12,3) NOT NULL DEFAULT 0,
    estado VARCHAR(20) NOT NULL DEFAULT 'ACTIVO',

    CONSTRAINT pk_producto
        PRIMARY KEY (id_producto),

    CONSTRAINT fk_producto_categoria
        FOREIGN KEY (id_categoria)
        REFERENCES categoria(id_categoria)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_producto_unidad
        FOREIGN KEY (id_unidad_medida)
        REFERENCES unidad_medida(id_unidad_medida)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB;


-- ============================================================
-- 6. PRESENTACION_PRODUCTO
-- ============================================================

CREATE TABLE presentacion_producto (
    id_presentacion INT UNSIGNED AUTO_INCREMENT,
    id_producto INT UNSIGNED NOT NULL,
    nombre_presentacion VARCHAR(80) NOT NULL,
    factor_conversion DECIMAL(12,3) NOT NULL,
    codigo_barras VARCHAR(50) NULL,
    precio_venta DECIMAL(12,2) NOT NULL,
    estado VARCHAR(20) NOT NULL DEFAULT 'ACTIVO',

    CONSTRAINT pk_presentacion_producto
        PRIMARY KEY (id_presentacion),

    CONSTRAINT uq_presentacion_codigo_barras
        UNIQUE (codigo_barras),

    CONSTRAINT fk_presentacion_producto
        FOREIGN KEY (id_producto)
        REFERENCES producto(id_producto)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB;


-- ============================================================
-- 7. PROVEEDOR
-- ============================================================

CREATE TABLE proveedor (
    id_proveedor INT UNSIGNED AUTO_INCREMENT,
    nombre VARCHAR(120) NOT NULL,
    contacto VARCHAR(100) NULL,
    telefono VARCHAR(30) NULL,
    direccion VARCHAR(200) NULL,
    estado VARCHAR(20) NOT NULL DEFAULT 'ACTIVO',

    CONSTRAINT pk_proveedor
        PRIMARY KEY (id_proveedor)
) ENGINE=InnoDB;


-- ============================================================
-- 8. COMPRA
-- ============================================================

CREATE TABLE compra (
    id_compra INT UNSIGNED AUTO_INCREMENT,
    id_proveedor INT UNSIGNED NOT NULL,
    id_usuario INT UNSIGNED NOT NULL,
    fecha_hora DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    observacion VARCHAR(250) NULL,

    CONSTRAINT pk_compra
        PRIMARY KEY (id_compra),

    CONSTRAINT fk_compra_proveedor
        FOREIGN KEY (id_proveedor)
        REFERENCES proveedor(id_proveedor)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_compra_usuario
        FOREIGN KEY (id_usuario)
        REFERENCES usuario(id_usuario)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB;


-- ============================================================
-- 9. DETALLE_COMPRA
-- ============================================================

CREATE TABLE detalle_compra (
    id_detalle_compra INT UNSIGNED AUTO_INCREMENT,
    id_compra INT UNSIGNED NOT NULL,
    id_presentacion INT UNSIGNED NOT NULL,
    cantidad DECIMAL(12,3) NOT NULL,
    costo_unitario DECIMAL(12,2) NOT NULL,

    CONSTRAINT pk_detalle_compra
        PRIMARY KEY (id_detalle_compra),

    CONSTRAINT fk_detalle_compra_compra
        FOREIGN KEY (id_compra)
        REFERENCES compra(id_compra)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_detalle_compra_presentacion
        FOREIGN KEY (id_presentacion)
        REFERENCES presentacion_producto(id_presentacion)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB;


-- ============================================================
-- 10. LOTE_PRODUCTO
-- ============================================================

CREATE TABLE lote_producto (
    id_lote INT UNSIGNED AUTO_INCREMENT,
    id_detalle_compra INT UNSIGNED NOT NULL,
    codigo_lote VARCHAR(80) NULL,
    fecha_vencimiento DATE NULL,
    cantidad_inicial DECIMAL(12,3) NOT NULL,

    CONSTRAINT pk_lote_producto
        PRIMARY KEY (id_lote),

    CONSTRAINT fk_lote_detalle_compra
        FOREIGN KEY (id_detalle_compra)
        REFERENCES detalle_compra(id_detalle_compra)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB;


-- ============================================================
-- 11. UBICACION
-- ============================================================

CREATE TABLE ubicacion (
    id_ubicacion INT UNSIGNED AUTO_INCREMENT,
    nombre VARCHAR(80) NOT NULL,
    descripcion VARCHAR(150) NULL,
    estado VARCHAR(20) NOT NULL DEFAULT 'ACTIVO',

    CONSTRAINT pk_ubicacion
        PRIMARY KEY (id_ubicacion),

    CONSTRAINT uq_ubicacion_nombre
        UNIQUE (nombre)
) ENGINE=InnoDB;


-- ============================================================
-- 12. LOTE_UBICACION
-- ============================================================

CREATE TABLE lote_ubicacion (
    id_lote_ubicacion INT UNSIGNED AUTO_INCREMENT,
    id_lote INT UNSIGNED NOT NULL,
    id_ubicacion INT UNSIGNED NOT NULL,
    cantidad_actual DECIMAL(12,3) NOT NULL DEFAULT 0,

    CONSTRAINT pk_lote_ubicacion
        PRIMARY KEY (id_lote_ubicacion),

    CONSTRAINT uq_lote_ubicacion
        UNIQUE (id_lote, id_ubicacion),

    CONSTRAINT fk_lote_ubicacion_lote
        FOREIGN KEY (id_lote)
        REFERENCES lote_producto(id_lote)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_lote_ubicacion_ubicacion
        FOREIGN KEY (id_ubicacion)
        REFERENCES ubicacion(id_ubicacion)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB;


-- ============================================================
-- 13. AJUSTE_INVENTARIO
-- ============================================================

CREATE TABLE ajuste_inventario (
    id_ajuste INT UNSIGNED AUTO_INCREMENT,
    id_lote_ubicacion INT UNSIGNED NOT NULL,
    id_usuario INT UNSIGNED NOT NULL,
    fecha_hora DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    tipo_ajuste VARCHAR(30) NOT NULL,
    cantidad DECIMAL(12,3) NOT NULL,
    observacion VARCHAR(250) NULL,

    CONSTRAINT pk_ajuste_inventario
        PRIMARY KEY (id_ajuste),

    CONSTRAINT fk_ajuste_lote_ubicacion
        FOREIGN KEY (id_lote_ubicacion)
        REFERENCES lote_ubicacion(id_lote_ubicacion)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_ajuste_usuario
        FOREIGN KEY (id_usuario)
        REFERENCES usuario(id_usuario)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB;


-- ============================================================
-- 14. SESION_CAJA
-- ============================================================

CREATE TABLE sesion_caja (
    id_sesion_caja INT UNSIGNED AUTO_INCREMENT,
    id_usuario INT UNSIGNED NOT NULL,
    fecha_hora_apertura DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    monto_inicial DECIMAL(12,2) NOT NULL DEFAULT 0,
    fecha_hora_cierre DATETIME NULL,
    estado VARCHAR(20) NOT NULL DEFAULT 'ABIERTA',
    observacion VARCHAR(250) NULL,

    CONSTRAINT pk_sesion_caja
        PRIMARY KEY (id_sesion_caja),

    CONSTRAINT fk_sesion_usuario
        FOREIGN KEY (id_usuario)
        REFERENCES usuario(id_usuario)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB;


-- ============================================================
-- 15. VENTA
-- ============================================================

CREATE TABLE venta (
    id_venta INT UNSIGNED AUTO_INCREMENT,
    id_sesion_caja INT UNSIGNED NOT NULL,
    fecha_hora DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    estado VARCHAR(20) NOT NULL DEFAULT 'VIGENTE',
    motivo_anulacion VARCHAR(250) NULL,

    CONSTRAINT pk_venta
        PRIMARY KEY (id_venta),

    CONSTRAINT fk_venta_sesion
        FOREIGN KEY (id_sesion_caja)
        REFERENCES sesion_caja(id_sesion_caja)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB;


-- ============================================================
-- 16. DETALLE_VENTA
-- ============================================================

CREATE TABLE detalle_venta (
    id_detalle_venta INT UNSIGNED AUTO_INCREMENT,
    id_venta INT UNSIGNED NOT NULL,
    id_presentacion INT UNSIGNED NOT NULL,
    cantidad DECIMAL(12,3) NOT NULL,
    precio_unitario DECIMAL(12,2) NOT NULL,

    CONSTRAINT pk_detalle_venta
        PRIMARY KEY (id_detalle_venta),

    CONSTRAINT fk_detalle_venta_venta
        FOREIGN KEY (id_venta)
        REFERENCES venta(id_venta)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_detalle_venta_presentacion
        FOREIGN KEY (id_presentacion)
        REFERENCES presentacion_producto(id_presentacion)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB;


-- ============================================================
-- 17. DETALLE_VENTA_LOTE
-- ============================================================

CREATE TABLE detalle_venta_lote (
    id_detalle_venta_lote INT UNSIGNED AUTO_INCREMENT,
    id_detalle_venta INT UNSIGNED NOT NULL,
    id_lote_ubicacion INT UNSIGNED NOT NULL,
    cantidad_base DECIMAL(12,3) NOT NULL,

    CONSTRAINT pk_detalle_venta_lote
        PRIMARY KEY (id_detalle_venta_lote),

    CONSTRAINT uq_detalle_venta_lote
        UNIQUE (id_detalle_venta, id_lote_ubicacion),

    CONSTRAINT fk_dvl_detalle_venta
        FOREIGN KEY (id_detalle_venta)
        REFERENCES detalle_venta(id_detalle_venta)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_dvl_lote_ubicacion
        FOREIGN KEY (id_lote_ubicacion)
        REFERENCES lote_ubicacion(id_lote_ubicacion)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB;


-- ============================================================
-- 18. PAGO
-- ============================================================

CREATE TABLE pago (
    id_pago INT UNSIGNED AUTO_INCREMENT,
    id_venta INT UNSIGNED NOT NULL,
    metodo_pago VARCHAR(20) NOT NULL,
    monto DECIMAL(12,2) NOT NULL,
    comprobante_qr VARCHAR(255) NULL,

    CONSTRAINT pk_pago
        PRIMARY KEY (id_pago),

    CONSTRAINT fk_pago_venta
        FOREIGN KEY (id_venta)
        REFERENCES venta(id_venta)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB;


-- ============================================================
-- 19. DENOMINACION
-- ============================================================

CREATE TABLE denominacion (
    id_denominacion INT UNSIGNED AUTO_INCREMENT,
    valor DECIMAL(12,2) NOT NULL,
    tipo VARCHAR(20) NOT NULL,
    estado VARCHAR(20) NOT NULL DEFAULT 'ACTIVO',

    CONSTRAINT pk_denominacion
        PRIMARY KEY (id_denominacion),

    CONSTRAINT uq_denominacion_valor
        UNIQUE (valor)
) ENGINE=InnoDB;


-- ============================================================
-- 20. ARQUEO_CAJA
-- ============================================================

CREATE TABLE arqueo_caja (
    id_arqueo INT UNSIGNED AUTO_INCREMENT,
    id_sesion_caja INT UNSIGNED NOT NULL,
    fecha_hora DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    observacion VARCHAR(250) NULL,

    CONSTRAINT pk_arqueo_caja
        PRIMARY KEY (id_arqueo),

    CONSTRAINT uq_arqueo_sesion
        UNIQUE (id_sesion_caja),

    CONSTRAINT fk_arqueo_sesion
        FOREIGN KEY (id_sesion_caja)
        REFERENCES sesion_caja(id_sesion_caja)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB;


-- ============================================================
-- 21. DETALLE_ARQUEO
-- ============================================================

CREATE TABLE detalle_arqueo (
    id_detalle_arqueo INT UNSIGNED AUTO_INCREMENT,
    id_arqueo INT UNSIGNED NOT NULL,
    id_denominacion INT UNSIGNED NOT NULL,
    cantidad INT UNSIGNED NOT NULL DEFAULT 0,

    CONSTRAINT pk_detalle_arqueo
        PRIMARY KEY (id_detalle_arqueo),

    CONSTRAINT uq_detalle_arqueo
        UNIQUE (id_arqueo, id_denominacion),

    CONSTRAINT fk_detalle_arqueo_arqueo
        FOREIGN KEY (id_arqueo)
        REFERENCES arqueo_caja(id_arqueo)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_detalle_arqueo_denominacion
        FOREIGN KEY (id_denominacion)
        REFERENCES denominacion(id_denominacion)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB;
-- ============================================================
-- RESTRICCIONES CHECK
-- Reemplazan UNSIGNED en columnas DECIMAL
-- ============================================================

ALTER TABLE producto
    ADD CONSTRAINT chk_producto_stock_minimo
    CHECK (stock_minimo >= 0);

ALTER TABLE presentacion_producto
    ADD CONSTRAINT chk_presentacion_factor
    CHECK (factor_conversion > 0),
    ADD CONSTRAINT chk_presentacion_precio
    CHECK (precio_venta >= 0);

ALTER TABLE detalle_compra
    ADD CONSTRAINT chk_detalle_compra_cantidad
    CHECK (cantidad > 0),
    ADD CONSTRAINT chk_detalle_compra_costo
    CHECK (costo_unitario >= 0);

ALTER TABLE lote_producto
    ADD CONSTRAINT chk_lote_cantidad_inicial
    CHECK (cantidad_inicial > 0);

ALTER TABLE lote_ubicacion
    ADD CONSTRAINT chk_lote_ubicacion_cantidad
    CHECK (cantidad_actual >= 0);

ALTER TABLE ajuste_inventario
    ADD CONSTRAINT chk_ajuste_cantidad
    CHECK (cantidad > 0),
    ADD CONSTRAINT chk_ajuste_tipo
    CHECK (tipo_ajuste IN ('DAÑADO','PERDIDO','VENCIDO','OTRO'));

ALTER TABLE sesion_caja
    ADD CONSTRAINT chk_sesion_monto_inicial
    CHECK (monto_inicial >= 0),
    ADD CONSTRAINT chk_sesion_estado
    CHECK (estado IN ('ABIERTA','CERRADA'));

ALTER TABLE venta
    ADD CONSTRAINT chk_venta_estado
    CHECK (estado IN ('VIGENTE','ANULADA')),
    ADD CONSTRAINT chk_venta_anulacion
    CHECK (
        (estado = 'VIGENTE' AND motivo_anulacion IS NULL)
        OR
        (estado = 'ANULADA' AND motivo_anulacion IS NOT NULL)
    );

ALTER TABLE detalle_venta
    ADD CONSTRAINT chk_detalle_venta_cantidad
    CHECK (cantidad > 0),
    ADD CONSTRAINT chk_detalle_venta_precio
    CHECK (precio_unitario >= 0);

ALTER TABLE detalle_venta_lote
    ADD CONSTRAINT chk_dvl_cantidad
    CHECK (cantidad_base > 0);

ALTER TABLE pago
    ADD CONSTRAINT chk_pago_monto
    CHECK (monto > 0),
    ADD CONSTRAINT chk_pago_metodo
    CHECK (metodo_pago IN ('EFECTIVO','QR')),
    ADD CONSTRAINT chk_pago_comprobante_qr
    CHECK (
        metodo_pago <> 'QR'
        OR comprobante_qr IS NOT NULL
    );

ALTER TABLE denominacion
    ADD CONSTRAINT chk_denominacion_valor
    CHECK (valor > 0),
    ADD CONSTRAINT chk_denominacion_tipo
    CHECK (tipo IN ('BILLETE','MONEDA'));

ALTER TABLE detalle_arqueo
    ADD CONSTRAINT chk_detalle_arqueo_cantidad
    CHECK (cantidad >= 0);
