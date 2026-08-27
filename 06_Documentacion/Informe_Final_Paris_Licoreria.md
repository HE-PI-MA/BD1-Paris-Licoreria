# Informe Final - Base de Datos París Licorería

## 1. Introducción

El presente proyecto consiste en el análisis, diseño e implementación de una base de datos relacional para París Licorería.

El negocio comercializa principalmente bebidas alcohólicas y complementa sus ventas con otros productos como gaseosas, dulces, galletas, artículos de limpieza y diferentes productos de consumo.

Antes del desarrollo del proyecto, gran parte del control operativo se realizaba utilizando papel y lápiz.

Esta forma de trabajo dificultaba mantener un control preciso sobre las existencias, las compras, los lotes, las ventas y los cierres de caja.

A partir de esta problemática se desarrolló un modelo de datos orientado a organizar la información del negocio y proporcionar trazabilidad sobre sus operaciones principales.

---

# 2. Situación problemática

Durante el análisis del negocio se identificaron diferentes necesidades relacionadas con la administración de la información.

Entre las principales se encontraron:

```text
Control de usuarios
Control de productos
Categorías
Presentaciones comerciales
Códigos de barras
Precios
Proveedores
Compras
Inventario
Stock mínimo
Lotes
Vencimientos
Ubicaciones
Ventas
Pagos
Pagos mixtos
Sesiones de caja
Arqueos
Daños
Pérdidas
Productos vencidos
Trazabilidad FIFO
```

La ausencia de una base de datos estructurada hacía difícil obtener información confiable y actualizada de estas operaciones.

---

# 3. Objetivo general

Diseñar e implementar una base de datos relacional normalizada para París Licorería que permita representar y controlar sus principales operaciones comerciales, manteniendo integridad, consistencia y trazabilidad de la información.

---

# 4. Objetivos específicos

Los objetivos específicos del proyecto fueron:

```text
Analizar el funcionamiento real del negocio
Identificar sus requerimientos de información
Identificar entidades y atributos
Determinar relaciones y cardinalidades
Diseñar el Modelo Entidad-Relación
Transformarlo en un Modelo Relacional
Aplicar normalización hasta 3FN
Implementar el modelo en MySQL
Crear vistas y consultas
Realizar pruebas integrales
Documentar la solución
```

---

# 5. Levantamiento de información

El desarrollo comenzó con una entrevista orientada a conocer la forma de trabajo de París Licorería.

Se analizaron procesos relacionados con:

```text
Productos
Compras
Proveedores
Inventario
Ventas
Formas de pago
Usuarios
Caja
Arqueos
Pérdidas
Vencimientos
```

La información obtenida permitió definir posteriormente los requerimientos funcionales y de datos.

---

# 6. Roles identificados

Se definieron dos roles principales.

## ADMINISTRADOR

Representa principalmente al propietario o responsable del negocio.

Entre sus funciones se encuentran:

```text
Administrar productos
Administrar categorías
Administrar proveedores
Registrar compras
Administrar precios
Revisar inventario
Revisar ventas
Revisar cierres de caja
Consultar reportes
Administrar usuarios
```

## ENCARGADO_VENTA

Representa al trabajador encargado de realizar ventas y manejar caja.

Entre sus operaciones se encuentran:

```text
Iniciar sesión
Abrir sesión de caja
Registrar ventas
Buscar productos
Utilizar código de barras
Registrar pagos
Registrar pagos QR
Registrar pagos mixtos
Cerrar sesión de caja
Realizar arqueo
```

---

# 7. Modelo Entidad-Relación

Después del análisis de los requerimientos se construyó el Modelo Entidad-Relación.

El modelo representa las entidades principales del negocio y las relaciones existentes entre ellas.

Posteriormente fue utilizado como base para generar el Modelo Relacional.

El diagrama fue desarrollado y conservado dentro de:

```text
03_Modelo_ER/
```

---

# 8. Modelo Relacional

La transformación del Modelo Entidad-Relación produjo una estructura formada por 21 tablas.

Las tablas finales son:

```text
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
```

---

# 9. Normalización

El modelo fue revisado aplicando:

```text
Primera Forma Normal  (1FN)
Segunda Forma Normal  (2FN)
Tercera Forma Normal  (3FN)
```

## Primera Forma Normal

Los campos contienen valores atómicos y no existen grupos repetitivos dentro de una misma tabla.

## Segunda Forma Normal

Los atributos dependen completamente de sus respectivas claves.

Las relaciones de muchos a muchos fueron resueltas mediante tablas intermedias o tablas de detalle.

## Tercera Forma Normal

Se evitaron dependencias transitivas separando información que corresponde a entidades distintas.

Ejemplos:

```text
PRODUCTO → CATEGORIA
PRODUCTO → UNIDAD_MEDIDA
PRODUCTO → PRESENTACION_PRODUCTO

COMPRA → DETALLE_COMPRA

VENTA → DETALLE_VENTA

ARQUEO_CAJA → DETALLE_ARQUEO
```

El resultado es una estructura que reduce redundancias y disminuye las posibilidades de anomalías de inserción, modificación y eliminación.

---

# 10. Productos y presentaciones

La tabla `PRODUCTO` almacena la información general del artículo.

La tabla `PRESENTACION_PRODUCTO` permite representar diferentes formas de comercialización.

Por ejemplo, un mismo producto podría comercializarse como:

```text
Unidad
Pack
Caja
Fardo
```

La conversión hacia la unidad base se controla mediante:

```text
factor_conversion
```

También se registra un código de barras cuando el producto o presentación dispone de uno.

---

# 11. Control de precios

El precio de venta actual se almacena en:

```text
PRESENTACION_PRODUCTO.precio_venta
```

Sin embargo, cada detalle de venta conserva:

```text
DETALLE_VENTA.precio_unitario
```

De esta manera, si posteriormente cambia el precio actual de un producto, las ventas históricas continúan conservando el precio utilizado en el momento en que fueron realizadas.

---

# 12. Compras y proveedores

Las compras están representadas mediante:

```text
PROVEEDOR
    ↓
COMPRA
    ↓
DETALLE_COMPRA
```

Cada compra identifica:

```text
Proveedor
Usuario responsable
Fecha y hora
Productos adquiridos
Cantidad
Costo unitario
```

Los totales pueden calcularse mediante los datos almacenados en los detalles.

---

# 13. Control de lotes

Cada ingreso de mercadería puede originar uno o varios registros de lote.

La tabla:

```text
LOTE_PRODUCTO
```

permite registrar:

```text
Código de lote
Fecha de vencimiento
Cantidad inicial
Compra de origen
```

Esto proporciona trazabilidad sobre el origen de las existencias.

---

# 14. Ubicaciones

La mercadería puede encontrarse en diferentes lugares físicos.

Se definieron ubicaciones iniciales como:

```text
Almacén
Estante
Refrigerador
Vitrina
```

La relación:

```text
LOTE_UBICACION
```

permite saber qué cantidad de un lote se encuentra en una determinada ubicación.

---

# 15. Control de stock

El stock actual no se almacena directamente en la tabla `PRODUCTO`.

Se obtiene utilizando:

```text
SUM(LOTE_UBICACION.cantidad_actual)
```

Esta decisión evita mantener dos fuentes distintas para la misma existencia.

Además se registra:

```text
PRODUCTO.stock_minimo
```

para identificar productos que requieren reposición.

Los posibles estados utilizados en las consultas son:

```text
DISPONIBLE
STOCK BAJO
AGOTADO
```

---

# 16. Ajustes de inventario

Las pérdidas de mercadería que no corresponden a ventas se registran mediante:

```text
AJUSTE_INVENTARIO
```

Los tipos considerados son:

```text
DAÑADO
PERDIDO
VENCIDO
OTRO
```

Cada ajuste mantiene información del usuario responsable, fecha, cantidad y observación.

---

# 17. Ventas

Una venta pertenece a una sesión de caja.

La estructura utilizada es:

```text
SESION_CAJA
      ↓
    VENTA
      ↓
DETALLE_VENTA
```

Cada detalle almacena:

```text
Presentación
Cantidad
Precio unitario histórico
```

El total de una venta se calcula sumando:

```text
cantidad × precio_unitario
```

de todos sus detalles.

---

# 18. Anulación de ventas

Las ventas no se eliminan físicamente.

Se utiliza el campo:

```text
estado
```

con valores:

```text
VIGENTE
ANULADA
```

Cuando corresponde una anulación también se conserva:

```text
motivo_anulacion
```

Esto permite mantener la trazabilidad histórica de las operaciones.

---

# 19. FIFO

El criterio establecido para la salida de mercadería es FIFO.

FIFO significa:

```text
First In, First Out
Primero en entrar, primero en salir
```

La tabla:

```text
DETALLE_VENTA_LOTE
```

registra exactamente de qué lote y ubicación salió cada cantidad vendida.

La trazabilidad utilizada es:

```text
DETALLE_VENTA
        ↓
DETALLE_VENTA_LOTE
        ↓
LOTE_UBICACION
        ↓
LOTE_PRODUCTO
```

---

# 20. Prueba FIFO realizada

Durante la validación se ingresaron dos lotes:

```text
LOTE-ANTIGUO-001 = 10 unidades
LOTE-NUEVO-002   = 10 unidades
```

Posteriormente se realizó una venta de:

```text
12 unidades
```

El resultado registrado fue:

```text
LOTE-ANTIGUO-001 → 10 unidades
LOTE-NUEVO-002   → 2 unidades
```

Esto demostró la trazabilidad del criterio FIFO dentro del modelo.

---

# 21. Formas de pago

La tabla:

```text
PAGO
```

se encuentra separada de `VENTA`.

Esto permite registrar varios pagos para una misma operación.

Los métodos actualmente considerados son:

```text
EFECTIVO
QR
```

Gracias a esta estructura también se pueden registrar pagos mixtos.

---

# 22. Prueba de pago mixto

Durante las pruebas se realizó una venta de:

```text
144 Bs
```

La operación se pagó de la siguiente manera:

```text
EFECTIVO = 100 Bs
QR       = 44 Bs
```

La suma fue:

```text
144 Bs
```

La validación automática obtuvo:

```text
diferencia = 0
resultado = OK
```

---

# 23. Sesiones de caja

Cada encargado trabaja asociado a una:

```text
SESION_CAJA
```

La sesión almacena:

```text
Usuario
Fecha y hora de apertura
Monto inicial
Fecha y hora de cierre
Estado
Observaciones
```

Los estados considerados son:

```text
ABIERTA
CERRADA
```

---

# 24. Arqueo de caja

El arqueo se representa mediante:

```text
ARQUEO_CAJA
        ↓
DETALLE_ARQUEO
        ↓
DENOMINACION
```

Esto permite registrar cuántos billetes y monedas existen durante el cierre.

El efectivo contado se calcula mediante:

```text
SUM(valor × cantidad)
```

---

# 25. Prueba de caja

La sesión de prueba comenzó con:

```text
Monto inicial = 100 Bs
```

Durante la venta se recibieron:

```text
100 Bs en efectivo
```

Por lo tanto:

```text
Efectivo esperado = 200 Bs
```

Durante el arqueo se registraron:

```text
200 Bs
```

La diferencia obtenida fue:

```text
0 Bs
```

Resultado:

```text
CUADRA
```

---

# 26. Vistas

Se implementaron 11 vistas.

```text
vw_stock_producto
vw_productos_stock_bajo
vw_stock_lote_ubicacion
vw_lotes_proximos_vencer
vw_compras_totales
vw_ventas_totales
vw_pagos_venta
vw_productos_mas_vendidos
vw_efectivo_esperado_sesion
vw_efectivo_contado_arqueo
vw_diferencias_caja
```

Las vistas permiten consultar información derivada sin almacenar valores redundantes.

---

# 27. Implementación física

La base fue implementada utilizando MySQL.

Se utilizaron:

```text
PRIMARY KEY
FOREIGN KEY
UNIQUE
CHECK
AUTO_INCREMENT
DATETIME
DATE
DECIMAL
VARCHAR
```

Las relaciones utilizan claves foráneas para reforzar la integridad referencial.

También se utilizaron restricciones `CHECK` para impedir determinados valores inválidos.

---

# 28. Codificación

La base utiliza:

```text
utf8mb4
```

Durante las pruebas se verificó correctamente el almacenamiento de caracteres especiales en textos como:

```text
Bebidas alcohólicas
Almacén
```

---

# 29. Prueba integral

La prueba final comprobó:

```text
21 tablas                       OK
11 vistas                       OK
Codificación UTF-8              OK
Compras                         OK
Inventario                      OK
Stock mínimo                    OK
FIFO                            OK
Venta                           OK
Pago mixto                      OK
Ajuste de inventario            OK
Sesión de caja                  OK
Arqueo                          OK
Existencias negativas           0
Diferencia de pagos             0
Diferencia de caja              0
```

La prueba terminó mostrando:

```text
BASE DE DATOS PARÍS LICORERÍA VALIDADA
```

---

# 30. Tecnologías utilizadas

Durante el desarrollo se utilizaron:

```text
MySQL Server 8.0
SQL
MySQL CLI
Visual Studio Code
Mermaid
Draw.io
Markdown
Git
GitHub
PowerShell
```

---

# 31. Organización del proyecto

El repositorio se encuentra organizado de la siguiente manera:

```text
BD1-Paris-Licoreria/
│
├── 01_Entrevista/
├── 02_Requerimientos/
├── 03_Modelo_ER/
├── 04_Modelo_Relacional/
├── 05_SQL/
├── 06_Documentacion/
└── README.md
```

Esta estructura permite identificar fácilmente cada etapa del trabajo realizado.

---

# 32. Scripts SQL

La implementación SQL contiene:

```text
00_ejecutar_todo.sql
01_creacion_bd.sql
02_creacion_tablas.sql
03_datos_iniciales.sql
04_vistas.sql
05_consultas_prueba.sql
06_datos_prueba.sql
07_pruebas_finales.sql
```

El archivo:

```text
00_ejecutar_todo.sql
```

permite ejecutar el escenario completo de validación.

---

# 33. Resultados obtenidos

Las pruebas realizadas comprobaron que la estructura puede registrar correctamente las principales operaciones planteadas para París Licorería.

El escenario integral produjo:

```text
Stock inicial          = 20 unidades
Venta                  = 12 unidades
Producto dañado        = 1 unidad
Stock final            = 7 unidades
Stock mínimo           = 10 unidades
Estado                 = STOCK BAJO

Total venta            = 144 Bs
Pago efectivo          = 100 Bs
Pago QR                = 44 Bs
Total pagado           = 144 Bs

Efectivo esperado      = 200 Bs
Efectivo contado       = 200 Bs
Diferencia caja        = 0 Bs
Resultado              = CUADRA
```

---

# 34. Conclusiones

El proyecto permitió desarrollar una base de datos relacional basada en las necesidades identificadas en París Licorería.

El modelo diseñado permite organizar la información correspondiente a usuarios, productos, categorías, presentaciones, proveedores, compras, lotes, ubicaciones, inventario, ventas, pagos y caja.

La normalización hasta Tercera Forma Normal reduce redundancias y ayuda a mantener consistencia en la información.

La utilización de claves primarias, claves foráneas, restricciones `UNIQUE` y restricciones `CHECK` fortalece la integridad del modelo físico.

El diseño de lotes y ubicaciones permite mantener una única fuente operativa para las existencias y conservar trazabilidad sobre las salidas de inventario.

La relación entre detalle de venta y lotes permite representar el criterio FIFO.

La separación de los pagos permite registrar operaciones en efectivo, QR y pagos mixtos.

Las sesiones y arqueos proporcionan una estructura para controlar aperturas, cierres y diferencias de caja.

Finalmente, la implementación fue probada en MySQL mediante un escenario integral y las validaciones realizadas confirmaron el correcto funcionamiento de los componentes principales de la base de datos.

La solución desarrollada constituye una base sólida para la futura implementación de un sistema de gestión para París Licorería.