# Actividad: Vistas SQL con campos calculados + agregaciones (GROUP BY / HAVING)

## Objetivo
Crear **3 vistas SQL** que funcionen como reportes reutilizables (para API/dashboards), aplicando:
- funciones agregadas
- GROUP BY
- HAVING
- al menos 1 campo calculado por vista

## Entregable
Tu equipo entrega **un solo archivo**:
- `db/equipos/<TU_EQUIPO>/views.sql`

No modifiques `schema.sql`, `seed.sql`, `migrate.sql` (salvo indicación del docente).

---

## Reglas (obligatorias)
1) Prohibido `SELECT *` en las vistas.
2) Cada vista debe tener un comentario inicial con:
   - **Qué devuelve**
   - **Grain** (una fila representa…)
   - **Métricas** (SUM/COUNT/AVG…)
3) Cada vista debe usar:
   - `GROUP BY`
   - `HAVING` (filtrado sobre agregaciones)
   - al menos **1 campo calculado** (ej. `ventas_total / ordenes_count`, `COALESCE`, `CASE`, etc.)
4) Nombres de vistas **incluyen el sufijo del equipo**:
   - `vw_top_productos_<EQUIPO>`
   - `vw_ventas_mensuales_<EQUIPO>`
   - `vw_clientes_valor_<EQUIPO>`

---

## Slices por equipo (anti copy-paste)
Cada equipo debe filtrar su “porción” de datos usando `MOD(id, 6)`:

| Equipo | MOD(id,6) |
|-------:|-----------|
| A | 0 |
| B | 1 |
| C | 2 |
| D | 3 |
| E | 4 |
| F | 5 |

ID a usar en el filtro por vista:
- Top productos: `producto_id`
- Ventas mensuales: `orden_id`
- Valor de clientes: `cliente_id`

> Nota: si tu esquema usa nombres distintos (ej. `productos.id` o `clientes.id_cliente`), ajusta el identificador correcto, pero **mantén la regla MOD(...,6)=N**.

---

## Qué construir (las 3 vistas)

### Vista 1: Top productos
**Nombre:** `vw_top_productos_<EQUIPO>`

Debe incluir (mínimo):
- `producto_id`
- `producto_nombre`
- `unidades_vendidas` (SUM)
- `ventas_total` (SUM)
- 1 campo calculado (ej. `ventas_total / NULLIF(unidades_vendidas,0)` como `precio_promedio`)

Debe usar:
- JOIN (producto + detalles de orden)
- GROUP BY por producto
- HAVING (ej. `SUM(cantidad) >= 2`)

Debe filtrar por equipo:
- `WHERE MOD(producto_id, 6) = <TU_MOD>`

---

### Vista 2: Ventas mensuales
**Nombre:** `vw_ventas_mensuales_<EQUIPO>`

Debe incluir (mínimo):
- `anio`
- `mes`
- `ordenes_count` (COUNT DISTINCT)
- `ventas_total` (SUM)
- 1 campo calculado (ej. `ventas_total / NULLIF(ordenes_count,0)` como `ticket_promedio`)

Debe usar:
- GROUP BY por año/mes
- HAVING (ej. `COUNT(DISTINCT orden_id) >= 2`)

Debe filtrar por equipo:
- `WHERE MOD(orden_id, 6) = <TU_MOD>`

---

### Vista 3: Valor de clientes
**Nombre:** `vw_clientes_valor_<EQUIPO>`

Debe incluir (mínimo):
- `cliente_id`
- `cliente_nombre` (o equivalente)
- `ordenes_count`
- `gasto_total`
- 1 campo calculado (ej. `gasto_total / NULLIF(ordenes_count,0)` como `gasto_promedio`)

Debe usar:
- JOIN (clientes + ordenes)
- GROUP BY por cliente
- HAVING (ej. `COUNT(DISTINCT orden_id) >= 2`)

Debe filtrar por equipo:
- `WHERE MOD(cliente_id, 6) = <TU_MOD>`

---

## Pasos (checklist)
1) Levanta ambiente:
```bash
docker compose up -d
./reset.sh
````

2. Abre tu archivo:

* Equipo A: `db/equipos/A/views.sql`
* Equipo B: `db/equipos/B/views.sql`
* ...
* Equipo F: `db/equipos/F/views.sql`

3. Implementa las 3 vistas (CREATE OR REPLACE VIEW).

4. Ejecuta tu archivo:

```bash
docker compose exec -T db psql -U postgres -d postgres -f db/equipos/<TU_EQUIPO>/views.sql
```

5. Verifica resultados (ejemplo Equipo A):

```bash
docker compose exec -T db psql -U postgres -d postgres -c "SELECT * FROM vw_top_productos_A LIMIT 10;"
docker compose exec -T db psql -U postgres -d postgres -c "SELECT * FROM vw_ventas_mensuales_A LIMIT 10;"
docker compose exec -T db psql -U postgres -d postgres -c "SELECT * FROM vw_clientes_valor_A LIMIT 10;"
```

6. Entrega:

* Commit y push de tu `views.sql`
* Tu archivo debe correr sin errores desde cero (con `./reset.sh`)

---

## Tip de oro (para no fallar)

Si te marca error por nombres, revisa `db/schema.sql` para ubicar:

* tablas reales (productos/ordenes/detalles/clientes)
* columnas reales (id/nombre/fecha/subtotal/cantidad/total)

La lógica debe ser la misma aunque cambien nombres.

````
