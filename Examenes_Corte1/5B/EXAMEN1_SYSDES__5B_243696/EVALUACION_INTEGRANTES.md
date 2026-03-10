# EVALUACION DE EXAMEN PARCIAL - BASE DE DATOS AVANZADA

===================================================================
EVALUACION: EXAMEN1_SYSDES__5B_243696
Caso: 3-A - Logistica de Distribucion Regional
Integrantes: 3 (Yael Betanzos Jimenez 243678, Jose Maria Moreno Perez 243752, Mishell Prado Gordillos 243696)
===================================================================

## ALERTA: ENTREGA DUPLICADA

**NOTA IMPORTANTE**: Los archivos de esta carpeta son identicos byte a byte a los de las carpetas `EXAMEN1_SYSDES__5B_243678` y `EXAMEN1_SYSDES__5B_243752` (mismo tamano: 24,953 bytes para el diagrama ER y 196,697 bytes para el documento). Esto corresponde a que los tres integrantes del equipo subieron cada uno una copia identica. No se considera plagio, sino entrega multiple del mismo equipo. La calificacion aplica por igual a los tres integrantes.

---

## RESUMEN DE PUNTUACION

| Seccion | Puntos Obtenidos | Puntos Maximos | Porcentaje |
|---------|------------------|----------------|------------|
| Modelo ER + Esquema Relacional | 19/30 | 30 | 63.3% |
| Restricciones | 11/20 | 20 | 55.0% |
| Queries SQL | 18/25 | 25 | 72.0% |
| VIEWS | 12/15 | 15 | 80.0% |
| Justificacion de Diseno | 5/10 | 10 | 50.0% |
| **TOTAL** | **65/100** | **100** | **65.0%** |

### Calificacion Final (este evaluador): 7.0 / 10

## PUNTUACION RECONCILIADA (Escala Lineal + Rangos)

> **Nota del Docente:** Este equipo fue evaluado por 3 evaluadores distintos (carpetas 243678, 243696, 243752) con puntuaciones de 72, 65 y 58. Se aplica promedio lineal y luego rangos.
>
> **Promedio lineal:** (72 + 65 + 58) / 3 = **65/100**
> **Rango aplicado:** 60-69 = **Calificacion: 7.0/10**

### **CALIFICACION RECONCILIADA: 7.0/10**
### **PUNTUACION RECONCILIADA: 65/100**
### Porcentaje del 15% de la Calificacion Final: 9.75%

---

## RETROALIMENTACION DETALLADA

### 1. Modelo ER + Esquema Relacional (19/30)

**Puntuacion desglosada:**
- Identificacion de entidades principales: 5/8
- Cardinalidades correctas: 4/6
- Claves primarias definidas: 4/5
- Claves foraneas correctas: 3/5
- Normalizacion: 1/3
- Tablas puente para N-N: 2/3

**Fortalezas:**
- Se identifican 12 entidades razonables para el caso de logistica: Proveedores, Envio, Envio_detalles, Comprador, Pedido, Pedido_detalles, Producto, Almacen, Conductor, Camioneta, producto_almacen, Ruta.
- La tabla `producto_almacen` funciona como tabla puente para la relacion N-N entre Producto y Almacen, lo cual es correcto.
- La tabla `Pedido_detalles` actua como tabla puente entre Pedido y Producto.
- El diagrama UML esta razonablemente bien estructurado con claves primarias y foraneas senaladas.

**Debilidades:**
- **Falta la entidad "Comercios"** con zona geografica. Se usa "Comprador" con solo id, ubicacion, nombre, lo cual es insuficiente para el caso que requiere comercios en 3 estados con zonas geograficas diferenciadas. (-2 pts por entidad principal faltante/insuficiente)
- **No hay tabla de Categorias** para los productos, lo cual es requerido por el caso (categorias de producto con precios de compra/venta). (-2 pts)
- La tabla Producto tiene un campo `id_productoAlmace (FK)` que crea una dependencia circular innecesaria con producto_almacen. El producto no deberia depender del almacen directamente; esa relacion ya esta en producto_almacen.
- **El campo `inventario` en la tabla Producto** es redundante dado que ya existe la tabla producto_almacen que deberia manejar el stock por almacen. Esto viola normalizacion basica. (-3 pts normalizacion)
- No se muestran cardinalidades explicitas en el diagrama (flechas sin etiquetas de 1:N, N:N).
- La tabla Envio tiene `id_compradorFK` lo cual confunde conceptualmente: en el caso 3-A, los envios van HACIA los comercios, no desde los compradores. La semantica esta invertida respecto al caso.
- Falta un campo `id_producto` en `Pedido_detalles` como FK explicita a Producto (tiene un campo `producto` generico).
- La relacion Proveedor-Producto es 1-N (producto tiene `id_proveedor`), pero el caso sugiere que un producto puede venir de multiples proveedores (N-N).

### 2. Restricciones (11/20)

**Puntuacion desglosada:**
- NOT NULL apropiados: 3/4
- UNIQUE constraints: 2/4
- CHECK constraints: 2/4
- Integridad referencial (FK): 2/4
- Restricciones de negocio: 2/4

**Fortalezas:**
- Se definen restricciones NOT NULL para campos criticos en la mayoria de las tablas (RFC, ubicacion, nombre, estado, etc.).
- Se incluye UNIQUE para RFC de proveedores.
- Se incluyen CHECK para `cantidad > 0` en detalles de envio y pedido, y `capacidad > 0.00` en camioneta.
- Todas las tablas tienen SERIAL PRIMARY KEY definido.

**Debilidades:**
- **Solo se define UNIQUE para Proveedores.RFC**. Faltan UNIQUE para: placas de camioneta, licencia de conductor, combinaciones unicas en tablas puente.
- **Faltan CHECK constraints criticos**: validacion de estados (estatus de pedido, estado de camioneta), validacion de fechas coherentes, validacion de que subtotal >= 0.
- **No se especifican acciones ON DELETE/ON UPDATE** para las claves foraneas. No hay mencion de RESTRICT, CASCADE, o SET NULL.
- **Faltan restricciones de negocio** identificadas para el caso: un conductor no deberia estar en dos rutas simultaneas, un vehiculo en mantenimiento no puede tener ruta asignada.
- Para un equipo de 3, se esperan al menos 10 restricciones. Se presentan aproximadamente 7-8 restricciones significativas, lo cual es insuficiente.
- La tabla ALMACEN tiene UBICACION y NOMBRE como VARCHAR sin NOT NULL, lo cual permitiria almacenes sin nombre ni ubicacion.

### 3. Queries SQL (18/25)

**Puntuacion desglosada:**
- Sintaxis correcta: 4/5
- JOINs apropiados: 6/8
- Agregaciones: 4/5
- GROUP BY / HAVING: 2/4
- Cobertura de queries requeridas: 2/3

**Fortalezas:**
- Se presentan 6 queries, cubriendo la mayoria de los requerimientos del caso.
- Query 1 (Pedidos confirmados sin ruta): Uso correcto de JOIN y WHERE con IS NULL para detectar pedidos sin asignar.
- Query 2 (Peso vs capacidad): Excelente uso de COALESCE con SUM, LEFT JOINs multiples, y GROUP BY.
- Query 3 (Entradas por proveedor): Buen uso de COUNT y SUM con GROUP BY multiple.
- Query 4 (Rutas con incidencias): Uso avanzado de SUM(CASE WHEN...) para contar incidencias, con multiple JOINs.
- Query 6 (Pedido mas reciente por comercio): Uso correcto de subquery correlacionada con MAX.
- Buena comprension general de JOINs y agregaciones.

**Debilidades:**
- Query 5 (Valor inventario por categoria): **No agrupa por categoria** como indica el titulo. Solo lista productos individuales sin GROUP BY, ni JOIN a una tabla de categorias (que no existe en su modelo). La query no cumple con lo solicitado.
- **No se usa HAVING en ninguna query**. El caso requiere filtrado de grupos, y esto es un elemento evaluable explicito.
- Query 1 usa `p.id_ruta IS NULL` pero en el diagrama la Ruta es una entidad separada sin FK directa en Pedido (no hay campo id_ruta en la tabla Pedido del diagrama). Inconsistencia con el modelo.
- Query 3 usa MySQL `DATE_SUB(CURDATE(), INTERVAL 1 MONTH)` mientras que las VIEWS usan PostgreSQL `DATE_TRUNC`. Inconsistencia de DBMS.
- Falta la query "Pedido mas reciente por comercio" con nombre correcto (usa "Comprador" en lugar de "Comercio").

### 4. VIEWS (12/15)

**Puntuacion desglosada:**
- Sintaxis CREATE VIEW: 3/3
- Agregaciones correctas: 3/4
- Uso de HAVING: 2/3
- Uso de CASE/COALESCE: 3/3
- Coherencia con esquema: 1/2

**Fortalezas:**
- Se presentan 5 VIEWS completas, cumpliendo el requisito para equipo de 3.
- **View 1 (Pedidos por zona)**: Buen uso de SUM(CASE WHEN...) para calcular entregas exitosas e incidencias, con tasa de exito calculada.
- **View 2 (Productividad conductores)**: Excelente uso de NULLIF para division segura, CASE para clasificacion de rendimiento, COUNT(DISTINCT) para metricas precisas.
- **View 3 (Inventario critico)**: Uso sofisticado de COALESCE para manejar cero ventas, CASE para clasificacion de cobertura, y HAVING para filtrado. Es la view mas completa.
- **View 4 (Rentabilidad proveedor)**: Calculo correcto de margen de ganancia con JOINs multiples.
- **View 5 (Utilizacion flota)**: LEFT JOIN correcto para incluir vehiculos sin rutas, CASE con rangos justificados.
- Sintaxis CREATE VIEW / CREATE OR REPLACE VIEW correcta en todas.
- Uso consistente de CASE y COALESCE.

**Debilidades:**
- View 1 agrupa por `c.ubicacion` como zona, pero la tabla Comprador solo tiene un campo generico de ubicacion, no una zona geografica propiamente definida.
- View 2 clasifica por `COUNT(DISTINCT p.id) > 50` en el SELECT pero el GROUP BY es por `con.id, con.nombre`. Los umbrales (50 y 20) no se justifican.
- View 3 usa `prod.inventario` directamente de la tabla Producto, pero en un diseno correcto el inventario deberia consultarse desde `producto_almacen`.
- View 5 usa `DATE_TRUNC('month', CURRENT_DATE)` que es sintaxis PostgreSQL, mientras las queries usan sintaxis MySQL. Inconsistencia.
- View 4 no usa COALESCE para manejar proveedores sin ventas.

### 5. Justificacion de Diseno (5/10)

**Puntuacion desglosada:**
- Por que escogieron ese caso: 3/4
- Por que lo disenaron asi: 2/6

**Fortalezas:**
- La justificacion del caso es razonable: experiencia previa con sistemas de ventas e inventarios.
- Se reconoce honestamente que "es posible que algunas cosas no se consideraron".

**Debilidades:**
- La respuesta a "por que lo disenaron asi" es **muy vaga y superficial**: "identificamos lo que consideramos esencial y poco a poco unimos cabos". No menciona ninguna decision de diseno especifica.
- **No se mencionan trade-offs** considerados (ej. por que una tabla de movimientos vs dos tablas separadas, por que Proveedor-Producto es 1-N en vez de N-N).
- No se justifica la estructura de envios separados de pedidos.
- No se menciona por que se uso SERIAL vs otro tipo de PK.
- La respuesta da la impresion de que el diseno se hizo sin reflexion profunda sobre alternativas.

---

## PREGUNTAS DE SEGUIMIENTO PARA DEFENSA

### 1. [COMPRENSION]
**Pregunta:** En su diagrama, la tabla `producto_almacen` tiene los campos id_producto e id_almacen. Expliquen que tipo de relacion modela esta tabla, cual es su cardinalidad, y por que es necesaria en lugar de simplemente poner un campo id_almacen en la tabla Producto.

**Respuesta esperada:** La tabla producto_almacen es una tabla puente que modela una relacion muchos-a-muchos (N-N) entre Producto y Almacen: un producto puede estar en multiples almacenes y un almacen puede contener multiples productos. Si solo se pusiera id_almacen en Producto, cada producto solo podria estar en un almacen. Ademas, permite registrar atributos propios de la relacion como hora_entrada.

### 2. [FALENCIAS]
**Pregunta:** Su tabla Producto tiene un campo `inventario` con el stock total, pero tambien tienen la tabla `producto_almacen` que registra productos por almacen. Si el sistema crece a multiples almacenes, que problema de consistencia de datos surgiria? Como podria el campo `inventario` quedar desactualizado?

**Respuesta esperada:** Hay redundancia de datos. El campo `inventario` en Producto deberia ser calculado como la suma de las cantidades en `producto_almacen`. Si se actualiza el stock en producto_almacen sin actualizar Producto.inventario (o viceversa), los datos quedan inconsistentes. La solucion seria eliminar el campo inventario de Producto y calcularlo mediante una VIEW o query que sume desde producto_almacen.

### 3. [MEJORA]
**Pregunta:** Su modelo no incluye una tabla de Categorias para los productos ni una zona geografica estructurada para los comercios/compradores. Si el negocio necesitara generar reportes de ventas por categoria de producto y por zona geografica (estado, municipio), que tablas agregarian y como las conectarian al modelo existente?

**Respuesta esperada:** Se agregaria una tabla `Categorias` con id, nombre, descripcion, y un campo `id_categoria` como FK en la tabla Producto. Para zonas geograficas, se podria agregar una tabla `Zonas` o `Municipios` con campos estado, municipio, zona, y un campo `id_zona` como FK en la tabla Comprador/Comercio. Alternativamente, se podrian agregar campos estado y municipio directamente en Comprador.

### 4. [DECISION]
**Pregunta:** En su modelo, la relacion entre Proveedor y Producto es 1-N (cada producto tiene un solo id_proveedor). Sin embargo, en la realidad, un mismo producto puede ser suministrado por multiples proveedores con diferentes precios y tiempos de entrega. Consideraron modelar esto como una relacion N-N con una tabla puente `proveedor_producto`? Por que decidieron no hacerlo?

**Respuesta esperada:** El estudiante deberia reconocer que una relacion N-N seria mas apropiada para el escenario real. Una tabla puente `proveedor_producto` permitiria registrar precio_proveedor, tiempo_entrega, y proveedor_principal por cada combinacion. La decision de 1-N simplifica el modelo pero limita la flexibilidad. Si no pueden justificar la decision, indica falta de analisis del dominio.

### 5. [APLICACION]
**Pregunta:** Muestren como su diseno resuelve el siguiente escenario: un conductor sale en una camioneta con 3 pedidos para diferentes compradores, pero en una entrega se danan 5 unidades de un producto. Que tablas se involucran y como se registra la incidencia?

**Respuesta esperada:** Se involucran: Conductor, Camioneta, Ruta (asigna conductor y camioneta), Pedido (3 registros vinculados a la ruta), Pedido_detalles (detalle de productos por pedido). La incidencia se registra en el campo `cantidad_rechazada` de Pedido_detalles (o Envio_detalles). Sin embargo, deberian notar que su modelo no tiene una entidad de "Entregas" separada ni un campo especifico para "danos" vs "rechazos", lo cual limita el detalle de las incidencias.

---

## OBSERVACIONES ADICIONALES

1. **Entrega triplicada**: Los mismos archivos exactos aparecen en tres carpetas (243678, 243696, 243752). Cada integrante subio una copia identica. La calificacion es compartida.

2. **Inconsistencia de DBMS**: Las queries usan sintaxis MySQL (DATE_SUB, CURDATE) mientras las VIEWS usan sintaxis PostgreSQL (DATE_TRUNC, CURRENT_DATE). Esto sugiere que se copiaron de diferentes fuentes sin unificar.

3. **No hay VIEWS de Rentabilidad por proveedor que calcule margen real**: La View 4 calcula margen pero referencia `pd.precio_venta` que no existe en el esquema de Pedido_detalles del diagrama.

4. **Coherencia general**: El documento es legible, bien estructurado, y demuestra comprension basica de SQL. Sin embargo, el modelo ER tiene deficiencias conceptuales importantes para un equipo de 3 integrantes con el caso mas complejo (3-A).

5. **Rubrica del estudiante vs rubrica oficial**: El documento incluye una rubrica propia (pag. 2) con pesos diferentes a la rubrica oficial del curso. Esto no afecta la evaluacion pero sugiere que usaron un formato proporcionado distinto.

6. **Calidad relativa**: Para ser un equipo de 3 con el caso 3-A, el trabajo cumple parcialmente. Las VIEWS son el punto mas fuerte; el modelo ER y las justificaciones son los puntos mas debiles.
