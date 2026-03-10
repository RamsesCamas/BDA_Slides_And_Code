
# EVALUACION DE EXAMEN PARCIAL - BASE DE DATOS AVANZADA

```
===============================================================
EVALUACION: EXAMEN1_SYSDES_5B_243737
Caso: 3-A - Logistica de Distribucion Regional
Integrantes: 3
  - 243723 Calderon Trejo Maria Regina
  - 243737 Morales Montejo Ian Mauricio
  - 243706 Selvas Alvarez Omar Kalid
===============================================================
```

> **NOTA IMPORTANTE - DUPLICADO DETECTADO:** Esta carpeta (243737) contiene exactamente el mismo contenido que la carpeta 1 (243706). Ambas carpetas corresponden al mismo equipo de 3 integrantes (243723, 243737, 243706). Se evalua de forma independiente basandose en el contenido entregado, pero se deja constancia de la duplicidad. El trabajo es identico en ambas entregas.

---

## PUNTUACION POR SECCION

```
--------------------------------------------------------------
Modelo ER + Esquema:    24/30
Restricciones:          16/20
Queries SQL:            19/25
VIEWS:                  13/15
Justificacion:           8/10
--------------------------------------------------------------
TOTAL:                  80/100
CALIFICACION:           9.0/10
PORCENTAJE FINAL:       12.0% de 15%
===============================================================
```

---

## RETROALIMENTACION DETALLADA

### [Modelo ER + Esquema Relacional] - 24/30

**Fortalezas:**
- Se identifican 12 entidades bien diferenciadas: Products, Suppliers, Businnes, Categories, Vehicles, Zones, orders, order_details, routes, Drivers, inventory_movement, orders_incidents, route_assignments. Esto cumple holgadamente con el minimo de 9-12 tablas para equipo de 3.
- Se implementan correctamente 2 tablas puente para relaciones N:N: order_details (pedidos-productos) y route_assignments (rutas-pedidos). Ambas son fundamentales para el dominio del negocio.
- Las claves primarias estan definidas en todas las tablas (id bigint en la mayoria, plates varchar en Vehicles, license varchar en Drivers).
- Las claves foraneas estan declaradas (categories_id, suppliers_id en Products; ibunnises_id en orders; products_id en order_details; vehicles_plates y drivers_license en routes; routes_id y order_id en route_assignments; orders_id en orders_incidents; products_id en inventory_movement).
- La tabla inventory_movement para movimientos de inventario (entrada/salida) es una decision de diseno acertada que permite trazabilidad.
- orders_incidents como entidad dependiente del pedido es correcta para el manejo de incidencias.

**Debilidades:**
- El nombre de la tabla "Businnes" tiene un error ortografico (deberia ser "Businesses" o "Comercios"). (-1)
- Hay inconsistencia de nomenclatura: algunas tablas usan ingles con PascalCase (Products, Suppliers, Vehicles, Drivers) y otras usan snake_case (order_details, route_assignments, inventory_movement). Se recomienda uniformidad. (-1)
- La tabla Zones solo tiene id y name, pero no se usa como FK en ninguna otra tabla del diagrama. En la tabla Businnes se usa un campo "zone" de tipo varchar en lugar de una FK a Zones. Esto genera redundancia y la tabla Zones queda desconectada. (-2)
- No se observa una entidad explicita para "Almacen" o "Bodega", que es parte central del caso 3-A. (-1)
- El campo "driver" en Vehicles es FK, pero la relacion conductor-vehiculo podria ser mas flexible (un conductor puede usar diferentes vehiculos en distintos momentos). En routes ya se asocia drivers_license, por lo que el FK en Vehicles parece redundante. (-1)
- El campo "route_assignments_id" en Drivers parece incorrecto; un conductor puede tener multiples asignaciones de ruta, no una sola FK.

### [Restricciones] - 16/20

**Fortalezas:**
- Se identifican mas de 10 restricciones, cumpliendo con el minimo esperado para equipo de 3.
- Buena variedad de tipos de restricciones:
  - NOT NULL: En campos de IDs y nombres, descriptions.
  - UNIQUE: RFC de proveedor, placas de vehiculo, licencia de conductor.
  - CHECK: stock >= 0, price > 0, quantity > 0, capacity > 0, status limitado a valores validos ('Disponible', 'Mantenimiento', 'En ruta'), type limitado a ('Entrada', 'Salida').
  - FK Integridad: ON DELETE RESTRICT en productos con movimientos registrados.
  - DEFAULT: date_creation como CURRENT_TIMESTAMP.
- Las restricciones de negocio son pertinentes al dominio logistico.

**Debilidades:**
- Las restricciones se presentan como lista descriptiva, no como sentencias SQL formales (ALTER TABLE ... ADD CONSTRAINT ...). Aunque se acepta pseudocodigo, la formalizacion seria mas rigurosa. (-2)
- Falta una restriccion para asegurar que un vehiculo en estado 'Mantenimiento' no pueda asignarse a una ruta (esto se menciona en la justificacion pero no se implementa como restriccion formal). (-1)
- No se menciona una restriccion UNIQUE para la combinacion (order_id, product_id) en order_details que evitaria duplicados. (-1)

### [Queries SQL] - 19/25

**Fortalezas:**
- Se presentan 5 queries SQL con sintaxis generalmente correcta.
- Query 1: Buen uso de JOINs multiples (Products-Suppliers-Categories). Sintaxis correcta.
- Query 2: Excelente query que compara peso total por ruta vs capacidad del vehiculo, utilizando JOINs de 4 tablas y SUM con GROUP BY. Muy relevante para el dominio de logistica.
- Query 3: Correcto uso de GROUP BY + HAVING con agregacion SUM y COUNT. Identifica clientes que superan $10,000 MXN.
- Query 4: JOIN simple pero funcional para historial de movimientos de inventario.
- Query 5: Buen uso de CASE y COALESCE combinados con LEFT JOIN. Demuestra comprension de manejo de valores nulos.

**Debilidades:**
- En Query 1, se describe como "Productos activos con artesano y comunidad" pero no hay filtro WHERE para productos activos. La descripcion no coincide completamente con la query. (-1)
- En Query 3, la tabla se nombra "Businnes" (con error ortografico) y el campo "o.ibunnises_id" tiene otro error ortografico. Estos errores impedirian la ejecucion real. (-2)
- En Query 2, se usa SUM(p.stock) como "peso_estimado_carga", lo cual es incorrecto conceptualmente. El stock es cantidad, no peso. Faltaria un campo de peso por producto. (-1)
- Solo se presentan 5 queries; para un equipo de 3 se esperarian al menos 7-8 para mayor cobertura del caso de negocio. (-1)
- No se incluye un query que filtre por los 3 estados (Chiapas, Oaxaca, Tabasco) ni uno que analice incidencias por conductor. (-1)

### [VIEWS] - 13/15

**Fortalezas:**
- Se presentan 5 VIEWS completas, cumpliendo con el minimo esperado para equipo de 3.
- Vista 1 (vista_cobertura_zona): Resumen de pedidos por zona con conteo de incidencias. Usa JOINs y GROUP BY.
- Vista 2 (vista_productividad_conductores): Excelente uso de CASE con clasificacion de rendimiento (Alto, Estandar, Baja Actividad). Usa COUNT y GROUP BY.
- Vista 3 (vista_inventario_critico): Clasificacion de stock con CASE (AGOTADO, REABASTECER URGENTE, Suficiente). Practica y util.
- Vista 4 (vista_rentabilidad_proveedores): Calcula inversion, venta potencial y margen de ganancia usando SUM y operaciones aritmeticas. Muy buena.
- Vista 5 (vista_utilizacion_flota): Muestra estado de vehiculos y rutas del mes con LEFT JOIN.
- Todas usan sintaxis CREATE VIEW correcta.
- Se demuestra uso de CASE (Vistas 2 y 3), agregaciones (todas), y coherencia con el esquema.

**Debilidades:**
- Ninguna vista usa HAVING, que era uno de los criterios evaluados. (-1)
- Vista 1 no tiene la clausula CREATE VIEW al inicio en el codigo mostrado (se ve en el bloque pero parece un detalle de formato). (-0)
- Vista 3 no utiliza la logica de "dias de duracion" que describe (solo clasifica por nivel de stock numerico, no calcula velocidad de ventas). (-1)
- No se usa COALESCE en ninguna vista (solo en queries).

### [Justificacion de Diseno] - 8/10

**Fortalezas:**
- La respuesta a "Por que escogieron ese caso" es honesta y razonable: familiaridad con modelos e-commerce por proyectos previos.
- La respuesta a "Por que lo disenaron asi" es muy completa y detallada:
  - Explica la separacion de entidades para evitar redundancia.
  - Justifica las tablas puente (order_details y route_assignments) con ejemplos concretos del caso de negocio.
  - Explica la decision de inventory_movement para trazabilidad.
  - Explica orders_incidents como entidad dependiente.
  - Menciona el uso de FK y CHECK para proteger la integridad del negocio.
  - Incluye ejemplos contextualizados (Don Pepe, Carlos Hernandez, queso en Juchitan).
- Se mencionan trade-offs (precio historico en order_details vs precio actual).

**Debilidades:**
- La respuesta al "por que escogieron ese caso" podria profundizar mas en la relevancia del caso para la region de Chiapas o en la importancia de la logistica de distribucion. (-1)
- No se menciona explicitamente por que NO eligieron las otras alternativas (e.g., Caso 3-B o 3-C). (-1)

---

## PREGUNTAS DE SEGUIMIENTO PARA DEFENSA

```
--------------------------------------------------------------
```

### 1. [COMPRENSION]
**Pregunta:** En su diseno, la tabla route_assignments conecta rutas con pedidos. Expliquen que sucede en el sistema cuando un conductor sale con una ruta que tiene 5 pedidos asignados y uno de ellos debe cancelarse en el camino. Como se actualizaria el estado en su modelo?

**Respuesta esperada:** Se deberia actualizar el campo load_status en route_assignments para ese pedido especifico (ej. 'Cancelado'), mantener los demas como 'Pendiente' o 'Entregado', y registrar una incidencia en orders_incidents con la descripcion del motivo de cancelacion. La separacion en route_assignments permite manejar cada pedido de forma independiente dentro de la misma ruta.

### 2. [FALENCIAS]
**Pregunta:** La tabla Zones tiene id y name, pero en Businnes el campo zone es un varchar, no una FK a Zones. Esto significa que la tabla Zones queda desconectada del esquema. Que problemas podria causar esto y como lo corregirian?

**Respuesta esperada:** Esto genera redundancia y posibles inconsistencias: si alguien escribe "chiapas" en un registro y "Chiapas" en otro, se tratarian como zonas diferentes. La solucion seria cambiar el campo zone en Businnes por un zones_id (bigint) como FK a la tabla Zones, garantizando integridad referencial y normalizacion.

### 3. [MEJORA]
**Pregunta:** Su modelo no tiene una tabla de Almacen o Bodega, que es un componente central del caso 3-A. Si tuvieran que agregar soporte para multiples almacenes en diferentes estados, que tablas modificarian o crearian?

**Respuesta esperada:** Se crearia una tabla Warehouses (id, name, address, zones_id, capacity) y se modificaria inventory_movement para incluir un warehouse_id como FK. Tambien podria agregarse un campo origin_warehouse en routes para saber de que almacen salen las entregas. Products podria tener una relacion N:N con Warehouses mediante una tabla warehouse_stock para manejar stock por ubicacion.

### 4. [DECISION]
**Pregunta:** En la tabla Vehicles, incluyeron un campo "driver" como FK al conductor. Sin embargo, en routes tambien asocian drivers_license. Por que decidieron poner la referencia al conductor en ambas tablas? No genera redundancia?

**Respuesta esperada:** El campo driver en Vehicles representaria el conductor "asignado por defecto" o habitual del vehiculo, mientras que drivers_license en routes permite flexibilidad para que en una ruta especifica se asigne un conductor diferente. Sin embargo, reconocerian que esto puede generar inconsistencias si el conductor asignado en la ruta no coincide con el del vehiculo. Una mejora seria eliminar el campo driver de Vehicles y manejar la asignacion solo a traves de routes.

### 5. [APLICACION]
**Pregunta:** Un comercio en Juchitan, Oaxaca pide 500 kg de maiz, pero el vehiculo disponible solo tiene capacidad para 300 kg. Usando su query 2 (peso total por ruta vs capacidad), expliquen como el sistema detectaria esta sobrecarga y que accion tomaria el coordinador logistico.

**Respuesta esperada:** La query 2 calcula SUM del peso/stock por ruta y lo compara con v.capacity. Si el resultado muestra que peso_estimado_carga > capacidad_max, el coordinador sabria que el vehiculo esta sobrecargado. La accion seria dividir el pedido en dos rutas o asignar un vehiculo con mayor capacidad. Sin embargo, deberian reconocer que su query usa SUM(p.stock) en lugar de un campo de peso real, lo cual seria una limitacion a corregir.

```
===============================================================
```

---

## OBSERVACIONES ADICIONALES

1. **Duplicidad de entrega:** Esta carpeta (243737) contiene exactamente los mismos archivos que la carpeta de la matricula 243706. Ambas corresponden al mismo equipo de 3 personas. Se recomienda verificar con los estudiantes si la entrega duplicada fue intencional o un error en la organizacion de carpetas.

2. **Calidad general:** El trabajo demuestra buena comprension del dominio de logistica de distribucion. El modelo ER es funcional y cubre los principales aspectos del caso. Las queries y views son variadas y demuestran dominio de SQL.

3. **Errores ortograficos recurrentes:** "Businnes" (deberia ser Businesses), "ibunnises_id" (deberia ser businesses_id), "purcharse_price" (deberia ser purchase_price), "biginit" (deberia ser bigint), "timespamp" (deberia ser timestamp). Estos errores impedirian la ejecucion real del SQL.

4. **Uso de IA:** Se observan marcas "[cite: XXX]" en varias queries SQL, lo que sugiere que fueron generadas o asistidas por una herramienta de IA (posiblemente Perplexity o similar). Esto no es penalizable segun las reglas del examen, pero las preguntas de defensa deben verificar comprension real.

5. **Nomenclatura mixta:** Se recomienda adoptar una convencion consistente (todo en ingles o todo en espanol, y un solo estilo de nombres de tabla).
