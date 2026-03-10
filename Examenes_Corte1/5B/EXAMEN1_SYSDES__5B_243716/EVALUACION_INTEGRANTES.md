# EVALUACION DE EXAMEN PARCIAL - BASE DE DATOS AVANZADA

===================================================================
EVALUACION: EXAMEN1_SYSDES__5B_243716
Caso: 3-A - Logistica de Distribucion Regional
Integrantes: 3 (Hidalgo Garcia Luvia Magali 243732, Montesinos Grajales Alix Anahi 243777, Velazquez Tovilla Mario Alberto 243716)
===================================================================

---

## RESUMEN DE PUNTUACION

| Seccion | Puntos Obtenidos | Puntos Maximos | Porcentaje |
|---------|------------------|----------------|------------|
| Modelo ER + Esquema Relacional | 27/30 | 30 | 90.0% |
| Restricciones | 18/20 | 20 | 90.0% |
| Queries SQL | 20/25 | 25 | 80.0% |
| VIEWS | 14/15 | 15 | 93.3% |
| Justificacion de Diseno | 7/10 | 10 | 70.0% |
| **TOTAL** | **86/100** | **100** | **86.0%** |

### Calificacion Final: 9.0 / 10
### Porcentaje del 15% de la Calificacion Final: 12.9%

---

## RETROALIMENTACION DETALLADA

### 1. Modelo ER + Esquema Relacional (27/30)

**Puntuacion desglosada:**
- Identificacion de entidades principales: 8/8
- Cardinalidades correctas: 5/6
- Claves primarias definidas: 5/5
- Claves foraneas correctas: 5/5
- Normalizacion: 2/3
- Tablas puente para N-N: 2/3

**Fortalezas:**
- **Excelente cobertura de entidades**: 14 tablas identificadas (categorias, comercios, conductores, detalle_entrega, detalle_pedido, inventario, movimientos_inventario, pedidos, productos, proveedor_producto, proveedores, ruta_pedido, rutas, vehiculos). Supera el minimo de 9-12 tablas requerido para equipo de 3.
- **Tabla puente `proveedor_producto`** correctamente modelada como relacion N-N entre proveedores y productos, con atributos propios (Precio_Proveedor, Tiempo_Entrega_Dias, Es_Proveedor_Principal, Fecha_Inicio_Suministro). Excelente diseno.
- **Tabla puente `ruta_pedido`** que vincula rutas con pedidos en relacion N-N, incluyendo Orden_Entrega y tiempos estimados vs reales. Muy bien pensada.
- **Tabla `detalle_entrega`** separada de `detalle_pedido`, lo que permite registrar incidencias de entrega (Cantidad_Danada, Cantidad_Faltante, Firma_Digital, Nombre_Receptor). Diseno sofisticado.
- **Tabla `inventario`** separada de productos con Cantidad_Disponible, Cantidad_Reservada, Stock_Minimo, Stock_Maximo. Permite gestion avanzada de inventario.
- **Tabla `movimientos_inventario`** con Tipo_Movimiento, permitiendo registrar entradas, salidas y ajustes en una sola tabla (decision de diseno acertada).
- **PKs bien definidas**: Uso de INT con AUTO_INCREMENT para la mayoria, y PKs naturales para vehiculos (Placas) y conductores (Numero_Licencia).
- **Tabla `comercios`** con campos completos: RFC, Direccion, Municipio, Estado_Republica, Zona, Credito_Autorizado, Saldo_Pendiente. Modelado rico y apropiado.
- **Tabla `categorias`** con Margen_Sugerido, lo que permite calculos de rentabilidad.
- Tipos de datos bien especificados con precision (DECIMAL(12,3), VARCHAR con longitudes apropiadas, TINYINT para booleanos).

**Debilidades:**
- **Falta tabla de Almacen explicita**: El caso menciona "almacen central" pero no hay una tabla de almacenes. El inventario y los movimientos no se asocian a un almacen especifico, lo que dificulta la escalabilidad a multiples almacenes. (-1 pts normalizacion)
- **Vehiculos usa Placas como PK natural**: Aunque funcional, las placas pueden cambiar (reemplacamiento). Un ID surrogado seria mas robusto, aunque esta decision es defendible.
- La relacion entre conductores y rutas usa Numero_Licencia como FK, lo cual es correcto pero poco convencional (las licencias tambien pueden renovarse con nuevo numero).
- No se observan cardinalidades explicitas en notacion formal en el diagrama, aunque las relaciones se infieren correctamente por las FK y las lineas de conexion con notacion Crow's foot visible.

### 2. Restricciones (18/20)

**Puntuacion desglosada:**
- NOT NULL apropiados: 4/4
- UNIQUE constraints: 4/4
- CHECK constraints: 4/4
- Integridad referencial (FK): 3/4
- Restricciones de negocio: 3/4

**Fortalezas:**
- **UNIQUE bien aplicados**: Nombres de categorias, RFC de proveedores y comercios, ficha de inventario por producto, producto unico por pedido en detalle, orden de entrega unico por ruta. Excelente cobertura (5 UNIQUE identificados).
- **CHECK constraints sofisticados y bien pensados**:
  - Valores positivos para precios, pesos, inventarios, capacidades.
  - Fechas coherentes (fecha entrega >= fecha pedido, vehiculos ano >= 2000).
  - Limites financieros (saldo <= credito autorizado, total = subtotal + IVA).
  - Requisitos de personal (conductores mayores de 21 anos, licencia vigente).
  - Consistencia de entregas (entregada + danada <= solicitada).
  - Formato RFC con patron oficial.
  - Estados validos predefinidos para vehiculos y pedidos.
- **NOT NULL correctamente aplicados**: Nombre y RFC obligatorios, fechas criticas obligatorias, cantidades obligatorias, estados siempre asignados.
- **Integridad referencial bien explicada**:
  - ON DELETE RESTRICT para proteger historial (proveedores con productos, comercios con pedidos).
  - ON DELETE CASCADE para detalles de pedido.
  - Existencia previa requerida para asignaciones.
- Se superan ampliamente las 10 restricciones requeridas para equipo de 3 (se identifican mas de 15).

**Debilidades:**
- Las restricciones se presentan de forma narrativa/descriptiva en lugar de sintaxis SQL. Aunque la logica es clara y correcta, la falta de codigo CREATE TABLE o ALTER TABLE con las restricciones explicitas reduce ligeramente el valor tecnico.
- Falta mencion de restriccion para evitar que un vehiculo en estado "Mantenimiento" sea asignado a una ruta (requiere trigger, pero deberia mencionarse como restriccion de negocio).
- No se menciona restriccion para evitar que un conductor tenga dos rutas en la misma fecha.

### 3. Queries SQL (20/25)

**Puntuacion desglosada:**
- Sintaxis correcta: 4/5
- JOINs apropiados: 7/8
- Agregaciones: 4/5
- GROUP BY / HAVING: 3/4
- Cobertura de queries requeridas: 2/3

**Fortalezas:**
- **Query 1 (Pedidos sin ruta)**: Uso correcto de LEFT JOIN con IS NULL para detectar pedidos confirmados no asignados. Referencia correcta a tablas del modelo.
- **Query 2 (Alerta sobrecarga)**: Excelente complejidad con 6 JOINs encadenados (Rutas -> Vehiculos -> Ruta_Pedido -> Pedidos -> Detalle_Pedido -> Productos), uso de SUM para calcular peso total, y CASE para clasificar "PELIGRO" vs "OK". Muestra dominio avanzado.
- **Query 3 (Rutas con incidencias)**: Uso correcto de GROUP BY + HAVING con SUM(CASE WHEN...) para contar incidencias y filtrar solo rutas con problemas. Excelente uso del patron.
- **Query 4 (Gasto por proveedor)**: Uso correcto de LEFT JOIN para incluir proveedores sin movimientos, COALESCE para manejar NULLs, filtro en condicion de JOIN para tipo 'ENTRADA'.
- **Query 5 (Valor inventario por categoria)**: JOINs correctos entre Inventario, Productos y Categorias con GROUP BY por nombre de categoria. Calculo correcto de valor total.
- Cada query incluye una explicacion del objetivo y la justificacion de los elementos SQL utilizados, lo que demuestra comprension.

**Debilidades:**
- **Solo 5 queries presentadas**. El caso 3-A requiere 6 queries. Falta la query del "pedido mas reciente por comercio". (-1 pts cobertura)
- Las queries se presentan como imagenes/capturas de codigo en el PDF en lugar de texto plano, lo que dificulta la verificacion exacta de sintaxis.
- Query 2 usa muchos JOINs pero no valida si los pedidos estan en estado activo (podria sumar peso de pedidos cancelados).
- Falta una query que muestre las entradas de almacen del mes por proveedor de forma independiente (Query 4 calcula gasto total pero no desglose mensual).
- No se incluye una query con subquery correlacionada o EXISTS, que mostraria mayor variedad de tecnicas.

### 4. VIEWS (14/15)

**Puntuacion desglosada:**
- Sintaxis CREATE VIEW: 3/3
- Agregaciones correctas: 4/4
- Uso de HAVING: 3/3
- Uso de CASE/COALESCE: 3/3
- Coherencia con esquema: 1/2

**Fortalezas:**
- Se presentan **5 VIEWS completas**, cumpliendo el requisito para equipo de 3.
- **View 1 (V_Inventario_Critico)**: La mas impresionante. Usa CTE (WITH Ventas_Diarias), COALESCE extensivo para manejar cero ventas, CASE con logica para asignar 9999 dias de cobertura cuando no hay ventas (evita division por cero), clasificacion de estado ("Estancado", "CRITICO", "Suficiente"), y filtrado con WHERE combinando condiciones. Uso de ROUND para precision. Diseno profesional.
- **View 2 (V_Resumen_Zona)**: Uso correcto de SUM(CASE WHEN...) para conteo condicional de entregas exitosas e incidencias, calculo de tasa de exito con NULLIF para division segura, casting a DECIMAL, ROUND, y HAVING COUNT > 5 para filtrar zonas con actividad significativa. Justificacion del umbral incluida.
- **View 3 (V_Productividad_Conductores)**: NULLIF para division segura, CASE con rangos justificados (>40 alto, 15-40 promedio, <15 bajo/en capacitacion), COUNT(DISTINCT) para metricas precisas, filtro WHERE por estados relevantes.
- **View 4 (V_Utilizacion_Flota)**: LEFT JOIN para incluir vehiculos sin rutas, CASE con umbrales justificados (0 subutilizado, 1-20 optimo, >20 sobrecargado), filtro de fecha con DATE_TRUNC. Incluye Modelo y Capacidad_Kg para contexto.
- **View 5 (V_Rentabilidad_Proveedor)**: Uso avanzado de subqueries correlacionadas para calcular ventas estimadas, COALESCE extensivo, calculo de margen bruto. Complejidad alta con logica de negocio bien implementada.
- Cada VIEW incluye justificacion escrita explicando el "por que" de las decisiones tecnicas.
- Sintaxis PostgreSQL consistente en todas las VIEWS.

**Debilidades:**
- View 5 usa subqueries correlacionadas que podrian ser ineficientes en bases de datos grandes. Un JOIN seria mas eficiente, aunque la logica es correcta.
- Las VIEWS referencian tablas y campos que son coherentes con el diagrama ER, excepto que View 1 referencia `Categorias` e `Inventario` correctamente. Sin embargo, la tabla `Categorias` en el diagrama no tiene todos los campos referenciados (cat.Nombre se usa pero la PK es ID_Categoria).
- No se presenta una VIEW que use HAVING de forma mas compleja (ej. HAVING con multiples condiciones).

### 5. Justificacion de Diseno (7/10)

**Puntuacion desglosada:**
- Por que escogieron ese caso: 3/4
- Por que lo disenaron asi: 4/6

**Fortalezas:**
- La respuesta a "por que escogieron el caso" es honesta y practica: eligieron el caso que consideraron menos complejo para poder resolverlo correctamente en el tiempo disponible. Aunque no es la justificacion mas academica, demuestra pragmatismo.
- La respuesta a "por que lo disenaron asi" describe un **proceso de analisis sistematico**: identificaron relaciones y tablas, redujeron de 15 a 13 tablas, analizaron el flujo de datos (proveedor -> almacen -> tienda -> ruta). Esto demuestra que hubo un proceso de diseno real.
- Se menciona la logica del flujo de negocio: entrada al almacen, verificacion de stock, confirmacion de pedido, creacion de ruta, asignacion de vehiculo y conductor.

**Debilidades:**
- **No se mencionan trade-offs especificos**: por que proveedor_producto como N-N, por que una tabla de movimientos en vez de dos, por que Placas como PK de vehiculos.
- La justificacion de reduccion de 15 a 13 tablas no explica cuales tablas se eliminaron ni por que.
- No se mencionan alternativas descartadas ni decisiones no obvias.
- La redaccion es algo desordenada y podria ser mas concisa.

---

## PREGUNTAS DE SEGUIMIENTO PARA DEFENSA

### 1. [COMPRENSION]
**Pregunta:** En su diagrama, la tabla `proveedor_producto` tiene un campo `Es_Proveedor_Principal` de tipo TINYINT. Expliquen que significa este campo, por que es necesario cuando ya existe la relacion N-N entre proveedores y productos, y como se utilizaria en una consulta para seleccionar al proveedor preferido para una compra.

**Respuesta esperada:** El campo Es_Proveedor_Principal es un booleano que indica cual de los multiples proveedores de un producto es el predeterminado para las compras. Es necesario porque un producto puede tener varios proveedores con diferentes precios y tiempos, y el sistema necesita saber a cual priorizar. En una consulta se usaria como: `SELECT * FROM proveedor_producto WHERE ID_Producto = X AND Es_Proveedor_Principal = 1`. Deberian tambien mencionar que se necesita una restriccion para que solo un proveedor sea principal por producto (UNIQUE parcial o trigger).

### 2. [FALENCIAS]
**Pregunta:** Su modelo no tiene una tabla de Almacen. Los movimientos de inventario y el stock se asocian solo al producto, no a una ubicacion fisica. Si la distribuidora abriera un segundo almacen en otro estado, que problemas tendria su diseno actual y que cambios serian necesarios?

**Respuesta esperada:** El diseno actual no soporta multiples almacenes. El inventario (Cantidad_Disponible, Stock_Minimo/Maximo) esta asociado solo al producto sin ubicacion. Para soportar multiples almacenes, se necesitaria: (1) crear tabla `Almacenes` con ID, Nombre, Ubicacion, Estado; (2) modificar tabla `inventario` para agregar FK a Almacenes, con UNIQUE(ID_Producto, ID_Almacen); (3) modificar `movimientos_inventario` para incluir ID_Almacen. Tambien deberian considerar que las rutas partirian de un almacen especifico.

### 3. [MEJORA]
**Pregunta:** Su tabla `detalle_entrega` registra cantidades danadas y faltantes, pero no tiene una clasificacion del tipo de incidencia (dano por transporte, producto vencido, error de cantidad, etc.). Si el negocio quisiera un reporte de incidencias por tipo para identificar problemas recurrentes, como modificarian su modelo?

**Respuesta esperada:** Se podria agregar: (1) una tabla `tipos_incidencia` con ID, Nombre, Descripcion; (2) un campo ID_Tipo_Incidencia como FK en detalle_entrega; o bien (3) un campo `Tipo_Incidencia` VARCHAR con CHECK constraint para valores validos. La primera opcion es mas flexible y normalizada. Alternativamente, se podria crear una tabla separada `incidencias` vinculada a detalle_entrega para registrar multiples incidencias por entrega. El reporte seria un GROUP BY tipo_incidencia con COUNT.

### 4. [DECISION]
**Pregunta:** Ustedes decidieron usar `Placas` como clave primaria de la tabla `vehiculos` en lugar de un ID numerico autogenerado. Tambien usaron `Numero_Licencia` como PK de conductores. Cuales son las ventajas y desventajas de usar claves naturales vs surrogadas en estas tablas? En que escenarios su decision podria causar problemas?

**Respuesta esperada:** Ventajas de PKs naturales: son significativas y legibles, no requieren secuencias, facilitan identificacion rapida. Desventajas: las placas pueden cambiar por reemplacamiento (requiere UPDATE en cascada en rutas y todas las FKs), las licencias se renuevan con nuevo numero. Un cambio de PK requiere actualizar todas las tablas que la referencian. Con ID surrogado, el cambio de placa seria solo un UPDATE en vehiculos.Placas sin afectar FKs. La decision es defendible para un sistema con pocos cambios, pero problematica a escala.

### 5. [APLICACION]
**Pregunta:** Usando su modelo, describan paso a paso como se registraria el siguiente escenario: un proveedor envia 100 unidades de un producto al almacen, se crea un pedido de 30 unidades de ese producto para un comercio, se asigna el pedido a una ruta, y al entregar se danan 5 unidades. Que tablas se modifican en cada paso y que campos se actualizan?

**Respuesta esperada:** (1) Entrada almacen: INSERT en `movimientos_inventario` con Tipo_Movimiento='ENTRADA', Cantidad=100, ID_Proveedor, Costo_Unitario. UPDATE `inventario` incrementando Cantidad_Disponible en 100. (2) Pedido: INSERT en `pedidos` con ID_Comercio, Estado='Confirmado', Total. INSERT en `detalle_pedido` con ID_Producto, Cantidad_Solicitada=30, Precio_Unitario, Subtotal. UPDATE `inventario` moviendo 30 de Cantidad_Disponible a Cantidad_Reservada. (3) Ruta: INSERT en `rutas` con Placas_Vehiculo, Licencia_Conductor, Fecha_Ruta. INSERT en `ruta_pedido` con ID_Ruta, ID_Pedido, Orden_Entrega. (4) Entrega con dano: INSERT en `detalle_entrega` con Cantidad_Entregada=25, Cantidad_Danada=5, Observaciones. UPDATE pedidos Estado='Entregado con incidencia'.

---

## OBSERVACIONES ADICIONALES

1. **Trabajo de alta calidad**: Este es un trabajo notablemente bien estructurado para un equipo de 3. El diagrama ER es profesional (generado con una herramienta de modelado como MySQL Workbench o DBeaver), con tipos de datos precisos, indices señalados, y relaciones claras.

2. **Fortaleza en VIEWS**: Las 5 VIEWS son el punto mas fuerte del trabajo. Demuestran dominio avanzado de SQL con CTEs, COALESCE, NULLIF, CASE, subqueries correlacionadas, y justificaciones escritas para cada decision tecnica. El manejo del caso "division por cero" es particularmente bien resuelto.

3. **Restricciones bien pensadas**: Aunque presentadas en formato narrativo en lugar de SQL, las restricciones son comprehensivas y demuestran entendimiento profundo de la integridad de datos. La mencion de ON DELETE RESTRICT vs CASCADE con justificacion es notable.

4. **Area de mejora principal**: La falta de una tabla de Almacen es la omision mas significativa del modelo, especialmente dado que el caso se llama "Logistica de Distribucion Regional" y menciona explicitamente un almacen central.

5. **Consistencia tecnica**: El trabajo mantiene consistencia en sintaxis PostgreSQL a lo largo de queries y VIEWS. Las explicaciones incluidas con cada query y VIEW demuestran que el equipo comprende lo que escribio.

6. **Presentacion profesional**: El documento tiene formato limpio con secciones numeradas, codigos en bloques de codigo con sintaxis resaltada, y explicaciones contextuales. La calidad de presentacion es superior al promedio.

7. **Queries con contexto**: Cada query va acompanada de un "Objetivo" y una "Explicacion" que describe el por que de cada tecnica SQL utilizada. Esto demuestra comprension y no solo copia de codigo.
