-- ============================================
-- SEED.SQL - Datos Iniciales
-- ============================================
-- Equipo: [Nombre del equipo]
-- Fecha: [Fecha]
-- ============================================
-- ORDEN DE INSERCIÓN:
-- 1. Catálogos (sin dependencias)
-- 2. Entidades principales
-- 3. Relaciones/transacciones
-- ============================================

-- ============================================
-- 1. CATÁLOGOS
-- ============================================

INSERT INTO categorias (nombre, descripcion) VALUES
    ('Electrónica', 'Dispositivos electrónicos y accesorios'),
    ('Ropa', 'Vestimenta y accesorios de moda'),
    ('Hogar', 'Artículos para el hogar y decoración'),
    ('Deportes', 'Equipamiento y ropa deportiva'),
    ('Libros', 'Libros físicos y digitales');

-- ============================================
-- 2. ENTIDADES PRINCIPALES
-- ============================================

-- Usuarios (mínimo 6)
INSERT INTO usuarios (email, nombre, password_hash) VALUES
    ('ada@example.com', 'Ada Lovelace', 'hash_placeholder_1'),
    ('alan@example.com', 'Alan Turing', 'hash_placeholder_2'),
    ('grace@example.com', 'Grace Hopper', 'hash_placeholder_3'),
    ('linus@example.com', 'Linus Torvalds', 'hash_placeholder_4'),
    ('margaret@example.com', 'Margaret Hamilton', 'hash_placeholder_5'),
    ('donald@example.com', 'Donald Knuth', 'hash_placeholder_6');

-- Productos (mínimo 5 por categoría importante)
INSERT INTO productos (codigo, nombre, descripcion, precio, stock, categoria_id) VALUES
    -- Electrónica (categoria_id = 1)
    ('ELEC-001', 'Laptop Pro 15"', 'Laptop de alto rendimiento', 1299.99, 50, 1),
    ('ELEC-002', 'Mouse Inalámbrico', 'Mouse ergonómico Bluetooth', 29.99, 200, 1),
    ('ELEC-003', 'Teclado Mecánico', 'Teclado RGB switches azules', 89.99, 75, 1),
    ('ELEC-004', 'Monitor 27"', 'Monitor 4K IPS', 399.99, 30, 1),
    ('ELEC-005', 'Webcam HD', 'Cámara 1080p con micrófono', 59.99, 100, 1),
    
    -- Ropa (categoria_id = 2)
    ('ROPA-001', 'Camiseta Básica', 'Camiseta 100% algodón', 19.99, 500, 2),
    ('ROPA-002', 'Jeans Clásico', 'Pantalón de mezclilla', 49.99, 200, 2),
    ('ROPA-003', 'Sudadera Tech', 'Sudadera con capucha', 39.99, 150, 2),
    ('ROPA-004', 'Zapatos Casual', 'Calzado cómodo diario', 69.99, 100, 2),
    ('ROPA-005', 'Gorra Deportiva', 'Gorra ajustable', 14.99, 300, 2),
    
    -- Hogar (categoria_id = 3)
    ('HOME-001', 'Lámpara LED', 'Lámpara de escritorio regulable', 34.99, 80, 3),
    ('HOME-002', 'Silla Ergonómica', 'Silla de oficina ajustable', 249.99, 25, 3),
    ('HOME-003', 'Organizador', 'Set de organizadores', 24.99, 120, 3),
    ('HOME-004', 'Planta Artificial', 'Decoración verde', 19.99, 200, 3),
    ('HOME-005', 'Cuadro Decorativo', 'Arte moderno 50x70cm', 44.99, 60, 3);

-- ============================================
-- 3. TRANSACCIONES/RELACIONES
-- ============================================

-- Órdenes
INSERT INTO ordenes (usuario_id, total, status) VALUES
    (1, 1389.97, 'entregado'),    -- Ada compró laptop + mouse + teclado
    (2, 69.98, 'enviado'),         -- Alan compró 2 camisetas + webcam (ajustado)
    (3, 284.98, 'pagado'),         -- Grace compró silla + lámpara
    (4, 99.98, 'pendiente'),       -- Linus compró jeans + sudadera
    (5, 1299.99, 'pagado'),        -- Margaret compró laptop
    (6, 399.99, 'pagado');         -- Donald compró monitor

-- Detalle de órdenes
INSERT INTO orden_detalles (orden_id, producto_id, cantidad, precio_unitario) VALUES
    -- Orden 1 de Ada
    (1, 1, 1, 1299.99),  -- 1 Laptop
    (1, 2, 1, 29.99),    -- 1 Mouse
    (1, 3, 1, 89.99),    -- 1 Teclado
    
    -- Orden 2 de Alan
    (2, 6, 2, 19.99),    -- 2 Camisetas
    (2, 5, 1, 59.99),    -- 1 Webcam (corregido de producto anterior)
    
    -- Orden 3 de Grace
    (3, 12, 1, 249.99),  -- 1 Silla
    (3, 11, 1, 34.99),   -- 1 Lámpara
    
    -- Orden 4 de Linus
    (4, 7, 1, 49.99),    -- 1 Jeans
    (4, 8, 1, 39.99),    -- 1 Sudadera
    
    -- Orden 5 de Margaret
    (5, 1, 1, 1299.99),  -- 1 Laptop

    -- Orden 6 de Donald
    (6, 4, 1, 399.99);   -- 1 Monitor

-- ============================================
-- 4. EDGE CASES (para versión 3 horas)
-- ============================================

-- Caso: String largo pero válido
INSERT INTO usuarios (email, nombre, password_hash) VALUES
    ('usuario.con.email.muy.largo.pero.valido@subdominio.empresa.ejemplo.com', 
     'Usuario Con Nombre Extremadamente Largo Para Probar Límites', 
     'hash_muy_largo_12345678901234567890');

-- Caso: Valores en el límite
INSERT INTO productos (codigo, nombre, precio, stock, categoria_id) VALUES
    ('EDGE-001', 'Producto Gratuito', 0.00, 0, 1);  -- Precio y stock en 0

-- ============================================
-- CASO QUE DEBERÍA FALLAR (COMENTADO)
-- ============================================
-- Descomentar para probar que el constraint funciona:

-- Este INSERT falla por UNIQUE en email:
-- INSERT INTO usuarios (email, nombre, password_hash) 
-- VALUES ('ada@example.com', 'Otra Ada', 'hash');
-- ERROR: duplicate key value violates unique constraint "usuarios_email_key"

-- Este INSERT falla por CHECK en precio:
-- INSERT INTO productos (codigo, nombre, precio, stock, categoria_id) 
-- VALUES ('FAIL-001', 'Precio Negativo', -10.00, 5, 1);
-- ERROR: new row violates check constraint "productos_precio_check"

-- Este INSERT falla por CHECK en cantidad:
-- INSERT INTO orden_detalles (orden_id, producto_id, cantidad, precio_unitario) 
-- VALUES (1, 1, 0, 100.00);
-- ERROR: new row violates check constraint "orden_detalles_cantidad_check"

-- ============================================
-- FIN DEL SEED
-- ============================================
-- Para ejecutar: \i db/seed.sql
