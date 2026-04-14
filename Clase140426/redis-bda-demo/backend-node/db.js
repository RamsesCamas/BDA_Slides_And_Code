/**
 * Conexiones a PostgreSQL y Redis.
 * Se inicializan a nivel de módulo para reutilizar pools entre requests.
 */

import pg from "pg";
import Redis from "ioredis";

const { Pool } = pg;

// --- PostgreSQL ---
// pg.Pool acepta una connection string directamente
const databaseUrl = process.env.DATABASE_URL || "postgresql://bda:bda@localhost:5432/bda";

export const pool = new Pool({
  connectionString: databaseUrl,
  max: 10,
});

// --- Redis ---
// ioredis acepta una URL directamente
const redisUrl = process.env.REDIS_URL || "redis://localhost:6379/0";

export const redis = new Redis(redisUrl, {
  lazyConnect: false, // conecta al instanciar
});

/**
 * Verifica que ambas conexiones estén activas al arrancar.
 * Si alguna falla, el proceso termina con exit code 1.
 */
export async function checkConnections() {
  try {
    await redis.ping();
    console.log("[startup] Redis: OK");
  } catch (err) {
    console.error("[startup] Redis: FALLO -", err.message);
    process.exit(1);
  }

  try {
    const client = await pool.connect();
    await client.query("SELECT 1");
    client.release();
    console.log("[startup] PostgreSQL: OK");
  } catch (err) {
    console.error("[startup] PostgreSQL: FALLO -", err.message);
    process.exit(1);
  }
}
