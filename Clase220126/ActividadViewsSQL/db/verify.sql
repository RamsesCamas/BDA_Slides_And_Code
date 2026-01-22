-- ============================================
-- VERIFY.SQL - Queries de Verificación
-- ============================================
-- Equipo: [Nombre del equipo]
-- Fecha: [Fecha]
-- ============================================

\echo '============================================'
\echo 'VERIFICACIÓN DE BASE DE DATOS'
\echo '============================================'

-- ============================================
-- 1. CONTEOS POR TABLA
-- ============================================

\echo ''
\echo '--- CONTEOS POR TABLA ---'

SELECT 'categorias' AS tabla, COUNT(*) AS registros FROM categorias
UNION ALL
SELECT 'usuarios', COUNT(*) FROM usuarios
UNION ALL
SELECT 'productos', COUNT(*) FROM productos
UNION ALL
SELECT 'ordenes', COUNT(*) FROM ordenes
UNION ALL
SELECT 'orden_detalles', COUNT(*) FROM orden_detalles
ORDER BY tabla;

-- ============================================
-- 2. JOINs DE VERIFICACIÓN
-- ============================================

\echo ''
\echo '--- JOIN 1: Productos con su categoría ---'

SELECT 
    p.codigo,
    p.nombre AS producto,
    c.nombre AS categoria,
    p.precio,
    p.stock
FROM productos p
JOIN categorias c ON p.categoria_id = c.id
ORDER BY c.nombre, p.nombre
LIMIT 10;

\echo ''
\echo '--- JOIN 2: Órdenes con usuario y detalle ---'

SELECT 
    o.id AS orden_id,
    u.nombre AS cliente,
    u.email,
    o.total,
    o.status,
    COUNT(od.id) AS productos_distintos,
    SUM(od.cantidad) AS items_totales
FROM ordenes o
JOIN usuarios u ON o.usuario_id = u.id
LEFT JOIN orden_detalles od ON o.id = od.orden_id
GROUP BY o.id, u.nombre, u.email, o.total, o.status
ORDER BY o.id;

-- ============================================
-- 3. AGREGACIONES (GROUP BY)
-- ============================================

\echo ''
\echo '--- Productos por categoría ---'

SELECT 
    c.nombre AS categoria,
    COUNT(p.id) AS total_productos,
    ROUND(AVG(p.precio)::numeric, 2) AS precio_promedio,
    SUM(p.stock) AS stock_total
FROM categorias c
LEFT JOIN productos p ON c.id = p.categoria_id
GROUP BY c.id, c.nombre
ORDER BY total_productos DESC;

\echo ''
\echo '--- Ventas por status ---'

SELECT 
    status,
    COUNT(*) AS cantidad_ordenes,
    SUM(total) AS monto_total,
    ROUND(AVG(total)::numeric, 2) AS promedio_orden
FROM ordenes
GROUP BY status
ORDER BY cantidad_ordenes DESC;

\echo ''
\echo '--- Top 5 productos más vendidos ---'

SELECT 
    p.nombre AS producto,
    SUM(od.cantidad) AS unidades_vendidas,
    SUM(od.subtotal) AS ingresos_totales
FROM orden_detalles od
JOIN productos p ON od.producto_id = p.id
GROUP BY p.id, p.nombre
ORDER BY unidades_vendidas DESC
LIMIT 5;

\echo ''
\echo '--- Top 5 clientes por monto de compras ---'

SELECT 
    u.nombre AS cliente,
    u.email,
    COUNT(o.id) AS total_ordenes,
    SUM(o.total) AS monto_total_compras
FROM usuarios u
LEFT JOIN ordenes o ON u.id = o.usuario_id
GROUP BY u.id, u.nombre, u.email
HAVING COUNT(o.id) > 0
ORDER BY monto_total_compras DESC
LIMIT 5;

-- ============================================
-- 4. VERIFICACIÓN DE INTEGRIDAD
-- ============================================

\echo ''
\echo '--- Verificación de FKs (debe estar vacío si todo OK) ---'

-- Órdenes sin usuario válido (debería estar vacío)
SELECT 'ordenes_sin_usuario' AS problema, COUNT(*) AS cantidad
FROM ordenes o
WHERE NOT EXISTS (SELECT 1 FROM usuarios u WHERE u.id = o.usuario_id);

-- Productos sin categoría válida (debería estar vacío)
SELECT 'productos_sin_categoria' AS problema, COUNT(*) AS cantidad
FROM productos p
WHERE NOT EXISTS (SELECT 1 FROM categorias c WHERE c.id = p.categoria_id);

\echo ''
\echo '--- Verificación de datos ---'

-- Productos con precio 0 (edge case válido pero a revisar)
SELECT 'productos_precio_cero' AS caso, COUNT(*) AS cantidad
FROM productos WHERE precio = 0;

-- Productos sin stock
SELECT 'productos_sin_stock' AS caso, COUNT(*) AS cantidad
FROM productos WHERE stock = 0;

-- ============================================
-- 5. MUESTRA DE DATOS (para evidencia)
-- ============================================

\echo ''
\echo '--- Muestra de usuarios ---'
SELECT id, email, nombre, activo FROM usuarios LIMIT 5;

\echo ''
\echo '--- Muestra de productos ---'
SELECT id, codigo, nombre, precio, stock FROM productos LIMIT 5;

\echo ''
\echo '============================================'
\echo 'FIN DE VERIFICACIÓN'
\echo '============================================'

-- ============================================
-- Para ejecutar: \i db/verify.sql
-- ============================================
