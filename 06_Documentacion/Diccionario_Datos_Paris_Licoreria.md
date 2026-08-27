# Diccionario de Datos - París Licorería

## 1. Introducción

El presente diccionario de datos documenta la estructura física de la base de datos `paris_licoreria`.

La base de datos fue diseñada a partir del análisis de los procesos del negocio, el Modelo Entidad-Relación, el Modelo Relacional y el proceso de normalización hasta Tercera Forma Normal (3FN).

El sistema está compuesto por 21 tablas principales destinadas a controlar:

- Usuarios y roles.
- Productos y categorías.
- Unidades de medida.
- Presentaciones comerciales.
- Proveedores.
- Compras.
- Lotes.
- Ubicaciones.
- Inventario.
- Ajustes.
- Ventas.
- Pagos.
- Sesiones de caja.
- Arqueos.
- Denominaciones monetarias.
- Trazabilidad FIFO.

---

# 2. Tabla ROL

Almacena los roles disponibles para los usuarios del sistema.

| Campo | Tipo | Restricciones | Descripción |
|---|---|---|---|
| id_rol | INT | PK, AUTO_INCREMENT | Identificador único del rol |
| nombre | VARCHAR(50) | NOT NULL, UNIQUE | Nombre del rol |
| descripcion | VARCHAR(150) | NULL | Descripción del rol |

Ejemplos:

- ADMINISTRADOR
- ENCARGADO_VENTA

---

# 3. Tabla USUARIO

Almacena las personas que tendrán acceso al sistema.

| Campo | Tipo | Restricciones | Descripción |
|---|---|---|---|
| id_usuario | INT | PK, AUTO_INCREMENT | Identificador único del usuario |
| id_rol | INT | FK, NOT NULL | Rol asignado al usuario |
| nombre | VARCHAR(80) | NOT NULL | Nombre del usuario |
| apellido | VARCHAR(80) | NOT NULL | Apellido del usuario |
| nombre_usuario | VARCHAR(50) | NOT NULL, UNIQUE | Nombre utilizado para iniciar sesión |
| contrasena | VARCHAR(255) | NOT NULL | Contraseña almacenada mediante hash |
| estado | VARCHAR(20) | NOT NULL | Estado del usuario |

### Clave foránea

`id_rol → ROL(id_rol)`

---

# 4. Tabla CATEGORIA

Permite clasificar los productos comercializados.

| Campo | Tipo | Restricciones | Descripción |
|---|---|---|---|
| id_categoria | INT | PK, AUTO_INCREMENT | Identificador de la categoría |
| nombre | VARCHAR(80) | NOT NULL, UNIQUE | Nombre de la categoría |
| descripcion | VARCHAR(150) | NULL | Descripción |
| estado | VARCHAR(20) | NOT NULL | Estado de la categoría |

Ejemplos:

- Bebidas alcohólicas
- Gaseosas
- Dulces
- Galletas
- Limpieza
- Otros

---

# 5. Tabla UNIDAD_MEDIDA

Almacena las unidades base utilizadas para controlar las existencias de los productos.

| Campo | Tipo | Restricciones | Descripción |
|---|---|---|---|
| id_unidad_medida | INT | PK, AUTO_INCREMENT | Identificador de la unidad |
| nombre | VARCHAR(50) | NOT NULL, UNIQUE | Nombre |
| abreviatura | VARCHAR(10) | NOT NULL | Abreviatura |

Ejemplos:

- Unidad → und
- Kilogramo → kg
- Gramo → g

---

# 6. Tabla PRODUCTO

Almacena la información general de cada producto.

| Campo | Tipo | Restricciones | Descripción |
|---|---|---|---|
| id_producto | INT | PK, AUTO_INCREMENT | Identificador del producto |
| id_categoria | INT | FK, NOT NULL | Categoría del producto |
| id_unidad_medida | INT | FK, NOT NULL | Unidad base |
| nombre | VARCHAR(120) | NOT NULL | Nombre del producto |
| descripcion | VARCHAR(255) | NULL | Descripción |
| stock_minimo | DECIMAL(12,3) | NOT NULL, DEFAULT 0, CHECK >= 0 | Cantidad mínima deseada |
| estado | VARCHAR(20) | NOT NULL | Estado |

### Claves foráneas

`id_categoria → CATEGORIA(id_categoria)`

`id_unidad_medida → UNIDAD_MEDIDA(id_unidad_medida)`

### Stock actual

No existe un campo `stock_actual` dentro de PRODUCTO.

El stock disponible se obtiene mediante:

`SUM(LOTE_UBICACION.cantidad_actual)`

---

# 7. Tabla PRESENTACION_PRODUCTO

Almacena las distintas formas comerciales en las que puede venderse un producto.

| Campo | Tipo | Restricciones | Descripción |
|---|---|---|---|
| id_presentacion | INT | PK, AUTO_INCREMENT | Identificador de presentación |
| id_producto | INT | FK, NOT NULL | Producto |
| nombre_presentacion | VARCHAR(80) | NOT NULL | Nombre de presentación |
| factor_conversion | DECIMAL(12,3) | NOT NULL, CHECK > 0 | Conversión hacia unidad base |
| codigo_barras | VARCHAR(50) | NULL, UNIQUE | Código de barras |
| precio_venta | DECIMAL(12,2) | NOT NULL, CHECK >= 0 | Precio actual |
| estado | VARCHAR(20) | NOT NULL | Estado |

### Clave foránea

`id_producto → PRODUCTO(id_producto)`

### Ejemplo de conversión

```text
Unidad       = 1
Pack de 6    = 6
Caja de 24   = 24
```

---

# 8. Tabla PROVEEDOR

Almacena los proveedores del negocio.

| Campo | Tipo | Restricciones | Descripción |
|---|---|---|---|
| id_proveedor | INT | PK, AUTO_INCREMENT | Identificador único del proveedor |
| nombre | VARCHAR(120) | NOT NULL | Nombre o razón comercial |
| contacto | VARCHAR(100) | NULL | Persona de contacto |
| telefono | VARCHAR(30) | NULL | Número telefónico |
| direccion | VARCHAR(200) | NULL | Dirección |
| estado | VARCHAR(20) | NOT NULL | Estado del proveedor |

---

# 9. Tabla COMPRA

Registra las compras realizadas a los proveedores.

| Campo | Tipo | Restricciones | Descripción |
|---|---|---|---|
| id_compra | INT | PK, AUTO_INCREMENT | Identificador de la compra |
| id_proveedor | INT | FK, NOT NULL | Proveedor de la compra |
| id_usuario | INT | FK, NOT NULL | Usuario que registra la compra |
| fecha_hora | DATETIME | NOT NULL | Fecha y hora de la compra |
| observacion | VARCHAR(250) | NULL | Información adicional |

### Claves foráneas

`id_proveedor → PROVEEDOR(id_proveedor)`

`id_usuario → USUARIO(id_usuario)`

El total de una compra no se almacena de forma redundante. Se calcula a partir de sus detalles.

---

# 10. Tabla DETALLE_COMPRA

Registra las presentaciones adquiridas en una compra.

| Campo | Tipo | Restricciones | Descripción |
|---|---|---|---|
| id_detalle_compra | INT | PK, AUTO_INCREMENT | Identificador |
| id_compra | INT | FK, NOT NULL | Compra asociada |
| id_presentacion | INT | FK, NOT NULL | Presentación comprada |
| cantidad | DECIMAL(12,3) | NOT NULL, CHECK > 0 | Cantidad comprada |
| costo_unitario | DECIMAL(12,2) | NOT NULL, CHECK >= 0 | Costo por unidad de presentación |

### Claves foráneas

`id_compra → COMPRA(id_compra)`

`id_presentacion → PRESENTACION_PRODUCTO(id_presentacion)`

### Subtotal

`cantidad × costo_unitario`

---

# 11. Tabla LOTE_PRODUCTO

Permite identificar los diferentes lotes ingresados mediante las compras.

| Campo | Tipo | Restricciones | Descripción |
|---|---|---|---|
| id_lote | INT | PK, AUTO_INCREMENT | Identificador del lote |
| id_detalle_compra | INT | FK, NOT NULL | Detalle de compra que originó el lote |
| codigo_lote | VARCHAR(80) | NULL | Código identificador del lote |
| fecha_vencimiento | DATE | NULL | Fecha de vencimiento |
| cantidad_inicial | DECIMAL(12,3) | NOT NULL, CHECK > 0 | Cantidad inicial expresada en unidad base |

### Clave foránea

`id_detalle_compra → DETALLE_COMPRA(id_detalle_compra)`

La fecha de vencimiento puede ser `NULL` cuando el producto no posee vencimiento.

---

# 12. Tabla UBICACION

Almacena los lugares físicos en los que puede encontrarse la mercadería.

| Campo | Tipo | Restricciones | Descripción |
|---|---|---|---|
| id_ubicacion | INT | PK, AUTO_INCREMENT | Identificador |
| nombre | VARCHAR(80) | NOT NULL, UNIQUE | Nombre de la ubicación |
| descripcion | VARCHAR(150) | NULL | Descripción |
| estado | VARCHAR(20) | NOT NULL | Estado |

Ejemplos:

- Almacén.
- Estante.
- Refrigerador.
- Vitrina.

---

# 13. Tabla LOTE_UBICACION

Almacena la cantidad actual de cada lote en cada ubicación.

| Campo | Tipo | Restricciones | Descripción |
|---|---|---|---|
| id_lote_ubicacion | INT | PK, AUTO_INCREMENT | Identificador |
| id_lote | INT | FK, NOT NULL | Lote |
| id_ubicacion | INT | FK, NOT NULL | Ubicación |
| cantidad_actual | DECIMAL(12,3) | NOT NULL, CHECK >= 0 | Existencia actual |

### Claves foráneas

`id_lote → LOTE_PRODUCTO(id_lote)`

`id_ubicacion → UBICACION(id_ubicacion)`

### Restricción de unicidad

`UNIQUE(id_lote, id_ubicacion)`

Esta tabla constituye la fuente principal para determinar el stock disponible.

---

# 14. Tabla AJUSTE_INVENTARIO

Registra salidas o modificaciones de inventario que no corresponden a una venta.

| Campo | Tipo | Restricciones | Descripción |
|---|---|---|---|
| id_ajuste | INT | PK, AUTO_INCREMENT | Identificador |
| id_lote_ubicacion | INT | FK, NOT NULL | Existencia afectada |
| id_usuario | INT | FK, NOT NULL | Usuario responsable |
| fecha_hora | DATETIME | NOT NULL | Fecha y hora |
| tipo_ajuste | VARCHAR(30) | NOT NULL, CHECK | Tipo de ajuste |
| cantidad | DECIMAL(12,3) | NOT NULL, CHECK > 0 | Cantidad afectada |
| observacion | VARCHAR(250) | NULL | Explicación del ajuste |

### Tipos considerados

- DAÑADO
- PERDIDO
- VENCIDO
- OTRO

### Claves foráneas

`id_lote_ubicacion → LOTE_UBICACION(id_lote_ubicacion)`

`id_usuario → USUARIO(id_usuario)`

---

# 15. Tabla SESION_CAJA

Registra la apertura y cierre de caja realizada por cada encargado.

| Campo | Tipo | Restricciones | Descripción |
|---|---|---|---|
| id_sesion_caja | INT | PK, AUTO_INCREMENT | Identificador |
| id_usuario | INT | FK, NOT NULL | Usuario responsable |
| fecha_hora_apertura | DATETIME | NOT NULL | Fecha y hora de apertura |
| monto_inicial | DECIMAL(12,2) | NOT NULL, CHECK >= 0 | Efectivo inicial |
| fecha_hora_cierre | DATETIME | NULL | Fecha y hora de cierre |
| estado | VARCHAR(20) | NOT NULL, CHECK | Estado |
| observacion | VARCHAR(250) | NULL | Observaciones |

### Estados

- ABIERTA
- CERRADA

### Clave foránea

`id_usuario → USUARIO(id_usuario)`

---

# 16. Tabla VENTA

Representa cada operación de venta realizada en el negocio.

| Campo | Tipo | Restricciones | Descripción |
|---|---|---|---|
| id_venta | INT | PK, AUTO_INCREMENT | Identificador |
| id_sesion_caja | INT | FK, NOT NULL | Sesión de caja |
| fecha_hora | DATETIME | NOT NULL | Fecha y hora |
| estado | VARCHAR(20) | NOT NULL, CHECK | Estado de la venta |
| motivo_anulacion | VARCHAR(250) | NULL | Motivo si fue anulada |

### Estados

- VIGENTE
- ANULADA

### Clave foránea

`id_sesion_caja → SESION_CAJA(id_sesion_caja)`

Las ventas anuladas se conservan en la base de datos y no se eliminan físicamente.

---

# 17. Tabla DETALLE_VENTA

Almacena los productos y presentaciones incluidos en una venta.

| Campo | Tipo | Restricciones | Descripción |
|---|---|---|---|
| id_detalle_venta | INT | PK, AUTO_INCREMENT | Identificador |
| id_venta | INT | FK, NOT NULL | Venta |
| id_presentacion | INT | FK, NOT NULL | Presentación vendida |
| cantidad | DECIMAL(12,3) | NOT NULL, CHECK > 0 | Cantidad |
| precio_unitario | DECIMAL(12,2) | NOT NULL, CHECK >= 0 | Precio aplicado en la venta |

### Claves foráneas

`id_venta → VENTA(id_venta)`

`id_presentacion → PRESENTACION_PRODUCTO(id_presentacion)`

### Precio histórico

El campo `precio_unitario` conserva el precio aplicado en el momento de la venta.

De esta forma, un cambio posterior en `PRESENTACION_PRODUCTO.precio_venta` no modifica las ventas históricas.

---

# 18. Tabla DETALLE_VENTA_LOTE

Registra los lotes específicos utilizados para atender cada detalle de venta.

| Campo | Tipo | Restricciones | Descripción |
|---|---|---|---|
| id_detalle_venta_lote | INT | PK, AUTO_INCREMENT | Identificador |
| id_detalle_venta | INT | FK, NOT NULL | Detalle de venta |
| id_lote_ubicacion | INT | FK, NOT NULL | Lote y ubicación afectados |
| cantidad_base | DECIMAL(12,3) | NOT NULL, CHECK > 0 | Cantidad descontada en unidad base |

### Claves foráneas

`id_detalle_venta → DETALLE_VENTA(id_detalle_venta)`

`id_lote_ubicacion → LOTE_UBICACION(id_lote_ubicacion)`

### Restricción

`UNIQUE(id_detalle_venta, id_lote_ubicacion)`

Esta relación mantiene la trazabilidad necesaria para aplicar FIFO.

---

# 19. Tabla PAGO

Registra los pagos realizados para una venta.

| Campo | Tipo | Restricciones | Descripción |
|---|---|---|---|
| id_pago | INT | PK, AUTO_INCREMENT | Identificador |
| id_venta | INT | FK, NOT NULL | Venta pagada |
| metodo_pago | VARCHAR(20) | NOT NULL, CHECK | Método utilizado |
| monto | DECIMAL(12,2) | NOT NULL, CHECK > 0 | Importe |
| comprobante_qr | VARCHAR(255) | NULL | Referencia al comprobante QR |

### Métodos de pago

- EFECTIVO
- QR

### Clave foránea

`id_venta → VENTA(id_venta)`

Una venta puede poseer más de un pago, permitiendo pagos mixtos.

Ejemplo:

```text
Venta total = 144 Bs
Efectivo    = 100 Bs
QR          = 44 Bs
```

---

# 20. Tabla DENOMINACION

Almacena las denominaciones monetarias utilizadas en los arqueos.

| Campo | Tipo | Restricciones | Descripción |
|---|---|---|---|
| id_denominacion | INT | PK, AUTO_INCREMENT | Identificador |
| valor | DECIMAL(12,2) | NOT NULL, UNIQUE, CHECK > 0 | Valor monetario |
| tipo | VARCHAR(20) | NOT NULL, CHECK | Tipo |
| estado | VARCHAR(20) | NOT NULL | Estado |

### Tipos

- BILLETE
- MONEDA

---

# 21. Tabla ARQUEO_CAJA

Registra el arqueo asociado al cierre de una sesión de caja.

| Campo | Tipo | Restricciones | Descripción |
|---|---|---|---|
| id_arqueo | INT | PK, AUTO_INCREMENT | Identificador |
| id_sesion_caja | INT | FK, NOT NULL, UNIQUE | Sesión de caja |
| fecha_hora | DATETIME | NOT NULL | Fecha y hora del arqueo |
| observacion | VARCHAR(250) | NULL | Observaciones |

### Clave foránea

`id_sesion_caja → SESION_CAJA(id_sesion_caja)`

La restricción `UNIQUE` evita registrar más de un arqueo para la misma sesión.

---

# 22. Tabla DETALLE_ARQUEO

Registra la cantidad contabilizada de cada denominación monetaria.

| Campo | Tipo | Restricciones | Descripción |
|---|---|---|---|
| id_detalle_arqueo | INT | PK, AUTO_INCREMENT | Identificador |
| id_arqueo | INT | FK, NOT NULL | Arqueo |
| id_denominacion | INT | FK, NOT NULL | Denominación |
| cantidad | INT | NOT NULL, CHECK >= 0 | Cantidad contabilizada |

### Claves foráneas

`id_arqueo → ARQUEO_CAJA(id_arqueo)`

`id_denominacion → DENOMINACION(id_denominacion)`

### Restricción

`UNIQUE(id_arqueo, id_denominacion)`

### Subtotal por denominación

`DENOMINACION.valor × DETALLE_ARQUEO.cantidad`

---

# 23. Resumen de relaciones principales

| Tabla origen | Clave foránea | Tabla destino |
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

# 24. Valores calculados

Para reducir redundancia, determinados resultados se calculan a partir de los datos almacenados.

### Stock actual

`SUM(LOTE_UBICACION.cantidad_actual)`

### Total de compra

`SUM(cantidad × costo_unitario)`

### Total de venta

`SUM(cantidad × precio_unitario)`

### Efectivo contado

`SUM(valor_denominacion × cantidad)`

### Efectivo esperado

```text
monto_inicial
+
pagos en efectivo de ventas vigentes
```

### Diferencia de caja

`efectivo_contado - efectivo_esperado`

Los posibles resultados del arqueo son:

- CUADRA
- SOBRANTE
- FALTANTE

---

# 25. Control FIFO

El sistema debe utilizar primero las existencias correspondientes a los lotes más antiguos disponibles.

La trazabilidad se registra mediante:

```text
DETALLE_VENTA
        ↓
DETALLE_VENTA_LOTE
        ↓
LOTE_UBICACION
        ↓
LOTE_PRODUCTO
```

Durante la prueba integral se utilizaron dos lotes:

```text
LOTE-ANTIGUO-001 → 10 unidades
LOTE-NUEVO-002   → 2 unidades
```

para completar una venta de 12 unidades.

---

# 26. Vistas implementadas

La implementación contiene 11 vistas de apoyo:

1. `vw_stock_producto`
2. `vw_productos_stock_bajo`
3. `vw_stock_lote_ubicacion`
4. `vw_lotes_proximos_vencer`
5. `vw_compras_totales`
6. `vw_ventas_totales`
7. `vw_pagos_venta`
8. `vw_productos_mas_vendidos`
9. `vw_efectivo_esperado_sesion`
10. `vw_efectivo_contado_arqueo`
11. `vw_diferencias_caja`

Estas vistas facilitan la elaboración de reportes sin duplicar información en las tablas principales.

---

# 27. Resumen del modelo físico

La base de datos está compuesta por 21 tablas:

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

# 28. Conclusión

El diccionario de datos documenta la estructura física implementada para París Licorería.

La base permite controlar usuarios, productos, categorías, presentaciones, proveedores, compras, lotes, ubicaciones, inventario, ventas, pagos y operaciones de caja.

Las claves primarias, claves foráneas, restricciones `UNIQUE` y restricciones `CHECK` permiten reforzar la integridad y consistencia de los datos.

El diseño también mantiene trazabilidad de inventario mediante lotes y permite aplicar el criterio FIFO.

La implementación fue validada correctamente utilizando MySQL 8.0.
