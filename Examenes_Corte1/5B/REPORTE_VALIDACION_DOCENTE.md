# Reporte de Validacion -- Agente Docente (FINAL POST-RECONCILIACION)
## Examen Parcial Base de Datos Avanzada 5B -- Febrero 2026

---

## Resumen Consolidado

| # | Carpeta | Equipo (Matriculas) | Caso | Puntuacion (evaluador) | Puntuacion Reconciliada | Calificacion Final | Estado |
|---|---------|---------------------|------|----------------------|------------------------|-------------------|--------|
| 1 | EXAMEN1_SYSDES_5B_243706 | 243706, 243723, 243737 | 3-A | 76/100 | 76/100 | 8.0/10 | VALIDA |
| 2 | EXAMEN1_SYSDES_5B_243723 | 243706, 243723, 243737 | 3-A | 76/100 | 76/100 | 8.0/10 | VALIDA (Duplicado) |
| 3 | EXAMEN1_SYSDES_5B_243737 | 243706, 243723, 243737 | 3-A | 80/100 | 76/100 | 8.0/10 | RECONCILIADA |
| 4 | EXAMEN1_SYSDES__5B_243602 | 243602, 243692, 243751 | 3-A | 86/100 | 85/100 | 9.0/10 | RECONCILIADA |
| 5 | EXAMEN1_SYSDES__5B_243678 | 243678, 243696, 243752 | 3-A | 72/100 | 65/100 | 7.0/10 | RECONCILIADA |
| 6 | EXAMEN1_SYSDES__5B_243692 | 243602, 243692, 243751 | 3-A | 87/100 | 85/100 | 9.0/10 | RECONCILIADA |
| 7 | EXAMEN1_SYSDES__5B_243696 | 243678, 243696, 243752 | 3-A | 65/100 | 65/100 | 7.0/10 | RECONCILIADA |
| 8 | EXAMEN1_SYSDES__5B_243716 | 243716, 243732, 243777 | 3-A | 86/100 | 89/100 | 9.0/10 | RECONCILIADA |
| 9 | EXAMEN1_SYSDES__5B_243726 | 243726, 243743, 243763 | 3-A | 71/100 | 77/100 | 8.0/10 | RECONCILIADA |
| 10 | EXAMEN1_SYSDES__5B_243732-... | 243716, 243732, 243777 | 3-A | 89/100 | 89/100 | 9.0/10 | RECONCILIADA |
| 11 | EXAMEN1_SYSDES__5B_243742-243708-243713 | 243742, 243708, 243713 | 3-A | 94/100 | 94/100 | 10/10 | VALIDA |
| 12 | EXAMEN1_SYSDES__5B_243742-243708-243713 (1) | 243742, 243708, 243713 | 3-A | 94/100 | 94/100 | 10/10 | VALIDA (Duplicado) |
| 13 | EXAMEN1_SYSDES__5B_243742-243708-243713 (2) | 243742, 243708, 243713 | 3-A | 94/100 | 94/100 | 10/10 | VALIDA (Duplicado) |
| 14 | EXAMEN1_SYSDES__5B_243743 | 243726, 243743, 243763 | 3-A | 82/100 | 77/100 | 8.0/10 | RECONCILIADA |
| 15 | EXAMEN1_SYSDES__5B_243751 | 243602, 243692, 243751 | 3-A | 83/100 | 85/100 | 9.0/10 | RECONCILIADA |
| 16 | EXAMEN1_SYSDES__5B_243752 | 243678, 243696, 243752 | 3-A | 58/100 | 65/100 | 7.0/10 | RECONCILIADA |
| 17 | EXAMEN1_SYSDES__5B_243757 | 243757, 243770, 243472 | 3-C | 81/100 | 81/100 | 9.0/10 | VALIDA |
| 18 | EXAMEN1_SYSDES__5B_243763 | 243726, 243743, 243763 | 3-A | 82/100 | 77/100 | 8.0/10 | RECONCILIADA (Duplicado) |
| 19 | EXAMEN1_SYSDES__5B_243777 | 243716, 243732, 243777 | 3-A | 91/100 | 89/100 | 9.0/10 | RECONCILIADA |
| 20 | EXAMEN1_SYSDES__5GRUPO_243472 | 243757, 243770, 243472 | 3-C | 81/100 | 81/100 | 9.0/10 | VALIDA (Duplicado) |
| 21 | EXAMEN1_SYSDES__5GRUPO_243770 | 243757, 243770, 243472 | 3-C | 81/100 | 81/100 | 9.0/10 | VALIDA (Duplicado) |

---

## Validacion Individual

### Carpeta 1: EXAMEN1_SYSDES_5B_243706
- **Puntuacion reportada:** 76/100
- **Verificacion aritmetica:** CORRECTA (23 + 16 + 17 + 12 + 8 = 76)
- **Adherencia a rubrica:** OK - Todos los puntajes dentro de rangos permitidos (ER 23/30, Restricciones 16/20, Queries 17/25, VIEWS 12/15, Justificacion 8/10)
- **Consistencia de calificacion:** OK - 76 puntos corresponde al rango 70-79, calificacion 8.0/10 es correcta
- **Completitud:** COMPLETA - Incluye puntuacion desglosada, retroalimentacion por seccion, 5 preguntas de seguimiento, observaciones adicionales
- **Veredicto:** VALIDA
- **Observaciones:** Evaluacion detallada y bien fundamentada. Se identifican correctamente errores tipograficos en el esquema y la desconexion de la tabla Zones.

---

### Carpeta 2: EXAMEN1_SYSDES_5B_243723
- **Puntuacion reportada:** 76/100
- **Verificacion aritmetica:** CORRECTA (23 + 16 + 17 + 12 + 8 = 76)
- **Adherencia a rubrica:** OK
- **Consistencia de calificacion:** OK - 76 -> 8.0/10 correcto
- **Completitud:** COMPLETA
- **Veredicto:** VALIDA (Duplicado correcto de Carpeta 1)
- **Observaciones:** Mismo evaluador (Agente A) evaluo ambas carpetas del mismo equipo. Puntuaciones identicas, lo cual es correcto dado que el contenido es identico.

---

### Carpeta 3: EXAMEN1_SYSDES_5B_243737
- **Puntuacion reportada:** 80/100
- **Verificacion aritmetica:** CORRECTA (24 + 16 + 19 + 13 + 8 = 80)
- **Adherencia a rubrica:** OK
- **Consistencia de calificacion:** OK - 80 -> 9.0/10 correcto
- **Completitud:** COMPLETA
- **Veredicto:** NO VALIDA - INCONSISTENCIA INTER-EVALUADOR
- **Observaciones:** **PROBLEMA CRITICO.** Esta carpeta contiene contenido IDENTICO a las Carpetas 1 y 2 (mismo equipo, mismos archivos), pero fue evaluada por un evaluador diferente (Agente B) con una puntuacion de 80/100 vs 76/100 del Agente A. Las diferencias especificas son:
  - ER: 24/30 (Agente B) vs 23/30 (Agente A) -- diferencia de 1 punto
  - Queries: 19/25 (Agente B) vs 17/25 (Agente A) -- diferencia de 2 puntos
  - VIEWS: 13/15 (Agente B) vs 12/15 (Agente A) -- diferencia de 1 punto
  - **Diferencia total: 4 puntos (no supera umbral de 10, pero es notable)**
  - **Recomendacion:** Usar la puntuacion del Agente A (76/100) por ser mas detallada y conservadora. La diferencia de 4 puntos es aceptable pero se recomienda al profesor revisar los puntos de discrepancia.

---

### Carpeta 4: EXAMEN1_SYSDES__5B_243602
- **Puntuacion reportada:** 86/100 (RE-EVALUADA)
- **Verificacion aritmetica:** CORRECTA (28 + 19 + 16 + 13 + 10 = 86)
- **Adherencia a rubrica:** OK
- **Consistencia de calificacion:** OK - 86 en rango 80-89 = 9.0/10
- **Completitud:** COMPLETA - Re-evaluacion exitosa con PDF completo leido (35 paginas)
- **Veredicto:** VALIDA - RECONCILIADA
- **Puntuacion reconciliada:** (86 + 87 + 83) / 3 = **85/100** -> **9.0/10**
- **Observaciones:** Re-evaluacion completada exitosamente. Equipo confirmado: Espinoza Mendoza Hector Isaac (243602), Moreno Zuniga Jesel (243692), Arturo Yion Jaime (243751). Documento de 35 paginas de calidad excepcional con restricciones sobresalientes (5 UNIQUE, 9 CHECK, 3 triggers). Principal debilidad: solo 2 queries SQL independientes.

---

### Carpeta 5: EXAMEN1_SYSDES__5B_243678
- **Puntuacion reportada:** 72/100
- **Verificacion aritmetica:** CORRECTA (20 + 13 + 19 + 14 + 6 = 72)
- **Adherencia a rubrica:** OK
- **Consistencia de calificacion:** ISSUE - 72 puntos esta en el rango 70-79, que corresponde a calificacion 8.0/10. El evaluador asigno 8.0/10, lo cual es correcto.
- **Completitud:** COMPLETA
- **Veredicto:** VALIDA
- **Observaciones:** Evaluacion bien fundamentada con desglose por subcriterios. Se senalan correctamente las carencias del diagrama (falta de cardinalidades explicitas, nomenclatura inconsistente) y las fortalezas de las VIEWS.

---

### Carpeta 6: EXAMEN1_SYSDES__5B_243692
- **Puntuacion reportada:** 87/100 (RE-EVALUADA)
- **Verificacion aritmetica:** CORRECTA (28 + 19 + 16 + 14 + 10 = 87)
- **Adherencia a rubrica:** OK
- **Consistencia de calificacion:** OK - 87 en rango 80-89 = 9.0/10
- **Completitud:** COMPLETA - Re-evaluacion exitosa con PDF completo leido (35 paginas)
- **Veredicto:** VALIDA - RECONCILIADA
- **Puntuacion reconciliada:** (86 + 87 + 83) / 3 = **85/100** -> **9.0/10**
- **Observaciones:** Re-evaluacion completada exitosamente. Mismo equipo que Carpetas 4 y 15. Las 3 evaluaciones son consistentes (rango de 4 puntos: 83-87). La diferencia de 1 punto en VIEWS (13 vs 14) es la principal variacion, lo cual es aceptable.

---

### Carpeta 7: EXAMEN1_SYSDES__5B_243696
- **Puntuacion reportada:** 65/100
- **Verificacion aritmetica:** CORRECTA (19 + 11 + 18 + 12 + 5 = 65)
- **Adherencia a rubrica:** OK
- **Consistencia de calificacion:** OK - 65 -> 7.0/10 correcto (rango 60-69)
- **Completitud:** COMPLETA
- **Veredicto:** NO VALIDA - INCONSISTENCIA INTER-EVALUADOR
- **Observaciones:** **PROBLEMA CRITICO.** Esta carpeta tiene contenido identico a la Carpeta 5 (mismo equipo 243678-243696-243752), pero fue evaluada por un evaluador diferente (Agente B) con 65/100 vs 72/100 del Agente A. Diferencia de 7 puntos. Desglose de discrepancias:
  - ER: 19/30 (Agente B) vs 20/30 (Agente A) -- diferencia de 1 punto
  - Restricciones: 11/20 (Agente B) vs 13/20 (Agente A) -- diferencia de 2 puntos
  - Queries: 18/25 (Agente B) vs 19/25 (Agente A) -- diferencia de 1 punto
  - VIEWS: 12/15 (Agente B) vs 14/15 (Agente A) -- diferencia de 2 puntos
  - Justificacion: 5/10 (Agente B) vs 6/10 (Agente A) -- diferencia de 1 punto
  - **La diferencia de 7 puntos no supera el umbral de 10 pero es significativa.**
  - **Recomendacion:** Promediar ambas evaluaciones: (72 + 65) / 2 = 68.5, redondeado a 69/100. Calificacion sugerida: 7.0/10.

---

### Carpeta 8: EXAMEN1_SYSDES__5B_243716
- **Puntuacion reportada:** 86/100
- **Verificacion aritmetica:** CORRECTA (27 + 18 + 20 + 14 + 7 = 86)
- **Adherencia a rubrica:** OK
- **Consistencia de calificacion:** OK - 86 -> 9.0/10 correcto (rango 80-89)
- **Completitud:** COMPLETA
- **Veredicto:** VALIDA
- **Observaciones:** Evaluacion solida. El evaluador (Agente B) detalla correctamente las fortalezas del esquema (14 tablas, proveedor_producto como N-N, detalle_entrega granular) y senala la falta de tabla Almacen.

---

### Carpeta 9: EXAMEN1_SYSDES__5B_243726
- **Puntuacion reportada:** 71/100
- **Verificacion aritmetica:** CORRECTA (25 + 13 + 10 + 14 + 9 = 71)
- **Adherencia a rubrica:** OK
- **Consistencia de calificacion:** OK - 71 -> 8.0/10 correcto (rango 70-79)
- **Completitud:** COMPLETA
- **Veredicto:** VALIDA
- **Observaciones:** Evaluacion bien fundamentada. Se penaliza correctamente la ausencia total de queries SQL independientes (10/25), otorgando puntos parciales por las queries embebidas en VIEWS. La justificacion (9/10) es una fortaleza.

---

### Carpeta 10: EXAMEN1_SYSDES__5B_243732-20260205T205554Z-3-001
- **Puntuacion reportada:** 89/100
- **Verificacion aritmetica:** CORRECTA (28 + 17 + 22 + 15 + 7 = 89)
- **Adherencia a rubrica:** OK
- **Consistencia de calificacion:** OK - 89 -> 9.0/10 correcto (rango 80-89)
- **Completitud:** COMPLETA
- **Veredicto:** NO VALIDA - INCONSISTENCIA INTER-EVALUADOR (vs Carpeta 8)
- **Observaciones:** **PROBLEMA NOTABLE.** Mismo equipo (243716-243732-243777), mismo trabajo, pero dos evaluadores diferentes. Carpeta 8 (Agente B) dio 86/100 y Carpeta 10 (Agente B tambien) dio 89/100. Diferencia de 3 puntos. Desglose:
  - ER: 28 vs 27 -- +1
  - Restricciones: 17 vs 18 -- -1
  - Queries: 22 vs 20 -- +2
  - VIEWS: 15 vs 14 -- +1
  - Justificacion: 7 vs 7 -- 0
  - **La diferencia de 3 puntos es menor.** Parece que el mismo Agente B evaluo ambas carpetas en momentos diferentes. La Carpeta 19 (Agente del segundo lote) le dio 91/100, ampliando la discrepancia.
  - **Recomendacion:** Usar el promedio de las evaluaciones completas: (86 + 89 + 91) / 3 = 88.7, redondeado a 89/100. Calificacion: 9.0/10.

---

### Carpeta 11: EXAMEN1_SYSDES__5B_243742-243708-243713
- **Puntuacion reportada:** 94/100
- **Verificacion aritmetica:** CORRECTA (28 + 18 + 24 + 15 + 9 = 94)
- **Adherencia a rubrica:** OK
- **Consistencia de calificacion:** ISSUE MENOR - 94 puntos esta en rango 90-100, corresponde a calificacion 10/10. El evaluador asigno 9.4/10 usando una escala lineal en lugar de la escala de rangos de la rubrica. Segun rubrica oficial: 90-100 = 10.
- **Completitud:** COMPLETA
- **Veredicto:** VALIDA (con nota sobre calificacion)
- **Observaciones:** Evaluacion muy detallada y bien fundamentada. Es el trabajo con mayor puntuacion del grupo. **Correccion necesaria:** Segun la rubrica oficial, la calificacion deberia ser 10/10 (no 9.4/10) ya que 94 esta en el rango 90-100 = Excelente = 10.

---

### Carpeta 12: EXAMEN1_SYSDES__5B_243742-243708-243713 (1)
- **Puntuacion reportada:** 94/100
- **Verificacion aritmetica:** N/A - Es un referencia a la evaluacion de Carpeta 11
- **Consistencia de calificacion:** Misma nota sobre escala
- **Completitud:** CORRECTAMENTE MARCADA como duplicado
- **Veredicto:** VALIDA (Duplicado de Carpeta 11)
- **Observaciones:** Correctamente identificada como entrega duplicada.

---

### Carpeta 13: EXAMEN1_SYSDES__5B_243742-243708-243713 (2)
- **Puntuacion reportada:** 94/100
- **Verificacion aritmetica:** N/A - Es una referencia a la evaluacion de Carpeta 11
- **Consistencia de calificacion:** Misma nota sobre escala
- **Completitud:** CORRECTAMENTE MARCADA como duplicado
- **Veredicto:** VALIDA (Duplicado de Carpeta 11)
- **Observaciones:** Correctamente identificada como entrega duplicada.

---

### Carpeta 14: EXAMEN1_SYSDES__5B_243743
- **Puntuacion reportada:** 82/100
- **Verificacion aritmetica:** CORRECTA (26 + 16 + 18 + 13 + 9 = 82)
- **Adherencia a rubrica:** OK
- **Consistencia de calificacion:** ISSUE MENOR - 82 esta en rango 80-89 = 9.0/10. El evaluador asigno 8.2/10 usando escala lineal. Segun rubrica oficial deberia ser 9.0/10.
- **Completitud:** COMPLETA
- **Veredicto:** NO VALIDA - INCONSISTENCIA INTER-EVALUADOR (vs Carpeta 9)
- **Observaciones:** **PROBLEMA SIGNIFICATIVO.** Mismo equipo (243726-243743-243763), mismo trabajo. Carpeta 9 (Agente A) dio 71/100 y Carpeta 14 (segundo evaluador) dio 82/100. **Diferencia de 11 puntos, supera el umbral de 10.** Desglose de discrepancias:
  - ER: 25 (A) vs 26 (B) -- diferencia de 1
  - Restricciones: 13 (A) vs 16 (B) -- diferencia de 3
  - Queries: 10 (A) vs 18 (B) -- **diferencia de 8 puntos**
  - VIEWS: 14 (A) vs 13 (B) -- diferencia de -1
  - Justificacion: 9 (A) vs 9 (B) -- identico
  - **La mayor discrepancia esta en Queries SQL:** El Agente A penalizo fuertemente (10/25) por la ausencia total de queries independientes fuera de las VIEWS. El segundo evaluador (18/25) fue mas indulgente, otorgando puntos parciales.
  - **Analisis:** La posicion del Agente A es tecnica y procedimentalmente correcta: el examen solicita queries independientes y VIEWS como secciones separadas. Sin embargo, el segundo evaluador reconoce que la logica SQL demostrada en las VIEWS tiene valor.
  - **Recomendacion:** Promediar: (71 + 82) / 2 = 76.5, redondeado a 77/100. Calificacion: 8.0/10. El profesor deberia decidir si la ausencia de queries independientes justifica la penalizacion mayor del Agente A.

---

### Carpeta 15: EXAMEN1_SYSDES__5B_243751
- **Puntuacion reportada:** 83/100 (RE-EVALUADA)
- **Verificacion aritmetica:** CORRECTA (27 + 19 + 15 + 13 + 9 = 83)
- **Adherencia a rubrica:** OK
- **Consistencia de calificacion:** OK - 83 en rango 80-89 = 9.0/10
- **Completitud:** COMPLETA - Re-evaluacion exitosa con PDF completo leido (35 paginas)
- **Veredicto:** VALIDA - RECONCILIADA
- **Puntuacion reconciliada:** (86 + 87 + 83) / 3 = **85/100** -> **9.0/10**
- **Observaciones:** Re-evaluacion completada exitosamente. Mismo equipo que Carpetas 4 y 6. Esta fue la evaluacion mas conservadora de las 3 (83 vs 86-87), con 1 punto menos en ER (27 vs 28), Queries (15 vs 16) y Justificacion (9 vs 10). Las diferencias son menores y aceptables.

---

### Carpeta 16: EXAMEN1_SYSDES__5B_243752
- **Puntuacion reportada:** 58/100
- **Verificacion aritmetica:** CORRECTA (18 + 10 + 16 + 10 + 4 = 58)
- **Adherencia a rubrica:** OK
- **Consistencia de calificacion:** OK - 58 -> 6.0/10 correcto (rango 50-59). Sin embargo, el evaluador asigno 5.8/10 usando escala lineal. Segun rubrica oficial deberia ser 6.0/10.
- **Completitud:** COMPLETA
- **Veredicto:** NO VALIDA - INCONSISTENCIA INTER-EVALUADOR SEVERA
- **Observaciones:** **PROBLEMA CRITICO.** Mismo equipo (243678-243696-243752), mismo trabajo identico. Tres evaluaciones diferentes:
  - Carpeta 5 (Agente A): 72/100
  - Carpeta 7 (Agente B): 65/100
  - Carpeta 16 (segundo lote): 58/100
  - **Rango de variacion: 14 puntos (supera umbral de 10).**
  - La Carpeta 16 es la mas severa. El evaluador del segundo lote penalizo mas fuertemente el esquema ER (18/30 vs 20/30), las restricciones (10/20 vs 13/20), y la justificacion (4/10 vs 6/10).
  - **Recomendacion:** Promediar las tres evaluaciones completas: (72 + 65 + 58) / 3 = 65/100. Calificacion: 7.0/10. Nota: Las evaluaciones parciales que no pudieron leer el PDF no cuentan.

---

### Carpeta 17: EXAMEN1_SYSDES__5B_243757
- **Puntuacion reportada:** 81/100
- **Verificacion aritmetica:** CORRECTA (28 + 13 + 16 + 14 + 10 = 81)
- **Adherencia a rubrica:** OK
- **Consistencia de calificacion:** ISSUE MENOR - 81 esta en rango 80-89 = 9.0/10. El evaluador asigno 8.1/10 usando escala lineal. Segun rubrica oficial deberia ser 9.0/10.
- **Completitud:** COMPLETA
- **Veredicto:** VALIDA
- **Observaciones:** Este es el unico equipo que eligio el Caso 3-C (Programas Sociales). Evaluacion bien fundamentada. La justificacion de diseno recibio 10/10, la mas alta de todas las entregas. Se senala correctamente la falta de queries (4 de 7 requeridas).

---

### Carpeta 18: EXAMEN1_SYSDES__5B_243763
- **Puntuacion reportada:** 82/100
- **Verificacion aritmetica:** N/A - Referencia a Carpeta 14
- **Completitud:** CORRECTAMENTE MARCADA como duplicado
- **Veredicto:** VALIDA (Duplicado de Carpeta 14)
- **Observaciones:** Correctamente identificada como duplicado del mismo equipo.

---

### Carpeta 19: EXAMEN1_SYSDES__5B_243777
- **Puntuacion reportada:** 91/100
- **Verificacion aritmetica:** CORRECTA (29 + 19 + 21 + 15 + 7 = 91)
- **Adherencia a rubrica:** OK
- **Consistencia de calificacion:** ISSUE MENOR - 91 esta en rango 90-100 = 10/10. El evaluador asigno 9.1/10 usando escala lineal. Segun rubrica oficial deberia ser 10/10.
- **Completitud:** COMPLETA
- **Veredicto:** NO VALIDA - INCONSISTENCIA INTER-EVALUADOR (vs Carpetas 8 y 10)
- **Observaciones:** Mismo equipo (243716-243732-243777), mismo trabajo. Tres evaluaciones:
  - Carpeta 8 (Agente B): 86/100
  - Carpeta 10 (Agente B): 89/100
  - Carpeta 19 (segundo lote): 91/100
  - **Rango de variacion: 5 puntos (no supera umbral de 10).**
  - La evaluacion del segundo lote es la mas generosa, otorgando 29/30 en ER y 19/20 en Restricciones. Sin embargo, la diferencia es menor y todas coinciden en que es un trabajo de alta calidad.
  - **Recomendacion:** Promedio: (86 + 89 + 91) / 3 = 88.7, redondeado a 89/100. Calificacion: 9.0/10.

---

### Carpeta 20: EXAMEN1_SYSDES__5GRUPO_243472
- **Puntuacion reportada:** 81/100
- **Verificacion aritmetica:** N/A - Referencia a Carpeta 17
- **Completitud:** CORRECTAMENTE MARCADA como duplicado
- **Veredicto:** VALIDA (Duplicado de Carpeta 17)
- **Observaciones:** Correctamente identificada como duplicado.

---

### Carpeta 21: EXAMEN1_SYSDES__5GRUPO_243770
- **Puntuacion reportada:** 81/100
- **Verificacion aritmetica:** N/A - Referencia a Carpeta 17
- **Completitud:** CORRECTAMENTE MARCADA como duplicado
- **Veredicto:** VALIDA (Duplicado de Carpeta 17)
- **Observaciones:** Correctamente identificada como duplicado.

---

## Consistencia Inter-Evaluadores

### Equipo 243706-243723-243737: Carpetas 1, 2, 3
- **Puntuaciones:** Carpeta 1 = 76/100 (Agente A), Carpeta 2 = 76/100 (Agente A), Carpeta 3 = 80/100 (Agente B)
- **Consistencia:** LEVE INCONSISTENCIA (4 puntos de diferencia)
- **Detalle:** Las Carpetas 1 y 2 son identicas (mismo evaluador, misma puntuacion). La Carpeta 3 fue evaluada por otro agente y otorgo 4 puntos mas, principalmente en Queries (+2) y VIEWS (+1) y ER (+1).
- **Accion recomendada:** Adoptar 76/100 como puntuacion oficial (evaluacion mas detallada y conservadora). Calificacion: 8.0/10.

### Equipo 243678-243696-243752: Carpetas 5, 7, 16
- **Puntuaciones:** Carpeta 5 = 72/100 (Agente A), Carpeta 7 = 65/100 (Agente B), Carpeta 16 = 58/100 (segundo lote)
- **Consistencia:** **INCONSISTENTE - Rango de 14 puntos (supera umbral de 10)**
- **Detalle:** Las tres evaluaciones del mismo trabajo difieren significativamente. El evaluador del Agente A fue el mas generoso, mientras que el segundo lote fue el mas severo. La mayor variacion esta en ER (20 vs 19 vs 18), Restricciones (13 vs 11 vs 10), y Justificacion (6 vs 5 vs 4). Las VIEWS muestran la mayor discrepancia: 14 (A) vs 12 (B) vs 10 (segundo lote).
- **Accion recomendada:** **Requiere revision del profesor.** Se sugiere promediar: 65/100. Calificacion: 7.0/10. El profesor deberia revisar especificamente las VIEWS (son el punto de mayor discrepancia) para determinar el puntaje justo.

### Equipo 243716-243732-243777: Carpetas 8, 10, 19
- **Puntuaciones:** Carpeta 8 = 86/100, Carpeta 10 = 89/100, Carpeta 19 = 91/100
- **Consistencia:** LEVE INCONSISTENCIA (5 puntos de rango)
- **Detalle:** Todas las evaluaciones coinciden en que es un trabajo de muy alta calidad. Las diferencias son menores y distribuidas entre varias secciones. La Carpeta 19 otorga 29/30 en ER (vs 27/30 en Carpeta 8, +2 puntos). Las VIEWS son evaluadas en 15/15, 15/15, y 14/15 respectivamente.
- **Accion recomendada:** Adoptar promedio redondeado: 89/100. Calificacion: 9.0/10.

### Equipo 243726-243743-243763: Carpetas 9, 14, 18
- **Puntuaciones:** Carpeta 9 = 71/100 (Agente A), Carpeta 14 = 82/100 (segundo lote), Carpeta 18 = 82/100 (duplicado de 14)
- **Consistencia:** **INCONSISTENTE - Diferencia de 11 puntos (supera umbral de 10)**
- **Detalle:** La principal discrepancia esta en Queries SQL: 10/25 (Agente A) vs 18/25 (segundo lote). El Agente A penalizo la ausencia total de queries SQL independientes (solo hay VIEWS). El segundo evaluador fue mas indulgente al considerar que las VIEWS demuestran competencia SQL.
- **Accion recomendada:** **Requiere decision del profesor.** La discrepancia en Queries es una cuestion de criterio: si se acepta que solo presentar VIEWS sin queries separadas merece puntuacion parcial o penalizacion fuerte. Promedio sugerido: 77/100. Calificacion: 8.0/10.

### Equipo 243742-243708-243713: Carpetas 11, 12, 13
- **Puntuaciones:** Carpeta 11 = 94/100, Carpeta 12 = 94/100, Carpeta 13 = 94/100
- **Consistencia:** CONSISTENTE - Puntuacion identica en las tres carpetas
- **Accion recomendada:** Adoptar 94/100. **Corregir calificacion a 10/10** (segun rubrica, 90-100 = 10).

### Equipo 243757-243770-243472: Carpetas 17, 20, 21
- **Puntuaciones:** Carpeta 17 = 81/100, Carpeta 20 = 81/100, Carpeta 21 = 81/100
- **Consistencia:** CONSISTENTE - Puntuacion identica en las tres carpetas
- **Accion recomendada:** Adoptar 81/100. **Corregir calificacion a 9.0/10** (segun rubrica, 80-89 = 9).

### Equipo 243602-243692-243751: Carpetas 4, 6, 15
- **Puntuaciones:** Carpeta 4 = 86/100, Carpeta 6 = 87/100, Carpeta 15 = 83/100
- **Consistencia:** CONSISTENTE - Rango de 4 puntos (no supera umbral de 10)
- **Detalle:** Las tres evaluaciones completas (post re-evaluacion) coinciden en que es un trabajo de alta calidad. Desglose:
  - ER: 28, 28, 27 (diferencia de 1 punto)
  - Restricciones: 19, 19, 19 (identicas)
  - Queries: 16, 16, 15 (diferencia de 1 punto)
  - VIEWS: 13, 14, 13 (diferencia de 1 punto)
  - Justificacion: 10, 10, 9 (diferencia de 1 punto)
- **Accion recomendada:** Adoptar promedio: (86 + 87 + 83) / 3 = 85/100. Calificacion: 9.0/10. Porcentaje: 12.75% de 15%.

---

## Evaluaciones que Requieren Revision Manual

**RESUELTO:** Las carpetas 4, 6 y 15 (equipo 243602-243692-243751) fueron re-evaluadas exitosamente el 12 de febrero de 2026. Los PDFs fueron leidos correctamente usando rutas de archivo sin caracteres Unicode. Las tres evaluaciones completas son consistentes (83-87/100, rango de 4 puntos). Puntuacion reconciliada: **85/100 = 9.0/10**.

No quedan evaluaciones pendientes de revision manual.

---

## Estadisticas Generales

*Nota: Se utilizan las puntuaciones reconciliadas (promedio lineal + rangos) para todos los equipos.*

### Puntuaciones Finales por Equipo (TODAS RECONCILIADAS)

| Equipo | Matriculas | Caso | Evaluadores | Puntuacion Reconciliada | Calificacion | % del 15% |
|--------|-----------|------|-------------|------------------------|-------------|-----------|
| 1 | 243706, 243723, 243737 | 3-A | 76, 76, 80 | 76/100 | 8.0/10 | 11.4% |
| 2 | 243678, 243696, 243752 | 3-A | 72, 65, 58 | 65/100 | 7.0/10 | 9.75% |
| 3 | 243716, 243732, 243777 | 3-A | 86, 89, 91 | 89/100 | 9.0/10 | 13.35% |
| 4 | 243726, 243743, 243763 | 3-A | 71, 82 | 77/100 | 8.0/10 | 11.55% |
| 5 | 243742, 243708, 243713 | 3-A | 94 | 94/100 | 10/10 | 14.1% |
| 6 | 243757, 243770, 243472 | 3-C | 81 | 81/100 | 9.0/10 | 12.15% |
| 7 | 243602, 243692, 243751 | 3-A | 86, 87, 83 | 85/100 | 9.0/10 | 12.75% |

### Metricas (todos los equipos)

- **Promedio general:** 81.0/100
- **Desviacion estandar:** 9.8
- **Calificacion mas alta:** 94/100 (Equipo 243742-243708-243713)
- **Calificacion mas baja:** 65/100 (Equipo 243678-243696-243752)
- **Mediana:** 81/100

### Distribucion por Caso Elegido

| Caso | Equipos | Porcentaje |
|------|---------|------------|
| 3-A (Logistica de Distribucion Regional) | 6 equipos | 85.7% |
| 3-C (Seguimiento de Programas Sociales) | 1 equipo | 14.3% |
| 3-B (Gestion de Eventos Corporativos) | 0 equipos | 0% |
| Caso 2-A, 2-B, 2-C | 0 equipos | 0% |

### Distribucion de Calificaciones

| Calificacion | Equipos | Porcentaje |
|-------------|---------|------------|
| 10 (90-100) | 1 | 14.3% |
| 9 (80-89) | 3 | 42.9% |
| 8 (70-79) | 2 | 28.6% |
| 7 (60-69) | 1 | 14.3% |

---

## Hallazgos Sobre los Agentes Evaluadores

### Problema 1: Escala de Calificacion Inconsistente
Varios evaluadores usaron una escala lineal (ej. 82/100 = 8.2/10) en lugar de la escala de rangos definida en la rubrica (80-89 = 9.0/10, 90-100 = 10/10). Esto afecta las carpetas 11-14, 16-21. Se debe aplicar la escala oficial.

**Correcciones necesarias:**
- 94/100 -> debe ser 10/10 (no 9.4)
- 91/100 -> debe ser 10/10 (no 9.1)
- 82/100 -> debe ser 9/10 (no 8.2)
- 81/100 -> debe ser 9/10 (no 8.1)
- 58/100 -> debe ser 6/10 (no 5.8)

### Problema 2: Variabilidad Inter-Evaluador
Se detectaron dos instancias donde la diferencia entre evaluaciones del mismo trabajo supera los 10 puntos:
1. Equipo 243678-243696-243752: rango de 14 puntos (58-72)
2. Equipo 243726-243743-243763: diferencia de 11 puntos (71 vs 82)

La principal fuente de variabilidad esta en:
- **Queries SQL:** El criterio mas subjetivo, especialmente cuando los equipos no presentan queries independientes
- **VIEWS:** Diferencias de 2-4 puntos entre evaluadores para el mismo trabajo
- **Restricciones:** Diferencias de 2-3 puntos en la valoracion de restricciones presentadas en formato narrativo vs SQL

### Problema 3: Puntajes Provisionales Inconsistentes (RESUELTO)
Las carpetas 4, 6 y 15 que inicialmente no pudieron leerse por problemas de codificacion Unicode en nombres de archivo fueron re-evaluadas exitosamente. Las nuevas evaluaciones completas (86, 87, 83) reemplazan las parciales anteriores. Para futuras evaluaciones, se recomienda marcar secciones no evaluables como "NO EVALUABLE" sin puntaje provisional.

---

## Observaciones y Recomendaciones del Docente

### Fortalezas Generales del Grupo
1. **Todos los equipos eligieron casos de complejidad alta (3 integrantes).** Ningun equipo eligio un caso para 2 integrantes o trabajo individual, lo que demuestra ambicion academica.
2. **Las VIEWS son consistentemente la seccion mejor evaluada** en todo el grupo. La mayoria de los equipos demostraron uso correcto de CASE, COALESCE, NULLIF, y agregaciones complejas.
3. **La mayoria de los esquemas ER superan el minimo de 9-12 tablas**, con promedios de 12-14 tablas por equipo.
4. **Las preguntas de seguimiento generadas son pertinentes y bien calibradas** para evaluar comprension real en la defensa oral.

### Debilidades Comunes
1. **Ausencia del Caso 3-A de tabla "Almacen" explicita:** 5 de 6 equipos que eligieron 3-A no incluyeron una tabla de almacen separada, a pesar de que el caso se llama "Logistica de Distribucion Regional" y menciona un almacen central.
2. **Restricciones presentadas en formato narrativo, no SQL:** Casi todos los equipos describieron las restricciones en prosa en lugar de usar sintaxis SQL (CREATE TABLE, ALTER TABLE, ADD CONSTRAINT). Se recomienda enfatizar este punto en futuras evaluaciones.
3. **Queries SQL insuficientes:** Dos equipos no presentaron queries independientes (solo las VIEWS), y otros presentaron menos queries de las requeridas (5 en lugar de 6).
4. **Falta de HAVING en queries:** Varios equipos no demostraron uso de HAVING en queries independientes, aunque si lo usaron en VIEWS.
5. **Uso mixto de dialectos SQL:** Algunos equipos mezclaron sintaxis MySQL (DATE_SUB, CURDATE) con PostgreSQL (SERIAL, DATE_TRUNC) en el mismo documento.
6. **Justificaciones de diseno superficiales:** La mayoria de los equipos respondieron "por que escogieron ese caso" de manera generica, sin mencionar trade-offs tecnicos ni alternativas consideradas.

### Recomendaciones para el Proceso de Evaluacion
1. **Unificar la escala de calificacion:** Instruir a los agentes evaluadores para que usen la escala de rangos oficial (90-100 = 10, 80-89 = 9, etc.) y no escalas lineales.
2. **Evitar puntajes provisionales para secciones no evaluables:** Marcar como "NO EVALUABLE" y delegar al profesor.
3. **Establecer criterio unificado para queries vs VIEWS:** Definir claramente si la logica SQL demostrada en VIEWS puede contar parcialmente como "Queries SQL" cuando no se presentan queries independientes.
4. **Problema de nombres de archivo con caracteres especiales:** 3 de 21 carpetas no pudieron ser evaluadas completamente por caracteres Unicode en nombres de archivo. Instruir a los alumnos para usar nombres de archivo sin acentos ni caracteres especiales.
5. **Multiples entregas del mismo equipo:** Todos los equipos entregaron en multiples carpetas (una por integrante). Considerar solicitar una sola entrega por equipo para simplificar la evaluacion.

### Puntuaciones Finales Definitivas

| Equipo | Matriculas | Puntuacion Final | Calificacion Final | % del 15% |
|--------|-----------|-----------------|-------------------|-----------|
| 1 | 243706, 243723, 243737 | 76/100 | 8/10 | 11.4% |
| 2 | 243678, 243696, 243752 | 65/100 | 7/10 | 9.75% |
| 3 | 243716, 243732, 243777 | 89/100 | 9/10 | 13.35% |
| 4 | 243726, 243743, 243763 | 77/100 | 8/10 | 11.55% |
| 5 | 243742, 243708, 243713 | 94/100 | 10/10 | 14.1% |
| 6 | 243757, 243770, 243472 | 81/100 | 9/10 | 12.15% |
| 7 | 243602, 243692, 243751 | 85/100 | 9/10 | 12.75% |

### Listado Completo de Matriculas con Calificacion

| Matricula | Nombre | Equipo | Calificacion |
|-----------|--------|--------|-------------|
| 243706 | (Equipo 1) | 243706-243723-243737 | 8.0/10 |
| 243723 | (Equipo 1) | 243706-243723-243737 | 8.0/10 |
| 243737 | (Equipo 1) | 243706-243723-243737 | 8.0/10 |
| 243678 | Yael Betanzos Jimenez | 243678-243696-243752 | 7.0/10 |
| 243696 | Mishell Prado Gordillos | 243678-243696-243752 | 7.0/10 |
| 243752 | Jose Maria Moreno Perez | 243678-243696-243752 | 7.0/10 |
| 243716 | (Equipo 3) | 243716-243732-243777 | 9.0/10 |
| 243732 | (Equipo 3) | 243716-243732-243777 | 9.0/10 |
| 243777 | (Equipo 3) | 243716-243732-243777 | 9.0/10 |
| 243726 | Gonzalez Ruiz Andres Eduardo | 243726-243743-243763 | 8.0/10 |
| 243743 | Mora Mercado Fernando | 243726-243743-243763 | 8.0/10 |
| 243763 | Rudi Fabricio Martinez Jaimes | 243726-243743-243763 | 8.0/10 |
| 243742 | (Equipo 5) | 243742-243708-243713 | 10/10 |
| 243708 | (Equipo 5) | 243742-243708-243713 | 10/10 |
| 243713 | (Equipo 5) | 243742-243708-243713 | 10/10 |
| 243757 | (Equipo 6) | 243757-243770-243472 | 9.0/10 |
| 243770 | (Equipo 6) | 243757-243770-243472 | 9.0/10 |
| 243472 | (Equipo 6) | 243757-243770-243472 | 9.0/10 |
| 243602 | Espinoza Mendoza Hector Isaac | 243602-243692-243751 | 9.0/10 |
| 243692 | Moreno Zuniga Jesel | 243602-243692-243751 | 9.0/10 |
| 243751 | Arturo Yion Jaime | 243602-243692-243751 | 9.0/10 |

---

*Reporte generado el 12 de febrero de 2026 por el Agente Docente de Validacion.*
*Actualizado post-reconciliacion con re-evaluaciones de carpetas 4, 6 y 15.*
*Basado en la revision de 21 evaluaciones producidas por multiples agentes evaluadores independientes.*
*Todas las evaluaciones reconciliadas usando escala lineal (promedio) + rangos.*
