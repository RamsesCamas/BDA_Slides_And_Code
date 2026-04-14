# Explicación de la Implementación: Redis como Cache sobre PostgreSQL

## Contexto del problema

Tenemos un catálogo de productos con **50,000 productos** y **1,000,000 de reseñas** en PostgreSQL. La consulta principal hace un triple JOIN (productos + categorías + reseñas) con agregaciones (`COUNT`, `AVG`) para obtener las estadísticas de un producto por su SKU.

**Deliberadamente no se creó un índice en `reviews.product_id`**, lo que fuerza a PostgreSQL a hacer un *sequential scan* sobre el millón de filas de reseñas cada vez que se ejecuta la query. Esto simula el escenario real donde una consulta costosa se repite frecuentemente con los mismos parámetros.

```sql
SELECT
  p.sku, p.name, p.price, p.stock,
  c.name AS category,
  COUNT(r.id) AS review_count,
  COALESCE(AVG(r.rating), 0)::NUMERIC(3,2) AS avg_rating
FROM products p
LEFT JOIN categories c ON c.id = p.category_id
LEFT JOIN reviews r ON r.product_id = p.id
WHERE p.sku = $1
GROUP BY p.id, c.name;
```

**Sin cache:** cada request tarda ~80-150ms.
**Con cache:** cada request tarda <2ms.

---

## Arquitectura general

```
  Cliente (curl)
       │
       ├──── :8001 ──► Backend Python (FastAPI)
       │                      │
       └──── :8002 ──► Backend Node.js (Express)
                              │
                    ┌─────────┴─────────┐
                    │                   │
              ┌─────▼─────┐     ┌──────▼──────┐
              │   Redis   │     │ PostgreSQL  │
              │   :6379   │     │   :5432     │
              │  (cache)  │     │  (datos)    │
              └───────────┘     └─────────────┘
```

Ambos backends comparten la **misma instancia de Redis** y la **misma base de datos PostgreSQL**. Esto significa que si Python cachea un producto, Node lo lee del cache directamente (y viceversa), porque la clave es la misma: `cache:product:{sku}`.

---

## Patrón implementado: Cache-Aside (Lazy Loading)

El patrón **Cache-Aside** funciona así:

```
         ┌─────────────────────────────┐
         │        GET /products/SKU    │
         └──────────┬──────────────────┘
                    │
                    ▼
            ┌───────────────┐
            │ ¿Existe en    │──── SÍ ──► Devolver dato del cache
            │   Redis?      │            (cache HIT, <2ms)
            └───────┬───────┘
                    │ NO
                    ▼
            ┌───────────────┐
            │ Consultar     │
            │ PostgreSQL    │──── (~80-150ms)
            └───────┬───────┘
                    │
                    ▼
            ┌───────────────┐
            │ Guardar en    │
            │ Redis con TTL │──── (SET + EXPIRE atómico)
            └───────┬───────┘
                    │
                    ▼
            ┌───────────────┐
            │ Devolver dato │
            │ (cache MISS)  │
            └───────────────┘
```

### ¿Por qué Cache-Aside y no otro patrón?

- **Write-Through** escribiría en el cache en cada INSERT/UPDATE, incluso si nadie va a leer ese dato pronto. Desperdicia memoria.
- **Read-Through** requiere que el cache sepa cómo consultar la base de datos. Acopla la capa de cache con la lógica de negocio.
- **Cache-Aside** es el más simple: la aplicación decide cuándo leer y cuándo escribir en el cache. El cache no sabe nada de PostgreSQL.

---

## Qué hace cada archivo

### Base de datos: `postgres/init.sql`

Crea tres tablas y las llena con datos sintéticos usando `generate_series` de PostgreSQL:

| Tabla | Filas | Propósito |
|-------|-------|-----------|
| `categories` | 10 | Catálogo fijo (Electrónica, Ropa, Hogar, etc.) |
| `products` | 50,000 | Productos con SKU único (`SKU-000001` a `SKU-050000`) |
| `reviews` | 1,000,000 | Reseñas con rating aleatorio [1-5] y product_id aleatorio |

El punto clave es que **no hay índice en `reviews.product_id`**. Esto es deliberado: sin índice, PostgreSQL debe recorrer el millón de filas para encontrar las reseñas de un producto. Con un índice, la query bajaría a <5ms y el cache no tendría sentido para el demo.

Al final ejecuta `ANALYZE` para que el query planner de PostgreSQL tenga estadísticas actualizadas sobre la distribución de datos.

### Orquestación: `docker-compose.yml`

Define 4 servicios:

| Servicio | Imagen | Puerto | Función |
|----------|--------|--------|---------|
| `postgres` | postgres:16-alpine | 5432 | Base de datos con seed automático |
| `redis` | redis:7-alpine | 6379 | Cache en memoria |
| `backend-python` | python:3.12-slim | 8001→8000 | API FastAPI |
| `backend-node` | node:20-alpine | 8002→3000 | API Express |

**Configuración de Redis como cache:**

```yaml
command: redis-server --appendonly yes --maxmemory 256mb --maxmemory-policy allkeys-lru
```

- `--appendonly yes`: Persistencia AOF (Append Only File). Cada escritura se registra en disco. Si Redis se reinicia, puede recuperar los datos. En producción real esto se configura según las necesidades; aquí se activa para poder inspeccionar el archivo en clase.
- `--maxmemory 256mb`: Límite de memoria. Cuando Redis llega a este límite, empieza a evictar claves.
- `--maxmemory-policy allkeys-lru`: Política de evicción LRU (Least Recently Used). Cuando se llena la memoria, Redis elimina las claves que llevan más tiempo sin ser accedidas.

**Healthcheck de PostgreSQL:**

```yaml
test: ["CMD-SHELL", "psql -U bda -d bda -c 'SELECT 1 FROM reviews LIMIT 1' || exit 1"]
```

Se verifica la tabla `reviews` (la última en insertarse) en vez de usar `pg_isready`. Esto garantiza que el seed completo terminó antes de que los backends intenten conectarse.

### Backend Python: `backend-python/`

#### `db.py` — Conexiones a PostgreSQL y Redis

```python
# Pool de conexiones a PostgreSQL (psycopg 3)
pg_pool = ConnectionPool(
    conninfo=_database_url,
    min_size=2,       # mantiene 2 conexiones abiertas siempre
    max_size=10,      # escala hasta 10 bajo carga
    kwargs={"row_factory": dict_row},  # devuelve dicts, no tuplas
)

# Pool de conexiones a Redis (redis-py 5)
redis_client = Redis(connection_pool=_redis_pool)
```

**¿Por qué usar pools?**
Sin pool, cada request abriría y cerraría una conexión TCP a PostgreSQL (~5-10ms solo en handshake). Con pool, las conexiones se reutilizan entre requests. El pool mantiene un mínimo de conexiones abiertas y las presta a los handlers cuando las necesitan.

**¿Por qué `dict_row`?**
Sin `dict_row`, psycopg3 devuelve tuplas: `(42, "Producto 42", 99.99, ...)`. Con `dict_row`, devuelve dicts: `{"sku": "SKU-000042", "name": "Producto 42", "price": 99.99, ...}`. Mucho más legible.

**¿Por qué `decode_responses=True` en Redis?**
Sin esta opción, Redis devuelve bytes (`b'{"sku": "SKU-000042"}'`). Con ella, devuelve strings directamente, y `json.loads()` funciona sin necesidad de llamar `.decode()`.

#### `main.py` — Endpoints de la API

**GET /products/{sku}** — El endpoint principal:

```python
@app.get("/products/{sku}")
def get_product(sku: str):
    t0 = time.perf_counter()
    cache_key = f"cache:product:{sku}"

    # 1. Buscar en cache
    cached = redis_client.get(cache_key)
    if cached is not None:
        # Cache HIT: devolver sin tocar PostgreSQL
        return {"cache_hit": True, "latency_ms": ..., "data": json.loads(cached)}

    # 2. Cache MISS: consultar PostgreSQL
    with pg_pool.connection() as conn:
        row = conn.execute(PRODUCT_QUERY, (sku,)).fetchone()

    # 3. Guardar en cache con TTL de 5 minutos
    redis_client.setex(cache_key, 300, json.dumps(product))

    return {"cache_hit": False, "latency_ms": ..., "data": product}
```

Puntos importantes:

- **`time.perf_counter()`** mide el tiempo con precisión de nanosegundos. Se usa en vez de `time.time()` porque este último tiene resolución de ~15ms en algunos sistemas.
- **`setex`** (SET + EXPIRE atómico) en vez de `SET` seguido de `EXPIRE`. Si el proceso muere entre los dos comandos, la clave quedaría en Redis sin TTL (memoria que nunca se libera).
- **`float(row["price"])`**: PostgreSQL devuelve `Decimal` para columnas `NUMERIC`. Python no sabe serializar `Decimal` a JSON, así que se convierte explícitamente a `float`.

**PATCH /products/{sku}/price** — Invalidación del cache:

```python
# 1. Actualizar en PostgreSQL
conn.execute("UPDATE products SET price = %s WHERE sku = %s", (price, sku))
conn.commit()  # psycopg3 requiere commit explícito

# 2. Invalidar cache
redis_client.delete(cache_key)
```

Se elimina la clave del cache en vez de actualizarla. La próxima lectura será un cache MISS que traerá el dato fresco de PostgreSQL. Este enfoque es más simple y seguro que intentar actualizar el cache (evita inconsistencias si el UPDATE falla a medias).

**GET /stats** — Métricas de Redis:

```python
info = redis_client.info("stats")
hits = info.get("keyspace_hits", 0)
misses = info.get("keyspace_misses", 0)
hit_ratio = (hits / (hits + misses)) * 100
```

Redis mantiene contadores globales de hits y misses. El `hit_ratio` indica qué porcentaje de las lecturas se resolvieron desde el cache sin tocar PostgreSQL.

### Backend Node: `backend-node/`

Implementación equivalente en JavaScript/Express con las mismas decisiones de diseño. Diferencias técnicas relevantes:

#### `db.js`

```javascript
import pg from "pg";
const { Pool } = pg;  // pg no tiene named exports en ES modules
```

El módulo `pg` fue diseñado para CommonJS. En ES modules, hay que importar el default y desestructurar. Esto es un quirk conocido del ecosistema Node.

#### `index.js`

```javascript
// pg devuelve NUMERIC como string para evitar pérdida de precisión
const product = {
  price: parseFloat(row.price),        // "99.99" → 99.99
  review_count: parseInt(row.review_count, 10),  // "18" → 18
  avg_rating: parseFloat(row.avg_rating),
};
```

A diferencia de Python donde `Decimal` es un tipo nativo, JavaScript solo tiene `Number` (IEEE 754 float64). La librería `pg` devuelve `NUMERIC` y `BIGINT` como strings para no perder precisión. El `parseFloat` es seguro para precios (no necesitamos precisión arbitraria en el demo).

**Parseo de INFO de Redis:**

```javascript
// ioredis devuelve INFO como string crudo (a diferencia de redis-py que parsea a dict)
const infoRaw = await redis.info();
// Parsear líneas "key:value" manualmente
```

La librería `ioredis` no parsea el output de `INFO` automáticamente (a diferencia de `redis-py` en Python). Hay que dividir por `\r\n` y separar cada línea por `:`.

---

## Configuración de Redis: ¿por qué estos parámetros?

### `--maxmemory 256mb`

Redis almacena todo en RAM. Sin un límite, podría consumir toda la memoria del sistema. En producción, este valor se calcula según la infraestructura disponible. Para el demo, 256MB es suficiente para cachear miles de productos.

### `--maxmemory-policy allkeys-lru`

Cuando Redis alcanza el límite de memoria, necesita decidir qué claves eliminar. Las políticas disponibles son:

| Política | Comportamiento |
|----------|---------------|
| `noeviction` | Rechaza escrituras nuevas (error OOM) |
| `allkeys-lru` | Elimina la clave menos usada recientemente (de todas) |
| `volatile-lru` | Elimina la clave menos usada recientemente (solo con TTL) |
| `allkeys-random` | Elimina una clave aleatoria |
| `volatile-ttl` | Elimina la clave con menor TTL restante |

Usamos `allkeys-lru` porque:
- Todas nuestras claves tienen TTL, pero LRU es más inteligente que TTL puro.
- Si un producto se consulta frecuentemente, su clave se mantiene aunque tenga poco TTL restante.
- Es la política más común en escenarios de cache.

### `--appendonly yes`

Activa la persistencia AOF (Append Only File). Cada operación de escritura se registra secuencialmente en disco. Si Redis se reinicia, reconstruye su estado leyendo el archivo AOF. Esto no es estrictamente necesario para un cache (si se pierde, se reconstruye desde PostgreSQL), pero permite inspeccionar el archivo en clase.

---

## Clave de cache: `cache:product:{sku}`

La convención de nombrado en Redis usa `:` como separador de namespace:

```
cache:product:SKU-000042
```

- `cache` — prefijo que indica que es un dato cacheado (vs datos primarios)
- `product` — tipo de entidad
- `SKU-000042` — identificador único

Esto permite:
- Buscar todas las claves de productos: `KEYS cache:product:*`
- Evitar colisiones si en el futuro se cachean otros tipos de datos
- Legibilidad al inspeccionar con `redis-cli`

---

## TTL: ¿por qué 300 segundos?

El TTL (Time To Live) de 5 minutos es un balance entre:

- **Frescura**: Un TTL más bajo mantiene los datos más actualizados, pero genera más cache misses.
- **Rendimiento**: Un TTL más alto reduce la carga sobre PostgreSQL, pero los datos pueden estar desactualizados.

En este demo usamos invalidación explícita en el PATCH, así que el TTL es más bien una red de seguridad: si alguien modifica datos directamente en PostgreSQL (sin pasar por la API), el cache se actualizará solo en un máximo de 5 minutos.

---

## Métricas observables

El endpoint `/stats` expone métricas directas de Redis:

| Métrica | Significado |
|---------|-------------|
| `keyspace_hits` | Veces que Redis encontró la clave pedida |
| `keyspace_misses` | Veces que Redis no encontró la clave |
| `hit_ratio` | `hits / (hits + misses) * 100` — porcentaje de efectividad |
| `evicted_keys` | Claves eliminadas por la política LRU (indica presión de memoria) |
| `total_keys` | Claves actualmente en Redis |

Un `hit_ratio` alto (>80%) indica que el cache está siendo efectivo. Un `evicted_keys` creciente indica que Redis necesita más memoria o que el TTL es muy largo.

---

## Flujo completo del demo

```
Tiempo  Acción                      cache_hit   latency_ms   Explicación
─────   ─────────────────────────   ─────────   ──────────   ───────────────────────────
  0s    POST /cache/flush           —           —            Empezamos limpio
  1s    GET /products/SKU-000042    false       ~120ms       Cache MISS: query completa a PG
  2s    GET /products/SKU-000042    true        ~0.3ms       Cache HIT: Redis responde
  3s    GET /products/SKU-000042    true        ~0.5ms       Cache HIT: Redis responde
  4s    GET /stats                  —           —            hit_ratio ~83%
  5s    PATCH /price → 99.99       —           ~5ms         Actualiza PG, borra clave de Redis
  6s    GET /products/SKU-000042    false       ~80ms        Cache MISS: dato fresco de PG
  7s    GET /stats                  —           —            hit_ratio actualizado
```

La diferencia de **~120ms vs ~0.3ms** (ratio ~400x) es lo que justifica agregar Redis como capa de cache. En un sistema con cientos de requests por segundo, esto se traduce en:
- Menor carga sobre PostgreSQL
- Menor latencia para el usuario
- Mayor capacidad de escalar horizontalmente (Redis se puede replicar fácilmente)

---

## Stack técnico utilizado

| Componente | Versión | Razón de elección |
|------------|---------|-------------------|
| PostgreSQL 16 | alpine | Base de datos relacional estándar |
| Redis 7 | alpine | Cache en memoria, el más usado en la industria |
| Python 3.12 | slim | Backend 1, con FastAPI por su simplicidad |
| `psycopg` 3.x | — | Driver nativo de PostgreSQL para Python (reemplaza psycopg2) |
| `redis-py` 5.x | — | Cliente oficial de Redis para Python |
| Node.js 20 | alpine | Backend 2, con Express por su ubicuidad |
| `ioredis` 5.x | — | Cliente de Redis para Node (más completo que node-redis) |
| `pg` 8.x | — | Cliente de PostgreSQL para Node |

**¿Por qué no se usó un ORM (SQLAlchemy, Sequelize)?**
Para que los estudiantes vean exactamente qué query se ejecuta. Un ORM genera SQL automáticamente, lo cual es útil en producción pero oculta lo que está pasando cuando estás aprendiendo.

**¿Por qué dos backends?**
Para demostrar que el patrón Cache-Aside es independiente del lenguaje. La lógica es la misma, la clave de cache es la misma, y los dos backends pueden servir los mismos datos desde el mismo Redis.
