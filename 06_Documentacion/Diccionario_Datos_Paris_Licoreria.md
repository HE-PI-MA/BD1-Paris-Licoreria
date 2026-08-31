# Diccionario de Datos V2 — París Licorería

## 1. Convenciones

- Motor: MySQL Community Server 8.0.44.
- Esquema: `paris_licoreria`.
- Codificación: `utf8mb4`.
- Identificadores: `INT UNSIGNED AUTO_INCREMENT`.
- Cantidades físicas: `DECIMAL(15,3)`.
- Importes monetarios: `DECIMAL(15,2)`.
- Estados maestros: `ACTIVO` o `INACTIVO`.
- Las claves foráneas usan `ON UPDATE CASCADE` y `ON DELETE RESTRICT`.

## 2. Unidad base

La unidad indicada por `PRODUCTO.id_unidad_medida` es la unidad base. `PRESENTACION_PRODUCTO.factor_conversion` convierte una presentación a esa unidad.

```text
cantidad_base = ROUND(cantidad_presentaciones × factor_conversion, 3)
```

## 3. Tablas maestras

### ROL

| Campo | Tipo | Restricciones | Descripción |
|---|---|---|---|
| id_rol | INT UNSIGNED | PK, AI | Identificador |
| nombre | VARCHAR(50) | NOT NULL, UNIQUE | Nombre del rol |
| descripcion | VARCHAR(150) | NULL | Descripción |

### USUARIO

| Campo | Tipo | Restricciones | Descripción |
|---|---|---|---|
| id_usuario | INT UNSIGNED | PK, AI | Identificador |
| id_rol | INT UNSIGNED | FK, NOT NULL | Rol |
| nombre | VARCHAR(80) | NOT NULL | Nombre |
| apellido | VARCHAR(80) | NOT NULL | Apellido |
| nombre_usuario | VARCHAR(50) | NOT NULL, UNIQUE | Credencial pública |
| contrasena | VARCHAR(255) | NOT NULL | Hash producido por la aplicación |
| estado | VARCHAR(20) | CHECK | `ACTIVO`, `INACTIVO` |

### CATEGORIA

| Campo | Tipo | Restricciones | Descripción |
|---|---|---|---|
| id_categoria | INT UNSIGNED | PK, AI | Identificador |
| nombre | VARCHAR(80) | NOT NULL, UNIQUE | Nombre |
| descripcion | VARCHAR(150) | NULL | Descripción |
| estado | VARCHAR(20) | CHECK | `ACTIVO`, `INACTIVO` |

### UNIDAD_MEDIDA

| Campo | Tipo | Restricciones | Descripción |
|---|---|---|---|
| id_unidad_medida | INT UNSIGNED | PK, AI | Identificador |
| nombre | VARCHAR(50) | NOT NULL, UNIQUE | Unidad base |
| abreviatura | VARCHAR(10) | NOT NULL, UNIQUE | Símbolo |

Datos iniciales: unidad, kilogramo, gramo y mililitro. Un producto por peso debe elegir gramo como base si se desea controlar el stock en gramos.

### PRODUCTO

| Campo | Tipo | Restricciones | Descripción |
|---|---|---|---|
| id_producto | INT UNSIGNED | PK, AI | Identificador |
| id_categoria | INT UNSIGNED | FK, NOT NULL | Categoría |
| id_unidad_medida | INT UNSIGNED | FK, NOT NULL | Unidad base |
| nombre | VARCHAR(120) | NOT NULL | Producto |
| descripcion | VARCHAR(255) | NULL | Descripción |
| stock_minimo | DECIMAL(15,3) | CHECK >= 0 | Umbral en unidad base |
| estado | VARCHAR(20) | CHECK | `ACTIVO`, `INACTIVO` |

### PRESENTACION_PRODUCTO

| Campo | Tipo | Restricciones | Descripción |
|---|---|---|---|
| id_presentacion | INT UNSIGNED | PK, AI | Identificador |
| id_producto | INT UNSIGNED | FK, NOT NULL | Producto |
| nombre_presentacion | VARCHAR(80) | NOT NULL | Unidad comercial |
| factor_conversion | DECIMAL(15,3) | CHECK > 0 | Unidades base por presentación |
| codigo_barras | VARCHAR(50) | NULL, UNIQUE | EAN, UPC o código interno |
| precio_venta | DECIMAL(15,2) | CHECK >= 0 | Precio por presentación |
| estado | VARCHAR(20) | CHECK | `ACTIVO`, `INACTIVO` |

`UNIQUE(id_producto, nombre_presentacion)` evita duplicar nombres dentro del producto. El código es texto para conservar ceros iniciales.

### PROVEEDOR

| Campo | Tipo | Restricciones | Descripción |
|---|---|---|---|
| id_proveedor | INT UNSIGNED | PK, AI | Identificador |
| nombre | VARCHAR(120) | NOT NULL | Razón comercial |
| contacto | VARCHAR(100) | NULL | Persona de contacto |
| telefono | VARCHAR(30) | NULL | Teléfono |
| direccion | VARCHAR(200) | NULL | Dirección |
| estado | VARCHAR(20) | CHECK | `ACTIVO`, `INACTIVO` |

### UBICACION

| Campo | Tipo | Restricciones | Descripción |
|---|---|---|---|
| id_ubicacion | INT UNSIGNED | PK, AI | Identificador |
| nombre | VARCHAR(80) | NOT NULL, UNIQUE | Lugar físico |
| descripcion | VARCHAR(150) | NULL | Descripción |
| estado | VARCHAR(20) | CHECK | `ACTIVO`, `INACTIVO` |

### DENOMINACION

| Campo | Tipo | Restricciones | Descripción |
|---|---|---|---|
| id_denominacion | INT UNSIGNED | PK, AI | Identificador |
| valor | DECIMAL(15,2) | UNIQUE, CHECK > 0 | Valor en bolivianos |
| tipo | VARCHAR(20) | CHECK | `BILLETE`, `MONEDA` |
| estado | VARCHAR(20) | CHECK | `ACTIVO`, `INACTIVO` |

## 4. Compras e inventario

### COMPRA

| Campo | Tipo | Restricciones | Descripción |
|---|---|---|---|
| id_compra | INT UNSIGNED | PK, AI | Compra |
| id_proveedor | INT UNSIGNED | FK, NOT NULL | Proveedor |
| id_usuario | INT UNSIGNED | FK, NOT NULL | Responsable |
| fecha_hora | DATETIME | NOT NULL | Fecha de ingreso usada por FIFO |
| observacion | VARCHAR(250) | NULL | Nota |

### DETALLE_COMPRA

| Campo | Tipo | Restricciones | Descripción |
|---|---|---|---|
| id_detalle_compra | INT UNSIGNED | PK, AI | Detalle |
| id_compra | INT UNSIGNED | FK, NOT NULL | Compra |
| id_presentacion | INT UNSIGNED | FK, NOT NULL | Presentación adquirida |
| cantidad | DECIMAL(15,3) | CHECK > 0 | Presentaciones compradas |
| costo_unitario | DECIMAL(15,2) | CHECK >= 0 | Costo por presentación |

### LOTE_PRODUCTO

| Campo | Tipo | Restricciones | Descripción |
|---|---|---|---|
| id_lote | INT UNSIGNED | PK, AI | Lote |
| id_detalle_compra | INT UNSIGNED | FK, NOT NULL | Origen |
| codigo_lote | VARCHAR(80) | NULL | Código físico opcional |
| fecha_vencimiento | DATE | NULL | Fecha límite |
| cantidad_inicial | DECIMAL(15,3) | CHECK > 0 | Cantidad recibida en unidad base |

La suma de lotes de un detalle no puede superar `cantidad × factor_conversion`.

### LOTE_UBICACION

| Campo | Tipo | Restricciones | Descripción |
|---|---|---|---|
| id_lote_ubicacion | INT UNSIGNED | PK, AI | Existencia |
| id_lote | INT UNSIGNED | FK, NOT NULL | Lote |
| id_ubicacion | INT UNSIGNED | FK, NOT NULL | Ubicación |
| cantidad_actual | DECIMAL(15,3) | CHECK >= 0 | Stock físico en unidad base |

`UNIQUE(id_lote, id_ubicacion)`. Las ventas y ajustes disminuyen este campo mediante triggers. La anulación lo incrementa hasta el máximo físico del lote.

### AJUSTE_INVENTARIO

| Campo | Tipo | Restricciones | Descripción |
|---|---|---|---|
| id_ajuste | INT UNSIGNED | PK, AI | Ajuste |
| id_lote_ubicacion | INT UNSIGNED | FK, NOT NULL | Existencia afectada |
| id_usuario | INT UNSIGNED | FK, NOT NULL | Responsable |
| fecha_hora | DATETIME | NOT NULL | Fecha |
| tipo_ajuste | VARCHAR(30) | CHECK | `DAÑADO`, `PERDIDO`, `VENCIDO`, `OTRO` |
| cantidad | DECIMAL(15,3) | CHECK > 0 | Retiro en unidad base |
| observacion | VARCHAR(250) | NULL | Justificación |

## 5. Ventas y pagos

### SESION_CAJA

| Campo | Tipo | Restricciones | Descripción |
|---|---|---|---|
| id_sesion_caja | INT UNSIGNED | PK, AI | Sesión |
| id_usuario | INT UNSIGNED | FK, NOT NULL | Responsable |
| fecha_hora_apertura | DATETIME | NOT NULL | Apertura |
| monto_inicial | DECIMAL(15,2) | CHECK >= 0 | Efectivo inicial |
| fecha_hora_cierre | DATETIME | NULL | Cierre |
| estado | VARCHAR(20) | CHECK | `ABIERTA`, `CERRADA` |
| observacion | VARCHAR(250) | NULL | Nota |

Una sesión abierta no tiene fecha de cierre. Una cerrada debe tener una fecha igual o posterior a la apertura.

### VENTA

| Campo | Tipo | Restricciones | Descripción |
|---|---|---|---|
| id_venta | INT UNSIGNED | PK, AI | Venta |
| id_sesion_caja | INT UNSIGNED | FK, NOT NULL | Caja |
| fecha_hora | DATETIME | NOT NULL | Fecha |
| estado | VARCHAR(20) | CHECK | `VIGENTE`, `ANULADA` |
| motivo_anulacion | VARCHAR(250) | Condicional | Obligatorio al anular |

### DETALLE_VENTA

| Campo | Tipo | Restricciones | Descripción |
|---|---|---|---|
| id_detalle_venta | INT UNSIGNED | PK, AI | Detalle |
| id_venta | INT UNSIGNED | FK, NOT NULL | Venta |
| id_presentacion | INT UNSIGNED | FK, NOT NULL | Presentación |
| cantidad | DECIMAL(15,3) | CHECK > 0 | Presentaciones vendidas |
| precio_unitario | DECIMAL(15,2) | CHECK >= 0 | Precio histórico por presentación |

### DETALLE_VENTA_LOTE

| Campo | Tipo | Restricciones | Descripción |
|---|---|---|---|
| id_detalle_venta_lote | INT UNSIGNED | PK, AI | Movimiento FIFO |
| id_detalle_venta | INT UNSIGNED | FK, NOT NULL | Detalle |
| id_lote_ubicacion | INT UNSIGNED | FK, NOT NULL | Origen físico |
| cantidad_base | DECIMAL(15,3) | CHECK > 0 | Cantidad descontada en unidad base |

`UNIQUE(id_detalle_venta, id_lote_ubicacion)`. Es histórico e inmutable. Se valida correspondencia del producto, vigencia del lote, caja abierta y límite convertido.

### PAGO

| Campo | Tipo | Restricciones | Descripción |
|---|---|---|---|
| id_pago | INT UNSIGNED | PK, AI | Pago |
| id_venta | INT UNSIGNED | FK, NOT NULL | Venta |
| metodo_pago | VARCHAR(20) | CHECK | `EFECTIVO`, `QR` |
| monto | DECIMAL(15,2) | CHECK > 0 | Importe |
| comprobante_qr | VARCHAR(255) | Condicional | Obligatorio para QR |

Los pagos se conservan al anular. Las vistas de caja cuentan únicamente efectivo de ventas vigentes.

## 6. Arqueo

### ARQUEO_CAJA

| Campo | Tipo | Restricciones | Descripción |
|---|---|---|---|
| id_arqueo | INT UNSIGNED | PK, AI | Arqueo |
| id_sesion_caja | INT UNSIGNED | FK, UNIQUE | Un arqueo por sesión |
| fecha_hora | DATETIME | NOT NULL | Fecha coherente con cierre |
| observacion | VARCHAR(250) | NULL | Explicación, obligatoria si hay diferencia al usar el procedimiento |

### DETALLE_ARQUEO

| Campo | Tipo | Restricciones | Descripción |
|---|---|---|---|
| id_detalle_arqueo | INT UNSIGNED | PK, AI | Detalle |
| id_arqueo | INT UNSIGNED | FK, NOT NULL | Arqueo |
| id_denominacion | INT UNSIGNED | FK, NOT NULL | Denominación |
| cantidad | INT UNSIGNED | CHECK >= 0 | Billetes o monedas |

`UNIQUE(id_arqueo, id_denominacion)`.

## 7. Vistas V2

La implementación contiene 14 vistas:

1. `vw_stock_lote_ubicacion`: detalle físico con estado de vencimiento.
2. `vw_stock_producto`: físico, disponible, vencido y estado de reposición.
3. `vw_stock_fisico_producto`.
4. `vw_stock_disponible_producto`.
5. `vw_stock_vencido_producto`.
6. `vw_productos_stock_bajo`.
7. `vw_lotes_proximos_vencer`: próximos 30 días, sin incluir vencidos.
8. `vw_compras_totales`.
9. `vw_ventas_totales`.
10. `vw_pagos_venta`.
11. `vw_productos_mas_vendidos`: cantidades comerciales y base.
12. `vw_efectivo_esperado_sesion`.
13. `vw_efectivo_contado_arqueo`.
14. `vw_diferencias_caja`.

## 8. Procedimientos operativos

| Procedimiento | Responsabilidad |
|---|---|
| `sp_registrar_compra` | Compra, conversión, lote y ubicación atómicos |
| `sp_registrar_venta` | Venta, FIFO, bloqueos y pagos atómicos |
| `sp_anular_venta` | Devolución exacta y conservación histórica |
| `sp_registrar_ajuste_inventario` | Merma segura sin stock negativo |
| `sp_cerrar_sesion_caja` | Cierre y arqueo atómicos |

## 9. Triggers

Los 21 triggers se agrupan en:

- Inmutabilidad de unidad base y factores ya utilizados.
- Límites entre compra, lotes y ubicaciones.
- Validación de caja abierta al vender.
- Correspondencia producto-lote, vencimiento y descuento de stock.
- Límite e inmutabilidad de pagos.
- Validación, descuento e inmutabilidad de ajustes.
- Coherencia del arqueo con una sesión cerrada.

## 10. Stock

```text
stock_fisico = toda cantidad_actual
stock_disponible = cantidad_actual de lotes no vencidos
stock_vencido = cantidad_actual de lotes con fecha <= hoy
```

La fecha de vencimiento alcanzada deja el lote fuera de venta, pero no lo borra ni lo retira físicamente.
