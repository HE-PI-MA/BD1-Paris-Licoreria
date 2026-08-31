# Informe Final V2 — Base de Datos París Licorería

## 1. Objetivo

La V2 convierte el modelo académico normalizado en una base preparada para sustentar posteriormente un sistema real. Conserva las entidades originales y agrega integridad operativa para compras, inventario, ventas, pagos, vencimientos, anulaciones y caja.

La implementación está orientada exclusivamente a MySQL Community Server 8.0.44. No incluye frontend, backend, lector móvil ni integraciones externas.

## 2. Estructura final

El modelo mantiene 21 tablas:

```text
ROL                       USUARIO
CATEGORIA                 UNIDAD_MEDIDA
PRODUCTO                  PRESENTACION_PRODUCTO
PROVEEDOR                 COMPRA
DETALLE_COMPRA            LOTE_PRODUCTO
UBICACION                 LOTE_UBICACION
AJUSTE_INVENTARIO         SESION_CAJA
VENTA                     DETALLE_VENTA
DETALLE_VENTA_LOTE        PAGO
DENOMINACION              ARQUEO_CAJA
DETALLE_ARQUEO
```

La capa V2 incorpora 14 vistas, 5 procedimientos operativos y 21 triggers sin agregar tablas persistentes.

## 3. Unidad base y conversiones

Cada producto define una unidad base mediante `PRODUCTO.id_unidad_medida`. La presentación define el multiplicador mediante `factor_conversion`.

```text
Compra base = DETALLE_COMPRA.cantidad × factor_conversion
Venta base  = DETALLE_VENTA.cantidad × factor_conversion
```

Las cantidades comerciales permanecen en los detalles de compra y venta. Los lotes, ubicaciones y movimientos FIFO se expresan en unidad base con tres decimales.

Casos implementados:

```text
1 caja de 24 cervezas → 24 unidades
2 kg de maní          → 2000 gramos
1 libra de maní       → 453.592 gramos
0.250 kg vendidos     → 250 gramos descontados
```

El importe de la venta por peso se calcula con la cantidad comercial y el precio de esa presentación. Por ejemplo, `0.250 kg × 20 Bs/kg = 5 Bs`.

## 4. Compra e ingreso de inventario

`sp_registrar_compra` recibe uno o varios detalles JSON y ejecuta dentro de una transacción:

```text
COMPRA
  ↓
DETALLE_COMPRA (presentaciones)
  ↓  cantidad × factor_conversion
LOTE_PRODUCTO (unidad base)
  ↓
LOTE_UBICACION (unidad base)
```

Los triggers impiden que los lotes superen lo comprado o que las ubicaciones representen más unidades que la cantidad inicial del lote.

## 5. Venta atómica

`sp_registrar_venta` confirma la operación únicamente si puede completar todos los pasos:

1. La sesión existe y está abierta.
2. Producto y presentación están activos.
3. Cantidad y factor son positivos.
4. Existe stock vendible suficiente.
5. Los lotes no están vencidos.
6. Cada lote pertenece al producto vendido.
7. La salida sigue FIFO.
8. Las existencias se bloquean con `FOR UPDATE`.
9. Se conserva el precio histórico.
10. La suma de pagos coincide exactamente con el total.

Ante cualquier error se ejecuta `ROLLBACK`, incluido el stock descontado por los triggers.

## 6. FIFO

Los lotes vendibles se ordenan mediante:

```text
COMPRA.fecha_hora
LOTE_PRODUCTO.id_lote
LOTE_UBICACION.id_lote_ubicacion
```

El escenario usa una venta de 12 unidades sobre lotes de 10 y 10. La trazabilidad esperada es:

```text
LOTE-ANTIGUO-001 → 10
LOTE-NUEVO-002   → 2
```

Cada asignación queda registrada en `DETALLE_VENTA_LOTE` y no puede modificarse o eliminarse posteriormente.

## 7. Vencimientos y clases de stock

La V2 distingue:

- `stock_fisico`: toda mercancía presente.
- `stock_disponible`: solo lotes no vencidos.
- `stock_vencido`: mercancía física cuya fecha ya fue alcanzada.

Un lote vencido permanece visible en inventario, queda excluido de FIFO y solo se retira físicamente mediante un ajuste `VENCIDO`.

Las vistas permiten consultar totales por producto y el detalle por lote/ubicación. `vw_lotes_proximos_vencer` muestra exclusivamente los próximos 30 días.

## 8. Anulación

`sp_anular_venta` utiliza la trazabilidad histórica para devolver a cada `LOTE_UBICACION` la cantidad exacta consumida. Luego marca la venta como `ANULADA` y guarda el motivo.

Se conservan:

- `DETALLE_VENTA`.
- `DETALLE_VENTA_LOTE`.
- `PAGO`.

Un trigger obliga a utilizar el procedimiento y la rutina impide anular dos veces.

## 9. Pagos

Los métodos soportados son `EFECTIVO` y `QR`, incluida su combinación en una venta. Se utiliza `DECIMAL(15,2)`.

Reglas:

- Monto positivo.
- QR con comprobante no vacío.
- Ningún pago puede superar el total.
- La transacción final exige igualdad exacta entre pagos y venta.
- Los pagos confirmados son históricos.
- El efectivo de una venta anulada no se incluye en caja.

## 10. Sesión y arqueo

La restricción de `SESION_CAJA` hace equivalentes estado y fecha de cierre:

```text
ABIERTA  ↔ fecha_hora_cierre IS NULL
CERRADA ↔ fecha_hora_cierre válida y posterior a apertura
```

La venta exige sesión abierta. `sp_cerrar_sesion_caja` bloquea la sesión, registra cierre, arqueo y denominaciones en una transacción. Una diferencia requiere observación.

El efectivo esperado es:

```text
monto_inicial + pagos EFECTIVO de ventas VIGENTES
```

## 11. Ajustes

`sp_registrar_ajuste_inventario` mantiene `DAÑADO`, `PERDIDO`, `VENCIDO` y `OTRO`. Bloquea la existencia, comprueba disponibilidad y registra/descuenta en la misma transacción. No permite stock negativo.

## 12. Estados e historial

Se agregaron `CHECK` para estados maestros `ACTIVO/INACTIVO`, sesiones `ABIERTA/CERRADA` y ventas `VIGENTE/ANULADA`. Las cantidades, factores y montos también tienen límites declarativos.

El factor y la unidad base no pueden cambiar después de generar historia incompatible. Los movimientos FIFO, pagos y ajustes confirmados son inmutables.

## 13. Códigos de barras

`PRESENTACION_PRODUCTO.codigo_barras` conserva el tipo `VARCHAR(50)` y la unicidad cuando existe. Esto admite:

- EAN-13.
- EAN-8.
- UPC con cero inicial.
- Códigos internos alfanuméricos.

No se añadió conexión a Internet ni API de productos.

## 14. Pruebas

`07_pruebas_finales.sql` ya no imprime un éxito incondicional. Las assertions se ejecutan dentro de un procedimiento; cualquier fallo emite `SIGNAL SQLSTATE '45000'` y evita el mensaje final.

La cobertura incluye estructura, UTF-8, conversiones, peso decimal, FIFO, vencimientos, stock físico/disponible, pagos, caja, arqueo, anulación, ajustes y casos negativos con verificación de rollback.

El único mensaje de éxito permitido es:

```text
BASE DE DATOS PARÍS LICORERÍA V2 VALIDADA
```

## 15. Conclusión

La V2 conserva la normalización y las 21 tablas del trabajo académico, pero traslada las reglas multirow críticas a operaciones atómicas. La combinación de `CHECK`, FK, triggers, procedimientos, bloqueos y pruebas convierte el esquema en una base mucho más segura para el desarrollo futuro de la aplicación de licorería.
