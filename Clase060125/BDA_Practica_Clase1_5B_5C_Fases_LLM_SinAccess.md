# BDA — Clase 1 (Práctica 5B y 5C) — **Sin Cloudflare Access** (Construcción por fases para un LLM)

> **Contexto**: el laboratorio corre en la MacBook del profesor. Los alumnos se conectan desde navegador usando **Cloudflare Tunnel** (sin Access).  
> **Objetivo didáctico**: ejecutar comandos y scripts de Postgres (`schema.sql`, `seed.sql`, `queries.sql`) y ver reflejados los cambios.  
> **Nota clave**: si no usas Access, **tu app queda accesible públicamente** por internet durante la sesión. La mitigación mínima es **auth en la app** + **acciones allowlisted** + **timeouts**.

---

## 0) ¿Sigue siendo buena práctica? Sí, con mitigaciones mínimas
Esta práctica sigue siendo excelente por combinar:
- Operación real de BD + reproducibilidad (Docker)
- Migración con scripts
- Seguridad aplicada (aunque sea “lite”)

✅ **Mitigación mínima obligatoria** (por no usar Access):
1) **Auth en la app (simple y rápida)**: HTTP Basic o “token” de clase.
2) **Nada de SQL libre**: solo acciones allowlisted.
3) **Timeouts** en PostgreSQL para cortar abusos.
4) **Rate limiting** en la app (muy simple, in-memory).

---

## 1) Principios de seguridad (NO negociables)
### 1.1 No SQL libre (anti SQL Injection)
- El frontend **no** envía SQL.
- El backend solo ejecuta **acciones predefinidas**:
  - `INIT_TEAM_SCHEMA`
  - `RUN_SCHEMA`
  - `RUN_SEED`
  - `RUN_QUERY_1`, `RUN_QUERY_2`, etc.
- Si hay input (por ejemplo `team_id`), usar **allowlist** estricta.

### 1.2 Aislamiento por equipo
- 1 DB: `bda_class`
- 1 schema por equipo: `team_5b_01`, `team_5c_03`, etc.
- Recomendado: 1 rol por equipo con permisos mínimos en su schema.

### 1.3 No exponer Postgres
- **No publicar puertos** de Postgres al host.
- Solo la app web se expone vía tunnel.
- La app escucha en `127.0.0.1` (localhost).

### 1.4 Timeouts en PostgreSQL
En cada sesión/conexión:
- `SET statement_timeout = '5s';`
- `SET lock_timeout = '2s';`
- `SET idle_in_transaction_session_timeout = '10s';`

### 1.5 Limitar impacto en el host (hardening básico)
- Si dockerizas la app:
  - `read_only: true`
  - `cap_drop: ["ALL"]`
  - `security_opt: ["no-new-privileges:true"]`
  - usuario no-root

---

## 2) Arquitectura recomendada (simple y rápida para aula)
### Opción recomendada: Docker Compose (app + db) + **Quick Tunnel**
- `app` (FastAPI) escucha en `127.0.0.1:8080`
- `db` (postgres) solo en red interna docker (sin puertos publicados)
- `cloudflared` (Quick Tunnel) se ejecuta en el host con 1 comando

**Motivo**: Quick Tunnel genera un subdominio aleatorio y proxya a tu localhost sin tocar DNS. Ideal para una práctica de 30 min.

---

## 3) Fase 1 — SQL Lab Web (guiado) + Cloudflare Tunnel (sin Access)

### 3.1 Requerimientos funcionales del UI
Construye un wizard/stepper:

**Paso 0: “Entrar al laboratorio”**
- Pedir “clave de clase” (password) o usar Basic Auth (recomendado).
- Mostrar “Team” por dropdown (sin input libre).

**Paso 1: Crear mi schema (y opcional rol)**
- Botón: “Inicializar mi espacio”
- Mostrar SQL didáctico (solo lectura)
- Mostrar resultado: schema creado

**Paso 2: Ver `schema.sql`** (read-only)
**Paso 3: Ejecutar `schema.sql`**
**Paso 4: Ver y ejecutar `seed.sql`**
**Paso 5: Ejecutar queries enumeradas**
- Q1..Qn
- Mostrar resultados en tabla

**Paso 6: Verificación final**
- Checklist + badge “COMPLETADO”

### 3.2 Auth mínima (sin Access)
Elige UNA (la más simple es Basic Auth):

#### Opción A (recomendada): HTTP Basic Auth
- Usuario fijo: `student`
- Password: `LAB_PASSWORD` (env)
- Middleware que valida header `Authorization`.
- Ventaja: no necesitas crear UI de login, el navegador lo maneja.

#### Opción B: token de clase
- En la landing: input “clave” → se guarda en cookie `HttpOnly` o en memoria.
- Cada request exige `X-Lab-Token` o cookie válida.
- Rotar token al iniciar clase y **apagar tunnel al terminar**.

> Importante: sin Access, **esto es lo mínimo** para evitar que cualquier bot de internet use tu laboratorio.

### 3.3 Contratos API (sin SQL libre)
Endpoints:
- `GET /api/health`
- `GET /api/teams` → lista allowlisted (ej. `team_5b_01`...)
- `POST /api/steps/init` → inicializa schema del team
- `GET /api/sql/schema` → devuelve el archivo (read-only)
- `POST /api/run/schema` → ejecuta schema.sql (en el schema del team)
- `GET /api/sql/seed`
- `POST /api/run/seed`
- `GET /api/queries` → lista de queries (Q1..Qn)
- `POST /api/run/query/{qid}` → ejecuta una query allowlisted
- `GET /api/introspect` → tablas/constraints (solo del schema del team)

### 3.4 Implementación DB: aislamiento por schema
- Backend determina el schema con allowlist:
  - `schema = team_id`
- Antes de ejecutar scripts:
  - `SET search_path TO <schema>;`
- **Nunca** uses concatenación libre de strings para armar SQL con datos del usuario.

### 3.5 Rate limiting (mínimo viable)
- In-memory (por IP):
  - max 30 req/min
- Si excede → 429
- Loggear `ip`, `team`, `endpoint`, `latency`

### 3.6 Quick Tunnel (para clase)
Precondición: la app corre en `http://127.0.0.1:8080`.

Comando:
- `cloudflared tunnel --url http://localhost:8080`

El comando imprime una URL tipo `https://<random>.trycloudflare.com`.
- Compartes esa URL + password (si usas Basic Auth o token).
- Al terminar la práctica: CTRL+C (apagar tunnel).

### 3.7 Criterios de aceptación (Fase 1)
- Un team no puede ver objetos de otro schema.
- No hay endpoint que reciba SQL libre.
- Si alguien spamea, el rate limit actúa.
- Queries pesadas mueren por `statement_timeout`.
- Postgres no tiene puertos expuestos.

---

## 4) Fase 2 — Alumno crea Postgres en Docker + migración por script
### Objetivo
Cada alumno:
1) crea su imagen `postgres:16-alpine`
2) levanta contenedor con volumen
3) se conecta desde script (Python/Node)
4) aplica `schema.sql`, `seed.sql`, `queries.sql`

### Requisitos mínimos
- `Dockerfile` (o solo `docker run` si quieres simplificar)
- `migrate.py` / `migrate.ts` que:
  1) espera a que Postgres esté listo
  2) ejecuta schema
  3) ejecuta seed
  4) corre queries y muestra resultados

### Entregables
- `Dockerfile` o `compose.yml`
- Script migración
- Evidencia (capturas + output)

---

## 5) Fase 3 — Repo del profe “optimizado” (sin rebuild)
### Objetivo
Clonar repo del profe donde:
- SQL está montado como volumen
- `make migrate` aplica scripts sin `docker compose up --build`
- runner ejecuta `psql -f` bajo demanda

### Actividad final
- `make up`
- `make migrate`
- Modificar un SQL (ej. agregar columna) y correr `make migrate` otra vez
- Explicar por qué no requiere rebuild

---

## 6) Checklist final (para el LLM)
**Fase 1**
- [ ] app (FastAPI) con Basic Auth o token
- [ ] endpoints allowlisted (sin SQL libre)
- [ ] schema por team + search_path
- [ ] timeouts Postgres
- [ ] rate limit
- [ ] quick tunnel funcionando

**Fase 2**
- [ ] docker alumno + migración script

**Fase 3**
- [ ] repo profe optimizado + runner + Makefile

---

## 7) Referencias rápidas (para el LLM)
```text
Cloudflare Tunnel (outbound-only, sin IP pública): https://developers.cloudflare.com/cloudflare-one/networks/connectors/cloudflare-tunnel/
Quick Tunnels (trycloudflare): https://developers.cloudflare.com/cloudflare-one/networks/connectors/cloudflare-tunnel/do-more-with-tunnels/trycloudflare/
Quick Tunnels “secure by default” (HTTPS/DDoS/no open ports): https://try.cloudflare.com/

OWASP SQL Injection Prevention: https://cheatsheetseries.owasp.org/cheatsheets/SQL_Injection_Prevention_Cheat_Sheet.html
OWASP Query Parameterization: https://cheatsheetseries.owasp.org/cheatsheets/Query_Parameterization_Cheat_Sheet.html

Postgres client timeouts (statement/lock/idle): https://www.postgresql.org/docs/current/runtime-config-client.html
Postgres statement_timeout: https://postgresqlco.nf/doc/en/param/statement_timeout/
Postgres lock_timeout: https://postgresqlco.nf/doc/en/param/lock_timeout/
Postgres idle_in_transaction_session_timeout: https://postgresqlco.nf/doc/en/param/idle_in_transaction_session_timeout/
```
