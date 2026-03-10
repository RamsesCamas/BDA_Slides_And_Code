═══════════════════════════════════════════════════════════════
EVALUACION: EXAMEN1_SYSDES__5B_243678
Caso: 3-A - Logistica de Distribucion Regional
Matriculas: 243678 (Yael Betanzos Jimenez), 243752 (Jose Maria Moreno Perez), 243696 (Mishell Prado Gordillos)
Integrantes: 3
═══════════════════════════════════════════════════════════════

## PUNTUACION POR SECCION

| Criterio                      | Puntos Obtenidos | Puntos Maximos |
|-------------------------------|------------------|----------------|
| Modelo ER + Esquema Relacional | 20               | 30             |
| Restricciones                 | 13               | 20             |
| Queries SQL                   | 19               | 25             |
| VIEWS                         | 14               | 15             |
| Justificacion de Diseno       | 6                | 10             |
|-------------------------------|------------------|----------------|
| **TOTAL**                     | **72**           | **100**        |

──────────────────────────────────────────────────────────────
**CALIFICACION (este evaluador): 8.0/10**
**PORCENTAJE FINAL (este evaluador): 10.8% de 15%**

## PUNTUACION RECONCILIADA (Escala Lineal + Rangos)

> **Nota del Docente:** Este equipo fue evaluado por 3 evaluadores distintos (carpetas 243678, 243696, 243752) con puntuaciones de 72, 65 y 58. Se aplica promedio lineal y luego rangos.
>
> **Promedio lineal:** (72 + 65 + 58) / 3 = **65/100**
> **Rango aplicado:** 60-69 = **Calificacion: 7.0/10**

**CALIFICACION RECONCILIADA: 7.0/10**
**PUNTUACION RECONCILIADA: 65/100**
**PORCENTAJE FINAL RECONCILIADO: 9.75% de 15%**
═══════════════════════════════════════════════════════════════

---

## RETROALIMENTACION DETALLADA

### [Modelo ER + Esquema Relacional] — 20/30

**Fortalezas:**
- Se identifican 12 entidades/tablas: Proveedores, Envio, Envio_detalles, Comprador, Pedido, Pedido_detalles, Camioneta, Conductor, Almacen, Productos_Existentes, Producto, producto_almacen, Ruta. Esto cumple con el minimo de 9-12 tablas para equipo de 3.
- Todas las tablas tienen claves primarias definidas (SERIAL PRIMARY KEY).
- Se incluyen claves foraneas (FK) en la mayoria de las tablas: id_compradorFK en Envio, id_envio y id_producto en Envio_detalles, id_provedor en Pedido, id_pedido en Pedido_detalles, id_almacen en Camioneta, id_conductor en Camioneta, id_camioneta e id_conductor en Ruta, id_producto e id_almacen en producto_almacen.
- Se incluye la tabla puente `producto_almacen` que resuelve la relacion N-N entre Producto y Almacen.
- Se incluyen tablas de detalle (`Envio_detalles`, `Pedido_detalles`) que actuan como tablas puente para relaciones N-N entre pedidos/envios y productos.

**Debilidades:**
- **Falta entidad de Ruta visible en el diagrama ER como tabla independiente claramente conectada** (-2 pts). Aunque la tabla Ruta existe, las relaciones en el diagrama UML no muestran claramente todas las cardinalidades con lineas de conexion etiquetadas (1-N, N-N).
- **Las cardinalidades no estan explicitas en el diagrama** (-4 pts). El diagrama UML muestra conexiones entre tablas pero no etiqueta las cardinalidades (1:1, 1:N, N:N). Solo se infieren por la estructura de FKs.
- **Nomenclatura inconsistente**: Se usa "Comprador" en lugar de "Comercio" (el caso habla de comercios en 3 estados). La tabla `Productos_Existentes` en restricciones parece diferir de `Producto` en el diagrama. Hay confusiones entre `Proveedor/Proveedores` (singular vs plural).
- **Falta tabla o concepto de "Incidencias"** como entidad separada. El caso menciona entregas con/sin incidencias; solo se maneja como campo `cantidad_rechazada` en detalles.
- **Falta tabla o campo para estados de vehiculos** (disponible, en ruta, mantenimiento). El campo `estado` en Camioneta existe pero no se define el dominio de valores con CHECK.
- **No se evidencia normalizacion explicita** ni se discute el grado de normalizacion alcanzado.

**Penalizaciones aplicadas:**
- Cardinalidades no explicitas en diagrama: -4 pts
- Nomenclatura inconsistente entre diagrama y restricciones: -2 pts
- Falta entidad Incidencias separada: -2 pts
- Sin explicacion de normalizacion: -2 pts

---

### [Restricciones] — 13/20

**Fortalezas:**
- Se definen restricciones NOT NULL en campos criticos para la mayoria de tablas (RFC, UBICACION, ESTADO, ID_PROVEEDOR, NOMBRE, LICENCIA, ID_ALMACEN, etc.).
- Se incluye UNIQUE para RFC en Proveedores (correcto, el RFC debe ser unico).
- Se incluyen CHECK constraints para cantidades positivas: `cantidad > 0` en Envio_detalles y Pedido_detalles, `capacidad > 0.00` en Camioneta.
- Se definen tipos de datos apropiados: VARCHAR con longitudes (100, 50, 255, 8), DECIMAL para capacidad.
- Claves primarias definidas como SERIAL PRIMARY KEY en todas las tablas.

**Debilidades:**
- **Faltan restricciones UNIQUE adicionales** (-2 pts): La placa de la camioneta deberia ser UNIQUE (solo se define como NOT NULL y VARCHAR(8)). La licencia del conductor tambien deberia ser UNIQUE.
- **Faltan CHECK constraints importantes** (-1 pt): No hay CHECK para el campo `estado` de Camioneta (deberia limitar a 'disponible', 'en_ruta', 'mantenimiento'). No hay CHECK para `estatus` de Pedido/Envio.
- **Falta integridad referencial explicita** (-2 pts): Aunque se mencionan FKs en el diagrama, las restricciones listadas en el documento no definen explicitamente FOREIGN KEY ... REFERENCES ... Las FKs solo aparecen como NOT NULL, sin especificar la tabla referenciada ni acciones ON DELETE/ON UPDATE.
- **Faltan restricciones de negocio** (-2 pts): No se modela la restriccion de que un vehiculo solo puede estar en una ruta a la vez, ni que un conductor solo puede estar asignado a una ruta activa. No hay restriccion para evitar sobrecarga (peso > capacidad).
- El requisito para equipo de 3 es minimo 10 restricciones. Se cuentan aproximadamente 20+ restricciones individuales (NOT NULL, PK, UNIQUE, CHECK), lo cual cumple la cantidad pero falta profundidad en reglas de negocio.

---

### [Queries SQL] — 19/25

**Fortalezas:**
- Se presentan 6 queries SQL con sintaxis correcta y razonable.
- **Query 1** (Pedidos Confirmados): JOIN correcto entre Pedido y Comprador, filtro por estatus con WHERE, uso de IS NULL. Buena logica.
- **Query 2** (Peso total vs capacidad): Excelente query con LEFT JOINs multiples (Ruta -> Camioneta -> Pedido -> Pedido_detalles), uso de COALESCE(SUM(...), 0), calculo de capacidad disponible, y GROUP BY apropiado.
- **Query 3** (Movimientos de entrada): Uso de JOINs multiples (Producto_almacen -> Producto -> Proveedor), funciones de agregacion COUNT y SUM, filtro temporal con DATE_SUB, y GROUP BY.
- **Query 4** (Rutas con incidencias): JOINs de 4 tablas, uso de COUNT(DISTINCT), SUM con CASE WHEN para contar incidencias, filtro temporal.
- **Query 5** (Valor inventario): Calculo con multiplicacion de campos, ORDER BY DESC.
- **Query 6** (Pedido mas reciente): Subconsulta correlacionada con MAX(), correcta logica.

**Debilidades:**
- **Falta uso de HAVING** (-3 pts): Ninguna query utiliza HAVING, que es parte del criterio de evaluacion. Podria haberse usado en Query 2 para filtrar rutas sobrecargadas, o en Query 3 para filtrar proveedores con cierto volumen.
- **Query 5 no es realmente "por categoria"** (-1 pt): El titulo dice "por categoria" pero la query no agrupa por categoria, solo lista productos individuales. Falta un GROUP BY por categoria.
- **DATE_SUB es sintaxis MySQL**, mientras que el diagrama y algunas queries sugieren PostgreSQL (SERIAL, etc.). Inconsistencia menor en dialecto SQL.
- **No hay queries de INSERT, UPDATE o DELETE** que demuestren manejo completo de DML, aunque esto no es estrictamente requerido.
- Las queries referencian tablas y campos que no siempre coinciden exactamente con el diagrama (ej. `Producto_almacen` vs `producto_almacen`, `Pedido_detalles` vs `Pedido_detalle`).

---

### [VIEWS] — 14/15

**Fortalezas:**
- Se presentan **5 VIEWS** (cumple y supera el minimo de 5 para equipo de 3). Excelente cobertura.
- **View 1** (Pedidos por zona): CREATE OR REPLACE VIEW correcta, uso de SUM con CASE WHEN para contar entregas exitosas e incidencias, calculo de tasa de exito como porcentaje. Incluye JOIN y LEFT JOIN. Muy buena.
- **View 2** (Productividad de conductores): Uso de COUNT(DISTINCT), NULLIF para division segura, CASE con rangos (BETWEEN) para clasificacion. Muy bien estructurada.
- **View 3** (Inventario critico): Excelente uso de COALESCE, CASE para evitar division por cero, calculo de dias de cobertura, y **HAVING** con expresion CASE compleja. Esta es la view mas sofisticada y demuestra buen dominio.
- **View 4** (Rentabilidad por proveedor): Calculos de margen de ganancia con JOINs de 3 tablas y agregaciones SUM.
- **View 5** (Utilizacion de flota): LEFT JOIN, CASE con BETWEEN, uso de DATE_TRUNC (sintaxis PostgreSQL correcta).
- Se usan CREATE VIEW y CREATE OR REPLACE VIEW correctamente.
- Uso extensivo de CASE/WHEN/ELSE/END y COALESCE en multiples views.

**Debilidades:**
- **Solo View 3 usa HAVING** (-1 pt). Se esperaria uso de HAVING en al menos una view adicional.
- Las views son coherentes con el esquema general, aunque algunas referencian campos no definidos explicitamente en las restricciones (como `precio_venta` en Pedido_detalles, `costo_unitario` en Producto).

---

### [Justificacion de Diseno] — 6/10

**Fortalezas:**
- Responden ambas preguntas (por que escogieron el caso y por que lo disenaron asi).
- La justificacion de la eleccion del caso es razonable: mencionan experiencia previa con sistemas de ventas e inventarios, lo cual es una razon valida.

**Debilidades:**
- **La justificacion del diseno es superficial** (-3 pts): "Identificamos lo esencial y poco a poco unimos cabos" no es una justificacion tecnica. No mencionan trade-offs, decisiones especificas, alternativas consideradas, ni por que eligieron cierta estructura sobre otra.
- **No mencionan decisiones no obvias** (-1 pt): No explican por que separaron Envio y Pedido, por que eligieron producto_almacen como tabla puente, ni como manejan la logica de rutas con multiples pedidos.
- La respuesta es muy breve y carece de profundidad tecnica. Se esperaria mencion de normalizacion, escalabilidad, o manejo de estados.

---

## PREGUNTAS DE SEGUIMIENTO PARA DEFENSA

──────────────────────────────────────────────────────────────

### 1. [COMPRENSION]
**Pregunta:** En su diagrama, la tabla `producto_almacen` conecta Producto con Almacen. Expliquen que tipo de relacion modela esta tabla y por que fue necesario crearla en lugar de simplemente agregar un campo `id_almacen` en la tabla Producto.

**Respuesta esperada:** La tabla `producto_almacen` modela una relacion muchos-a-muchos (N:N) entre Producto y Almacen, ya que un mismo producto puede estar en multiples almacenes y un almacen puede tener multiples productos. Si solo se pusiera un `id_almacen` en Producto, cada producto solo podria estar en un almacen, lo cual no refleja la realidad de una distribuidora con multiples puntos de almacenamiento. Ademas, la tabla puente permite registrar informacion adicional como `hora_entrada` para rastrear movimientos de inventario.

### 2. [FALENCIAS]
**Pregunta:** Su diseno no incluye una entidad separada para "Incidencias" de entrega. El caso requiere manejar entregas con y sin incidencias. Con su diseno actual (solo `cantidad_rechazada` en detalles), que tipo de informacion sobre incidencias se pierde y como afecta esto a los reportes operativos?

**Respuesta esperada:** Con solo un campo `cantidad_rechazada`, se pierde el tipo de incidencia (producto danado, entrega incorrecta, rechazo por cliente, etc.), la descripcion detallada del problema, la fecha/hora especifica de la incidencia, el responsable del registro, y las acciones correctivas tomadas. Esto impide generar reportes por tipo de incidencia, analizar patrones de problemas, o implementar procesos de mejora continua. Una tabla separada de Incidencias con campos como tipo, descripcion, gravedad, y estado de resolucion seria mas apropiada.

### 3. [MEJORA]
**Pregunta:** Si quisieran agregar la funcionalidad de que un vehiculo no pueda ser asignado a una nueva ruta mientras su estado sea "en_ruta", como modificarian su diseno? Que restricciones o triggers necesitarian?

**Respuesta esperada:** Se podria implementar de varias formas: (1) Un CHECK constraint o TRIGGER que antes de insertar en la tabla Ruta verifique que el vehiculo referenciado tenga estado = 'disponible' en la tabla Camioneta. (2) Un trigger AFTER INSERT en Ruta que automaticamente cambie el estado del vehiculo a 'en_ruta', y un trigger AFTER UPDATE que cuando la ruta se complete cambie el estado a 'disponible'. (3) Una restriccion UNIQUE parcial que impida que un vehiculo tenga mas de una ruta activa simultaneamente. La solucion mas robusta combinaria un CHECK en estados validos con triggers para mantener la consistencia.

### 4. [DECISION]
**Pregunta:** En su modelo, Pedido tiene un campo `id_ruta` (FK), lo que implica que un pedido se asigna a una ruta. Pero tambien podrian haber creado una tabla puente `Pedido_Ruta` para la relacion N:N. Por que eligieron una FK directa? Que limitacion tiene este enfoque?

**Respuesta esperada:** Con la FK directa `id_ruta` en Pedido, cada pedido solo puede pertenecer a una ruta, lo cual simplifica el modelo. Sin embargo, esto impide que un pedido que no fue entregado en una ruta sea reasignado a otra ruta en un segundo intento. Una tabla puente `Pedido_Ruta` permitiria registrar multiples asignaciones a rutas (con historial), manejar re-intentos de entrega, y almacenar el orden de entrega dentro de la ruta. La limitacion del enfoque actual es que si una entrega falla, no se puede rastrear el historial de intentos.

### 5. [APLICACION]
**Pregunta:** Un gerente de la distribuidora necesita saber cuales proveedores han tenido el mayor porcentaje de productos rechazados en los ultimos 3 meses. Escriban en pseudocodigo o SQL como obtendrian esa informacion usando su esquema actual.

**Respuesta esperada:** Se necesitaria un query que junte Proveedor -> Producto (via id_proveedor) -> Pedido_detalles (via id_producto), sume las cantidades totales entregadas y las cantidades rechazadas por proveedor, calcule el porcentaje de rechazo, filtre por fecha de los ultimos 3 meses, y ordene descendentemente. Algo como:
```sql
SELECT prov.nombre,
       SUM(pd.cantidad) AS total_entregado,
       SUM(pd.cantidad_rechazada) AS total_rechazado,
       (SUM(pd.cantidad_rechazada) * 100.0 / NULLIF(SUM(pd.cantidad), 0)) AS pct_rechazo
FROM Proveedor prov
JOIN Producto prod ON prov.id = prod.id_proveedor
JOIN Pedido_detalles pd ON prod.id = pd.id_producto
JOIN Pedido p ON pd.id_pedido = p.id
WHERE p.fecha_creacion >= CURRENT_DATE - INTERVAL '3 months'
GROUP BY prov.id, prov.nombre
ORDER BY pct_rechazo DESC;
```

═══════════════════════════════════════════════════════════════

## OBSERVACIONES ADICIONALES

1. **Cantidad y calidad del trabajo**: El equipo entrego un volumen significativo de trabajo con 12 tablas, restricciones para todas las tablas, 6 queries SQL y 5 VIEWS. Esto demuestra esfuerzo y compromiso con el examen.

2. **Fortaleza notable en VIEWS**: Las VIEWS son el punto mas fuerte del trabajo. Demuestran buen dominio de SQL avanzado con CASE, COALESCE, NULLIF, HAVING, y calculos complejos como dias de cobertura y tasas de exito.

3. **Area de mejora principal**: El diagrama ER carece de cardinalidades explicitas y la nomenclatura es inconsistente entre el diagrama y las restricciones. Para futuros trabajos, asegurarse de que el diagrama y el documento usen exactamente los mismos nombres de tablas y campos.

4. **Justificacion debil**: La seccion de preguntas de justificacion es la mas debil. Se recomienda elaborar mas sobre decisiones tecnicas especificas, trade-offs considerados, y alternativas descartadas.

5. **Nota sobre dialecto SQL**: Se mezclan funciones de MySQL (DATE_SUB) y PostgreSQL (SERIAL, DATE_TRUNC). Se recomienda elegir un dialecto y ser consistente.

═══════════════════════════════════════════════════════════════
