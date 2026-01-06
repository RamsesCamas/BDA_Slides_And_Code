# RepoOptimizado - Repo del Profe (Fase 3)

Repo optimizado donde los scripts SQL se montan como volúmenes, permitiendo aplicar migraciones sin necesidad de rebuild.

## 🚀 Inicio Rápido

```bash
# Iniciar el entorno
make up

# Ejecutar migraciones
make migrate

# Ver logs
make logs
```

## 📋 Comandos Disponibles

### Gestión de Servicios

```bash
make up          # Inicia servicios en segundo plano
make down        # Detiene servicios
make restart     # Reinicia servicios
make status      # Muestra estado de servicios y volúmenes
make logs        # Muestra logs en tiempo real
```

### Migraciones

```bash
make migrate         # Ejecuta todas las migraciones (schema → seed → queries)
make migrate-schema  # Ejecuta solo el schema
make migrate-seed    # Ejecuta solo el seed
make run-queries     # Ejecuta y muestra resultados de queries
make reset           # Reinicia todo y ejecuta migraciones
```

### Interacción con la Base de Datos

```bash
make shell           # Abre shell de psql interactivo
make db cmd="..."    # Ejecuta comando SQL
make test            # Prueba conexión a la base de datos
make inspect         # Inspecciona tablas y datos
```

### Mantenimiento

```bash
make build       # Construye las imágenes
make clean       # Limpia contenedores, redes y volúmenes
make rebuild     # Reconstruye todo desde cero
make help        # Muestra ayuda completa
```

## 🏗️ Estructura del Proyecto

```
RepoOptimizado/
├── Makefile              # Comandos de automatización
├── docker-compose.yml    # Definición de servicios
├── sql/
│   ├── 01_schema.sql     # Definición de tablas
│   ├── 02_seed.sql       # Datos de prueba
│   └── 03_queries.sql    # Queries de ejemplo
├── scripts/
│   └── runner.sh         # Script de ejecución de SQL
└── README.md
```

## 🔑 Concepto Clave: Sin Rebuild

### ❌ Enfoque tradicional (ineficiente)

```bash
# Paso 1: Modificar SQL
vim sql/schema.sql

# Paso 2: Rebuild (LLEVA TIEMPO)
docker compose down
docker compose up --build

# ⏱️ Tiempo: 2-5 minutos para cambios simples
```

### ✅ Enfoque optimizado (rápido)

```bash
# Paso 1: Modificar SQL (volumen)
vim sql/schema.sql

# Paso 2: Reaplicar migración (INSTANTÁNEO)
make migrate

# ⏱️ Tiempo: 1-2 segundos para cambios simples
```

## 📚 Por qué funciona

### Montaje como Volumen

```yaml
volumes:
  - pgdata:/var/lib/postgresql/data    # Persistencia
  - ./sql:/sql                         # Scripts SQL montados
```

Los scripts SQL se montan como un volumen en `/sql`, lo que significa:
- ✅ Los archivos están disponibles en el contenedor en tiempo real
- ✅ Los cambios se reflejan inmediatamente
- ✅ No es necesario rebuild del contenedor
- ✅ Se pueden ejecutar scripts bajo demanda con `psql -f`

### Ejecución con psql

```bash
make migrate
```

Ejecuta:

```bash
docker compose exec db psql -U postgres -d mydb -f /sql/01_schema.sql
docker compose exec db psql -U postgres -d mydb -f /sql/02_seed.sql
docker compose exec db psql -U postgres -d mydb -f /sql/03_queries.sql
```

## 🎯 Flujo de Trabajo Típico

### Escenario 1: Agregar una columna

```bash
# 1. Modificar el schema.sql
vim sql/01_schema.sql

# 2. Ejecutar migración (instantáneo)
make migrate-schema

# 3. Verificar cambios
make inspect
```

### Escenario 2: Agregar datos de prueba

```bash
# 1. Modificar el seed.sql
vim sql/02_seed.sql

# 2. Resetear y aplicar
make reset

# 3. Verificar datos
make db cmd="SELECT COUNT(*) FROM employees;"
```

### Escenario 3: Prueba de nueva query

```bash
# 1. Agregar query a 03_queries.sql
vim sql/03_queries.sql

# 2. Ejecutar y ver resultados
make run-queries
```

## 🖥️ Script Runner Alternativo

También puedes usar el script `runner.sh`:

```bash
# Ejecutar todos los scripts
docker compose exec runner /scripts/runner.sh all

# Ejecutar solo schema
docker compose exec runner /scripts/runner.sh schema

# Ejecutar solo seed
docker compose exec runner /scripts/runner.sh seed

# Ver ayuda
docker compose exec runner /scripts/runner.sh help
```

## 📊 Scripts SQL

### 01_schema.sql
Definición de estructura:
- Tablas: departments, employees, projects, project_assignments
- Índices para performance
- Triggers para timestamps automáticos

### 02_seed.sql
Datos de prueba:
- 5 departamentos
- 12 empleados
- 5 proyectos
- 13 asignaciones

### 03_queries.sql
Queries de ejemplo:
- 7 queries con JOIN, GROUP BY, subconsultas
- Listas para referencia

## 🔧 Variables de Entorno

El proyecto usa valores por defecto, pero puedes personalizar:

```bash
# En docker-compose.yml
environment:
  POSTGRES_DB: mydb
  POSTGRES_USER: postgres
  POSTGRES_PASSWORD: postgres

# En runner.sh
export DB_HOST=db
export DB_PORT=5432
export DB_NAME=mydb
export DB_USER=postgres
export DB_PASSWORD=postgres
```

## 🧰 Servicios

### db
PostgreSQL 16 Alpine con:
- Datos persistentes en volumen `pgdata`
- Scripts montados en `/sql`
- Health check automático
- Puerto expuesto: 5432

### runner
Contenedor auxiliar para ejecutar scripts:
- Imagen PostgreSQL 16 Alpine
- Scripts montados en `/scripts`
- Depende de `db` (health check)
- Para ejecución bajo demanda

## 📖 Ejemplos de Uso

### Crear nuevo esquema de migración

```bash
# 1. Crear nuevo archivo SQL
echo "CREATE TABLE test (id INT);" > sql/04_test.sql

# 2. Ejecutar manualmente
make db cmd="\\i sql/04_test.sql"

# 3. Verificar
make db cmd="\\dt"
```

### Backup de datos

```bash
# Dump de toda la base de datos
docker compose exec db pg_dump -U postgres mydb > backup.sql

# Restaurar
docker compose exec -T db psql -U postgres mydb < backup.sql
```

### Consultas rápidas

```bash
# Contar filas
make db cmd="SELECT COUNT(*) FROM employees;"

# Ver estructura de tabla
make db cmd="\\d employees"

# Listar todas las tablas
make db cmd="\\dt"
```

## 🧹 Limpieza

```bash
# Detener servicios
make down

# Eliminar datos (volumen)
make clean

# Reconstruir todo
make rebuild
```

## 🎓 Objetivo Didáctico

Este proyecto enseña:
- ✅ Montaje de scripts SQL como volúmenes
- ✅ Ejecución bajo demanda sin rebuild
- ✅ Uso de Makefiles para automatización
- ✅ Workflows eficientes de desarrollo
- ✅ Separación de código y datos
- ✅ Comandos de psql para migraciones

## 📚 Comparación

| Aspecto | Con Rebuild | Sin Rebuild (Volumen) |
|---------|-------------|----------------------|
| Modificar SQL | Editar + rebuild | Editar + migrate |
| Tiempo cambio | 2-5 min | 1-2 seg |
| Imagen base | Cada cambio | Una vez |
| Cache Docker | Inútil | Útil |
| Iteración | Lenta | Rápida |

## 🔗 Conexión desde aplicaciones

### Python (psycopg2)

```python
import psycopg2

conn = psycopg2.connect(
    host='localhost',
    port=5432,
    database='mydb',
    user='postgres',
    password='postgres'
)
```

### Node.js (pg)

```javascript
const { Pool } = require('pg');
const pool = new Pool({
  host: 'localhost',
  port: 5432,
  database: 'mydb',
  user: 'postgres',
  password: 'postgres'
});
```

### DBeaver / pgAdmin / TablePlus

- Host: `localhost`
- Port: `5432`
- Database: `mydb`
- Username: `postgres`
- Password: `postgres`

## 📸 Salida Ejemplo

```bash
$ make migrate
🔄 Ejecutando migraciones...
✅ Schema aplicado
✅ Seed aplicado
✅ Queries ejecutadas

$ make inspect
📋 Inspeccionando base de datos...
          List of relations
 Schema |       Name        | Type  |  Owner   
--------+-------------------+-------+----------
 public | departments      | table | postgres
 public | employees        | table | postgres
 public | project_assignments | table | postgres
 public | projects         | table | postgres

📊 Filas por tabla:
 schemaname |       tablename       | n_live_tup 
------------+-----------------------+------------
 public     | departments           |          5
 public     | employees             |         12
 public     | projects              |          5
 public     | project_assignments   |         13
```
