-- =============================================================
-- init.sql — Schema y seed para el demo de Redis Cache
-- Se ejecuta automáticamente al crear el contenedor PostgreSQL
-- vía /docker-entrypoint-initdb.d/
-- =============================================================

-- Tabla de categorías (catálogo pequeño, ~10 filas)
CREATE TABLE categories (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  slug TEXT UNIQUE NOT NULL
);

-- Tabla de productos (50,000 filas)
-- El índice en SKU es necesario para el WHERE de la query principal
CREATE TABLE products (
  id SERIAL PRIMARY KEY,
  sku TEXT UNIQUE NOT NULL,
  name TEXT NOT NULL,
  description TEXT,
  price NUMERIC(10, 2) NOT NULL,
  stock INT NOT NULL DEFAULT 0,
  category_id INT REFERENCES categories(id),
  created_at TIMESTAMP DEFAULT NOW()
);

-- Tabla de reseñas (500,000 filas)
-- DELIBERADAMENTE sin índice en product_id para forzar un sequential scan
-- en el LEFT JOIN. Esto hace que la query tarde ~80-300ms, justificando
-- el uso de cache.
CREATE TABLE reviews (
  id SERIAL PRIMARY KEY,
  product_id INT REFERENCES products(id),
  rating SMALLINT CHECK (rating BETWEEN 1 AND 5),
  body TEXT,
  created_at TIMESTAMP DEFAULT NOW()
);

-- =============================================================
-- SEED: Categorías (10 fijas)
-- =============================================================
INSERT INTO categories (name, slug) VALUES
  ('Electrónica',  'electronica'),
  ('Ropa',         'ropa'),
  ('Hogar',        'hogar'),
  ('Deportes',     'deportes'),
  ('Libros',       'libros'),
  ('Juguetes',     'juguetes'),
  ('Alimentos',    'alimentos'),
  ('Salud',        'salud'),
  ('Automotriz',   'automotriz'),
  ('Jardín',       'jardin');

-- =============================================================
-- SEED: 50,000 productos con generate_series
-- SKU-000001 hasta SKU-050000
-- =============================================================
INSERT INTO products (sku, name, description, price, stock, category_id)
SELECT
  'SKU-' || LPAD(g::TEXT, 6, '0'),
  'Producto ' || g,
  'Descripción del producto número ' || g,
  ROUND((random() * 999 + 1)::NUMERIC, 2),
  (random() * 500)::INT,
  (g % 10) + 1
FROM generate_series(1, 50000) AS g;

-- =============================================================
-- SEED: 1,000,000 reseñas con generate_series
-- Usamos 1M en vez de 500K para que el sequential scan sobre
-- reviews (sin índice en product_id) tome ~80-300ms y el
-- beneficio del cache sea evidente en el demo.
-- product_id aleatorio entre 1 y 50,000
-- rating aleatorio entre 1 y 5
-- =============================================================
INSERT INTO reviews (product_id, rating, body)
SELECT
  (random() * 49999 + 1)::INT,
  (random() * 4 + 1)::SMALLINT,
  'Reseña de ejemplo #' || g
FROM generate_series(1, 1000000) AS g;

-- =============================================================
-- ANALYZE para que el query planner tenga estadísticas actualizadas
-- Sin esto, las primeras queries podrían tener planes subóptimos
-- =============================================================
ANALYZE categories;
ANALYZE products;
ANALYZE reviews;
