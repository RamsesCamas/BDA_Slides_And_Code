-- ============================================================
-- ActividadViewsSQL - Equipo C
-- Archivo: db/equipos/C/views.sql
-- ============================================================
-- Reglas:
-- - No SELECT *
-- - Cada vista debe incluir comentario de que devuelve, grain, metricas
-- - Usar GROUP BY + HAVING + al menos 1 campo calculado
-- ============================================================

/*
VISTA 1: vw_top_productos_C
Que devuelve: TODO
Grain (una fila representa): TODO
Metricas: SUM(...), COUNT(...)
*/
CREATE OR REPLACE VIEW vw_top_productos_C AS
SELECT
    p.id AS producto_id,
    p.nombre AS producto_nombre,
    SUM(od.cantidad) AS unidades_vendidas,
    SUM(od.subtotal) AS ventas_total,
    SUM(od.subtotal) / NULLIF(SUM(od.cantidad), 0) AS precio_promedio
FROM productos p
JOIN orden_detalles od ON od.producto_id = p.id
-- TODO: agrega joins extra si necesitas (ordenes, categorias).
WHERE MOD(od.producto_id, 6) = 2
GROUP BY p.id, p.nombre
HAVING SUM(od.cantidad) >= 1;

/*
VISTA 2: vw_ventas_mensuales_C
Que devuelve: TODO
Grain (una fila representa): TODO
Metricas: COUNT DISTINCT ordenes, SUM total
*/
CREATE OR REPLACE VIEW vw_ventas_mensuales_C AS
SELECT
    EXTRACT(YEAR FROM o.created_at)::int AS anio,
    EXTRACT(MONTH FROM o.created_at)::int AS mes,
    COUNT(DISTINCT o.id) AS ordenes_count,
    SUM(o.total) AS ventas_total,
    SUM(o.total) / NULLIF(COUNT(DISTINCT o.id), 0) AS ticket_promedio
FROM ordenes o
-- TODO: si filtras por status/fecha, usa WHERE antes del GROUP BY.
WHERE MOD(o.id, 6) = 2
GROUP BY EXTRACT(YEAR FROM o.created_at), EXTRACT(MONTH FROM o.created_at)
HAVING COUNT(DISTINCT o.id) >= 1;

/*
VISTA 3: vw_clientes_valor_C
Que devuelve: TODO
Grain (una fila representa): TODO
Metricas: COUNT DISTINCT ordenes, SUM total
*/
CREATE OR REPLACE VIEW vw_clientes_valor_C AS
SELECT
    u.id AS cliente_id,
    u.nombre AS cliente_nombre,
    COUNT(DISTINCT o.id) AS ordenes_count,
    SUM(o.total) AS gasto_total,
    SUM(o.total) / NULLIF(COUNT(DISTINCT o.id), 0) AS gasto_promedio
FROM usuarios u
JOIN ordenes o ON o.usuario_id = u.id
WHERE MOD(u.id, 6) = 2
GROUP BY u.id, u.nombre
HAVING COUNT(DISTINCT o.id) >= 1;
