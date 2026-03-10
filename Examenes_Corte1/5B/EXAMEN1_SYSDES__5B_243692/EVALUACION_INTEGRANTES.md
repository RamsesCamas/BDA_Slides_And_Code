
# EVALUACION DE EXAMEN PARCIAL - BASE DE DATOS AVANZADA

```
===============================================================
EVALUACION: EXAMEN1_SYSDES__5B_243692
Caso: 3-A - Logistica de Distribucion Regional
Integrantes: 3
  - Espinoza Mendoza Hector Isaac - 243692
  - Moreno Zuniga Jesel - 243751
  - Arturo Yion Jaime - 243602
===============================================================
```

---

## PUNTUACION POR SECCION

```
--------------------------------------------------------------
Modelo ER + Esquema:    28/30
Restricciones:          19/20
Queries SQL:            16/25
VIEWS:                  14/15
Justificacion:          10/10
--------------------------------------------------------------
TOTAL:                  87/100
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

### [Modelo ER + Esquema Relacional] -- 28/30

**Fortalezas:**
- **Excelente cantidad de entidades (14 tablas):** CATEGORIA, PROVEEDOR, PRODUCTO, ENTRADA_ALMACEN, DETALLE_ENTRADA, ZONA_GEOGRAFICA, COMERCIO, PEDIDO, DETALLE_PEDIDO, VEHICULO, CONDUCTOR, RUTA, PEDIDO_RUTA, ENTREGA. Supera ampliamente el minimo de 9-12 tablas para equipo de 3.
- **Dos diagramas complementarios:** Se presenta tanto un esquema relacional detallado (hecho en dbdiagram.io, paginas 1-2) como un diagrama Entidad-Relacion en notacion Chen (pagina 3). Demuestra dominio de ambas representaciones.
- **Tres tablas puente correctamente implementadas:**
  - DETALLE_ENTRADA (id_entrada, id_producto) -- resuelve N:N entre ENTRADA_ALMACEN y PRODUCTO
  - DETALLE_PEDIDO (id_pedido, id_producto) -- resuelve N:N entre PEDIDO y PRODUCTO
  - PEDIDO_RUTA (id_pedido, id_ruta, orden_entrega) -- resuelve N:N entre PEDIDO y RUTA, con campo adicional de orden de entrega
  - Esto supera el requisito de 2 relaciones N:N para equipo de 3.
- **Cardinalidades correctas y explicitas** tanto en el diagrama relacional como en el diagrama Chen: 1:N para Proveedor-Producto, Categoria-Producto, Zona-Comercio, Comercio-Pedido, Vehiculo-Ruta, Conductor-Ruta; N:M para Producto-Pedido y Pedido-Ruta; 1:1 para Pedido-Entrega.
- **Claves primarias bien definidas** en todas las tablas con icono de llave.
- **Claves foraneas correctamente marcadas** en el esquema relacional.
- **NOT NULL (NN) marcados visualmente** en el diagrama para campos criticos.
- **Tipos de datos apropiados:** DECIMAL(10,2) para dinero (no FLOAT), VARCHAR para textos, DATETIME/DATE para fechas, INT para IDs.
- **Campo `orden_entrega`** en PEDIDO_RUTA es un excelente detalle operativo que demuestra comprension del dominio logistico.
- **Campos `firma_digital`, `incidencia`, `cantidad_danada`** en ENTREGA modelan correctamente las entregas con y sin incidencias.
- **Entidad ENTREGA modelada como entidad debil** (id_pedido como PK y FK), cumpliendo el requisito de al menos 1 entidad debil.

**Debilidades:**
- **Falta tabla de ALMACEN explicita** (-1 pt): El caso menciona un almacen central, pero el modelo no tiene una tabla ALMACEN separada. El stock se maneja a nivel global en PRODUCTO (stock_actual), lo cual limita la escalabilidad si se necesitan multiples almacenes.
- **ENTREGA con id_pedido como PK implica relacion 1:1** (-1 pt): Si un pedido requiere multiples intentos de entrega (re-entregas), el modelo actual no lo permite. Sin embargo, el equipo reconoce explicitamente esta limitacion en su documento y menciona que se puede cambiar a 1:N en el futuro.

**Penalizaciones aplicadas:**
- Falta entidad Almacen: -1 pt
- Limitacion en modelado de re-entregas: -1 pt

---

### [Restricciones] -- 19/20

**Fortalezas:**
- **NOT NULL (4/4):** Excelente uso de NOT NULL en campos criticos a traves de todas las tablas. Mas de 20 campos marcados como NOT NULL con justificacion clara de por que cada uno es obligatorio. Ejemplos: nombre y rfc en PROVEEDOR, precios y stock en PRODUCTO, fecha_ruta/id_vehiculo/id_conductor en RUTA.
- **UNIQUE (4/4):** 5 restricciones UNIQUE bien justificadas:
  - RFC unico en PROVEEDOR (identificador fiscal mexicano)
  - Placas unicas en VEHICULO (identificador legal del vehiculo)
  - Licencia unica en CONDUCTOR (licencia personal e intransferible)
  - Nombre de categoria unico en CATEGORIA (evita duplicados)
  - Nombre de zona unico en ZONA_GEOGRAFICA (evita ambiguedad)
  - Cada restriccion tiene sintaxis ALTER TABLE correcta con nombre de constraint (uq_proveedor_rfc, etc.).
- **CHECK (4/4):** 9 restricciones CHECK con sintaxis correcta y justificaciones pertinentes:
  - Formato de RFC con REGEXP (patron de RFC mexicano)
  - Precios positivos en PRODUCTO (precio_compra > 0, precio_venta > 0)
  - Stock no negativo (stock_actual >= 0)
  - Cantidades positivas en DETALLE_ENTRADA y DETALLE_PEDIDO
  - Estados validos para PEDIDO (IN 'Confirmado','En ruta','Entregado','Entregado con incidencia','Cancelado')
  - Estados validos para VEHICULO (IN 'Disponible','En ruta','Mantenimiento','Fuera de servicio')
  - Capacidad positiva en VEHICULO
  - Estados validos para RUTA
  - Unidades de medida validas en PRODUCTO
- **FK / Integridad referencial (4/4):** 13 FOREIGN KEY bien definidas en las sentencias CREATE TABLE. Buena distincion entre FKs con ON DELETE CASCADE (en tablas de detalle: DETALLE_ENTRADA, DETALLE_PEDIDO) y FKs sin CASCADE (proteccion en PRODUCTO->PROVEEDOR para no borrar proveedores con productos). Justificacion clara de por que se aplica o no CASCADE en cada caso.
- **Reglas de negocio (3/4):** 3 triggers bien implementados para reglas de negocio complejas:
  - trg_validar_capacidad_vehiculo: Previene que el peso asignado a una ruta exceda la capacidad del vehiculo (BEFORE INSERT en PEDIDO_RUTA). Usa SIGNAL SQLSTATE para lanzar error.
  - trg_validar_vehiculo_disponible: Impide asignar un vehiculo en mantenimiento a una ruta (BEFORE INSERT en RUTA). Implementa el requisito del caso.
  - trg_aumentar_stock / trg_disminuir_stock: Actualizan automaticamente el stock al registrar entradas y pedidos.
  - Todos con sintaxis MySQL correcta (DECLARE, SELECT INTO, IF, SIGNAL SQLSTATE).
  - Se descuenta 1 punto porque falta una regla que valide que el stock sea suficiente antes de confirmar un pedido (el trigger de stock decrementa sin verificar si hay stock disponible, lo cual podria violar la restriccion CHECK de stock >= 0 pero no da un mensaje de error de negocio amigable).

**Debilidades:**
- Falta trigger de validacion de stock suficiente antes de crear detalle de pedido (-1 pt).

**Total de restricciones documentadas:** 5 UNIQUE + 9 CHECK + 20+ NOT NULL + 13 FK + 3 Triggers = supera ampliamente el minimo de 10 para equipo de 3.

---

### [Queries SQL] -- 16/25

**Fortalezas:**
- **Sintaxis correcta (4/5):** Las 2 queries presentadas tienen sintaxis MySQL correcta y ejecutable.
- **JOINs apropiados (5/8):**
  - Query 1 (Pedidos sin ruta): Usa JOIN entre PEDIDO y COMERCIO, con subquery NOT IN contra PEDIDO_RUTA. Demuestra comprension de JOINs y subconsultas.
  - Query 2 (Alerta sobrecarga): Usa 3 JOINs encadenados (RUTA -> VEHICULO, RUTA -> PEDIDO_RUTA -> PEDIDO). Excelente ejemplo de query multi-tabla.
  - Sin embargo, con solo 2 queries no se demuestra variedad completa de JOINs (falta LEFT JOIN, CROSS JOIN, self-join en queries independientes).
- **Agregaciones (3/5):** La Query 2 usa SUM(p.peso_total) correctamente. Falta demostrar COUNT, AVG u otras agregaciones en queries independientes.
- **GROUP BY / HAVING (3/4):** La Query 2 usa GROUP BY r.id_ruta, v.capacidad_kg con HAVING SUM(p.peso_total) > v.capacidad_kg * 0.9, que es un excelente uso de HAVING con calculo de umbral del 90%. Sin embargo, solo hay un ejemplo.
- **Cobertura (1/3):** Solo 2 queries presentadas. Para un equipo de 3 se esperan al menos 7-8 queries con variedad de operaciones. Esta es la principal debilidad de la entrega.

**NOTA IMPORTANTE:** Las 5 VIEWS del documento contienen queries SQL complejas y bien construidas dentro de sus definiciones (con JOINs, CASE, NULLIF, COALESCE, GROUP BY, agregaciones). Si se consideran como queries adicionales, la cobertura seria significativamente mayor. Sin embargo, la seccion dedicada a "Queries SQL de Ejemplo" solo presenta 2 queries explicitamente.

**Debilidades:**
- Solo 2 queries en la seccion dedicada (-5 puntos en cobertura y variedad).
- Falta demostrar LEFT JOIN explicito, subconsultas correlacionadas, UNION, o queries de actualizacion/eliminacion.
- La seccion 6 del documento parece incompleta -- solo tiene 2 capturas de pantalla de queries.

---

### [VIEWS] -- 14/15

**Fortalezas:**
- **Sintaxis CREATE VIEW (3/3):** Las 5 vistas usan la sintaxis CREATE VIEW correcta con nombres descriptivos (vista_resumen_zonas, vista_productividad_conductores, vista_inventario_critico, vista_rentabilidad_proveedor, vista_utilizacion_flota). Cumple exactamente el minimo de 5 VIEWS para equipo de 3.
- **Agregaciones correctas (4/4):** Excelente uso de agregaciones:
  - COUNT(p.id_pedido) en vista_resumen_zonas
  - SUM(CASE WHEN...) para conteo condicional en vista_resumen_zonas
  - COUNT(r.id_ruta) y COUNT(pr.id_pedido) en vista_productividad_conductores
  - SUM(dp.cantidad * dp.precio_venta_historico) y SUM(dp.cantidad * p.precio_compra_actual) en vista_rentabilidad_proveedor
  - COALESCE(SUM(dp.cantidad), 0) en vista_inventario_critico
- **Uso de HAVING (2/3):** No se observa uso explicito de HAVING en las VIEWS. Se descuenta 1 punto. Las VIEWS usan GROUP BY pero ninguna incluye clausula HAVING para filtrar grupos.
- **Uso de CASE/COALESCE (3/3):** Excelente uso:
  - CASE WHEN para clasificar productividad de conductores (Baja/Normal/Excelente)
  - CASE WHEN para clasificar utilizacion de flota (Subutilizado/Optimo/Sobrecargado)
  - CASE WHEN para conteo condicional de entregas exitosas vs incidencias
  - COALESCE para manejar valores NULL en ventas totales
  - NULLIF para prevenir division entre cero en vista_inventario_critico y vista_resumen_zonas
- **Coherencia con esquema (2/2):** Las 5 vistas referencian tablas y campos existentes en el esquema. Cada vista tiene una descripcion clara de su proposito de negocio.

**Debilidades:**
- Falta uso de HAVING en las vistas (-1 pt). Una clausula HAVING podria haberse usado para filtrar, por ejemplo, solo zonas con mas de X pedidos o conductores con productividad por debajo de un umbral.

**Detalles de las 5 VIEWS:**
1. **vista_resumen_zonas:** Resumen de pedidos por zona geografica. Usa LEFT JOIN (ZONA->COMERCIO->PEDIDO), SUM con CASE, NULLIF para division segura, GROUP BY.
2. **vista_productividad_conductores:** Productividad de conductores. Usa JOINs (CONDUCTOR->RUTA->PEDIDO_RUTA), COUNT, CASE para clasificacion, GROUP BY.
3. **vista_inventario_critico:** Control de quiebre de stock. Usa LEFT JOIN (PRODUCTO->DETALLE_PEDIDO), COALESCE, NULLIF, SUM, GROUP BY.
4. **vista_rentabilidad_proveedor:** Rentabilidad por proveedor. Usa JOINs (PROVEEDOR->PRODUCTO->DETALLE_PEDIDO), SUM con calculos financieros, GROUP BY.
5. **vista_utilizacion_flota:** Utilizacion de flota vehicular. Usa LEFT JOIN (VEHICULO->RUTA), COUNT, CASE para clasificacion, GROUP BY.

---

### [Justificacion de Diseno] -- 10/10

**Por que escogieron ese caso (4/4):**
- Respuesta clara y bien argumentada. Mencionan que eligieron el Caso 3-A por:
  - Complejidad arquitectonica: Tres flujos de datos entrelazados (suministro, comercial, operativo).
  - Desafio de integridad: Logica de estados avanzada como vehiculos en mantenimiento, triggers y restricciones de negocio.
  - Lo consideraron el caso mas atractivo y completo para un equipo de 3.
- Demuestra que la eleccion fue deliberada y no aleatoria.

**Por que lo disenaron asi (6/6):**
- Respuesta excepcionalmente detallada y estructurada en 4 puntos:
  - **A. Preservacion de datos historicos:** Explican por que incluyen precio_venta_historico en DETALLE_PEDIDO y precio_compra_historico en DETALLE_ENTRADA. Justificacion clara: "Si el precio de la leche sube manana en PRODUCTO, los pedidos de hoy deben mantener su valor original." Mencion explicita de que no hacerlo "corromperia la contabilidad historica."
  - **B. Uso de entidades debiles para incidencias:** Justifican ENTREGA como entidad debil por separacion de responsabilidades (pedido = almacen, entrega = campo), evitar NULLs en PEDIDO, y extensibilidad futura.
  - **C. Automatizacion mediante triggers:** Explican por que delegaron la integridad al motor de BD en lugar de depender de la aplicacion. Mencionan seguridad del stock y reglas de negocio como la prohibicion de asignar vehiculos en mantenimiento.
  - **D. Normalizacion y escalabilidad:** Justifican la separacion de CATEGORIA y ZONA_GEOGRAFICA como tablas independientes para evitar redundancia y facilitar crecimiento futuro.
- Se mencionan trade-offs, decisiones no obvias, y coherencia general. Excelente calidad de justificacion.

---

## PREGUNTAS DE SEGUIMIENTO PARA DEFENSA

```
--------------------------------------------------------------
```

### 1. [COMPRENSION]
**Pregunta:** En su tabla DETALLE_PEDIDO incluyen un campo `precio_venta_historico`, pero en su tabla DETALLE_ENTRADA incluyen un campo `precio_compra_historico`. Expliquen la diferencia funcional entre estos dos campos y por que decidieron congelar ambos precios en el momento de la transaccion en lugar de solo uno.

**Respuesta esperada:** El precio_venta_historico en DETALLE_PEDIDO congela el precio al que se vendio el producto al comercio en ese momento. El precio_compra_historico en DETALLE_ENTRADA congela el costo de adquisicion del proveedor en esa entrega especifica. Ambos son necesarios porque: (1) los precios de compra y venta pueden cambiar independientemente, (2) congelar solo el de venta no permitiria calcular el margen real de ganancia historico (necesitamos saber cuanto costo Y cuanto se vendio), (3) esto permite la vista_rentabilidad_proveedor que calcula el margen exacto usando precios historicos. Si solo se congelara un precio, los reportes financieros serian imprecisos.

### 2. [FALENCIAS]
**Pregunta:** Su trigger `trg_disminuir_stock` resta la cantidad del pedido del stock_actual automaticamente al insertar en DETALLE_PEDIDO, pero no valida si hay stock suficiente antes de restar. Que problema podria ocurrir si un comercio pide 100 litros de leche pero solo hay 30 en stock? Como lo resolverian?

**Respuesta esperada:** Deberian reconocer que el trigger actual podria reducir el stock a un valor negativo. Aunque la restriccion CHECK (stock_actual >= 0) rechazaria la operacion, el mensaje de error seria generico y no informativo. La solucion seria agregar una validacion previa en el trigger: antes de hacer el UPDATE, verificar que stock_actual >= NEW.cantidad, y si no, lanzar un SIGNAL SQLSTATE '45000' con mensaje 'Stock insuficiente para el producto X'. Alternativamente, podrian combinar el trigger con un procedimiento almacenado que verifique stock antes de insertar el detalle.

### 3. [MEJORA]
**Pregunta:** Sus vistas calculan metricas de productividad y utilizacion, pero no filtran por periodo de tiempo. Si el gerente solo quiere ver la productividad de conductores del ultimo mes, como modificarian la vista_productividad_conductores? Que limitaciones tienen las vistas para este tipo de filtro temporal?

**Respuesta esperada:** Podrian agregar un WHERE r.fecha_ruta >= DATE_SUB(CURRENT_DATE, INTERVAL 1 MONTH) en la vista para filtrar solo rutas del ultimo mes. Sin embargo, esto haría que la vista siempre muestre un mes fijo. Una mejor solucion seria crear un procedimiento almacenado o funcion que acepte parametros de fecha, o bien dejar la vista sin filtro temporal y aplicar el filtro al consultar la vista (SELECT * FROM vista_productividad_conductores WHERE...). La limitacion es que las vistas en MySQL no aceptan parametros, asi que si se necesita flexibilidad temporal, se requiere otra estrategia.

### 4. [DECISION]
**Pregunta:** Ustedes decidieron usar id_proveedor como PK de la tabla PROVEEDOR en lugar de usar el RFC directamente como clave primaria, aunque el RFC ya es UNIQUE y NOT NULL. Expliquen los trade-offs de esta decision. En que escenarios podria ser mejor usar el RFC como PK?

**Respuesta esperada:** Deberian mencionar: (1) INT es mas eficiente para JOINs que VARCHAR(13) porque ocupa menos bytes y las comparaciones son mas rapidas; (2) si hay un error de captura en el RFC, un id_proveedor como PK permite corregirlo sin afectar las FK en PRODUCTO y ENTRADA_ALMACEN; (3) el RFC como UNIQUE ya garantiza la unicidad de negocio. El RFC como PK seria mejor si: se necesita referenciar proveedores por RFC en otras bases de datos o sistemas externos, o si la base es pequena y la eficiencia no es critica. Es un trade-off entre eficiencia tecnica (INT como PK) y significado de negocio (RFC como PK natural).

### 5. [APLICACION]
**Pregunta:** Usando su esquema, el gerente quiere saber: "Cual es el proveedor mas rentable del ultimo trimestre?" Es decir, el proveedor cuyos productos generaron mayor margen de ganancia (precio_venta_historico - precio_compra del producto, multiplicado por cantidad vendida). Escriban la consulta.

**Respuesta esperada:**
```sql
SELECT
    pr.nombre AS proveedor,
    SUM(dp.cantidad * (dp.precio_venta_historico - p.precio_compra)) AS margen_total,
    SUM(dp.cantidad * dp.precio_venta_historico) AS ingreso_total,
    SUM(dp.cantidad * p.precio_compra) AS costo_total
FROM PROVEEDOR pr
JOIN PRODUCTO p ON pr.id_proveedor = p.id_proveedor
JOIN DETALLE_PEDIDO dp ON p.id_producto = dp.id_producto
JOIN PEDIDO ped ON dp.id_pedido = ped.id_pedido
WHERE ped.fecha_pedido >= DATE_SUB(CURRENT_DATE, INTERVAL 3 MONTH)
GROUP BY pr.id_proveedor, pr.nombre
ORDER BY margen_total DESC
LIMIT 1;
```
La query requiere unir PROVEEDOR -> PRODUCTO -> DETALLE_PEDIDO -> PEDIDO, filtrar por fecha del ultimo trimestre, calcular el margen usando precio historico de venta y precio de compra del producto, agrupar por proveedor y ordenar por margen descendente.

```
===============================================================
```

---

## OBSERVACIONES ADICIONALES

1. **Calidad excepcional del documento de diseno:** Este es uno de los documentos mas completos y profesionales de la entrega. Contiene 35 paginas con portada, indice, introduccion, modelo conceptual con justificaciones detalladas para cada entidad, esquema relacional con CREATE TABLE completos, 17 restricciones formales nombradas con justificaciones, 3 triggers con logica MySQL correcta, 5 VIEWS bien estructuradas, queries de ejemplo, y respuestas articuladas a las preguntas de justificacion.

2. **Justificaciones individuales por entidad y por restriccion:** Cada entidad tiene su justificacion de existencia, cada atributo tiene razon de ser, cada restriccion tiene explicacion. Esto demuestra profundidad de comprension (o al menos buena capacidad de articulacion). Las preguntas de defensa verificaran la comprension real.

3. **Principal debilidad: Queries SQL insuficientes:** La seccion de Queries SQL solo presenta 2 queries de ejemplo cuando se esperan al menos 7-8 para un equipo de 3. Este es el unico punto significativamente debil de la entrega. Las queries dentro de las VIEWS compensan parcialmente pero no reemplazan una seccion dedicada de queries variados.

4. **Uso sofisticado de CASE, COALESCE y NULLIF en VIEWS:** Las 5 vistas demuestran dominio de funciones SQL avanzadas: CASE para clasificacion categorica, COALESCE para manejo de NULLs, NULLIF para prevencion de division entre cero. Esto es un nivel por encima de lo esperado en un examen de 5to semestre.

5. **Equipo confirmado de 3 integrantes:** Espinoza Mendoza Hector Isaac (243692), Moreno Zuniga Jesel (243751), Arturo Yion Jaime (243602). Las matriculas en la portada estan truncadas pero corresponden con las carpetas 243692, 243751 y 243602 que contienen los mismos archivos.

===============================================================
