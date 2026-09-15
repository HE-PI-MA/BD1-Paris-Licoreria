# Sistematización de la entrevista — París Licorería

## 1. Propósito y fuentes

Este documento organiza la información de la entrevista para explicar cómo cada necesidad del negocio se relaciona con los datos, las entidades y las reglas de la base de datos.

**Actividad central del negocio: VENTA DE PRODUCTOS.** Las compras, el inventario, los pagos y el control de caja apoyan esa actividad.

La fuente principal es [Entrevista_Paris_Licoreria.md](Entrevista_Paris_Licoreria.md): entrevista original del **20 de agosto de 2026**, actualizada con las aclaraciones comunicadas por el responsable del proyecto el **15 de septiembre de 2026**. Se utiliza la versión incorporada mediante la solicitud #2, commit `6ab328a0c7baa9051b0c2634de8324e8ddcdd916`.

Para contrastar las necesidades se consultan las [entidades](../03_Modelo_ER/Entidades_Paris_Licoreria.md), el [modelo relacional](../04_Modelo_Relacional/Modelo_Relacional_Paris_Licoreria.md), las [tablas SQL](../05_SQL/02_creacion_tablas.sql), las [rutinas](../05_SQL/03_rutinas.sql) y las [vistas](../05_SQL/04_vistas.sql) de la V2.

Se distingue entre lo declarado en la entrevista y las conclusiones del análisis. Una dificultad posible se presenta como riesgo, no como un incidente que necesariamente haya ocurrido. Las entidades y atributos mencionados corresponden al modelo existente, salvo donde se indica que su representación está pendiente de diseño.

Esta etapa no modifica los requerimientos, diagramas, tablas ni SQL. Las reglas descritas son reglas del negocio o condiciones derivadas para su revisión; no se afirma que todas estén implementadas.

## 2. Análisis de respuestas y necesidades

### S01. Organización y responsables

**Fuente:** preguntas 1–6 y 50–51.

| Elemento | Análisis |
|---|---|
| Información obtenida | El negocio funciona hace más de cuatro años, cuenta aproximadamente con dos o tres trabajadores y organiza la atención por turnos. La dueña administra y realiza principalmente las compras. Cada trabajador necesita su propio usuario. |
| Problema o necesidad de control | Se necesita identificar quién realiza cada operación y diferenciar las funciones administrativas de las funciones de venta. |
| Información que debe registrarse | Datos del trabajador, identificación de acceso, rol y estado de su cuenta. |
| Entidades y atributos principales | `USUARIO`: id_usuario, id_rol, nombre, apellido, nombre_usuario, contrasena, estado. `ROL`: id_rol, nombre, descripcion. La contraseña se representa mediante un hash, como decisión técnica de seguridad. |
| Relaciones | ROL 1:N USUARIO. USUARIO 1:N COMPRA. USUARIO 1:N SESION_CAJA. USUARIO 1:N AJUSTE_INVENTARIO. |
| Regla de negocio | Cada trabajador utiliza su propia cuenta. La administradora y el encargado tienen funciones distintas. |
| Contraste con V2 | Las entidades existen. Su presencia no demuestra por sí sola que una aplicación ya aplique todos los permisos. No se necesita guardar los años de funcionamiento ni la cantidad aproximada de trabajadores como tablas operativas. |

### S02. Registro de ventas

**Fuente:** preguntas 7–8 y 39–41; regla RN03 de la entrevista.

| Elemento | Análisis |
|---|---|
| Información obtenida | Las ventas se anotan con papel y lápiz. No existe un sistema digital que controle completamente ventas e inventario. Una venta puede contener uno o varios productos. |
| Problema o necesidad de control | Organizar las ventas y facilitar su consulta sin depender de revisar las anotaciones manuales. |
| Información que debe registrarse | Fecha y hora, sesión, responsable, presentaciones vendidas, cantidades, precios aplicados, pagos y estado. Deben poder obtenerse subtotal y total. |
| Entidades y atributos principales | `VENTA`: id_venta, id_sesion_caja, fecha_hora, estado, motivo_anulacion. `DETALLE_VENTA`: id_detalle_venta, id_venta, id_presentacion, cantidad, precio_unitario. |
| Relaciones | SESION_CAJA 1:N VENTA. VENTA 1:N DETALLE_VENTA. PRESENTACION_PRODUCTO 1:N DETALLE_VENTA. El responsable se obtiene mediante la sesión. |
| Regla de negocio | Una venta confirmada tiene al menos un detalle. Subtotal = cantidad por precio aplicado, redondeado a dos decimales. Total = suma de esos subtotales. El redondeo es la convención implementada en V2. |
| Contraste con V2 | La separación entre venta y detalle existe y debe conservarse. Los importes se calculan. Falta reflejar claramente los atributos derivados y las participaciones mínimas en el modelo conceptual. |

### S03. Productos, categorías y presentaciones

**Fuente:** preguntas 10–13.

| Elemento | Análisis |
|---|---|
| Información obtenida | Se venden bebidas alcohólicas y otros productos. Pueden comercializarse por unidad, paquete, caja, fardo o peso; un mismo producto puede tener distintas presentaciones y precios. |
| Problema o necesidad de control | Identificar el producto y sus formas de venta sin mantener existencias independientes e inconexas de cada presentación. |
| Información que debe registrarse | Nombre y descripción del artículo, categoría, unidad base, presentaciones, equivalencias, precios y estado. Se requieren cantidades decimales para productos por peso. |
| Entidades y atributos principales | `PRODUCTO`: id_producto, nombre, descripcion, id_categoria, id_unidad_medida, estado. `CATEGORIA`: id_categoria, nombre. `UNIDAD_MEDIDA`: id_unidad_medida, nombre, abreviatura. `PRESENTACION_PRODUCTO`: id_presentacion, id_producto, nombre_presentacion, factor_conversion, precio_venta, estado. |
| Relaciones | CATEGORIA 1:N PRODUCTO. UNIDAD_MEDIDA 1:N PRODUCTO. PRODUCTO 1:N PRESENTACION_PRODUCTO. |
| Regla de negocio | Una presentación corresponde a un producto. El factor expresa cuántas unidades base representa. Las cantidades por peso pueden contener decimales. |
| Contraste con V2 | La estructura existe. Caja y paquete son presentaciones comerciales; debe evitarse confundirlas con la unidad base usada para controlar existencias. Las equivalencias concretas deben corresponder a cada producto real. |

### S04. Códigos de barras y búsqueda

**Fuente:** preguntas 14–16.

| Elemento | Análisis |
|---|---|
| Información obtenida | La mayoría de los productos tiene código de barras. Se desea buscar productos registrados utilizando la cámara del celular y permitir búsqueda manual cuando no haya código. |
| Problema o necesidad de control | Encontrar rápidamente la presentación correcta durante una venta. |
| Información que debe registrarse | Código de barras cuando exista, nombre del producto y categoría para búsquedas manuales. |
| Entidades y atributos principales | `PRESENTACION_PRODUCTO.codigo_barras`, `PRODUCTO.nombre`, `PRODUCTO.id_categoria` y `CATEGORIA.nombre`. |
| Relaciones | PRODUCTO 1:N PRESENTACION_PRODUCTO. CATEGORIA 1:N PRODUCTO. |
| Regla de negocio | Un producto sin código puede localizarse manualmente. Como decisión del modelo actual, el código se asocia a la presentación y es único cuando se informa. |
| Contraste con V2 | El campo existe y admite ausencia de código. La cámara es una función de la aplicación futura. La entrevista solicita localizar productos registrados; no confirma obtener automáticamente sus datos desde un catálogo externo. |

### S05. Existencias y reposición

**Fuente:** preguntas 9 y 17–20.

| Elemento | Análisis |
|---|---|
| Información obtenida | El inventario se controla manualmente. Se necesita conocer cantidades disponibles, productos agotados y productos con poca existencia para reponerlos. |
| Problema o necesidad de control | El control manual dificulta consultar de forma automática qué debe reponerse. |
| Información que debe registrarse | Cantidad física por lote y ubicación y mínimo de reposición por producto. La disponibilidad se obtiene considerando los lotes aptos para venta. |
| Entidades y atributos principales | `LOTE_UBICACION`: id_lote_ubicacion, id_lote, id_ubicacion, cantidad_actual. `PRODUCTO.stock_minimo`. `LOTE_PRODUCTO.fecha_vencimiento`. |
| Relaciones | LOTE_PRODUCTO 1:N LOTE_UBICACION. UBICACION 1:N LOTE_UBICACION. El producto se identifica mediante el origen del lote. |
| Regla de negocio | Las existencias no pueden ser negativas. Stock disponible cero significa agotado; el mínimo permite identificar necesidades de reposición. |
| Contraste con V2 | No hace falta una tabla llamada STOCK. `cantidad_actual` conserva la existencia y las vistas calculan sus totales. `stock_minimo` es una configuración por producto, no una duplicación de la existencia. Deben unificarse los criterios de disponibilidad de las vistas y de la venta. |

### S06. Lotes, vencimientos y orden de salida

**Fuente:** preguntas 22–25 y 66.

| Elemento | Análisis |
|---|---|
| Información obtenida | Pueden llegar productos nuevos mientras todavía hay mercadería anterior. Se vende primero lo que ingresó antes. Algunos productos vencen. Una compra puede incluir distintos lotes o vencimientos del mismo producto. |
| Problema o necesidad de control | Distinguir los ingresos y evitar vender mercadería vencida o perder la identificación de su procedencia. |
| Información que debe registrarse | Código de lote cuando exista, vencimiento cuando corresponda, cantidad inicial, compra de origen, ubicación y cantidades utilizadas en ventas. |
| Entidades y atributos principales | `LOTE_PRODUCTO`: id_lote, id_detalle_compra, codigo_lote, fecha_vencimiento, cantidad_inicial. `DETALLE_VENTA_LOTE`: id_detalle_venta, id_lote_ubicacion, cantidad_base. |
| Relaciones | DETALLE_COMPRA 1:N LOTE_PRODUCTO. LOTE_PRODUCTO 1:N LOTE_UBICACION. DETALLE_VENTA 1:N DETALLE_VENTA_LOTE. LOTE_UBICACION 1:N DETALLE_VENTA_LOTE. |
| Regla de negocio | Aplicar FIFO entre existencias vendibles. Un producto vencido no se vende. Una línea de venta puede consumir más de un lote. |
| Contraste con V2 | Las relaciones existen. El producto del lote se obtiene mediante DETALLE_COMPRA y PRESENTACION_PRODUCTO; no requiere repetir id_producto en el lote. La rutina de compra crea un lote por elemento recibido: debe revisarse cómo capturar varios lotes de una compra real y cómo ordenar el inventario inicial. |

### S07. Pérdidas y retiro de vencidos

**Fuente:** preguntas 21 y 25.

| Elemento | Análisis |
|---|---|
| Información obtenida | El control debe considerar daños, vencimientos y otras pérdidas. La mercadería vencida deja de venderse y debe desecharse. |
| Problema o necesidad de control | Una reducción de existencias necesita una causa identificable. |
| Información que debe registrarse | Existencia afectada, cantidad retirada, tipo de pérdida, responsable, fecha y observación cuando corresponda. |
| Entidades y atributos principales | `AJUSTE_INVENTARIO`: id_ajuste, id_lote_ubicacion, id_usuario, fecha_hora, tipo_ajuste, cantidad, observacion. |
| Relaciones | LOTE_UBICACION 1:N AJUSTE_INVENTARIO. USUARIO 1:N AJUSTE_INVENTARIO. |
| Regla de negocio | Un retiro no supera la cantidad física existente. El vencimiento excluye la mercadería de la venta; el retiro físico debe quedar registrado. |
| Contraste con V2 | La entidad está justificada y existen rutinas de descuento. No se debe usar un ajuste de pérdida para simular una compra ni para registrar el conteo inicial. |

### S08. Ubicación y distribución de mercadería

**Fuente:** preguntas 26–27 y 64–65.

| Elemento | Análisis |
|---|---|
| Información obtenida | Los productos pueden distribuirse entre lugares del negocio. Pueden ingresar directamente al almacén o a la heladera. Interesa conocer cantidades por ubicación; no se solicitó identificar al responsable de cada traslado. |
| Problema o necesidad de control | Saber dónde está la mercadería y cuánta existe en cada lugar. |
| Información que debe registrarse | Identificación del lugar, lote y cantidad física existente. |
| Entidades y atributos principales | `UBICACION`: id_ubicacion, nombre, descripcion, estado. `LOTE_UBICACION`: id_lote, id_ubicacion, cantidad_actual. |
| Relaciones | LOTE_PRODUCTO N:M UBICACION, resuelta mediante LOTE_UBICACION. |
| Regla de negocio | Una distribución entre lugares conserva la cantidad total del lote. No se exige que toda mercadería pase primero por el almacén. |
| Contraste con V2 | Almacén puede representarse como una ubicación. No se justifica una tabla ALMACEN por su nombre. Debe completarse la operación controlada para distribuir o trasladar cantidades, sin asumir que se necesita un historial independiente de traslados. |

### S09. Precio vigente y precio aplicado

**Fuente:** preguntas 28–30 y 68.

| Elemento | Análisis |
|---|---|
| Información obtenida | Los precios cambian por factores como el costo de adquisición y la variación del dólar. La administradora actualiza precios. Solo se requiere conocer el precio utilizado en cada venta. |
| Problema o necesidad de control | Actualizar precios sin alterar el valor de ventas anteriores. |
| Información que debe registrarse | Precio vigente de cada presentación y precio aplicado a cada detalle vendido. |
| Entidades y atributos principales | `PRESENTACION_PRODUCTO.precio_venta` y `DETALLE_VENTA.precio_unitario`. |
| Relaciones | PRESENTACION_PRODUCTO 1:N DETALLE_VENTA. |
| Regla de negocio | El cambio de precio vigente no modifica el precio registrado en una venta anterior. |
| Contraste con V2 | La separación existe y se conserva. No se justifica un historial completo de cambios de precio. Debe protegerse el detalle histórico frente a modificaciones no permitidas. |

### S10. Proveedores y compras

**Fuente:** preguntas 5, 31–38 y 63.

| Elemento | Análisis |
|---|---|
| Información obtenida | La dueña compra principalmente a distribuidores y empresas. Sus datos no siempre están organizados. Un producto puede obtenerse de varios proveedores y una compra puede incluir varios productos. La mercadería llega al comprar. |
| Problema o necesidad de control | Organizar proveedores, conservar el origen de la mercadería y registrar cantidades y costos de adquisición. |
| Información que debe registrarse | Proveedor y contacto, fecha de compra, responsable, presentaciones adquiridas, cantidades y costos por presentación. El total se obtiene de los detalles. |
| Entidades y atributos principales | `PROVEEDOR`: id_proveedor, nombre, contacto, telefono, direccion, estado. `COMPRA`: id_compra, id_proveedor, id_usuario, fecha_hora, observacion. `DETALLE_COMPRA`: id_detalle_compra, id_compra, id_presentacion, cantidad, costo_unitario. |
| Relaciones | PROVEEDOR 1:N COMPRA. USUARIO 1:N COMPRA. COMPRA 1:N DETALLE_COMPRA. PRESENTACION_PRODUCTO 1:N DETALLE_COMPRA. DETALLE_COMPRA 1:N LOTE_PRODUCTO. |
| Regla de negocio | Una compra confirmada contiene uno o varios detalles. Su registro incluye el ingreso recibido. Costo de adquisición y precio de venta son conceptos distintos. |
| Contraste con V2 | La estructura representa las compras posteriores al inicio. No se confirmó recepción separada ni costos adicionales como fletes, impuestos o aranceles. La procedencia histórica de un producto se consulta mediante sus compras, sin necesitar PRODUCTO_PROVEEDOR para ese fin. |

### S11. Pagos y moneda

**Fuente:** preguntas 42–44, 49 y 67.

| Elemento | Análisis |
|---|---|
| Información obtenida | Se cobra en efectivo, QR o combinando ambos. Se desea conservar el comprobante QR. Las ventas se pagan al momento y las operaciones se registran en bolivianos. |
| Problema o necesidad de control | Identificar cuánto se pagó por cada medio y relacionarlo con la venta correspondiente. |
| Información que debe registrarse | Venta, medio de pago, importe y referencia del comprobante QR. |
| Entidades y atributos principales | `PAGO`: id_pago, id_venta, metodo_pago, monto, comprobante_qr. |
| Relaciones | VENTA 1:N PAGO. Una venta confirmada tiene al menos un pago. |
| Regla de negocio | Una venta puede combinar efectivo y QR. La suma de pagos aplicados debe cubrir exactamente el total; el monto aplicado no representa un billete entregado antes de dar cambio. Los importes están en bolivianos. |
| Contraste con V2 | PAGO y el soporte mixto existen. No es obligatorio crear METODO_PAGO para dos valores controlados. La referencia QR no almacena por sí sola la imagen ni comprueba que una transferencia bancaria haya ocurrido. La entrega y conservación del archivo corresponden también a la aplicación. |

### S12. Anulación, mercadería y devolución del pago

**Fuente:** preguntas 45–47 y 69–70; aclaración de autorización y plazo incluida en la pregunta 45.

| Elemento | Análisis |
|---|---|
| Información obtenida | El encargado puede anular ventas de su propia sesión durante su turno abierto y con motivo obligatorio. La venta se conserva. Se necesita distinguir si los productos regresan. Para un pago QR, se indicó devolución por QR. |
| Problema o necesidad de control | Conservar la explicación y evitar que una anulación produzca existencias que no regresaron o altere cierres anteriores. |
| Información que debe registrarse | Identificación de venta y sesión, estado, motivo y resultado del regreso de mercadería. Debe aclararse la constancia de devolución del dinero. |
| Entidades y atributos principales | Existen `VENTA.estado`, `VENTA.motivo_anulacion`, `SESION_CAJA`, `DETALLE_VENTA_LOTE` y `PAGO`. La V2 no distingue mediante un dato específico si regresó la mercadería. La representación adicional queda pendiente de diseño. |
| Relaciones | SESION_CAJA 1:N VENTA. VENTA 1:N DETALLE_VENTA. VENTA 1:N PAGO. DETALLE_VENTA 1:N DETALLE_VENTA_LOTE. |
| Regla de negocio | Solo se anulan ventas de la propia sesión mientras está abierta y con justificación. Anular no significa necesariamente recuperar físicamente los productos. La venta no se elimina. |
| Contraste con V2 | La rutina devuelve siempre todo el stock y no restringe la anulación a una sesión abierta. Debe corregirse posteriormente. **REQUIERE CONFIRMACIÓN CON LA DUEÑA:** pérdida y dinero cuando el comprador se fue, devoluciones en efectivo o mixtas, devoluciones parciales y constancias. No se presupone devolución automática por integración bancaria. |

### S13. Compradores y ventas al contado

**Fuente:** preguntas 48–49.

| Elemento | Análisis |
|---|---|
| Información obtenida | No se registran los datos de los compradores. No hay ventas al fiado o crédito. |
| Problema o necesidad de control | Registrar la venta y su pago sin exigir datos de compradores que el negocio no utiliza. |
| Información que debe registrarse | Los datos de la venta y sus pagos, sin identificación personal del comprador. |
| Entidades y atributos principales | VENTA y PAGO. No surge una necesidad de CLIENTE ni de cuentas por cobrar. |
| Relaciones | VENTA 1:N PAGO. |
| Regla de negocio | El pago se realiza al momento. No se exige registrar un cliente para vender. |
| Contraste con V2 | La ausencia de CLIENTE es coherente con el alcance. No se agregan categorías de clientes por analogía con otros negocios. |

### S14. Sesión de caja por turno

**Fuente:** preguntas 3, 51–54 y 71.

| Elemento | Análisis |
|---|---|
| Información obtenida | Cada vendedor es responsable durante su turno. Los turnos se suceden y se registra un monto inicial. No se realizan otros ingresos o retiros de efectivo durante el turno. La mención de dos o más cajas se aclaró como referencia a turnos. |
| Problema o necesidad de control | Separar las operaciones de cada encargado y conocer el período durante el que tiene responsabilidad. |
| Información que debe registrarse | Responsable, apertura, cierre, monto inicial, estado y observación. |
| Entidades y atributos principales | `SESION_CAJA`: id_sesion_caja, id_usuario, fecha_hora_apertura, fecha_hora_cierre, monto_inicial, estado, observacion. |
| Relaciones | USUARIO 1:N SESION_CAJA. SESION_CAJA 1:N VENTA. SESION_CAJA 1:0..1 ARQUEO_CAJA durante su ciclo; al cerrar debe quedar su arqueo. |
| Regla de negocio | La venta requiere sesión abierta. El cierre termina la responsabilidad del turno. Los períodos deben ser coherentes con las fechas de sus ventas. |
| Contraste con V2 | SESION_CAJA representa el turno trabajado. No hay evidencia suficiente para agregar CAJA física. Deben revisarse la sucesión de sesiones, las fechas y la protección de los cierres; no basta con que existan campos de apertura y cierre. |

### S15. Arqueo y diferencias

**Fuente:** preguntas 54–59, 62 y 71.

| Elemento | Análisis |
|---|---|
| Información obtenida | Al terminar se cuentan billetes y monedas, se compara el efectivo con lo esperado y se registra una explicación obligatoria si hay diferencia. La dueña revisa los cierres. |
| Problema o necesidad de control | Conservar un conteo detallado y permitir revisar faltantes o sobrantes por turno. |
| Información que debe registrarse | Sesión, fecha, denominaciones, cantidades contadas y observación. Deben obtenerse efectivo contado, esperado y diferencia. |
| Entidades y atributos principales | `ARQUEO_CAJA`: id_arqueo, id_sesion_caja, fecha_hora, observacion. `DETALLE_ARQUEO`: id_arqueo, id_denominacion, cantidad. `DENOMINACION`: id_denominacion, valor, tipo, estado. |
| Relaciones | SESION_CAJA 1:0..1 ARQUEO_CAJA. ARQUEO_CAJA 1:N DETALLE_ARQUEO. DENOMINACION 1:N DETALLE_ARQUEO. |
| Regla de negocio | Contado = suma de valor por cantidad de cada denominación. Diferencia = contado menos esperado. QR no integra el efectivo físico. La explicación es obligatoria cuando existe diferencia. |
| Contraste con V2 | Las tablas y cálculos existen. El esperado actual es monto inicial más pagos en efectivo de ventas vigentes. Su uso definitivo debe concordar con la política de anulaciones y devoluciones. Los datos del conteo y de sus denominaciones deben protegerse para que un arqueo histórico no cambie después. |

### S16. Entrega de dinero entre turnos

**Fuente:** preguntas 54 y 60.

| Elemento | Análisis |
|---|---|
| Información obtenida | Se entrega el dinero contado y se deja constancia. Se necesita identificar quién entrega, quién recibe y cuánto se entrega. |
| Problema o necesidad de control | El registro de una apertura y un cierre por separado no deja necesariamente una constancia explícita de la entrega entre ambos responsables. |
| Información que debe registrarse | Responsable que entrega, responsable que recibe e importe entregado. La vinculación con las sesiones es una conclusión del análisis para mantener su contexto. |
| Entidades y atributos principales | Existen USUARIO y SESION_CAJA. Se identifica el concepto de entrega de caja; su representación mediante atributos, relaciones o una entidad propia está pendiente de diseño. |
| Relaciones | La entrega debe poder asociarse con los responsables y las sesiones correspondientes. No se fijan todavía cardinalidades que no estén aclaradas. |
| Regla de negocio | La entrega deja constancia del dinero contado y de ambas personas. No se presume automáticamente que el importe entregado sea igual al efectivo esperado ni que cualquier sesión siguiente sea la receptora. |
| Contraste con V2 | El modelo actual no tiene una constancia específica de entrega. La necesidad ahora está confirmada; debe revisarse antes de decidir cambios en las tablas. |

### S17. Reportes para la administración

**Fuente:** preguntas 61–62.

| Elemento | Análisis |
|---|---|
| Información obtenida | La dueña necesita ventas por período, productos más vendidos, faltantes, compras, inventario, cierres y diferencias. |
| Problema o necesidad de control | Obtener información sin revisar manualmente todas las anotaciones. |
| Información que debe registrarse | Fechas, cantidades, precios, estados, pagos, existencias y conteos en sus operaciones de origen. |
| Entidades y atributos principales | VENTA, DETALLE_VENTA, PRODUCTO, PRESENTACION_PRODUCTO, COMPRA, DETALLE_COMPRA, LOTE_PRODUCTO, LOTE_UBICACION, SESION_CAJA, PAGO y ARQUEO_CAJA con sus detalles. |
| Relaciones | Se utilizan las relaciones ya descritas para ventas, compras, inventario y caja. |
| Regla de negocio | Cada reporte debe indicar qué período, estado y unidad considera. Como conclusión del análisis, no deben sumarse gramos y unidades como si fueran la misma cantidad. |
| Contraste con V2 | Existen vistas y consultas. No se necesita una tabla REPORTE para resultados calculados. Deben corregirse las consultas que confunden varios pagos del mismo método con pago mixto o comparan cantidades de unidades diferentes. |

### S18. Conteo inicial de mercadería

**Fuente:** pregunta 72 y aclaración final: “un conteo para registrar al sistema”.

| Elemento | Análisis |
|---|---|
| Información obtenida | Para comenzar se cuenta la mercadería que ya existe. No se confirmó reconstruir todas sus compras anteriores. |
| Problema o necesidad de control | Registrar las existencias iniciales reales sin inventar operaciones de compra ni proveedores. |
| Información que debe registrarse | Como propuesta derivada del análisis: producto, cantidad contada y ubicación; lote y vencimiento cuando se conozcan. La fecha y el responsable del registro permiten identificar el conteo. Su detalle se revisará antes de aprobar el modelo. |
| Entidades y atributos principales | Se relaciona con PRODUCTO, sus presentaciones cuando se utilicen para contar, UBICACION y las existencias por lote. El concepto de conteo inicial surge de una necesidad confirmada, pero todavía no tiene una representación independiente aprobada. |
| Relaciones | El conteo puede incluir varios productos y debe dar origen a existencias identificables. Debe distinguirse del origen por compra. Las relaciones físicas definitivas quedan pendientes de diseño. |
| Regla de negocio | El conteo establece el saldo inicial. No se registran compras ficticias para ingresarlo. Las compras posteriores se registran como operaciones nuevas. |
| Contraste con V2 | Todo LOTE_PRODUCTO exige actualmente id_detalle_compra. Esta dependencia debe revisarse para admitir el origen inicial. **REQUIERE CONFIRMACIÓN CON LA DUEÑA:** costos conocidos, identificación de lotes y vencimientos disponibles, y antigüedad de mercadería para iniciar FIFO. No se asignan costos ni fechas anteriores inventados. |

## 3. Resultado de la comparación

| Situación | Resultado |
|---|---|
| Diseño que se conserva como base | Producto y presentaciones; compra y detalle; venta y detalle; pagos; lotes; existencias por ubicación; salidas por lote; ajustes; usuarios; sesiones; arqueos y denominaciones. |
| Decisiones confirmadas en la actualización | Pago mixto; bolivianos; precio histórico por venta; anulación durante la propia sesión con motivo; explicación obligatoria de diferencias; entrega con constancia; ingreso junto con compra; conteo inicial. |
| Necesidades confirmadas cuya representación debe revisarse | Conteo inicial, constancia de entrega y distinción del regreso de mercadería al anular. No se asigna todavía un número final de tablas. |
| Operaciones que necesitan revisión | Anulación después de cierre, devolución automática de todo el stock, conservación del arqueo histórico, distribución por ubicación, criterios de disponibilidad y coherencia temporal. |
| Entidades sin justificación actual para agregarse | CLIENTE, categorías de clientes, cuentas por cobrar, CAJA física, ALMACEN independiente, historial completo de precios y recepción independiente. |
| Fuera de una conclusión automática | Integraciones bancarias, catálogo externo de productos, otros tipos de moneda, impuestos, fletes o aranceles no declarados. |

Que una estructura tenga 21 tablas no obliga a conservar ese número si una necesidad confirmada exige un ajuste. Tampoco justifica aumentarlo. Cualquier modificación debe demostrar qué información falta y por qué no puede representarse correctamente con la estructura existente.

## 4. Confirmaciones pendientes

Se mantiene lo señalado en la sección 28 de la entrevista. **REQUIERE CONFIRMACIÓN CON LA DUEÑA**:

1. Cantidad e identificación de cajas físicas, si ese control resulta necesario. Los turnos no prueban que existan cajas físicas diferentes.
2. Tratamiento de la pérdida y del dinero cuando se anula y la mercadería no regresa, incluido el caso de billete falso.
3. Forma y constancia de devolución de pagos en efectivo o mixtos, además de la devolución QR ya indicada.
4. Existencia y tratamiento de devoluciones parciales.
5. Costos, lotes, vencimientos y antigüedad que pueden conocerse durante el conteo inicial.
6. Datos adicionales de identificación del negocio que se requieran para la presentación académica.

Estos asuntos no se consideran reglas definitivamente resueltas ni autorizan a inventar datos para completar el SQL.

## 5. Índice de trazabilidad de preguntas

| Preguntas de la entrevista | Apartados de esta sistematización |
|---|---|
| 1–6 | S01; pregunta 3 también en S14 y pregunta 5 también en S10 |
| 7–8 | S02 |
| 9 | S05 |
| 10–13 | S03 |
| 14–16 | S04 |
| 17–20 | S05 |
| 21 | S07 |
| 22–25 | S06; pregunta 25 también en S07 |
| 26–27 | S08 |
| 28–30 | S09 |
| 31–38 | S10 |
| 39–41 | S02 |
| 42–44 | S11 |
| 45–47 | S12 |
| 48–49 | S13; pregunta 49 también en S11 |
| 50–51 | S01; pregunta 51 también en S14 |
| 52–54 | S14; pregunta 54 también en S15 y S16 |
| 55–59 | S15 |
| 60 | S16 |
| 61–62 | S17; pregunta 62 también en S15 |
| 63 | S10 |
| 64–65 | S08 |
| 66 | S06 |
| 67 | S11 |
| 68 | S09 |
| 69–70 | S12 |
| 71 | S14 y S15 |
| 72 | S18 |

## 6. Cierre de esta etapa

La entrevista queda organizada en 18 grupos de análisis que cubren sus 72 preguntas. Cada grupo explica la necesidad, los datos relacionados, su representación actual y las reglas correspondientes.

El resultado permite continuar con la descripción y análisis de la problemática y, posteriormente, revisar actividad central, entidades principales, requerimientos, modelos y SQL en el orden acordado. La presente sistematización no sustituye esas etapas ni aprueba cambios estructurales por adelantado.
