# Evaluacion: 243757 - 243770 - 243472
## Caso: 3-C - Seguimiento de Programas Sociales Gubernamentales
### Integrantes: 3 (Luis Angel Perez Aguilera 243757, Angel Eduardo Chame Perez 243770, Luis Antonio Selvas de Leon 243472)

---

### Resumen de Puntuacion

| Seccion | Puntos Obtenidos | Puntos Maximos | Porcentaje |
|---------|------------------|----------------|------------|
| Modelo ER + Esquema | 28 | 30 | 93% |
| Restricciones | 13 | 20 | 65% |
| Queries SQL | 16 | 25 | 64% |
| VIEWS | 14 | 15 | 93% |
| Justificacion | 10 | 10 | 100% |
| **TOTAL** | **81** | **100** | **81%** |

### Calificacion Final: 8.1 / 10
### Porcentaje Final: 12.15% de 15%

---

### Retroalimentacion por Seccion

#### Modelo ER + Esquema Relacional
- **Fortalezas**: Esquema completo y bien estructurado con 11 tablas en dbdiagram.io: programas, municipios, beneficiarios, convocatorias, solicitudes, evaluadores, entregas, entregas_especie, bitacora_estados, padron_beneficiarios. Incluye tanto el diagrama relacional como el diagrama ER conceptual. La tabla padron_beneficiarios implementa correctamente la relacion N-N entre beneficiarios y programas (con fecha_alta, fecha_baja, motivo_baja, estatus_padron). La tabla bitacora_estados funciona como entidad debil vinculada a solicitudes (con estado_anterior, estado_nuevo, fecha_cambio, id_usuario_cambio, motivo). Las entregas se separan en entregas (monetarias) y entregas_especie (productos fisicos), lo cual es una decision de diseno flexible. La tabla beneficiarios incluye CURP con char(18) y NOT NULL. Las relaciones 1-N y N-N estan correctamente representadas en el ER.
- **Debilidades**: No se incluye una tabla de enlaces_municipales que el caso sugiere como posible entidad (-1 pt). La tabla entregas tiene id_programa como FK directa, pero la relacion logica deberia ser entregas vinculadas al padron o beneficiario-programa, no directamente al programa (-1 pt). Menor: el diagrama ER conceptual no muestra claramente la entidad debil (doble rectangulo) para bitacora_estados, aunque la implementacion relacional es correcta.

#### Restricciones
- **Fortalezas**: 6 restricciones identificadas y bien categorizadas: UNIQUE (CURP), CHECK (presupuesto > 0), CHECK (estados validos con lista de valores), NOT NULL (nombres/fechas), FK (integridad referencial), CHECK (fecha_fin > fecha_inicio en convocatorias). Las restricciones son relevantes y corresponden a reglas de negocio del caso.
- **Debilidades**: Solo se presentan 6 restricciones cuando el minimo para equipos de 3 es 10 (-4 pts). Faltan restricciones importantes:
  - No se especifica UNIQUE en la combinacion beneficiario-convocatoria en solicitudes (evitar solicitudes duplicadas) (-1 pt).
  - No se especifican acciones ON DELETE/ON UPDATE en las claves foraneas (-1 pt).
  - No hay CHECK para montos positivos en entregas (-1 pt).
  - Las restricciones se describen de manera general sin sintaxis SQL especifica, aunque los conceptos son correctos.

#### Queries SQL
- **Fortalezas**: 4 queries presentadas con codigo SQL funcional:
  - Query 1 (JOIN y Agregacion): Calcula monto acumulado por beneficiario con JOIN entregas, GROUP BY y HAVING SUM > 0.
  - Query 2 (CASE y Subconsultas): Lista solicitudes con COALESCE para evaluador pendiente y CASE para estatus informativo.
  - Query 3 (Historial): Consulta bitacora_estados con JOIN evaluadores, COALESCE para motivo, y ORDER BY fecha_cambio.
  - Query 4 (Campo Justo): JOIN programas-entregas-entregas_especie con SUM y GROUP BY.
  Todas usan JOINs correctos y son coherentes con el esquema.
- **Debilidades**: Solo se presentan 4 queries cuando el caso requiere 7 queries para equipos de 3 (-5 pts). Faltan queries para:
  - Beneficiarios activos con municipio y fecha.
  - Convocatorias abiertas con lugares disponibles.
  - Beneficiarios dados de baja.
  - Solicitudes por evaluador.
  - Municipios con gasto sobre umbral.
  Las queries presentadas son correctas pero la cobertura es insuficiente (-4 pts).

#### VIEWS
- **Fortalezas**: 5 VIEWS completas y de alta calidad que cubren todos los reportes requeridos del caso 3-C:
  - VIEW 1 (vw_cobertura_municipio_programa): JOIN de 5 tablas con COUNT(DISTINCT), COALESCE, NULLIF para porcentaje_cobertura. Excelente.
  - VIEW 2 (vw_taza_aprobacion_rechazo_convocatoria): SUM con CASE para aprobadas/rechazadas, ROUND con cast NUMERIC, NULLIF para division. Buena implementacion.
  - VIEW 3 (vw_gasto_vs_presupuesto): COALESCE, ROUND con NULLIF, CASE con 3 niveles de clasificacion (En curso, Cerca del limite, Sobrepasado). Incluye filtro temporal por anio. Muy completa.
  - VIEW 4 (vw_beneficiarios_multiplos_programas): COUNT(DISTINCT), COALESCE, HAVING > 1. Filtra por estatus_padron = 'Activo'. Correcta.
  - VIEW 5 (vw_rechazos_recientes): COALESCE para motivo, filtro temporal de 90 dias con INTERVAL. Limpia y funcional.
  Todas usan CREATE VIEW correctamente y son coherentes con el esquema.
- **Debilidades**: VIEW 2 tiene un posible error tipografico "taza" en lugar de "tasa" (menor). Algunos textos en los screenshots de VIEWS muestran problemas de rendering ("mBOMobetoalctacibsdb" en VIEW 4 y "mBOMvbitacbaagestados" en VIEW 5), lo cual sugiere problemas de encoding en el PDF, pero el SQL subyacente es correcto (-1 pt).

#### Justificacion de Diseno
- **Fortalezas**: Justificacion excelente y la mas articulada del grupo evaluado. La respuesta a "por que este caso" es detallada: analizo las tres opciones, eligio 3-C por logica de negocio clara (seguimiento de ciudadano desde solicitud hasta apoyo), robustez para auditoria (bitacora), y gestion de presupuestos. La respuesta a "por que lo disenaron asi" menciona tres decisiones concretas con razonamiento tecnico: (1) entidad asociativa Padron para multiples programas sin repetir datos, (2) entidad debil para bitacora para preservar historial completo, (3) entregas flexibles que soportan tanto monetarias como en especie. Demuestra comprension profunda de los conceptos de modelado.
- **Debilidades**: Ninguna significativa. Esta es la mejor justificacion de todas las entregas evaluadas.

---

### Preguntas de Seguimiento

1. **[COMPRENSION]**
   - Pregunta: En su modelo, la tabla bitacora_estados tiene los campos estado_anterior y estado_nuevo. Expliquen que sucede en esta tabla cuando una solicitud pasa de "Recibida" a "En revision" y luego a "Aprobada". Cuantos registros se crearian y que datos tendria cada uno?
   - Respuesta esperada: Se crearian 2 registros. Registro 1: estado_anterior='Recibida', estado_nuevo='En revision', fecha_cambio=timestamp, id_usuario_cambio=evaluador1, motivo='Asignada para revision'. Registro 2: estado_anterior='En revision', estado_nuevo='Aprobada', fecha_cambio=timestamp2, id_usuario_cambio=evaluador1, motivo='Cumple requisitos'. Cada cambio de estado genera una entrada, creando un historial completo y auditable.

2. **[FALENCIAS]**
   - Pregunta: Su tabla entregas tiene id_programa como FK directa. Si un beneficiario esta inscrito en el mismo programa a traves de dos convocatorias diferentes, como distinguiria su modelo a cual pertenece la entrega?
   - Respuesta esperada: Deben reconocer que la relacion entregas->programa no pasa por padron_beneficiarios ni por convocatoria. La entrega deberia vincularse al padron (id_padron) en lugar de directamente al programa, ya que el padron ya contiene la relacion beneficiario-programa con las fechas de alta. Alternativamente, podrian agregar id_convocatoria a entregas.

3. **[MEJORA]**
   - Pregunta: Su modelo no incluye una tabla de enlaces municipales. Si el gobierno necesita asignar un funcionario responsable por municipio para supervisar la ejecucion de los programas, que cambios harian?
   - Respuesta esperada: Deberian proponer una tabla enlaces_municipales con (id_enlace, nombre, id_municipio, telefono, email, fecha_asignacion) vinculada a municipios. Podrian tambien vincular las entregas o solicitudes al enlace responsable para trazabilidad.

4. **[DECISION]**
   - Pregunta: Ustedes implementaron entregas_especie como tabla separada de entregas en lugar de poner campos de descripcion y cantidad directamente en la tabla entregas. Por que tomaron esta decision y que ventaja tiene?
   - Respuesta esperada: Deben explicar que separar permite registrar multiples productos en una sola entrega (una entrega puede incluir arroz, frijol, aceite como registros separados en entregas_especie). Si estuviera todo en una tabla, tendrian que crear un registro de entrega por cada producto, duplicando la informacion de fecha, beneficiario, etc.

5. **[APLICACION]**
   - Pregunta: Usando su VIEW vw_gasto_vs_presupuesto, si un programa tiene presupuesto_anual = 1,000,000 y el gasto acumulado en entregas del 2026 es de 750,000, que valores mostraria la vista para porcentaje_gastado, saldo, y clasificacion?
   - Respuesta esperada: gasto_anual_actual = COALESCE(750000, 0) = 750,000. porcentaje_gastado = ROUND(750000 / NULLIF(1000000, 0) * 100, 2) = 75.00. saldo = 1,000,000 - 750,000 = 250,000. clasificacion: como 75% esta BETWEEN 70 AND 100, mostraria 'Cerca del limite'.

---

### Observaciones Adicionales
Trabajo solido con una estructura de base de datos bien pensada para el caso 3-C de programas sociales. Las fortalezas principales son el esquema relacional completo con padron como entidad asociativa y bitacora como entidad debil, las 5 VIEWS de alta calidad con manejo correcto de NULLIF, COALESCE, CASE y filtros temporales, y una justificacion de diseno excepcional. Las debilidades principales son el numero insuficiente de queries SQL (4 de 7 requeridas) y el numero de restricciones por debajo del minimo (6 de 10). La clasificacion de entidades en categorias (Principales, Dependientes, Historial/Control, Asociativas, Operativas) demuestra una comprension avanzada de modelado de datos.

**NOTA**: Esta evaluacion aplica tambien a las carpetas duplicadas EXAMEN1_SYSDES__5GRUPO_243472 y EXAMEN1_SYSDES__5GRUPO_243770, que contienen los mismos archivos con diferente matricula en el nombre.
