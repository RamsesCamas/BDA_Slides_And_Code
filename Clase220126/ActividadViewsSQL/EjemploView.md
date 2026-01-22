# Ejemplo: Views y EXPLAIN en PostgreSQL

Este documento explica de forma simple como funcionan las views (vistas) y
como usar EXPLAIN para entender el plan de ejecucion. Incluye sintaxis basica
que puedes copiar y adaptar.

## Que es una view
- Una view es una consulta guardada con nombre.
- No guarda datos (a menos que sea una MATERIALIZED VIEW).
- Actua como una tabla virtual: puedes hacer SELECT sobre ella.
- Al ejecutar SELECT, el optimizador expande la view y genera un plan.

Usos comunes:
- Reutilizar consultas complejas.
- Encapsular joins y agregaciones.
- Exponer solo ciertas columnas (seguridad/contratos).
- Mantener consultas consistentes en reportes.

## Sintaxis basica de views
Crear:
```sql
CREATE VIEW nombre_view AS
SELECT ...
FROM ...
WHERE ...;
```

Reemplazar:
```sql
CREATE OR REPLACE VIEW nombre_view AS
SELECT ...;
```

Eliminar:
```sql
DROP VIEW IF EXISTS nombre_view;
```

Consultar:
```sql
SELECT * FROM nombre_view LIMIT 10;
```

## Que es EXPLAIN
EXPLAIN muestra el plan que PostgreSQL usaria para ejecutar una consulta.
No ejecuta la consulta (a menos que uses ANALYZE).

Sintaxis:
```sql
EXPLAIN SELECT ...;
EXPLAIN (ANALYZE, BUFFERS) SELECT ...;
```

Tips:
- EXPLAIN: muestra estimaciones (costos, filas, tipo de scan).
- EXPLAIN ANALYZE: ejecuta la consulta y muestra tiempos reales.
- Si haces EXPLAIN sobre una view, veras el plan de la consulta expandida.

## Como usarlo con views
1) Crea la view.
2) Ejecuta EXPLAIN con un SELECT sobre la view.
3) Interpreta el plan y ajusta indices o filtros si hace falta.

## Archivos de ejemplo
- `views_example.sql` incluye 5 views con EXPLAIN y comentarios.

Para ejecutar:
```bash
docker compose exec -T postgres psql -U postgres -d actividad_db -f views_example.sql
```

Si tu servicio o DB cambian, ajusta `postgres` y `actividad_db`.
