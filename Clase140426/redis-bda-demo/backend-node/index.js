/**
 * Backend Node.js (Express) — Demo Cache-Aside con Redis.
 * Endpoints idénticos al backend Python para comparación directa.
 */

import express from "express";
import { pool, redis, checkConnections } from "./db.js";

const app = express();
app.use(express.json());

const CACHE_PREFIX = "cache:product:";
const CACHE_TTL = 300; // 5 minutos en segundos

// Consulta SQL pesada (idéntica al backend Python)
// Sin índice en reviews.product_id → sequential scan deliberado
const PRODUCT_QUERY = `
  SELECT
    p.sku, p.name, p.price, p.stock,
    c.name AS category,
    COUNT(r.id) AS review_count,
    COALESCE(AVG(r.rating), 0)::NUMERIC(3,2) AS avg_rating
  FROM products p
  LEFT JOIN categories c ON c.id = p.category_id
  LEFT JOIN reviews r ON r.product_id = p.id
  WHERE p.sku = $1
  GROUP BY p.id, c.name`;


// =============================================
// GET /health — Endpoint trivial para scripts
// =============================================
app.get("/health", (_req, res) => {
  res.json({ status: "ok", backend: "node" });
});


// =============================================
// GET /products/:sku — Cache-Aside Pattern
// =============================================
app.get("/products/:sku", async (req, res) => {
  const start = performance.now();
  const { sku } = req.params;
  const cacheKey = `${CACHE_PREFIX}${sku}`;

  try {
    // 1. Intentar leer del cache
    const cached = await redis.get(cacheKey);
    if (cached !== null) {
      const elapsed = performance.now() - start;
      console.log(`[cache HIT] ${sku} (${elapsed.toFixed(2)}ms)`);
      return res.json({
        cache_hit: true,
        latency_ms: Math.round(elapsed * 100) / 100,
        data: JSON.parse(cached),
      });
    }

    // 2. Cache miss: consultar PostgreSQL
    const { rows } = await pool.query(PRODUCT_QUERY, [sku]);
    if (rows.length === 0) {
      return res.status(404).json({ detail: `SKU ${sku} no encontrado` });
    }

    // pg devuelve NUMERIC como string para preservar precisión;
    // convertimos a Number para que el JSON sea idéntico al backend Python
    const row = rows[0];
    const product = {
      sku: row.sku,
      name: row.name,
      price: parseFloat(row.price),
      stock: row.stock,
      category: row.category,
      review_count: parseInt(row.review_count, 10),
      avg_rating: parseFloat(row.avg_rating),
    };

    // 3. Guardar en cache con TTL de 5 minutos
    // setex = SET + EXPIRE atómico (misma razón que en Python)
    await redis.setex(cacheKey, CACHE_TTL, JSON.stringify(product));

    const elapsed = performance.now() - start;
    console.log(`[cache MISS] ${sku} (${elapsed.toFixed(2)}ms)`);
    res.json({
      cache_hit: false,
      latency_ms: Math.round(elapsed * 100) / 100,
      data: product,
    });
  } catch (err) {
    console.error("Error en GET /products/:sku", err);
    res.status(500).json({ detail: err.message });
  }
});


// =============================================
// PATCH /products/:sku/price — Write-Through
// =============================================
app.patch("/products/:sku/price", async (req, res) => {
  const start = performance.now();
  const { sku } = req.params;
  const { price } = req.body;

  if (price == null || typeof price !== "number") {
    return res.status(400).json({ detail: "Se requiere 'price' (numero)" });
  }

  try {
    // 1. Actualizar en PostgreSQL
    const { rows } = await pool.query(
      "UPDATE products SET price = $1 WHERE sku = $2 RETURNING sku",
      [price, sku]
    );

    if (rows.length === 0) {
      return res.status(404).json({ detail: `SKU ${sku} no encontrado` });
    }

    // 2. Invalidar cache — la próxima lectura traerá el dato fresco de PG
    const cacheKey = `${CACHE_PREFIX}${sku}`;
    await redis.del(cacheKey);

    const elapsed = performance.now() - start;
    console.log(`[invalidate] ${sku} precio -> ${price} (${elapsed.toFixed(2)}ms)`);
    res.json({
      message: `Precio de ${sku} actualizado a ${price}`,
      cache_invalidated: true,
      latency_ms: Math.round(elapsed * 100) / 100,
    });
  } catch (err) {
    console.error("Error en PATCH /products/:sku/price", err);
    res.status(500).json({ detail: err.message });
  }
});


// =============================================
// GET /stats — Métricas de Redis
// =============================================
app.get("/stats", async (_req, res) => {
  try {
    // ioredis devuelve INFO como string crudo; hay que parsearlo manualmente
    // (a diferencia de redis-py que lo parsea a dict automáticamente)
    const infoRaw = await redis.info();
    const info = {};
    infoRaw.split("\r\n").forEach((line) => {
      if (line && !line.startsWith("#")) {
        const idx = line.indexOf(":");
        if (idx !== -1) {
          info[line.substring(0, idx)] = line.substring(idx + 1);
        }
      }
    });

    const hits = parseInt(info.keyspace_hits || "0", 10);
    const misses = parseInt(info.keyspace_misses || "0", 10);
    const total = hits + misses;

    res.json({
      redis_version: info.redis_version,
      used_memory_human: info.used_memory_human,
      keyspace_hits: hits,
      keyspace_misses: misses,
      // Evitar división por cero cuando no ha habido requests aún
      hit_ratio: total > 0 ? Math.round((hits / total) * 10000) / 100 : 0,
      evicted_keys: parseInt(info.evicted_keys || "0", 10),
      total_keys: await redis.dbsize(),
    });
  } catch (err) {
    console.error("Error en GET /stats", err);
    res.status(500).json({ detail: err.message });
  }
});


// =============================================
// POST /cache/flush — Limpiar cache para demo
// =============================================
app.post("/cache/flush", async (_req, res) => {
  await redis.flushdb();
  const remaining = await redis.dbsize();
  console.log("[flush] Cache vaciado");
  res.json({ message: "Cache vaciado", keys_remaining: remaining });
});


// --- Arranque ---
const PORT = 3000;

checkConnections().then(() => {
  app.listen(PORT, () => {
    console.log(`[startup] Backend Node escuchando en puerto ${PORT}`);
  });
});
