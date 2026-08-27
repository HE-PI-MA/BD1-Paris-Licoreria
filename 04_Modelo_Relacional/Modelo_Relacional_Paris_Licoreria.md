# Modelo Relacional - París Licorería

## 1. Introducción

El presente modelo relacional se obtiene a partir del Modelo Entidad-Relación de París Licorería.

En esta etapa se transforman las entidades identificadas en relaciones o tablas, definiendo:

- Claves primarias.
- Claves foráneas.
- Tipos de datos.
- Campos obligatorios.
- Campos opcionales.
- Restricciones de unicidad.
- Relaciones entre tablas.

El modelo está compuesto por 21 tablas.

---

# 2. ROL

| Campo | Tipo | Restricciones |
|---|---|---|
| id_rol | INT | PK, AUTO_INCREMENT |
| nombre | VARCHAR(50) | NOT NULL, UNIQUE |
| descripcion | VARCHAR(150) | NULL |

**Clave primaria:** `id_rol`

**Relación:**

`ROL 1 : N USUARIO`

---

# 3. USUARIO

| Campo | Tipo | Restricciones |
|---|---|---|
| id_usuario | INT | PK, AUTO_INCREMENT |
| id_rol | INT | FK, NOT NULL |
| nombre | VARCHAR(80) | NOT NULL |
| apellido | VARCHAR(80) | NOT NULL |
| nombre_usuario | VARCHAR(50) | NOT NULL, UNIQUE |
| contrasena | VARCHAR(255) | NOT NULL |
| estado | VARCHAR(20) | NOT NULL |

**Clave primaria:** `id_usuario`

**Clave foránea:**

`id_rol → ROL(id_rol)`

La contraseña deberá almacenarse posteriormente mediante un hash seguro y no como texto plano.

---

# 4. CATEGORIA

| Campo | Tipo | Restricciones |
|---|---|---|
| id_categoria | INT | PK, AUTO_INCREMENT |
| nombre | VARCHAR(80) | NOT NULL, UNIQUE |
| descripcion | VARCHAR(150) | NULL |
| estado | VARCHAR(20) | NOT NULL |

**Clave primaria:** `id_categoria`

---

# 5. UNIDAD_MEDIDA

| Campo | Tipo | Restricciones |
|---|---|---|
| id_unidad_medida | INT | PK, AUTO_INCREMENT |
| nombre | VARCHAR(50) | NOT NULL, UNIQUE |
| abreviatura | VARCHAR(10) | NOT NULL |

**Clave primaria:** `id_unidad_medida`

Ejemplos:

- Unidad.
- Kilogramo.
- Gramo.

Las presentaciones comerciales como caja, paquete o fardo se manejarán mediante `PRESENTACION_PRODUCTO`.

---

# 6. PRODUCTO

| Campo | Tipo | Restricciones |
|---|---|---|
| id_producto | INT | PK, AUTO_INCREMENT |
| id_categoria | INT | FK, NOT NULL |
| id_unidad_medida | INT | FK, NOT NULL |
| nombre | VARCHAR(120) | NOT NULL |
| descripcion | VARCHAR(255) | NULL |
| stock_minimo | DECIMAL(12,3) | NOT NULL, DEFAULT 0 |
| estado | VARCHAR(20) | NOT NULL |

**Clave primaria:** `id_producto`

**Claves foráneas:**

`id_categoria → CATEGORIA(id_categoria)`

`id_unidad_medida → UNIDAD_MEDIDA(id_unidad_medida)`

## Stock actual

No se almacenará un campo `stock_actual` en PRODUCTO.

El stock disponible se obtendrá mediante la suma de:

`LOTE_UBICACION.cantidad_actual`

correspondiente a los lotes del producto.

---

# 7. PRESENTACION_PRODUCTO

| Campo | Tipo | Restricciones |
|---|---|---|
| id_presentacion | INT | PK, AUTO_INCREMENT |
| id_producto | INT | FK, NOT NULL |
| nombre_presentacion | VARCHAR(80) | NOT NULL |
| factor_conversion | DECIMAL(12,3) | NOT NULL |
| codigo_barras | VARCHAR(50) | NULL, UNIQUE |
| precio_venta | DECIMAL(12,2) | NOT NULL |
| estado | VARCHAR(20) | NOT NULL |

**Clave primaria:** `id_presentacion`

**Clave foránea:**

`id_producto → PRODUCTO(id_producto)`

## Factor de conversión

Permite convertir una presentación a la unidad base del producto.

Ejemplo:

```text
Unidad       = 1
Pack de 6    = 6
Caja de 24   = 24
Para productos por peso también podrán utilizarse valores decimales.

---

# 8. PROVEEDOR

| Campo | Tipo | Restricciones |
|---|---|---|
| id_proveedor | INT | PK, AUTO_INCREMENT |
| nombre | VARCHAR(120) | NOT NULL |
| contacto | VARCHAR(100) | NULL |
| telefono | VARCHAR(30) | NULL |
| direccion | VARCHAR(200) | NULL |
| estado | VARCHAR(20) | NOT NULL |

**Clave primaria:** `id_proveedor`

---

# 9. COMPRA

| Campo | Tipo | Restricciones |
|---|---|---|
| id_compra | INT | PK, AUTO_INCREMENT |
| id_proveedor | INT | FK, NOT NULL |
| id_usuario | INT | FK, NOT NULL |
| fecha_hora | DATETIME | NOT NULL |
| observacion | VARCHAR(250) | NULL |

**Clave primaria:** `id_compra`

**Claves foráneas:**

`id_proveedor → PROVEEDOR(id_proveedor)`

`id_usuario → USUARIO(id_usuario)`

## Total

El total de la compra podrá calcularse mediante:

`SUM(cantidad × costo_unitario)`

de sus registros en `DETALLE_COMPRA`.

---

# 10. DETALLE_COMPRA

| Campo | Tipo | Restricciones |
|---|---|---|
| id_detalle_compra | INT | PK, AUTO_INCREMENT |
| id_compra | INT | FK, NOT NULL |
| id_presentacion | INT | FK, NOT NULL |
| cantidad | DECIMAL(12,3) | NOT NULL |
| costo_unitario | DECIMAL(12,2) | NOT NULL |

**Clave primaria:** `id_detalle_compra`

**Claves foráneas:**

`id_compra → COMPRA(id_compra)`

`id_presentacion → PRESENTACION_PRODUCTO(id_presentacion)`

El subtotal puede calcularse mediante:

`cantidad × costo_unitario`

---

# 11. LOTE_PRODUCTO

| Campo | Tipo | Restricciones |
|---|---|---|
| id_lote | INT | PK, AUTO_INCREMENT |
| id_detalle_compra | INT | FK, NOT NULL |
| codigo_lote | VARCHAR(80) | NULL |
| fecha_vencimiento | DATE | NULL |
| cantidad_inicial | DECIMAL(12,3) | NOT NULL |

**Clave primaria:** `id_lote`

**Clave foránea:**

`id_detalle_compra → DETALLE_COMPRA(id_detalle_compra)`

`fecha_vencimiento` podrá ser NULL cuando el producto no tenga vencimiento.

La cantidad inicial deberá expresarse en la unidad base del producto.

---

# 12. UBICACION

| Campo | Tipo | Restricciones |
|---|---|---|
| id_ubicacion | INT | PK, AUTO_INCREMENT |
| nombre | VARCHAR(80) | NOT NULL, UNIQUE |
| descripcion | VARCHAR(150) | NULL |
| estado | VARCHAR(20) | NOT NULL |

**Clave primaria:** `id_ubicacion`

Ejemplos:

- Refrigerador.
- Estante.
- Vitrina.
- Almacén.

---

# 13. LOTE_UBICACION

| Campo | Tipo | Restricciones |
|---|---|---|
| id_lote_ubicacion | INT | PK, AUTO_INCREMENT |
| id_lote | INT | FK, NOT NULL |
| id_ubicacion | INT | FK, NOT NULL |
| cantidad_actual | DECIMAL(12,3) | NOT NULL |

**Clave primaria:** `id_lote_ubicacion`

**Claves foráneas:**

`id_lote → LOTE_PRODUCTO(id_lote)`

`id_ubicacion → UBICACION(id_ubicacion)`

**Restricción UNIQUE:**

`(id_lote, id_ubicacion)`

Esta tabla será la fuente principal para determinar el stock disponible.

---

# 14. AJUSTE_INVENTARIO

| Campo | Tipo | Restricciones |
|---|---|---|
| id_ajuste | INT | PK, AUTO_INCREMENT |
| id_lote_ubicacion | INT | FK, NOT NULL |
| id_usuario | INT | FK, NOT NULL |
| fecha_hora | DATETIME | NOT NULL |
| tipo_ajuste | VARCHAR(30) | NOT NULL |
| cantidad | DECIMAL(12,3) | NOT NULL |
| observacion | VARCHAR(250) | NULL |

**Clave primaria:** `id_ajuste`

**Claves foráneas:**

`id_lote_ubicacion → LOTE_UBICACION(id_lote_ubicacion)`

`id_usuario → USUARIO(id_usuario)`

Ejemplos de tipo:

- DAÑADO.
- PERDIDO.
- VENCIDO.
- OTRO.

---

# 15. SESION_CAJA

| Campo | Tipo | Restricciones |
|---|---|---|
| id_sesion_caja | INT | PK, AUTO_INCREMENT |
| id_usuario | INT | FK, NOT NULL |
| fecha_hora_apertura | DATETIME | NOT NULL |
| monto_inicial | DECIMAL(12,2) | NOT NULL |
| fecha_hora_cierre | DATETIME | NULL |
| estado | VARCHAR(20) | NOT NULL |
| observacion | VARCHAR(250) | NULL |

**Clave primaria:** `id_sesion_caja`

**Clave foránea:**

`id_usuario → USUARIO(id_usuario)`

---

# 16. VENTA

| Campo | Tipo | Restricciones |
|---|---|---|
| id_venta | INT | PK, AUTO_INCREMENT |
| id_sesion_caja | INT | FK, NOT NULL |
| fecha_hora | DATETIME | NOT NULL |
| estado | VARCHAR(20) | NOT NULL |
| motivo_anulacion | VARCHAR(250) | NULL |

**Clave primaria:** `id_venta`

**Clave foránea:**

`id_sesion_caja → SESION_CAJA(id_sesion_caja)`

---

# 17. DETALLE_VENTA

| Campo | Tipo | Restricciones |
|---|---|---|
| id_detalle_venta | INT | PK, AUTO_INCREMENT |
| id_venta | INT | FK, NOT NULL |
| id_presentacion | INT | FK, NOT NULL |
| cantidad | DECIMAL(12,3) | NOT NULL |
| precio_unitario | DECIMAL(12,2) | NOT NULL |

**Clave primaria:** `id_detalle_venta`

**Claves foráneas:**

`id_venta → VENTA(id_venta)`

`id_presentacion → PRESENTACION_PRODUCTO(id_presentacion)`

---

# 18. DETALLE_VENTA_LOTE

| Campo | Tipo | Restricciones |
|---|---|---|
| id_detalle_venta_lote | INT | PK, AUTO_INCREMENT |
| id_detalle_venta | INT | FK, NOT NULL |
| id_lote_ubicacion | INT | FK, NOT NULL |
| cantidad_base | DECIMAL(12,3) | NOT NULL |

**Clave primaria:** `id_detalle_venta_lote`

**Claves foráneas:**

`id_detalle_venta → DETALLE_VENTA(id_detalle_venta)`

`id_lote_ubicacion → LOTE_UBICACION(id_lote_ubicacion)`

**Restricción UNIQUE recomendada:**

`(id_detalle_venta, id_lote_ubicacion)`

---

# 19. PAGO

| Campo | Tipo | Restricciones |
|---|---|---|
| id_pago | INT | PK, AUTO_INCREMENT |
| id_venta | INT | FK, NOT NULL |
| metodo_pago | VARCHAR(20) | NOT NULL |
| monto | DECIMAL(12,2) | NOT NULL |
| comprobante_qr | VARCHAR(255) | NULL |

**Clave primaria:** `id_pago`

**Clave foránea:**

`id_venta → VENTA(id_venta)`

Métodos iniciales:

- EFECTIVO.
- QR.

---

# 20. DENOMINACION

| Campo | Tipo | Restricciones |
|---|---|---|
| id_denominacion | INT | PK, AUTO_INCREMENT |
| valor | DECIMAL(12,2) | NOT NULL, UNIQUE |
| tipo | VARCHAR(20) | NOT NULL |
| estado | VARCHAR(20) | NOT NULL |

**Clave primaria:** `id_denominacion`

---

# 21. ARQUEO_CAJA

| Campo | Tipo | Restricciones |
|---|---|---|
| id_arqueo | INT | PK, AUTO_INCREMENT |
| id_sesion_caja | INT | FK, NOT NULL, UNIQUE |
| fecha_hora | DATETIME | NOT NULL |
| observacion | VARCHAR(250) | NULL |

**Clave primaria:** `id_arqueo`

**Clave foránea:**

`id_sesion_caja → SESION_CAJA(id_sesion_caja)`

---

# 22. DETALLE_ARQUEO

| Campo | Tipo | Restricciones |
|---|---|---|
| id_detalle_arqueo | INT | PK, AUTO_INCREMENT |
| id_arqueo | INT | FK, NOT NULL |
| id_denominacion | INT | FK, NOT NULL |
| cantidad | INT | NOT NULL |

**Clave primaria:** `id_detalle_arqueo`

**Claves foráneas:**

`id_arqueo → ARQUEO_CAJA(id_arqueo)`

`id_denominacion → DENOMINACION(id_denominacion)`

**Restricción UNIQUE:**

`(id_arqueo, id_denominacion)`

---

# 23. Resumen de claves foráneas

| Tabla | FK | Referencia |
|---|---|---|
| USUARIO | id_rol | ROL |
| PRODUCTO | id_categoria | CATEGORIA |
| PRODUCTO | id_unidad_medida | UNIDAD_MEDIDA |
| PRESENTACION_PRODUCTO | id_producto | PRODUCTO |
| COMPRA | id_proveedor | PROVEEDOR |
| COMPRA | id_usuario | USUARIO |
| DETALLE_COMPRA | id_compra | COMPRA |
| DETALLE_COMPRA | id_presentacion | PRESENTACION_PRODUCTO |
| LOTE_PRODUCTO | id_detalle_compra | DETALLE_COMPRA |
| LOTE_UBICACION | id_lote | LOTE_PRODUCTO |
| LOTE_UBICACION | id_ubicacion | UBICACION |
| AJUSTE_INVENTARIO | id_lote_ubicacion | LOTE_UBICACION |
| AJUSTE_INVENTARIO | id_usuario | USUARIO |
| SESION_CAJA | id_usuario | USUARIO |
| VENTA | id_sesion_caja | SESION_CAJA |
| DETALLE_VENTA | id_venta | VENTA |
| DETALLE_VENTA | id_presentacion | PRESENTACION_PRODUCTO |
| DETALLE_VENTA_LOTE | id_detalle_venta | DETALLE_VENTA |
| DETALLE_VENTA_LOTE | id_lote_ubicacion | LOTE_UBICACION |
| PAGO | id_venta | VENTA |
| ARQUEO_CAJA | id_sesion_caja | SESION_CAJA |
| DETALLE_ARQUEO | id_arqueo | ARQUEO_CAJA |
| DETALLE_ARQUEO | id_denominacion | DENOMINACION |

---

# 24. Restricciones de unicidad importantes

- `ROL.nombre` → UNIQUE
- `USUARIO.nombre_usuario` → UNIQUE
- `CATEGORIA.nombre` → UNIQUE
- `UNIDAD_MEDIDA.nombre` → UNIQUE
- `PRESENTACION_PRODUCTO.codigo_barras` → UNIQUE cuando exista
- `UBICACION.nombre` → UNIQUE
- `(id_lote, id_ubicacion)` → UNIQUE
- `(id_detalle_venta, id_lote_ubicacion)` → UNIQUE
- `DENOMINACION.valor` → UNIQUE
- `ARQUEO_CAJA.id_sesion_caja` → UNIQUE
- `(id_arqueo, id_denominacion)` → UNIQUE

---

# 25. Valores calculados

## Stock actual de producto

`SUM(LOTE_UBICACION.cantidad_actual)`

## Subtotal de compra

`cantidad × costo_unitario`

## Total de compra

`SUM(subtotales de DETALLE_COMPRA)`

## Subtotal de venta

`cantidad × precio_unitario`

## Total de venta

`SUM(subtotales de DETALLE_VENTA)`

## Subtotal del arqueo

`DENOMINACION.valor × DETALLE_ARQUEO.cantidad`

## Efectivo contado

`SUM(subtotales de DETALLE_ARQUEO)`

## Diferencia de caja

`efectivo_contado - efectivo_esperado`

---

# 26. Tablas del modelo

1. ROL
2. USUARIO
3. CATEGORIA
4. UNIDAD_MEDIDA
5. PRODUCTO
6. PRESENTACION_PRODUCTO
7. PROVEEDOR
8. COMPRA
9. DETALLE_COMPRA
10. LOTE_PRODUCTO
11. UBICACION
12. LOTE_UBICACION
13. AJUSTE_INVENTARIO
14. SESION_CAJA
15. VENTA
16. DETALLE_VENTA
17. DETALLE_VENTA_LOTE
18. PAGO
19. DENOMINACION
20. ARQUEO_CAJA
21. DETALLE_ARQUEO

---

# 27. Conclusión

El modelo relacional transforma las entidades identificadas durante el análisis en 21 relaciones estructuradas mediante claves primarias y claves foráneas.

La separación entre productos, presentaciones, compras, lotes, ubicaciones, ventas, pagos y caja permite reducir redundancias y mantener la trazabilidad de las principales operaciones de París Licorería.

La siguiente etapa será verificar formalmente el cumplimiento de Primera, Segunda y Tercera Forma Normal antes de generar los scripts SQL.