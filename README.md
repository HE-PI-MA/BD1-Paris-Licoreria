# París Licorería - Proyecto de Base de Datos

Proyecto académico de diseño e implementación de una base de datos relacional para la gestión de **París Licorería**.

La solución permite representar los principales procesos del negocio relacionados con productos, inventario, compras, proveedores, lotes, ventas, pagos y control de caja.

---

## Objetivo

Diseñar e implementar una base de datos relacional normalizada hasta **Tercera Forma Normal (3FN)** que permita administrar de forma estructurada las operaciones principales de París Licorería.

---

## Funcionalidades contempladas

- Gestión de usuarios y roles.
- Gestión de categorías y productos.
- Diferentes presentaciones comerciales.
- Códigos de barras.
- Control de precios.
- Registro de proveedores.
- Registro de compras.
- Control de lotes.
- Fechas de vencimiento.
- Múltiples ubicaciones de inventario.
- Control de stock y stock mínimo.
- Ajustes por daño, pérdida o vencimiento.
- Registro de ventas.
- Historial del precio vendido.
- Pagos en efectivo.
- Pagos mediante QR.
- Pagos mixtos.
- Sesiones de caja.
- Arqueos de caja.
- Control de diferencias.
- Trazabilidad de inventario mediante FIFO.
- Consultas y reportes.

---

## Modelo de datos

La implementación física está compuesta por **21 tablas**:

1. `ROL`
2. `USUARIO`
3. `CATEGORIA`
4. `UNIDAD_MEDIDA`
5. `PRODUCTO`
6. `PRESENTACION_PRODUCTO`
7. `PROVEEDOR`
8. `COMPRA`
9. `DETALLE_COMPRA`
10. `LOTE_PRODUCTO`
11. `UBICACION`
12. `LOTE_UBICACION`
13. `AJUSTE_INVENTARIO`
14. `SESION_CAJA`
15. `VENTA`
16. `DETALLE_VENTA`
17. `DETALLE_VENTA_LOTE`
18. `PAGO`
19. `DENOMINACION`
20. `ARQUEO_CAJA`
21. `DETALLE_ARQUEO`

El modelo fue normalizado hasta **3FN**.

---

## Organización del repositorio

```text
BD1-Paris-Licoreria/
│
├── 01_Entrevista/
│
├── 02_Requerimientos/
│
├── 03_Modelo_ER/
│
├── 04_Modelo_Relacional/
│
├── 05_SQL/
│   ├── 00_ejecutar_todo.sql
│   ├── 01_creacion_bd.sql
│   ├── 02_creacion_tablas.sql
│   ├── 03_datos_iniciales.sql
│   ├── 04_vistas.sql
│   ├── 05_consultas_prueba.sql
│   ├── 06_datos_prueba.sql
│   └── 07_pruebas_finales.sql
│
├── 06_Documentacion/
│   ├── Diccionario_Datos_Paris_Licoreria.md
│   ├── Manual_Ejecucion_Paris_Licoreria.md
│   └── Informe_Final_Paris_Licoreria.md
│
└── README.md
```

---

## Ejecución de la base de datos

La implementación fue validada utilizando:

```text
MySQL Community Server 8.0.44
```

Desde el cliente MySQL puede ejecutarse todo el proyecto mediante:

```sql
SOURCE 05_SQL/00_ejecutar_todo.sql;
```

El archivo maestro realiza automáticamente:

```text
Creación de la base
        ↓
Creación de tablas
        ↓
Aplicación de restricciones
        ↓
Carga de datos iniciales
        ↓
Creación de vistas
        ↓
Carga de datos de prueba
        ↓
Consultas
        ↓
Validación final
```

> El archivo de ejecución completa recrea la base `paris_licoreria` y carga un escenario destinado a pruebas académicas.

---

## Control de inventario

El stock actual no se almacena directamente en `PRODUCTO`.

Se calcula utilizando las existencias registradas en:

```text
LOTE_UBICACION
```

Esto permite controlar cantidades por lote y por ubicación física.

---

## FIFO

La trazabilidad de las ventas se conserva mediante:

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

para atender una venta de 12 unidades.

---

## Pagos mixtos

Una venta puede poseer varios registros en `PAGO`.

Ejemplo utilizado durante las pruebas:

```text
Total venta = 144 Bs

EFECTIVO = 100 Bs
QR       = 44 Bs
```

Resultado:

```text
Total pagado = 144 Bs
Diferencia   = 0 Bs
```

---

## Prueba de caja

La validación integral produjo:

```text
Monto inicial      = 100 Bs
Efectivo recibido  = 100 Bs
Efectivo esperado  = 200 Bs
Efectivo contado   = 200 Bs
Diferencia         = 0 Bs
Resultado          = CUADRA
```

---

## Resultados de validación

La prueba final confirmó:

```text
21 tablas                 OK
11 vistas                 OK
UTF-8                     OK
Compras                   OK
Inventario                OK
Stock mínimo              OK
FIFO                      OK
Venta                     OK
Pago mixto                OK
Ajuste de inventario      OK
Sesión de caja            OK
Arqueo                    OK
Existencias negativas     0
Diferencia de pagos       0
Diferencia de caja        0
```

Resultado final:

```text
BASE DE DATOS PARÍS LICORERÍA VALIDADA
```

---

## Tecnologías utilizadas

- MySQL 8.0
- SQL
- Mermaid
- Draw.io
- Markdown
- Visual Studio Code
- PowerShell
- Git
- GitHub

---

## Documentación

La documentación detallada se encuentra en:

```text
06_Documentacion/
```

Incluye:

- Diccionario de datos.
- Manual de ejecución.
- Informe final.

---

## Estado del proyecto

**Proyecto de Base de Datos 1 completado y validado.**

La estructura se encuentra preparada para servir posteriormente como base de un sistema de gestión para París Licorería.