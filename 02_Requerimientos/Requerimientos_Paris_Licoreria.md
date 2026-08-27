# Requerimientos del Sistema - París Licorería

## 1. Introducción

Los siguientes requerimientos fueron identificados a partir de la entrevista realizada en París Licorería.

Su propósito es definir las funciones que deberá realizar el sistema, las condiciones que deberá cumplir y las reglas propias del funcionamiento del negocio.

Los requerimientos servirán posteriormente como base para identificar las entidades, atributos y relaciones necesarias para diseñar el modelo entidad-relación y el modelo relacional de la base de datos.

---

# 2. Requerimientos funcionales

## 2.1 Usuarios y roles

### RF01. Registrar usuarios

El sistema deberá permitir al administrador registrar nuevos usuarios para los trabajadores que tendrán acceso al sistema.

### RF02. Iniciar sesión

El sistema deberá permitir que cada usuario inicie sesión utilizando sus propias credenciales.

### RF03. Gestionar roles

El sistema deberá permitir diferenciar los permisos y funciones correspondientes al administrador y al encargado de venta o caja.

### RF04. Modificar usuarios

El sistema deberá permitir al administrador modificar la información de los usuarios registrados cuando sea necesario.

### RF05. Desactivar usuarios

El sistema deberá permitir al administrador desactivar usuarios que ya no deban tener acceso al sistema, sin eliminar la información histórica relacionada con sus operaciones.

---

## 2.2 Productos y categorías

### RF06. Registrar productos

El sistema deberá permitir al administrador registrar los productos comercializados por París Licorería.

### RF07. Modificar productos

El sistema deberá permitir al administrador modificar la información de los productos registrados.

### RF08. Registrar categorías

El sistema deberá permitir registrar categorías para clasificar los diferentes tipos de productos.

### RF09. Asignar categorías a los productos

El sistema deberá permitir relacionar cada producto con la categoría que le corresponda.

### RF10. Registrar unidades de medida

El sistema deberá permitir registrar las unidades de medida utilizadas para controlar los productos.

Entre ellas podrán encontrarse:

* Unidad.
* Gramo.
* Kilogramo.
* Paquete.
* Caja.
* Fardo.

### RF11. Registrar presentaciones de productos

El sistema deberá permitir registrar las diferentes presentaciones en las que puede comercializarse un producto.

Por ejemplo:

* Unidad.
* Paquete.
* Caja.

### RF12. Asignar precios a las presentaciones

El sistema deberá permitir establecer el precio de venta correspondiente a cada presentación de un producto cuando existan diferentes formas de comercialización.

### RF13. Actualizar precios

El sistema deberá permitir al administrador modificar los precios de venta cuando sea necesario.

---

## 2.3 Código de barras y búsqueda de productos

### RF14. Registrar código de barras

El sistema deberá permitir almacenar el código de barras de los productos que dispongan de uno.

### RF15. Buscar productos mediante código de barras

El sistema deberá permitir localizar un producto utilizando su código de barras.

### RF16. Escanear códigos de barras

El sistema deberá permitir utilizar la cámara de un dispositivo móvil para escanear el código de barras de un producto durante el registro de una venta.

### RF17. Buscar productos manualmente

El sistema deberá permitir buscar productos manualmente cuando no tengan código de barras o cuando no pueda utilizarse el escáner.

La búsqueda podrá realizarse utilizando información registrada del producto, como nombre o categoría.

---

## 2.4 Productos vendidos por peso

### RF18. Manejar cantidades decimales

El sistema deberá permitir registrar cantidades decimales para aquellos productos que sean controlados o vendidos por peso.

Por ejemplo:

* 0.50 kg.
* 1.25 kg.
* 250 g.

### RF19. Registrar ventas de productos por peso

El sistema deberá permitir registrar ventas parciales de productos cuya cantidad se encuentre expresada en gramos, kilogramos u otra unidad de medida correspondiente.

---

## 2.5 Inventario y stock

### RF20. Consultar stock

El sistema deberá permitir consultar la cantidad disponible de los productos.

### RF21. Definir stock mínimo

El sistema deberá permitir establecer una cantidad mínima de existencia para los productos que requieran control de reposición.

### RF22. Identificar productos con bajo stock

El sistema deberá identificar los productos cuya existencia haya alcanzado o sea inferior al stock mínimo establecido.

### RF23. Identificar productos agotados

El sistema deberá permitir identificar los productos cuya existencia disponible sea igual a cero.

### RF24. Actualizar stock mediante compras

El sistema deberá aumentar la existencia disponible de los productos cuando se registre correctamente el ingreso de mercadería mediante una compra.

### RF25. Actualizar stock mediante ventas

El sistema deberá disminuir la existencia disponible correspondiente cuando se registre una venta válida.

### RF26. Registrar pérdidas de inventario

El sistema deberá permitir registrar disminuciones de inventario ocasionadas por productos dañados, perdidos, vencidos u otras causas justificadas.

---

## 2.6 Ubicación de productos

### RF27. Registrar ubicaciones

El sistema deberá permitir registrar las diferentes ubicaciones físicas utilizadas dentro del negocio.

Por ejemplo:

* Refrigerador.
* Estante.
* Vitrina.
* Almacén.

### RF28. Asignar productos a ubicaciones

El sistema deberá permitir indicar en qué ubicación o ubicaciones se encuentra cada producto.

### RF29. Controlar cantidades por ubicación

El sistema deberá permitir conocer la cantidad de un producto existente en cada ubicación cuando un mismo producto se encuentre distribuido en diferentes lugares.

---

## 2.7 Lotes y vencimientos

### RF30. Registrar lotes de productos

El sistema deberá permitir registrar los diferentes lotes de mercadería que ingresen al negocio.

### RF31. Registrar información del lote

El sistema deberá permitir almacenar información relacionada con cada lote, incluyendo cuando corresponda:

* Producto.
* Fecha de ingreso.
* Fecha de vencimiento.
* Cantidad inicial.
* Cantidad disponible.
* Costo de compra.

### RF32. Controlar salida de productos mediante FIFO

El sistema deberá permitir controlar que, cuando existan diferentes lotes disponibles de un mismo producto, se utilice primero la mercadería que ingresó anteriormente.

### RF33. Controlar fechas de vencimiento

El sistema deberá permitir registrar y consultar las fechas de vencimiento de los productos o lotes que las posean.

### RF34. Identificar productos vencidos

El sistema deberá permitir identificar los productos o lotes cuya fecha de vencimiento haya sido alcanzada.

### RF35. Retirar productos vencidos del inventario disponible

El sistema deberá permitir registrar la salida de productos vencidos para que no continúen formando parte de la existencia disponible para venta.

---

## 2.8 Proveedores

### RF36. Registrar proveedores

El sistema deberá permitir al administrador registrar los proveedores o empresas que suministran productos al negocio.

### RF37. Registrar información de contacto del proveedor

El sistema deberá permitir almacenar información del proveedor, como:

* Nombre o razón social.
* Persona de contacto.
* Teléfono.
* Dirección.
* Otra información necesaria para identificarlo.

### RF38. Modificar proveedores

El sistema deberá permitir actualizar la información de los proveedores registrados.

### RF39. Consultar proveedores

El sistema deberá permitir consultar los proveedores registrados y la información disponible de cada uno.

---

## 2.9 Compras

### RF40. Registrar compras

El sistema deberá permitir registrar las compras de mercadería realizadas por la dueña o por el usuario autorizado.

### RF41. Relacionar una compra con un proveedor

El sistema deberá permitir identificar el proveedor correspondiente a cada compra registrada.

### RF42. Registrar productos de una compra

El sistema deberá permitir registrar uno o varios productos dentro de una misma compra.

### RF43. Registrar detalle de compra

Por cada producto comprado, el sistema deberá permitir registrar información como:

* Producto.
* Cantidad.
* Costo de compra.
* Información relacionada con el lote cuando corresponda.

### RF44. Calcular total de compra

El sistema deberá permitir obtener el total correspondiente a una compra a partir de sus productos y costos registrados.

### RF45. Identificar al responsable de la compra

El sistema deberá permitir conocer qué usuario registró cada compra.

### RF46. Consultar compras

El sistema deberá permitir consultar las compras realizadas y su información relacionada.

---

## 2.10 Ventas

### RF47. Registrar ventas

El sistema deberá permitir al encargado de venta o caja registrar las ventas realizadas en el negocio.

### RF48. Registrar productos de una venta

El sistema deberá permitir incluir uno o varios productos dentro de una misma venta.

### RF49. Registrar detalle de venta

Por cada producto vendido, el sistema deberá conservar información como:

* Producto o presentación.
* Cantidad vendida.
* Precio utilizado.
* Subtotal correspondiente.

### RF50. Calcular total de venta

El sistema deberá calcular el total de una venta a partir de los productos, cantidades y precios registrados.

### RF51. Registrar fecha y hora de venta

El sistema deberá conservar la fecha y hora en que se realizó cada venta.

### RF52. Identificar al usuario que realizó la venta

El sistema deberá permitir conocer qué trabajador registró cada venta.

### RF53. Relacionar la venta con una sesión de caja

El sistema deberá permitir identificar la sesión de caja en la cual se realizó cada venta.

### RF54. Consultar ventas

El sistema deberá permitir al usuario autorizado consultar las ventas registradas.

---

## 2.11 Pagos

### RF55. Registrar pagos en efectivo

El sistema deberá permitir registrar ventas pagadas mediante efectivo.

### RF56. Registrar pagos mediante QR

El sistema deberá permitir registrar ventas pagadas mediante QR.

### RF57. Registrar monto pagado

El sistema deberá permitir almacenar el monto correspondiente al pago realizado.

### RF58. Registrar comprobante QR

El sistema deberá permitir asociar a una venta pagada mediante QR una imagen del comprobante de pago.

### RF59. Consultar información de pagos

El sistema deberá permitir consultar la forma de pago y la información relacionada con una venta.

---

## 2.12 Anulación de ventas

### RF60. Anular ventas

El sistema deberá permitir anular una venta cuando exista una causa válida.

### RF61. Registrar motivo de anulación

El sistema deberá exigir el registro de un motivo cuando una venta sea anulada.

### RF62. Conservar ventas anuladas

El sistema deberá mantener la información histórica de una venta anulada en lugar de eliminarla físicamente de la base de datos.

### RF63. Identificar estado de una venta

El sistema deberá permitir distinguir si una venta se encuentra vigente o anulada.

---

## 2.13 Sesiones de caja y turnos

### RF64. Abrir sesión de caja

El sistema deberá permitir que el encargado inicie una sesión de caja al comenzar su turno.

### RF65. Registrar monto inicial

El sistema deberá permitir registrar el monto inicial de efectivo existente al momento de abrir una sesión de caja.

### RF66. Identificar responsable de la sesión

El sistema deberá relacionar cada sesión de caja con el usuario encargado de dicha sesión.

### RF67. Registrar hora de apertura

El sistema deberá conservar la fecha y hora en que comenzó cada sesión de caja.

### RF68. Cerrar sesión de caja

El sistema deberá permitir cerrar una sesión de caja al finalizar el turno correspondiente.

### RF69. Registrar hora de cierre

El sistema deberá conservar la fecha y hora en que fue cerrada cada sesión de caja.

### RF70. Consultar sesiones de caja

El sistema deberá permitir consultar las sesiones de caja registradas y el usuario responsable de cada una.

---

## 2.14 Arqueo de caja

### RF71. Registrar arqueo de caja

El sistema deberá permitir realizar y registrar el arqueo correspondiente al cierre de una sesión de caja.

### RF72. Registrar denominaciones

El sistema deberá permitir registrar las diferentes denominaciones de billetes y monedas encontradas durante el arqueo.

Por ejemplo:

* 100 Bs.
* 50 Bs.
* 20 Bs.
* 10 Bs.
* 5 Bs.
* 1 Bs.
* 0.50 Bs.

### RF73. Registrar cantidad por denominación

El sistema deberá permitir indicar cuántos billetes o monedas existen de cada denominación.

### RF74. Calcular subtotal por denominación

El sistema deberá calcular el subtotal correspondiente a cada denominación utilizando su valor y la cantidad registrada.

### RF75. Calcular efectivo contado

El sistema deberá calcular el total de efectivo contado durante el arqueo.

### RF76. Calcular efectivo esperado

El sistema deberá permitir determinar el monto de efectivo que debería existir en caja de acuerdo con la sesión y las operaciones registradas.

### RF77. Calcular diferencia de caja

El sistema deberá calcular la diferencia entre el dinero esperado y el dinero contado.

### RF78. Registrar observación de diferencia

El sistema deberá permitir guardar una observación o explicación cuando exista una diferencia de caja.

### RF79. Consultar historial de arqueos

El sistema deberá permitir al administrador consultar los arqueos realizados anteriormente.

---

## 2.15 Reportes y consultas

### RF80. Consultar ventas diarias

El sistema deberá permitir consultar las ventas realizadas durante un día determinado.

### RF81. Consultar ventas semanales

El sistema deberá permitir consultar las ventas realizadas durante un período semanal.

### RF82. Consultar ventas mensuales

El sistema deberá permitir consultar las ventas realizadas durante un período mensual.

### RF83. Consultar productos más vendidos

El sistema deberá permitir obtener información sobre los productos con mayor cantidad de ventas.

### RF84. Consultar productos con bajo stock

El sistema deberá permitir obtener un listado de productos que hayan alcanzado o se encuentren por debajo de su stock mínimo.

### RF85. Consultar productos agotados

El sistema deberá permitir obtener un listado de productos sin existencia disponible.

### RF86. Consultar inventario

El sistema deberá permitir al administrador consultar información general sobre las existencias de productos.

### RF87. Consultar compras realizadas

El sistema deberá permitir obtener información sobre las compras registradas.

### RF88. Consultar cierres de caja

El sistema deberá permitir a la administradora revisar el historial de sesiones y cierres de caja.

### RF89. Consultar diferencias de caja

El sistema deberá permitir consultar las diferencias detectadas en los arqueos realizados.

---

# 3. Requerimientos no funcionales

Los siguientes requerimientos no funcionales se derivan de las condiciones de operación mencionadas durante el levantamiento de información. No se establecen requisitos de rendimiento, copias de seguridad o disponibilidad porque estos aspectos todavía no fueron definidos durante la entrevista.

### RNF01. Control de acceso

El sistema deberá restringir las funciones disponibles de acuerdo con el rol del usuario autenticado.

### RNF02. Identificación individual de usuarios

Las operaciones que requieran responsabilidad individual deberán poder relacionarse con el usuario que las realizó.

### RNF03. Compatibilidad con cantidades decimales

La base de datos y el sistema deberán permitir manejar cantidades decimales para productos vendidos o controlados por peso.

### RNF04. Precisión de valores monetarios

La base de datos deberá permitir almacenar valores monetarios con decimales, incluyendo denominaciones como 0.50 Bs.

### RNF05. Compatibilidad con escaneo móvil

La funcionalidad de lectura de códigos de barras deberá contemplar el uso de la cámara de un dispositivo móvil.

### RNF06. Conservación de información histórica

Las operaciones que deban conservarse para fines de control, como las ventas anuladas, no deberán eliminarse físicamente cuando la regla del negocio requiera mantener su historial.

### RNF07. Integridad de la información

La información relacionada con compras, ventas, inventario, sesiones de caja y arqueos deberá mantenerse relacionada de forma coherente para permitir conocer el origen de las entradas y salidas registradas.

### RNF08. Trazabilidad

El sistema deberá permitir rastrear las principales operaciones del negocio mediante sus relaciones con usuarios, fechas, compras, ventas y sesiones de caja.

---

# 4. Reglas de negocio

### RN01. Usuario individual

Cada trabajador debe utilizar su propio usuario dentro del sistema.

### RN02. Roles diferentes

La administradora tendrá funciones diferentes a las del encargado de venta o caja.

### RN03. Productos por venta

Una venta puede contener uno o varios productos.

### RN04. Productos por compra

Una compra puede contener uno o varios productos.

### RN05. Código de barras

La mayoría de los productos puede identificarse mediante un código de barras.

### RN06. Productos sin código de barras

Los productos que no posean código de barras deben poder localizarse manualmente.

### RN07. Cantidades decimales

No todos los productos se manejan mediante cantidades enteras, debido a que existen productos vendidos por peso.

### RN08. Presentaciones

Un mismo producto puede disponer de diferentes formas de presentación o venta.

### RN09. Ubicaciones

Un mismo producto puede encontrarse en más de una ubicación dentro de la tienda.

### RN10. Proveedores

Un producto puede adquirirse de diferentes proveedores.

### RN11. FIFO

Cuando existan diferentes lotes disponibles de un mismo producto, debe utilizarse primero la mercadería que ingresó anteriormente.

### RN12. Productos vencidos

Los productos vencidos no deben venderse y deben retirarse del inventario disponible.

### RN13. Modificación de precios

Los precios de venta pueden modificarse cuando sea necesario.

### RN14. Formas de pago

Las ventas pueden pagarse mediante efectivo o QR.

### RN15. Venta anulada

Una venta anulada no debe eliminarse físicamente de la base de datos.

### RN16. Motivo de anulación

Toda venta anulada debe conservar un motivo que explique la anulación.

### RN17. Clientes

La tienda no registra información de clientes para realizar las ventas.

### RN18. Ventas a crédito

La tienda no realiza ventas al fiado ni ventas a crédito.

### RN19. Responsable de caja

Cada sesión o turno de caja debe poder relacionarse con el usuario responsable.

### RN20. Arqueo al cierre

Al finalizar una sesión de caja debe poder realizarse un arqueo.

### RN21. Denominaciones del arqueo

El arqueo debe permitir contar diferentes denominaciones de billetes y monedas.

### RN22. Diferencia de caja

Si existe una diferencia entre el efectivo esperado y el efectivo contado, dicha diferencia debe quedar registrada.

### RN23. Observación de diferencias

Cuando exista una diferencia de caja debe poder registrarse una observación o explicación.

---

# 5. Aspectos pendientes de validación

Durante el levantamiento de información se identificaron algunos aspectos que todavía requieren confirmación antes de considerarlos requerimientos definitivos.

## 5.1 Pago mixto

Debe confirmarse si el negocio utilizará ventas pagadas parcialmente en efectivo y parcialmente mediante QR.

Si se confirma esta necesidad, se incorporará posteriormente un requerimiento funcional específico para registrar múltiples formas de pago dentro de una misma venta.

## 5.2 Entrega de caja entre turnos

Debe confirmarse cómo se realiza exactamente la entrega física del dinero entre un encargado y el siguiente.

También debe determinarse si esta entrega necesita registrarse como una operación independiente o si puede representarse mediante el cierre de una sesión y la apertura de la siguiente.

## 5.3 Historial de precios

Debe confirmarse si la dueña necesita consultar precios anteriores de los productos o si únicamente requiere mantener el precio de venta vigente.

## 5.4 Fecha de la entrevista

Debe incorporarse la fecha exacta de realización de la entrevista cuando dicho dato se encuentre disponible.

## 5.5 Requerimientos técnicos adicionales

Durante la entrevista todavía no se definieron características específicas relacionadas con:

* Tiempo máximo de respuesta.
* Disponibilidad del sistema.
* Copias de seguridad.
* Recuperación ante fallos.
* Cantidad máxima de usuarios simultáneos.

Estos aspectos no se consideran requisitos definitivos hasta que sean establecidos o solicitados dentro del proyecto.

---

# 6. Alcance definido a partir de los requerimientos

De acuerdo con la entrevista y los requerimientos identificados, el sistema deberá concentrarse principalmente en la gestión de:

* Usuarios y roles.
* Productos.
* Categorías.
* Unidades de medida.
* Presentaciones.
* Códigos de barras.
* Productos vendidos por peso.
* Inventario.
* Stock mínimo.
* Ubicaciones.
* Lotes.
* Vencimientos.
* Proveedores.
* Compras.
* Ventas.
* Pagos.
* Anulaciones.
* Sesiones de caja.
* Arqueos.
* Diferencias de caja.
* Reportes.

No se incluye actualmente la gestión de clientes ni cuentas por cobrar debido a que París Licorería no registra clientes y no trabaja con ventas al crédito o al fiado.

---

# 7. Conclusión

Los requerimientos definidos en este documento fueron obtenidos a partir de los procesos, problemas y necesidades identificados durante la entrevista realizada en París Licorería.

Estos requerimientos establecen qué información deberá controlar el sistema y qué operaciones deberán poder realizar sus usuarios.

La siguiente etapa del proyecto consistirá en analizar estos requerimientos para identificar las entidades, atributos, claves y relaciones necesarias para construir el modelo entidad-relación de la base de datos.

Los aspectos que todavía se encuentran pendientes de validación no deberán convertirse en entidades o relaciones definitivas hasta que se tome una decisión sobre su necesidad.
