#!/bin/bash
# ============================================
# RESET - Reiniciar Base de Datos
# ============================================
# Uso: 
#   ./reset.sh              # Elimina y recrea tablas + datos
#   ./reset.sh --mode full  # Solo elimina tablas (BD vacía)
# ============================================

set -e

CONTAINER_NAME="postgres_container"
DB_NAME="actividad_db"
DB_USER="postgres"

# Colores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

# Parsear argumentos
MODE="normal"
while [[ $# -gt 0 ]]; do
    case $1 in
        --mode)
            MODE="$2"
            shift 2
            ;;
        *)
            echo "Uso: ./reset.sh [--mode full]"
            echo "  --mode full  Solo elimina tablas (deja BD vacía para práctica)"
            exit 1
            ;;
    esac
done

echo ""
echo -e "${YELLOW}⚠️  REINICIANDO BASE DE DATOS...${NC}"
echo -e "${CYAN}   Modo: $MODE${NC}"
echo ""

# Verificar que el contenedor está corriendo
if ! docker ps | grep -q "$CONTAINER_NAME"; then
    echo "❌ El contenedor $CONTAINER_NAME no está corriendo"
    echo "   Ejecuta: docker compose up -d"
    exit 1
fi

# Borrar tablas
echo "🗑️  Eliminando tablas existentes..."
docker exec $CONTAINER_NAME psql -U $DB_USER -d $DB_NAME -c "
DROP TABLE IF EXISTS orden_detalles CASCADE;
DROP TABLE IF EXISTS ordenes CASCADE;
DROP TABLE IF EXISTS productos CASCADE;
DROP TABLE IF EXISTS usuarios CASCADE;
DROP TABLE IF EXISTS categorias CASCADE;
"

echo -e "${GREEN}✅ Tablas eliminadas${NC}"

# Si no es modo full, recrear schema y seeds
if [ "$MODE" != "full" ]; then
    # Recrear schema
    echo ""
    echo "📦 Recreando schema..."
    docker exec -i $CONTAINER_NAME psql -U $DB_USER -d $DB_NAME < db/schema.sql

    # Insertar seeds
    echo ""
    echo "🌱 Insertando datos iniciales..."
    docker exec -i $CONTAINER_NAME psql -U $DB_USER -d $DB_NAME < db/seed.sql

    echo ""
    echo "============================================"
    echo -e "${GREEN}✅ BASE DE DATOS REINICIADA EXITOSAMENTE${NC}"
    echo "============================================"
    echo ""

    # Mostrar estado final
    echo "--- Estado final ---"
    docker exec $CONTAINER_NAME psql -U $DB_USER -d $DB_NAME -c "
    SELECT 'categorias' AS tabla, COUNT(*) AS registros FROM categorias
    UNION ALL SELECT 'usuarios', COUNT(*) FROM usuarios
    UNION ALL SELECT 'productos', COUNT(*) FROM productos
    UNION ALL SELECT 'ordenes', COUNT(*) FROM ordenes
    UNION ALL SELECT 'orden_detalles', COUNT(*) FROM orden_detalles
    ORDER BY tabla;
    "
else
    echo ""
    echo "============================================"
    echo -e "${GREEN}✅ BASE DE DATOS VACÍA (modo full)${NC}"
    echo "============================================"
    echo ""
    echo "La base de datos está lista para la práctica."
    echo "Los estudiantes deben ejecutar:"
    echo ""
    echo "  Desde psql:     \\i /scripts/schema.sql"
    echo "  Desde terminal: docker exec -i $CONTAINER_NAME psql -U $DB_USER -d $DB_NAME < db/schema.sql"
    echo ""
    
    # Verificar que no hay tablas
    echo "--- Verificación ---"
    docker exec $CONTAINER_NAME psql -U $DB_USER -d $DB_NAME -c "\dt"
fi
