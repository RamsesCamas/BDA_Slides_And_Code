# Guía de Evaluación - Examen Parcial Base de Datos Avanzada
## Casos de Diseño — Febrero 2026

---

## 1. Información General del Examen

### Formato de Entrega
- Documento PDF con solución escaneada (si fue a mano) o documento de diseño digital
- Diagramas en PDF
- **Obligatorio**: Especificar integrantes del equipo y caso escogido
- **Obligatorio**: Responder las preguntas de justificación

### Preguntas de Justificación Requeridas
1. ¿Por qué escogieron ese caso?
2. ¿Por qué lo diseñaron así?

### Consideración Especial - Trabajo Individual
Los estudiantes que trabajen individualmente deben:
- Seleccionar un caso para equipos de 2
- Reducir la complejidad a un **mínimo de 5 tablas**

---

## 2. Casos a Evaluar

### Casos para Equipos de 2 Integrantes
**Complejidad media**: Mínimo 6-8 tablas, al menos 1 relación N-N con tabla puente, 3 VIEWS y 6 restricciones.

#### Caso 2-A: Marketplace de Productos Artesanales

**Contexto**: Plataforma de comercio electrónico para cooperativa de artesanos chiapanecos con comisión del 12%.

**Entidades principales esperadas**:
- Artesanos (con comunidad de origen)
- Productos (con estado activo/inactivo, precio, categoría)
- Compradores
- Pedidos (con estados: pendiente, pagado, completado, cancelado)
- Detalles de pedido (tabla puente con precio histórico)
- Envíos (por artesano, con estados independientes)
- Pagos
- Reseñas (con restricción de una por producto-comprador)

**Trade-offs Clave**:

| Decisión | Opción A | Opción B | Consideraciones |
|----------|----------|----------|-----------------|
| **Envíos** | Atributo del pedido | Entidad separada | Con múltiples artesanos por pedido, debe ser entidad separada para manejar estados independientes |
| **Precio histórico** | Guardarlo en detalle_pedido | Referencia a producto | DEBE guardarse en detalle para evitar corrupción al cambiar precios |
| **Categorías** | CHECK constraint | Tabla catálogo | Tabla catálogo permite agregar categorías sin ALTER TABLE |
| **Reseñas duplicadas** | UNIQUE(producto, comprador) | Lógica de aplicación | UNIQUE es más seguro y autodocumentado |

**VIEWS Requeridas**:
1. Resumen de ventas por artesano (ventas, comisión retenida, monto a pagar)
2. Ranking de productos por calificación promedio (con umbral justificado)
3. Reporte de pedidos recientes (clasificación rápido/tardío con criterio justificado)

**Queries Requeridas**:
1. Productos activos con artesano y comunidad
2. Ingreso total por categoría en periodo
3. Pedidos con envíos pendientes
4. Top compradores por gasto
5. Proporción productos activos/inactivos por artesano

---

#### Caso 2-B: Boletaje para Festival Cultural del Estado

**Contexto**: Sistema de boletaje para festival con múltiples sedes, eventos gratuitos y de pago.

**Entidades principales esperadas**:
- Sedes (con capacidad)
- Eventos (con tipo, precio, horario)
- Personas/Asistentes
- Boletos (con folio único, hora de entrada)
- Órdenes (con estados de pago)
- Pagos

**Trade-offs Clave**:

| Decisión | Opción A | Opción B | Consideraciones |
|----------|----------|----------|-----------------|
| **Traslape de horarios** | CHECK constraint | Validación de aplicación | CHECK no puede validar traslapes complejos; requiere trigger o aplicación |
| **Boleto** | Entidad propia | Tabla puente (Persona-Evento) | Entidad propia permite atributos como folio, hora_entrada |
| **Capacidad** | En tabla Evento | En tabla Sede | En Sede evita redundancia; el VIEW hace JOIN |
| **Eventos cancelados** | Borrado lógico | Campo estado | Campo estado preserva datos para reembolsos |

**VIEWS Requeridas**:
1. Ocupación real por evento (vendidos vs asistidos vs capacidad)
2. Recaudación por tipo de evento (con HAVING para filtrar tipos con >1 evento)
3. Perfil de asistentes (eventos atendidos, gasto, clasificación frecuente/ocasional)

**Queries Requeridas**:
1. Programación completa de una sede
2. Recaudación agrupada por sede y tipo
3. Eventos con <50% asistencia vs boletos vendidos
4. Personas que asistieron a eventos gratuitos Y de pago
5. Ingreso promedio por boleto por tipo (excluyendo gratuitos)

---

#### Caso 2-C: Registro de Licencias de Conducir

**Contexto**: Sistema para administrar licencias de conducir con tipos, exámenes y renovaciones.

**Entidades principales esperadas**:
- Ciudadanos (con CURP)
- Tipos de licencia (con vigencia y costo)
- Solicitudes (con estados)
- Exámenes (médico y teórico)
- Evaluadores
- Licencias (con estados: vigente, vencida, reemplazada)

**Trade-offs Clave**:

| Decisión | Opción A | Opción B | Consideraciones |
|----------|----------|----------|-----------------|
| **CURP como PK** | PK natural (CURP) | ID surrogate + CURP UNIQUE | Surrogate simplifica FKs; CURP puede tener errores de captura |
| **Exámenes** | Una tabla con tipo | Dos tablas separadas | Una tabla es más flexible pero requiere validación de atributos |
| **Licencia única vigente** | Constraint parcial | Trigger/Aplicación | Constraint parcial (UNIQUE WHERE vigente) no es estándar en todos DBMS |
| **Agregar tipo licencia** | INSERT en catálogo | ALTER TABLE con CHECK | Tabla catálogo es más flexible |

**VIEWS Requeridas**:
1. Tasa de aprobación por tipo de licencia (con umbral de volumen)
2. Licencias próximas a vencer (rangos de urgencia justificados)
3. Rendimiento de evaluadores (con COALESCE/CASE para evaluadores de un solo tipo)

**Queries Requeridas**:
1. Ciudadanos con licencia vigente
2. Promedio calificación teórica por tipo
3. Ciudadanos con múltiples solicitudes
4. Ingreso por licencias del último año
5. Solicitudes rechazadas con resultados de exámenes

---

### Casos para Equipos de 3 Integrantes
**Complejidad alta**: Mínimo 9-12 tablas, al menos 2 relaciones N-N o 1 N-N + 1 entidad débil, 5 VIEWS y 10 restricciones.

#### Caso 3-A: Logística de Distribución Regional

**Contexto**: Distribuidora con almacén central, flota propia y entregas a comercios en 3 estados.

**Entidades principales esperadas**:
- Proveedores
- Productos (con categoría, precios de compra/venta)
- Comercios (con zona geográfica)
- Inventario/Movimientos (entradas y salidas)
- Pedidos
- Detalles de pedido
- Vehículos (con estado y capacidad)
- Conductores
- Rutas
- Entregas (con incidencias)

**Trade-offs Clave**:

| Decisión | Opción A | Opción B | Consideraciones |
|----------|----------|----------|-----------------|
| **Movimientos inventario** | Una tabla con tipo | Dos tablas (entrada/salida) | Una tabla facilita agregar tipos (ajuste, merma); dos tablas son más explícitas |
| **Producto-Proveedor** | Producto sabe su proveedor | Relación N-N | Depende si un producto puede venir de múltiples proveedores |
| **Vehículo en mantenimiento** | CHECK (estado != 'mantenimiento' OR no en ruta) | Trigger/Aplicación | CHECK simple no puede validar esto; requiere trigger |
| **División entre cero** | NULLIF(ventas, 0) | CASE WHEN ventas = 0 | NULLIF es más elegante; CASE más explícito |
| **Múltiples almacenes** | Campo almacen_id en movimientos | Rediseño significativo | Diseño original debe contemplar escalabilidad |

**VIEWS Requeridas**:
1. Resumen de pedidos por zona geográfica
2. Productividad de conductores (con clasificación de rendimiento)
3. Inventario crítico (manejo de cero ventas)
4. Rentabilidad por proveedor (margen)
5. Utilización de flota (con umbrales justificados)

**Queries Requeridas**:
1. Pedidos sin ruta asignada
2. Peso asignado vs capacidad por ruta
3. Entradas de almacén del mes por proveedor
4. Rutas de la semana con incidencias
5. Valor total de inventario por categoría
6. Pedido más reciente por comercio

---

#### Caso 3-B: Gestión de Eventos Corporativos

**Contexto**: Organización de conferencias con sesiones, ponentes, empresas cliente y patrocinadores.

**Entidades principales esperadas**:
- Centros de convenciones
- Salones (con piso y capacidad)
- Eventos
- Sesiones (con tipo y cupo)
- Ponentes
- Participaciones (ponente-sesión con rol)
- Empresas cliente
- Paquetes
- Pagos
- Asistentes
- Inscripciones (asistente-sesión con asistencia)
- Patrocinadores
- Patrocinios (patrocinador-evento con nivel)

**Trade-offs Clave**:

| Decisión | Opción A | Opción B | Consideraciones |
|----------|----------|----------|-----------------|
| **Tablas puente con atributos** | Solo FKs | Con rol, nivel, asistencia | Las relaciones N-N tienen atributos propios significativos |
| **Consistencia salón-centro** | FK compuesta | Validación de aplicación | FK compuesta garantiza integridad referencial |
| **Pagos parciales** | Relación 1-N (paquete-pagos) | Campo único con historial | 1-N es correcto para pagos parciales |
| **Traslape de ponentes** | Trigger | Validación de aplicación | BD no puede prevenir fácilmente; es validación de aplicación |
| **Inscritos vs Asistentes** | Campo booleano asistio | Dos tablas separadas | Campo booleano es más simple y funcional |

**VIEWS Requeridas**:
1. Resumen financiero por evento (paquetes + patrocinios, con manejo de NULL)
2. Asistencia por sesión (con clasificación de ocupación)
3. Ponentes más activos
4. Inversión por empresa cliente
5. Balance de pagos (con clasificación de estado)

**Queries Requeridas**:
1. Sesiones con ponentes, salón y horario
2. Total asistentes por empresa cliente
3. Ponentes con múltiples roles en mismo evento
4. Ingreso por tipo de paquete
5. Asistentes en >3 sesiones
6. Monto por nivel de patrocinio
7. Sesiones al 100% de cupo

---

#### Caso 3-C: Seguimiento de Programas Sociales Gubernamentales

**Contexto**: Administración de programas sociales con convocatorias, solicitudes, beneficiarios y entregas.

**Entidades principales esperadas**:
- Programas (con presupuesto anual)
- Convocatorias (con fechas y cupo)
- Beneficiarios/Ciudadanos (con municipio)
- Municipios (con población)
- Solicitudes (con estados)
- Bitácora de cambios (entidad débil)
- Evaluadores
- Padrón (beneficiario-programa, N-N con atributos)
- Entregas (monetarias y en especie)
- Enlaces municipales

**Trade-offs Clave**:

| Decisión | Opción A | Opción B | Consideraciones |
|----------|----------|----------|-----------------|
| **Bitácora** | Entidad débil de solicitud | Tabla independiente | Entidad débil con PK(solicitud_id, secuencia) es más correcta |
| **Padrón** | Campo en beneficiario | Tabla N-N | Tabla N-N permite múltiples programas y fechas de alta/baja |
| **Entregas mixtas** | Campos monto + descripcion | Dos tablas | Campos separados en misma tabla es más simple |
| **División entre cero** | CASE con validación | NULLIF | Debe manejarse para programas nuevos sin presupuesto |
| **Requisitos** | Texto libre | Estructura/Tabla | Texto libre es flexible pero no validable por BD |
| **Datos opcionales** | NULL permitido | Valores por defecto | NULL es semánticamente correcto para "no tiene" |

**VIEWS Requeridas**:
1. Cobertura por municipio y programa
2. Eficiencia del proceso de solicitudes (con clasificación de selectividad)
3. Gasto vs presupuesto (con clasificación y manejo de cero)
4. Beneficiarios con múltiples programas
5. Bitácora de rechazos (con COALESCE para motivo)

**Queries Requeridas**:
1. Beneficiarios activos con municipio y fecha
2. Monto por programa y método de entrega
3. Convocatorias abiertas con lugares disponibles
4. Beneficiarios dados de baja
5. Solicitudes por evaluador
6. Historial de cambios de solicitud
7. Municipios con gasto sobre umbral

---

## 3. Rúbrica de Evaluación Ajustada

La ponderación se ajusta eliminando las preguntas de defensa oral y escrita (25% original), redistribuyendo el peso proporcionalmente.

### Ponderación Final

| Criterio | Peso | Qué se Evalúa |
|----------|------|---------------|
| **Modelo ER + Esquema Relacional** | 30% | Entidades correctas, cardinalidades, PKs, FKs, normalización básica. Se descuenta si falta tabla puente de N-N o hay redundancia evidente. |
| **Restricciones** | 20% | CHECK, UNIQUE, NOT NULL, FK identificadas correctamente. Se valora que correspondan a reglas del negocio. |
| **Queries SQL** | 25% | Sintaxis razonable, JOINs apropiados, uso de agregaciones y GROUP BY/HAVING. Se permite pseudocódigo si la lógica es clara. |
| **VIEWS** | 15% | Definidas como CREATE VIEW. Incluyen agregación, HAVING donde se indique, CASE/COALESCE donde se requiera. Coherentes con el esquema. |
| **Justificación de Diseño** | 10% | Respuestas a las preguntas "¿Por qué escogieron ese caso?" y "¿Por qué lo diseñaron así?" Claridad y coherencia de la argumentación. |

**Total: 100%**

---

## 4. Criterios Detallados por Sección

### 4.1 Modelo ER + Esquema Relacional (30%)

**Puntuación máxima: 30 puntos**

| Aspecto | Puntos | Criterio |
|---------|--------|----------|
| Identificación de entidades | 8 | Todas las entidades principales del caso están presentes |
| Cardinalidades correctas | 6 | Las relaciones 1-N y N-N están correctamente identificadas |
| Claves primarias | 5 | PKs definidas correctamente (naturales o surrogates justificados) |
| Claves foráneas | 5 | FKs conectan correctamente las tablas |
| Normalización | 3 | Sin redundancia evidente, al menos 3FN |
| Tablas puente | 3 | Relaciones N-N tienen su tabla puente correspondiente |

**Penalizaciones**:
- -5 puntos: Falta tabla puente obligatoria
- -3 puntos: Redundancia de datos evidente
- -2 puntos: Cardinalidad incorrecta
- -2 puntos: Entidad principal faltante

### 4.2 Restricciones (20%)

**Puntuación máxima: 20 puntos**

| Tipo de Restricción | Puntos | Ejemplos |
|---------------------|--------|----------|
| NOT NULL apropiados | 4 | Campos que no deben ser nulos según el negocio |
| UNIQUE constraints | 4 | Identificadores naturales, combinaciones únicas |
| CHECK constraints | 4 | Validación de rangos, estados válidos, porcentajes |
| Integridad referencial (FK) | 4 | ON DELETE/ON UPDATE apropiados |
| Restricciones de negocio identificadas | 4 | Aunque no sean implementables como constraint |

**Mínimo esperado por caso**:
- Equipos de 2: 6 restricciones
- Equipos de 3: 10 restricciones
- Individual: 4 restricciones

### 4.3 Queries SQL (25%)

**Puntuación máxima: 25 puntos**

| Aspecto | Puntos | Criterio |
|---------|--------|----------|
| Sintaxis correcta | 5 | SELECT, FROM, WHERE, GROUP BY sintácticamente válidos |
| JOINs apropiados | 8 | Uso correcto de INNER, LEFT, RIGHT JOIN según la semántica requerida |
| Agregaciones | 5 | COUNT, SUM, AVG usados correctamente |
| GROUP BY / HAVING | 4 | Agrupación correcta, filtros de grupo apropiados |
| Cobertura de queries requeridas | 3 | Se responden las consultas solicitadas en el caso |

**Nota**: Se acepta pseudocódigo si la lógica es clara y demostrable.

### 4.4 VIEWS (15%)

**Puntuación máxima: 15 puntos**

| Aspecto | Puntos | Criterio |
|---------|--------|----------|
| Sintaxis CREATE VIEW | 3 | Estructura correcta de definición |
| Agregaciones correctas | 4 | SUM, COUNT, AVG según se requiera |
| Uso de HAVING | 3 | Filtrado de grupos donde se especifica |
| Uso de CASE/COALESCE | 3 | Manejo de clasificaciones y valores NULL |
| Coherencia con esquema | 2 | Las tablas y campos referenciados existen |

**Mínimo esperado**:
- Equipos de 2: 3 VIEWS
- Equipos de 3: 5 VIEWS
- Individual: 2 VIEWS

### 4.5 Justificación de Diseño (10%)

**Puntuación máxima: 10 puntos**

| Pregunta | Puntos | Criterio |
|----------|--------|----------|
| ¿Por qué escogieron ese caso? | 4 | Razones claras, relevantes (interés, experiencia, complejidad adecuada) |
| ¿Por qué lo diseñaron así? | 6 | Justificación de decisiones técnicas, trade-offs considerados, alternativas descartadas |

**Se valora**:
- Mención de trade-offs considerados
- Justificación de decisiones no obvias
- Coherencia entre la justificación y el diseño entregado

---

## 5. Instrucciones para el Agente Evaluador

### 5.1 Proceso de Evaluación

1. **Identificar el caso**: Determinar qué caso eligió el equipo (2-A, 2-B, 2-C, 3-A, 3-B, 3-C)
2. **Verificar integrantes**: Confirmar número de integrantes y ajustar expectativas
3. **Evaluar cada sección**: Aplicar los criterios de la rúbrica
4. **Calcular puntuación**: Sumar puntos de cada sección
5. **Generar preguntas de seguimiento**: Crear 5 preguntas personalizadas

### 5.2 Consideraciones Especiales

- **Trabajo individual**: Reducir expectativas a mínimo 5 tablas, 2 VIEWS, 4 restricciones
- **Uso de IA permitido**: No penalizar por uso de herramientas, pero verificar comprensión
- **Pseudocódigo**: Aceptable en queries si la lógica es clara

### 5.3 Generación de Preguntas de Seguimiento

Para cada entrega, generar **5 preguntas** que evalúen:

1. **Comprensión del modelo** (1 pregunta): Sobre una entidad o relación específica de su diseño
2. **Identificación de falencias** (1 pregunta): Sobre un posible problema o limitación de su diseño
3. **Áreas de mejora** (1 pregunta): Sobre cómo podrían mejorar o extender su diseño
4. **Decisiones de diseño** (1 pregunta): Sobre por qué eligieron una alternativa sobre otra
5. **Aplicación práctica** (1 pregunta): Sobre cómo su diseño resuelve un escenario del caso

**Formato de pregunta**:
```
Pregunta [N]: [Texto de la pregunta]
Categoría: [Comprensión/Falencias/Mejora/Decisión/Aplicación]
Respuesta esperada: [Resumen de lo que se espera que respondan]
Puntos clave a evaluar: [Aspectos específicos a observar en la respuesta]
```

### 5.4 Ejemplo de Preguntas por Tipo

**Comprensión del modelo**:
> "En su diseño, ¿cómo se relaciona la entidad [X] con la entidad [Y]? ¿Qué cardinalidad tiene esa relación y por qué?"

**Identificación de falencias**:
> "Si un [escenario del caso] ocurriera, ¿su modelo actual lo soportaría? ¿Qué problemas podrían surgir?"

**Áreas de mejora**:
> "Si el negocio creciera y necesitara [nueva funcionalidad], ¿qué cambios harían a su diseño?"

**Decisiones de diseño**:
> "Ustedes modelaron [X] como [decisión]. ¿Consideraron la alternativa de [Y]? ¿Por qué la descartaron?"

**Aplicación práctica**:
> "Muestren cómo su diseño resuelve [consulta específica del caso]. ¿Qué tablas involucra?"

---

## 6. Formato de Reporte de Evaluación

```markdown
# Evaluación: [Nombre del Equipo/Integrantes]
## Caso: [Identificador del caso]

### Resumen de Puntuación

| Sección | Puntos Obtenidos | Puntos Máximos | Porcentaje |
|---------|------------------|----------------|------------|
| Modelo ER + Esquema | XX | 30 | XX% |
| Restricciones | XX | 20 | XX% |
| Queries SQL | XX | 25 | XX% |
| VIEWS | XX | 15 | XX% |
| Justificación | XX | 10 | XX% |
| **TOTAL** | **XX** | **100** | **XX%** |

### Calificación Final: [X.X / 10]

### Retroalimentación por Sección

#### Modelo ER + Esquema Relacional
[Comentarios específicos, fortalezas y debilidades]

#### Restricciones
[Comentarios específicos]

#### Queries SQL
[Comentarios específicos]

#### VIEWS
[Comentarios específicos]

#### Justificación de Diseño
[Comentarios sobre las respuestas a las preguntas de justificación]

### Preguntas de Seguimiento

1. [Pregunta 1]
   - Categoría: [Tipo]
   - Respuesta esperada: [...]

2. [Pregunta 2]
   - Categoría: [Tipo]
   - Respuesta esperada: [...]

3. [Pregunta 3]
   - Categoría: [Tipo]
   - Respuesta esperada: [...]

4. [Pregunta 4]
   - Categoría: [Tipo]
   - Respuesta esperada: [...]

5. [Pregunta 5]
   - Categoría: [Tipo]
   - Respuesta esperada: [...]

### Observaciones Adicionales
[Comentarios generales sobre la calidad del trabajo]
```

---

## 7. Peso en Calificación Final y Escala de Calificación

### Peso del Examen
Este examen parcial representa el **15% de la calificación final** del curso.

### Conversión de Puntuación a Porcentaje Final

| Puntuación del Examen | Porcentaje Obtenido del 15% | Cálculo |
|-----------------------|-----------------------------|---------|
| 100 | 15.0% | 100% × 15% |
| 90 | 13.5% | 90% × 15% |
| 80 | 12.0% | 80% × 15% |
| 70 | 10.5% | 70% × 15% |
| 60 | 9.0% | 60% × 15% |
| 50 | 7.5% | 50% × 15% |
| 40 | 6.0% | 40% × 15% |
| 0 | 0% | 0% × 15% |

**Fórmula**: `Porcentaje Final = (Puntuación / 100) × 15`

### Escala de Calificación del Examen

| Puntuación | Calificación | Descripción | % de Calif. Final |
|------------|--------------|-------------|-------------------|
| 90-100 | 10 | Excelente. Diseño completo, bien justificado, sin errores significativos | 13.5% - 15% |
| 80-89 | 9 | Muy bien. Diseño sólido con mejoras menores posibles | 12% - 13.35% |
| 70-79 | 8 | Bien. Diseño funcional con algunas áreas de mejora | 10.5% - 11.85% |
| 60-69 | 7 | Satisfactorio. Cumple requisitos mínimos con deficiencias notables | 9% - 10.35% |
| 50-59 | 6 | Suficiente. Diseño incompleto pero con fundamentos correctos | 7.5% - 8.85% |
| 40-49 | 5 | Insuficiente. Faltan componentes importantes o errores significativos | 6% - 7.35% |
| < 40 | Reprobado | No cumple con los requisitos mínimos del examen | < 6% |

---

## Notas Finales

- Las preguntas de defensa del documento original **NO** se evalúan, pero sirven como referencia para generar las preguntas de seguimiento
- El uso de IA está explícitamente permitido; la evaluación se centra en la comprensión demostrada
- Los diagramas pueden estar en cualquier notación (Chen, UML, Crow's Foot) siempre que sean claros
- La justificación de decisiones es tan importante como las decisiones mismas
