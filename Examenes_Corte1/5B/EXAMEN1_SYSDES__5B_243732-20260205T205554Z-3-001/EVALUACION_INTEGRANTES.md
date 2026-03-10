═══════════════════════════════════════════════════════════════
EVALUACION: EXAMEN1_SYSDES__5B_243732-20260205T205554Z-3-001
Caso: 3-A - Logistica de Distribucion Regional
Integrantes: 3 (243732 Hidalgo Garcia Luvia Magali, 243777 Montesinos Grajales Alix Anahi, 243716 Velazquez Tovilla Mario Alberto)
═══════════════════════════════════════════════════════════════

> **NOTA IMPORTANTE - ENTREGA DUPLICADA:** Esta carpeta (243732) tiene la misma
> subcarpeta "EXAMEN1_SYSDES__5B_243732" que aparece dentro de la carpeta
> EXAMEN1_SYSDES__5B_243716 (Folder 8). Esto significa que el equipo conformado
> por 243732, 243777 y 243716 subio la misma entrega en multiples carpetas.
> Se evalua el contenido una sola vez. La calificacion aplica para los tres integrantes:
> 243732, 243777 y 243716.

---

## PUNTUACION POR SECCION

| Criterio                      | Puntos Obtenidos | Puntos Posibles |
|-------------------------------|------------------|-----------------|
| Modelo ER + Esquema Relacional | 28/30           | 30              |
| Restricciones                 | 17/20            | 20              |
| Queries SQL                   | 22/25            | 25              |
| VIEWS                         | 15/15            | 15              |
| Justificacion de Diseno       | 7/10             | 10              |

──────────────────────────────────────────────────────────────
**TOTAL: 89/100**
**CALIFICACION: 9.0/10**
**PORCENTAJE FINAL: 13.35% de 15%**
═══════════════════════════════════════════════════════════════

---

## RETROALIMENTACION DETALLADA

### 1. Modelo ER + Esquema Relacional (28/30)

**Fortalezas:**
- Modelo excepcionalmente completo con 14 tablas bien definidas: categorias, comercios, conductores, detalle_entrega, detalle_pedido, inventario, movimientos_inventario, pedidos, productos, proveedor_producto, proveedores, ruta_pedido, rutas, vehiculos.
- Supera ampliamente el requisito de 9-12 tablas para equipos de 3.
- Dos tablas puente claramente implementadas:
  - proveedor_producto (N:N entre Proveedores y Productos) con atributos propios (Precio_Proveedor, Tiempo_Entrega_Dias, Es_Proveedor_Principal).
  - ruta_pedido (N:N entre Rutas y Pedidos) con Orden_Entrega y horas estimadas/reales.
- Tabla de inventario separada de productos, permitiendo gestion independiente de stock con Stock_Minimo, Stock_Maximo, Cantidad_Reservada.
- Tabla movimientos_inventario para registro completo de entradas/salidas (tipo_movimiento), resolviendo la trazabilidad de inventario.
- Tabla detalle_entrega con campos granulares: Cantidad_Solicitada, Cantidad_Entregada, Cantidad_Danada, Cantidad_Faltante, Firma_Digital, Nombre_Receptor. Esto demuestra un nivel de detalle excepcional para el manejo de incidencias.
- Diagrama ER generado con herramienta profesional (MySQL Workbench o similar), con relaciones visibles entre tablas.
- Tipos de datos precisos y apropiados: DECIMAL(12,3) para cantidades, DECIMAL(10,2) para precios, VARCHAR con longitudes adecuadas.
- Claves primarias y foraneas correctamente definidas y visibles en el diagrama.
- Uso de claves naturales donde es apropiado: Placas como PK de vehiculos, Numero_Licencia como PK de conductores.

**Debilidades:**
- Las cardinalidades en el diagrama ER no se muestran con notacion explicita (no se ven simbolos 1, N, M en las lineas de relacion). Las relaciones se infieren por las FK pero no estan etiquetadas visualmente. (-2 pts)
- Podria haberse incluido una tabla de "Estados" como catalogo en lugar de usar VARCHAR directamente para los campos de estado en vehiculos, conductores y pedidos, aunque esto se compensa con las restricciones CHECK mencionadas.

### 2. Restricciones (17/20)

**Fortalezas:**
- Seccion de restricciones muy completa y bien organizada en 4 categorias:
  1. **UNIQUE**: Nombres de categorias, RFC de proveedores y comercios, ficha de inventario por producto, producto unico por pedido, orden unico por ruta. (5 restricciones UNIQUE concretas)
  2. **CHECK**: Valores positivos, fechas coherentes (fecha_requerida >= fecha_pedido), limites financieros (saldo <= credito), requisitos de personal (edad >= 21, licencia vigente), consistencia de entregas (entregada + danada <= solicitada), formato RFC, estados validos con valores predefinidos. (7+ restricciones CHECK)
  3. **NOT NULL**: Identidad obligatoria, fechas obligatorias, cantidades obligatorias, estado obligatorio.
  4. **FOREIGN KEY**: ON DELETE RESTRICT para proteger historial, existencia previa obligatoria, ON DELETE CASCADE para limpieza automatica de detalles.
- Las restricciones de negocio son sofisticadas y especificas al caso: validacion de edad de conductores, credito autorizado vs saldo, consistencia de entregas, formato RFC.
- Mencion explicita de ON DELETE RESTRICT y ON DELETE CASCADE con justificacion de cuando usar cada uno.

**Debilidades:**
- Las restricciones se presentan en formato descriptivo/prosa, no como sentencias SQL (ALTER TABLE, CREATE TABLE con CONSTRAINT). Esto impide verificar la implementacion exacta. (-3 pts)
- Aunque las restricciones son numerosas y bien pensadas, la falta de codigo SQL concreto reduce la confianza en que fueron implementadas correctamente en la base de datos.

### 3. Queries SQL (22/25)

**Fortalezas:**
- 5 queries SQL de ejemplo bien presentadas, cada una con Objetivo y Explicacion:
  1. **Pedidos confirmados sin ruta** (LEFT JOIN): SELECT con JOIN Comercios + LEFT JOIN Ruta_Pedido, WHERE con filtro IS NULL. Demuestra dominio de LEFT JOIN para encontrar registros sin correspondencia.
  2. **Alerta de Sobrecarga** (Agregacion + CASE): Query compleja con 5 JOINs (Rutas-Vehiculos, Ruta_Pedido, Pedidos, Detalle_Pedido, Productos), SUM de peso con CASE para clasificacion. Muy buena complejidad.
  3. **Rutas con Incidencias** (GROUP BY + HAVING): JOIN de Rutas-Conductores-Ruta_Pedido-Pedidos, SUM con CASE condicional, HAVING para filtrar solo rutas con incidencias > 0. Uso correcto de HAVING.
  4. **Gasto por Proveedor** (COALESCE): LEFT JOIN de Proveedores-Movimientos_Inventario, COALESCE para manejar nulos, filtro en JOIN con condicion AND, ORDER BY. Bien implementada.
  5. **Valor del Inventario** (Agregacion Simple): JOIN de Inventario-Productos-Categorias, SUM de cantidad * precio, GROUP BY por categoria.
- Excelente variedad de tecnicas SQL demostradas: LEFT JOIN, INNER JOIN, multiple JOINs, CASE, COALESCE, SUM, COUNT, GROUP BY, HAVING, ORDER BY, WHERE con multiples condiciones, IS NULL.
- Cada query viene acompanada de explicacion del objetivo y del razonamiento tecnico.
- Las queries son coherentes con el esquema relacional presentado.

**Debilidades:**
- Falta uso de subqueries (SELECT anidados) en las queries de ejemplo, aunque si aparecen en las VIEWS. (-1 pt)
- No se incluyen queries de INSERT, UPDATE o DELETE para demostrar operaciones DML completas. (-1 pt)
- La query 2 (Sobrecarga) es densa y podria beneficiarse de alias mas descriptivos. (-1 pt)

### 4. VIEWS (15/15)

**Fortalezas:**
- 5 VIEWS completas, sofisticadas y con justificacion individual. Cada vista viene con su requerimiento original y la justificacion tecnica de como lo resuelve:
  1. **V_Inventario_Critico**: WITH (CTE) para calcular ventas diarias promedio, multiples JOINs (Productos-Inventario-Categorias-CTE), COALESCE para manejo de nulos, CASE con multiples condiciones para clasificar estado (Estancado, CRITICO, Suficiente), ROUND, division segura con manejo de cero ventas asignando cobertura 9999. Excepcional nivel de sofisticacion.
  2. **V_Resumen_Zona**: JOIN Pedidos-Comercios, SUM con CASE condicional para entregas exitosas vs con incidencia, ROUND con NULLIF para tasa de exito porcentual, casting a DECIMAL, HAVING COUNT > 5 para actividad significativa. Muy bien implementada.
  3. **V_Productividad_Conductores**: JOINs de Conductores-Rutas-Ruta_Pedido-Pedidos, COUNT DISTINCT, ROUND con NULLIF para promedio por ruta, CASE para clasificacion de rendimiento (Alto > 40, Promedio 15-40, Bajo < 15). Rangos justificados.
  4. **V_Utilizacion_Flota**: LEFT JOIN con condicion en ON (filtro de fecha con DATE_TRUNC), COUNT para rutas por mes, CASE con clasificacion (Subutilizado = 0, Punto Optimo 1-20, Sobrecargado > 20). Uso avanzado de filtrado temporal en el JOIN.
  5. **V_Rentabilidad_Proveedor**: Subqueries correlacionadas para Total_Ventas_Estimadas y Margen_Bruto, COALESCE, LEFT JOIN con condicion de tipo movimiento, GROUP BY. La mas compleja de todas las vistas.
- Uso de CREATE OR REPLACE VIEW (buena practica).
- Uso de WITH (CTE) en la primera vista demuestra conocimiento avanzado.
- COALESCE usado en 4 de 5 vistas para manejo robusto de nulos.
- CASE usado en 4 de 5 vistas con rangos justificados.
- HAVING utilizado correctamente en V_Resumen_Zona.
- NULLIF para prevencion de division por cero en 3 vistas.
- DATE_TRUNC para filtrado temporal en V_Utilizacion_Flota.
- Subqueries correlacionadas en V_Rentabilidad_Proveedor.
- Todas las vistas son 100% coherentes con el esquema relacional del diagrama ER.

**Debilidades:**
- Ninguna debilidad significativa. Las 5 VIEWS cumplen y superan todos los criterios de evaluacion.

### 5. Justificacion de Diseno (7/10)

**Fortalezas:**
- Responden ambas preguntas obligatorias ("Por que escogieron ese caso" y "Por que lo disenaron asi").
- La justificacion del diseno describe un proceso metodico: identificaron relaciones, redujeron de 15 a 13 tablas, desglosaron el flujo del negocio (proveedor -> almacen -> pedido -> ruta -> entrega).

**Debilidades:**
- La justificacion del caso es debil: dicen que eligieron el caso 3-A porque era "menos complejo" que los otros dos casos de 3. Esto contradice la naturaleza del caso (logistica con 14 tablas) y no demuestra motivacion genuina ni comprension de la relevancia del dominio. (-2 pts)
- La justificacion del diseno es descriptiva pero poco tecnica. Mencionan que crearon tablas "a base de los datos que se nos presentaron en la problematica" sin profundizar en decisiones especificas de normalizacion, trade-offs de rendimiento, o por que eligieron ciertas claves naturales (Placas, Numero_Licencia) en lugar de claves surrogadas. (-1 pt)
- No mencionan trade-offs ni alternativas que hayan considerado y descartado.

---

## OBSERVACIONES ADICIONALES

1. **ENTREGA DUPLICADA**: Esta carpeta (EXAMEN1_SYSDES__5B_243732-20260205T205554Z-3-001) contiene el mismo trabajo que la carpeta EXAMEN1_SYSDES__5B_243716. Ambas tienen la subcarpeta "EXAMEN1_SYSDES__5B_243732". Esto indica que el equipo subio el trabajo desde multiples cuentas o en multiples ocasiones. La calificacion aplica una sola vez para los tres integrantes: **243732, 243777 y 243716**.

2. **Trabajo de alta calidad**: Este es uno de los trabajos mas completos evaluados. El esquema de 14 tablas con tipos de datos precisos, las 5 VIEWS con tecnicas avanzadas (CTE, subqueries correlacionadas, DATE_TRUNC), y las 5 queries de ejemplo con variedad tecnica demuestran un dominio solido de bases de datos.

3. **Contraste entre calidad tecnica y justificacion**: El trabajo tecnico es excelente, pero la justificacion escrita es notablemente mas debil. Esto podria indicar que los estudiantes tienen buen dominio practico pero les cuesta articular sus decisiones por escrito, o que la seccion de justificacion se hizo con menos atencion.

4. **Restricciones en prosa vs SQL**: A pesar de que las restricciones no estan en SQL, la profundidad y especificidad de las descripciones (formato RFC, edad >= 21, cantidad_entregada + cantidad_danada <= cantidad_solicitada) demuestra que fueron pensadas seriamente, no genericamente.

5. **Uso de claves naturales**: La decision de usar Placas como PK de vehiculos y Numero_Licencia como PK de conductores es interesante y demuestra reflexion, aunque tiene implicaciones de rendimiento en JOINs con VARCHAR vs INT.

---

## PREGUNTAS DE SEGUIMIENTO PARA DEFENSA

──────────────────────────────────────────────────────────────

### 1. [COMPRENSION]
**Pregunta:** En su modelo, separaron la tabla "inventario" de la tabla "productos". Expliquen que informacion guarda cada una y por que no pusieron las columnas de inventario (Cantidad_Disponible, Stock_Minimo, Stock_Maximo) directamente en la tabla productos.

**Respuesta esperada:** La tabla "productos" es un catalogo maestro con informacion descriptiva (nombre, categoria, precio base, peso, si es perecedero). La tabla "inventario" contiene informacion operativa y dinamica (cantidad disponible, cantidad reservada, stock minimo/maximo, fechas de ultima entrada y salida). Separar ambas respeta la normalizacion: la informacion de stock cambia frecuentemente mientras que el catalogo del producto es relativamente estatico. Ademas, permite tener productos sin inventario (productos descontinuados que mantienen historial) y evita bloqueos de tabla por actualizaciones concurrentes de stock.

### 2. [FALENCIAS]
**Pregunta:** Su tabla "detalle_entrega" registra cantidades entregadas, danadas y faltantes. Sin embargo, no tienen una tabla de "incidencias" separada. Si un pedido tiene 3 productos y solo 1 llega danado, como registran la razon especifica del dano? Detectan alguna limitacion?

**Respuesta esperada:** Deberian reconocer que su tabla detalle_entrega tiene un campo "Observaciones TEXT" donde se puede documentar la razon, pero esto es texto libre sin estructura. La limitacion es que no pueden categorizar tipos de incidencia (dano por transporte, dano por clima, faltante por error de carga, etc.) ni hacer reportes agregados por tipo de incidencia. Una mejora seria crear una tabla "tipos_incidencia" como catalogo y vincularla al detalle_entrega, o crear una tabla dedicada de incidencias con campos estructurados (tipo, severidad, causa raiz).

### 3. [MEJORA]
**Pregunta:** Su vista V_Inventario_Critico usa un CTE (WITH Ventas_Diarias) que calcula el promedio de venta de los ultimos 30 dias. Si un producto es estacional (ej. se vende mucho en diciembre pero poco en enero), su vista podria dar alertas incorrectas. Como mejorarian el calculo para manejar estacionalidad?

**Respuesta esperada:** Podrian considerar: (1) Ampliar la ventana de tiempo a 90 o 365 dias para suavizar la estacionalidad. (2) Usar un promedio ponderado donde los dias recientes pesan mas. (3) Crear una tabla de "temporadas" o "factores estacionales" por categoria y multiplicar el promedio por un factor de ajuste. (4) Comparar contra el mismo periodo del ano anterior en lugar de los ultimos 30 dias. Esto mejoraria la precision de las alertas de inventario critico.

### 4. [DECISION]
**Pregunta:** Usaron Placas como clave primaria de vehiculos y Numero_Licencia como clave primaria de conductores, en lugar de un ID numerico autoincremental. Cuales son las ventajas y desventajas de esta decision? En que situacion real podria causar problemas?

**Respuesta esperada:** Ventajas: las claves naturales tienen significado de negocio, eliminan la necesidad de buscar el ID correspondiente, y facilitan lecturas humanas de los datos. Desventajas: los VARCHAR son mas lentos en JOINs que los INT, ocupan mas espacio en indices, y si un vehiculo cambia de placas (por ejemplo, al renovar emplacamiento) habria que actualizar la PK y todas las FK que la referencian (en rutas, por ejemplo), lo cual es problematico. Con un ID surrogado, el cambio de placas seria simplemente un UPDATE de un campo regular. Este es el tipico trade-off entre claves naturales vs surrogadas.

### 5. [APLICACION]
**Pregunta:** Supongamos que un comercio hace un pedido grande que requiere 2 vehiculos para ser entregado. Usando su modelo actual, describan paso a paso como registrarian este escenario en la base de datos, mencionando que tablas se afectan y en que orden.

**Respuesta esperada:** (1) Se crea UN registro en la tabla "pedidos" con el total del pedido. (2) Se crean los registros correspondientes en "detalle_pedido" con cada producto y cantidad. (3) Se crean DOS registros en la tabla "rutas", uno para cada vehiculo con su conductor asignado. (4) En la tabla puente "ruta_pedido", se crea un registro por cada ruta vinculandola al mismo ID_Pedido, con Orden_Entrega apropiado. (5) Al momento de la entrega, se crean registros en "detalle_entrega" por cada ruta indicando que cantidades entrego cada vehiculo. (6) Se actualizan los registros de "inventario" restando las cantidades despachadas y (7) se registran los "movimientos_inventario" correspondientes como tipo SALIDA.

═══════════════════════════════════════════════════════════════
