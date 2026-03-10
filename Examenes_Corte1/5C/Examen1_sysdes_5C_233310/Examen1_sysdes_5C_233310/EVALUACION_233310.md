═══════════════════════════════════════════════════════════════
EVALUACIÓN: 233310
Caso: 2-A - Marketplace de Productos Artesanales
Integrantes: 1 (Individual)
═══════════════════════════════════════════════════════════════

PUNTUACIÓN POR SECCIÓN
──────────────────────────────────────────────────────────────
Modelo ER + Esquema:    27/30
Restricciones:          18/20
Queries SQL:            24/25
VIEWS:                  14/15
Justificación:          10/10
──────────────────────────────────────────────────────────────
TOTAL:                  93/100
CALIFICACIÓN:           10/10
PORCENTAJE FINAL:       13.95% de 15%
═══════════════════════════════════════════════════════════════

RETROALIMENTACIÓN

[Modelo ER + Esquema]
• Fortalezas: Excelente trabajo. Presenta tanto diagrama ER (notación Chen) como diagrama relacional, ambos coherentes entre sí. Las 5 tablas (artesanos, productos, pedidos, detalle_pedido, reseñas) cubren todos los requisitos del caso individual (mínimo 5). La tabla puente "contiene/detalle_pedido" resuelve correctamente la relación N-N entre pedidos y productos. Las claves primarias están bien definidas con SERIAL. Las claves foráneas son correctas (artesano_id en productos, pedido_id y producto_id en detalle_pedido, producto_id en reseñas). El precio histórico en detalle_pedido demuestra comprensión avanzada de integridad transaccional. Cardinalidades correctamente representadas (1:N entre artesano-producto, 1:N entre producto-reseña, N:N entre pedido-producto vía detalle_pedido).
• Debilidades: No existe una entidad separada para "Comprador" — los datos del comprador (email, nombre) están embebidos en la tabla pedidos, lo cual genera redundancia si un mismo comprador hace múltiples pedidos. Sin embargo, para el alcance individual de 5 tablas, esta decisión es aceptable y el estudiante la reconoce implícitamente. El campo "subtotal" en la tabla producto del diagrama relacional es redundante (puede calcularse), aunque en detalle_pedido tiene sentido como dato histórico.

[Restricciones]
• Fortalezas: Uso extensivo y correcto de restricciones. NOT NULL en campos críticos (nombre, comunidad, email, precio_actual). UNIQUE en email de artesano y combinación comprador_email+producto_id en reseñas. CHECK constraints bien aplicados: precio >= 0, calificación BETWEEN 1 AND 5, categoría IN (...), cantidad > 0, estado_pedido IN (...), estado_envío IN (...). Integridad referencial con REFERENCES en todas las FK. DEFAULT values apropiados (CURRENT_TIMESTAMP, true para activo, 'pendiente' para estado_envío). Índices de optimización adicionales demuestran conocimiento avanzado.
• Debilidades: Ninguna significativa. Cumple holgadamente el mínimo de 4 restricciones para trabajo individual.

[Queries SQL]
• Fortalezas: 9 consultas completas y funcionales, muy por encima del mínimo. Sintaxis PostgreSQL correcta. JOINs variados y apropiados (JOIN, LEFT JOIN). Agregaciones bien usadas (COUNT, SUM, AVG, COUNT(DISTINCT)). GROUP BY con HAVING correctamente aplicado (ej: HAVING COUNT(r.id) >= 3). Uso avanzado de CASE WHEN, NULLIF para evitar división por cero, casteo ::DECIMAL. Consultas cubren múltiples escenarios del negocio: ventas por categoría, reporte por artesano, calificaciones, estado de envíos, ingresos por periodo, compradores top. LIMIT para top 10.
• Debilidades: Mínimas. Alguna consulta podría beneficiarse de subconsultas para obtener "el más vendido por categoría" en lugar de solo ordenar.

[VIEWS]
• Fortalezas: 3 VIEWS bien implementadas (mínimo 2 para individual). VIEW 1 (ventas por artesano) usa JOINs y agregaciones con cálculo de comisión del 12%. VIEW 2 (productos mejor calificados) usa LEFT JOIN, AVG, HAVING >= 3 con justificación estadística del umbral. VIEW 3 (clasificación de velocidad de pago) usa CASE con INTERVAL, demostrando manejo de tipos temporales. Sintaxis CREATE VIEW correcta. CASE/COALESCE presentes. Coherencia total con el esquema.
• Debilidades: La VIEW 2 usa LEFT JOIN en reseñas pero luego filtra con HAVING COUNT >= 3, lo cual efectivamente la convierte en INNER JOIN; no es incorrecto, pero el LEFT JOIN no aporta en ese contexto.

[Justificación]
• Comentarios: Justificación sobresaliente. Responde claramente ambas preguntas obligatorias con profundidad. Las 5 decisiones de diseño están explicadas con razonamientos técnicos sólidos: precio histórico en detalle_pedido, estado de envío independiente, categorías como CHECK (con reconocimiento explícito del trade-off), restricción de reseña única. Incluye análisis de trade-offs (flexibilidad vs performance), escenarios concretos del caso (Don Manuel, Doña Rosa, María) y hasta casos de uso con scripts SQL de prueba. Menciona que es un modelo similar a Etsy/MercadoLibre. La sección de casos de uso y pruebas es un valor agregado excepcional.

──────────────────────────────────────────────────────────────
PREGUNTAS DE SEGUIMIENTO PARA DEFENSA
──────────────────────────────────────────────────────────────

1. [COMPRENSIÓN]
   Pregunta: En tu tabla detalle_pedido incluiste artesano_id como FK además de producto_id. Dado que el artesano ya se puede obtener vía producto.artesano_id, ¿por qué decidiste incluir esta redundancia controlada? ¿Qué pasa si un artesano transfiere un producto a otro artesano?
   Respuesta esperada: Es una desnormalización intencional para evitar un JOIN adicional en consultas de ventas por artesano. Si un producto cambiara de artesano, el detalle_pedido conservaría el artesano original que vendió. Idealmente se podría manejar solo con producto_id y hacer el JOIN, pero para reportes de comisiones frecuentes, tener artesano_id directamente mejora el rendimiento.

2. [FALENCIAS]
   Pregunta: Tu modelo no tiene una tabla de Compradores — los datos de comprador están en la tabla pedidos (comprador_email, comprador_nombre). Si María cambia su nombre, ¿cómo afecta esto a los pedidos históricos? ¿Qué problema de normalización presenta esto?
   Respuesta esperada: Viola la 2da forma normal, ya que comprador_nombre depende de comprador_email, no de la PK del pedido. Si María cambia su nombre, los pedidos antiguos conservarían el nombre viejo (lo cual podría ser deseable para auditoría) o habría que actualizar múltiples registros. La solución sería una tabla Comprador separada con email como PK o UNIQUE, pero se sacrificó por el límite de 5 tablas.

3. [MEJORA]
   Pregunta: Tu VIEW vista_pedidos_clasificados clasifica la velocidad de pago. Si el negocio quisiera agregar una cuarta categoría "Muy Tardío" (más de 7 días) y además filtrar solo pedidos del último trimestre, ¿cómo modificarías la vista?
   Respuesta esperada: Agregaría un WHEN adicional en el CASE: WHEN fecha_pago - fecha_pedido > INTERVAL '7 days' THEN 'Muy Tardío'. Y agregaría un WHERE fecha_pedido >= CURRENT_DATE - INTERVAL '3 months' antes del ORDER BY. También habría que reordenar los WHEN para que el más restrictivo vaya primero.

4. [DECISIÓN]
   Pregunta: Decidiste usar CHECK constraint para categorías en lugar de una tabla separada. Si mañana el marketplace crece a 50 categorías y cada una necesita un ícono, descripción y traducción al inglés, ¿cuál sería el costo de migración? Descríbeme los pasos SQL necesarios.
   Respuesta esperada: Habría que: 1) CREATE TABLE categorías (id SERIAL PK, nombre VARCHAR, ícono VARCHAR, descripción TEXT, nombre_en VARCHAR). 2) INSERT INTO categorías los valores existentes. 3) ALTER TABLE productos ADD COLUMN categoría_id INTEGER REFERENCES categorías(id). 4) UPDATE productos SET categoría_id según el nombre. 5) ALTER TABLE productos DROP CONSTRAINT del CHECK y DROP COLUMN categoría. El costo es medio — requiere migración de datos pero no pierde información.

5. [APLICACIÓN]
   Pregunta: En tu caso de uso, muestras que María no puede reseñar el huipil porque aún no se ha entregado. Sin embargo, esa validación no está implementada a nivel de base de datos (solo dice "lógica de aplicación"). ¿Cómo implementarías esa restricción directamente en la BD usando un TRIGGER o CHECK?
   Respuesta esperada: Un CHECK constraint no puede referenciar otra tabla. Se necesitaría un TRIGGER BEFORE INSERT en reseñas que verifique: SELECT estado_envío FROM detalle_pedido WHERE producto_id = NEW.producto_id AND pedido_id IN (SELECT id FROM pedidos WHERE comprador_email = NEW.comprador_email) = 'entregado'. Si no encuentra una entrega completada, lanza RAISE EXCEPTION. Alternativamente, se podría usar una función almacenada.

═══════════════════════════════════════════════════════════════
VALIDACIÓN DOCENTE: ✅ EVALUACIÓN VÁLIDA
═══════════════════════════════════════════════════════════════
