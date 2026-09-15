# Entrevista París Licorería

## 1. Datos generales

**Nombre del negocio:** París Licorería
**Actividad central:** VENTA DE PRODUCTOS: bebidas alcohólicas y otros productos de consumo.
**Tiempo de funcionamiento:** Más de 4 años.
**Cantidad aproximada de trabajadores:** Entre 2 y 3 personas.
**Horario de atención:** Durante todo el día.
**Cantidad de turnos:** Entre 2 y 3 turnos.
**Persona entrevistada:** Dueña del negocio.
**Fecha de la entrevista original:** 20 de agosto de 2026.
**Actualización del levantamiento:** 15 de septiembre de 2026.

Esta versión integra las aclaraciones comunicadas por el responsable del proyecto durante la revisión de la entrevista. Las respuestas ampliadas no se presentan como una transcripción literal ni como información confirmada desde el 20 de agosto. La versión anterior se conserva en el historial del repositorio.

Las aclaraciones comprenden pagos mixtos, responsabilidad por turno, entrega de dinero, ingreso de mercadería, cantidades por ubicación, lotes, moneda, precios históricos, anulaciones, diferencias de caja y conteo inicial. Los asuntos que todavía no tienen una respuesta suficiente se indican en la sección 28.

---

## 2. Objetivo de la entrevista

Conocer cómo funciona París Licorería, identificar los problemas y necesidades relacionados con la venta de productos y sus procesos de apoyo, y fundamentar la revisión de la base de datos existente. Cada decisión de diseño debe responder a información del negocio, diferenciando las necesidades confirmadas de las pendientes.

---

## 3. Funcionamiento general del negocio

### Pregunta 1. ¿Hace cuánto tiempo funciona París Licorería?

**Respuesta:**
El negocio funciona desde hace más de cuatro años.

### Pregunta 2. ¿Cuántas personas trabajan aproximadamente en la licorería?

**Respuesta:**
Trabajan aproximadamente entre dos y tres personas.

### Pregunta 3. ¿Cómo se organiza el trabajo durante el día?

**Respuesta:**
El negocio trabaja durante todo el día y se organiza mediante aproximadamente dos o tres turnos.

### Pregunta 4. ¿Quién administra el negocio?

**Respuesta:**
La dueña es la principal encargada de administrar la licorería.

### Pregunta 5. ¿Quién realiza las compras de mercadería?

**Respuesta:**
La dueña se encarga principalmente de realizar las compras de productos para el negocio.

### Pregunta 6. ¿Quién realiza las ventas?

**Respuesta:**
Las personas encargadas de cada turno atienden a los compradores y realizan las ventas.

---

## 4. Registro actual de la información

### Pregunta 7. ¿Cómo se registran actualmente las ventas?

**Respuesta:**
Las ventas se registran de manera manual utilizando papel y lápiz.

### Pregunta 8. ¿Actualmente utilizan algún sistema informático para controlar el negocio?

**Respuesta:**
No se cuenta con un sistema digital para controlar de manera completa las ventas y el inventario.

### Pregunta 9. ¿Se lleva un registro digital del inventario?

**Respuesta:**
No. El inventario se controla actualmente de manera manual.

---

## 5. Productos

### Pregunta 10. ¿Qué tipos de productos comercializa la licorería?

**Respuesta:**
Aunque el negocio se dedica principalmente a la venta de bebidas alcohólicas, también comercializa diferentes tipos de productos, entre ellos:

* Gaseosas.
* Dulces.
* Chupetes.
* Galletas.
* Productos de limpieza.
* Pipas.
* Productos individuales.
* Productos vendidos por peso.
* Otros productos disponibles en la tienda.

### Pregunta 11. ¿Todos los productos se venden de la misma forma?

**Respuesta:**
No. Dependiendo del producto pueden existir diferentes formas de venta, por ejemplo:

* Unidad.
* Paquete.
* Caja.
* Fardo.
* Peso.

### Pregunta 12. ¿Existen productos que se venden por peso?

**Respuesta:**
Sí. Algunos productos pueden venderse utilizando gramos o kilogramos.

Esto significa que para estos productos las cantidades manejadas no siempre serán números enteros.

### Pregunta 13. ¿Un mismo producto puede venderse en diferentes presentaciones?

**Respuesta:**
Sí. Algunos productos pueden venderse en más de una presentación.

Por ejemplo, un producto podría comercializarse:

* Por unidad.
* Por paquete.
* Por caja.

Cada presentación puede tener un precio diferente.

---

## 6. Código de barras

### Pregunta 14. ¿Los productos tienen código de barras?

**Respuesta:**
La mayoría de los productos cuentan con código de barras.

### Pregunta 15. ¿Qué se espera hacer con el código de barras?

**Respuesta:**
Se quiere utilizar el código de barras para encontrar rápidamente el producto registrado en el sistema al momento de realizar una venta.

La intención es poder utilizar la cámara de un celular para escanear el código.

### Pregunta 16. ¿Qué ocurriría con los productos que no tengan código de barras?

**Respuesta:**
Deben poder buscarse y seleccionarse manualmente dentro del sistema.

La búsqueda podría realizarse utilizando datos registrados del producto como su nombre, categoría o información relacionada.

---

## 7. Inventario y stock

### Pregunta 17. ¿Cómo se controla actualmente el inventario?

**Respuesta:**
El inventario se controla manualmente.

### Pregunta 18. ¿Qué información sería importante conocer sobre el stock?

**Respuesta:**
Es necesario conocer la cantidad disponible de los productos y poder identificar aquellos que se están terminando o ya se encuentran agotados.

### Pregunta 19. ¿Qué ocurre cuando un producto está por terminarse?

**Respuesta:**
Cuando un producto llega a una cantidad mínima o se termina, es necesario realizar una nueva compra para reponerlo.

### Pregunta 20. ¿Sería útil identificar productos con bajo stock?

**Respuesta:**
Sí. La dueña quiere poder conocer qué productos tienen poca existencia para poder realizar su reposición.

### Pregunta 21. ¿Se producen pérdidas de productos?

**Respuesta:**
Dentro del control de inventario deben considerarse productos que puedan perderse debido a daños, vencimientos u otras situaciones que reduzcan la existencia disponible.

---

## 8. Lotes y vencimientos

### Pregunta 22. ¿La mercadería ingresa en distintos lotes?

**Respuesta:**
Sí. Pueden ingresar nuevas cantidades de un mismo producto mientras todavía existe mercadería anterior.

### Pregunta 23. ¿Qué producto debe venderse primero cuando existen lotes diferentes?

**Respuesta:**
Primero debe venderse el producto que ingresó anteriormente y posteriormente el producto perteneciente al nuevo lote.

Este comportamiento corresponde al criterio conocido como **FIFO: primero en entrar, primero en salir**.

### Pregunta 24. ¿Existen productos con fecha de vencimiento?

**Respuesta:**
Sí. Algunos productos manejan fecha de vencimiento.

### Pregunta 25. ¿Qué ocurre con un producto cuando vence?

**Respuesta:**
Cuando el producto se encuentra vencido ya no se vende y debe desecharse.

Por este motivo es necesario poder controlar los vencimientos dentro del inventario.

---

## 9. Ubicación de los productos

### Pregunta 26. ¿Los productos se encuentran todos en un solo lugar dentro de la tienda?

**Respuesta:**
No necesariamente.

Los productos pueden encontrarse en diferentes lugares, por ejemplo:

* Refrigeradores.
* Estantes.
* Vitrinas.
* Almacén.
* Otros lugares dentro del negocio.

### Pregunta 27. ¿Un mismo producto podría estar en más de una ubicación?

**Respuesta:**
Sí. Un mismo producto puede encontrarse distribuido en diferentes ubicaciones de la licorería.

Por este motivo sería útil conocer no solamente dónde se encuentra el producto, sino también qué cantidad existe en cada ubicación.

---

## 10. Precios

### Pregunta 28. ¿Los precios de los productos permanecen siempre iguales?

**Respuesta:**
No. Los precios pueden cambiar.

### Pregunta 29. ¿De qué pueden depender los cambios de precio?

**Respuesta:**
Entre los factores mencionados se encuentran el costo de adquisición del producto y las variaciones relacionadas con el dólar.

### Pregunta 30. ¿El sistema debería permitir modificar los precios?

**Respuesta:**
Sí. La administradora debe poder actualizar el precio de los productos cuando sea necesario.

---

## 11. Proveedores

### Pregunta 31. ¿De dónde se obtiene la mercadería?

**Respuesta:**
Los productos se compran principalmente a distribuidores y empresas proveedoras.

### Pregunta 32. ¿Se registran actualmente todos los datos de los proveedores?

**Respuesta:**
Actualmente no siempre se conserva de manera organizada toda la información de los proveedores.

### Pregunta 33. ¿Qué información sería conveniente registrar de un proveedor?

**Respuesta:**
Sería conveniente conservar información como:

* Nombre de la empresa o proveedor.
* Persona de contacto.
* Teléfono.
* Dirección.
* Otra información necesaria para identificarlo y contactarlo.

### Pregunta 34. ¿Un producto solamente puede comprarse a un proveedor?

**Respuesta:**
No. Un producto puede obtenerse de diferentes proveedores dependiendo de la disponibilidad o de las compras realizadas.

---

## 12. Compras

### Pregunta 35. ¿Quién realiza las compras de mercadería?

**Respuesta:**
La dueña realiza principalmente las compras.

### Pregunta 36. ¿Cuándo se realizan las compras?

**Respuesta:**
Las compras pueden realizarse cuando:

* Un producto se termina.
* El producto llega a una cantidad mínima.
* Es necesario reponer mercadería.

### Pregunta 37. ¿Una compra puede incluir varios productos?

**Respuesta:**
Sí. En una misma compra pueden adquirirse distintos productos.

### Pregunta 38. ¿Qué información sería importante conservar de una compra?

**Respuesta:**
Para poder controlar correctamente las compras sería necesario registrar información como:

* Fecha.
* Proveedor.
* Responsable de registrar la compra.
* Productos adquiridos.
* Cantidades.
* Costos de compra.
* Total de la compra.
* Información relacionada con el lote cuando corresponda.

---

## 13. Ventas

### Pregunta 39. ¿Cómo se realizan actualmente las ventas?

**Respuesta:**
El vendedor atiende al comprador y registra manualmente la venta.

### Pregunta 40. ¿Qué información debería registrar el sistema durante una venta?

**Respuesta:**
El sistema debería permitir conocer:

* Fecha.
* Hora.
* Usuario que realizó la venta.
* Turno o sesión de caja correspondiente.
* Productos vendidos.
* Cantidades.
* Precios utilizados en la venta.
* Total.
* Forma de pago.
* Estado de la venta.

### Pregunta 41. ¿Una venta puede incluir varios productos?

**Respuesta:**
Sí. Una misma venta puede contener uno o varios productos.

---

## 14. Formas de pago

### Pregunta 42. ¿Qué formas de pago utiliza la licorería?

**Respuesta:**
Se utilizan principalmente:

* Efectivo.
* QR.

También se permiten pagos combinados entre efectivo y QR, según la aclaración posterior.

### Pregunta 43. ¿Qué ocurre cuando una venta se paga mediante QR?

**Respuesta:**
Se utiliza el comprobante del pago realizado.

Se desea que el sistema permita conservar una imagen del comprobante QR asociada a la venta.

### Pregunta 44. ¿Podría una venta pagarse parcialmente en efectivo y parcialmente mediante QR?

**Respuesta:**
Sí. Una misma venta puede pagarse parcialmente en efectivo y parcialmente mediante QR. Esta posibilidad, pendiente en el levantamiento original, queda confirmada en la actualización.

---

## 15. Anulación de ventas

### Pregunta 45. ¿Puede anularse una venta?

**Respuesta:**
Sí. El encargado puede anular una venta de su propia sesión mientras su turno permanece abierto. La justificación es obligatoria. No se permiten anulaciones después del cierre del turno, según la aclaración recibida.

### Pregunta 46. ¿Qué situaciones podrían ocasionar la anulación?

**Respuesta:**
Entre los ejemplos mencionados se encuentran:

* Error durante el registro de la venta.
* Detección de un billete falso.
* Otro motivo justificado.

### Pregunta 47. ¿Una venta anulada debe eliminarse completamente?

**Respuesta:**
No.

Debe conservarse el registro de la venta, cambiarse su estado a anulada y guardar el motivo correspondiente.

Esto permitirá mantener un historial de lo sucedido.

---

## 16. Clientes

### Pregunta 48. ¿La licorería registra información de los clientes?

**Respuesta:**
No.

La tienda realiza ventas directas y no necesita registrar a cada comprador.

### Pregunta 49. ¿Se realizan ventas al fiado o a crédito?

**Respuesta:**
No.

Las ventas se pagan en el momento.

Por esta razón actualmente no existe la necesidad de registrar clientes para controlar cuentas por cobrar.

---

## 17. Usuarios del sistema

### Pregunta 50. ¿Todas las personas utilizarían la misma cuenta dentro del sistema?

**Respuesta:**
No.

Cada trabajador debería contar con su propio usuario para poder identificar quién realizó cada operación.

### Pregunta 51. ¿Todos los usuarios deberían tener las mismas funciones?

**Respuesta:**
No.

Se identifican inicialmente dos tipos principales de usuario:

### Administrador

Representado principalmente por la dueña.

Debe poder realizar actividades como:

* Registrar y modificar productos.
* Registrar categorías.
* Registrar proveedores.
* Registrar compras.
* Actualizar precios.
* Consultar inventario.
* Revisar ventas.
* Revisar cierres de caja.
* Consultar reportes.
* Gestionar usuarios.

### Encargado de venta o caja

Debe poder realizar actividades relacionadas con su turno, entre ellas:

* Iniciar sesión.
* Abrir su sesión de caja.
* Registrar ventas.
* Escanear productos.
* Buscar productos manualmente.
* Registrar formas de pago.
* Anular ventas de su propia sesión durante el turno, con justificación obligatoria.
* Cerrar su sesión de caja.
* Realizar el arqueo.
* Registrar diferencias cuando corresponda.

---

## 18. Caja y turnos

### Pregunta 52. ¿Cómo funciona la caja durante el día?

**Respuesta:**
Cada encargado se hace responsable de la caja durante su turno. Los turnos se suceden: uno termina y luego comienza el siguiente; no se trabaja simultáneamente en los turnos descritos.

La referencia posterior a dos o más cajas fue aclarada como una referencia a los turnos de los vendedores. No se confirmó que existan dos cajas físicas distintas ni su cantidad exacta. Esta información no permite justificar por sí sola una entidad independiente para cajas físicas.

### Pregunta 53. ¿Qué debería ocurrir al comenzar un turno?

**Respuesta:**
El encargado debe iniciar una sesión de caja correspondiente a su turno.

La sesión debe permitir identificar:

* Fecha.
* Hora de inicio.
* Usuario responsable.
* Monto inicial.
* Estado de la sesión.

### Pregunta 54. ¿Qué ocurre al finalizar un turno?

**Respuesta:**
Al finalizar el turno, el encargado debe:

1. Cerrar su sesión.
2. Contar el dinero existente.
3. Realizar el arqueo.
4. Comparar el dinero contado con el dinero esperado.
5. Registrar cualquier diferencia.
6. Entregar la responsabilidad de la caja al siguiente encargado cuando corresponda.

---

## 19. Arqueo de caja

### Pregunta 55. ¿Cómo se desea realizar el conteo del efectivo?

**Respuesta:**
Se quiere realizar un conteo detallado de los billetes y monedas existentes en caja.

Por ejemplo:

* Billetes de 100 Bs.
* Billetes de 50 Bs.
* Billetes de 20 Bs.
* Billetes de 10 Bs.
* Billetes de 5 Bs.
* Monedas de 1 Bs.
* Monedas de 0.50 Bs.

### Pregunta 56. ¿Qué debería calcularse durante el arqueo?

**Respuesta:**
Para cada denominación se debe registrar la cantidad encontrada y calcular su subtotal.

Después deben sumarse los subtotales para obtener el total de efectivo contado.

### Pregunta 57. ¿Por qué es importante registrar las denominaciones?

**Respuesta:**
La dueña quiere conocer el fraccionamiento del dinero existente en caja y no solamente el monto total.

---

## 20. Diferencias de caja

### Pregunta 58. ¿Qué ocurre si el dinero contado no coincide con el dinero que debería existir?

**Respuesta:**
Debe calcularse y registrarse la diferencia.

Por ejemplo:

**Dinero esperado:** 1000 Bs
**Dinero contado:** 980 Bs
**Diferencia:** -20 Bs

### Pregunta 59. ¿Debe registrarse una explicación cuando existe una diferencia?

**Respuesta:**
Sí.

Cuando el efectivo contado no coincide con el esperado, el encargado debe registrar obligatoriamente una explicación de la diferencia.

---

## 21. Entrega de caja entre turnos

### Pregunta 60. ¿Existe entrega de caja entre los encargados de diferentes turnos?

**Respuesta:**
Al finalizar un turno, el dinero se entrega contado y se deja constancia de la entrega al siguiente encargado.

Se necesita registrar quién entrega, quién recibe y cuánto dinero se entrega, e identificar las sesiones correspondientes. La necesidad de conservar esta información queda confirmada. La forma de representarla en el modelo se revisará en la etapa correspondiente.

---

## 22. Reportes e información requerida

### Pregunta 61. ¿Qué información necesita consultar la dueña?

**Respuesta:**
La dueña necesita poder revisar información del funcionamiento del negocio.

Entre los reportes considerados se encuentran:

* Ventas del día.
* Ventas de la semana.
* Ventas del mes.
* Productos más vendidos.
* Productos con bajo stock.
* Productos agotados.
* Compras realizadas.
* Estado del inventario.
* Historial de cierres de caja.
* Diferencias encontradas en caja.

### Pregunta 62. ¿Quién revisa los cierres de caja?

**Respuesta:**
La dueña es quien revisa los cierres realizados por los encargados.

---

## 22.1 Preguntas complementarias del levantamiento

Las siguientes respuestas fueron comunicadas por el responsable del proyecto durante la actualización. Se mantiene la numeración original de las preguntas 1 a 62 para conservar sus referencias.

### Pregunta 63. ¿La mercadería llega al momento de comprarla o se recibe después?

**Respuesta:**
La mercadería llega al momento de comprarla. No se confirmó una necesidad de registrar recepciones posteriores o entregas parciales.

### Pregunta 64. ¿Toda la mercadería pasa primero por el almacén?

**Respuesta:**
Los productos pueden colocarse directamente en el almacén o en la heladera, según corresponda. No se indicó que deban pasar obligatoriamente por el almacén antes de ubicarse en otro lugar.

### Pregunta 65. ¿Qué información se necesita controlar cuando los productos están en diferentes lugares?

**Respuesta:**
Se necesita conocer la cantidad existente en cada ubicación. No se requiere registrar quién realizó cada traslado. La operación debe mantener correctas las cantidades por ubicación.

### Pregunta 66. ¿Una misma compra puede incluir un producto con diferentes lotes o vencimientos?

**Respuesta:**
Sí. Un mismo producto recibido en una compra puede pertenecer a distintos lotes o tener diferentes fechas de vencimiento.

### Pregunta 67. ¿En qué moneda se registran las operaciones?

**Respuesta:**
Las compras, ventas y pagos se registran en bolivianos. La influencia del dólar sobre los precios, mencionada en la pregunta 29, no significa que se registren operaciones en dólares.

### Pregunta 68. ¿Se necesita consultar todos los cambios anteriores de precios?

**Respuesta:**
No. Se necesita conservar el precio utilizado en cada venta. No se requiere un historial completo de cambios del precio vigente cuando no hubo ventas.

### Pregunta 69. ¿Qué debe distinguirse si se anula una venta y el comprador ya se llevó los productos?

**Respuesta:**
Se solicita una opción para indicar si los productos regresaron o si el comprador se los llevó y no los devolvió. No debe suponerse que toda anulación implica el regreso físico de la mercadería.

El tratamiento del dinero, la pérdida y las posibles devoluciones parciales en estos casos requiere una aclaración adicional; no queda definido únicamente con esta respuesta.

### Pregunta 70. ¿Cómo se devuelve el dinero cuando se anula una venta pagada por QR?

**Respuesta:**
El dinero se devuelve por QR y se anula la venta dentro del turno. No se confirmó una devolución automática mediante una integración bancaria.

La forma de devolver pagos en efectivo o mixtos y la constancia necesaria de cada devolución todavía deben aclararse.

### Pregunta 71. ¿Durante el turno se retira o agrega efectivo por motivos distintos de las ventas?

**Respuesta:**
No. No se realizan retiros para compras u otros gastos ni ingresos adicionales de efectivo durante el turno. El monto inicial corresponde a la apertura y la entrega al siguiente encargado corresponde al cambio de turno.

### Pregunta 72. ¿Cómo se registrará la mercadería existente al comenzar a utilizar el sistema?

**Respuesta:**
Se realizará un conteo inicial de la mercadería existente para registrarla en el sistema. No se confirmó una reconstrucción de todas sus compras anteriores.

Este conteo se diferencia de las nuevas compras de mercadería. La disponibilidad de costos, datos de lote y antigüedad para ordenar estas existencias todavía debe aclararse; no se deben inventar compras anteriores para registrar el conteo.

---

# 23. Procesos actuales identificados

A partir de la entrevista se identificaron los siguientes procesos principales del negocio:

## 23.1 Compra de mercadería

1. Se detecta que un producto se encuentra agotado o con poca existencia.
2. La dueña decide realizar una reposición.
3. Se contacta o compra a un distribuidor o empresa.
4. La mercadería ingresa al momento de realizar la compra.
5. Los productos son ubicados dentro del negocio, por ejemplo directamente en el almacén o la heladera.
6. Se continúa vendiendo primero la mercadería anterior cuando existe stock previo.

## 23.2 Venta

1. El comprador selecciona los productos.
2. El encargado identifica los productos.
3. Se determina la cantidad.
4. Se calcula el precio correspondiente.
5. El comprador realiza el pago.
6. La venta se registra actualmente de manera manual.
7. La mercadería sale del inventario.

## 23.3 Pago

La venta puede pagarse principalmente mediante:

* Efectivo.
* QR.
* Una combinación de efectivo y QR.

Las operaciones se registran en bolivianos. Cuando se utiliza QR existe un comprobante del pago.

## 23.4 Control de caja

1. Un encargado inicia su turno.
2. Atiende y registra ventas durante su turno.
3. Al finalizar cuenta el efectivo.
4. Realiza el arqueo.
5. Se determina si existe alguna diferencia y se registra una explicación obligatoria cuando no coincide el dinero.
6. Se deja constancia del dinero contado que se entrega, de quién entrega y de quién recibe al cambiar de turno.
7. La dueña puede revisar posteriormente el cierre realizado.

## 23.5 Control de inventario

El negocio controla la disponibilidad de los productos y necesita detectar:

* Productos disponibles.
* Productos con bajo stock.
* Productos agotados.
* Ingresos de productos.
* Salidas por ventas.
* Productos dañados.
* Productos vencidos.

## 23.6 Conteo inicial para comenzar el registro digital

Antes de comenzar a registrar las operaciones en el sistema, se realiza un conteo de la mercadería existente. Ese conteo establece la existencia inicial y se distingue de las compras realizadas posteriormente. Los datos necesarios y la forma de representarlo se revisarán sin inventar compras históricas.

---

# 24. Problemas actuales detectados

A partir del levantamiento de información se identificaron los siguientes problemas:

1. Las ventas se registran manualmente utilizando papel y lápiz.
2. No existe un sistema digital centralizado para consultar las ventas.
3. El inventario se controla manualmente.
4. No existe una forma automática de conocer qué productos se encuentran con bajo stock.
5. Resulta más difícil controlar los productos pertenecientes a diferentes lotes.
6. El control de productos vencidos depende del seguimiento manual.
7. Los cambios de precios deben controlarse manualmente.
8. La información de los proveedores no siempre se encuentra registrada de forma organizada.
9. El cierre y arqueo de caja requiere un mayor control por turno.
10. Las diferencias de caja necesitan quedar registradas para poder ser revisadas.
11. La dueña necesita obtener información y reportes sin tener que revisar manualmente todos los registros.

---

# 25. Necesidades detectadas

Se identificaron las siguientes necesidades generales:

* Registrar usuarios y diferenciar sus responsabilidades.
* Registrar productos.
* Clasificar los productos.
* Registrar diferentes formas o presentaciones de venta.
* Manejar productos vendidos por unidad y por peso.
* Utilizar códigos de barras cuando existan.
* Permitir búsqueda manual de productos.
* Controlar stock.
* Definir niveles mínimos de stock.
* Identificar productos agotados.
* Identificar productos con bajo stock.
* Controlar lotes.
* Controlar fechas de vencimiento.
* Controlar diferentes ubicaciones de los productos.
* Registrar proveedores.
* Registrar compras.
* Registrar ventas.
* Registrar los productos incluidos en cada venta.
* Registrar pagos en efectivo y QR.
* Registrar pagos mixtos de efectivo y QR.
* Conservar comprobantes QR.
* Permitir anulaciones sin eliminar el historial de la venta.
* Limitar la anulación a las ventas de la sesión del encargado mientras su turno está abierto, con justificación obligatoria.
* Distinguir si la mercadería regresó al anular una venta.
* Registrar sesiones de caja por turno.
* Conservar constancia de quién entrega el dinero, quién lo recibe y cuánto se entrega.
* Realizar arqueos.
* Registrar denominaciones de billetes y monedas.
* Calcular diferencias de caja.
* Exigir una explicación cuando exista una diferencia de caja.
* Registrar las existencias iniciales mediante un conteo.
* Manejar compras, ventas y pagos en bolivianos.
* Conservar el precio utilizado en cada venta.
* Consultar información histórica.
* Obtener reportes para apoyar la administración del negocio.

---

# 26. Reglas del negocio identificadas

Durante la entrevista se identificaron las siguientes reglas:

**RN01.** Cada trabajador debe utilizar su propio usuario dentro del sistema.

**RN02.** La dueña tendrá funciones administrativas diferentes a las del encargado de ventas.

**RN03.** Una venta puede contener uno o varios productos.

**RN04.** Una compra puede contener uno o varios productos.

**RN05.** La mayoría de los productos puede identificarse mediante código de barras.

**RN06.** Los productos sin código de barras deben poder localizarse manualmente.

**RN07.** No todos los productos se manejan mediante cantidades enteras, debido a que existen productos vendidos por peso.

**RN08.** Un producto puede disponer de diferentes formas de presentación o venta.

**RN09.** Un producto puede encontrarse en más de una ubicación dentro de la tienda.

**RN10.** Un producto puede adquirirse de diferentes proveedores.

**RN11.** Cuando existen diferentes lotes de un producto, se debe vender primero la mercadería más antigua.

**RN12.** Los productos vencidos no deben venderse y deben retirarse del inventario disponible.

**RN13.** Los precios de venta pueden modificarse cuando sea necesario.

**RN14.** Las ventas pueden pagarse en efectivo o mediante QR.

**RN15.** Una misma venta puede pagarse combinando efectivo y QR.

**RN16.** Una venta anulada no debe eliminarse físicamente del registro.

**RN17.** Toda anulación debe conservar un motivo obligatorio. El encargado solo puede anular ventas de su propia sesión durante su turno abierto.

**RN18.** La tienda no registra clientes.

**RN19.** La tienda no realiza ventas al fiado ni ventas a crédito.

**RN20.** Cada turno debe poder relacionarse con el usuario responsable de la caja.

**RN21.** Al finalizar una sesión de caja debe poder realizarse un arqueo.

**RN22.** El arqueo debe permitir contar las diferentes denominaciones de billetes y monedas.

**RN23.** Si existe diferencia entre el efectivo esperado y el contado, dicha diferencia debe quedar registrada junto con una explicación obligatoria.

**RN24.** La entrega entre encargados debe dejar constancia de quién entrega, quién recibe y cuánto dinero se entrega.

**RN25.** Las compras, ventas y pagos se registran en bolivianos.

**RN26.** Cada venta conserva el precio aplicado en ese momento, aunque el precio vigente cambie posteriormente.

**RN27.** La mercadería llega al momento de la compra y puede colocarse directamente en el almacén o la heladera.

**RN28.** Una misma compra puede incluir distintos lotes o vencimientos de un mismo producto.

**RN29.** El inicio del registro en el sistema se realiza mediante un conteo de la mercadería existente, separado de las nuevas compras.

**RN30.** Al anular se debe distinguir si los productos regresaron. El tratamiento de la pérdida y del dinero cuando no regresan permanece pendiente de confirmación.

**RN31.** No se realizan ingresos adicionales ni retiros de efectivo durante el turno por motivos distintos de las ventas; la apertura y la entrega entre turnos se registran por separado de esos cobros.

**RN32.** Los encargados se suceden por turno; no se describió un funcionamiento simultáneo de los turnos.

---

# 27. Alcance identificado del sistema

A partir de la entrevista y sus aclaraciones, el alcance comprende:

* Usuarios.
* Productos.
* Categorías.
* Presentaciones.
* Unidades de medida.
* Inventario.
* Ubicaciones.
* Lotes.
* Vencimientos.
* Proveedores.
* Compras.
* Ventas.
* Pagos.
* Caja.
* Turnos.
* Arqueos.
* Diferencias.
* Reportes.

También comprende el conteo inicial de mercadería, los pagos mixtos, la constancia de entrega de dinero entre turnos y la distinción del regreso de mercadería en las anulaciones. Registrar estas necesidades no significa que ya estén implementadas en la V2; deben contrastarse con requerimientos y modelo en las siguientes etapas de revisión.

No se considera actualmente necesario registrar clientes ni gestionar cuentas por cobrar, debido a que el negocio realiza ventas directas y no trabaja con crédito o fiado.

---

# 28. Aspectos pendientes de confirmar

Los pagos mixtos, la necesidad de dejar constancia de la entrega entre turnos, la conservación del precio aplicado en cada venta, la moneda, el conteo inicial y la fecha de la entrevista ya fueron aclarados. No deben seguir figurando como necesidades sin confirmar.

Los siguientes puntos **REQUIEREN CONFIRMACIÓN CON LA DUEÑA**:

1. **Cajas físicas:** no se conoce su cantidad exacta ni si necesitan identificación propia. La mención a dos o más se aclaró como referencia a turnos.
2. **Anulación sin regreso de mercadería:** cómo se trata la pérdida y qué sucede con el pago, especialmente cuando se detecta un billete falso después de que el comprador se fue.
3. **Devoluciones de dinero:** cómo se devuelven pagos en efectivo o mixtos y qué constancia debe guardarse. Se indicó devolución por QR para ventas pagadas por QR.
4. **Devoluciones parciales:** si existen y cómo se gestionan. No se deduce esta necesidad de una anulación completa.
5. **Conteo inicial:** qué costos y datos de lote o vencimiento están disponibles y cómo se identifica la mercadería más antigua para comenzar a aplicar FIFO cuando no hay registro de sus compras anteriores.
6. **Identificación adicional del negocio:** cualquier dato académico necesario que todavía no haya sido proporcionado.

La elección de tablas, atributos o procedimientos para representar las necesidades confirmadas corresponde al análisis y diseño posterior; no se presenta como una respuesta de la dueña.

---

# 29. Conclusión de la entrevista

La entrevista permitió identificar que París Licorería actualmente realiza gran parte de sus controles de manera manual, especialmente el registro de ventas y el seguimiento del inventario.

El negocio necesita organizar información relacionada con productos, compras, proveedores, inventario, ventas, pagos y caja.

La actividad central es la venta de productos. Las compras, el ingreso y almacenamiento de mercadería, el inventario, los pagos y el control de caja permiten desarrollar y controlar esa actividad.

La actualización confirma pagos mixtos, operaciones en bolivianos, conservación del precio aplicado en cada venta, anulaciones justificadas durante el turno, entrega de dinero con constancia y registro inicial de mercadería mediante conteo. También distingue los puntos que todavía requieren aclaración.

La base V2 ya existe. Esta entrevista actualizada fundamenta su revisión por etapas, comenzando por la sistematización de las necesidades y su comparación con los requerimientos. No constituye una aprobación automática de cambios en las tablas ni del comportamiento actual del SQL.
