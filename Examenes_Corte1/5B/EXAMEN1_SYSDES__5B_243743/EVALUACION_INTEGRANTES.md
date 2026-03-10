# Evaluacion: 243743 - 243763 - 243726
## Caso: 3-A - Logistica de Distribucion Regional
### Integrantes: 3 (Rudi Fabricio Martinez Jaimes 243763, Gonzalez Ruiz Andres Eduardo 243726, Mora Mercado Fernando 243743)

---

### Resumen de Puntuacion

| Seccion | Puntos Obtenidos | Puntos Maximos | Porcentaje |
|---------|------------------|----------------|------------|
| Modelo ER + Esquema | 26 | 30 | 87% |
| Restricciones | 16 | 20 | 80% |
| Queries SQL | 18 | 25 | 72% |
| VIEWS | 13 | 15 | 87% |
| Justificacion | 9 | 10 | 90% |
| **TOTAL** | **82** | **100** | **82%** |

### Calificacion Final (este evaluador): 8.2 / 10

## PUNTUACION RECONCILIADA (Escala Lineal + Rangos)

> **Nota del Docente:** Este equipo fue evaluado por 2 evaluadores distintos (carpetas 243726 y 243743) con puntuaciones de 71 y 82. Se aplica promedio lineal y luego rangos.
>
> **Promedio lineal:** (71 + 82) / 2 = **77/100**
> **Rango aplicado:** 70-79 = **Calificacion: 8.0/10**

### **CALIFICACION RECONCILIADA: 8.0/10**
### **PUNTUACION RECONCILIADA: 77/100**
### Porcentaje Final: 11.55% de 15%

---

### Retroalimentacion por Seccion

#### Modelo ER + Esquema Relacional
- **Fortalezas**: Esquema bien estructurado con aproximadamente 14 tablas creadas en dbdiagram.io. Incluye las entidades principales esperadas: Proveedores, Productos, Categorias, Comercios, Zonas, Pedidos, Vehiculos, Conductores, Rutas. Las dos relaciones N-N estan correctamente implementadas: Detalle_Pedido (Pedido-Producto) y Ruta_Pedidos (Ruta-Pedido con orden_entrega). La tabla Incidencias vinculada a Detalle_Pedido es una decision de diseno interesante que permite rastrear problemas a nivel de producto especifico. El campo precio_venta_historico en Detalle_Pedido muestra buena comprension de la preservacion de datos historicos.
- **Debilidades**: La tabla Entradas_Almacen no tiene una tabla de detalle (Detalle_Entrada) - solo registra id_proveedor, id_producto, cantidad y fecha. Esto limita registrar multiples productos en una sola entrada de almacen (-2 pts). El esquema muestra NN (NOT NULL) en muchos campos pero no se definen explicitamente los constraints UNIQUE ni CHECK en el diagrama (-2 pts).

#### Restricciones
- **Fortalezas**: El informe menciona 10 restricciones clave incluyendo CHECK para stocks negativos y precio_venta > precio_compra, UNIQUE en RFC y Licencia, y NOT NULL en claves foraneas. La organizacion en categorias (CHECK, UNIQUE, NOT NULL) es clara.
- **Debilidades**: Las restricciones se mencionan de manera general en el informe pero no se detallan con sintaxis SQL especifica ni se listan tabla por tabla. No se especifican acciones ON DELETE/ON UPDATE. Falta detalle en la implementacion concreta (-4 pts).

#### Queries SQL
- **Fortalezas**: El informe no incluye queries SQL explicitas como codigo. Sin embargo, las VIEWS contienen logica SQL valida que demuestra conocimiento de JOINs, agregaciones y GROUP BY.
- **Debilidades**: No se presentan las 6 queries requeridas del caso como consultas independientes. El informe se enfoca en las fases del proyecto y la justificacion pero omite la seccion de queries SQL de ejemplo. Esto es una omision significativa (-7 pts). Se otorgan puntos parciales por la logica SQL demostrada en las VIEWS.

#### VIEWS
- **Fortalezas**: 5 VIEWS implementadas con CREATE VIEW correctamente. Vista 1 (resumen_zonas) usa SUM con CASE, NULLIF y HAVING. Vista 2 (inventario_critico) usa COALESCE y CASE para manejo de cero ventas. Vista 3 (productividad_conductores) incluye LEFT JOIN con subconsulta para peso promedio por ruta. Vista 4 (rentabilidad_proveedor) usa precio historico para calculo de margen. Vista 5 (utilizacion_flota) clasifica con CASE. Todas son coherentes con el esquema.
- **Debilidades**: Algunos problemas de encoding en los strings (ej. "OperaciA3n Optima" en lugar de "Operacion Optima", "EstA;ndar" en lugar de "Estandar"). La vista de inventario critico no filtra por periodo temporal en las ventas, lo cual podria dar resultados distorsionados (-2 pts).

#### Justificacion de Diseno
- **Fortalezas**: Justificacion excelente y bien estructurada. Se organiza en fases del proyecto (Analisis, Arquitectura, Pruebas, Inteligencia de Negocio). La respuesta a "por que este caso" menciona la alta demanda de logica relacional y las tres dimensiones (Inventario, Comercial, Operativa). La respuesta a "por que asi" detalla tres decisiones concretas: desacoplamiento operativo via tabla puente, preservacion de historicos en Detalle_Pedido, y gestion atomica de incidencias. Mencion explicita de 3FN.
- **Debilidades**: Minimas. La justificacion es una de las mas solidas del grupo. Solo se descuenta 1 punto porque la narracion en fases, aunque clara, no aborda explicitamente trade-offs descartados.

---

### Preguntas de Seguimiento

1. **[COMPRENSION]**
   - Pregunta: En su diagrama, la tabla Incidencias esta vinculada a Detalle_Pedido (no directamente al Pedido o la Ruta). Expliquen por que tomaron esta decision y como registrarian una incidencia donde 20kg de queso llegaron danados en una entrega.
   - Respuesta esperada: Deben explicar que vincular incidencias a Detalle_Pedido permite identificar exactamente cual producto tuvo el problema. Para el caso del queso, se crearia un registro en Incidencias con id_detalle_pedido apuntando al renglon de queso, cantidad_danada = 20, y un motivo descriptivo. Esto permite analizar patrones por producto y proveedor.

2. **[FALENCIAS]**
   - Pregunta: Su tabla Entradas_Almacen registra un solo producto por entrada (id_producto directo en la tabla). Si un camion del proveedor llega con 10 productos diferentes en la misma carga, como lo registrarian en su modelo actual?
   - Respuesta esperada: Deben reconocer que tendrian que crear 10 registros separados en Entradas_Almacen, uno por cada producto. La solucion correcta seria tener una tabla Detalle_Entrada (como en otros equipos) para registrar multiples productos bajo una misma entrada.

3. **[MEJORA]**
   - Pregunta: Sus VIEWS no incluyen filtros temporales en algunas (ej. inventario critico no filtra ventas por periodo). Como mejorarian la vista de inventario critico para que solo considere ventas de los ultimos 30 dias?
   - Respuesta esperada: Deberian agregar un WHERE o un filtro en el JOIN con Detalle_Pedido que limite a pedidos donde fecha_pedido >= CURRENT_DATE - INTERVAL '30 days'. Sin este filtro, la vista considera todas las ventas historicas, distorsionando el calculo de cobertura.

4. **[DECISION]**
   - Pregunta: Ustedes crearon una tabla Ruta_Pedidos separada de la tabla Incidencias. Otra alternativa seria poner los campos de incidencia directamente en Ruta_Pedidos. Por que eligieron separarlas?
   - Respuesta esperada: Deben justificar que la separacion permite que una incidencia tenga multiples registros detallados por producto (a nivel de Detalle_Pedido), mientras que Ruta_Pedidos solo maneja el orden logistico. Ademas, no todas las entregas tienen incidencias, asi que separar evita campos NULL innecesarios.

5. **[APLICACION]**
   - Pregunta: Usando su vista vista_rentabilidad_proveedor, si un proveedor vende productos con precio_compra = 50 y precio_venta_historico = 80, y se vendieron 100 unidades, cual seria el margen porcentual que mostraria la vista?
   - Respuesta esperada: costo_ventas = 100 * 50 = 5000, ventas_totales = 100 * 80 = 8000, margen_bruto_ganancia = 8000 - 5000 = 3000, margen_porcentual = ROUND((3000 / NULLIF(8000, 0)) * 100, 2) = 37.50%.

---

### Observaciones Adicionales
Trabajo solido con un esquema bien pensado y una justificacion destacable. La principal debilidad es la ausencia de queries SQL independientes como seccion del documento, lo que afecta significativamente la puntuacion en ese rubro. Las VIEWS son buenas pero tienen problemas menores de encoding de caracteres. La decision de vincular incidencias a nivel de detalle de pedido es una decision de diseno sofisticada.

**NOTA IMPORTANTE**: Esta entrega es del mismo equipo que la carpeta EXAMEN1_SYSDES__5B_243763 (Folder 18) y EXAMEN1_SYSDES__5B_243726. El contenido es esencialmente identico. Se aplica la misma evaluacion.
