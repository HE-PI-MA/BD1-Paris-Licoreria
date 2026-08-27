# Normalización de la Base de Datos - París Licorería

## 1. Introducción

La normalización es el proceso mediante el cual se organiza la información de una base de datos para reducir redundancias, evitar anomalías y mantener la integridad de los datos.

El modelo relacional de París Licorería está compuesto por 21 tablas.

En esta etapa se verificará el cumplimiento de:

* Primera Forma Normal (1FN).
* Segunda Forma Normal (2FN).
* Tercera Forma Normal (3FN).

El análisis parte del modelo relacional previamente definido y de las dependencias existentes entre sus atributos.

---

# 2. Objetivos de la normalización

La normalización del modelo busca evitar problemas como:

* Repetición innecesaria de información.
* Datos inconsistentes.
* Problemas al insertar información.
* Problemas al actualizar información.
* Problemas al eliminar registros.
* Dependencias incorrectas entre atributos.
* Almacenamiento de grupos repetitivos dentro de una misma columna.

También busca garantizar que cada dato se almacene en la tabla que realmente le corresponde.

---

# 3. Primera Forma Normal - 1FN

## 3.1 Definición

Una relación se encuentra en Primera Forma Normal cuando:

1. Cada tabla posee una clave primaria.
2. Cada campo contiene un único valor.
3. No existen grupos repetitivos.
4. Los valores almacenados son atómicos dentro del contexto del sistema.
5. Cada registro puede identificarse de manera única.

---

# 4. Aplicación de 1FN al modelo

Todas las tablas del modelo poseen una clave primaria.

Por ejemplo:

`ROL`

Clave primaria:

`id_rol`

`PRODUCTO`

Clave primaria:

`id_producto`

`VENTA`

Clave primaria:

`id_venta`

`DETALLE_VENTA`

Clave primaria:

`id_detalle_venta`

Esto permite identificar de manera única cada registro.

---

# 5. Eliminación de grupos repetitivos

Un ejemplo importante se encuentra en las ventas.

Una estructura incorrecta podría ser:

```text
VENTA

id_venta
fecha
producto1
cantidad1
producto2
cantidad2
producto3
cantidad3
```

Este diseño incumpliría 1FN debido a la existencia de grupos repetitivos.

En el modelo de París Licorería se utiliza:

```text
VENTA
```

y:

```text
DETALLE_VENTA
```

De esta forma una venta puede tener cualquier cantidad de productos sin agregar columnas repetitivas.

Ejemplo:

```text
VENTA
id_venta = 1
```

Puede relacionarse con:

```text
DETALLE_VENTA

1 → Cerveza → 2 unidades
1 → Coca Cola → 1 unidad
1 → Galleta → 3 unidades
```

Por lo tanto, el modelo mantiene valores atómicos y elimina grupos repetitivos.

---

# 6. Compras y 1FN

Una compra tampoco almacena múltiples productos dentro de columnas repetidas.

Se utiliza:

```text
COMPRA
```

para almacenar la información general de la compra.

Y:

```text
DETALLE_COMPRA
```

para almacenar los productos incluidos.

Esto permite representar:

```text
COMPRA 1
    |
    +--- Producto A
    +--- Producto B
    +--- Producto C
```

sin almacenar:

```text
producto1
producto2
producto3
```

dentro de COMPRA.

---

# 7. Arqueos y 1FN

El arqueo de caja también evita grupos repetitivos.

Una estructura incorrecta sería:

```text
ARQUEO_CAJA

billetes_100
billetes_50
billetes_20
billetes_10
monedas_5
monedas_1
```

En el modelo normalizado se utilizan:

```text
DENOMINACION
```

y:

```text
DETALLE_ARQUEO
```

Esto permite registrar cualquier denominación sin modificar la estructura de ARQUEO_CAJA.

---

# 8. Ubicaciones y 1FN

Un producto o lote puede encontrarse en más de una ubicación.

No se almacena algo como:

```text
ubicaciones = "Refrigerador, Estante, Almacén"
```

dentro de una sola columna.

Se utiliza:

```text
LOTE_UBICACION
```

Cada registro representa una relación individual entre:

* Un lote.
* Una ubicación.
* Una cantidad actual.

Por lo tanto, cada valor continúa siendo atómico.

---

# 9. Pagos y 1FN

Una venta puede utilizar más de una forma de pago.

No se utiliza una estructura como:

```text
VENTA

pago_efectivo
pago_qr
pago_otro
```

En cambio, se utiliza:

```text
PAGO
```

Una venta puede relacionarse con varios registros.

Ejemplo:

```text
Venta = 100 Bs

PAGO 1
EFECTIVO = 60 Bs

PAGO 2
QR = 40 Bs
```

De esta forma no existen grupos repetitivos dentro de VENTA.

---

# 10. Resultado de Primera Forma Normal

Las 21 tablas cumplen Primera Forma Normal debido a que:

* Cada tabla posee una clave primaria.
* Cada registro es identificable.
* Los campos almacenan valores individuales.
* No existen listas dentro de una columna.
* Los productos de compras y ventas se almacenan mediante tablas de detalle.
* Las ubicaciones se manejan mediante relaciones individuales.
* Las denominaciones se almacenan independientemente.
* Los pagos se almacenan como registros independientes.

Por lo tanto:

**El modelo cumple 1FN.**

---

# 11. Segunda Forma Normal - 2FN

## 11.1 Definición

Una tabla se encuentra en Segunda Forma Normal cuando:

1. Cumple Primera Forma Normal.
2. Todos los atributos no clave dependen completamente de la clave primaria.
3. No existen dependencias parciales de una clave compuesta.

Una dependencia parcial ocurre cuando un atributo depende solamente de una parte de una clave compuesta.

---

# 12. Claves primarias del modelo

La mayoría de las tablas utilizan una clave primaria simple.

Por ejemplo:

```text
PRODUCTO
PK = id_producto
```

```text
VENTA
PK = id_venta
```

```text
COMPRA
PK = id_compra
```

```text
PAGO
PK = id_pago
```

Cuando una tabla posee una clave primaria formada por un solo atributo, no puede existir una dependencia parcial respecto de dicha clave primaria.

Sin embargo, también se analizarán las relaciones que tienen restricciones compuestas de unicidad.

---

# 13. ROL en 2FN

Dependencia principal:

```text
id_rol → nombre, descripcion
```

Todos los atributos dependen completamente de:

```text
id_rol
```

Por lo tanto:

**ROL cumple 2FN.**

---

# 14. USUARIO en 2FN

Dependencia:

```text
id_usuario →
id_rol,
nombre,
apellido,
nombre_usuario,
contrasena,
estado
```

Toda la información corresponde al usuario identificado mediante:

```text
id_usuario
```

No existe dependencia parcial.

**USUARIO cumple 2FN.**

---

# 15. CATEGORIA en 2FN

Dependencia:

```text
id_categoria →
nombre,
descripcion,
estado
```

Los atributos describen exclusivamente la categoría.

**CATEGORIA cumple 2FN.**

---

# 16. UNIDAD_MEDIDA en 2FN

Dependencia:

```text
id_unidad_medida →
nombre,
abreviatura
```

Los atributos dependen completamente de la unidad de medida.

**UNIDAD_MEDIDA cumple 2FN.**

---

# 17. PRODUCTO en 2FN

Dependencia:

```text
id_producto →
id_categoria,
id_unidad_medida,
nombre,
descripcion,
stock_minimo,
estado
```

Todos los atributos corresponden al producto identificado.

**PRODUCTO cumple 2FN.**

---

# 18. PRESENTACION_PRODUCTO en 2FN

Dependencia:

```text
id_presentacion →
id_producto,
nombre_presentacion,
factor_conversion,
codigo_barras,
precio_venta,
estado
```

El precio, código de barras y factor de conversión pertenecen a una presentación específica.

Ejemplo:

```text
Coca Cola 3L - Unidad
```

puede tener un código y precio diferente de:

```text
Coca Cola 3L - Caja
```

Por lo tanto, dichos atributos dependen de:

```text
id_presentacion
```

**PRESENTACION_PRODUCTO cumple 2FN.**

---

# 19. PROVEEDOR en 2FN

Dependencia:

```text
id_proveedor →
nombre,
contacto,
telefono,
direccion,
estado
```

Todos los datos describen al mismo proveedor.

**PROVEEDOR cumple 2FN.**

---

# 20. COMPRA en 2FN

Dependencia:

```text
id_compra →
id_proveedor,
id_usuario,
fecha_hora,
observacion
```

Todos los atributos describen una compra determinada.

Los productos comprados no se almacenan directamente en esta tabla.

**COMPRA cumple 2FN.**

---

# 21. DETALLE_COMPRA en 2FN

Dependencia:

```text
id_detalle_compra →
id_compra,
id_presentacion,
cantidad,
costo_unitario
```

Cada detalle representa una presentación determinada incluida en una compra.

Los atributos:

```text
cantidad
costo_unitario
```

corresponden al detalle específico.

Por lo tanto:

**DETALLE_COMPRA cumple 2FN.**

---

# 22. LOTE_PRODUCTO en 2FN

Dependencia:

```text
id_lote →
id_detalle_compra,
codigo_lote,
fecha_vencimiento,
cantidad_inicial
```

Los datos corresponden al lote identificado.

**LOTE_PRODUCTO cumple 2FN.**

---

# 23. UBICACION en 2FN

Dependencia:

```text
id_ubicacion →
nombre,
descripcion,
estado
```

Todos los atributos dependen de la ubicación.

**UBICACION cumple 2FN.**

---

# 24. LOTE_UBICACION en 2FN

Clave primaria:

```text
id_lote_ubicacion
```

Además existe la restricción:

```text
UNIQUE(id_lote, id_ubicacion)
```

La cantidad actual depende de la combinación:

```text
lote + ubicación
```

Ejemplo:

```text
Lote 1 + Refrigerador → 10 unidades
Lote 1 + Almacén      → 20 unidades
```

No tendría sentido que `cantidad_actual` dependiera solamente del lote o solamente de la ubicación.

Por lo tanto:

**LOTE_UBICACION cumple 2FN.**

---

# 25. AJUSTE_INVENTARIO en 2FN

Dependencia:

```text
id_ajuste →
id_lote_ubicacion,
id_usuario,
fecha_hora,
tipo_ajuste,
cantidad,
observacion
```

Los atributos describen un ajuste determinado.

**AJUSTE_INVENTARIO cumple 2FN.**

---

# 26. SESION_CAJA en 2FN

Dependencia:

```text
id_sesion_caja →
id_usuario,
fecha_hora_apertura,
monto_inicial,
fecha_hora_cierre,
estado,
observacion
```

Cada atributo describe una sesión de caja.

**SESION_CAJA cumple 2FN.**

---

# 27. VENTA en 2FN

Dependencia:

```text
id_venta →
id_sesion_caja,
fecha_hora,
estado,
motivo_anulacion
```

Los atributos corresponden a una venta determinada.

**VENTA cumple 2FN.**

---

# 28. DETALLE_VENTA en 2FN

Dependencia:

```text
id_detalle_venta →
id_venta,
id_presentacion,
cantidad,
precio_unitario
```

La cantidad y el precio utilizado pertenecen al detalle de venta específico.

**DETALLE_VENTA cumple 2FN.**

---

# 29. DETALLE_VENTA_LOTE en 2FN

Clave primaria:

```text
id_detalle_venta_lote
```

Existe además:

```text
UNIQUE(id_detalle_venta, id_lote_ubicacion)
```

La cantidad base representa cuánto se descontó de una determinada existencia de lote y ubicación para un determinado detalle de venta.

Por lo tanto:

```text
(id_detalle_venta, id_lote_ubicacion)
→ cantidad_base
```

La cantidad depende de la combinación completa.

**DETALLE_VENTA_LOTE cumple 2FN.**

---

# 30. PAGO en 2FN

Dependencia:

```text
id_pago →
id_venta,
metodo_pago,
monto,
comprobante_qr
```

Cada registro representa una parte del pago realizado para una venta.

**PAGO cumple 2FN.**

---

# 31. DENOMINACION en 2FN

Dependencia:

```text
id_denominacion →
valor,
tipo,
estado
```

Los atributos describen una denominación monetaria específica.

**DENOMINACION cumple 2FN.**

---

# 32. ARQUEO_CAJA en 2FN

Dependencia:

```text
id_arqueo →
id_sesion_caja,
fecha_hora,
observacion
```

Cada registro representa el arqueo correspondiente a una sesión.

Además:

```text
id_sesion_caja
```

es único dentro de ARQUEO_CAJA.

**ARQUEO_CAJA cumple 2FN.**

---

# 33. DETALLE_ARQUEO en 2FN

Existe:

```text
UNIQUE(id_arqueo, id_denominacion)
```

La cantidad depende de:

```text
arqueo + denominación
```

Ejemplo:

```text
Arqueo 1 + 100 Bs → 5 billetes
Arqueo 1 + 50 Bs  → 3 billetes
```

La cantidad no depende solamente del arqueo ni solamente de la denominación.

Depende de ambos.

**DETALLE_ARQUEO cumple 2FN.**

---

# 34. Resultado de Segunda Forma Normal

Todas las relaciones cumplen Segunda Forma Normal porque:

* Ya cumplen 1FN.
* Las tablas con PK simple no presentan dependencias parciales de su clave primaria.
* Las relaciones conceptualmente determinadas por combinaciones de campos conservan atributos que dependen de la combinación completa.
* Las relaciones N:M se resolvieron mediante tablas intermedias.

Por lo tanto:

**El modelo cumple 2FN.**

---

# 35. Tercera Forma Normal - 3FN

## 35.1 Definición

Una tabla se encuentra en Tercera Forma Normal cuando:

1. Cumple Segunda Forma Normal.
2. No existen dependencias transitivas entre atributos no clave.
3. Los atributos no clave dependen de la clave, de toda la clave y no de otro atributo no clave.

Una dependencia transitiva ocurre cuando:

```text
PK → atributo A → atributo B
```

y `atributo B` debería almacenarse en otra tabla.

---

# 36. Separación de roles

Una estructura incorrecta sería:

```text
USUARIO

id_usuario
nombre
nombre_rol
descripcion_rol
```

En ese caso existiría:

```text
id_usuario → nombre_rol
nombre_rol → descripcion_rol
```

Esto produciría una dependencia transitiva.

El modelo utiliza:

```text
ROL
```

y:

```text
USUARIO
```

USUARIO solamente almacena:

```text
id_rol
```

como FK.

Por ello la información del rol no se repite.

---

# 37. Separación de categorías

Una estructura incorrecta sería:

```text
PRODUCTO

id_producto
nombre
categoria
descripcion_categoria
```

Esto ocasionaría:

```text
id_producto → categoria
categoria → descripcion_categoria
```

En el modelo existen:

```text
CATEGORIA
```

y:

```text
PRODUCTO
```

PRODUCTO guarda únicamente:

```text
id_categoria
```

Por lo tanto se elimina la dependencia transitiva.

---

# 38. Separación de unidades de medida

No se almacena dentro de PRODUCTO:

```text
nombre_unidad
abreviatura_unidad
```

En su lugar existe:

```text
UNIDAD_MEDIDA
```

y PRODUCTO almacena:

```text
id_unidad_medida
```

Esto evita repetir:

```text
Kilogramo
kg
```

en muchos productos.

---

# 39. Separación de presentaciones

Las características propias de una presentación no se almacenan directamente en PRODUCTO.

Se utiliza:

```text
PRESENTACION_PRODUCTO
```

para almacenar:

* Nombre de presentación.
* Factor de conversión.
* Código de barras.
* Precio de venta.

Esto permite que un producto tenga varias presentaciones sin repetir sus datos generales.

---

# 40. Separación de proveedores y compras

Una estructura incorrecta sería:

```text
COMPRA

id_compra
nombre_proveedor
telefono_proveedor
direccion_proveedor
```

Esto produciría repetición del proveedor en cada compra.

El modelo utiliza:

```text
PROVEEDOR
```

y:

```text
COMPRA
```

COMPRA solamente conserva:

```text
id_proveedor
```

Por lo tanto:

**No existe dependencia transitiva de los datos del proveedor dentro de COMPRA.**

---

# 41. Separación de usuarios y compras

COMPRA no almacena:

* Nombre del usuario.
* Apellido.
* Rol.

Solamente almacena:

```text
id_usuario
```

La información completa permanece en USUARIO.

---

# 42. Separación de productos comprados

Los productos de una compra no se almacenan en COMPRA.

Se utiliza:

```text
DETALLE_COMPRA
```

Esto resuelve la relación:

```text
COMPRA N : M PRESENTACION_PRODUCTO
```

mediante:

```text
COMPRA
    ↓
DETALLE_COMPRA
    ↑
PRESENTACION_PRODUCTO
```

---

# 43. Separación de lotes

La información específica de lotes no se almacena directamente en PRODUCTO ni en COMPRA.

Se utiliza:

```text
LOTE_PRODUCTO
```

Esto permite manejar diferentes:

* Fechas de vencimiento.
* Códigos de lote.
* Cantidades iniciales.

para un mismo producto.

---

# 44. Separación de ubicaciones

La información de ubicación se encuentra en:

```text
UBICACION
```

mientras:

```text
LOTE_UBICACION
```

relaciona:

```text
LOTE_PRODUCTO N : M UBICACION
```

Esto evita almacenar nombres y descripciones de ubicaciones repetidamente.

---

# 45. Stock y redundancia

No se almacena:

```text
PRODUCTO.stock_actual
```

al mismo tiempo que:

```text
LOTE_UBICACION.cantidad_actual
```

El stock total del producto se obtiene mediante la suma de las cantidades correspondientes.

Ejemplo:

```text
Lote A - Refrigerador = 5
Lote A - Almacén      = 10
Lote B - Almacén      = 7
```

Stock actual:

```text
5 + 10 + 7 = 22
```

Esto evita mantener dos valores de stock que podrían quedar inconsistentes.

---

# 46. Separación de ventas y detalles

VENTA contiene solamente información general.

Los productos vendidos se encuentran en:

```text
DETALLE_VENTA
```

Esto evita repetir información general de la venta por cada producto vendido.

---

# 47. Precio histórico

El precio actual se almacena en:

```text
PRESENTACION_PRODUCTO.precio_venta
```

pero el precio realmente utilizado en una operación se almacena en:

```text
DETALLE_VENTA.precio_unitario
```

Este dato no constituye una redundancia incorrecta.

Representa un hecho histórico propio de la transacción.

Ejemplo:

```text
Precio actual = 12 Bs
```

Una venta realizada anteriormente puede conservar:

```text
precio_unitario = 10 Bs
```

Esto garantiza la trazabilidad histórica.

---

# 48. FIFO y DETALLE_VENTA_LOTE

La relación:

```text
DETALLE_VENTA N : M LOTE_UBICACION
```

se resuelve mediante:

```text
DETALLE_VENTA_LOTE
```

Esto permite registrar exactamente qué existencias participaron en una venta.

Ejemplo:

```text
Venta: 5 unidades

Lote antiguo → 3
Lote nuevo   → 2
```

De esta forma puede comprobarse la aplicación del criterio FIFO.

---

# 49. Pagos normalizados

No se almacenan campos como:

```text
VENTA.monto_efectivo
VENTA.monto_qr
VENTA.comprobante_qr
```

En cambio se utiliza:

```text
PAGO
```

Una venta puede tener uno o varios pagos.

Esto permite manejar:

* Efectivo.
* QR.
* Pago mixto.

sin modificar la estructura de VENTA.

---

# 50. Caja y usuarios

SESION_CAJA almacena:

```text
id_usuario
```

pero no almacena:

* Nombre del usuario.
* Apellido.
* Rol.

Estos datos pueden consultarse mediante su relación con USUARIO.

Esto evita dependencias transitivas.

---

# 51. Arqueos y denominaciones

No se almacena el valor de la denominación repetidamente dentro de cada detalle.

Se utiliza:

```text
DENOMINACION
```

para almacenar:

```text
valor
tipo
estado
```

y:

```text
DETALLE_ARQUEO
```

solamente almacena:

```text
id_denominacion
cantidad
```

Esto evita repetir datos como:

```text
100 Bs - BILLETE
```

en todos los arqueos.

---

# 52. Datos calculados y 3FN

También se evita almacenar información que puede calcularse de manera confiable a partir de los datos existentes cuando no es necesario conservarla como hecho independiente.

## Subtotal de compra

No se almacena.

Se calcula:

```text
cantidad × costo_unitario
```

## Total de compra

Se calcula:

```text
SUM(detalles de compra)
```

## Subtotal de venta

Se calcula:

```text
cantidad × precio_unitario
```

## Total de venta

Se calcula:

```text
SUM(detalles de venta)
```

## Subtotal del arqueo

Se calcula:

```text
valor_denominacion × cantidad
```

## Total contado

Se obtiene:

```text
SUM(subtotales del arqueo)
```

Esto reduce la posibilidad de inconsistencias entre valores almacenados y valores calculados.

---

# 53. Resolución de relaciones N:M

Durante el diseño se identificaron diferentes relaciones muchos a muchos.

Estas relaciones fueron resueltas mediante entidades intermedias.

## Compra y presentación

Relación conceptual:

```text
COMPRA N : M PRESENTACION_PRODUCTO
```

Resolución:

```text
DETALLE_COMPRA
```

---

## Lote y ubicación

Relación:

```text
LOTE_PRODUCTO N : M UBICACION
```

Resolución:

```text
LOTE_UBICACION
```

---

## Venta y presentación

Relación conceptual:

```text
VENTA N : M PRESENTACION_PRODUCTO
```

Resolución:

```text
DETALLE_VENTA
```

---

## Detalle de venta y existencia de lote

Relación:

```text
DETALLE_VENTA N : M LOTE_UBICACION
```

Resolución:

```text
DETALLE_VENTA_LOTE
```

---

## Arqueo y denominación

Relación:

```text
ARQUEO_CAJA N : M DENOMINACION
```

Resolución:

```text
DETALLE_ARQUEO
```

Estas entidades intermedias ayudan a evitar redundancias y permiten almacenar atributos propios de cada relación.

---

# 54. Verificación de las 21 tablas

| Tabla                 | 1FN | 2FN | 3FN |
| --------------------- | --- | --- | --- |
| ROL                   | Sí  | Sí  | Sí  |
| USUARIO               | Sí  | Sí  | Sí  |
| CATEGORIA             | Sí  | Sí  | Sí  |
| UNIDAD_MEDIDA         | Sí  | Sí  | Sí  |
| PRODUCTO              | Sí  | Sí  | Sí  |
| PRESENTACION_PRODUCTO | Sí  | Sí  | Sí  |
| PROVEEDOR             | Sí  | Sí  | Sí  |
| COMPRA                | Sí  | Sí  | Sí  |
| DETALLE_COMPRA        | Sí  | Sí  | Sí  |
| LOTE_PRODUCTO         | Sí  | Sí  | Sí  |
| UBICACION             | Sí  | Sí  | Sí  |
| LOTE_UBICACION        | Sí  | Sí  | Sí  |
| AJUSTE_INVENTARIO     | Sí  | Sí  | Sí  |
| SESION_CAJA           | Sí  | Sí  | Sí  |
| VENTA                 | Sí  | Sí  | Sí  |
| DETALLE_VENTA         | Sí  | Sí  | Sí  |
| DETALLE_VENTA_LOTE    | Sí  | Sí  | Sí  |
| PAGO                  | Sí  | Sí  | Sí  |
| DENOMINACION          | Sí  | Sí  | Sí  |
| ARQUEO_CAJA           | Sí  | Sí  | Sí  |
| DETALLE_ARQUEO        | Sí  | Sí  | Sí  |

---

# 55. Anomalías evitadas

Gracias a la normalización se reducen diferentes tipos de anomalías.

## Anomalía de actualización

Si cambia el teléfono de un proveedor, se modifica solamente:

```text
PROVEEDOR.telefono
```

No es necesario cambiar todas las compras realizadas anteriormente.

---

## Anomalía de inserción

Puede registrarse un producto aunque todavía no haya sido vendido.

También puede registrarse un proveedor antes de realizar una compra.

---

## Anomalía de eliminación

Eliminar o anular una operación no implica eliminar información maestra relacionada.

Por ejemplo, una venta anulada no elimina:

* Producto.
* Presentación.
* Usuario.
* Sesión de caja.

Además, la venta anulada debe conservarse históricamente.

---

# 56. Dependencias funcionales principales

Algunas de las dependencias funcionales principales del modelo son:

```text
id_rol
→ nombre, descripcion
```

```text
id_usuario
→ id_rol, nombre, apellido, nombre_usuario, contrasena, estado
```

```text
id_categoria
→ nombre, descripcion, estado
```

```text
id_unidad_medida
→ nombre, abreviatura
```

```text
id_producto
→ id_categoria, id_unidad_medida, nombre, descripcion, stock_minimo, estado
```

```text
id_presentacion
→ id_producto, nombre_presentacion, factor_conversion, codigo_barras, precio_venta, estado
```

```text
id_compra
→ id_proveedor, id_usuario, fecha_hora, observacion
```

```text
id_detalle_compra
→ id_compra, id_presentacion, cantidad, costo_unitario
```

```text
id_lote
→ id_detalle_compra, codigo_lote, fecha_vencimiento, cantidad_inicial
```

```text
(id_lote, id_ubicacion)
→ cantidad_actual
```

```text
id_venta
→ id_sesion_caja, fecha_hora, estado, motivo_anulacion
```

```text
id_detalle_venta
→ id_venta, id_presentacion, cantidad, precio_unitario
```

```text
(id_detalle_venta, id_lote_ubicacion)
→ cantidad_base
```

```text
id_pago
→ id_venta, metodo_pago, monto, comprobante_qr
```

```text
id_arqueo
→ id_sesion_caja, fecha_hora, observacion
```

```text
(id_arqueo, id_denominacion)
→ cantidad
```

Estas dependencias muestran que los atributos no clave dependen de las claves correspondientes.

---

# 57. Resultado de Tercera Forma Normal

El modelo cumple Tercera Forma Normal porque:

* Cumple 1FN.
* Cumple 2FN.
* Los datos descriptivos se encuentran separados en sus entidades correspondientes.
* No existen dependencias transitivas necesarias entre atributos no clave dentro de las relaciones diseñadas.
* Las relaciones N:M se encuentran resueltas mediante entidades intermedias.
* Los datos calculables no se duplican innecesariamente.
* Las claves foráneas permiten obtener información relacionada sin repetir atributos descriptivos.
* El precio histórico de una venta se conserva como un hecho propio de la transacción.
* El stock total no se duplica dentro de PRODUCTO.

Por lo tanto:

**El modelo relacional de París Licorería cumple Primera, Segunda y Tercera Forma Normal.**

---

# 58. Conclusión

El proceso de normalización permitió verificar que el modelo relacional propuesto para París Licorería posee una estructura organizada y coherente.

La Primera Forma Normal garantiza que los datos sean atómicos y que no existan grupos repetitivos.

La Segunda Forma Normal garantiza que los atributos dependan completamente de las claves correspondientes.

La Tercera Forma Normal elimina dependencias transitivas y evita almacenar repetidamente información perteneciente a otras entidades.

Como resultado, el modelo de 21 tablas permite manejar correctamente:

* Usuarios.
* Roles.
* Productos.
* Categorías.
* Unidades de medida.
* Presentaciones.
* Proveedores.
* Compras.
* Lotes.
* Ubicaciones.
* Inventario.
* Ajustes.
* Ventas.
* FIFO.
* Pagos.
* Caja.
* Arqueos.
* Denominaciones.

El modelo normalizado constituye la base para la siguiente etapa del proyecto: la creación física de la base de datos mediante scripts SQL.
