
# EVALUACION DE EXAMEN PARCIAL - BASE DE DATOS AVANZADA

```
===============================================================
EVALUACION: EXAMEN1_SYSDES__5B_243751
Caso: 3-A - Logistica de Distribucion Regional
Integrantes: 3
  - Espinoza Mendoza Hector Isaac - 243751
  - Moreno Zuniga Jesel - 243692
  - Arturo Yion Jaime - 243602
===============================================================
```

> **NOTA**: Esta evaluacion reemplaza la version provisional anterior que solo pudo evaluar el diagrama. Ahora se evaluan AMBOS archivos: "Diagramas.pdf" y "DOCUMENTO DE DISENO_ SISTEMA DE LOGISTICA DE DISTRIBUCION REGIONAL.pdf" (35 paginas).

> **BANDERA**: Esta carpeta comparte contenido identico con las carpetas 243692 y 243602. Los tres integrantes del equipo entregaron el mismo trabajo. Calificacion compartida.

---

## PUNTUACION POR SECCION

```
--------------------------------------------------------------
Modelo ER + Esquema:    27/30
Restricciones:          19/20
Queries SQL:            15/25
VIEWS:                  13/15
Justificacion:           9/10
--------------------------------------------------------------
TOTAL:                  83/100
CALIFICACION (este evaluador): 9/10
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

### [Modelo ER + Esquema Relacional] -- 27/30

**Fortalezas:**
- Excelente esquema relacional en dbdiagram.io con 14 tablas bien definidas: CATEGORIA, PROVEEDOR, PRODUCTO, ENTRADA_ALMACEN, DETALLE_ENTRADA, ZONA_GEOGRAFICA, COMERCIO, PEDIDO, DETALLE_PEDIDO, VEHICULO, CONDUCTOR, RUTA, PEDIDO_RUTA, ENTREGA. Supera ampliamente el minimo de 9-12 tablas para equipo de 3.
- Tres tablas puente correctamente implementadas: DETALLE_ENTRADA (Entrada-Producto N:N), DETALLE_PEDIDO (Pedido-Producto N:N), PEDIDO_RUTA (Pedido-Ruta N:N con campo orden_entrega). Supera el requisito de 2 relaciones N:N.
- Doble representacion diagramatica: esquema relacional detallado (dbdiagram.io, paginas 1-2) + diagrama ER en notacion Chen (pagina 3). Demuestra dominio de ambas notaciones.
- Claves primarias correctamente identificadas en todas las tablas con iconos de llave en el diagrama.
- Claves foraneas bien definidas y marcadas en el esquema.
- Restricciones NOT NULL (NN) claramente marcadas en el diagrama para campos criticos en todas las tablas.
- El documento incluye CREATE TABLE completos para las 14 tablas con tipos de datos apropiados: DECIMAL(10,2) para precios y cantidades, VARCHAR con longitudes razonables, DATETIME/DATE diferenciados segun necesidad.
- Cardinalidades correctas en el diagrama Chen y justificadas en tabla resumen (pagina 10-11).
- El campo orden_entrega en PEDIDO_RUTA y los campos firma_digital, incidencia, cantidad_danada en ENTREGA demuestran comprension profunda del dominio logistico.
- ENTREGA correctamente identificada como entidad debil dependiente de PEDIDO.
- Cada tabla incluye justificaciones detalladas de por que existe como tabla separada y por que se eligieron los atributos.

**Debilidades:**
- La tabla ENTREGA usa id_pedido como PK (relacion 1:1 con PEDIDO), lo que impide registrar multiples intentos de entrega. Un id_entrega propio seria mas flexible. (-1 pt)
- No existe tabla ALMACEN explicita. El stock se maneja a nivel global en PRODUCTO sin diferenciar por ubicacion fisica de almacen. (-1 pt)
- El diagrama del esquema relacional en Diagramas.pdf no muestra el campo precio_venta_historico en DETALLE_PEDIDO ni precio_compra_historico en DETALLE_ENTRADA que si aparecen en el documento de diseno (CREATE TABLE). Hay inconsistencia menor entre diagrama y documento. (-1 pt)

### [Restricciones] -- 19/20

**Fortalezas:**
- **UNIQUE (5 restricciones):** RFC de proveedor, placas de vehiculo, licencia de conductor, nombre de categoria, nombre de zona. Todas con sintaxis correcta (ALTER TABLE ... ADD CONSTRAINT ... UNIQUE) y justificacion individual. Excelente cobertura. (4/4)
- **CHECK (9 restricciones):** Formato de RFC con REGEXP, precios positivos (x2), stock no negativo, cantidades positivas en detalles (x2), estados validos para PEDIDO/VEHICULO/RUTA, unidades de medida validas. Todas con sintaxis correcta y justificaciones claras que referencian el caso de negocio. (4/4)
- **NOT NULL (20+ campos):** Bien seleccionados en campos criticos de todas las tablas. Incluidos directamente en los CREATE TABLE con justificacion general. (4/4)
- **FK e integridad referencial (13 FKs):** Todas las relaciones tienen FOREIGN KEY explicitas. Distinguen inteligentemente entre ON DELETE CASCADE (para detalles huerfanos) y sin CASCADE (para proteger integridad historica como proveedor con productos). (4/4)
- **Reglas de negocio via triggers (3 triggers):**
  - trg_validar_capacidad_vehiculo: Impide que el peso total de una ruta exceda la capacidad del vehiculo.
  - trg_validar_vehiculo_disponible: Impide asignar vehiculos en mantenimiento a rutas (requisito explicito del caso).
  - trg_aumentar_stock / trg_disminuir_stock: Actualizacion automatica de stock al registrar entradas y pedidos.
  Los triggers tienen sintaxis MySQL correcta con DECLARE, SELECT INTO, IF, SIGNAL SQLSTATE.
- Total: 17 restricciones nombradas + 20+ NOT NULL + 13 FK + 3 triggers = supera ampliamente el minimo de 10 restricciones para equipo de 3.
- Tabla resumen excelente (pagina 30) que organiza las restricciones por tipo.

**Debilidades:**
- No se incluye una restriccion para validar que precio_venta > precio_compra en PRODUCTO, lo cual seria una regla de negocio logica para garantizar rentabilidad. (-1 pt)

### [Queries SQL] -- 15/25

**Fortalezas:**
- **Query 1 - Pedidos sin ruta asignada:**
  ```sql
  SELECT p.id_pedido, c.nombre_comercio, p.peso_total
  FROM PEDIDO p
  JOIN COMERCIO c ON p.id_comercio = c.id_comercio
  WHERE p.id_pedido NOT IN (SELECT id_pedido FROM PEDIDO_RUTA);
  ```
  Sintaxis correcta, usa JOIN y subconsulta NOT IN. Util para operaciones diarias. (3/5 sintaxis, parcial en JOINs)

- **Query 2 - Alerta de sobrecarga:**
  ```sql
  SELECT r.id_ruta, v.capacidad_kg, SUM(p.peso_total) as peso_asignado
  FROM RUTA r
  JOIN VEHICULO v ON r.id_vehiculo = v.id_vehiculo
  JOIN PEDIDO_RUTA pr ON r.id_ruta = pr.id_ruta
  JOIN PEDIDO p ON pr.id_pedido = p.id_pedido
  GROUP BY r.id_ruta, v.capacidad_kg
  HAVING SUM(p.peso_total) > v.capacidad_kg * 0.9;
  ```
  Excelente query con multiples JOINs (3 tablas), GROUP BY, HAVING con condicion de negocio (umbral 90%), y SUM. Demuestra comprension avanzada.

**Debilidades:**
- Solo se presentan 2 queries explicitas en la seccion "Queries SQL de Ejemplo". Para un equipo de 3 se esperan al menos 7-8 queries con variedad. (-5 pts por cobertura insuficiente)
- No hay queries con AVG, COUNT independiente, ni subconsultas correlacionadas. (-3 pts en agregaciones)
- No hay queries que demuestren LEFT JOIN, OUTER JOIN u otras variantes. (-2 pts parcial en JOINs)
- Las queries dentro de los triggers (SELECT INTO) y las VIEWS contienen logica SQL adicional, pero no se cuentan como queries independientes ya que estan embebidas en otros objetos.

**Desglose:**
- Sintaxis correcta: 4/5 (las 2 queries son correctas pero son solo 2)
- JOINs apropiados: 5/8 (Query 2 tiene 3 JOINs encadenados, pero falta LEFT JOIN y variedad)
- Agregaciones: 3/5 (SUM presente, falta COUNT, AVG en queries independientes)
- GROUP BY / HAVING: 3/4 (Query 2 los usa bien, pero solo hay un ejemplo)
- Cobertura: 0/3 (2 queries es insuficiente para equipo de 3; se esperan minimo 7)

### [VIEWS] -- 13/15

**Fortalezas:**
- **5 VIEWS presentadas**, cumpliendo exactamente el requisito para equipo de 3:
  1. **vista_resumen_zonas**: LEFT JOIN (ZONA->COMERCIO->PEDIDO), COUNT, SUM con CASE para estados, calculo de tasa_exito con NULLIF para division segura. Excelente.
  2. **vista_productividad_conductores**: JOIN (CONDUCTOR->RUTA->PEDIDO_RUTA), COUNT, CASE con BETWEEN para clasificar productividad (Baja/Normal/Excelente). Bien estructurada.
  3. **vista_inventario_critico**: LEFT JOIN (PRODUCTO->DETALLE_PEDIDO), COALESCE con valor default 0, NULLIF para prevenir division entre cero, calculo de dias_para_agotamiento. Demuestra manejo robusto de nulos.
  4. **vista_rentabilidad_proveedor**: JOIN (PROVEEDOR->PRODUCTO->DETALLE_PEDIDO), SUM con multiplicaciones para calcular total_ventas, total_costo y margen. Usa precio_venta_historico correctamente.
  5. **vista_utilizacion_flota**: LEFT JOIN (VEHICULO->RUTA), COUNT, CASE con BETWEEN para clasificar (Subutilizado/Optimo/Sobrecargado). Correcta.
- **Sintaxis CREATE VIEW**: Correcta en las 5 vistas. (3/3)
- **Agregaciones**: COUNT y SUM usados correctamente en multiples vistas. (4/4)
- **CASE/COALESCE**: CASE usado en 3 vistas (resumen_zonas, productividad, utilizacion), COALESCE en 2 (inventario_critico, resumen_zonas), NULLIF en 2 (inventario_critico, resumen_zonas). Excelente variedad. (3/3)
- **Coherencia con esquema**: Todas las vistas referencian tablas y campos correctos del esquema. (2/2)
- Las descripciones textuales de cada vista explican su proposito gerencial.

**Debilidades:**
- Ninguna de las 5 VIEWS usa HAVING. La clausula HAVING aparece solo en la Query 2 independiente. Para obtener puntaje completo se esperaba HAVING en al menos una vista. (-2 pts)
- La vista_rentabilidad_proveedor referencia pr.nombre_empresa, pero la tabla PROVEEDOR tiene el campo como "nombre", no "nombre_empresa". Error menor de consistencia en nombre de campo. (Nota, no se descuenta adicional porque el campo existe conceptualmente)

**Desglose:**
- Sintaxis CREATE VIEW: 3/3
- Agregaciones correctas: 4/4
- Uso de HAVING: 1/3 (no presente en las VIEWS, aunque si en queries)
- CASE/COALESCE: 3/3
- Coherencia con esquema: 2/2

### [Justificacion de Diseno] -- 9/10

**Fortalezas:**
- **Por que escogieron el caso (Pregunta 1):** Respuesta solida. Mencionan la complejidad arquitectonica (tres flujos de datos entrelazados), el desafio de integridad (logica de estados avanzada con triggers), y lo atractivo del caso para equipo de 3. Demuestran que la eleccion fue deliberada. (4/4)
- **Por que lo disenaron asi (Pregunta 2):** Respuesta excelente y muy bien estructurada en 4 puntos:
  - A. Preservacion de datos historicos: Explican precio_venta_historico en DETALLE_PEDIDO para no corromper contabilidad.
  - B. Uso de entidades debiles: ENTREGA separada de PEDIDO por separacion de responsabilidades, manejo de incidencias, y extensibilidad.
  - C. Automatizacion mediante triggers: Delegan integridad al motor de BD, no a la aplicacion.
  - D. Normalizacion y escalabilidad: Tablas separadas para CATEGORIA y ZONA permiten crecimiento.
  Mencionan trade-offs explicitos (ej: 1:1 en ENTREGA ahora, escalable a 1:N despues). (5/6)

**Debilidades:**
- Podrian haber mencionado las limitaciones reconocidas de su diseno (como la falta de tabla ALMACEN o la restriccion 1:1 en ENTREGA) como trade-offs conscientes en la justificacion. (-1 pt)

---

## PREGUNTAS DE SEGUIMIENTO PARA DEFENSA

```
--------------------------------------------------------------
```

### 1. [COMPRENSION]
**Pregunta:** En su documento mencionan que DETALLE_PEDIDO incluye un campo precio_venta_historico, pero en el diagrama de dbdiagram.io ese campo no aparece y DETALLE_PEDIDO solo tiene id_pedido, id_producto y cantidad. Expliquen esta diferencia: cual es la version final de la tabla y por que es importante ese campo.

**Respuesta esperada:** Deben reconocer la inconsistencia entre el diagrama y el CREATE TABLE del documento. La version correcta deberia ser la del CREATE TABLE (con precio_venta_historico) porque ese campo es critico para preservar el precio al momento de la venta. Sin el, si el precio del producto cambia despues, los reportes financieros (como la vista_rentabilidad_proveedor) calcularian montos incorrectos. Deben demostrar que entienden por que el precio historico es necesario y no basta con consultarlo de la tabla PRODUCTO.

### 2. [FALENCIAS]
**Pregunta:** Su trigger trg_disminuir_stock resta la cantidad del pedido al stock_actual cuando se inserta en DETALLE_PEDIDO. Pero no hay validacion de que el stock sea suficiente antes de restar. Que pasaria si un comercio pide 100 litros de leche pero solo hay 50 en stock? Su CHECK de stock >= 0 lo detendria, pero es eso suficiente o deberian validar antes?

**Respuesta esperada:** Deben reconocer que depender solo del CHECK (stock_actual >= 0) es un enfoque reactivo: el INSERT fallaria con un error de CHECK constraint pero no daria un mensaje claro al usuario. Idealmente, el trigger trg_disminuir_stock deberia incluir una validacion previa (BEFORE INSERT) que verifique stock_actual >= NEW.cantidad y, si no es suficiente, emita un SIGNAL SQLSTATE con un mensaje descriptivo como "Stock insuficiente para el producto X". Esto es un control proactivo vs reactivo.

### 3. [MEJORA]
**Pregunta:** Su seccion de Queries SQL solo incluye 2 consultas de ejemplo. Si tuvieran que agregar 3 queries mas que fueran utiles para el gerente de la distribuidora, cuales serian y que tablas involucran?

**Respuesta esperada:** Deberian proponer queries como: (1) Reporte de ventas mensuales por zona con SUM y GROUP BY sobre PEDIDO, COMERCIO, ZONA_GEOGRAFICA; (2) Conductores con mayor tasa de incidencias usando JOIN entre CONDUCTOR, RUTA, PEDIDO_RUTA, ENTREGA con COUNT y CASE; (3) Productos mas vendidos por categoria usando JOIN entre PRODUCTO, CATEGORIA, DETALLE_PEDIDO con SUM, GROUP BY y ORDER BY. Deben demostrar que pueden disenar queries que cruzan multiples tablas de su esquema.

### 4. [DECISION]
**Pregunta:** En su documento justifican que la relacion PRODUCTO-PROVEEDOR es 1:N (un producto tiene un solo proveedor) en lugar de N:N. Sin embargo, en la realidad un mismo producto podria comprarse a diferentes proveedores con precios distintos. Por que tomaron esta decision y como la cambiarian si fuera necesario?

**Respuesta esperada:** Deben explicar que simplificaron la relacion porque el caso dice "Lacteos del Sur provee leche y queso", sugiriendo un proveedor por producto. Para cambiar a N:N, eliminarian id_proveedor de PRODUCTO y crearian una tabla puente PRODUCTO_PROVEEDOR(id_producto, id_proveedor, precio_compra, es_principal) que permitiria multiples proveedores por producto con precios independientes. Tambien deberian mencionar el impacto en las queries existentes que hacen JOIN directo PRODUCTO-PROVEEDOR.

### 5. [APLICACION]
**Pregunta:** Usando su vista_inventario_critico, el gerente detecta que la leche tiene un dias_para_agotamiento de 3 dias. Describan paso a paso que sucede en la base de datos desde que se decide hacer un pedido al proveedor hasta que la leche esta disponible en el almacen para nuevos pedidos de comercios.

**Respuesta esperada:** Paso 1: Se identifica el proveedor de leche consultando PRODUCTO.id_proveedor. Paso 2: Se crea un registro en ENTRADA_ALMACEN con id_proveedor, fecha_entrada (automatica), usuario_registro y observaciones. Paso 3: Se inserta un registro en DETALLE_ENTRADA con id_entrada, id_producto (leche), cantidad y precio_compra_historico. Paso 4: El trigger trg_aumentar_stock se dispara automaticamente y ejecuta UPDATE PRODUCTO SET stock_actual = stock_actual + NEW.cantidad. Paso 5: El stock_actual de leche se actualiza y la vista_inventario_critico recalculara automaticamente el nuevo dias_para_agotamiento. No se necesita intervencion manual para actualizar el stock.

```
===============================================================
```

---

## OBSERVACIONES ADICIONALES

1. **Calidad excepcional del documento de diseno:** El documento de 35 paginas es extremadamente completo: incluye introduccion con analisis del caso, modelo conceptual con justificaciones por entidad, esquema relacional con CREATE TABLE y justificaciones por tabla, restricciones organizadas por tipo con sintaxis SQL, 5 VIEWS con descripciones, queries de ejemplo y justificacion de diseno. La organizacion y profundidad superan lo esperado para un examen parcial.

2. **Fortaleza principal - Restricciones:** La seccion de restricciones es la mas destacada del trabajo. Con 5 UNIQUE, 9 CHECK, 20+ NOT NULL, 13 FK y 3 triggers con logica de negocio, superan ampliamente lo esperado. Los triggers demuestran comprension avanzada de como el motor de BD puede garantizar integridad sin depender de la aplicacion.

3. **Debilidad principal - Queries SQL:** La seccion de queries es la mas debil. Solo 2 queries de ejemplo es insuficiente para un equipo de 3 integrantes. Curiosamente, las VIEWS y los triggers contienen SQL mas sofisticado que las queries independientes, lo que sugiere que el equipo tiene la capacidad pero no dedico suficiente atencion a esta seccion.

4. **Inconsistencia diagrama vs documento:** El diagrama en dbdiagram.io no muestra precio_venta_historico en DETALLE_PEDIDO ni precio_compra_historico en DETALLE_ENTRADA, pero los CREATE TABLE del documento si los incluyen. Esto sugiere que el diagrama se creo primero y se mejoro el diseno despues sin actualizar el diagrama.

5. **Equipo de 3 integrantes confirmado:** La portada del documento lista a Espinoza Mendoza Hector Isaac (243751), Moreno Zuniga Jesel (243692), y Arturo Yion Jaime (243602). Las tres carpetas contienen el mismo trabajo.

===============================================================
