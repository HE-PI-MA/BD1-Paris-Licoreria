# París Licorería V2 — Base de datos operativa

Base de datos relacional para la gestión de productos, compras, inventario por lote y ubicación, ventas, pagos, sesiones de caja y arqueos de París Licorería.

La V2 conserva las **21 tablas** normalizadas hasta 3FN y agrega una capa operativa compatible con **MySQL Community Server 8.0.44**:

- 14 vistas.
- 5 procedimientos transaccionales.
- 21 triggers de integridad y auditoría.
- Pruebas positivas y negativas con `SIGNAL SQLSTATE`.

## Reglas centrales

### Unidad base y presentaciones

`PRODUCTO.id_unidad_medida` define la unidad en la que se controla el inventario. `PRESENTACION_PRODUCTO.factor_conversion` expresa cuántas unidades base contiene una presentación.

| Producto | Unidad base | Presentación | Factor | Operación | Inventario base |
|---|---|---|---:|---:|---:|
| Cerveza | unidad | Caja de 24 | 24 | compra 2 cajas | 48 unidades |
| Maní | gramo | Kilogramo | 1000 | venta 0.250 kg | 250 gramos |
| Maní | gramo | Libra | 453.592 | compra 1 libra | 453.592 gramos |

Semántica de cantidades:

- `DETALLE_COMPRA.cantidad`: presentaciones compradas.
- `DETALLE_VENTA.cantidad`: presentaciones vendidas.
- `LOTE_PRODUCTO.cantidad_inicial`: unidades base recibidas.
- `LOTE_UBICACION.cantidad_actual`: unidades base físicamente existentes.
- `DETALLE_VENTA_LOTE.cantidad_base`: unidades base descontadas.

### Stock físico, disponible y vencido

- **Stock físico:** toda existencia presente, incluso vencida.
- **Stock disponible:** existencia positiva de lotes sin vencimiento o con fecha posterior a hoy.
- **Stock vencido:** existencia cuyo vencimiento ya fue alcanzado.

Un lote vencido se conserva físicamente y aparece en reportes, pero los triggers y `sp_registrar_venta` impiden venderlo. Se retira mediante `sp_registrar_ajuste_inventario` con tipo `VENCIDO`.

### Operaciones atómicas

- `sp_registrar_compra`: registra compra, detalle, lote y ubicación aplicando `cantidad × factor_conversion`.
- `sp_registrar_venta`: valida caja, presentaciones, stock y pagos; bloquea lotes con `FOR UPDATE`; aplica FIFO; confirma todo o revierte todo.
- `sp_anular_venta`: devuelve exactamente el stock registrado en `DETALLE_VENTA_LOTE`, conserva detalles y pagos, y evita una segunda anulación.
- `sp_registrar_ajuste_inventario`: retira inventario sin permitir existencias negativas.
- `sp_cerrar_sesion_caja`: cierra la sesión y registra el arqueo dentro de una transacción.

Los lotes de una venta se ordenan por fecha de compra, `id_lote` e `id_lote_ubicacion`. El trigger de `DETALLE_VENTA_LOTE` verifica además que lote y venta correspondan al mismo producto.

## Organización

```text
BD1-Paris-Licoreria/
├── 01_Entrevista/
├── 02_Requerimientos/
├── 03_Modelo_ER/
├── 04_Modelo_Relacional/
├── 05_SQL/
│   ├── 00_ejecutar_todo.sql
│   ├── 01_creacion_bd.sql
│   ├── 02_creacion_tablas.sql
│   ├── 03_rutinas.sql
│   ├── 03_datos_iniciales.sql
│   ├── 04_vistas.sql
│   ├── 05_consultas_prueba.sql
│   ├── 06_datos_prueba.sql
│   └── 07_pruebas_finales.sql
└── 06_Documentacion/
```

El archivo maestro ejecuta:

```text
Base → tablas y CHECK/FK → triggers/procedimientos → vistas
     → datos iniciales → escenario V2 → assertions finales
```

## Reconstrucción

Desde la raíz del repositorio, abrir el cliente sin escribir la contraseña en el comando:

```powershell
& "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" --default-character-set=utf8mb4 -u root -p
```

MySQL solicitará la contraseña de forma interactiva. Después ejecutar:

```sql
SOURCE 05_SQL/00_ejecutar_todo.sql;
```

El script elimina y recrea `paris_licoreria`. Solo si todas las assertions pasan muestra:

```text
BASE DE DATOS PARÍS LICORERÍA V2 VALIDADA
```

Las pruebas cubren conversiones de cajas, kilogramos y libras; cantidades decimales; FIFO; vencimientos; pagos completos y mixtos; caja cerrada; stock negativo; ajustes; anulación y arqueo.

## Contratos JSON principales

Ejemplo de detalle para `sp_registrar_compra`:

```json
{
  "id_presentacion": 1,
  "cantidad": 2.000,
  "costo_unitario": 180.00,
  "codigo_lote": "LOTE-001",
  "fecha_vencimiento": "2027-12-31",
  "id_ubicacion": 1
}
```

Ejemplo de venta:

```json
{
  "detalles": [{"id_presentacion": 1, "cantidad": 0.250}],
  "pagos": [
    {"metodo_pago": "EFECTIVO", "monto": 5.00},
    {"metodo_pago": "QR", "monto": 10.00, "comprobante_qr": "ruta/archivo.png"}
  ]
}
```

La suma de pagos debe coincidir exactamente con el total. Los pagos de ventas anuladas permanecen como historial, pero no integran el efectivo esperado.

## Códigos de barras y seguridad

`PRESENTACION_PRODUCTO.codigo_barras` continúa como `VARCHAR(50)` y `UNIQUE` cuando no es `NULL`. Admite EAN-13, EAN-8, UPC con ceros iniciales y códigos internos alfanuméricos.

El repositorio no contiene contraseñas reales. Los valores de demostración representan hashes no utilizables; la aplicación futura deberá producir hashes seguros y conceder a su usuario SQL permisos para ejecutar las rutinas necesarias.
