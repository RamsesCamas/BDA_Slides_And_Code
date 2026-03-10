# Evaluacion: 243752 - 243678 - 243696
## Caso: 3-A - Logistica de Distribucion Regional
### Integrantes: 3 (Yael Betanzos Jimenez 243678, Jose Maria Moreno Perez 243752, Mishell Prado Gordillos 243696)

**BANDERA**: Esta carpeta comparte nombres de archivo identicos con las carpetas de los equipos en folders 5 y 7 evaluados por el Agente A. Verificar si se trata del mismo equipo para evitar doble calificacion.

---

### Resumen de Puntuacion

| Seccion | Puntos Obtenidos | Puntos Maximos | Porcentaje |
|---------|------------------|----------------|------------|
| Modelo ER + Esquema | 18 | 30 | 60% |
| Restricciones | 10 | 20 | 50% |
| Queries SQL | 16 | 25 | 64% |
| VIEWS | 10 | 15 | 67% |
| Justificacion | 4 | 10 | 40% |
| **TOTAL** | **58** | **100** | **58%** |

### Calificacion Final (este evaluador): 5.8 / 10

## PUNTUACION RECONCILIADA (Escala Lineal + Rangos)

> **Nota del Docente:** Este equipo fue evaluado por 3 evaluadores distintos (carpetas 243678, 243696, 243752) con puntuaciones de 72, 65 y 58. Se aplica promedio lineal y luego rangos.
>
> **Promedio lineal:** (72 + 65 + 58) / 3 = **65/100**
> **Rango aplicado:** 60-69 = **Calificacion: 7.0/10**

### **CALIFICACION RECONCILIADA: 7.0/10**
### **PUNTUACION RECONCILIADA: 65/100**
### Porcentaje Final: 9.75% de 15%

---

### Retroalimentacion por Seccion

#### Modelo ER + Esquema Relacional
- **Fortalezas**: El diagrama ER (notacion UML) muestra 12 tablas: Proveedores, Comprador, Pedido, Pedido_detalles, Envio, Envio_detalles, Producto, producto_almacen, Almacen, Camioneta, Conductor, Ruta. Incluye una tabla producto_almacen que rastrea productos por almacen con hora_entrada, y una separacion Envio/Envio_detalles que actua como tabla puente.
- **Debilidades**: Problemas significativos en el esquema:
  - No existe tabla de Zonas Geograficas, que es fundamental para el caso de distribucion en 3 estados (-2 pts).
  - No existe tabla de Categorias de productos (-2 pts).
  - Se usa "Comprador" en lugar de "Comercio", lo cual es una simplificacion que pierde informacion del contexto comercial.
  - La tabla "Pedido" parece representar ordenes de compra al proveedor (tiene id_proveedor y id_almacen), mientras que "Envio" representa los pedidos de los compradores. Esta inversion de nomenclatura es confusa (-2 pts).
  - No hay tabla puente explicita para la relacion N-N entre Pedido y Ruta. El campo id_ruta esta directamente en la tabla Pedido (1-N), lo que no permite asignar multiples pedidos a una ruta de manera flexible (-3 pts).
  - El Conductor esta vinculado directamente a Camioneta (id_conductor en Camioneta) en lugar de a Ruta, lo que implica que un conductor siempre maneja la misma camioneta (-1 pt).
  - Falta tabla de entregas/incidencias como entidad separada. Las incidencias se manejan via cantidad_rechazada en Envio_detalles, lo cual es limitado (-2 pts).

#### Restricciones
- **Fortalezas**: Se listan restricciones tabla por tabla con buena organizacion. Incluye SERIAL PRIMARY KEY, NOT NULL, UNIQUE (RFC en Proveedores), CHECK (cantidad > 0 en Pedido_detalles y Envio_detalles, capacidad > 0 en Camioneta), y VARCHAR con limites especificos. 10 tablas cubiertas con restricciones basicas.
- **Debilidades**: Las restricciones son mayoritariamente PRIMARY KEY y NOT NULL, que son las mas basicas. Falta:
  - No se especifican restricciones CHECK para estados validos (-2 pts).
  - No se especifican restricciones de integridad referencial ON DELETE/ON UPDATE (-2 pts).
  - No hay CHECK para precios positivos, formato de RFC, o validacion de fechas (-2 pts).
  - No hay UNIQUE en placas de camionetas ni licencias de conductores (-2 pts).
  - Solo 6 restricciones son realmente significativas (de las 10 requeridas para equipo de 3) (-2 pts).

#### Queries SQL
- **Fortalezas**: 6 queries presentadas cubriendo los temas requeridos: pedidos confirmados sin ruta, peso vs capacidad, entradas por proveedor, rutas con incidencias, valor de inventario, y pedido mas reciente por comercio. Query 2 usa COALESCE correctamente. Query 4 usa CASE y COUNT(DISTINCT). Query 6 usa subconsulta correlacionada con MAX.
- **Debilidades**:
  - Se usa sintaxis MySQL (DATE_SUB, CURDATE) en lugar de PostgreSQL, que es el DBMS esperado segun el contexto del curso (-2 pts).
  - Query 5 (valor de inventario por categoria) no agrupa por categoria sino que lista productos individuales. Falta GROUP BY y no se usa JOIN con una tabla de categorias que no existe en el esquema (-3 pts).
  - Query 1 busca p.id_ruta IS NULL en la tabla Pedido, pero en el esquema no hay un campo id_ruta claro en Pedido (esta en Envio). Inconsistencia entre queries y esquema (-2 pts).
  - Query 3 usa DATE_SUB que no es sintaxis PostgreSQL estandar (-1 pt).
  - Algunas queries referencian campos que no existen claramente en el diagrama ER (p.estatus, prod.costo_unitario) (-1 pt).

#### VIEWS
- **Fortalezas**: 5 VIEWS presentadas con CREATE VIEW o CREATE OR REPLACE VIEW correctamente. View 1 (pedidos por zona) usa SUM con CASE y calcula Tasa_Exito. View 2 (productividad conductores) usa COUNT(DISTINCT), NULLIF para division por cero, y CASE para clasificacion. View 3 (inventario critico) usa COALESCE, CASE y HAVING. View 4 (rentabilidad proveedor) calcula margen con SUM de costos vs ventas. View 5 (utilizacion flota) usa LEFT JOIN, CASE y DATE_TRUNC.
- **Debilidades**:
  - View 1 agrupa por c.ubicacion (campo de Comprador) en lugar de por zona geografica, ya que no hay tabla de zonas (-1 pt).
  - View 3 asigna 999 como dias de cobertura cuando no hay ventas; seria mas claro usar NULL o una etiqueta. Ademas, el HAVING filtra <15 dias, lo que excluiria los productos con 999 (sin ventas), lo cual es correcto pero podria perder productos estancados (-1 pt).
  - View 4 no calcula margen porcentual, solo margen absoluto (-1 pt).
  - Las views referencian tablas y campos que no siempre coinciden con el diagrama ER (ej. prod.inventario, pd.precio_venta no aparecen en el diagrama) (-2 pts).

#### Justificacion de Diseno
- **Fortalezas**: Se responden ambas preguntas. La respuesta a "por que este caso" menciona experiencia previa con sistemas de ventas e inventarios.
- **Debilidades**:
  - La justificacion de "por que lo disenaron asi" es vaga y superficial: "identificamos lo que consideramos esencial y poco a poco unimos cabos". No menciona decisiones tecnicas especificas, trade-offs considerados, ni alternativas descartadas (-3 pts).
  - No hay mencion de normalizacion, relaciones N-N, ni justificacion de la estructura de tablas elegida (-2 pts).
  - La respuesta reconoce que "es posible que algunas cosas no se consideraron", lo cual demuestra cierta honestidad pero no suple la falta de analisis tecnico (-1 pt).

---

### Preguntas de Seguimiento

1. **[COMPRENSION]**
   - Pregunta: En su diagrama, "Pedido" tiene id_proveedor y "Envio" tiene id_comprador. Expliquen la diferencia entre estas dos tablas y como fluye un producto desde el proveedor hasta el comprador final en su modelo.
   - Respuesta esperada: Deben explicar que "Pedido" representa la orden de compra al proveedor (entrada al almacen) y "Envio" representa el despacho al comprador (salida del almacen). El flujo seria: Proveedor -> Pedido -> producto_almacen -> Envio -> Comprador. Deben poder articular claramente esta distincion.

2. **[FALENCIAS]**
   - Pregunta: Su modelo no tiene una tabla de Zonas Geograficas. Si la distribuidora necesita generar un reporte de pedidos por estado (Chiapas, Tabasco, Oaxaca), como lo harian con su modelo actual?
   - Respuesta esperada: Deben reconocer que tendrian que filtrar por el campo "ubicacion" del Comprador, lo cual no es estructurado ni normalizado. La solucion correcta seria agregar una tabla Zona_Geografica con (id_zona, nombre, estado) y vincularla a Comprador con una FK.

3. **[MEJORA]**
   - Pregunta: Su tabla Camioneta tiene id_conductor como campo directo, lo que significa que un conductor siempre esta asignado a la misma camioneta. Si un conductor se enferma y necesitan asignar su camioneta a otro conductor para el dia, como lo manejarian?
   - Respuesta esperada: Deberian reconocer que el diseno actual no lo permite facilmente. La mejora seria mover la asignacion conductor-vehiculo a la tabla Ruta (que ya tiene id_camioneta e id_conductor), eliminando id_conductor de Camioneta. Asi cada ruta puede tener cualquier combinacion de conductor y camioneta.

4. **[DECISION]**
   - Pregunta: Ustedes eligieron usar DATE_SUB y CURDATE() en sus queries SQL, que son funciones de MySQL. El curso se centra en PostgreSQL. Pueden explicar como convertirian su query de "entradas del mes por proveedor" a sintaxis PostgreSQL?
   - Respuesta esperada: Deben poder convertir DATE_SUB(CURDATE(), INTERVAL 1 MONTH) a CURRENT_DATE - INTERVAL '1 month'. Esto evaluaria si entienden las diferencias entre dialectos SQL.

5. **[APLICACION]**
   - Pregunta: Usando su view vw_inventario_critico, si un producto tiene inventario = 100 y ventas_mensuales (SUM de cantidad en pedido_detalles) = 0, que resultado mostraria la vista? Y si tiene inventario = 30 y ventas_mensuales = 60?
   - Respuesta esperada: Caso 1: COALESCE(0, 0) = 0, entra en WHEN = 0 THEN 999, dias_Cobertura = 999, y como 999 no es < 15, el producto NO apareceria en la vista (el HAVING lo excluye). Caso 2: ventas_mensuales = 60, 60/30 = 2 unidades diarias, 30/2 = 15 dias, como 15 no es < 15 estrictamente, tampoco apareceria. Con 29 de inventario: 29/2 = 14.5, que SI es < 15 y apareceria.

---

### Observaciones Adicionales
Este trabajo presenta debilidades significativas en el esquema relacional, con ausencia de tablas clave como Zonas Geograficas y Categorias, y una estructura confusa donde "Pedido" representa ordenes de compra y "Envio" representa despachos al cliente. Las restricciones son basicas (mayoritariamente PRIMARY KEY y NOT NULL). Las queries SQL son funcionales pero usan sintaxis MySQL incorrecta para el contexto del curso y presentan inconsistencias con el esquema. Las VIEWS son aceptables con uso correcto de CASE, COALESCE y NULLIF, pero referencian campos no presentes en el diagrama. La justificacion es la seccion mas debil, con respuestas vagas que no demuestran analisis tecnico profundo. En general, el trabajo cumple parcialmente pero tiene carencias notables en completitud y coherencia interna.
