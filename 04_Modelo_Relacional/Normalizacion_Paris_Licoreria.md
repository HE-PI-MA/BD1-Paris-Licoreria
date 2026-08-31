# Normalización V2 — París Licorería

## 1. Resultado

El modelo conserva 21 tablas persistentes y cumple Primera, Segunda y Tercera Forma Normal. La V2 no agrega columnas calculadas redundantes ni tablas de estado auxiliares; fortalece las operaciones mediante procedimientos, triggers, vistas y transacciones.

## 2. Primera Forma Normal

Cada relación posee clave primaria y sus atributos contienen valores atómicos. Los grupos repetitivos se representan mediante tablas de detalle:

| Relación conceptual | Resolución normalizada |
|---|---|
| Compra con varios productos | `COMPRA` + `DETALLE_COMPRA` |
| Venta con varios productos | `VENTA` + `DETALLE_VENTA` |
| Venta atendida por varios lotes | `DETALLE_VENTA_LOTE` |
| Lote distribuido en ubicaciones | `LOTE_UBICACION` |
| Venta con varios pagos | `PAGO` |
| Arqueo con denominaciones | `DETALLE_ARQUEO` |

Los arrays JSON recibidos por los procedimientos son parámetros operativos. Se descomponen en tablas temporales de la conexión y cada elemento termina almacenado de forma atómica en las relaciones anteriores.

## 3. Segunda Forma Normal

Las tablas utilizan claves primarias simples. Los atributos dependen por completo del identificador de su fila. Las restricciones compuestas representan claves candidatas:

- `LOTE_UBICACION(id_lote, id_ubicacion)` determina `cantidad_actual`.
- `DETALLE_VENTA_LOTE(id_detalle_venta, id_lote_ubicacion)` determina `cantidad_base`.
- `DETALLE_ARQUEO(id_arqueo, id_denominacion)` determina `cantidad`.
- `PRESENTACION_PRODUCTO(id_producto, nombre_presentacion)` identifica una presentación dentro de su producto.

No existen atributos que dependan únicamente de una parte de esas combinaciones.

## 4. Tercera Forma Normal

Los datos descriptivos permanecen en su entidad propietaria:

- El rol se almacena en `ROL`, no se repite en `USUARIO`.
- Categoría y unidad base se referencian desde `PRODUCTO`.
- Precio, código de barras y factor pertenecen a `PRESENTACION_PRODUCTO`.
- Los datos del proveedor no se copian en `COMPRA`.
- Los nombres de ubicación no se copian en `LOTE_UBICACION`.
- El valor monetario se conserva en `DENOMINACION`, no en cada detalle de arqueo.

`DETALLE_VENTA.precio_unitario` no constituye una dependencia transitiva: es el precio histórico aplicado a esa transacción, distinto del precio actual de la presentación.

## 5. Unidad base y factor de conversión

Las cantidades tienen semánticas diferentes y no son datos duplicados:

| Campo | Semántica |
|---|---|
| `DETALLE_COMPRA.cantidad` | Presentaciones compradas |
| `DETALLE_VENTA.cantidad` | Presentaciones vendidas |
| `LOTE_PRODUCTO.cantidad_inicial` | Unidades base recibidas |
| `LOTE_UBICACION.cantidad_actual` | Unidades base físicamente existentes |
| `DETALLE_VENTA_LOTE.cantidad_base` | Unidades base consumidas por la venta |

La transformación es:

```text
cantidad_base = ROUND(cantidad_presentaciones × factor_conversion, 3)
```

Ejemplos:

```text
2 cajas × 24 unidades = 48 unidades base
0.250 kg × 1000 g     = 250 gramos base
1 libra × 453.592 g   = 453.592 gramos base
```

Conservar la cantidad comercial y la cantidad base es necesario para representar tanto el hecho económico como el movimiento físico. Los triggers impiden que las cantidades base excedan el hecho de compra o venta que las origina.

## 6. Valores derivados no almacenados

Para evitar anomalías, se calculan mediante vistas:

```text
subtotal_compra = cantidad × costo_unitario
total_compra    = SUM(subtotal_compra)

subtotal_venta  = ROUND(cantidad × precio_unitario, 2)
total_venta     = SUM(subtotal_venta)

stock_fisico    = SUM(cantidad_actual)
stock_disponible = SUM(cantidad_actual de lotes vendibles)
stock_vencido   = SUM(cantidad_actual de lotes vencidos)

efectivo_contado = SUM(denominacion.valor × detalle_arqueo.cantidad)
efectivo_esperado = monto_inicial + pagos EFECTIVO de ventas VIGENTES
diferencia        = efectivo_contado - efectivo_esperado
```

La separación entre stock físico, disponible y vencido son proyecciones del mismo hecho `LOTE_UBICACION.cantidad_actual`; no se almacenan tres saldos independientes.

## 7. Integridad operativa y normalización

La normalización por sí sola no garantiza una operación multirow. La V2 complementa el modelo con:

- `sp_registrar_compra` para crear compra, detalle, lote y ubicación de forma atómica.
- `sp_registrar_venta` para aplicar FIFO, bloquear existencias y validar pagos.
- `sp_anular_venta` para revertir el movimiento físico sin borrar historia.
- `sp_registrar_ajuste_inventario` para registrar y descontar una merma.
- `sp_cerrar_sesion_caja` para cerrar y arquear coherentemente.

Los triggers protegen invariantes locales: correspondencia producto-lote, vencimientos, límites de cantidad, estados, inmutabilidad del historial y stock no negativo.

Estas reglas no desnormalizan el esquema; controlan transiciones válidas entre estados normalizados.

## 8. Dependencias funcionales principales

```text
id_producto
→ id_categoria, id_unidad_medida, nombre, descripcion, stock_minimo, estado

id_presentacion
→ id_producto, nombre_presentacion, factor_conversion,
  codigo_barras, precio_venta, estado

id_detalle_compra
→ id_compra, id_presentacion, cantidad, costo_unitario

id_lote
→ id_detalle_compra, codigo_lote, fecha_vencimiento, cantidad_inicial

(id_lote, id_ubicacion)
→ cantidad_actual

id_detalle_venta
→ id_venta, id_presentacion, cantidad, precio_unitario

(id_detalle_venta, id_lote_ubicacion)
→ cantidad_base

id_pago
→ id_venta, metodo_pago, monto, comprobante_qr

(id_arqueo, id_denominacion)
→ cantidad
```

## 9. Verificación de las 21 tablas

| Tabla | 1FN | 2FN | 3FN |
|---|---|---|---|
| ROL | Sí | Sí | Sí |
| USUARIO | Sí | Sí | Sí |
| CATEGORIA | Sí | Sí | Sí |
| UNIDAD_MEDIDA | Sí | Sí | Sí |
| PRODUCTO | Sí | Sí | Sí |
| PRESENTACION_PRODUCTO | Sí | Sí | Sí |
| PROVEEDOR | Sí | Sí | Sí |
| COMPRA | Sí | Sí | Sí |
| DETALLE_COMPRA | Sí | Sí | Sí |
| LOTE_PRODUCTO | Sí | Sí | Sí |
| UBICACION | Sí | Sí | Sí |
| LOTE_UBICACION | Sí | Sí | Sí |
| AJUSTE_INVENTARIO | Sí | Sí | Sí |
| SESION_CAJA | Sí | Sí | Sí |
| VENTA | Sí | Sí | Sí |
| DETALLE_VENTA | Sí | Sí | Sí |
| DETALLE_VENTA_LOTE | Sí | Sí | Sí |
| PAGO | Sí | Sí | Sí |
| DENOMINACION | Sí | Sí | Sí |
| ARQUEO_CAJA | Sí | Sí | Sí |
| DETALLE_ARQUEO | Sí | Sí | Sí |

## 10. Conclusión

La V2 mantiene el diseño en 3FN y una única fuente persistente para cada hecho. La robustez adicional proviene de límites declarativos y transacciones atómicas, no de almacenar totales o saldos paralelos que puedan divergir.
