═══════════════════════════════════════════════════════════════
EVALUACION: EXAMEN1_SYSDES__5B_243726
Caso: 3-A - Logistica de Distribucion Regional
Integrantes: 3 (243763 Rudi Fabricio Martinez Jaimes, 243726 Gonzalez Ruiz Andres Esuardo, 243743 Mora Mercado Fernando)
═══════════════════════════════════════════════════════════════

## PUNTUACION POR SECCION

| Criterio                      | Puntos Obtenidos | Puntos Posibles |
|-------------------------------|------------------|-----------------|
| Modelo ER + Esquema Relacional | 25/30           | 30              |
| Restricciones                 | 13/20            | 20              |
| Queries SQL                   | 10/25            | 25              |
| VIEWS                         | 14/15            | 15              |
| Justificacion de Diseno       | 9/10             | 10              |

──────────────────────────────────────────────────────────────
**TOTAL (este evaluador): 71/100**

## PUNTUACION RECONCILIADA (Escala Lineal + Rangos)

> **Nota del Docente:** Este equipo fue evaluado por 2 evaluadores distintos (carpetas 243726 y 243743) con puntuaciones de 71 y 82. Se aplica promedio lineal y luego rangos.
>
> **Promedio lineal:** (71 + 82) / 2 = **77/100**
> **Rango aplicado:** 70-79 = **Calificacion: 8.0/10**

**PUNTUACION RECONCILIADA: 77/100**
**CALIFICACION RECONCILIADA: 8.0/10**
**PORCENTAJE FINAL: 11.55% de 15%**
═══════════════════════════════════════════════════════════════

---

## RETROALIMENTACION DETALLADA

### 1. Modelo ER + Esquema Relacional (25/30)

**Fortalezas:**
- Excelente identificacion de entidades para el caso 3-A. Se presentan 12 tablas interconectadas: Pedidos, Comercios, Zonas, Productos, Categorias, Vehiculos, Conductores, Proveedores, Entradas_Almacen, Incidencias, Detalle_Pedido y Ruta_Pedidos. Esto cumple ampliamente con el requisito de 9-12 tablas para equipos de 3.
- Dos tablas puente claramente identificadas: Detalle_Pedido (Productos-Pedidos, N:N) y Ruta_Pedidos (Rutas-Pedidos, N:N). Cumple con el requisito de al menos 2 relaciones N:N.
- Entidad debil correctamente implementada (Entradas_Almacen depende de Producto y Proveedor).
- Diagrama realizado en dbdiagram.io con notacion clara, PKs y FKs visibles, tipos de datos definidos.
- Buena normalizacion: separacion de catalogos maestros (Proveedores, Zonas, Categorias) de tablas transaccionales (Pedidos, Rutas, Entradas).
- El campo precio_venta_historico en Detalle_Pedido muestra comprension de la preservacion de datos historicos.

**Debilidades:**
- El diagrama no muestra explicitamente las lineas de relacion con cardinalidades (1:N, N:N) dibujadas entre las tablas. Si bien las FK son visibles en las columnas, la representacion visual de las cardinalidades es limitada. (-3 pts en cardinalidades)
- Falta una tabla dedicada de Almacen o Bodega; las entradas van directo a producto/proveedor sin registrar ubicacion fisica. (-2 pts en entidades)

### 2. Restricciones (13/20)

**Fortalezas:**
- Se mencionan correctamente en prosa las restricciones implementadas: CHECK para stocks negativos y precio_venta > precio_compra.
- UNIQUE en RFC y Licencia identificados correctamente.
- NOT NULL en claves foraneas para evitar registros huerfanos.
- Se reportan 10 restricciones clave programadas.

**Debilidades:**
- Las restricciones se describen SOLO en prosa/narrativa (Fase 2 del informe). No se presentan sentencias SQL explicitas tipo ALTER TABLE ... ADD CONSTRAINT o CREATE TABLE con CHECK/UNIQUE/NOT NULL. Esto impide verificar la correccion sintactica. (-4 pts)
- No hay una seccion dedicada de restricciones con codigo SQL. Las restricciones estan dispersas en la descripcion del desarrollo. (-2 pts)
- Falta evidencia concreta de restricciones de negocio mas alla de las mencionadas (por ejemplo, validacion de estados de vehiculo, validacion de capacidad de vehiculo vs carga). (-1 pt)

### 3. Queries SQL (10/25)

**Fortalezas:**
- El informe menciona la creacion de seeds.sql con escenarios de prueba, lo que demuestra que se insertaron datos de validacion.

**Debilidades:**
- NO se presentan queries SELECT con JOINs, agregaciones, GROUP BY, HAVING en el documento. Las unicas sentencias SQL visibles son las 5 VIEWS. (-12 pts)
- No hay seccion dedicada de "Queries SQL de ejemplo" como lo requiere el examen. Toda la logica SQL esta embebida exclusivamente en las VIEWS. (-3 pts)
- Aunque las VIEWS contienen JOINs y agregaciones, el examen pide queries separadas de las VIEWS. No se pueden evaluar queries independientes porque no existen en el entregable.
- Se otorgan 10 puntos parciales porque las VIEWS demuestran dominio de JOINs, GROUP BY, HAVING, agregaciones y subqueries, pero formalmente no cumplen como "Queries SQL de ejemplo" separadas.

### 4. VIEWS (14/15)

**Fortalezas:**
- 5 VIEWS completas presentadas con sintaxis CREATE VIEW correcta:
  1. vista_resumen_zonas: JOIN de Zonas-Comercios-Pedidos, COUNT, SUM con CASE, HAVING, ROUND, NULLIF para division segura.
  2. vista_inventario_critico: LEFT JOIN con Detalle_Pedido, COALESCE, CASE con multiples condiciones, logica de alerta de stock.
  3. vista_productividad_conductores: LEFT JOINs multiples, subquery para calcular peso por ruta, COUNT DISTINCT, COALESCE, AVG, CASE para clasificacion de rendimiento.
  4. vista_rentabilidad_proveedor: JOINs de 3 tablas, SUM, NULLIF para division segura, concatenacion de porcentaje, calculo de margen bruto.
  5. vista_utilizacion_flota: LEFT JOIN, COUNT, CASE con rangos, GROUP BY.
- Uso correcto y variado de CASE en 4 de 5 vistas con rangos bien definidos.
- Uso de COALESCE en 3 vistas y NULLIF en 2 vistas para manejo robusto de nulos.
- HAVING utilizado correctamente en vista_resumen_zonas.
- Las vistas son coherentes con el esquema relacional presentado.

**Debilidades:**
- Algunos caracteres de encoding aparecen mal (Ã³n en lugar de "on") en los comentarios SQL, aunque no afecta funcionalidad. (-1 pt)

### 5. Justificacion de Diseno (9/10)

**Fortalezas:**
- Justificacion del caso excelente: explican que eligieron el Caso 3-A por su "alta demanda de logica relacional" y la necesidad de coordinar tres dimensiones (Inventario, Comercial, Operativa).
- La justificacion del diseno es muy solida con tres argumentos concretos:
  1. Desacoplamiento Operativo mediante tabla puente Ruta-Pedido.
  2. Preservacion de Historicos con precio al momento de la venta.
  3. Gestion Atomica de Incidencias vinculada al detalle del producto.
- Mencion explicita de trade-offs y decisiones no obvias (ej. dividir pedido en multiples rutas).
- Lenguaje tecnico apropiado y argumentos bien fundamentados.

**Debilidades:**
- La justificacion podria haber mencionado por que se eligio 3FN especificamente y no otra forma normal. (-1 pt)

---

## OBSERVACIONES ADICIONALES

1. **Caso real vs archivo**: El nombre de archivo dice "CasoA" en "Reporte_Solucion-CasoA.pdf", pero el contenido claramente corresponde al Caso 3-A (Logistica de Distribucion Regional), no al Caso 2-A (Marketplace de Productos Artesanales). Se evalua por el contenido real.

2. **Brecha importante en Queries SQL**: El trabajo es muy solido en VIEWS y modelado, pero la ausencia total de queries SELECT independientes (fuera de las VIEWS) es una carencia significativa. Las VIEWS compensan parcialmente porque contienen logica SQL avanzada, pero no sustituyen la necesidad de queries de consulta autonomas.

3. **Presentacion profesional**: El trabajo esta bien organizado en fases (Analisis, Arquitectura, Pruebas, Inteligencia de Negocio), lo que demuestra un proceso de desarrollo estructurado. El uso de dbdiagram.io para el esquema es apropiado.

4. **Equipo de 3**: Cumple con los requisitos de equipo de 3 (12 tablas, 2 N:N, 5 VIEWS, restricciones mencionadas aunque no codificadas explicitamente).

---

## PREGUNTAS DE SEGUIMIENTO PARA DEFENSA

──────────────────────────────────────────────────────────────

### 1. [COMPRENSION]
**Pregunta:** En su tabla Ruta_Pedidos, tienen un campo "orden_entrega". Expliquen como funciona esta relacion N:N y por que un simple campo en la tabla Pedidos no seria suficiente para gestionar el orden de entrega.

**Respuesta esperada:** La tabla Ruta_Pedidos es una tabla puente entre Rutas y Pedidos. Un pedido puede estar en multiples rutas (si se divide) y una ruta lleva multiples pedidos. El campo orden_entrega pertenece a la relacion, no al pedido ni a la ruta, porque el mismo pedido podria tener diferente orden en diferentes rutas. Si pusieramos el orden en la tabla Pedidos, solo podriamos tener un unico orden fijo, sin flexibilidad para reorganizar segun la ruta asignada.

### 2. [FALENCIAS]
**Pregunta:** Su modelo no incluye queries SQL independientes fuera de las VIEWS. Si necesitaran hacer una consulta ad hoc para encontrar todos los pedidos de un comercio especifico con su detalle de productos y estado de entrega, como la escribirian? Detectan alguna limitacion en su esquema para este tipo de consultas?

**Respuesta esperada:** Deberian poder escribir un SELECT con JOIN entre Pedidos, Comercios, Detalle_Pedido y Productos, filtrando por id_comercio. La limitacion es que no tienen una tabla de "Entregas" separada; el estado_entrega esta en Detalle_Pedido como un varchar, lo que podria dificultar consultas complejas sobre estados de entrega. Tambien deberian reconocer que la falta de queries independientes en su entregable fue una omision.

### 3. [MEJORA]
**Pregunta:** Su tabla Entradas_Almacen registra el flujo de entrada de stock. Sin embargo, no tienen un mecanismo explicito para registrar salidas de almacen (cuando los productos se cargan en un vehiculo). Como mejorarian su modelo para tener un control completo de inventario con entradas y salidas?

**Respuesta esperada:** Podrian crear una tabla Movimientos_Inventario con un campo tipo_movimiento (ENTRADA/SALIDA) que unifique las entradas y salidas, vinculada tanto a proveedores (entradas) como a rutas/pedidos (salidas). Otra opcion seria agregar una tabla Salidas_Almacen vinculada a Ruta_Pedidos. Tambien podrian agregar triggers para actualizar automaticamente el stock_actual en Productos cuando se registra un movimiento.

### 4. [DECISION]
**Pregunta:** En su tabla Incidencias, vincularon la incidencia al id_detalle_pedido en lugar de vincularla directamente al id_pedido. Por que tomaron esta decision? Que ventajas y desventajas tiene?

**Respuesta esperada:** Vincularon al detalle porque las incidencias ocurren a nivel de producto especifico, no del pedido completo. Si un pedido tiene queso y leche pero solo el queso se dano, la incidencia se registra solo para esa linea. La ventaja es granularidad: se puede saber exactamente que producto tuvo problemas y en que cantidad. La desventaja es que si la incidencia afecta a todo el pedido (ej. accidente vehicular), habria que registrar multiples incidencias, una por cada linea de detalle.

### 5. [APLICACION]
**Pregunta:** Si la distribuidora necesita agregar un nuevo estado para los vehiculos, por ejemplo "En revision mecanica de emergencia", que cambios tendrian que hacer en su base de datos? Su diseno actual lo facilita o lo dificulta?

**Respuesta esperada:** En su diseno actual, el campo "estado" en Vehiculos es un VARCHAR, por lo que agregar un nuevo estado es tan simple como insertar un registro con ese nuevo valor. Sin embargo, esto tambien es una debilidad: cualquier texto podria ser ingresado como estado. Una mejora seria tener una tabla catalogo de Estados_Vehiculo con un CHECK constraint o FK, lo que controlaria los valores validos pero requeriria un INSERT en el catalogo para agregar un nuevo estado. El diseno actual facilita la adicion pero sacrifica control de integridad.

═══════════════════════════════════════════════════════════════
