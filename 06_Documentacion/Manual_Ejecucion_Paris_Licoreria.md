# Manual de Ejecución V2 — París Licorería

## 1. Requisitos

- MySQL Community Server 8.0.44.
- Cliente de línea de comandos de MySQL.
- Usuario con permisos para crear la base, tablas, vistas, procedimientos y triggers.
- Consola configurada para UTF-8.

No se debe guardar ninguna contraseña en archivos, comandos, Git o documentación.

## 2. Advertencia

`05_SQL/00_ejecutar_todo.sql` ejecuta `DROP DATABASE IF EXISTS paris_licoreria`. Su propósito es reconstruir y probar el esquema desde cero; elimina cualquier dato previo de esa base.

## 3. Archivos

```text
05_SQL/
├── 00_ejecutar_todo.sql       maestro
├── 01_creacion_bd.sql         base y utf8mb4
├── 02_creacion_tablas.sql     21 tablas, FK, UNIQUE, CHECK e índices
├── 03_rutinas.sql             5 procedimientos y 21 triggers
├── 04_vistas.sql              14 vistas
├── 03_datos_iniciales.sql     catálogos iniciales
├── 06_datos_prueba.sql        escenario V2
├── 07_pruebas_finales.sql     assertions positivas y negativas
└── 05_consultas_prueba.sql    consultas manuales opcionales
```

El orden del archivo maestro es:

```text
Base
  ↓
Tablas y restricciones
  ↓
Triggers y procedimientos
  ↓
Vistas
  ↓
Datos iniciales
  ↓
Escenario de prueba
  ↓
Assertions finales
```

## 4. Abrir MySQL sin exponer la contraseña

En PowerShell, desde la raíz del repositorio:

```powershell
chcp 65001
& "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" --default-character-set=utf8mb4 -u root -p
```

La opción `-p` sin valor hace que MySQL solicite la contraseña de forma interactiva. No la escriba dentro del comando.

## 5. Reconstrucción completa

Dentro del cliente MySQL:

```sql
SOURCE 05_SQL/00_ejecutar_todo.sql;
```

Solo si todas las pruebas pasan se muestra:

```text
BASE DE DATOS PARÍS LICORERÍA V2 VALIDADA
```

Si una assertion falla, `SIGNAL SQLSTATE '45000'` aborta el procedimiento de pruebas antes de emitir ese mensaje.

Para demostrar reproducibilidad, salir y ejecutar el archivo maestro una segunda vez.

## 6. Ejecución por etapas

```sql
SOURCE 05_SQL/01_creacion_bd.sql;
SOURCE 05_SQL/02_creacion_tablas.sql;
SOURCE 05_SQL/03_rutinas.sql;
SOURCE 05_SQL/04_vistas.sql;
SOURCE 05_SQL/03_datos_iniciales.sql;
SOURCE 05_SQL/06_datos_prueba.sql;
SOURCE 05_SQL/07_pruebas_finales.sql;
```

Las consultas de exploración son opcionales:

```sql
SOURCE 05_SQL/05_consultas_prueba.sql;
```

## 7. Registrar una compra

Firma:

```sql
CALL sp_registrar_compra(
    id_proveedor,
    id_usuario,
    fecha_hora,
    observacion,
    detalles_json,
    @id_compra
);
```

Ejemplo para dos cajas de 24:

```sql
CALL sp_registrar_compra(
    1,
    1,
    CURRENT_TIMESTAMP,
    'Ingreso de cajas',
    JSON_ARRAY(JSON_OBJECT(
        'id_presentacion', 2,
        'cantidad', 2.000,
        'costo_unitario', 180.00,
        'codigo_lote', 'LOTE-001',
        'fecha_vencimiento', '2027-12-31',
        'id_ubicacion', 1
    )),
    @id_compra
);
```

El procedimiento registra 48 unidades base. Si falla cualquier paso, revierte compra, detalle, lote y ubicación.

## 8. Registrar una venta

Firma:

```sql
CALL sp_registrar_venta(
    id_sesion_caja,
    detalles_json,
    pagos_json,
    @id_venta
);
```

Ejemplo de pago mixto:

```sql
CALL sp_registrar_venta(
    1,
    JSON_ARRAY(
        JSON_OBJECT('id_presentacion', 1, 'cantidad', 12.000)
    ),
    JSON_ARRAY(
        JSON_OBJECT('metodo_pago', 'EFECTIVO', 'monto', 100.00),
        JSON_OBJECT(
            'metodo_pago', 'QR',
            'monto', 44.00,
            'comprobante_qr', 'comprobantes/venta.png'
        )
    ),
    @id_venta
);
```

La rutina:

1. Bloquea la sesión y exige que esté abierta.
2. Valida presentaciones y productos activos.
3. Convierte cada cantidad a unidad base.
4. Busca lotes del mismo producto, no vencidos y con stock.
5. Los ordena por fecha de compra, lote y ubicación.
6. Bloquea cada existencia con `FOR UPDATE`.
7. Registra `DETALLE_VENTA_LOTE` y descuenta inventario.
8. Conserva el precio histórico.
9. Exige igualdad exacta entre pagos y total.
10. Confirma todo o ejecuta `ROLLBACK`.

## 9. Productos por peso

Para maní cuya unidad base es gramo:

```text
Gramo     factor 1
Kilogramo factor 1000
Libra     factor 453.592
```

Una venta de `0.250` kilogramos descuenta `250.000` gramos. La cantidad monetaria continúa siendo `0.250 × precio_por_kilogramo`.

## 10. Anular una venta

```sql
CALL sp_anular_venta(@id_venta, 'Motivo obligatorio');
```

Se bloquea la venta, se devuelve a cada lote exactamente lo consumido, se conserva todo el historial y se marca `ANULADA`. Un segundo intento produce error.

## 11. Ajustar inventario

```sql
CALL sp_registrar_ajuste_inventario(
    id_lote_ubicacion,
    id_usuario,
    'DAÑADO',
    1.000,
    'Botella rota',
    @id_ajuste
);
```

Tipos: `DAÑADO`, `PERDIDO`, `VENCIDO`, `OTRO`. El procedimiento bloquea la existencia y rechaza cantidades superiores al stock. `VENCIDO` requiere una fecha ya alcanzada.

## 12. Cerrar y arquear caja

```sql
CALL sp_cerrar_sesion_caja(
    id_sesion,
    CURRENT_TIMESTAMP,
    'Arqueo del turno',
    JSON_ARRAY(
        JSON_OBJECT('id_denominacion', 1, 'cantidad', 2),
        JSON_OBJECT('id_denominacion', 2, 'cantidad', 1)
    ),
    @id_arqueo
);
```

La sesión se cierra y el arqueo se registra en una transacción. Si el efectivo contado difiere del esperado, la observación es obligatoria.

## 13. Consultar inventario

```sql
SELECT * FROM vw_stock_producto;
SELECT * FROM vw_stock_fisico_producto;
SELECT * FROM vw_stock_disponible_producto;
SELECT * FROM vw_stock_vencido_producto;
SELECT * FROM vw_stock_lote_ubicacion;
SELECT * FROM vw_lotes_proximos_vencer;
```

Un lote con `fecha_vencimiento <= CURRENT_DATE` forma parte del stock físico y vencido, pero no del disponible.

## 14. Pruebas cubiertas

Las assertions verifican:

- 21 tablas, 14 vistas, 5 procedimientos, 21 triggers, FK y CHECK.
- UTF-8 y códigos con cero inicial.
- Compra normal y conversiones 24, 1000 y 453.592.
- Venta decimal de 0.250 kg.
- FIFO 10 + 2.
- Stock físico, disponible y vencido.
- Efectivo, QR y pago mixto.
- Pago incompleto con rollback.
- Stock insuficiente y stock negativo.
- Lote vencido y cruce de productos.
- Caja cerrada y estados incoherentes.
- Anulación, devolución exacta y doble anulación.
- Ajustes `DAÑADO`, `VENCIDO` y exceso de ajuste.
- Efectivo esperado y arqueo sin diferencia.

## 15. Seguridad y operación futura

- No conceder a la aplicación permisos administrativos sobre el servidor.
- Usar procedimientos para las operaciones multirow.
- Producir hashes de contraseña en el backend futuro.
- Guardar archivos QR fuera de la base y almacenar únicamente su referencia controlada.
- Programar copias de seguridad antes de utilizar datos reales.
