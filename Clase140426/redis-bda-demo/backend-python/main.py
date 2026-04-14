"""
Backend Python (FastAPI) — Demo Cache-Aside con Redis.
Endpoints idénticos al backend Node para comparación directa.
"""

import json
import time

from fastapi import FastAPI, HTTPException
from pydantic import BaseModel

from db import pg_pool, redis_client, check_connections

app = FastAPI(title="Redis BDA Demo - Python", version="1.0.0")

CACHE_PREFIX = "cache:product:"
CACHE_TTL = 300  # 5 minutos en segundos


# --- Modelo para el body del PATCH ---
class PriceUpdate(BaseModel):
    price: float


# --- Consulta SQL pesada ---
# Sin índice en reviews.product_id, el LEFT JOIN fuerza un sequential scan
# sobre las 500K filas de reviews. Esto es DELIBERADO para demostrar
# el beneficio del cache.
PRODUCT_QUERY = """
SELECT
  p.sku, p.name, p.price, p.stock,
  c.name AS category,
  COUNT(r.id) AS review_count,
  COALESCE(AVG(r.rating), 0)::NUMERIC(3,2) AS avg_rating
FROM products p
LEFT JOIN categories c ON c.id = p.category_id
LEFT JOIN reviews r ON r.product_id = p.id
WHERE p.sku = %s
GROUP BY p.id, c.name;
"""


@app.on_event("startup")
def startup() -> None:
    """Verificar conexiones al arrancar. Si falla, el proceso muere."""
    check_connections()
    print("[startup] Backend Python listo", flush=True)


# =============================================
# GET /health — Endpoint trivial para scripts
# =============================================
@app.get("/health")
def health():
    return {"status": "ok", "backend": "python"}


# =============================================
# GET /products/{sku} — Cache-Aside Pattern
# =============================================
@app.get("/products/{sku}")
def get_product(sku: str):
    t0 = time.perf_counter()
    cache_key = f"{CACHE_PREFIX}{sku}"

    # 1. Intentar leer del cache
    cached = redis_client.get(cache_key)
    if cached is not None:
        elapsed = (time.perf_counter() - t0) * 1000
        print(f"[cache HIT] {sku} ({elapsed:.2f}ms)", flush=True)
        return {
            "cache_hit": True,
            "latency_ms": round(elapsed, 2),
            "data": json.loads(cached),
        }

    # 2. Cache miss: consultar PostgreSQL
    with pg_pool.connection() as conn:
        row = conn.execute(PRODUCT_QUERY, (sku,)).fetchone()

    if row is None:
        raise HTTPException(status_code=404, detail=f"SKU {sku} no encontrado")

    # Convertir Decimal a float porque json.dumps no sabe serializar Decimal
    product = {
        "sku": row["sku"],
        "name": row["name"],
        "price": float(row["price"]),
        "stock": row["stock"],
        "category": row["category"],
        "review_count": row["review_count"],
        "avg_rating": float(row["avg_rating"]),
    }

    # 3. Guardar en cache con TTL de 5 minutos
    # Usamos setex (SET con EXPIRE atómico) en vez de SET + EXPIRE separados
    # para evitar la ventana donde la clave existe sin TTL si el proceso muere
    # entre los dos comandos.
    redis_client.setex(cache_key, CACHE_TTL, json.dumps(product))

    elapsed = (time.perf_counter() - t0) * 1000
    print(f"[cache MISS] {sku} ({elapsed:.2f}ms)", flush=True)
    return {
        "cache_hit": False,
        "latency_ms": round(elapsed, 2),
        "data": product,
    }


# =============================================
# PATCH /products/{sku}/price — Write-Through
# =============================================
@app.patch("/products/{sku}/price")
def update_price(sku: str, body: PriceUpdate):
    t0 = time.perf_counter()

    # 1. Actualizar en PostgreSQL
    with pg_pool.connection() as conn:
        result = conn.execute(
            "UPDATE products SET price = %s WHERE sku = %s RETURNING sku",
            (body.price, sku),
        )
        updated = result.fetchone()
        # psycopg3 requiere commit explícito (no hay autocommit por defecto)
        conn.commit()

    if updated is None:
        raise HTTPException(status_code=404, detail=f"SKU {sku} no encontrado")

    # 2. Invalidar cache — la próxima lectura traerá el dato fresco de PG
    cache_key = f"{CACHE_PREFIX}{sku}"
    redis_client.delete(cache_key)

    elapsed = (time.perf_counter() - t0) * 1000
    print(f"[invalidate] {sku} precio -> {body.price} ({elapsed:.2f}ms)", flush=True)
    return {
        "message": f"Precio de {sku} actualizado a {body.price}",
        "cache_invalidated": True,
        "latency_ms": round(elapsed, 2),
    }


# =============================================
# GET /stats — Métricas de Redis
# =============================================
@app.get("/stats")
def stats():
    # redis-py parsea INFO automáticamente a un dict
    info = redis_client.info("stats")
    info_server = redis_client.info("server")
    info_memory = redis_client.info("memory")

    hits = info.get("keyspace_hits", 0)
    misses = info.get("keyspace_misses", 0)
    total = hits + misses

    return {
        "redis_version": info_server.get("redis_version"),
        "used_memory_human": info_memory.get("used_memory_human"),
        "keyspace_hits": hits,
        "keyspace_misses": misses,
        # Evitar división por cero cuando no ha habido requests aún
        "hit_ratio": round((hits / total) * 100, 2) if total > 0 else 0.0,
        "evicted_keys": info.get("evicted_keys", 0),
        "total_keys": redis_client.dbsize(),
    }


# =============================================
# POST /cache/flush — Limpiar cache para demo
# =============================================
@app.post("/cache/flush")
def flush_cache():
    redis_client.flushdb()
    print("[flush] Cache vaciado", flush=True)
    return {"message": "Cache vaciado", "keys_remaining": redis_client.dbsize()}
