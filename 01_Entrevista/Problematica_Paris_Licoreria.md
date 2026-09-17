# Descripción y análisis de la problemática — París Licorería

## 1. Base del análisis

El análisis se sustenta en la [entrevista de París Licorería](Entrevista_Paris_Licoreria.md), realizada el 20 de agosto de 2026 y actualizada con las aclaraciones comunicadas por el responsable del proyecto el 15 de septiembre de 2026, y en su [sistematización](Sistematizacion_Entrevista_Paris_Licoreria.md).

Se utiliza la versión de estos documentos incorporada al repositorio hasta el commit `d41395d5affbd94565fce531b7dd15a22c1a6cd1`. La información describe el funcionamiento recogido en el levantamiento. La existencia de una base de datos V2 en el repositorio no demuestra que una aplicación completa ya esté instalada o en uso en el negocio.

## 2. Descripción de la situación actual

París Licorería tiene como actividad central la **venta de productos**. Comercializa principalmente bebidas alcohólicas y también gaseosas, dulces, galletas, productos de limpieza y otros artículos. Funciona desde hace más de cuatro años y cuenta aproximadamente con dos o tres trabajadores. La dueña administra el negocio y realiza principalmente las compras de mercadería, mientras los encargados atienden las ventas durante sus respectivos turnos.

Las ventas se registran de forma manual con papel y lápiz. El inventario también se controla manualmente y no se dispone de un sistema digital que permita gestionar de forma completa ambos procesos. Por ello, la consulta de las operaciones y de las existencias depende de la revisión de los registros y del seguimiento realizado por las personas encargadas. Estas condiciones están descritas en las preguntas 1 a 9 de la entrevista.

El control de productos requiere considerar diferentes presentaciones. Un artículo puede comprarse o venderse por unidad, paquete, caja o peso. Algunos productos admiten cantidades decimales y cada presentación puede tener un precio distinto. Por tanto, registrar solamente el nombre del producto y una cantidad sin indicar su presentación puede dificultar la interpretación de lo comprado, lo vendido y lo que permanece en inventario. Esta es una dificultad derivada del análisis de las preguntas 10 a 13, no un error concreto cuya ocurrencia se haya medido.

La mercadería llega al momento de realizar la compra y puede colocarse directamente en el almacén o en la heladera. Un producto puede distribuirse entre diferentes ubicaciones, y una misma compra puede incluir distintos lotes o fechas de vencimiento del mismo artículo. La dueña necesita conocer las cantidades disponibles, identificar productos con poca existencia y vender primero la mercadería que ingresó antes. Los productos vencidos no deben venderse y deben retirarse físicamente. Estas necesidades se encuentran en las preguntas 17 a 27 y 63 a 66.

Los precios de venta pueden cambiar. El negocio necesita actualizar el precio vigente y conservar el que se utilizó en cada venta. También requiere organizar los datos de proveedores, las compras, las cantidades adquiridas y sus costos. El costo de compra y el precio de venta corresponden a datos distintos, porque uno identifica el valor de adquisición y el otro el importe cobrado al vender. Las preguntas 28 a 38 y 68 fundamentan estos aspectos.

Las ventas se pagan al momento mediante efectivo, QR o una combinación de ambos, y las operaciones se registran en bolivianos. No se registran datos de clientes ni se realizan ventas al fiado o crédito. Durante cada turno se necesita identificar al encargado, registrar la apertura de su sesión, relacionar sus ventas y realizar el cierre con conteo de billetes y monedas. Si el dinero contado no coincide con el esperado, la explicación es obligatoria. Al cambiar de turno se entrega el dinero contado y se requiere dejar constancia de quién entrega, quién recibe y cuánto se entrega. Estas condiciones se recogen en las preguntas 42 a 60 y 67.

Para comenzar el registro digital de las existencias se realizará un conteo de la mercadería disponible. Ese conteo constituye el punto de partida del inventario y debe distinguirse de las compras que se realicen posteriormente. La pregunta 72 confirma esta necesidad; no confirma la reconstrucción de todas las compras anteriores.

## 3. Problema central

**París Licorería registra manualmente sus ventas y controla de la misma forma el inventario, sin disponer de un registro digital integrado que permita consultar de manera organizada las operaciones, las existencias por lote y ubicación, los pagos y la responsabilidad de caja por turno.**

Esta situación dificulta reunir la información necesaria para revisar el funcionamiento del negocio. La dueña necesita conocer qué se vende, cuánto queda disponible, qué productos requieren reposición, cuáles están vencidos y si el efectivo de cada turno coincide con las operaciones registradas.

El problema se centra en la organización y relación de la información. No se atribuyen a los trabajadores conductas indebidas ni se afirma que existan pérdidas económicas de una cantidad determinada, porque la entrevista no aporta esas evidencias.

## 4. Análisis de los problemas y necesidades

La siguiente tabla relaciona los hechos o necesidades declarados con su efecto sobre el control del negocio. Los riesgos se distinguen expresamente de los problemas confirmados.

| Aspecto | Evidencia de la entrevista | Análisis de la dificultad o riesgo | Necesidad que surge |
|---|---|---|---|
| Registro de ventas | Las ventas se anotan con papel y lápiz; una venta puede incluir varios productos. Preguntas 7–8 y 39–41. | La información no está reunida en un registro digital que facilite consultar la venta y todos sus detalles. | Registrar fecha, responsable, productos, presentaciones, cantidades, precios y pagos de cada venta; obtener subtotales y total. |
| Presentaciones y cantidades | Existen ventas por unidad, paquete, caja y peso. Preguntas 10–13. | Hay riesgo de interpretar de manera incorrecta una cantidad si no se conoce su presentación y equivalencia. No se midió la frecuencia de este error. | Identificar las presentaciones y relacionarlas con la unidad usada para controlar existencias. |
| Disponibilidad y reposición | El inventario es manual y se necesita detectar productos agotados o con poca existencia. Preguntas 9 y 17–20. | El negocio carece de una consulta automática que reúna la disponibilidad y el mínimo de reposición. | Conocer existencias y detectar productos que requieren una nueva compra. |
| Lotes y vencimientos | Ingresa mercadería nueva mientras todavía hay anterior; algunos productos vencen. Preguntas 22–25 y 66. | Sin distinguir los ingresos, resulta más difícil seguir la antigüedad y el vencimiento de las existencias. No se afirma que se hayan vendido productos vencidos. | Identificar lotes y vencimientos, utilizar primero la mercadería más antigua apta para venta y registrar el retiro de vencidos. |
| Ubicaciones | Un producto puede estar en distintos lugares. Preguntas 26–27 y 64–65. | Conocer únicamente una cantidad general no permite saber cuánto hay en cada lugar. | Registrar cantidades por ubicación y mantener su coherencia cuando se distribuye mercadería. |
| Pérdidas y retiros | Deben considerarse daños, vencimientos y otras causas de reducción de existencias. Preguntas 21 y 25. | Cambiar una cantidad sin conservar su causa impediría explicar la disminución. Es un riesgo del control, no una pérdida cuantificada. | Relacionar cada retiro con su cantidad, causa, fecha y responsable. |
| Proveedores y compras | Los datos de proveedores no siempre se conservan organizadamente y una compra incluye productos, cantidades y costos. Preguntas 31–38 y 63. | La información de contacto y el origen de las compras necesitan reunirse para facilitar su consulta. | Registrar proveedores y relacionarlos con compras, detalles e ingreso de mercadería. |
| Cambios de precios | Los precios cambian y se requiere conservar el utilizado en cada venta. Preguntas 28–30 y 68. | Si se utiliza el precio vigente para consultar una venta antigua, se obtiene un importe que puede no corresponder a lo cobrado. | Conservar el precio aplicado en la venta, separado del precio vigente y del costo de compra. |
| Pagos | Se utilizan efectivo, QR y pagos mixtos; se requiere conservar el comprobante QR. Preguntas 42–44 y 67. | Un único dato general de forma de pago no explica los importes de una venta pagada con dos medios. | Relacionar cada importe y su medio de pago con la venta; conservar la imagen del comprobante QR asociada a la venta cuando corresponda. |
| Caja y cambio de turno | Cada encargado responde por su sesión; se cuenta el efectivo y se deja constancia de la entrega. Preguntas 52–60 y 71. | Para revisar diferencias y entregas se necesita vincular operaciones, período de trabajo y responsables. No se afirma que existan faltantes frecuentes. | Registrar sesiones, conteos, diferencias justificadas y constancia de quién entrega, quién recibe y cuánto. |
| Anulaciones | El encargado puede anular durante su turno con motivo; debe distinguirse si los productos regresaron. Preguntas 45–47 y 69–70. | Suponer que toda anulación devuelve mercadería puede generar una existencia que no está físicamente en el negocio. | Conservar la venta, el motivo y la información necesaria sobre el regreso de productos, respetando el turno autorizado. |
| Inicio del inventario digital | Se realizará un conteo de lo que existe para registrarlo. Pregunta 72. | Tratar el conteo como una nueva compra inventaría una operación y no explicaría correctamente el origen inicial. | Registrar el conteo inicial y distinguirlo de los ingresos por compras posteriores. |
| Información para la dueña | Se necesitan reportes de ventas, compras, inventario, productos y cierres. Preguntas 61–62. | La revisión manual no ofrece una consulta integrada de los datos solicitados. | Obtener reportes a partir de operaciones relacionadas y criterios claros de fechas, estados y unidades. |

## 5. Condiciones que explican la problemática

La primera condición es el uso de registros manuales para las ventas y el inventario. Esta forma de trabajo hace que reunir y consultar la información dependa de revisar anotaciones y verificar existencias. La entrevista confirma el método utilizado, pero no proporciona mediciones del tiempo que tarda cada consulta.

La segunda condición es la variedad de datos que intervienen en una misma venta. Es necesario relacionar artículo, presentación, cantidad, precio aplicado, lote de salida, pago y sesión del encargado. Si esos datos se mantienen sin relación, existe el riesgo de obtener resultados que no correspondan a la misma operación.

La tercera condición es el cambio de las existencias y los precios con el tiempo. Llegan nuevas cantidades de productos, se realizan ventas, pueden retirarse productos dañados o vencidos y se actualizan los precios. El negocio necesita distinguir lo que existe ahora de lo que se compró o vendió anteriormente.

La cuarta condición es la responsabilidad por turno. Para revisar un cierre, no basta con conocer el total vendido durante el día: se necesita identificar la sesión, sus cobros en efectivo, el monto inicial, el conteo realizado y la entrega de dinero al siguiente encargado.

Estas condiciones fundamentan la necesidad de organizar los datos. No permiten concluir que falte capacitación, que exista mala administración o que ocurran fraudes, porque esos hechos no fueron establecidos en la entrevista.

## 6. Consecuencias y límites de la evidencia

La consecuencia principal identificada es la dificultad para consultar de manera integrada las ventas, las existencias y el control de caja. También se requiere un seguimiento manual para identificar la reposición y controlar la mercadería de distintos lotes y vencimientos.

Como riesgos del proceso se reconocen la confusión de cantidades entre presentaciones, la falta de explicación de una reducción de inventario, el uso de un precio actual para interpretar una venta anterior y la devolución incorrecta de stock durante una anulación. Estos riesgos justifican controles, pero no deben redactarse como incidentes comprobados.

La entrevista no aporta datos suficientes para afirmar cuántos errores ocurren, cuánto dinero se pierde, cuántos productos vencen o cuánto tiempo demora la elaboración de reportes. Por ello, el análisis no incluye cifras, porcentajes, frecuencias ni mejoras de rendimiento inventadas.

## 7. Delimitación del problema

El análisis comprende la información necesaria para controlar productos y presentaciones, proveedores, compras, conteo inicial, existencias por lote y ubicación, ventas, pagos, usuarios, sesiones, entrega de dinero y arqueos.

El negocio registra sus operaciones en bolivianos. No se incluye gestión de clientes ni cuentas por cobrar, porque no registra compradores y no trabaja con ventas al fiado o crédito. Tampoco se identifica una necesidad de conservar todos los cambios de precios: basta con mantener el precio aplicado en cada venta y permitir actualizar el vigente.

La recepción de mercadería ocurre al momento de la compra, por lo que no se confirma un proceso separado de entregas posteriores. Almacén y heladera son lugares de almacenamiento; sus nombres no determinan por sí solos que deba existir una tabla independiente para cada uno. La referencia a dos o más cajas se aclaró como una referencia a turnos, sin confirmar la cantidad de cajas físicas.

**REQUIERE CONFIRMACIÓN CON LA DUEÑA:** el tratamiento de la pérdida y del dinero cuando la mercadería no regresa al anular; las devoluciones en efectivo o mixtas y sus constancias; las devoluciones parciales, si existen; y los costos, datos de lote, vencimientos y antigüedad disponibles para el conteo inicial. La identificación de cajas físicas también debe aclararse si se plantea incorporar ese control.

## 8. Formulación del problema

**¿Cómo organizar y relacionar la información de las ventas, compras, existencias, pagos y caja por turno de París Licorería para facilitar su registro, consulta y control de acuerdo con el funcionamiento real del negocio?**

Esta pregunta orienta la revisión de la base de datos existente. Su respuesta debe apoyarse en las necesidades confirmadas, conservar las estructuras que ya las representan correctamente y justificar cualquier ajuste posterior. La problemática no se define por la cantidad de tablas ni se resuelve únicamente agregando nuevas entidades.

## 9. Correspondencia con la sistematización

| Tema de este análisis | Apartados de la sistematización |
|---|---|
| Organización y responsabilidad | S01 y S14 |
| Ventas, presentaciones y búsqueda | S02, S03 y S04 |
| Existencias, lotes, pérdidas y ubicaciones | S05, S06, S07 y S08 |
| Precios, proveedores y compras | S09 y S10 |
| Pagos, anulaciones y ventas al contado | S11, S12 y S13 |
| Arqueo y entrega entre turnos | S15 y S16 |
| Reportes y consulta administrativa | S17 |
| Conteo inicial | S18 |

Este documento desarrolla la problemática del negocio. Los ajustes de integridad encontrados en la auditoría del SQL se revisarán en la etapa técnica correspondiente, sin confundirlos con hechos observados durante la entrevista.
