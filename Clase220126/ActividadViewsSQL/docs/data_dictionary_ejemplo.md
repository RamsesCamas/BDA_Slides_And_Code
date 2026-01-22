# 📖 Diccionario de Datos

## Información General

| Propiedad | Valor |
|-----------|-------|
| **Base de datos** | actividad_db |
| **DBMS** | PostgreSQL 16 |
| **Equipo** | [Nombre del equipo] |
| **Fecha** | [Fecha] |
| **Dominio** | E-commerce (ejemplo) |

---

## Diagrama de Relaciones

```
┌─────────────┐     ┌─────────────┐
│ categorias  │     │  usuarios   │
└──────┬──────┘     └──────┬──────┘
       │                   │
       │ 1:N               │ 1:N
       ▼                   ▼
┌─────────────┐     ┌─────────────┐
│  productos  │     │   ordenes   │
└──────┬──────┘     └──────┬──────┘
       │                   │
       │ 1:N               │ 1:N
       │                   │
       └───────┬───────────┘
               ▼
       ┌───────────────┐
       │ orden_detalles│
       └───────────────┘
```

---

## Tabla: `categorias`

Catálogo de categorías de productos.

| Campo | Tipo | Null | Default | Constraints | Descripción |
|-------|------|------|---------|-------------|-------------|
| id | SERIAL | NO | auto | PK | Identificador único |
| nombre | VARCHAR(100) | NO | - | UNIQUE | Nombre de la categoría |
| descripcion | TEXT | SÍ | NULL | - | Descripción detallada |
| created_at | TIMESTAMP | NO | CURRENT_TIMESTAMP | - | Fecha de creación |

**Ejemplo de datos:**
| id | nombre | descripcion |
|----|--------|-------------|
| 1 | Electrónica | Dispositivos electrónicos y accesorios |
| 2 | Ropa | Vestimenta y accesorios de moda |

---

## Tabla: `usuarios`

Usuarios registrados en el sistema.

| Campo | Tipo | Null | Default | Constraints | Descripción |
|-------|------|------|---------|-------------|-------------|
| id | SERIAL | NO | auto | PK | Identificador único |
| email | VARCHAR(255) | NO | - | UNIQUE, NOT NULL | Correo electrónico |
| nombre | VARCHAR(100) | NO | - | NOT NULL | Nombre completo |
| password_hash | VARCHAR(255) | NO | - | NOT NULL | Hash de contraseña |
| activo | BOOLEAN | NO | TRUE | - | Estado del usuario |
| created_at | TIMESTAMP | NO | CURRENT_TIMESTAMP | - | Fecha de registro |
| updated_at | TIMESTAMP | NO | CURRENT_TIMESTAMP | - | Última actualización |

**Ejemplo de datos:**
| id | email | nombre |
|----|-------|--------|
| 1 | ada@example.com | Ada Lovelace |
| 2 | alan@example.com | Alan Turing |

---

## Tabla: `productos`

Catálogo de productos disponibles para venta.

| Campo | Tipo | Null | Default | Constraints | Descripción |
|-------|------|------|---------|-------------|-------------|
| id | SERIAL | NO | auto | PK | Identificador único |
| codigo | VARCHAR(50) | NO | - | UNIQUE, NOT NULL | Código SKU |
| nombre | VARCHAR(200) | NO | - | NOT NULL | Nombre del producto |
| descripcion | TEXT | SÍ | NULL | - | Descripción detallada |
| precio | DECIMAL(10,2) | NO | - | CHECK >= 0 | Precio unitario |
| stock | INTEGER | NO | 0 | CHECK >= 0 | Cantidad disponible |
| categoria_id | INTEGER | NO | - | FK → categorias(id), ON DELETE RESTRICT | Categoría del producto |
| activo | BOOLEAN | NO | TRUE | - | Producto activo/inactivo |
| created_at | TIMESTAMP | NO | CURRENT_TIMESTAMP | - | Fecha de creación |

**Índices:**
- `idx_productos_categoria_id` en `categoria_id`

**Ejemplo de datos:**
| id | codigo | nombre | precio | stock | categoria_id |
|----|--------|--------|--------|-------|--------------|
| 1 | ELEC-001 | Laptop Pro 15" | 1299.99 | 50 | 1 |
| 2 | ELEC-002 | Mouse Inalámbrico | 29.99 | 200 | 1 |

---

## Tabla: `ordenes`

Órdenes/pedidos realizados por usuarios.

| Campo | Tipo | Null | Default | Constraints | Descripción |
|-------|------|------|---------|-------------|-------------|
| id | SERIAL | NO | auto | PK | Identificador único |
| usuario_id | INTEGER | NO | - | FK → usuarios(id), ON DELETE RESTRICT | Usuario que realizó la orden |
| total | DECIMAL(12,2) | NO | 0 | CHECK >= 0 | Monto total de la orden |
| status | VARCHAR(20) | NO | 'pendiente' | CHECK IN (...) | Estado de la orden |
| created_at | TIMESTAMP | NO | CURRENT_TIMESTAMP | - | Fecha de creación |
| updated_at | TIMESTAMP | NO | CURRENT_TIMESTAMP | - | Última actualización |

**Valores válidos para `status`:**
- `pendiente` - Orden creada, sin pago
- `pagado` - Pago confirmado
- `enviado` - En tránsito
- `entregado` - Entregado al cliente
- `cancelado` - Orden cancelada

**Índices:**
- `idx_ordenes_usuario_id` en `usuario_id`
- `idx_ordenes_status` en `status`

---

## Tabla: `orden_detalles`

Detalle de productos por cada orden.

| Campo | Tipo | Null | Default | Constraints | Descripción |
|-------|------|------|---------|-------------|-------------|
| id | SERIAL | NO | auto | PK | Identificador único |
| orden_id | INTEGER | NO | - | FK → ordenes(id), ON DELETE CASCADE | Orden padre |
| producto_id | INTEGER | NO | - | FK → productos(id), ON DELETE RESTRICT | Producto comprado |
| cantidad | INTEGER | NO | - | CHECK > 0 | Cantidad ordenada |
| precio_unitario | DECIMAL(10,2) | NO | - | CHECK >= 0 | Precio al momento de compra |
| subtotal | DECIMAL(12,2) | NO | auto | GENERATED | cantidad × precio_unitario |

**Constraints adicionales:**
- `UNIQUE(orden_id, producto_id)` - Un producto solo aparece una vez por orden

**Decisiones de diseño:**
- `ON DELETE CASCADE` en `orden_id`: Si se elimina una orden, se eliminan sus detalles
- `ON DELETE RESTRICT` en `producto_id`: No se puede eliminar un producto que ha sido vendido
- `subtotal` es columna generada para evitar inconsistencias

---

## Resumen de Constraints

| Tabla | Constraint | Tipo | Justificación |
|-------|-----------|------|---------------|
| usuarios | email UNIQUE | Integridad | Evita registros duplicados |
| productos | codigo UNIQUE | Integridad | SKU único para inventario |
| productos | precio >= 0 | CHECK | Precios no pueden ser negativos |
| productos | stock >= 0 | CHECK | Stock no puede ser negativo |
| ordenes | status IN (...) | CHECK | Solo estados válidos |
| orden_detalles | cantidad > 0 | CHECK | No se pueden ordenar 0 unidades |
| orden_detalles | (orden_id, producto_id) UNIQUE | Integridad | Evita duplicados en detalle |

---

## Índices Adicionales

| Índice | Tabla | Columna(s) | Justificación |
|--------|-------|------------|---------------|
| idx_ordenes_usuario_id | ordenes | usuario_id | Búsqueda de órdenes por usuario |
| idx_productos_categoria_id | productos | categoria_id | Filtrado por categoría |
| idx_ordenes_status | ordenes | status | Reportes por estado |
