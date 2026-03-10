
# EVALUACION DE EXAMEN PARCIAL - BASE DE DATOS AVANZADA

```
===============================================================
EVALUACION: EXAMEN1_SYSDES_5B_243706 / 243706, 243723, 243737
Caso: 3-A - Logistica de Distribucion Regional
Integrantes: 3 (Equipo de 3)
  - 243723 Calderon Trejo Maria Regina
  - 243737 Morales Montejo Ian Mauricio
  - 243706 Selvas Alvarez Omar Kalid
===============================================================
```

> **NOTA:** Esta entrega es identica a la encontrada en la carpeta EXAMEN1_SYSDES_5B_243723. Se trata del mismo equipo de 3 integrantes que entrego en multiples carpetas. La evaluacion aplica por igual a los tres integrantes.

---

## PUNTUACION POR SECCION

```
--------------------------------------------------------------
Modelo ER + Esquema Relacional:    23/30
Restricciones:                     16/20
Queries SQL:                       17/25
VIEWS:                             12/15
Justificacion de Diseno:            8/10
--------------------------------------------------------------
TOTAL:                             76/100
CALIFICACION:                      8.0/10
PORCENTAJE FINAL:                  11.4% de 15%
===============================================================
```

---

## RETROALIMENTACION DETALLADA

### [Modelo ER + Esquema Relacional] 23/30

**Fortalezas:**
- Se identifican 13 tablas (Products, Suppliers, Businnes, Categories, Vehicles, Zones, Drivers, orders, order_details, routes, route_assignments, inventory_movement, orders_incidents), lo que supera el minimo de 9-12 tablas para equipo de 3.
- Se incluyen dos tablas puente claras: `order_details` (relacion N-N entre orders y Products) y `route_assignments` (relacion N-N entre routes y orders). Esto cumple con el requisito de 2 relaciones N-N.
- `orders_incidents` funciona correctamente como entidad debil dependiente de `orders`.
- Los tipos de datos estan razonablemente definidos (bigint para IDs, varchar con longitudes, decimal(10,2) para precios, timestamp para fechas).
- Se incluye `price_at_purchase` en `order_details`, lo que demuestra comprension de la preservacion del precio historico.
- La separacion de Categories, Suppliers, Zones, Drivers y Vehicles como entidades independientes refleja buena normalizacion.

**Debilidades:**
- **Errores tipograficos en tipos de datos:** `biginit` en lugar de `bigint` en las tablas `routes` y `route_assignments`; `timespamp` en lugar de `timestamp` en `inventory_movement`. (-1)
- **Nombre de tabla incorrecto:** `Businnes` deberia ser `Businesses` o `Business`. El campo `ibunnises_id` en `orders` tambien tiene el error tipografico propagado. (-1)
- **La tabla `Zones` esta desconectada del diagrama:** Tiene solo `id` y `name` pero no se referencia desde ninguna otra tabla mediante FK. El campo `zone` en `Businnes` es un varchar, no un FK a `Zones.id`. Esto representa redundancia: la tabla Zones existe pero no se usa con integridad referencial. (-2)
- **El campo `driver` en `Vehicles` se marca como `fk` pero no especifica claramente a que tabla referencia** ni usa el mismo nombre que la PK de Drivers (`license`). La relacion en el diagrama entre Vehicles y Drivers es confusa. (-1)
- **Falta la relacion explicita entre `order_details` y `orders`:** La tabla `order_details` no tiene un campo `orders_id` como FK. No se puede saber a que pedido pertenece cada detalle. Esto es un error critico en el esquema relacional. (-2)
- **Cardinalidades parcialmente documentadas:** El diagrama muestra "uno a muchos" y "xto" (posiblemente N-a-M) pero la notacion es informal y algunas relaciones no tienen cardinalidad visible.

**Puntuacion desglosada:**
- Identificacion de entidades principales: 7/8 (buena cobertura, pero Zones desconectada)
- Cardinalidades correctas: 4/6 (notacion informal, algunas confusas)
- Claves primarias definidas: 4/5 (definidas pero con typos en tipos)
- Claves foraneas correctas: 3/5 (falta orders_id en order_details, Zones no conectada, driver FK ambigua)
- Normalizacion: 2/3 (zone como varchar en Businnes en vez de FK)
- Tablas puente para N-N: 3/3 (order_details y route_assignments presentes)

---

### [Restricciones] 16/20

**Fortalezas:**
- Se identifican mas de 10 restricciones, superando el minimo de 10 para equipo de 3.
- Buena variedad de tipos de restricciones: NOT NULL, UNIQUE, CHECK, FK con ON DELETE RESTRICT, DEFAULT.
- Los CHECK constraints son pertinentes al dominio: `stock >= 0`, `status IN (...)`, `type IN ('Entrada', 'Salida')`, `capacity > 0`, `price > 0`, `quantity > 0`.
- Mencion de `ON DELETE RESTRICT` en productos con movimientos registrados demuestra comprension de integridad referencial.
- `DEFAULT CURRENT_TIMESTAMP` en pedidos e incidencias es una buena practica.
- Las restricciones UNIQUE en placas y licencia son correctas y relevantes.

**Debilidades:**
- Las restricciones se presentan como lista narrativa, no como sentencias SQL formales (ALTER TABLE ... ADD CONSTRAINT ...). Aunque se acepta pseudocodigo, la falta de sintaxis SQL formal reduce la puntuacion de precision.
- No se implementa una restriccion para que un vehiculo en estado 'Mantenimiento' no pueda asignarse a una ruta (solo se menciona narrativamente en la justificacion, no como CHECK o TRIGGER).
- Falta una restriccion para validar que `zone` en Businnes sea un valor valido de las 3 zonas esperadas (Chiapas, Oaxaca, Tabasco).
- No se menciona restriccion para evitar pedidos con fecha futura o movimientos de inventario con cantidad negativa de forma explicita.

**Puntuacion desglosada:**
- NOT NULL apropiados: 4/4 (mencionados para IDs, nombres, descriptions)
- UNIQUE constraints: 4/4 (RFC, placas, licencia)
- CHECK constraints: 4/4 (stock >= 0, status, type, capacity > 0, price > 0)
- Integridad referencial (FK): 3/4 (ON DELETE RESTRICT mencionado, pero falta FK de order_details a orders)
- Restricciones de negocio: 1/4 (la regla de vehiculo en mantenimiento no se formaliza como restriccion)

---

### [Queries SQL] 17/25

**Fortalezas:**
- Se presentan 5 queries con buena cobertura funcional: productos con proveedores, peso por ruta vs capacidad, clientes top por gasto, historial de inventario, y deteccion de incidencias.
- Se usan JOINs de forma apropiada: multiples JOINs en una sola query (hasta 4 JOINs en query 2 y 3), incluyendo LEFT JOIN en query 5.
- La query 3 usa GROUP BY + HAVING correctamente para filtrar empresas con gasto > $10,000.
- Las funciones de agregacion SUM() y COUNT() se usan correctamente.
- La query 5 combina COALESCE y CASE de forma inteligente para clasificar pedidos segun incidencias.

**Debilidades:**
- **Query 2 usa `SUM(p.stock)` como "peso_estimado_carga"**, lo cual es semanticamente incorrecto: el stock no es peso. No existe un campo de peso en Products. Esto es un error logico importante. (-2)
- **Query 3 tiene errores de nomenclatura:** `Businnes` y `o.ibunnises_id` perpetuan el error tipografico, y `o.id = od.id` en la linea `JOIN order_details od ON o.id = od.id` es incorrecto porque deberia ser `od.orders_id = o.id`, pero ese campo no existe en el esquema. (-2)
- **Solo 5 queries para equipo de 3.** Se esperarian al menos 6-8 queries dada la complejidad del caso. La cobertura es limitada: no hay queries de entregas por conductor, rutas por estado, o analisis temporal. (-2)
- **La query 4 es relativamente simple:** solo un JOIN sin agregaciones ni filtros complejos. (-1)
- Las queries contienen marcas "[cite: ...]" que sugieren uso de IA sin limpiar las referencias. Esto no se penaliza (IA permitida) pero denota falta de revision.
- Falta una query que filtre vehiculos disponibles o analice incidencias por zona.

**Puntuacion desglosada:**
- Sintaxis correcta: 3/5 (errores en JOINs y nombres de campo)
- JOINs apropiados: 6/8 (buena variedad pero con errores en condiciones)
- Agregaciones: 4/5 (SUM, COUNT bien usados, pero SUM(stock) como peso es error)
- GROUP BY / HAVING: 3/4 (usado correctamente en query 3, falta en otras)
- Cobertura de queries requeridas: 1/3 (solo 5 queries, falta profundidad)

---

### [VIEWS] 12/15

**Fortalezas:**
- Se presentan 5 VIEWS, cumpliendo con el requisito de 5 para equipo de 3.
- Todas usan la sintaxis `CREATE VIEW ... AS SELECT` correctamente.
- La Vista 2 (productividad de conductores) usa CASE con BETWEEN de forma efectiva para clasificar rendimiento.
- La Vista 3 (inventario critico) usa CASE para categorizar stock en tres niveles (AGOTADO, REABASTECER URGENTE, Suficiente).
- La Vista 4 (rentabilidad por proveedor) calcula margenes con expresiones aritmeticas dentro de SUM(), demostrando conocimiento de agregaciones complejas.
- Las Vistas cubren diferentes aspectos del negocio: zona geografica, conductores, inventario, proveedores, flota.
- La Vista 5 usa LEFT JOIN correctamente para incluir vehiculos sin rutas.

**Debilidades:**
- **La Vista 1 le falta `CREATE VIEW` en el codigo visible;** solo se ve el cuerpo SELECT. Aunque el texto dice "CREATE VIEW vista_cobertura_zona AS", la sintaxis esta presente. Sin embargo, no incluye HAVING ni filtra por cantidad minima.
- **Ninguna vista usa HAVING.** Para equipo de 3, se esperaria al menos una vista con HAVING para filtrar grupos. (-2)
- **No se usa COALESCE en ninguna VIEW.** Aunque se usa en la query 5, las vistas no aprovechan esta funcion. (-1)
- La Vista 3 mencionaba "calcula si el stock dura menos de 15 dias" en la descripcion pero la implementacion solo compara stock contra umbrales fijos (0 y 20), sin calcular dias reales de duracion.
- La Vista 2 tiene un error menor: falta un espacio antes de `ELSE` en la linea `'EstandardELSE 'Baja Actividad'` (dice `'EstandardELSE` en vez de `'Estandar' ELSE`).

**Puntuacion desglosada:**
- Sintaxis CREATE VIEW: 3/3 (todas correctas)
- Agregaciones correctas: 4/4 (COUNT, SUM bien usados en multiples vistas)
- Uso de HAVING: 1/3 (no se usa HAVING en ninguna vista)
- Uso de CASE/COALESCE: 2/3 (CASE bien usado, falta COALESCE en vistas)
- Coherencia con esquema: 2/2 (las vistas referencian tablas del esquema)

---

### [Justificacion de Diseno] 8/10

**Fortalezas:**
- La respuesta a "Por que lo disenaron asi?" es detallada y demuestra comprension profunda de las decisiones de diseno.
- Se mencionan trade-offs especificos: por que separar entidades, por que usar tablas puente, por que guardar precio historico.
- La justificacion de `inventory_movement` como alternativa a solo un campo de stock demuestra pensamiento avanzado.
- Se usa un ejemplo concreto (Don Pepe, Carlos Hernandez en Juchitan) para ilustrar escenarios reales, lo que muestra contextualizacion del caso.
- La mencion de `ON DELETE RESTRICT` y restricciones CHECK como "blindaje del negocio" es pertinente.

**Debilidades:**
- La respuesta a "Por que escogieron ese caso?" es generica: "estamos mas familiarizados con e-commerce." Logistica de distribucion no es exactamente e-commerce; la conexion es debil. (-1)
- Falta una reflexion sobre las limitaciones del diseno actual o posibles mejoras futuras. (-1)

**Puntuacion desglosada:**
- Por que escogieron ese caso: 3/4 (razon valida pero superficial)
- Por que lo disenaron asi: 5/6 (excelente detalle, falta mencion de limitaciones)

---

## PREGUNTAS DE SEGUIMIENTO PARA DEFENSA

```
--------------------------------------------------------------
```

### 1. [COMPRENSION]

**Pregunta:** En su diagrama, la tabla `order_details` no tiene un campo `orders_id` que la vincule a la tabla `orders`. Si un pedido tiene 5 productos diferentes, como sabe el sistema a que pedido pertenece cada linea de detalle? Expliquen como resolverian esto.

**Respuesta esperada:** El estudiante deberia reconocer que falta el campo `orders_id` como FK en `order_details` y explicar que es necesario agregarlo para establecer la relacion 1-N entre `orders` y `order_details`. Sin este campo, la tabla puente no puede funcionar como tal. Deberian mencionar que seria `orders_id BIGINT NOT NULL REFERENCES orders(id)`.

---

### 2. [FALENCIAS]

**Pregunta:** La tabla `Zones` tiene solo `id` y `name`, pero en la tabla `Businnes` el campo `zone` es de tipo `varchar`, no una FK a `Zones.id`. Esto significa que se puede escribir cualquier texto en el campo zone de un negocio (por ejemplo "Marte" o "CDMX"). Que problema de integridad genera esto y como lo arreglarian?

**Respuesta esperada:** El estudiante deberia identificar que esto genera redundancia y posible inconsistencia: la tabla Zones existe pero no se utiliza con integridad referencial. La solucion seria cambiar el campo `zone` en Businnes por `zone_id BIGINT REFERENCES Zones(id)`, eliminando el varchar libre y forzando que solo se usen zonas validas del catalogo.

---

### 3. [MEJORA]

**Pregunta:** Su diseno no tiene una tabla para registrar el estado de las entregas (entregado, en transito, devuelto). Actualmente `load_status` en `route_assignments` maneja un unico status. Como extenderian el diseno para soportar un historial completo de cambios de estado de cada entrega, incluyendo quien hizo el cambio y cuando?

**Respuesta esperada:** El estudiante deberia proponer una tabla tipo `delivery_status_log` o `shipment_tracking` con campos como: id, route_assignment_id (FK), previous_status, new_status, changed_by, changed_at (timestamp), y observaciones. Esto permitiria un historial completo de cambios similar a una bitacora, en lugar de solo el estado actual.

---

### 4. [DECISION]

**Pregunta:** Decidieron que la PK de `Vehicles` fuera `plates` (las placas) en vez de un ID numerico autogenerado, y la PK de `Drivers` fuera `license` (la licencia). Que pasaria si un vehiculo cambia de placas o un conductor renueva su licencia? Que implicaciones tiene esto en todas las tablas que referencian estas PKs?

**Respuesta esperada:** El estudiante deberia reconocer que usar llaves naturales (placas, licencia) como PK genera problemas de actualizacion en cascada: si una placa cambia, habria que actualizar `routes.vehicles_plates` y `Vehicles.plates` simultaneamente. Con un ID surrogate (autogenerado), el cambio de placa solo afectaria un campo en Vehicles. Deberian mencionar UPDATE CASCADE como posible mitigacion o proponer migrar a IDs surrogados.

---

### 5. [APLICACION]

**Pregunta:** Supongamos que el almacen recibe un cargamento de 500 kg de queso del proveedor "Lacteos Chiapas" y se necesita registrar la entrada en inventario, y luego un comercio en Juchitan hace un pedido de 50 kg de ese queso. Describan paso a paso que registros se crearian o modificarian en sus tablas, mencionando cada tabla involucrada.

**Respuesta esperada:** El estudiante deberia describir: (1) Se crea un registro en `inventory_movement` con type='Entrada', products_id del queso, quantity=500, description del recibo. (2) Se actualiza `Products.stock` sumando 500. (3) Se crea un registro en `orders` con ibunnises_id del comercio de Juchitan. (4) Se crea un registro en `order_details` con products_id del queso, quantity=50, price_at_purchase con el precio actual. (5) Se crea otro registro en `inventory_movement` con type='Salida', quantity=50. (6) Se actualiza Products.stock restando 50. (7) Se crea una ruta en `routes`, se asigna en `route_assignments` vinculando la ruta con el pedido.

---

## OBSERVACIONES ADICIONALES

1. **Entrega duplicada:** Esta entrega aparece identica en las carpetas `EXAMEN1_SYSDES_5B_243706` y `EXAMEN1_SYSDES_5B_243723`. Los archivos son identicos en contenido y tamano (875,000 bytes para Analisis.pdf y 46,275 bytes para Diagrama ER.pdf).

2. **Marcas de citacion de IA:** Las queries contienen marcadores `[cite: XXX]` que son tipicos de respuestas generadas por IA (probablemente Perplexity o similar). Aunque el uso de IA esta permitido, la presencia de estos artefactos sin limpiar sugiere que no se reviso el documento final cuidadosamente.

3. **Errores tipograficos recurrentes:** `Businnes` (deberia ser Business/Businesses), `ibunnises_id`, `biginit` (bigint), `timespamp` (timestamp), `purcharse_price` (purchase_price). Estos errores se propagan por todo el documento y el diagrama, sugiriendo que se copiaron sin verificar.

4. **Caso elegido vs justificacion:** El equipo dice que eligio el caso por familiaridad con e-commerce, pero el Caso 3-A es de logistica de distribucion. Aunque hay similitudes, la justificacion no aborda directamente los retos logisticos (rutas, vehiculos, inventario en transito).

5. **Calidad del diagrama ER:** El diagrama es visualmente claro y usa una notacion tabular con colores diferenciados. Sin embargo, la notacion de cardinalidades ("uno a muchos", "xto") es informal y algunas relaciones no estan claramente representadas con lineas de conexion.

6. **Para equipo de 3, el trabajo es solido pero con deficiencias notables** en la precision del esquema relacional (campo faltante en order_details, Zones desconectada) y en la falta de HAVING en las VIEWS.
