-- ============================================
-- SCHEMA.SQL - Definición de Estructura
-- ============================================
-- Equipo: [Nombre del equipo]
-- Fecha: [Fecha]
-- Dominio: [Describir el dominio modelado]
-- ============================================

-- Limpiar tablas si existen (útil para desarrollo)
-- CUIDADO: Esto borra todos los datos
DROP TABLE IF EXISTS tabla_relacion CASCADE;
DROP TABLE IF EXISTS tabla_hija CASCADE;
DROP TABLE IF EXISTS tabla_padre CASCADE;

-- ============================================
-- TABLAS CATÁLOGO (sin dependencias)
-- ============================================

-- Ejemplo: Categorías
CREATE TABLE categorias (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    descripcion TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- TABLAS ENTIDAD PRINCIPAL
-- ============================================

-- Ejemplo: Usuarios
CREATE TABLE usuarios (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    nombre VARCHAR(100) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    activo BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Ejemplo: Productos (con FK a categorías)
CREATE TABLE productos (
    id SERIAL PRIMARY KEY,
    codigo VARCHAR(50) NOT NULL UNIQUE,
    nombre VARCHAR(200) NOT NULL,
    descripcion TEXT,
    precio DECIMAL(10, 2) NOT NULL CHECK (precio >= 0),
    stock INTEGER NOT NULL DEFAULT 0 CHECK (stock >= 0),
    categoria_id INTEGER NOT NULL REFERENCES categorias(id) ON DELETE RESTRICT,
    activo BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- TABLAS DE RELACIÓN (muchos a muchos)
-- ============================================

-- Ejemplo: Órdenes
CREATE TABLE ordenes (
    id SERIAL PRIMARY KEY,
    usuario_id INTEGER NOT NULL REFERENCES usuarios(id) ON DELETE RESTRICT,
    total DECIMAL(12, 2) NOT NULL DEFAULT 0 CHECK (total >= 0),
    status VARCHAR(20) NOT NULL DEFAULT 'pendiente' 
        CHECK (status IN ('pendiente', 'pagado', 'enviado', 'entregado', 'cancelado')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Ejemplo: Detalle de órdenes
CREATE TABLE orden_detalles (
    id SERIAL PRIMARY KEY,
    orden_id INTEGER NOT NULL REFERENCES ordenes(id) ON DELETE CASCADE,
    producto_id INTEGER NOT NULL REFERENCES productos(id) ON DELETE RESTRICT,
    cantidad INTEGER NOT NULL CHECK (cantidad > 0),
    precio_unitario DECIMAL(10, 2) NOT NULL CHECK (precio_unitario >= 0),
    subtotal DECIMAL(12, 2) GENERATED ALWAYS AS (cantidad * precio_unitario) STORED,
    
    -- Evitar duplicados del mismo producto en una orden
    UNIQUE (orden_id, producto_id)
);



-- ESTUDIANTES HASTA ACÁ


-- ============================================
-- ÍNDICES (para optimizar consultas)
-- ============================================

-- Índice para búsquedas por usuario en órdenes
CREATE INDEX idx_ordenes_usuario_id ON ordenes(usuario_id);

-- Índice para búsquedas por categoría en productos
CREATE INDEX idx_productos_categoria_id ON productos(categoria_id);

-- Índice para búsquedas por status de orden
CREATE INDEX idx_ordenes_status ON ordenes(status);

-- ============================================
-- COMENTARIOS DE TABLAS (documentación en BD)
-- ============================================

COMMENT ON TABLE categorias IS 'Catálogo de categorías de productos';
COMMENT ON TABLE usuarios IS 'Usuarios del sistema';
COMMENT ON TABLE productos IS 'Catálogo de productos disponibles';
COMMENT ON TABLE ordenes IS 'Órdenes/pedidos de los usuarios';
COMMENT ON TABLE orden_detalles IS 'Detalle de productos por orden';

-- ============================================
-- FIN DEL SCHEMA
-- ============================================
-- Para ejecutar: \i db/schema.sql
