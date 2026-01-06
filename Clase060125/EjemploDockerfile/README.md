# EjemploDockerfile - Migración por Script (Fase 2)

Ejemplo de cómo un alumno crea su imagen de PostgreSQL en Docker y realiza migración por script.

## 🚀 Inicio Rápido

```bash
# Opción 1: Usar docker run directamente
docker run --name my-postgres \
  -e POSTGRES_DB=mydb \
  -e POSTGRES_USER=postgres \
  -e POSTGRES_PASSWORD=postgres \
  -v $(pwd)/sql:/docker-entrypoint-initdb.d \
  -p 5432:5432 \
  -d postgres:16-alpine

# Opción 2: Usar Docker Compose (recomendado)
docker compose up -d
```

## 📝 Uso del Script de Migración

### Instalar dependencias

```bash
pip install -r requirements.txt
```

### Ejecutar migración

```bash
# Usar valores por defecto (localhost:5432)
python migrate.py

# O especificar variables de entorno
DB_HOST=localhost \
DB_PORT=5432 \
DB_NAME=mydb \
DB_USER=postgres \
DB_PASSWORD=postgres \
python migrate.py
```

## 🏗️ Estructura del Proyecto

```
EjemploDockerfile/
├── Dockerfile              # Imagen personalizada de PostgreSQL
├── docker-compose.yml      # Definición de servicios
├── migrate.py             # Script de migración
├── requirements.txt       # Dependencias Python
├── sql/
│   ├── schema.sql         # Definición de tablas
│   ├── seed.sql           # Datos de prueba
│   └── queries.sql        # Queries de ejemplo
└── README.md
```

## 📋 Qué hace migrate.py

1. **Espera a que PostgreSQL esté listo**
   - Reintenta hasta 30 veces con 2 segundos de delay
   - Verifica la conexión con `pg_isready`

2. **Ejecuta schema.sql**
   - Crea las tablas en la base de datos
   - Muestra confirmación de éxito/error

3. **Ejecuta seed.sql** (opcional)
   - Inserta datos de prueba
   - Muestra confirmación de éxito/error

4. **Ejecuta queries.sql** (opcional)
   - Parsea las queries predefinidas
   - Ejecuta cada query
   - Muestra resultados en formato tabular
   - Indica total de filas

## 🔌 Conexión a la Base de Datos

### Usando psql

```bash
# Desde el host
psql -h localhost -p 5432 -U postgres -d mydb

# Desde dentro del contenedor
docker exec -it ejemplodockerfile-db psql -U postgres -d mydb
```

### Usando Python

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

### Usando DBeaver o pgAdmin

- Host: `localhost`
- Port: `5432`
- Database: `mydb`
- Username: `postgres`
- Password: `postgres`

## 📊 Scripts SQL

### schema.sql
Define la estructura de la base de datos:
- Tablas: departments, employees, projects, project_assignments
- Índices para optimización
- Trigger para timestamps

### seed.sql
Inserta datos de prueba:
- 5 departamentos
- 12 empleados
- 5 proyectos
- 13 asignaciones

### queries.sql
7 queries predefinidas para análisis de datos:
1. Empleados con departamento
2. Salario promedio por departamento
3. Empleados con salario alto
4. Proyectos activos
5. Top 3 empleados más activos
6. Presupuesto vs salarios
7. Proyectos próximos a vencer

## 🎯 Objetivo Didáctico

Este proyecto enseña:
- ✅ Crear una imagen personalizada de PostgreSQL
- ✅ Montar scripts SQL en `/docker-entrypoint-initdb.d/`
- ✅ Crear un script de migración en Python
- ✅ Esperar a que la base de datos esté lista
- ✅ Ejecutar scripts en orden (schema → seed → queries)
- ✅ Manejar errores y mostrar resultados
- ✅ Usar volúmenes para persistencia

## 🔧 Variables de Entorno

| Variable | Por defecto | Descripción |
|----------|-------------|-------------|
| `DB_HOST` | `localhost` | Host de PostgreSQL |
| `DB_PORT` | `5432` | Puerto de PostgreSQL |
| `DB_NAME` | `mydb` | Nombre de la base de datos |
| `DB_USER` | `postgres` | Usuario de PostgreSQL |
| `DB_PASSWORD` | `postgres` | Contraseña de PostgreSQL |

## 🧹 Limpieza

```bash
# Detener contenedor
docker compose down

# Eliminar contenedor y volúmenes
docker compose down -v

# Si usaste docker run
docker stop my-postgres
docker rm my-postgres
docker volume prune
```

## 📚 Referencias

- [PostgreSQL Docker Image](https://hub.docker.com/_/postgres)
- [Initialization Scripts](https://hub.docker.com/_/postgres/#initialization-scripts)
- [psycopg2 Documentation](https://www.psycopg.org/docs/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)

## 📸 Ejemplo de Salida

```
🚀 Iniciando migración de base de datos
================================================================================
⏳ Esperando a que PostgreSQL esté listo en localhost:5432...
✅ PostgreSQL está listo!

✅ Conectado a PostgreSQL: localhost:5432/mydb

⚡ Ejecutando Schema: sql/schema.sql
✅ Schema ejecutado exitosamente

⚡ Ejecutando Seed: sql/seed.sql
✅ Seed ejecutado exitosamente

🔍 Ejecutando query: Query 1: Empleados con Departamento
================================================================================
📊 Resultados:
--------------------------------------------------------------------------------
first_name              last_name               email                   department_name         
--------------------------------------------------------------------------------
Carlos                  García                  carlos.garcia@company.com Ingeniería de Software
María                   Rodríguez                maria.rodriguez@company.com Ingeniería de Software
...
--------------------------------------------------------------------------------
📈 Total filas: 12

================================================================================
🎉 Migración completada exitosamente!
```
