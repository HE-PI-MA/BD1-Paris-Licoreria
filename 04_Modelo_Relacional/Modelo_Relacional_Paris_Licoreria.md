# Modelo Relacional V2 — París Licorería

## 1. Alcance

La V2 conserva las 21 relaciones del modelo académico y fortalece su comportamiento mediante claves foráneas, restricciones `UNIQUE` y `CHECK`, triggers y procedimientos almacenados transaccionales compatibles con MySQL 8.0.44.

No se agregaron tablas: las operaciones temporales recibidas como JSON se procesan en tablas temporales de sesión y no forman parte del modelo persistente.

## 2. Regla de unidad base

`PRODUCTO.id_unidad_medida` identifica la unidad base del inventario. Todas las existencias físicas se expresan en esa unidad.

`PRESENTACION_PRODUCTO.factor_conversion` indica la cantidad de unidades base contenida en una presentación:

```text
Producto base UNIDAD
Unidad       = 1
Pack de 6    = 6
Caja de 24   = 24

Producto base GRAMO
Gramo        = 1
Kilogramo    = 1000
Libra        = 453.592
```

El bloque Markdown anterior cierra correctamente la sección que estaba incompleta en la versión inicial.

## 3. Relaciones

### ROL

```text
ROL(
  id_rol PK,
  nombre UQ,
  descripcion
)
```

### USUARIO

```text
USUARIO(
  id_usuario PK,
  id_rol FK → ROL,
  nombre,
  apellido,
  nombre_usuario UQ,
  contrasena,
  estado CHECK(ACTIVO, INACTIVO)
)
```

`contrasena` almacena un hash producido por la aplicación, nunca una contraseña en texto plano.

### CATEGORIA

```text
CATEGORIA(
  id_categoria PK,
  nombre UQ,
  descripcion,
  estado CHECK(ACTIVO, INACTIVO)
)
```

### UNIDAD_MEDIDA

```text
UNIDAD_MEDIDA(
  id_unidad_medida PK,
  nombre UQ,
  abreviatura UQ
)
```

### PRODUCTO

```text
PRODUCTO(
  id_producto PK,
  id_categoria FK → CATEGORIA,
  id_unidad_medida FK → UNIDAD_MEDIDA,
  nombre,
  descripcion,
  stock_minimo DECIMAL(15,3) CHECK >= 0,
  estado CHECK(ACTIVO, INACTIVO)
)
```

No contiene `stock_actual`; el inventario se obtiene desde `LOTE_UBICACION`.

### PRESENTACION_PRODUCTO

```text
PRESENTACION_PRODUCTO(
  id_presentacion PK,
  id_producto FK → PRODUCTO,
  nombre_presentacion,
  factor_conversion DECIMAL(15,3) CHECK > 0,
  codigo_barras VARCHAR(50) NULL UQ,
  precio_venta DECIMAL(15,2) CHECK >= 0,
  estado CHECK(ACTIVO, INACTIVO),
  UQ(id_producto, nombre_presentacion)
)
```

El código permanece como texto para conservar ceros iniciales y admitir EAN-13, EAN-8, UPC y códigos internos.

### PROVEEDOR

```text
PROVEEDOR(
  id_proveedor PK,
  nombre,
  contacto,
  telefono,
  direccion,
  estado CHECK(ACTIVO, INACTIVO)
)
```

### COMPRA y DETALLE_COMPRA

```text
COMPRA(
  id_compra PK,
  id_proveedor FK → PROVEEDOR,
  id_usuario FK → USUARIO,
  fecha_hora,
  observacion
)

DETALLE_COMPRA(
  id_detalle_compra PK,
  id_compra FK → COMPRA,
  id_presentacion FK → PRESENTACION_PRODUCTO,
  cantidad DECIMAL(15,3) CHECK > 0,
  costo_unitario DECIMAL(15,2) CHECK >= 0
)
```

`DETALLE_COMPRA.cantidad` representa presentaciones compradas. El subtotal monetario es `cantidad × costo_unitario`.

### LOTE_PRODUCTO y LOTE_UBICACION

```text
LOTE_PRODUCTO(
  id_lote PK,
  id_detalle_compra FK → DETALLE_COMPRA,
  codigo_lote,
  fecha_vencimiento,
  cantidad_inicial DECIMAL(15,3) CHECK > 0
)

LOTE_UBICACION(
  id_lote_ubicacion PK,
  id_lote FK → LOTE_PRODUCTO,
  id_ubicacion FK → UBICACION,
  cantidad_actual DECIMAL(15,3) CHECK >= 0,
  UQ(id_lote, id_ubicacion)
)
```

`cantidad_inicial` y `cantidad_actual` se expresan en unidad base. Los triggers impiden que la suma de lotes supere `DETALLE_COMPRA.cantidad × factor_conversion` y que las ubicaciones superen la cantidad inicial del lote.

### UBICACION

```text
UBICACION(
  id_ubicacion PK,
  nombre UQ,
  descripcion,
  estado CHECK(ACTIVO, INACTIVO)
)
```

### AJUSTE_INVENTARIO

```text
AJUSTE_INVENTARIO(
  id_ajuste PK,
  id_lote_ubicacion FK → LOTE_UBICACION,
  id_usuario FK → USUARIO,
  fecha_hora,
  tipo_ajuste CHECK(DAÑADO, PERDIDO, VENCIDO, OTRO),
  cantidad DECIMAL(15,3) CHECK > 0,
  observacion
)
```

La cantidad está en unidad base. Un trigger descuenta el stock y rechaza retiros superiores a la existencia. `VENCIDO` solo acepta lotes cuya fecha ya fue alcanzada.

### SESION_CAJA

```text
SESION_CAJA(
  id_sesion_caja PK,
  id_usuario FK → USUARIO,
  fecha_hora_apertura,
  monto_inicial DECIMAL(15,2) CHECK >= 0,
  fecha_hora_cierre,
  estado CHECK(ABIERTA, CERRADA),
  observacion
)
```

Regla temporal:

```text
ABIERTA  → fecha_hora_cierre IS NULL
CERRADA → fecha_hora_cierre IS NOT NULL
           y fecha_hora_cierre >= fecha_hora_apertura
```

### VENTA y DETALLE_VENTA

```text
VENTA(
  id_venta PK,
  id_sesion_caja FK → SESION_CAJA,
  fecha_hora,
  estado CHECK(VIGENTE, ANULADA),
  motivo_anulacion
)

DETALLE_VENTA(
  id_detalle_venta PK,
  id_venta FK → VENTA,
  id_presentacion FK → PRESENTACION_PRODUCTO,
  cantidad DECIMAL(15,3) CHECK > 0,
  precio_unitario DECIMAL(15,2) CHECK >= 0
)
```

`DETALLE_VENTA.cantidad` representa presentaciones vendidas. `precio_unitario` conserva el precio histórico por presentación.

### DETALLE_VENTA_LOTE

```text
DETALLE_VENTA_LOTE(
  id_detalle_venta_lote PK,
  id_detalle_venta FK → DETALLE_VENTA,
  id_lote_ubicacion FK → LOTE_UBICACION,
  cantidad_base DECIMAL(15,3) CHECK > 0,
  UQ(id_detalle_venta, id_lote_ubicacion)
)
```

El trigger valida que ambos caminos lleguen al mismo `PRODUCTO`, impide lotes vencidos, verifica que la suma no supere `cantidad × factor_conversion` y descuenta inventario. Los registros son históricos e inmutables.

### PAGO

```text
PAGO(
  id_pago PK,
  id_venta FK → VENTA,
  metodo_pago CHECK(EFECTIVO, QR),
  monto DECIMAL(15,2) CHECK > 0,
  comprobante_qr
)
```

QR requiere comprobante. `sp_registrar_venta` exige igualdad exacta entre la suma de pagos y el total de la venta. Los pagos confirmados son históricos e inmutables.

### DENOMINACION, ARQUEO_CAJA y DETALLE_ARQUEO

```text
DENOMINACION(
  id_denominacion PK,
  valor DECIMAL(15,2) UQ CHECK > 0,
  tipo CHECK(BILLETE, MONEDA),
  estado CHECK(ACTIVO, INACTIVO)
)

ARQUEO_CAJA(
  id_arqueo PK,
  id_sesion_caja FK UQ → SESION_CAJA,
  fecha_hora,
  observacion
)

DETALLE_ARQUEO(
  id_detalle_arqueo PK,
  id_arqueo FK → ARQUEO_CAJA,
  id_denominacion FK → DENOMINACION,
  cantidad INT UNSIGNED,
  UQ(id_arqueo, id_denominacion)
)
```

El arqueo solo puede registrarse después de cerrar coherentemente la sesión.

## 4. Stock derivado

```text
stock_fisico = SUM(LOTE_UBICACION.cantidad_actual)

stock_disponible = SUM(cantidad_actual de lotes sin vencimiento
                       o con fecha_vencimiento > CURRENT_DATE)

stock_vencido = SUM(cantidad_actual de lotes
                    con fecha_vencimiento <= CURRENT_DATE)
```

El vencimiento no elimina el registro ni reduce automáticamente el stock físico.

## 5. FIFO y concurrencia

`sp_registrar_venta` procesa presentaciones en orden estable y selecciona lotes vendibles mediante:

```text
ORDER BY COMPRA.fecha_hora, LOTE_PRODUCTO.id_lote,
         LOTE_UBICACION.id_lote_ubicacion
FOR UPDATE
```

Cada asignación se registra en `DETALLE_VENTA_LOTE`. Si falta stock, un pago no cuadra o cualquier validación falla, se revierte venta, detalles, trazabilidad, pagos y existencias.

## 6. Anulación

`sp_anular_venta` bloquea la venta y cada existencia utilizada, devuelve exactamente `DETALLE_VENTA_LOTE.cantidad_base`, marca la venta como `ANULADA` y conserva detalles, asignaciones y pagos. El trigger impide anular directamente sin ejecutar este flujo.

## 7. Resumen físico V2

- 21 tablas persistentes.
- 23 claves foráneas.
- 14 vistas.
- 5 procedimientos operativos.
- 21 triggers.
- Cantidades en `DECIMAL(15,3)`.
- Dinero en `DECIMAL(15,2)`; nunca `FLOAT`.

El modelo permanece en 3FN; las rutinas agregan integridad transaccional sin duplicar hechos persistentes.
