# Redis Cache Demo — Base de Datos Avanzada

Demo interactivo del patrón **Cache-Aside** con Redis, diseñado para la clase "Introducción a Redis" del Corte 3 de BDA. Muestra de forma tangible el impacto de agregar una capa de cache sobre PostgreSQL: latencia sin cache (~70-150ms) vs con cache (<2ms).

El proyecto incluye **dos backends paralelos** (Python/FastAPI y Node.js/Express) que comparten la misma base de datos PostgreSQL y la misma instancia de Redis, con contratos JSON idénticos. El profesor puede elegir cuál demostrar según el grupo.

## Requisitos

- Docker Compose v2
- `curl`
- `jq` (opcional, para formatear JSON en los scripts)

## Arranque rápido

```bash
git clone <repo> && cd redis-bda-demo
make up
# Esperar ~30-40 segundos (seed de 1M reseñas en PostgreSQL)
make bench-py
```

## Arquitectura

```
                    ┌──────────────┐
         :8001      │   Python     │
  curl ────────────>│   (FastAPI)  │──┐
                    └──────────────┘  │    ┌───────────┐
                                      ├───>│   Redis   │
                    ┌──────────────┐  │    │   :6379   │
         :8002      │   Node.js    │──┘    └───────────┘
  curl ────────────>│   (Express)  │──┐
                    └──────────────┘  │    ┌───────────┐
                                      └───>│ PostgreSQL│
                    Ambos backends         │   :5432   │
                    comparten Redis        │ 50K prod  │
                    y PostgreSQL            │ 1M reviews│
                                           └───────────┘
```

## Endpoints

Ambos backends exponen los mismos endpoints con contrato JSON idéntico:

| Método | Ruta | Descripción |
|--------|------|-------------|
| GET | `/health` | Health check (`{"status": "ok"}`) |
| GET | `/products/{sku}` | Obtiene producto con stats. Cache-aside, TTL 300s |
| PATCH | `/products/{sku}/price` | Actualiza precio, invalida cache |
| GET | `/stats` | Métricas de Redis (hits, misses, hit_ratio) |
| POST | `/cache/flush` | Vacía el cache (FLUSHDB) |

Cada respuesta de `/products/{sku}` incluye:
- `cache_hit`: `true`/`false`
- `latency_ms`: tiempo medido server-side
- `data`: objeto con sku, name, price, stock, category, review_count, avg_rating

## Demo sugerido para clase

```bash
# 1. Arrancar todo
make up
# Esperar ~30-40 segundos

# 2. Vaciar cache
curl -s -X POST http://localhost:8001/cache/flush | jq .

# 3. Primer request (MISS, ~70-150ms)
curl -s http://localhost:8001/products/SKU-000042 | jq .

# 4. Segundo request (HIT, <2ms)
curl -s http://localhost:8001/products/SKU-000042 | jq .

# 5. Ver métricas
curl -s http://localhost:8001/stats | jq .

# 6. Actualizar precio (invalida cache)
curl -s -X PATCH http://localhost:8001/products/SKU-000042/price \
  -H "Content-Type: application/json" \
  -d '{"price": 99.99}' | jq .

# 7. Request post-invalidación (MISS de nuevo)
curl -s http://localhost:8001/products/SKU-000042 | jq .

# 8. O ejecutar el script automatizado:
make bench-py    # Backend Python
make bench-node  # Backend Node
```

## Comandos disponibles

```bash
make up          # Inicia todos los servicios
make down        # Detiene los servicios (conserva datos)
make reset       # Teardown completo y rebuild (borra datos)
make bench-py    # Ejecuta demo con backend Python
make bench-node  # Ejecuta demo con backend Node
make logs        # Muestra logs en tiempo real
make psql        # Abre sesión de psql
make redis-cli   # Abre redis-cli
```

## Troubleshooting

**Los backends no arrancan / "connection refused"**
El seed de 1M reseñas tarda ~30 segundos. Los backends se reiniciarán automáticamente (`restart: on-failure`). Esperar y verificar con `docker compose ps`.

**Puerto 5432 o 6379 ocupado**
Otro servicio está usando el puerto. Detenerlo o cambiar los puertos en `docker-compose.yml`.

**La query es muy rápida (<30ms)**
Si la máquina es muy potente, la diferencia cache/no-cache se reduce. Aún así debería ser visible (30ms vs <2ms). Para aumentar la latencia, agregar más filas a `reviews` en `init.sql`.

**Error "SKU not found"**
Los SKUs válidos son `SKU-000001` hasta `SKU-050000`. Verificar que el formato sea correcto (guión, 6 dígitos con ceros a la izquierda).

## Licencia

MIT
