# ActividadViewsSQL — Vistas + Campos calculados + Agregaciones (GROUP BY / HAVING)

En esta actividad vas a construir **vistas SQL** que generan reportes reutilizables, usando:
- **Funciones agregadas** (SUM, COUNT, AVG, MIN, MAX)
- **GROUP BY**
- **HAVING**
- **Campos calculados** (ej. promedios, totales, ratios, COALESCE, CASE)

Cada equipo (A–F) trabaja en **su propio archivo** de vistas.

---

## Requisitos
- Docker + Docker Compose (v2)
- Git
- (Opcional) Cliente SQL: DBeaver / TablePlus / pgAdmin

---

## Estructura del repo
- `docker-compose.yml` levanta PostgreSQL
- `db/` contiene los scripts base:
  - `schema.sql` (estructura)
  - `seed.sql` (datos)
  - `migrate.sql` (migraciones/ajustes si aplica)
  - `equipos/<X>/views.sql` (TU ENTREGA: vistas por equipo)
- `reset.sh` reinicia el estado para volver a ejecutar desde cero
- `InstruccionesClase.md` contiene la actividad paso a paso
- `instructor_only/` (solo docente) autograder + answer keys

---

## Quick start (levantar ambiente)
1) Levanta Postgres:
```bash
docker compose up -d
````

2. (Recomendado) Reinicia la BD antes de empezar:

```bash
./reset.sh
```

3. Ejecuta scripts base (si tu `reset.sh` ya lo hace, omite este paso):

```bash
# Ajusta el nombre del servicio si no es "db"
docker compose exec -T db psql -U postgres -d postgres -f db/migrate.sql
docker compose exec -T db psql -U postgres -d postgres -f db/schema.sql
docker compose exec -T db psql -U postgres -d postgres -f db/seed.sql
```

4. Ejecuta tus vistas (ejemplo Equipo A):

```bash
docker compose exec -T db psql -U postgres -d postgres -f db/equipos/A/views.sql
```

5. Verifica rápido (ejemplos):

```bash
docker compose exec -T db psql -U postgres -d postgres -c "SELECT * FROM vw_top_productos_A LIMIT 10;"
docker compose exec -T db psql -U postgres -d postgres -c "SELECT * FROM vw_ventas_mensuales_A LIMIT 10;"
docker compose exec -T db psql -U postgres -d postgres -c "SELECT * FROM vw_clientes_valor_A LIMIT 10;"
```

---

## ¿Qué se hará en la actividad?

Vas a implementar **3 vistas** de reporteo para tu equipo:

1. Top productos (agregación por producto)
2. Ventas mensuales (agregación por mes)
3. Valor de clientes (agregación por cliente)

Detalles completos: **`InstruccionesClase.md`**.
