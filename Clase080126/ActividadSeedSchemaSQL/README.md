# 🗄️ Actividad: Schema, Seed y Verificación en PostgreSQL

## 📋 Descripción
Actividad práctica grupal para diseñar, poblar y verificar una base de datos PostgreSQL siguiendo buenas prácticas de modelado e integridad referencial.

---

## 👥 Roles del Equipo

| Rol | Responsabilidades |
|-----|-------------------|
| **🎮 Driver** | Ejecuta comandos, edita archivos |
| **🧭 Navigator** | Revisa modelo, detecta FK/constraints, orden de ejecución |
| **📝 Scribe** | Arma `data_dictionary.md`, documenta evidencias |
| **🔍 QA** | Corre scripts, busca errores, propone correcciones |

> **Si son 2 personas:** Driver+Navigator y Scribe+QA

---

## 📁 Estructura del Proyecto

```
/db
  schema.sql       # DDL: tablas, constraints, índices
  seed.sql         # DML: datos iniciales
  verify.sql       # Queries de verificación
/docs
  data_dictionary.md
README.md
docker-compose.yml
```

---

## 🚀 Paso a Paso

### Fase 1: Sanity Check + Levantar PostgreSQL (10-15 min)

```bash
# Verificar Docker
docker ps

# Levantar servicios
docker compose up -d

# Ver logs (buscar "ready to accept connections")
docker compose logs -f postgres
```

**✅ Checkpoint:**
- [ ] Contenedor corriendo sin reinicios
- [ ] Puerto y credenciales correctas

---

### Fase 2: Conexión a PostgreSQL (10-15 min)

```bash
# Conectar al contenedor
docker exec -it postgres_container psql -U postgres -d actividad_db

# Dentro de psql:
\l          # Listar bases de datos
\dt         # Listar tablas (vacío al inicio)
```

**✅ Checkpoint:**
- [ ] Conexión exitosa a la base de datos

---

### Fase 3: Crear Schema (35-45 min)

**Proceso iterativo:**
1. Driver escribe una tabla en `schema.sql`
2. QA ejecuta el script (ver opciones abajo)
3. Navigator corrige según errores
4. Repetir hasta que corra completo

**⚠️ IMPORTANTE:** Hay dos formas de ejecutar los scripts:

**Opción A: Desde tu terminal (RECOMENDADO)**
```bash
# Desde la carpeta ActividadSeedSchemaSQL:
docker exec -i postgres_container psql -U postgres -d actividad_db < db/schema.sql
```

**Opción B: Desde dentro de psql (rutas del contenedor)**
```sql
-- Si estás dentro del contenedor con psql:
\i /scripts/schema.sql

-- Verificar tablas creadas
\dt
```

> 💡 **Nota:** Si al iniciar Docker las tablas ya existen, es porque Docker autoejecutó los scripts. Esto es normal y esperado.

**✅ Checkpoint:**
- [ ] `schema.sql` corre sin errores
- [ ] `\dt` muestra todas las tablas esperadas

---

### Fase 4: Insertar Seeds (20-25 min)

**Orden de inserción:** catálogos → entidades → relaciones

**Desde terminal:**
```bash
docker exec -i postgres_container psql -U postgres -d actividad_db < db/seed.sql
```

**Desde psql (dentro del contenedor):**
```sql
\i /scripts/seed.sql

-- Verificar conteos
SELECT 'tabla_nombre' AS tabla, COUNT(*) FROM tabla_nombre;
```

**✅ Checkpoint:**
- [ ] `seed.sql` corre sin errores
- [ ] Mínimo 5 filas por tabla principal

---

### Fase 5: Verificación (15-20 min) - **Obligatorio en versión 3h**

**Desde terminal:**
```bash
docker exec -i postgres_container psql -U postgres -d actividad_db < db/verify.sql
```

**Desde psql:**
```sql
\i /scripts/verify.sql
```

**✅ Checkpoint:**
- [ ] Conteos por tabla
- [ ] 2 JOINs funcionando
- [ ] 1 agregación (GROUP BY)

---

### Fase 6: Documentación (10-15 min)

**Scribe completa:**
- [ ] `docs/data_dictionary.md` con tabla por entidad
- [ ] Evidencias en este README (abajo)

---

## ✅ Definition of Done

### Versión 2 horas
- [ ] `schema.sql` + `seed.sql` corren sin errores
- [ ] Hay evidencias documentadas
- [ ] Diccionario de datos completo

### Versión 3 horas (adicional)
- [ ] `verify.sql` obligatorio con JOINs y agregaciones
- [ ] 1 FK con ON DELETE (CASCADE/RESTRICT) justificada
- [ ] 1 CHECK adicional
- [ ] 1 índice para FK o campo de búsqueda
- [ ] Edge cases documentados (con caso fallido comentado)

---

## 📊 Evidencias

### Output de `\dt`
```
-- Pegar aquí resultado de \dt
```

### Conteos por tabla
```sql
-- Pegar aquí conteos
```

### Query con JOIN de ejemplo
```sql
-- Pegar aquí query y resultado
```

---

## 🆘 Plan B (Si Docker falla)

1. **Equipo ancla** comparte logs de éxito y comandos
2. Equipos con falla avanzan en `schema.sql` y `seed.sql` "en seco"
3. Al final, validar conectándose al Postgres del equipo ancla

---

## 🔧 Comandos Útiles

```bash
# Reiniciar contenedores
docker compose down && docker compose up -d

# Limpiar base de datos
docker compose down -v

# Ejecutar SQL desde fuera del contenedor
docker exec -i postgres_container psql -U postgres -d actividad_db < db/schema.sql
```
