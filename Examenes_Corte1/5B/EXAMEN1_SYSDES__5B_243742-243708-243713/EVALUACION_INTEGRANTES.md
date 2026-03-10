# Evaluacion: 243742 - 243708 - 243713
## Caso: 3-A - Logistica de Distribucion Regional
### Integrantes: 3 (Derek Alejandro Ortiz Tovilla, Jose Juan Ramos Cabrera, Alexander Jesus Jimenez Leon)

---

### Resumen de Puntuacion

| Seccion | Puntos Obtenidos | Puntos Maximos | Porcentaje |
|---------|------------------|----------------|------------|
| Modelo ER + Esquema | 28 | 30 | 93% |
| Restricciones | 18 | 20 | 90% |
| Queries SQL | 24 | 25 | 96% |
| VIEWS | 15 | 15 | 100% |
| Justificacion | 9 | 10 | 90% |
| **TOTAL** | **94** | **100** | **94%** |

### Calificacion Final: 9.4 / 10
### Porcentaje Final: 14.1% de 15%

---

### Retroalimentacion por Seccion

#### Modelo ER + Esquema Relacional
- **Fortalezas**: Excelente esquema con 14 tablas bien definidas. Se presentan tanto el diagrama ER conceptual como el esquema relacional detallado con tipos de datos, PKs, FKs y constraints UNIQUE claramente marcados. Las dos relaciones N-N (Detalle_Pedido y Asignacion_Pedidos_Ruta) estan correctamente implementadas con tablas puente. La tabla Mantenimientos y Detalle_Entrada muestran un nivel de detalle superior al minimo requerido. La normalizacion a 3FN es correcta.
- **Debilidades**: La relacion Proveedor-Producto es 1-N (un proveedor suministra muchos productos), lo cual es correcto para el escenario simple, pero no contempla la posibilidad de que un producto venga de multiples proveedores. Esto es un trade-off valido pero podria haberse mencionado explicitamente. Se descuentan 2 puntos menores por no incluir una tabla de Zonas Geograficas mas detallada (solo tiene ID y Nombre, falta el campo estado/region que es relevante para 3 estados).

#### Restricciones
- **Fortalezas**: 10 restricciones bien identificadas y categorizadas en tres grupos (Integridad Critica, Unicidad, Negocio). Incluye NOT NULL en campos criticos, UNIQUE en RFC, Placas y Licencias, CHECK para precios (Precio_Venta > Precio_Compra), stock no negativo, cantidades positivas, y licencia vigente. La restriccion UNIQUE(ID_Vehiculo, Fecha) en Mantenimientos es una decision inteligente.
- **Debilidades**: Falta especificar restricciones ON DELETE/ON UPDATE en las claves foraneas. No se menciona explicitamente la integridad referencial con acciones en cascada o restriccion. Se descuentan 2 puntos.

#### Queries SQL
- **Fortalezas**: 6 queries completas y de alta calidad. Uso avanzado de SQL: NOT EXISTS para pedidos sin ruta (query A), COALESCE con CASE para clasificacion de carga (query B), COUNT(DISTINCT) y SUM (query C), STRING_AGG para concatenar incidencias (query D), TO_CHAR para formateo monetario (query E), y DISTINCT ON para el pedido mas reciente (query F). Todas las queries usan JOINs correctos y GROUP BY apropiado. La cobertura de las 6 queries requeridas del caso es completa.
- **Debilidades**: Minima: en la query D se filtra por r.Estado_Ruta = 'Completada' pero en el esquema la columna se llama Estado_Ruta (consistente), aunque en la VIEW 2 se usa r.Estado = 'Completada'. Inconsistencia menor en nombre de columna. Se descuenta 1 punto.

#### VIEWS
- **Fortalezas**: 5 VIEWS excepcionales que cubren todos los reportes requeridos. VIEW 1 (Reporte Zonas) usa FILTER, NULLIF y HAVING con umbral justificado. VIEW 2 (Productividad Conductores) clasifica con CASE y maneja division por cero con NULLIF. VIEW 3 (Inventario Critico) usa CTE (WITH), COALESCE, y logica sofisticada para stock muerto vs critico vs precaucion. VIEW 4 (Rentabilidad Proveedor) calcula margen porcentual con NULLIF. VIEW 5 (Utilizacion Flota) usa LEFT JOIN con filtro temporal en el JOIN y CASE para clasificacion. Todas usan CREATE VIEW correctamente y son coherentes con el esquema.
- **Debilidades**: Ninguna significativa. Trabajo de nivel profesional.

#### Justificacion de Diseno
- **Fortalezas**: Justificacion solida y bien articulada. La respuesta a "por que este caso" menciona tres desafios tecnicos concretos (integridad transaccional, relaciones N-N reales, SQL avanzado). La respuesta a "por que asi" detalla tres decisiones de diseno con razonamiento tecnico: tabla ASIGNACION_PEDIDOS_RUTA para historial, estados calculados dinamicamente, y separacion de entradas/salidas.
- **Debilidades**: La decision de "estados calculados" (deducir estado del pedido dinamicamente) es interesante pero no se refleja completamente en el esquema, ya que la tabla Pedidos si tiene un campo "Estado" como enum. Ligera inconsistencia entre la justificacion y la implementacion. Se descuenta 1 punto.

---

### Preguntas de Seguimiento

1. **[COMPRENSION]**
   - Pregunta: En su diseno, la tabla ASIGNACION_PEDIDOS_RUTA tiene campos como Orden_Visita, Incidencia y Firma_Digital. Expliquen como funciona el flujo de datos cuando un conductor sale a entregar: que pasa en esta tabla desde que se asigna el pedido hasta que se completa la entrega.
   - Respuesta esperada: Deben explicar que primero se crea el registro con ID_Ruta e ID_Pedido y el Orden_Visita. Incidencia y Firma_Digital comienzan como NULL. Al llegar al comercio, si la entrega es exitosa se registra la Firma_Digital. Si hay problemas se registra la Incidencia (ej. "Casa cerrada", "Producto danado"). El estado se deduce de estos campos.

2. **[FALENCIAS]**
   - Pregunta: Su modelo no tiene una tabla de Categorias de productos ni una relacion N-N entre Proveedores y Productos. Si un mismo producto (ej. "Leche entera 1L") puede ser suministrado por dos proveedores diferentes con precios distintos, su modelo actual lo soportaria? Que problemas surgirian?
   - Respuesta esperada: Deben reconocer que actualmente un producto solo tiene un ID_Proveedor (relacion 1-N), asi que no pueden registrar dos proveedores para el mismo producto. Tendrian que crear productos duplicados o agregar una tabla puente Proveedor_Producto. NOTA: Su esquema SI tiene tabla Categorias, pero la relacion Proveedor-Producto es 1-N.

3. **[MEJORA]**
   - Pregunta: Si la distribuidora decidiera expandirse a 10 estados y tener 5 almacenes regionales en lugar de uno central, que cambios harian a su diseno?
   - Respuesta esperada: Deberian mencionar agregar una tabla Almacenes, modificar Entradas_Almacen para incluir ID_Almacen, ajustar el inventario por almacen, y posiblemente crear transferencias entre almacenes. Las Zonas necesitarian vincularse a almacenes especificos.

4. **[DECISION]**
   - Pregunta: Ustedes mencionan que el estado de un pedido se "deduce dinamicamente" en lugar de guardarlo manualmente. Sin embargo, su tabla Pedidos tiene un campo Estado de tipo enum. Cual fue la decision final: guardar el estado o calcularlo? Por que?
   - Respuesta esperada: Deben clarificar si el campo Estado en Pedidos es redundante o si es el estado calculado que se actualiza via trigger/aplicacion. La inconsistencia entre la justificacion y el esquema sugiere que inicialmente pensaron en calcularlo pero optaron por guardarlo. Deben justificar la decision final.

5. **[APLICACION]**
   - Pregunta: Usando su VIEW v_Inventario_Critico, si un producto tiene Stock_Actual = 100 y Total_Vendido_30Dias = 0, que resultado mostraria la vista? Y si tiene Stock_Actual = 50 y ventas de 150 en 30 dias?
   - Respuesta esperada: Caso 1: Total_Vendido_30Dias = 0, entonces COALESCE(0,0) = 0, entra en el WHEN = 0 y muestra "ALERTA: Stock Muerto (Sin ventas)" con Dias_Duracion_Estimada = NULL. Caso 2: 150/30 = 5 unidades diarias, 50/5 = 10 dias de duracion, como 10 < 15 muestra "CRITICO (< 15 Dias)" con Dias_Duracion_Estimada = 10.0.

---

### Observaciones Adicionales
Este es uno de los mejores trabajos del grupo. Demuestra un dominio avanzado de SQL con uso de FILTER, CTE, DISTINCT ON, STRING_AGG, NULLIF, COALESCE y CASE. El esquema es completo y bien normalizado. La justificacion es coherente y demuestra comprension profunda de los trade-offs de diseno. La unica area de mejora notable es la relacion Proveedor-Producto que podria beneficiarse de ser N-N.

**NOTA**: Esta evaluacion aplica tambien a las carpetas duplicadas EXAMEN1_SYSDES__5B_243742-243708-243713 (1) y EXAMEN1_SYSDES__5B_243742-243708-243713 (2), que contienen exactamente los mismos archivos.
