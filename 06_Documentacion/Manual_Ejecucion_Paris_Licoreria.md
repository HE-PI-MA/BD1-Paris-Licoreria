# Manual de Ejecución - París Licorería

## 1. Introducción

El presente manual describe el procedimiento necesario para crear, cargar, probar y validar la base de datos desarrollada para París Licorería.

La implementación fue realizada y validada utilizando MySQL Community Server 8.0.

---

# 2. Requisitos

Para ejecutar el proyecto se requiere:

- MySQL Server 8.0 o superior.
- Cliente de línea de comandos de MySQL.
- Visual Studio Code u otro editor de texto.
- Usuario de MySQL con permisos para crear bases de datos.
- Codificación UTF-8.

La versión utilizada durante las pruebas fue:

```text
MySQL Community Server 8.0.44
```

---

# 3. Base de datos

Nombre de la base:

```text
paris_licoreria
```

Juego de caracteres:

```text
utf8mb4
```

Intercalación:

```text
utf8mb4_unicode_ci
```

La utilización de `utf8mb4` permite almacenar correctamente caracteres como:

```text
á é í ó ú ñ
```

---

# 4. Organización de los scripts SQL

Los archivos se encuentran dentro de la carpeta:

```text
05_SQL/
```

La estructura es:

```text
05_SQL/
│
├── 00_ejecutar_todo.sql
├── 01_creacion_bd.sql
├── 02_creacion_tablas.sql
├── 03_datos_iniciales.sql
├── 04_vistas.sql
├── 05_consultas_prueba.sql
├── 06_datos_prueba.sql
└── 07_pruebas_finales.sql
```

---

# 5. Descripción de los archivos

## 5.1. 00_ejecutar_todo.sql

Es el archivo maestro del proyecto.

Ejecuta automáticamente los demás scripts en el orden correspondiente.

Permite reconstruir y validar completamente la base de datos.

> Importante: el proceso recrea la base de datos `paris_licoreria`. Por lo tanto, los datos existentes en esa base serán reemplazados por el escenario definido en los scripts.

---

## 5.2. 01_creacion_bd.sql

Realiza las siguientes operaciones:

```text
Eliminar la base anterior si existe
        ↓
Crear paris_licoreria
        ↓
Configurar utf8mb4
        ↓
Seleccionar la base
```

---

## 5.3. 02_creacion_tablas.sql

Crea las 21 tablas del modelo físico.

También define:

- Claves primarias.
- Claves foráneas.
- Restricciones UNIQUE.
- Restricciones CHECK.
- Relaciones entre tablas.
- Reglas de integridad.

---

## 5.4. 03_datos_iniciales.sql

Carga los datos maestros necesarios para iniciar el sistema.

Incluye:

```text
Roles
Unidades de medida
Categorías
Ubicaciones
Denominaciones monetarias
```

---

## 5.5. 04_vistas.sql

Crea 11 vistas destinadas a facilitar consultas y reportes.

Las vistas implementadas son:

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

---

## 5.6. 05_consultas_prueba.sql

Contiene consultas destinadas a comprobar el funcionamiento de la información almacenada.

Permite consultar, entre otros aspectos:

```text
Productos
Presentaciones
Stock
Stock bajo
Lotes
Vencimientos
Compras
Ventas
Ventas diarias
Ventas semanales
Ventas mensuales
Productos más vendidos
Formas de pago
Pagos mixtos
Ventas anuladas
Sesiones de caja
Diferencias de caja
Ajustes de inventario
Trazabilidad FIFO
Validación de pagos
```

---

## 5.7. 06_datos_prueba.sql

Carga un escenario controlado para demostrar el funcionamiento integral del modelo.

La prueba contiene:

```text
2 usuarios
1 proveedor
1 producto
1 presentación
2 compras
2 lotes
1 sesión de caja
1 venta
2 formas de pago
1 ajuste de inventario
1 arqueo de caja
```

También demuestra la utilización del criterio FIFO.

---

## 5.8. 07_pruebas_finales.sql

Ejecuta verificaciones automáticas sobre la base.

Comprueba:

```text
Cantidad de tablas
Cantidad de vistas
Codificación UTF-8
Stock
FIFO
Total de venta
Total pagado
Pagos mixtos
Existencias negativas
Arqueo de caja
Ajustes de inventario
```

---

# 6. Abrir MySQL desde PowerShell

Desde PowerShell se recomienda utilizar la página de códigos UTF-8.

Ejecutar:

```powershell
chcp 65001
```

Después iniciar el cliente de MySQL:

```powershell
& "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" --default-character-set=utf8mb4 -u root -p
```

MySQL solicitará la contraseña del usuario.

La contraseña no se incluye en ningún archivo del repositorio.

Cuando el acceso sea correcto aparecerá:

```text
mysql>
```

---

# 7. Ejecución completa recomendada

Ubicado dentro del cliente MySQL, ejecutar:

```sql
SOURCE 05_SQL/00_ejecutar_todo.sql;
```

Este único comando realiza:

```text
Creación de la base
        ↓
Creación de 21 tablas
        ↓
Aplicación de restricciones
        ↓
Carga de datos iniciales
        ↓
Creación de 11 vistas
        ↓
Carga de datos de prueba
        ↓
Ejecución de consultas
        ↓
Validación final
```

---

# 8. Ejecución manual por etapas

También es posible ejecutar los archivos individualmente:

```sql
SOURCE 05_SQL/01_creacion_bd.sql;

SOURCE 05_SQL/02_creacion_tablas.sql;

SOURCE 05_SQL/03_datos_iniciales.sql;

SOURCE 05_SQL/04_vistas.sql;

SOURCE 05_SQL/06_datos_prueba.sql;

SOURCE 05_SQL/05_consultas_prueba.sql;

SOURCE 05_SQL/07_pruebas_finales.sql;
```

---

# 9. Validación de la estructura

La prueba final debe indicar:

```text
cantidad_tablas = 21
resultado = OK
```

y:

```text
cantidad_vistas = 11
resultado = OK
```

Esto comprueba que la estructura física fue creada completamente.

---

# 10. Validación UTF-8

Durante las pruebas se verificaron textos como:

```text
Bebidas alcohólicas
Almacén
```

El valor hexadecimal almacenado confirmó que los caracteres se encuentran correctamente codificados en UTF-8.

---

# 11. Escenario de inventario

La prueba utiliza un producto:

```text
Cerveza Paceña 330 ml
```

Se ingresan dos lotes:

```text
LOTE-ANTIGUO-001 = 10 unidades
LOTE-NUEVO-002   = 10 unidades
```

Stock inicial:

```text
20 unidades
```

---

# 12. Prueba FIFO

Se realiza una venta de:

```text
12 unidades
```

La trazabilidad registrada es:

```text
LOTE-ANTIGUO-001 → 10 unidades
LOTE-NUEVO-002   → 2 unidades
```

Esto demuestra que se utilizaron primero las existencias correspondientes al lote más antiguo.

---

# 13. Prueba de ajuste de inventario

Después de la venta se registra:

```text
1 unidad dañada
```

El cálculo del inventario resulta:

```text
20 unidades iniciales
-12 unidades vendidas
-1 unidad dañada
---------------------
7 unidades finales
```

Como el stock mínimo configurado es:

```text
10 unidades
```

el sistema determina:

```text
STOCK BAJO
```

---

# 14. Prueba de venta

La venta utilizada en el escenario contiene:

```text
Cantidad = 12 unidades
Precio unitario = 12 Bs
```

Total:

```text
12 × 12 = 144 Bs
```

Resultado de validación:

```text
total_venta = 144
resultado = OK
```

---

# 15. Prueba de pago mixto

La venta de 144 Bs se paga mediante:

```text
EFECTIVO = 100 Bs
QR       = 44 Bs
```

Total pagado:

```text
144 Bs
```

Diferencia:

```text
0 Bs
```

Resultado:

```text
OK
```

---

# 16. Prueba de caja

La sesión se abre con:

```text
Monto inicial = 100 Bs
```

Durante la sesión se reciben:

```text
100 Bs en efectivo
```

Por lo tanto:

```text
Efectivo esperado = 200 Bs
```

Durante el arqueo se cuentan:

```text
200 Bs
```

Resultado:

```text
Efectivo esperado = 200 Bs
Efectivo contado  = 200 Bs
Diferencia        = 0 Bs
Resultado         = CUADRA
```

---

# 17. Validación de stock negativo

La prueba automática comprueba que no existan registros con:

```text
cantidad_actual < 0
```

El resultado obtenido fue:

```text
existencias_negativas = 0
resultado = OK
```

---

# 18. Resultado final esperado

Cuando toda la ejecución ha sido correcta aparece:

```text
BASE DE DATOS PARÍS LICORERÍA VALIDADA
```

Este mensaje indica que las principales verificaciones del escenario de prueba fueron superadas.

---

# 19. Salir de MySQL

Para cerrar el cliente:

```sql
exit;
```

---

# 20. Recomendaciones

Los archivos `06_datos_prueba.sql` y `07_pruebas_finales.sql` están destinados a la demostración y validación académica.

Para utilizar posteriormente la base con datos reales se deberán cargar los usuarios, productos, proveedores, compras y demás operaciones reales del negocio.

No deben almacenarse contraseñas reales en texto plano.

La aplicación que utilice esta base deberá almacenar las contraseñas mediante un algoritmo seguro de hash.

---

# 21. Conclusión

La base de datos de París Licorería puede reconstruirse y validarse de forma reproducible mediante los scripts incluidos en el proyecto.

El archivo `00_ejecutar_todo.sql` facilita la demostración del sistema al ejecutar automáticamente la estructura, los datos iniciales, el escenario de prueba, las consultas y las verificaciones finales.

Las pruebas realizadas confirmaron el correcto funcionamiento de las relaciones, el inventario, los lotes, FIFO, las ventas, los pagos mixtos y el control de caja.