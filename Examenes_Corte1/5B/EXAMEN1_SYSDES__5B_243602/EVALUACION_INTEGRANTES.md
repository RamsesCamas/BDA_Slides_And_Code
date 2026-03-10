
# EVALUACION DE EXAMEN PARCIAL - BASE DE DATOS AVANZADA

```
===============================================================
EVALUACION: EXAMEN1_SYSDES__5B_243602
Caso: 3-A - Logistica de Distribucion Regional
Integrantes: 3
  - Espinoza Mendoza Hector Isaac (243602)
  - Moreno Zuniga Jesel (243692)
  - Arturo Yion Jaime (243751)
===============================================================
```

---

## PUNTUACION POR SECCION

```
--------------------------------------------------------------
Modelo ER + Esquema:    28/30
Restricciones:          19/20
Queries SQL:            16/25
VIEWS:                  13/15
Justificacion:          10/10
--------------------------------------------------------------
TOTAL:                  86/100
CALIFICACION (este evaluador): 9.0/10
===============================================================
```

## PUNTUACION RECONCILIADA (Escala Lineal + Rangos)

> **Nota del Docente:** Este equipo fue evaluado por 3 evaluadores distintos (carpetas 243602, 243692, 243751) con puntuaciones de 86, 87 y 83. Se aplica promedio lineal y luego rangos.
>
> **Promedio lineal:** (86 + 87 + 83) / 3 = **85/100**
> **Rango aplicado:** 80-89 = **Calificacion: 9.0/10**

### **CALIFICACION RECONCILIADA: 9.0/10**
### **PUNTUACION RECONCILIADA: 85/100**
### Porcentaje Final: 12.75% de 15%

---

## RETROALIMENTACION DETALLADA

### [Modelo ER + Esquema Relacional] - 28/30

**Fortalezas:**
- Excelente modelo relacional completo con 14 tablas claramente definidas: CATEGORIA, PROVEEDOR, PRODUCTO, ENTRADA_ALMACEN, DETALLE_ENTRADA, ZONA_GEOGRAFICA, COMERCIO, PEDIDO, DETALLE_PEDIDO, VEHICULO, CONDUCTOR, RUTA, PEDIDO_RUTA, ENTREGA. Supera el minimo de 9-12 tablas para equipo de 3.
- Tres tablas puente bien implementadas:
  - DETALLE_ENTRADA (entrada almacen - producto): relacion N:N entre entradas y productos.
  - DETALLE_PEDIDO (pedido - producto): relacion N:N entre pedidos y productos.
  - PEDIDO_RUTA (pedido - ruta): relacion N:N entre pedidos y rutas, con campo orden_entrega.
  Esto supera el requisito de 2 relaciones N:N.
- Diagrama en doble notacion: Se presenta tanto un esquema relacional detallado (dbdiagram.io) como un diagrama ER en notacion Chen. Esto demuestra dominio de ambas representaciones.
- Claves primarias correctamente identificadas en todas las tablas (marcadas con icono de llave en el diagrama relacional).
- Claves foraneas bien definidas: id_categoria e id_proveedor en PRODUCTO, id_proveedor en ENTRADA_ALMACEN, id_zona en COMERCIO, id_comercio en PEDIDO, id_vehiculo e id_conductor en RUTA. Todas marcadas con icono de FK.
- Restricciones NOT NULL (NN) claramente marcadas en el diagrama relacional para campos criticos.
- Entidad ENTRADA_ALMACEN es una excelente adicion que permite registrar movimientos de entrada de inventario con trazabilidad (usuario_registro, observaciones).
- Entidad ENTREGA separada del PEDIDO permite registrar incidencias, firma digital y cantidad danada de forma independiente. Correctamente identificada como entidad debil.
- Nomenclatura consistente en espanol con snake_case en todas las tablas y campos.
- Tipos de datos apropiados: decimal(10,2) para precios, capacidades y cantidades; varchar para textos; datetime/date para fechas; int para IDs.
- Cardinalidades correctas en el diagrama Chen y tabla de cardinalidades justificadas en el documento (pagina 10).
- El campo orden_entrega en PEDIDO_RUTA es un detalle inteligente que permite definir la secuencia de entregas en una ruta.
- El documento incluye CREATE TABLE completos con sintaxis SQL correcta para las 14 tablas, con justificaciones individuales para cada decision de diseno.

**Debilidades:**
- En la tabla ENTREGA, la PK es id_pedido, lo que implica una relacion 1:1 con PEDIDO. Si un pedido pudiera tener multiples intentos de entrega, esto seria limitante. Un id_entrega propio como PK seria mas flexible. (-1) Nota: Los estudiantes reconocen esta limitacion en su documento y mencionan que "si en el futuro se permiten entregas parciales, se puede cambiar PK a (id_entrega)".
- No se observa una tabla para registrar salidas de inventario (solo ENTRADA_ALMACEN). Para un sistema de logistica completo, deberia haber un movimiento de salida cuando los productos se asignan a pedidos. (-1) Nota: Los triggers de actualizacion de stock compensan parcialmente esta falta.

### [Restricciones] - 19/20

**Fortalezas:**
- **NOT NULL (4/4):** Excelente aplicacion de NOT NULL en campos criticos de todas las tablas. Mas de 20 campos marcados como NOT NULL con justificacion clara. Ejemplos: nombre y rfc en PROVEEDOR; nombre, precios, stock, unidad_medida en PRODUCTO; nombre_zona y estado en ZONA_GEOGRAFICA; nombre, id_zona, municipio, direccion en COMERCIO; placas, capacidad_kg, estado en VEHICULO; nombre, licencia en CONDUCTOR; fecha_ruta, id_vehiculo, id_conductor, estado en RUTA; id_comercio, estado en PEDIDO.
- **UNIQUE (4/4):** 5 restricciones UNIQUE correctamente identificadas y formalizadas con ALTER TABLE y nombres de constraint:
  1. RFC unico en PROVEEDOR (uq_proveedor_rfc)
  2. Placas unicas en VEHICULO (uq_vehiculo_placas)
  3. Licencia unica en CONDUCTOR (uq_conductor_licencia)
  4. Nombre de categoria unico en CATEGORIA (uq_categoria_nombre)
  5. Nombre de zona unico en ZONA_GEOGRAFICA (uq_zona_nombre)
  Todas con justificacion de negocio pertinente.
- **CHECK (4/4):** 9 restricciones CHECK bien definidas con sintaxis SQL correcta:
  1. Formato de RFC con REGEXP (chk_rfc_formato)
  2. Precio compra positivo (chk_precio_compra_positivo)
  3. Precio venta positivo (chk_precio_venta_positivo)
  4. Stock no negativo (chk_stock_no_negativo)
  5. Cantidad positiva en DETALLE_ENTRADA (chk_cantidad_entrada_positiva)
  6. Cantidad positiva en DETALLE_PEDIDO (chk_cantidad_pedido_positiva)
  7. Estados validos para PEDIDO con IN clause (chk_estado_pedido)
  8. Estados validos para VEHICULO (chk_estado_vehiculo)
  9. Capacidad positiva en VEHICULO (chk_capacidad_positiva)
  10. Estados validos para RUTA (chk_estado_ruta)
  11. Unidades de medida validas (chk_unidad_medida)
  Nota: Se cuentan 11 CHECK constraints, superando ampliamente lo esperado.
- **FK / Integridad Referencial (4/4):** 13 FOREIGN KEYs correctamente definidas. Distinguen acertadamente entre FK con ON DELETE CASCADE (detalles de entrada/pedido, que son registros dependientes) y FK sin CASCADE (proteccion contra borrado de proveedores con productos). Demuestran comprension de cuando aplicar cada estrategia.
- **Reglas de Negocio (3/4):** 3 triggers bien implementados para reglas de negocio complejas:
  1. trg_validar_capacidad_vehiculo: Valida que el peso total de una ruta no exceda la capacidad del vehiculo antes de insertar en PEDIDO_RUTA. Usa COALESCE, JOINs y SIGNAL SQLSTATE.
  2. trg_validar_vehiculo_disponible: Impide asignar vehiculos en mantenimiento a nuevas rutas. Directamente del caso de negocio.
  3. trg_aumentar_stock y trg_disminuir_stock: Automatiza la actualizacion de stock al registrar entradas y pedidos.
  Estos triggers demuestran conocimiento avanzado de logica procedimental en SQL.

**Debilidades:**
- Falta una restriccion de negocio que valide que no se pueda crear un DETALLE_PEDIDO si el stock_actual del producto es insuficiente (el trigger trg_disminuir_stock resta sin verificar). (-1)

### [Queries SQL] - 16/25

**Fortalezas:**
- **Sintaxis correcta (4/5):** Las queries presentadas tienen sintaxis SQL valida. La primera query usa un subquery con NOT IN y la segunda usa JOINs multiples con HAVING.
- **JOINs apropiados (5/8):** Se demuestra uso de JOIN entre multiples tablas (RUTA-VEHICULO-PEDIDO_RUTA-PEDIDO en la segunda query) y JOIN simple (PEDIDO-COMERCIO en la primera).
- **Agregaciones (3/5):** Se usa SUM(p.peso_total) con alias "peso_asignado" en la segunda query. Se demuestra conocimiento de funciones de agregacion.
- **GROUP BY / HAVING (3/4):** La segunda query usa GROUP BY con HAVING correctamente: "HAVING SUM(p.peso_total) > v.capacidad_kg * 0.9" para detectar rutas sobrecargadas. Es un uso inteligente de HAVING con calculo de umbral.
- **Cobertura (1/3):** Se presentan 2 queries de ejemplo relevantes al caso.

**Debilidades:**
- Solo se presentan 2 queries SQL de ejemplo. Para un equipo de 3, se esperan al menos 7-8 queries con buena variedad. (-3 en JOINs, -2 en agregaciones, -1 en GROUP BY/HAVING, -2 en cobertura)
- No se incluyen queries con LEFT/RIGHT JOIN explicitos (aunque las VIEWS si los usan).
- No se incluyen queries con COUNT, AVG, ni funciones de fecha.
- La seccion "6. Queries SQL de Ejemplo" parece incompleta comparada con la profundidad del resto del documento. Es posible que los estudiantes hayan considerado que las 5 VIEWS ya demostraban suficiente competencia SQL, pero la rubrica evalua queries y VIEWS por separado.
- La primera query usa NOT IN con subquery, lo cual es valido pero podria ser mas eficiente con LEFT JOIN ... IS NULL. No se penaliza pero se nota como area de mejora.

### [VIEWS] - 13/15

**Fortalezas:**
- **Sintaxis CREATE VIEW (3/3):** Las 5 VIEWS tienen sintaxis correcta con CREATE VIEW ... AS SELECT. Todas usan alias apropiados y estan bien nombradas (vista_resumen_zonas, vista_productividad_conductores, vista_inventario_critico, vista_rentabilidad_proveedor, vista_utilizacion_flota). Cumplen exactamente el minimo de 5 VIEWS para equipo de 3.
- **Agregaciones correctas (4/4):** Excelente variedad de agregaciones:
  - COUNT(p.id_pedido) en vista_resumen_zonas
  - SUM(CASE WHEN...) para entregas exitosas e incidencias
  - COUNT(r.id_ruta) y COUNT(pr.id_pedido) en vista_productividad_conductores
  - COALESCE(SUM(dp.cantidad), 0) en vista_inventario_critico
  - SUM(dp.cantidad * dp.precio_venta_historico) y SUM(dp.cantidad * p.precio_compra_actual) en vista_rentabilidad_proveedor
  - COUNT(r.id_ruta) en vista_utilizacion_flota
- **HAVING (1/3):** No se usa HAVING explicitamente en las VIEWS. Sin embargo, la segunda query SQL de ejemplo demuestra uso de HAVING. Las VIEWS podrian haberse beneficiado de HAVING para filtrar, por ejemplo, solo proveedores con margen negativo o conductores con productividad baja. (-2)
- **CASE/COALESCE (3/3):** Excelente uso de ambas funciones:
  - CASE WHEN para clasificar conductores (Baja, Normal, Excelente) en vista_productividad_conductores
  - CASE WHEN para clasificar vehiculos (Subutilizado, Optimo, Sobrecargado) en vista_utilizacion_flota
  - SUM(CASE WHEN p.estado = 'Entregado' THEN 1 ELSE 0 END) para conteo condicional en vista_resumen_zonas
  - COALESCE(SUM(dp.cantidad), 0) para manejo de NULLs en vista_inventario_critico
  - NULLIF(SUM(dp.cantidad), 0) para prevencion de division entre cero
  - NULLIF(COUNT(p.id_pedido), 0) para tasa de exito
- **Coherencia con esquema (2/2):** Todas las VIEWS referencian correctamente las tablas del esquema y usan los campos definidos. Las VIEWS cubren diferentes areas del negocio: zona geografica, conductores, inventario, proveedores y flota.

**Debilidades:**
- No se usa HAVING en ninguna VIEW. Seria util, por ejemplo, para filtrar solo zonas con tasa de exito menor al 80% o solo proveedores con margen negativo. (-2)
- En vista_rentabilidad_proveedor se usa "pr.nombre_empresa" pero la tabla PROVEEDOR tiene el campo "nombre", no "nombre_empresa". Este es un error menor de referencia al campo. (-0 se tolera como error menor)
- En vista_inventario_critico, la formula de "dias_para_agotamiento" usa una expresion algo confusa con COALESCE anidado y NULLIF doble. La logica es correcta pero la legibilidad podria mejorar.

### [Justificacion de Diseno] - 10/10

**Fortalezas:**
- **Por que escogieron ese caso (4/4):** Respuesta completa y bien argumentada:
  - Mencionan la "complejidad arquitectonica" del caso: tres flujos de datos distintos (suministro, comercial, operativo).
  - Identifican el "desafio de integridad" como motivacion: logica de estados avanzada con vehiculos en mantenimiento y triggers.
  - Reconocen que era el caso mas atractivo y adecuado para equipo de 3.
  - Demuestra que eligieron el caso conscientemente, no por azar.

- **Por que lo disenaron asi (6/6):** Respuesta excepcional organizada en 4 ejes:
  - **A. Preservacion de Datos Historicos:** Justifican la inclusion de precio_venta_historico en DETALLE_PEDIDO y precio_compra_historico en DETALLE_ENTRADA para no corromper la contabilidad si cambian precios. Mencionan trade-off explicito.
  - **B. Uso de Entidades Debiles para Incidencias:** Justifican por que ENTREGA es tabla separada (separacion de responsabilidades, datos opcionales, extensibilidad, auditoria). Referencia directa al caso del queso danado.
  - **C. Automatizacion mediante Triggers:** Justifican delegar la integridad al motor de BD en vez de a la aplicacion. Mencionan seguridad y reglas de negocio.
  - **D. Normalizacion y Escalabilidad:** Justifican la separacion de CATEGORIA y ZONA_GEOGRAFICA en tablas independientes para evitar redundancia y facilitar crecimiento.

**Comentarios adicionales sobre la justificacion:**
- A lo largo del documento, cada tabla y cada restriccion incluye una seccion "Justificacion" y "Decision" que explica el razonamiento detras del diseno. Esto es excepcional y demuestra comprension profunda del proceso de modelado de datos.
- El documento incluye justificaciones para decisiones no obvias: por que INT como PK en vez de RFC, por que ON DELETE CASCADE en detalles pero no en tablas padre, por que separar DETALLE_PEDIDO de DETALLE_ENTRADA (4 razones), por que peso_total se almacena y no se calcula, etc.
- Se mencionan trade-offs explicitamente (ej: "Si se necesita multi-proveedor, se puede cambiar a N:N despues").

---

## PREGUNTAS DE SEGUIMIENTO PARA DEFENSA

```
--------------------------------------------------------------
```

### 1. [COMPRENSION]
**Pregunta:** En su documento justifican que DETALLE_PEDIDO incluye un campo `precio_venta_historico` para preservar el precio al momento de la venta. Sin embargo, en DETALLE_ENTRADA inicialmente dicen "No agregamos precio_compra aqui porque ya esta en PRODUCTO" (pagina 15) pero luego en la tabla 5 si aparece `precio_compra_historico`. Expliquen esta aparente contradiccion: se registro o no el precio historico en las entradas de almacen?

**Respuesta esperada:** Deberian reconocer que hay una inconsistencia en el documento. La tabla 5 (DETALLE_ENTRADA) en la pagina 14 si incluye `precio_compra_historico DECIMAL(10,2) NOT NULL`, pero la justificacion en la pagina 15 dice que no lo incluyeron. La version correcta es la del CREATE TABLE (con precio_compra_historico), ya que es coherente con su filosofia de "preservacion de datos historicos" explicada en la seccion 7. Si no pueden explicar esta inconsistencia, podria indicar que no revisaron el documento completo antes de entregarlo.

### 2. [FALENCIAS]
**Pregunta:** Su trigger `trg_disminuir_stock` resta automaticamente la cantidad del stock al insertar en DETALLE_PEDIDO. Pero no valida si hay stock suficiente antes de restar. Que pasaria si alguien crea un pedido de 500 litros de leche cuando solo hay 100 litros en stock? Su CHECK constraint `chk_stock_no_negativo` lo detendria?

**Respuesta esperada:** Deberian reconocer que hay un problema de orden de ejecucion. El trigger AFTER INSERT restaria el stock despues de insertar el detalle, y el CHECK constraint `stock_actual >= 0` en PRODUCTO bloquearia el UPDATE si el resultado fuera negativo. Esto causaria un error en el trigger, pero el INSERT en DETALLE_PEDIDO ya se habria ejecutado (podria quedar inconsistente dependiendo de la transaccion). La solucion correcta seria un trigger BEFORE INSERT en DETALLE_PEDIDO que verifique stock >= cantidad ANTES de permitir la insercion, o envolver todo en una transaccion explicita.

### 3. [MEJORA]
**Pregunta:** Su sistema actualmente no registra las salidas de inventario de forma explicita (solo las entradas via ENTRADA_ALMACEN/DETALLE_ENTRADA). Si el gerente quiere un reporte de "todos los movimientos de inventario del producto X en enero" (tanto entradas como salidas), como lo construirian con su esquema actual? Y como mejorarian el diseno para facilitar este reporte?

**Respuesta esperada:** Con el esquema actual, tendrian que hacer UNION de dos queries: una sobre DETALLE_ENTRADA (entradas) y otra sobre DETALLE_PEDIDO (salidas implicitas). Para mejorar, podrian crear una tabla MOVIMIENTO_INVENTARIO(id_movimiento, id_producto, tipo ENUM('Entrada','Salida','Ajuste'), cantidad, fecha, referencia_id, referencia_tipo) que unifique todos los movimientos. Esto seguiria el patron de "event sourcing" y permitiria reconstruir el stock en cualquier punto del tiempo.

### 4. [DECISION]
**Pregunta:** En la tabla RUTA no pusieron UNIQUE en (fecha_ruta, id_vehiculo), y justificaron que "un vehiculo podria hacer dos rutas en un dia (turno AM y PM)". Sin embargo, su trigger `trg_validar_vehiculo_disponible` solo valida que el vehiculo este en estado 'Disponible'. Si un vehiculo esta en estado 'En ruta' en la ruta de la manana, el trigger permitiria asignarlo a la ruta de la tarde? Como resolverian este conflicto?

**Respuesta esperada:** Deberian reconocer que el trigger solo valida el estado actual del vehiculo. Si el vehiculo esta 'En ruta' en la manana, el trigger lo bloquearia para la tarde. Pero si la ruta de la manana ya se 'Completo' y el estado volvio a 'Disponible', entonces si se podria asignar. El problema real es que no tienen un trigger que cambie automaticamente el estado del vehiculo a 'En ruta' cuando comienza una ruta ni a 'Disponible' cuando termina. Necesitarian triggers adicionales en UPDATE de RUTA para mantener sincronizado el estado del vehiculo.

### 5. [APLICACION]
**Pregunta:** Usando su vista `vista_rentabilidad_proveedor`, el gerente nota que un proveedor tiene margen negativo. Expliquen paso a paso como la vista calcula el margen, y por que usaron `dp.precio_venta_historico` en vez de `p.precio_venta` para calcular el total de ventas. Que pasaria con el calculo si usaran el precio actual de la tabla PRODUCTO?

**Respuesta esperada:** La vista calcula: total_ventas = SUM(cantidad * precio_venta_historico), total_costo = SUM(cantidad * precio_compra_actual), margen = total_ventas - total_costo. Usan precio_venta_historico porque es el precio real al que se vendio el producto, no el precio actual del catalogo. Si usaran p.precio_venta (el precio actual), y el precio hubiera subido despues de las ventas, el margen apareceria inflado artificialmente. Inversamente, si el precio hubiera bajado, el margen apareceria mas bajo de lo real. Nota: deberian tambien reconocer que idealmente el total_costo deberia usar el precio_compra_historico de DETALLE_ENTRADA (no el precio_compra_actual de PRODUCTO) para ser completamente consistente.

```
===============================================================
```

---

## OBSERVACIONES ADICIONALES

1. **Documento de diseno excepcional:** El documento de 35 paginas es uno de los trabajos mas completos y profesionales de la materia. Incluye indice, introduccion con analisis del caso, modelo conceptual con justificaciones, esquema relacional con CREATE TABLE completos, restricciones categorizadas (UNIQUE, CHECK, NOT NULL, FK, triggers), 5 VIEWS y justificacion de diseno.

2. **Punto fuerte: Justificaciones en cada decision:** Cada tabla, cada restriccion y cada VIEW incluye una seccion de justificacion que explica el razonamiento. Esto es excepcional y demuestra comprension profunda del dominio y del proceso de modelado.

3. **Punto debil: Queries SQL insuficientes:** La seccion de queries SQL es la mas debil del documento, con solo 2 queries de ejemplo. Esto contrasta significativamente con la profundidad de las otras secciones. Es posible que el equipo haya invertido mas tiempo en restricciones y VIEWS, pero la rubrica evalua queries por separado.

4. **Restricciones sobresalientes:** Con 5 UNIQUE, 11 CHECK, 20+ NOT NULL, 13 FK y 3 triggers, este equipo supera ampliamente el minimo de 10 restricciones para equipo de 3. Los triggers son especialmente destacables por su complejidad y relevancia al caso.

5. **VIEWS de alta calidad:** Las 5 VIEWS cubren diferentes areas del negocio y demuestran uso avanzado de CASE, COALESCE, NULLIF, LEFT JOIN, SUM condicional y COUNT. Falta uso de HAVING en las VIEWS.

6. **Inconsistencia menor:** Hay una contradiccion entre la justificacion de DETALLE_ENTRADA (pagina 15 dice que no agregaron precio_compra) y el CREATE TABLE real (pagina 14 que si incluye precio_compra_historico). Esto sugiere que el documento fue escrito en multiples iteraciones y no se revisaron todas las secciones para consistencia.

7. **Identificacion de integrantes:** El equipo esta formado por Espinoza Mendoza Hector Isaac (243602), Moreno Zuniga Jesel (243692) y Arturo Yion Jaime (243751). Las tres carpetas (243602, 243692, 243751) contienen el mismo contenido.
