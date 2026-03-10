═══════════════════════════════════════════════════════════════
EVALUACIÓN: 243790
Caso: 2-C - Registro de Licencias de Conducir
Integrantes: 1 (Individual)
═══════════════════════════════════════════════════════════════

PUNTUACIÓN POR SECCIÓN
──────────────────────────────────────────────────────────────
Modelo ER + Esquema:    22/30
Restricciones:          13/20
Queries SQL:            5/25
VIEWS:                  4/15
Justificación:          7/10
──────────────────────────────────────────────────────────────
TOTAL:                  51/100
CALIFICACIÓN:           6/10
PORCENTAJE FINAL:       7.65% de 15%
═══════════════════════════════════════════════════════════════

RETROALIMENTACIÓN

[Modelo ER + Esquema]
• Fortalezas: 5 tablas definidas: citizens, applications, exams, evaluators, licenses. Cumple el mínimo de 5 para trabajo individual. Presenta tanto el modelo conceptual ER (imagen ModeloConceptual-ER.png) como el esquema relacional (imagen ER.png). Buena distinción entre ambos niveles. El modelo conceptual muestra entidades, relaciones (realiza, genera, requiere, aplica, posee) y cardinalidades con notación clara. Incluye notas de reglas de negocio en el diagrama conceptual (solo una licencia vigente por ciudadano, ambos exámenes para aprobar, evaluadores aplican según especialidad, historial completo). Cardinalidades correctamente identificadas y documentadas. Claves primarias en todas las tablas. CURP como UNIQUE pero no PK (buena decisión documentada). Relación citizens->licenses (1 a muchos) para historial, pero con restricción de solo una vigente.
• Debilidades: El esquema relacional (ER.png) es de baja resolución y difícil de leer. No se presentan los tipos de datos detallados de cada columna en el reporte. Falta una tabla de Tipo_Licencia que el caso del dominio requiere (tipos A, B, C mencionados en las applications pero no normalizados en tabla separada). Las tablas usan nombres en inglés mientras los diagramas conceptuales mezclan español.

[Restricciones]
• Fortalezas: Restricciones mencionadas: CURP única, número de licencia único, tipo de examen limitado a médico/teórico, estados controlados, FK en todas las relaciones. Índice UNIQUE parcial sobre licenses cuando vigente = TRUE. Solución técnica avanzada y elegante para la regla de una licencia vigente por ciudadano. Es la mejor implementación de esta regla entre todos los equipos del caso 2-C. Se mencionan las 5 restricciones básicas requeridas para trabajo individual.
• Debilidades: Las restricciones se describen solo como lista de bullets, sin código SQL que las implemente. No se presentan CHECK constraints con detalle. Faltan NOT NULL explícitos documentados. No hay restricciones de negocio más allá de la licencia vigente.

[Queries SQL]
• Fortalezas: 4 queries documentadas con descripción de lo que hacen y para qué sirven. Query 1: JOIN para ciudadanos con licencia vigente. Query 2: GROUP BY + HAVING para exámenes por evaluador. Query 3: CASE + COALESCE para estadísticas por tipo de examen. Query 4: HAVING para solicitudes listas para licencia. Las descripciones demuestran comprensión conceptual de SQL avanzado.
• Debilidades: CRÍTICO: No se incluye el código SQL de NINGUNA consulta. Solo se describen textualmente ("Uso JOIN porque...", "Se usa GROUP BY para..."). Esto imposibilita evaluar la sintaxis, los JOINs apropiados, y la corrección técnica. En un examen de Base de Datos Avanzada se requiere evidencia de código funcional. Se otorga crédito parcial (5/25) por la comprensión conceptual demostrada en las descripciones textuales.

[VIEWS]
• Fortalezas: 3 VIEWS mencionadas: v_tasa_aprobación, v_licencias_por_vencer, v_rendimiento_evaluadores. Cumple el mínimo de 2 VIEWS y supera con 3. Las descripciones indican uso de LEFT JOIN, COALESCE, y agregaciones.
• Debilidades: CRÍTICO: Al igual que las queries, las VIEWS no incluyen código SQL. Solo descripción textual. No se puede evaluar: sintaxis CREATE VIEW, agregaciones correctas, uso de HAVING, uso de CASE/COALESCE. Se otorga crédito parcial (4/15) por la identificación conceptual correcta de las vistas necesarias.

[Justificación]
• Comentarios: Justificación clara del caso: flujo claro (ciudadano -> solicitud -> exámenes -> licencia), facilidad de explicación para trabajo individual. Menciona historial de solicitudes, reglas de negocio reales, y vistas con agregaciones. Sección de "Decisiones de Diseño": 5 tablas para simplicidad, exámenes en una sola tabla con tipo_examen, separación solicitudes/licencias, estados en texto, índice UNIQUE parcial. La justificación de "por qué lo diseñaron así" es breve y repite ideas de la sección de modelo. Falta análisis de alternativas descartadas.

──────────────────────────────────────────────────────────────
PREGUNTAS DE SEGUIMIENTO PARA DEFENSA
──────────────────────────────────────────────────────────────

1. [COMPRENSIÓN]
   Pregunta: Tu modelo tiene la relación citizens -> licenses como 1 a muchos, pero también applications -> licenses como 1 a 1. Explica cómo se vinculan estas dos relaciones y por qué un ciudadano puede tener muchas licencias si cada solicitud solo genera una.
   Respuesta esperada: Un ciudadano puede hacer múltiples solicitudes a lo largo del tiempo (renovaciones, intentos fallidos previos). Cada solicitud aprobada genera exactamente una licencia (1 a 1). Pero como el ciudadano puede tener múltiples solicitudes aprobadas en diferentes momentos, acumula múltiples licencias históricas. La restricción de negocio es que solo una puede estar vigente (vigente = TRUE), controlada por el índice UNIQUE parcial. Las licencias anteriores quedan con vigente = FALSE como historial.

2. [FALENCIAS]
   Pregunta: En tu documento mencionas 4 queries y 3 VIEWS pero no incluyes el código SQL de ninguno. Escribe ahora mismo el código SQL de tu Query 2 (Exámenes por evaluador con GROUP BY + HAVING).
   Respuesta esperada: SELECT ev.nombre AS evaluador, COUNT(e.exam_id) AS total_examenes, SUM(CASE WHEN e.resultado = 'aprobado' THEN 1 ELSE 0 END) AS aprobados FROM evaluators ev JOIN exams e ON ev.evaluator_id = e.evaluator_id GROUP BY ev.evaluator_id, ev.nombre HAVING COUNT(e.exam_id) > 0 ORDER BY total_examenes DESC;

3. [MEJORA]
   Pregunta: Tu modelo no incluye una tabla de Tipo_Licencia (A, B, C), aunque en la sección de applications mencionas el tipo de licencia. ¿Cómo agregarías esta tabla y qué campos tendría?
   Respuesta esperada: Crearía una tabla license_types con campos: license_type_id (PK), nombre (varchar, UNIQUE, valores como 'A', 'B', 'C'), descripción, duración_años (int), costo (decimal), requisitos_edad_mínima (int). Luego agregaría una FK license_type_id en la tabla applications. Esto normalizaría el tipo de licencia, evitaría repetir información como duración y costo en cada solicitud, y permitiría agregar nuevos tipos sin modificar la estructura.

4. [DECISIÓN]
   Pregunta: Mencionas que usaste un índice UNIQUE parcial en vez de un trigger para controlar la licencia vigente. Explica la diferencia técnica entre ambos enfoques y por qué el índice parcial es preferible.
   Respuesta esperada: El índice UNIQUE parcial (CREATE UNIQUE INDEX idx_licencia_vigente ON licenses(citizen_id) WHERE vigente = TRUE) es declarativo: la base de datos rechaza automáticamente cualquier INSERT o UPDATE que viole la condición. Un trigger sería procedural: ejecutaría código que verifica y lanza excepción. El índice es preferible porque: (1) es más eficiente (la verificación ocurre a nivel de índice B-tree), (2) es inmune a errores de programación en el trigger, (3) es más fácil de mantener, (4) funciona incluso en operaciones batch. El trigger podría tener condiciones de carrera en transacciones concurrentes si no se maneja correctamente.

5. [APLICACIÓN]
   Pregunta: Si la Secretaría de Movilidad te pidiera agregar un proceso de renovación de licencia donde el ciudadano no necesita repetir el examen médico si fue aprobado en los últimos 2 años, ¿cómo modelarías esta lógica?
   Respuesta esperada: En la tabla exams ya se guarda la fecha del examen y el resultado. Al crear una nueva solicitud de renovación, el sistema consultaría: SELECT * FROM exams WHERE application_id IN (SELECT application_id FROM applications WHERE citizen_id = X) AND tipo_examen = 'médico' AND resultado = 'aprobado' AND fecha_examen >= CURRENT_DATE - INTERVAL '2 years'. Si encuentra un resultado, se podría crear el registro de examen médico en la nueva solicitud como "exento" o reusar el resultado. También se podría agregar un campo "exento_médico" (boolean) en la tabla applications para marcar este caso.

═══════════════════════════════════════════════════════════════
VALIDACIÓN DOCENTE: ⚠️ EVALUACIÓN CORREGIDA
Correcciones aplicadas por inconsistencia con criterios de otros equipos:
- Queries: 12/25 → 5/25 (cero código SQL; crédito parcial por descripciones textuales)
- VIEWS: 8/15 → 4/15 (cero código SQL; equiparado con criterio de Equipo 2)
- Total: 62 → 51/100 | Calificación: 7 → 6/10 | Porcentaje: 9.30 → 7.65%
═══════════════════════════════════════════════════════════════
