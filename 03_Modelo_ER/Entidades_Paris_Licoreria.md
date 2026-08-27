# Identificación de Entidades - París Licorería

## 1. Introducción

Las entidades propuestas en este documento fueron identificadas a partir de la entrevista y de los requerimientos definidos para París Licorería.

El objetivo de esta etapa es determinar qué información necesita almacenar la base de datos antes de construir el modelo entidad-relación.

Para cada entidad se analizará:

* Por qué existe.
* Qué problema resuelve.
* Su clave primaria.
* Sus principales atributos.
* Sus claves foráneas.
* Sus relaciones con otras entidades.

La propuesta no busca aumentar artificialmente el número de tablas, sino representar correctamente los procesos reales del negocio y reducir redundancias.

---

# 2. Decisiones de diseño tomadas

Antes de identificar las entidades definitivas se tomaron las siguientes decisiones.

## 2.1 Pago mixto

Se permitirá que una venta pueda pagarse utilizando más de una forma de pago.

Ejemplo:

Venta total:

100 Bs.

Pago:

* 60 Bs en efectivo.
* 40 Bs mediante QR.

Por esta razón no se utilizará únicamente una tabla `PAGO_QR`.

Se propone una entidad general:

`PAGO`

Una venta podrá tener uno o varios registros de pago.

---

## 2.2 Entrega de caja

Por el momento no se creará una entidad `ENTREGA_CAJA`.

La transición entre trabajadores podrá identificarse mediante:

1. Cierre de la sesión del encargado anterior.
2. Apertura de una nueva sesión de caja.
3. Usuario responsable de cada sesión.
4. Monto inicial de la nueva sesión.

Si posteriormente se confirma que debe registrarse formalmente quién entrega dinero a quién, podrá evaluarse nuevamente esta entidad.

---

## 2.3 Historial de precios

Por el momento no se creará una tabla independiente de historial de precios.

La presentación del producto almacenará su precio actual.

Cuando se realice una venta, `DETALLE_VENTA` conservará el precio utilizado en ese momento.

De esta forma, si posteriormente cambia el precio actual del producto, las ventas antiguas conservarán correctamente su precio histórico.

---

# 3. Entidades propuestas

Después de analizar los requerimientos se proponen inicialmente las siguientes entidades:

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
17. PAGO
18. DENOMINACION
19. ARQUEO_CAJA
20. DETALLE_ARQUEO

Estas entidades todavía deberán revisarse mediante sus relaciones y cardinalidades antes de considerarse definitivamente aprobadas.

---

# 4. ROL

## ¿Por qué existe?

Los trabajadores no tendrán las mismas funciones dentro del sistema.

Inicialmente se identificaron:

* Administrador.
* Encargado de venta o caja.

Si se almacenara el nombre del rol directamente en cada usuario se repetiría información.

Por este motivo se utiliza la entidad `ROL`.

## Problema que resuelve

Permite centralizar los tipos de usuario y relacionar varios usuarios con un mismo rol.

## Clave primaria

`id_rol`

## Atributos propuestos

* id_rol
* nombre
* descripcion

## Relación principal

`ROL 1 : N USUARIO`

Un rol puede estar asignado a varios usuarios.

Cada usuario tendrá un rol.

---

# 5. USUARIO

## ¿Por qué existe?

Cada trabajador deberá utilizar su propia cuenta.

Además, necesitamos identificar quién realizó:

* Ventas.
* Compras.
* Sesiones de caja.
* Ajustes de inventario.

## Problema que resuelve

Permite identificar y responsabilizar a cada trabajador por las operaciones realizadas.

## Clave primaria

`id_usuario`

## Atributos propuestos

* id_usuario
* id_rol
* nombre
* apellido
* nombre_usuario
* contrasena
* estado

## Clave foránea

`id_rol → ROL`

## Relaciones principales

`ROL 1 : N USUARIO`

`USUARIO 1 : N COMPRA`

`USUARIO 1 : N SESION_CAJA`

`USUARIO 1 : N AJUSTE_INVENTARIO`

---

# 6. CATEGORIA

## ¿Por qué existe?

Los productos comercializados pertenecen a diferentes grupos.

Por ejemplo:

* Bebidas alcohólicas.
* Gaseosas.
* Dulces.
* Galletas.
* Limpieza.

## Problema que resuelve

Evita almacenar repetidamente el nombre de una categoría dentro de cada producto.

## Clave primaria

`id_categoria`

## Atributos propuestos

* id_categoria
* nombre
* descripcion
* estado

## Relación

`CATEGORIA 1 : N PRODUCTO`

Una categoría puede contener muchos productos.

Cada producto pertenecerá inicialmente a una categoría.

---

# 7. UNIDAD_MEDIDA

## ¿Por qué existe?

No todos los productos se controlan de la misma manera.

Pueden utilizarse unidades como:

* Unidad.
* Gramo.
* Kilogramo.

Las presentaciones comerciales como caja, paquete o fardo se manejarán mediante `PRESENTACION_PRODUCTO`.

## Problema que resuelve

Permite identificar correctamente la unidad base utilizada para controlar las existencias.

## Clave primaria

`id_unidad_medida`

## Atributos propuestos

* id_unidad_medida
* nombre
* abreviatura

## Relación

`UNIDAD_MEDIDA 1 : N PRODUCTO`

---

# 8. PRODUCTO

## ¿Por qué existe?

Es una de las entidades centrales de la base de datos.

Representa cada artículo comercializado por París Licorería.

## Problema que resuelve

Permite almacenar la información general de cada producto una sola vez.

## Clave primaria

`id_producto`

## Atributos propuestos

* id_producto
* id_categoria
* id_unidad_medida
* nombre
* descripcion
* stock_minimo
* estado

## Claves foráneas

`id_categoria → CATEGORIA`

`id_unidad_medida → UNIDAD_MEDIDA`

## Observación importante

No se almacenará obligatoriamente un campo `stock_actual` en esta entidad.

La existencia podrá determinarse mediante los lotes disponibles.

Esto evita mantener varias cantidades duplicadas que puedan quedar inconsistentes.

## Relaciones

`CATEGORIA 1 : N PRODUCTO`

`UNIDAD_MEDIDA 1 : N PRODUCTO`

`PRODUCTO 1 : N PRESENTACION_PRODUCTO`

---

# 9. PRESENTACION_PRODUCTO

## ¿Por qué existe?

Un mismo producto puede venderse de distintas formas.

Ejemplo:

Coca Cola:

* Unidad.
* Paquete.
* Caja.

Cada forma de venta puede tener:

* Precio diferente.
* Código de barras diferente.
* Cantidad equivalente diferente.

## Problema que resuelve

Evita crear un producto diferente para cada presentación comercial.

## Clave primaria

`id_presentacion`

## Atributos propuestos

* id_presentacion
* id_producto
* nombre_presentacion
* factor_conversion
* codigo_barras
* precio_venta
* estado

## Clave foránea

`id_producto → PRODUCTO`

## Factor de conversión

Indica cuántas unidades base representa una presentación.

Ejemplo:

Producto:

Cerveza individual.

Presentaciones:

Unidad → factor 1

Pack de 6 → factor 6

Caja de 24 → factor 24

Esto permitirá descontar correctamente el inventario aunque se venda utilizando diferentes presentaciones.

## Código de barras

El código de barras se propone aquí y no directamente en `PRODUCTO` porque diferentes presentaciones físicas pueden tener códigos de barras diferentes.

## Relaciones

`PRODUCTO 1 : N PRESENTACION_PRODUCTO`

`PRESENTACION_PRODUCTO 1 : N DETALLE_COMPRA`

`PRESENTACION_PRODUCTO 1 : N DETALLE_VENTA`

---

# 10. PROVEEDOR

## ¿Por qué existe?

La mercadería proviene de diferentes distribuidores y empresas.

## Problema que resuelve

Permite conservar de manera organizada la información de los proveedores.

## Clave primaria

`id_proveedor`

## Atributos propuestos

* id_proveedor
* nombre
* contacto
* telefono
* direccion
* estado

## Relación

`PROVEEDOR 1 : N COMPRA`

Un proveedor puede aparecer en muchas compras.

Cada compra pertenece a un proveedor.

## Decisión importante

No se necesita inicialmente una tabla `PRODUCTO_PROVEEDOR`.

Podemos conocer qué proveedores han suministrado cada producto mediante:

`PROVEEDOR → COMPRA → DETALLE_COMPRA → PRESENTACION_PRODUCTO → PRODUCTO`

Esto evita crear una relación adicional que actualmente no necesitamos.

---

# 11. COMPRA

## ¿Por qué existe?

La dueña realiza compras de mercadería para reponer el inventario.

Una compra puede contener varios productos.

## Problema que resuelve

Permite almacenar los datos generales de cada operación de compra.

## Clave primaria

`id_compra`

## Atributos propuestos

* id_compra
* id_proveedor
* id_usuario
* fecha_hora
* observacion

## Claves foráneas

`id_proveedor → PROVEEDOR`

`id_usuario → USUARIO`

## Relaciones

`PROVEEDOR 1 : N COMPRA`

`USUARIO 1 : N COMPRA`

`COMPRA 1 : N DETALLE_COMPRA`

## Total de compra

El total puede calcularse sumando los detalles de compra.

Por ello inicialmente no es obligatorio almacenar un campo redundante `total`.

---

# 12. DETALLE_COMPRA

## ¿Por qué existe?

Una compra puede contener varios productos y una misma presentación puede aparecer en muchas compras.

Existe una relación:

`COMPRA N : M PRESENTACION_PRODUCTO`

Esta relación debe resolverse mediante una entidad intermedia.

## Problema que resuelve

Permite registrar los productos adquiridos dentro de cada compra.

## Clave primaria

`id_detalle_compra`

## Atributos propuestos

* id_detalle_compra
* id_compra
* id_presentacion
* cantidad
* costo_unitario

## Claves foráneas

`id_compra → COMPRA`

`id_presentacion → PRESENTACION_PRODUCTO`

## Relaciones

`COMPRA 1 : N DETALLE_COMPRA`

`PRESENTACION_PRODUCTO 1 : N DETALLE_COMPRA`

`DETALLE_COMPRA 1 : N LOTE_PRODUCTO`

## Subtotal

No es obligatorio almacenar el subtotal porque puede calcularse:

`cantidad × costo_unitario`

---

# 13. LOTE_PRODUCTO

## ¿Por qué existe?

Pueden ingresar nuevas cantidades de un producto mientras todavía existe mercadería anterior.

Además, algunos productos tienen fecha de vencimiento.

Se debe aplicar FIFO.

## Problema que resuelve

Permite distinguir físicamente diferentes ingresos de mercadería del mismo producto.

## Clave primaria

`id_lote`

## Atributos propuestos

* id_lote
* id_detalle_compra
* codigo_lote
* fecha_vencimiento
* cantidad_inicial

## Clave foránea

`id_detalle_compra → DETALLE_COMPRA`

## Observación

`fecha_vencimiento` podrá ser nula cuando el producto no maneje vencimiento.

`codigo_lote` también podrá ser opcional cuando el proveedor no entregue un identificador físico de lote.

## ¿Por qué se relaciona con DETALLE_COMPRA?

Porque todo lote ingresado debe poder rastrearse hasta la compra mediante la cual llegó.

Desde `DETALLE_COMPRA` también podemos determinar:

* Qué presentación se compró.
* Qué producto corresponde.
* Qué costo tuvo.
* Qué proveedor lo suministró.
* Cuándo se realizó la compra.

## Relación

`DETALLE_COMPRA 1 : N LOTE_PRODUCTO`

Un detalle de compra podría generar uno o varios lotes cuando sea necesario.

---

# 14. UBICACION

## ¿Por qué existe?

Los productos pueden encontrarse en diferentes lugares.

Por ejemplo:

* Refrigerador.
* Estante.
* Vitrina.
* Almacén.

## Problema que resuelve

Permite identificar las áreas físicas donde se guarda la mercadería.

## Clave primaria

`id_ubicacion`

## Atributos propuestos

* id_ubicacion
* nombre
* descripcion
* estado

---

# 15. LOTE_UBICACION

## ¿Por qué existe?

Inicialmente se había propuesto:

`PRODUCTO_UBICACION`

Sin embargo, después de analizar los lotes aparece un problema.

Si solamente sabemos:

`Producto A → Refrigerador → 10 unidades`

no podemos saber a qué lote pertenecen esas 10 unidades.

Esto dificulta aplicar correctamente FIFO y controlar vencimientos.

Por eso resulta más coherente relacionar:

`LOTE_PRODUCTO`

con:

`UBICACION`

## Problema que resuelve

Permite saber cuánto existe de cada lote en cada ubicación.

## Relación original

`LOTE_PRODUCTO N : M UBICACION`

La entidad `LOTE_UBICACION` resuelve esa relación muchos a muchos.

## Clave primaria

`id_lote_ubicacion`

## Atributos propuestos

* id_lote_ubicacion
* id_lote
* id_ubicacion
* cantidad_actual

## Claves foráneas

`id_lote → LOTE_PRODUCTO`

`id_ubicacion → UBICACION`

## Restricción recomendada

La combinación:

`id_lote + id_ubicacion`

deberá ser única.

## Ventaja

El stock de un producto puede obtenerse sumando las cantidades disponibles de sus lotes.

El stock por ubicación también puede calcularse utilizando esta entidad.

Por ello ya no necesitamos mantener simultáneamente:

* stock en PRODUCTO
* stock por PRODUCTO_UBICACION
* stock por LOTE

con valores repetidos.

---

# 16. AJUSTE_INVENTARIO

## ¿Por qué existe?

Las existencias no disminuyen únicamente mediante ventas.

También pueden existir:

* Productos dañados.
* Productos perdidos.
* Productos vencidos.
* Ajustes manuales justificados.

Necesitamos conservar la causa de esas disminuciones.

## Problema que resuelve

Evita modificar simplemente una cantidad sin saber por qué cambió.

## Clave primaria

`id_ajuste`

## Atributos propuestos

* id_ajuste
* id_lote_ubicacion
* id_usuario
* fecha_hora
* tipo_ajuste
* cantidad
* observacion

## Claves foráneas

`id_lote_ubicacion → LOTE_UBICACION`

`id_usuario → USUARIO`

## Ejemplos de tipo de ajuste

* DAÑADO
* PERDIDO
* VENCIDO
* OTRO

## Relaciones

`LOTE_UBICACION 1 : N AJUSTE_INVENTARIO`

`USUARIO 1 : N AJUSTE_INVENTARIO`

---

# 17. SESION_CAJA

## ¿Por qué existe?

La licorería trabaja mediante diferentes turnos.

Cada trabajador debe ser responsable de la caja durante un período determinado.

## Problema que resuelve

Evita manejar todas las operaciones del día como si pertenecieran a una única caja sin responsable.

## Clave primaria

`id_sesion_caja`

## Atributos propuestos

* id_sesion_caja
* id_usuario
* fecha_hora_apertura
* monto_inicial
* fecha_hora_cierre
* estado
* observacion

## Clave foránea

`id_usuario → USUARIO`

## Relaciones

`USUARIO 1 : N SESION_CAJA`

`SESION_CAJA 1 : N VENTA`

`SESION_CAJA 1 : 0..1 ARQUEO_CAJA`

## Observación

No se crea por ahora una entidad independiente `TURNO`, debido a que todavía no se han definido turnos fijos con horarios y características propias.

La sesión de caja ya permite conocer exactamente qué usuario estuvo trabajando y durante qué período.

---

# 18. VENTA

## ¿Por qué existe?

Representa cada operación de venta realizada en el negocio.

## Problema que resuelve

Permite almacenar la información general de cada transacción comercial.

## Clave primaria

`id_venta`

## Atributos propuestos

* id_venta
* id_sesion_caja
* fecha_hora
* estado
* motivo_anulacion

## Clave foránea

`id_sesion_caja → SESION_CAJA`

## Estados posibles

Por ejemplo:

* VIGENTE
* ANULADA

## Anulación

Una venta anulada no será eliminada físicamente.

Su estado cambiará y se conservará el motivo correspondiente.

## Relaciones

`SESION_CAJA 1 : N VENTA`

`VENTA 1 : N DETALLE_VENTA`

`VENTA 1 : N PAGO`

## Total

El total de venta puede calcularse a partir de sus detalles.

---

# 19. DETALLE_VENTA

## ¿Por qué existe?

Una venta puede incluir varios productos.

Al mismo tiempo, una presentación puede aparecer en muchas ventas.

Existe:

`VENTA N : M PRESENTACION_PRODUCTO`

Por ello se necesita una entidad intermedia.

## Problema que resuelve

Permite registrar cada artículo incluido en una venta.

## Clave primaria

`id_detalle_venta`

## Atributos propuestos

* id_detalle_venta
* id_venta
* id_presentacion
* cantidad
* precio_unitario

## Claves foráneas

`id_venta → VENTA`

`id_presentacion → PRESENTACION_PRODUCTO`

## Precio unitario

Este atributo es especialmente importante.

Aunque `PRESENTACION_PRODUCTO` tenga actualmente un precio de venta, `DETALLE_VENTA` debe conservar el precio realmente utilizado cuando ocurrió la venta.

Ejemplo:

Hoy:

Cerveza = 10 Bs.

Mañana:

Cerveza = 12 Bs.

Una venta realizada hoy debe continuar mostrando 10 Bs aunque posteriormente se actualice el precio del producto.

## Subtotal

Puede calcularse mediante:

`cantidad × precio_unitario`

---

# 20. PAGO

## ¿Por qué existe?

Una venta puede pagarse:

* En efectivo.
* Mediante QR.
* Utilizando una combinación de ambos.

## Problema de la propuesta anterior

Anteriormente se planteó únicamente:

`PAGO_QR`

Eso funciona para pagos QR, pero complica el pago mixto.

## Nueva solución

Crear una entidad general:

`PAGO`

## Clave primaria

`id_pago`

## Atributos propuestos

* id_pago
* id_venta
* metodo_pago
* monto
* comprobante_qr

## Clave foránea

`id_venta → VENTA`

## Relación

`VENTA 1 : N PAGO`

## Ejemplo

Venta:

100 Bs.

PAGO 1:

* Método: EFECTIVO
* Monto: 60 Bs.

PAGO 2:

* Método: QR
* Monto: 40 Bs.
* Comprobante: imagen correspondiente.

## Regla

La suma de los pagos válidos de una venta deberá coincidir con el total de la venta.

## Comprobante QR

Será obligatorio únicamente cuando el método utilizado sea QR.

---

# 21. DENOMINACION

## ¿Por qué existe?

Durante el arqueo se cuentan diferentes billetes y monedas.

Por ejemplo:

* 100 Bs.
* 50 Bs.
* 20 Bs.
* 10 Bs.
* 5 Bs.
* 1 Bs.
* 0.50 Bs.

Si almacenáramos el valor directamente en cada detalle de cada arqueo repetiríamos constantemente la misma información.

## Problema que resuelve

Centraliza las denominaciones monetarias utilizadas.

## Clave primaria

`id_denominacion`

## Atributos propuestos

* id_denominacion
* valor
* tipo
* estado

## Ejemplos de tipo

* BILLETE
* MONEDA

## Relación

`DENOMINACION 1 : N DETALLE_ARQUEO`

---

# 22. ARQUEO_CAJA

## ¿Por qué existe?

Al finalizar una sesión de caja el encargado debe contar físicamente el dinero.

## Problema que resuelve

Permite conservar el registro del arqueo realizado para cada sesión.

## Clave primaria

`id_arqueo`

## Atributos propuestos

* id_arqueo
* id_sesion_caja
* fecha_hora
* observacion

## Clave foránea

`id_sesion_caja → SESION_CAJA`

## Restricción

Una sesión deberá tener como máximo un arqueo de cierre.

Por ello:

`id_sesion_caja`

deberá ser único dentro de `ARQUEO_CAJA`.

## Relación

`SESION_CAJA 1 : 0..1 ARQUEO_CAJA`

Una sesión abierta todavía puede no tener arqueo.

Una sesión cerrada deberá tener su arqueo correspondiente.

## Valores calculados

El total contado puede calcularse a partir de `DETALLE_ARQUEO`.

El efectivo esperado puede calcularse utilizando:

* Monto inicial.
* Pagos en efectivo válidos realizados durante la sesión.

La diferencia puede calcularse mediante:

`efectivo contado - efectivo esperado`

Esto evita almacenar varios valores que pueden obtenerse de la información existente.

---

# 23. DETALLE_ARQUEO

## ¿Por qué existe?

Un arqueo contiene varias denominaciones.

Una misma denominación aparecerá en diferentes arqueos.

Existe:

`ARQUEO_CAJA N : M DENOMINACION`

Esta relación se resuelve mediante `DETALLE_ARQUEO`.

## Clave primaria

`id_detalle_arqueo`

## Atributos propuestos

* id_detalle_arqueo
* id_arqueo
* id_denominacion
* cantidad

## Claves foráneas

`id_arqueo → ARQUEO_CAJA`

`id_denominacion → DENOMINACION`

## Restricción recomendada

La combinación:

`id_arqueo + id_denominacion`

deberá ser única.

## Subtotal

No es necesario almacenarlo.

Puede calcularse:

`valor de denominación × cantidad`

---

# 24. Cambios respecto a la propuesta inicial

La propuesta original tenía aproximadamente 19 tablas.

Después de revisar los requerimientos se realizaron cambios importantes.

## PAGO_QR

Antes:

`PAGO_QR`

Ahora:

`PAGO`

### Razón

`PAGO` permite:

* Efectivo.
* QR.
* Pago mixto.

Por ello resulta más flexible y normalizado.

---

## PRODUCTO_UBICACION

Antes:

`PRODUCTO_UBICACION`

Ahora:

`LOTE_UBICACION`

### Razón

Si se controla FIFO y vencimientos, resulta más preciso conocer qué lote está almacenado en cada ubicación.

Además se evita duplicar cantidades de stock en diferentes tablas.

---

## ENTREGA_CAJA

Antes:

`ENTREGA_CAJA`

Ahora:

No se utilizará por el momento.

### Razón

La necesidad real de registrar una entrega independiente todavía no fue confirmada.

El cambio de responsable puede identificarse mediante el cierre de una sesión y la apertura de la siguiente.

---

## AJUSTE_INVENTARIO

Antes:

No existía en la propuesta inicial.

Ahora:

Se propone `AJUSTE_INVENTARIO`.

### Razón

Los requerimientos indican que deben registrarse productos:

* Dañados.
* Perdidos.
* Vencidos.

Sin esta entidad solamente modificaríamos una cantidad y perderíamos la explicación de por qué disminuyó el inventario.

---

## DENOMINACION

Antes:

La denominación estaba directamente dentro de `DETALLE_ARQUEO`.

Ahora:

Se propone una entidad `DENOMINACION`.

### Razón

Los valores 100, 50, 20, 10, etc. se repiten en todos los arqueos.

Separarlos permite reutilizar las denominaciones y mantener una estructura más normalizada.

---

# 25. Entidades que NO se crearán por ahora

## CLIENTE

No se necesita porque París Licorería:

* No registra clientes.
* No vende al fiado.
* No maneja cuentas por cobrar.

---

## ENTREGA_CAJA

No se crea hasta confirmar que la entrega entre trabajadores necesita información propia independiente.

---

## HISTORIAL_PRECIO

No se crea por ahora.

El precio vigente estará en `PRESENTACION_PRODUCTO`.

El precio histórico utilizado se conservará en `DETALLE_VENTA`.

---

## PRODUCTO_PROVEEDOR

No se considera necesaria actualmente.

La relación puede determinarse mediante las compras realizadas.

---

## TURNO

No se crea todavía porque no se han definido turnos permanentes como registros independientes.

`SESION_CAJA` permite conocer:

* Responsable.
* Inicio.
* Fin.

---

# 26. Resumen de claves primarias

| Entidad               | Clave primaria    |
| --------------------- | ----------------- |
| ROL                   | id_rol            |
| USUARIO               | id_usuario        |
| CATEGORIA             | id_categoria      |
| UNIDAD_MEDIDA         | id_unidad_medida  |
| PRODUCTO              | id_producto       |
| PRESENTACION_PRODUCTO | id_presentacion   |
| PROVEEDOR             | id_proveedor      |
| COMPRA                | id_compra         |
| DETALLE_COMPRA        | id_detalle_compra |
| LOTE_PRODUCTO         | id_lote           |
| UBICACION             | id_ubicacion      |
| LOTE_UBICACION        | id_lote_ubicacion |
| AJUSTE_INVENTARIO     | id_ajuste         |
| SESION_CAJA           | id_sesion_caja    |
| VENTA                 | id_venta          |
| DETALLE_VENTA         | id_detalle_venta  |
| PAGO                  | id_pago           |
| DENOMINACION          | id_denominacion   |
| ARQUEO_CAJA           | id_arqueo         |
| DETALLE_ARQUEO        | id_detalle_arqueo |

---

# 27. Resumen de relaciones principales

`ROL 1 : N USUARIO`

`CATEGORIA 1 : N PRODUCTO`

`UNIDAD_MEDIDA 1 : N PRODUCTO`

`PRODUCTO 1 : N PRESENTACION_PRODUCTO`

`PROVEEDOR 1 : N COMPRA`

`USUARIO 1 : N COMPRA`

`COMPRA 1 : N DETALLE_COMPRA`

`PRESENTACION_PRODUCTO 1 : N DETALLE_COMPRA`

`DETALLE_COMPRA 1 : N LOTE_PRODUCTO`

`LOTE_PRODUCTO N : M UBICACION`

Relación resuelta mediante:

`LOTE_UBICACION`

`LOTE_UBICACION 1 : N AJUSTE_INVENTARIO`

`USUARIO 1 : N AJUSTE_INVENTARIO`

`USUARIO 1 : N SESION_CAJA`

`SESION_CAJA 1 : N VENTA`

`VENTA 1 : N DETALLE_VENTA`

`PRESENTACION_PRODUCTO 1 : N DETALLE_VENTA`

`VENTA 1 : N PAGO`

`SESION_CAJA 1 : 0..1 ARQUEO_CAJA`

`ARQUEO_CAJA 1 : N DETALLE_ARQUEO`

`DENOMINACION 1 : N DETALLE_ARQUEO`

---

# 28. Conclusión

Después de analizar la entrevista y los requerimientos se propone inicialmente un modelo compuesto por 20 entidades.

La nueva propuesta mejora varios aspectos del planteamiento inicial:

* Permite pagos mixtos mediante `PAGO`.
* Evita una tabla exclusiva para QR.
* Controla ubicaciones por lote mediante `LOTE_UBICACION`.
* Permite registrar pérdidas y vencimientos mediante `AJUSTE_INVENTARIO`.
* Evita crear `ENTREGA_CAJA` sin una necesidad confirmada.
* Permite conservar precios históricos mediante `DETALLE_VENTA` sin crear inicialmente un historial independiente.
* Evita duplicar innecesariamente información de stock.
* Mantiene separados los encabezados y detalles de compras, ventas y arqueos.

La siguiente etapa será revisar visualmente todas estas relaciones, confirmar sus cardinalidades y construir el modelo entidad-relación en Draw.io.
