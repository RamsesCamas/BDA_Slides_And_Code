-- ============================================================
-- views_example.sql
-- 5 ejemplos de views con EXPLAIN y comentarios paso a paso.
-- ============================================================

-- ------------------------------------------------------------
-- Ejemplo 1: View simple de productos activos
-- 1) Se crea la view.
-- 2) EXPLAIN muestra que el SELECT sobre la view se expande.
-- 3) El SELECT real consulta la view.
-- ------------------------------------------------------------
CREATE OR REPLACE VIEW vw_productos_activos AS
SELECT
    p.id AS producto_id,
    p.nombre AS producto_nombre,
    p.precio,
    p.stock
FROM productos p
WHERE p.activo = TRUE;

EXPLAIN
SELECT * FROM vw_productos_activos;

SELECT * FROM vw_productos_activos LIMIT 5;

-- ------------------------------------------------------------
-- Ejemplo 2: View con join y agregacion por producto
-- 1) Join productos + orden_detalles.
-- 2) Se agrupa por producto.
-- 3) EXPLAIN mostrara el plan con join + aggregate.
-- ------------------------------------------------------------
CREATE OR REPLACE VIEW vw_ventas_por_producto AS
SELECT
    p.id AS producto_id,
    p.nombre AS producto_nombre,
    SUM(od.cantidad) AS unidades_vendidas,
    SUM(od.subtotal) AS ventas_total,
    SUM(od.subtotal) / NULLIF(SUM(od.cantidad), 0) AS precio_promedio
FROM productos p
JOIN orden_detalles od ON od.producto_id = p.id
GROUP BY p.id, p.nombre;

EXPLAIN
SELECT * FROM vw_ventas_por_producto;

SELECT * FROM vw_ventas_por_producto ORDER BY ventas_total DESC LIMIT 5;

-- ------------------------------------------------------------
-- Ejemplo 3: View de ordenes por usuario
-- 1) Join usuarios + ordenes.
-- 2) Agregacion por usuario.
-- 3) EXPLAIN ayuda a ver si usa indice en ordenes.usuario_id.
-- ------------------------------------------------------------
CREATE OR REPLACE VIEW vw_ordenes_por_usuario AS
SELECT
    u.id AS usuario_id,
    u.nombre AS usuario_nombre,
    COUNT(DISTINCT o.id) AS ordenes_count,
    SUM(o.total) AS gasto_total,
    SUM(o.total) / NULLIF(COUNT(DISTINCT o.id), 0) AS gasto_promedio
FROM usuarios u
JOIN ordenes o ON o.usuario_id = u.id
GROUP BY u.id, u.nombre;

EXPLAIN
SELECT * FROM vw_ordenes_por_usuario;

SELECT * FROM vw_ordenes_por_usuario ORDER BY gasto_total DESC LIMIT 5;

-- ------------------------------------------------------------
-- Ejemplo 4: View de ventas mensuales
-- 1) Se usa date_trunc para agrupar por mes.
-- 2) EXPLAIN muestra aggregate por mes.
-- ------------------------------------------------------------
CREATE OR REPLACE VIEW vw_ventas_mensuales AS
SELECT
    date_trunc('month', o.created_at)::date AS mes,
    COUNT(DISTINCT o.id) AS ordenes_count,
    SUM(o.total) AS ventas_total,
    SUM(o.total) / NULLIF(COUNT(DISTINCT o.id), 0) AS ticket_promedio
FROM ordenes o
GROUP BY date_trunc('month', o.created_at)::date;

EXPLAIN
SELECT * FROM vw_ventas_mensuales;

SELECT * FROM vw_ventas_mensuales ORDER BY mes ASC;

-- ------------------------------------------------------------
-- Ejemplo 5: View de ventas por categoria (incluye categorias sin ventas)
-- 1) LEFT JOIN para no perder categorias.
-- 2) COALESCE convierte NULL en 0.
-- 3) EXPLAIN muestra left join + aggregate.
-- ------------------------------------------------------------
CREATE OR REPLACE VIEW vw_ventas_por_categoria AS
SELECT
    c.id AS categoria_id,
    c.nombre AS categoria_nombre,
    COALESCE(SUM(od.subtotal), 0) AS ventas_total,
    COALESCE(SUM(od.cantidad), 0) AS unidades_vendidas
FROM categorias c
LEFT JOIN productos p ON p.categoria_id = c.id
LEFT JOIN orden_detalles od ON od.producto_id = p.id
GROUP BY c.id, c.nombre;

EXPLAIN
SELECT * FROM vw_ventas_por_categoria;

SELECT * FROM vw_ventas_por_categoria ORDER BY ventas_total DESC;
