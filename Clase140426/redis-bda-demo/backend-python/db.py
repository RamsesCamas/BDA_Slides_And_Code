"""
Conexiones a PostgreSQL y Redis.
Se inicializan a nivel de módulo para reutilizar pools entre requests.
"""

import os
import sys

from psycopg.rows import dict_row
from psycopg_pool import ConnectionPool
from redis import Redis, ConnectionPool as RedisPool

# --- PostgreSQL ---
# Usamos la URL completa de conexión que viene del docker-compose
_database_url = os.environ.get(
    "DATABASE_URL",
    "postgresql://bda:bda@localhost:5432/bda"
)

pg_pool = ConnectionPool(
    conninfo=_database_url,
    min_size=2,
    max_size=10,
    # dict_row hace que cada fila sea un dict en vez de una tupla,
    # mucho más legible cuando accedemos a row["sku"], row["price"], etc.
    kwargs={"row_factory": dict_row},
)

# --- Redis ---
# Parseamos host y port de REDIS_URL manualmente para usar ConnectionPool
_redis_url = os.environ.get("REDIS_URL", "redis://localhost:6379/0")
# Formato: redis://host:port/db
_redis_parts = _redis_url.replace("redis://", "").split("/")
_redis_host_port = _redis_parts[0].split(":")
_redis_host = _redis_host_port[0]
_redis_port = int(_redis_host_port[1]) if len(_redis_host_port) > 1 else 6379
_redis_db = int(_redis_parts[1]) if len(_redis_parts) > 1 else 0

_redis_pool = RedisPool(
    host=_redis_host,
    port=_redis_port,
    db=_redis_db,
    # decode_responses=True devuelve str en vez de bytes,
    # así json.loads() funciona directo sin necesidad de .decode()
    decode_responses=True,
    max_connections=20,
)

redis_client = Redis(connection_pool=_redis_pool)


def check_connections() -> None:
    """Verifica que ambas conexiones estén activas al arrancar.
    Si alguna falla, el proceso termina con exit code 1."""
    try:
        redis_client.ping()
        print("[startup] Redis: OK", flush=True)
    except Exception as e:
        print(f"[startup] Redis: FALLO - {e}", flush=True)
        sys.exit(1)

    try:
        with pg_pool.connection() as conn:
            conn.execute("SELECT 1")
        print("[startup] PostgreSQL: OK", flush=True)
    except Exception as e:
        print(f"[startup] PostgreSQL: FALLO - {e}", flush=True)
        sys.exit(1)
