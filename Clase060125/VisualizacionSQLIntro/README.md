# SQL Lab - Demo Visual (Simplificado)

**Versión**: 2.0  
**Estado**: ✅ Funcional  
**Fecha**: Enero 2025

## 🚀 Inicio Rápido

```bash
cd VisualizacionSQLIntro
docker compose up -d
```

**Links de acceso:**
- 📱 Frontend: http://localhost:3000
- ⚙️ Backend API: http://localhost:8000
- 📚 API Docs: http://localhost:8000/docs
- 🗄️ PostgreSQL: `docker compose exec db psql -U postgres -d bda_class`

---

## 📊 Qué hace este proyecto

Es una **herramienta de demostración visual de SQL** para la clase de Bases de Datos Avanzadas. No requiere autenticación ni configuración.

### Características principales:
- ✅ **Sin autenticación**: Todos tienen acceso completo
- ✅ **No wizard**: Va directo a las queries
- ✅ **Visualización interactiva**: Ejecuta queries y muestra resultados
- ✅ **7 queries predefinidas** sobre datos de ejemplo
- ✅ **Explicación detallada** de cada query (qué hace, qué conceptos usa)

---

## 📋 Estructura del Proyecto

```
VisualizacionSQLIntro/
├── docker-compose.yml          # Configuración de servicios
├── backend/                      # API FastAPI simplificada
│   ├── main.py                  # Endpoints de queries
│   ├── queries.sql               # 7 queries SQL
│   ├── requirements.txt
│   ├── sql_scripts/
│   │   ├── schema.sql
│   │   └── seed.sql
│   └── Dockerfile
└── frontend/                     # React + Vite
    ├── src/
    │   ├── App.jsx              # App React simplificada
    │   ├── index.css             # Estilos
    │   └── index.html
    ├── package.json
    └── Dockerfile
```

---

## 🎓 Queries Disponibles

### 📊 Query 1: Empleados con Departamento
**Propósito**: Demostrar JOINs básicos entre tablas

```sql
SELECT 
    e.first_name,
    e.last_name,
    e.email,
    e.position,
    d.name AS department_name
FROM employees e
LEFT JOIN departments d ON e.department_id = d.id
ORDER BY e.last_name, e.first_name;
```

**Conceptos SQL**:
- `LEFT JOIN`: Devuelve todos los empleados, incluso sin departamento
- Alias: `AS department_name`
- Ordenamiento: `ORDER BY` con múltiples columnas

---

### 📊 Query 2: Salario Promedio por Departamento
**Propósito**: Demostrar agregación con `GROUP BY`, funciones de agregación y redondeo

```sql
SELECT 
    d.name AS department_name,
    COUNT(e.id) AS employee_count,
    ROUND(AVG(e.salary), 2) AS average_salary,
    ROUND(MAX(e.salary), 2) AS max_salary,
    ROUND(MIN(e.salary), 2) AS min_salary
FROM departments d
LEFT JOIN employees e ON d.id = e.department_id
GROUP BY d.id, d.name
ORDER BY average_salary DESC;
```

**Conceptos SQL**:
- `GROUP BY`: Agrupar resultados por departamento
- `COUNT`, `AVG`, `MAX`, `MIN`: Funciones de agregación
- `ROUND`: Redondear a 2 decimales
- `LEFT JOIN` con agregación: Permite departamentos sin empleados

---

### 📊 Query 3: Empleados con Salario Alto
**Propósito**: Demostrar subconsultas en `WHERE` y comparación con promedio

```sql
SELECT 
    first_name,
    last_name,
    email,
    salary,
    position
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees)
ORDER BY salary DESC;
```

**Conceptos SQL**:
- Subquery en `WHERE`: Comparación con promedio
- Filtrado de salario: `salary > AVG(salary)`

---

### 📊 Query 4: Proyectos Activos
**Propósito**: Demostrar JOIN múltiples y agregación condicional

```sql
SELECT 
    p.name AS project_name,
    p.status,
    p.budget,
    COUNT(pa.employee_id) AS assigned_employees,
    SUM(pa.hours_worked) AS total_hours_worked
FROM projects p
LEFT JOIN project_assignments pa ON p.id = pa.project_id
WHERE p.status = 'active'
GROUP BY p.id, p.name, p.status, p.budget
ORDER BY assigned_employees DESC;
```

**Conceptos SQL**:
- `COUNT` + `SUM` en el mismo query
- `WHERE` para filtrar solo proyectos activos
- `GROUP BY` con múltiples columnas

---

### 📊 Query 5: Top 3 Empleados más Activos
**Propósito**: Demostrar `GROUP BY` + `COUNT` + `SUM` + `ORDER BY` + `LIMIT`

```sql
SELECT 
    e.first_name,
    e.last_name,
    e.position,
    COUNT(pa.id) AS project_count,
    SUM(pa.hours_worked) AS total_hours
FROM employees e
JOIN project_assignments pa ON e.id = pa.employee_id
GROUP BY e.id, e.first_name, e.last_name, e.position
ORDER BY total_hours DESC
LIMIT 3;
```

**Conceptos SQL**:
- `COUNT` para contar proyectos por empleado
- `SUM` para sumar horas
- `GROUP BY` con alias para múltiples columnas
- `LIMIT` para ranking Top-N

---

### 📊 Query 6: Presupuesto vs Salarios
**Propósito**: Demostrar cálculos aritméticos en SQL

```sql
SELECT 
    d.name AS department_name,
    d.budget AS department_budget,
    COALESCE(SUM(e.salary), 0) AS total_salaries,
    d.budget - COALESCE(SUM(e.salary), 0) AS remaining_budget
FROM departments d
LEFT JOIN employees e ON d.id = e.department_id
GROUP BY d.id, d.name, d.budget
ORDER BY remaining_budget DESC;
```

**Conceptos SQL**:
- `COALESCE`: Manejo de NULL values
- Operaciones aritméticas: `SUM`, resta
- `GROUP BY` + cálculos en SELECT
- Orden descendente por presupuesto restante

---

### 📊 Query 7: Proyectos Próximos a Vencer
**Propósito**: Demostrar `CASE WHEN` + cálculos de fechas + `BETWEEN` para rangos

```sql
SELECT 
    p.name AS project_name,
    p.end_date,
    p.status,
    p.budget,
    d.name AS department_name,
    CASE 
        WHEN p.end_date < CURRENT_DATE THEN 'Vencido'
        WHEN p.end_date = CURRENT_DATE THEN 'Vence hoy'
        ELSE 'Activo'
    END AS status_label
FROM projects p
JOIN departments d ON p.department_id = d.id
WHERE p.end_date BETWEEN CURRENT_DATE AND (CURRENT_DATE + INTERVAL '30 days')
   OR p.end_date < CURRENT_DATE
ORDER BY p.end_date;
```

**Conceptos SQL**:
- `CASE WHEN`: Lógica condicional en SELECT
- `CURRENT_DATE`: Fecha actual
- `INTERVAL '30 days'`: Cálculo de fechas
- `BETWEEN`: Rango de fechas
- `OR` condiciones lógicas

---

## 🎯 Conceptos SQL Enseñados por las Queries

### **1. Fundamentos de SELECT**
- Proyecciones: `SELECT columnas FROM tabla`
- Alias: `AS alias_nombre`
- Filtrado: `WHERE condiciones`
- Ordenamiento: `ORDER BY columnas`

### 2. JOINs**
- `INNER JOIN`: Solo coincidencias
- `LEFT JOIN`: Todos de la tabla izquierda
- RIGHT JOIN`: Todos de la derecha
- `FULL JOIN`: Todas las coincidencias + no coincidencias

### 3. Agregación**
- `COUNT(*)`: Contar filas
- `AVG(column)`: Promedio
- `SUM(column)`: Suma total
- `MAX(column)`: Valor máximo
- `MIN(column)`: Valor mínimo
- `ROUND(expr, n)`: Redondeo a n decimales

### 4. Subconsultas**
- En `WHERE`: Filtrado con subquery
- En `SELECT`: Cálculos en FROM/JOIN
- En FROM: Crear tablas temporales

### 5. Group By**
- Agrupar por 1 o más columnas
- Funciones de agregación con `GROUP BY`
- Múltiples columnas en `GROUP BY`

### 6. Funciones de Cadena y Fechas**
- `CASE WHEN`: Lógica condicional en SELECT
- `COALESCE(val, default)`: Manejo de NULL
- `CURRENT_DATE`: Fecha actual
- `INTERVAL`: Operaciones aritméticas
- `BETWEEN`: Rango de fechas
- `<`, `<=`, `>`, `>=`, `BETWEEN`

---

## 🎨 Estilos de Visualización

### 📊 Tablas con Headers
- Filas con coloreado alterado para legibilidad
- Sticky headers al hacer scroll

### 🎨 Resaltado de Información
- **Negrita**: Títulos importantes
- **Colores**: Azul (#667eea) para headers
- **Fondo alternado**: Blanco (#ffffff) y gris claro (#f7fafc)

### 📊 Layouts
- **Grid**: 2 columnas para Query 1 y Query 6
- **Responsive**: Scroll horizontal en móviles
- **Alineamiento**: Izquierda para texto, derecha para números

---

## 🔧 Comandos para Desarrollo y Pruebas

### Levantar el proyecto:
```bash
cd VisualizacionSQLIntro
docker compose up -d
```

### Ver logs en tiempo real:
```bash
# Todos los servicios
docker compose logs -f

# Solo backend
docker compose logs -f backend

# Solo frontend
docker compose logs -f frontend

# Solo base de datos
docker compose logs -f db
```

### Entrar a la base de datos:
```bash
docker compose exec db psql -U postgres -d bda_class
```

### Ejecutar scripts SQL manualmente:
```bash
# Ver schema
docker compose exec -T db psql -U postgres -d bda_class -f /docker-entrypoint-initdb.d/01_schema.sql

# Ver seed
docker compose exec -T db psql -U postgres -d bda_class -f /docker-entrypoint-initdb.d/02_seed.sql

# Ejecutar queries.sql completo
docker compose exec -T db psql -U postgres -d bda_class -f /app/queries.sql
```

### Reiniciar servicios:
```bash
# Reiniciar todos
docker compose restart

# Reiniciar un servicio
docker compose restart backend
docker compose restart frontend
docker compose restart db
```

### Detener todo y limpiar datos:
```bash
# Detener servicios
docker compose down

# Detener y eliminar datos
docker compose down -v
```

### Recontruir imágenes:
```bash
# Reconstruir backend
docker compose up --build backend

# Reconstruir todo
docker compose up --build --build
```

---

## � Configuración de PostgreSQL

### Timeouts configurados:
- `statement_timeout`: 5 segundos
- `lock_timeout`: 2 segundos
- `idle_in_transaction_session_timeout`: 10 segundos

### Scripts de inicialización:
- `/docker-entrypoint-initdb.d/01_schema.sql`: Crea tablas, índices y trigger
- `/docker-entrypoint-initdb.d/02_seed.sql`: Inserta datos de prueba

### Datos de ejemplo:
- **Departamentos**: 5 departamentos
- **Empleados**: 12 empleados
- **Proyectos**: 5 proyectos
- **Asignaciones**: 13 asignaciones

---

## 🚀 Cómo Usar en Clase

### Para el profesor:
1. Levantar el proyecto: `docker compose up -d`
2. Compartir la URL: http://localhost:3000 con los alumnos
3. Explicar cada query, sus conceptos y patrones SQL
4. Foco en:
   - Diferencia entre INNER y LEFT JOIN
   - Cómo funciona GROUP BY
   - Cómo usar subconsultas
   - Manejo de NULL con COALESCE
   - Cálculos de fechas con BETWEEN e INTERVAL

### Para los alumnos:
1. Seleccionar una query del menú
2. Leer el código SQL visible
3. Hacer clic en "Ejecutar Query"
4. Analizar los resultados en la tabla
5. Preguntar dudas sobre el código SQL

### Ejercicio sugerido:
- "¿Qué pasaría si cambiamos `LEFT JOIN` por `INNER JOIN` en la Query 1?"
- "¿Cómo podríamos modificar la Query 2 para incluir departamentos sin empleados?"
- "¿Podríamos agregar una Query 8 que muestre el salario promedio por departamento solo de departamentos con más de 3 empleados?"

---

## 📚 Referencias

### Documentación de PostgreSQL:
- [JOIN](https://www.postgresql.org/docs/current/sql-select-joins/)
- [GROUP BY](https://www.postgresql.org/docs/current/sql-group-by.html)
- [CASE](https://www.postgresql.org/docs/current/sql-expressions/case.html)
- [Funciones](https://www.postgresql.org/docs/functions-aggregate.html)
- [Date/Time](https://www.postgresql.org/docs/current/datatype-datetime.html)
- [String Functions](https://www.postgresql.org/docs/functions-string.html)

### Tutoriales recomendados:
- [W3School SQL Tutorial](https://www.w3schools.com/sql/)
- [SQLZoo](https://sqlzoo.net/)
- [PostgreSQL Tutorial](https://www.postgresqltutorial.com/)
- [SQL Fiddle](https://sqlfiddle.com/)

---

## � Personalización

Para cambiar el puerto o configuración, edita:
- `docker-compose.yml`: Puertos y variables de entorno
- `backend/main.py`: Conexión a la base de datos
- `frontend/src/App.jsx`: Queries SQL y lógica de UI

---

## 🎯 Próximos Pasos

### Para expandir el proyecto:

1. **Agregar más queries**: Editar `backend/queries.sql`
2. **Agregar gráficos**: Integrar una librería como `recharts` o `chart.js`
3. **Exportar datos**: Agregar endpoint `/api/export/{qid}/csv` para bajar CSV
4. **Historial**: Guardar las queries ejecutadas en PostgreSQL
5. **Caché de resultados**: Guardar resultados en memoria para comparar

### Para hacer una herramienta completa:
- Agregar editor de SQL en el frontend
- Sintaxis highlighting para SQL
- Guardar queries personalizadas
- Compartir queries con la clase

---

## 📚 Problemas Conocidos y Soluciones

### Error: "syntax error at or near ':'"
- **Causa**: Query inválida, error de sintaxis
- **Solución**: Verifica paréntesis, comas, keywords

### Error: "column does not exist"
- **Causa**: Nombre de columna incorrecto
- **Solución**: Usa `information_schema.columns` para verificar nombres exactos

### Error: "must appear in the GROUP BY clause"
- **Causa**: Columna en SELECT no está en GROUP BY
- **Solución**: Agrega la columna al GROUP BY o elimínla del SELECT

### Error: "column must be in the GROUP BY clause"
- **Causa**: Intentar usar una función de agregación sin agrupar por ella
- **Solución: Agrega la función de agregación al GROUP BY o usa subquery

### Error: "division by zero"
- **Causa**: División por cero en cálculos
- **Solución: Usa `COALESCE(count, 0)` o `CASE WHEN count > 0`

---

## 🎓 FAQs

### ¿Qué base de datos usamos?
- PostgreSQL 16 Alpine
- Nombre: `bda_class`
- Usuario: `postgres`
- Contraseña: `postgres`

### ¿Cuántos datos hay en cada tabla?
- Departments: 5 departamentos
- Employees: 12 empleados
- Projects: 5 proyectos
- Assignments: 13 asignaciones
- Queries: 7 queries predefinidas

### ¿Cómo persisten los datos?
- Volumen Docker: `postgres_data` → `/var/lib/postgresql/data`
- Los datos NO se pierden al detener el contenedor, a menos que borres el volumen

### ¿Puedo ejecutar mis propias queries?
- Sí, usando: `docker compose exec -T db psql -U postgres -d bda_class -c 'SELECT * FROM employees LIMIT 5;'`
- Puedes usar `psql` con más flags:
  - `-A` para alinear resultados
  - `-t` = '' para separar columnas con '|'
  - `-E` para eliminar alineación

---

## 📊 Estado del Proyecto

- ✅ Frontend: React 18 + Vite
- ✅ Backend: FastAPI 2.0 + Python 3.11
- ✅ Base de datos: PostgreSQL 16 Alpine
- ✅ Queries: 7 queries predefinidas
- ✅ Docker Compose: V2.x
- ✅ Scripts SQL: Schema, seed y queries separados

---

## 🎓 Cómo Extender el Proyecto

### Ideas para más queries:

1. **Estadísticas de salarios**:
   - Histograma de salarios
   - Percentiles por departamento
   - Comparación salarial entre departamentos

2. **Análisis de proyectos**:
   - Proyectos activos vs completados
   - Presupuesto vs horas trabajadas
   - Proyectos por departamento

3. **Análisis de empleados**:
   - Antigüedad de la empresa (usando `hire_date`)
   - Turnover por departamento
   - Crecimiento y antigüedad promedio

4. **Gráficos interactivos**:
   - Gráfico de barras de salarios por departamento
   - Gráfico de horas por proyecto
   - Gráfico circular de distribución de empleados
   - Timeline de proyectos

5. **Búsqueda y filtros**:
   - Búsqueda por nombre/apellido/posición
   - Filtrado por rango de salario
   - Filtrado por departamento
   - Filtrado por estado de proyecto
   - Ordenamiento dinámico por cualquier columna

6. **Exportar datos**:
   - Exportar tabla completa a CSV
   - Exportar resultados de query específico a CSV
   - Exportar esquema completo a SQL

7. **Comparaciones**:
   - Comparar salarios por departamentos
   - Comparar proyectos por presupuesto
   - Comparar proyectos por horas trabajadas

8. **Histórico de ejecución**:
   - Registrar cada query ejecutada
   - Guardar timestamp y resultados
   - Guardar parámetros de búsqueda/filtrado

9. **Gestión de marcadores**:
- Marcar queries como favoritas
- Guardar notas explicativas para cada query
- Crear colecciones de queries personalizadas

---

## 🎉 Resumen para la clase

Este proyecto simplificado es **mucho más fácil** que el wizard de 7 pasos original:

✅ **Más simple para aprender**:
- No autenticación requerida
- Todo visible desde el inicio
- Código SQL visible para análisis
- Ejecución interactiva de queries
- Resultados en tiempo real

✅ **Mejor para demostraciones**:
- Profesor puede explicar cada query en vivo
- Alumnos pueden ver código y resultados simultáneamente
- Fácil probar variar queries y ver resultados
- Perfecto para enseñar conceptos SQL

✅ **Fácil de personalizar**:
- Agregar nuevas queries es tan simple como agregar al archivo `queries.sql`
- No hay lógica de autenticación que modificar
- Todos ejecutan en el mismo schema `public`

✅ **Fácil de mantener**:
- Solo 1 archivo para queries: `backend/queries.sql`
- Sin lógica compleja de navegación
- Sin estados ni pasos ni checkpoints

---

## 🎯 Recomendaciones de Uso en Clase

### Para el Profesor:
1. Levantar el proyecto antes de la clase: `docker compose up -d`
2. Proyectar la página web: http://localhost:3000
3. Explicar el propósito de cada query
4. Usar ejemplos del dataset para demostraciones
5. Fomentar preguntas: "¿Qué pasaría si cambiamos LEFT JOIN por INNER JOIN?"
6. Mostar cómo optimizar queries con EXPLAIN ANALYZE
7. Explicar los conceptos de SQL mostrados

### Para los Alumnos:
1. Seleccionar una query del menú
2. Leer y analizar el código SQL visible
3. Hacer clic en "Ejecutar Query"
4. Estudiar los resultados en la tabla
5. Preguntar sobre dudas sobre el código SQL
6. Experimentar con variaciones de las queries
7. Discutir con compañeros los conceptos aprendidos

### Ejemplos de Preguntas:
- "¿Por qué usamos LEFT JOIN en la Query 1?"
- "¿Qué hace ROUND(x, 2)? ¿Qué significa el 2?"
- "¿Cuál es la diferencia entre INNER JOIN y LEFT JOIN?"
- "¿Cómo funciona la subquery en la Query 3?"
- "¿Por qué usamos GROUP BY en la Query 2?"
- "¿Cuándo usar COUNT vs COUNT(*) en la Query 2?"
- "¿Qué hace COALESCE? Por qué es necesario?"
- "¿Por qué usamos CASE WHEN en la Query 7?"
- "¿Cuál es el propósito del INTERVAL en la Query 7?"
- "¿Cuál es la diferencia entre <, <=, >, >=, BETWEEN?"
- "¿Por qué usamos ORDER BY en todas las queries?"
- "¿Qué pasa si usamos ORDER BY nombre en una columna de texto?"

---

## 🚀 ¡Listo para la clase! 🎓

Para más información, revisa la documentación de PostgreSQL en https://www.postgresql.org/docs/