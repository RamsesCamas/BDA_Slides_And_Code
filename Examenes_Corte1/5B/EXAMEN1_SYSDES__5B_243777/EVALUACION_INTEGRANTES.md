# Evaluacion: 243777 - 243732 - 243716
## Caso: 3-A - Logistica de Distribucion Regional
### Integrantes: 3 (Hidalgo Garcia Luvia Magali 243732, Montesinos Grajales Alix Anahi 243777, Velazquez Tovilla Mario Alberto 243716)

---

### Resumen de Puntuacion

| Seccion | Puntos Obtenidos | Puntos Maximos | Porcentaje |
|---------|------------------|----------------|------------|
| Modelo ER + Esquema | 29 | 30 | 97% |
| Restricciones | 19 | 20 | 95% |
| Queries SQL | 21 | 25 | 84% |
| VIEWS | 15 | 15 | 100% |
| Justificacion | 7 | 10 | 70% |
| **TOTAL** | **91** | **100** | **91%** |

### Calificacion Final: 9.1 / 10
### Porcentaje Final: 13.65% de 15%

---

### Retroalimentacion por Seccion

#### Modelo ER + Esquema Relacional
- **Fortalezas**: Esquema excepcional con 13 tablas muy detalladas: categorias, proveedores, productos, proveedor_producto, inventario, movimientos_inventario, comercios, pedidos, detalle_pedido, detalle_entrega, rutas, ruta_pedido, vehiculos, conductores. Destacan varios aspectos superiores:
  - La tabla proveedor_producto implementa una relacion N-N entre proveedores y productos con atributos ricos (Precio_Proveedor, Tiempo_Entrega_Dias, Fecha_Inicio_Suministro, Es_Proveedor_Principal, Activo). Este es el unico equipo que implementa correctamente esta relacion N-N.
  - La tabla inventario esta separada de productos, con Cantidad_Disponible, Cantidad_Reservada, Stock_Minimo, Stock_Maximo, y fechas de ultima entrada/salida.
  - La tabla movimientos_inventario unifica entradas y salidas con Tipo_Movimiento, lo que permite rastrear ajustes y mermas ademas de entradas/salidas normales.
  - La tabla detalle_entrega tiene campos granulares: Cantidad_Solicitada, Cantidad_Entregada, Cantidad_Danada, Cantidad_Faltante, Firma_Digital, Nombre_Receptor.
  - Los vehiculos usan Placas como PK natural, con campos de Kilometraje, Fecha_Ultima_Revision, Fecha_Proximo_Mantenimiento.
  - Los conductores usan Numero_Licencia como PK natural, con Fecha_Vencimiento_Licencia y Tipo_Licencia.
  - La tabla comercios incluye Estado_Republica, Zona, Credito_Autorizado, Saldo_Pendiente.
  - Campos Activo (TINYINT) en multiples tablas para borrado logico.
  Los tipos de datos son detallados y apropiados (DECIMAL con precision especifica, VARCHAR con longitudes justificadas).
- **Debilidades**: No se presenta un diagrama ER conceptual en notacion Chen o similar, solo el esquema relacional. Sin embargo, el esquema es tan detallado que esto es una omision menor (-1 pt).

#### Restricciones
- **Fortalezas**: Las restricciones son las mas completas y mejor organizadas de todas las entregas evaluadas. Se organizan en 4 categorias claras:
  1. **UNIQUE** (5): Nombres de categorias, RFC de proveedores y comercios, inventario por producto, productos en pedido, orden de ruta.
  2. **CHECK** (multiples): Valores positivos (precios, pesos, inventarios, capacidades, kilometrajes). Fechas coherentes (entrega >= pedido, vehiculos >= 2000). Limites financieros (saldo <= credito, total = subtotal + IVA). Requisitos de personal (conductor > 21 anios, licencia vigente). Consistencia de entregas (entregada + danada <= solicitada). Formato RFC (patron oficial). Estados validos (predefinidos).
  3. **NOT NULL**: Identidad obligatoria, tiempos, cantidades, estados.
  4. **FOREIGN KEY**: ON DELETE RESTRICT para historial (proveedor con productos, comercio con pedidos). ON DELETE CASCADE para detalles (lineas de pedido). Existencia previa para asignaciones.
  Exceden ampliamente el minimo de 10 restricciones, con probablemente mas de 20 restricciones identificadas.
- **Debilidades**: Las restricciones se describen en lenguaje natural claro pero no incluyen la sintaxis SQL exacta (ALTER TABLE ADD CONSTRAINT). Sin embargo, el nivel de detalle es suficiente para demostrar comprension completa. Descuento minimo (-1 pt).

#### Queries SQL
- **Fortalezas**: 5 queries presentadas con codigo SQL funcional y explicaciones claras:
  - Query 1 (Pedidos sin ruta): LEFT JOIN correcto con Ruta_Pedido, WHERE IS NULL.
  - Query 2 (Sobrecarga): SUM con multiples JOINs a traves de Ruta->Ruta_Pedido->Pedido->Detalle_Pedido->Producto. CASE para clasificacion Peligro/OK. WHERE r.Estado = 'Planificada'.
  - Query 3 (Rutas con incidencias): SUM(CASE) con HAVING > 0 para filtrar. JOIN con Conductores.
  - Query 4 (Gasto por proveedor): COALESCE con LEFT JOIN a movimientos_inventario. Filtro AND mi.Tipo_Movimiento = 'ENTRADA'.
  - Query 5 (Valor inventario por categoria): JOIN Inventario-Productos-Categorias. SUM(Cantidad_Disponible * Precio_Base). GROUP BY cat.Nombre.
  Todas usan JOINs correctos, son coherentes con el esquema, y cada una incluye una explicacion del objetivo.
- **Debilidades**: Solo 5 queries presentadas cuando el caso requiere 6 (-2 pts). Falta la query 6 (pedido mas reciente por comercio). Query 2 referencia r.Placas_Vehiculo = v.Placas (correcto con PK natural). Query 3 usa r.Licencia_Conductor = c.Numero_Licencia (correcto). Menor: Query 3 filtra por p.Estado = 'Entregado con incidencia', lo cual presupone un estado especifico que deberia documentarse mejor (-2 pts).

#### VIEWS
- **Fortalezas**: 5 VIEWS excepcionales, cada una con justificacion detallada del por que y como funciona:
  - VIEW 1 (V_Inventario_Critico): Usa CTE (WITH Ventas_Diarias) con filtro temporal de 30 dias, COALESCE para cero ventas, CASE doble (Dias_Cobertura y Estado_Inventario con 'Estancado', 'CRITICO', 'Suficiente'). Incluye WHERE para filtrar solo problematicos. La justificacion menciona division por cero como problema resuelto.
  - VIEW 2 (V_Resumen_Zona): SUM con CASE para entregas exitosas e incidencias, ROUND con DECIMAL cast y NULLIF para tasa de exito. WHERE filtra por estados relevantes. HAVING COUNT > 5 como umbral justificado. Excelente.
  - VIEW 3 (V_Productividad_Conductores): COUNT(DISTINCT), ROUND con DECIMAL y NULLIF. CASE con 3 niveles (Alto Rendimiento >40, Promedio 15-40, Bajo/En Capacitacion <15). Justificacion de rangos incluida.
  - VIEW 4 (V_Utilizacion_Flota): LEFT JOIN con filtro temporal en el JOIN (DATE_TRUNC). CASE con 3 niveles (Subutilizado =0, Punto Optimo 1-20, Sobrecargado >20). Justificacion de umbral de sobrecarga incluida.
  - VIEW 5 (V_Rentabilidad_Proveedor): Usa subconsultas correlacionadas con COALESCE para Total_Ventas_Estimadas y Margen_Bruto. LEFT JOIN con movimientos_inventario para costos. Referencia la tabla proveedor_producto con Es_Proveedor_Principal = TRUE.
  Todas las VIEWS son de nivel profesional, coherentes con el esquema, y demuestran dominio avanzado de SQL.
- **Debilidades**: Ninguna significativa. Este es el mejor conjunto de VIEWS de todas las entregas evaluadas junto con el equipo 243742.

#### Justificacion de Diseno
- **Fortalezas**: Se responden ambas preguntas. La respuesta a "por que este caso" es honesta: eligieron el caso por tener nivel menos complejo y facilitar la visualizacion del flujo de datos. La respuesta a "por que lo disenaron asi" describe el proceso de analisis: identificaron relaciones y tablas, pasaron de 15 a 13 tablas, analizaron el flujo proveedor->almacen->pedido->ruta->entrega.
- **Debilidades**: La justificacion es la seccion mas debil del trabajo, contrastando con la calidad excepcional del esquema y VIEWS. La respuesta a "por que este caso" reconoce haber elegido el caso por menor complejidad, lo cual es honesto pero no menciona desafios tecnicos concretos del caso (-1 pt). La respuesta a "por que lo disenaron asi" es un relato del proceso de trabajo, no una justificacion de decisiones tecnicas. No menciona trade-offs (ej. por que N-N en proveedor-producto, por que una tabla de inventario separada, por que movimientos unificados en lugar de tablas separadas) (-2 pts). No menciona normalizacion, entidades debiles, ni conceptos de diseno de BD.

---

### Preguntas de Seguimiento

1. **[COMPRENSION]**
   - Pregunta: Su tabla proveedor_producto tiene un campo Es_Proveedor_Principal (booleano). Expliquen como funciona esta tabla cuando un mismo producto (ej. "Aceite de oliva 1L") puede ser comprado a dos proveedores diferentes. Como registrarian esto y como decidirian a cual proveedor comprar?
   - Respuesta esperada: Deben explicar que se crean dos registros en proveedor_producto con el mismo ID_Producto pero diferente ID_Proveedor, cada uno con su Precio_Proveedor y Tiempo_Entrega_Dias. El campo Es_Proveedor_Principal marca al preferido. Para decidir a quien comprar, se consultaria esta tabla filtrando por Activo=TRUE y priorizando Es_Proveedor_Principal=TRUE, con precio y tiempo de entrega como criterios secundarios.

2. **[FALENCIAS]**
   - Pregunta: Su tabla detalle_entrega registra Cantidad_Solicitada, Cantidad_Entregada, Cantidad_Danada y Cantidad_Faltante por producto. Si un pedido tiene 3 productos y 2 se entregan bien pero el tercero esta completamente danado, como se reflejaria esto en su modelo? Y como afectaria al inventario?
   - Respuesta esperada: Se crearian 3 registros en detalle_entrega. Productos 1 y 2: Cantidad_Entregada = Cantidad_Solicitada, Danada=0, Faltante=0. Producto 3: Cantidad_Entregada=0, Cantidad_Danada=total, Faltante=0. El inventario deberia ajustarse con un movimiento_inventario de tipo 'MERMA' o 'DANADO' para el producto 3. Deben reconocer si su modelo maneja automaticamente este ajuste o si requiere una operacion manual.

3. **[MEJORA]**
   - Pregunta: Su tabla comercios tiene campos Credito_Autorizado y Saldo_Pendiente. Como implementarian un control que impida crear un pedido nuevo cuando el saldo_pendiente de un comercio ya supera su credito_autorizado?
   - Respuesta esperada: Deberian mencionar que un CHECK constraint puro no puede validar datos entre tablas. Necesitarian un trigger BEFORE INSERT en pedidos que consulte comercios.Saldo_Pendiente y comercios.Credito_Autorizado, rechazando el INSERT si Saldo_Pendiente + nuevo_pedido.Total > Credito_Autorizado. Alternativamente, esta logica podria vivir en la aplicacion.

4. **[DECISION]**
   - Pregunta: Ustedes eligieron unificar entradas y salidas de almacen en una sola tabla movimientos_inventario con un campo Tipo_Movimiento, en lugar de tener tablas separadas de entradas y salidas como otros equipos. Por que tomaron esa decision?
   - Respuesta esperada: Deben justificar que una sola tabla permite agregar nuevos tipos de movimiento (ajuste, merma, transferencia, devolucion) con solo agregar un valor al campo, sin crear nuevas tablas. Facilita consultas de historial completo de un producto. Tambien simplifica los reportes de movimientos. La desventaja es que campos como ID_Proveedor solo aplican a ENTRADAS, quedando NULL para otros tipos.

5. **[APLICACION]**
   - Pregunta: Usando su VIEW V_Inventario_Critico, si un producto tiene Cantidad_Disponible = 45 en inventario y en los ultimos 30 dias se vendieron 90 unidades (SUM de Cantidad_Solicitada), que valores mostraria la vista para Ventas_Diarias_Prom, Dias_Cobertura, y Estado_Inventario?
   - Respuesta esperada: CTE Ventas_Diarias: Promedio_Venta = COALESCE(90, 0) / 30.0 = 3.0. En la consulta principal: Ventas_Diarias_Prom = ROUND(COALESCE(3.0, 0), 2) = 3.00. Dias_Cobertura: como 3.0 != 0, entra en ELSE ROUND(45 / 3.0, 1) = 15.0. Estado_Inventario: como 45/3.0 = 15 y 15 no es < 15, el producto NO apareceria en la vista (el WHERE filtra por < 15 o = 0). Con 44 de stock: 44/3.0 = 14.67, SI apareceria como 'CRITICO (<15 dias)'.

---

### Observaciones Adicionales
Este es uno de los mejores trabajos del grupo, junto con el equipo 243742. El esquema relacional es el mas detallado de todas las entregas, con la unica implementacion correcta de la relacion N-N Proveedor-Producto, una tabla de inventario separada con stocks minimos/maximos, y la tabla detalle_entrega con campos granulares de Cantidad_Solicitada/Entregada/Danada/Faltante. Las restricciones son exhaustivas y bien categorizadas. Las VIEWS son de nivel profesional con CTE, subconsultas correlacionadas, y justificaciones individuales. La unica area de mejora notable es la justificacion de diseno, que es demasiado informal y no refleja la sofisticacion tecnica evidente en el resto del trabajo. Tambien falta una query (5 de 6 requeridas).
