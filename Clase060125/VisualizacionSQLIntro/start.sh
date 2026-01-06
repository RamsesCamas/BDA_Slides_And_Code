#!/bin/bash

# Script para levantar VisualizacionSQLIntro (Proyecto 1)
# SQL Lab Web con React + FastAPI + PostgreSQL
# Versión simplificada para demo visual (sin autenticación, sin equipos)

set -e

PROJECT_NAME="VisualizacionSQLIntro"
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}========================================"
echo -e "🚀 Levantando ${PROJECT_NAME}"
echo -e "========================================${NC}"
echo ""
echo -e "${YELLOW}Modo: Demo Visual (sin autenticación)${NC}"
echo ""

cd "$(dirname "$0")"

# Verificar archivos
echo -e "${YELLOW}Verificando archivos necesarios...${NC}"

REQUIRED_FILES=(
    "docker-compose.yml"
    "backend/Dockerfile"
    "backend/main.py"
    "backend/requirements.txt"
    "backend/sql_scripts/schema.sql"
    "backend/sql_scripts/seed.sql"
    "backend/queries.sql"
    "frontend/Dockerfile"
    "frontend/package.json"
)

for file in "${REQUIRED_FILES[@]}"; do
    if [ ! -f "$file" ]; then
        echo -e "${RED}❌ No se encuentra: $file${NC}"
        exit 1
    fi
done

echo -e "${GREEN}✅ Todos los archivos existen${NC}"
echo ""

# Verificar Docker
if ! docker info > /dev/null 2>&1; then
    echo -e "${RED}❌ Docker no está corriendo${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Docker está corriendo${NC}"
echo ""

# Verificar docker compose
if ! docker compose version > /dev/null 2>&1; then
    echo -e "${RED}❌ docker compose no disponible${NC}"
    exit 1
fi

echo -e "${GREEN}✅ docker compose disponible${NC}"
echo ""

# Detener contenedores previos
echo -e "${YELLOW}Limpiando contenedores previos...${NC}"
docker compose down > /dev/null 2>&1 || true

# Iniciar contenedores
echo -e "${BLUE}Iniciando servicios...${NC}"
docker compose up -d --build

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Error al iniciar servicios${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}✅ Contenedores iniciados${NC}"
echo ""

# Esperar a que backend esté listo
echo -e "${YELLOW}Esperando a que backend esté listo...${NC}"
for i in {1..30}; do
    if curl -s http://localhost:8000/api/health > /dev/null 2>&1; then
        echo -e "${GREEN}✅ Backend listo${NC}"
        break
    fi
    sleep 2
done

# Cargar datos de seed si la base está vacía
echo -e "${YELLOW}Verificando datos en la base...${NC}"
DB_COUNT=$(docker compose exec -T db psql -U postgres -d bda_class -tAc "SELECT COUNT(*) FROM employees;" 2>/dev/null || echo "0")
if [ "$DB_COUNT" = "0" ]; then
    echo -e "${YELLOW}Cargando datos de seed...${NC}"
    docker compose exec -T db psql -U postgres -d bda_class < backend/sql_scripts/seed.sql
    echo -e "${GREEN}✅ Datos cargados${NC}"
else
    echo -e "${GREEN}✅ Base de datos ya contiene datos${NC}"
fi

# Mostrar logs
echo ""
echo -e "${BLUE}Logs recientes:${NC}"
docker compose logs --tail=10
echo ""
echo -e "${BLUE}========================================${NC}"
echo -e "${GREEN}¡Listo para usar!${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""
echo -e "📱 Frontend: http://localhost:3000"
echo -e "⚙️  Backend: http://localhost:8000"
echo -e "📚 API Docs: http://localhost:8000/docs"
echo -e ""
echo -e "ℹ️  Este es un demo visual de queries SQL"
echo -e "ℹ️  No requiere autenticación"
echo -e ""
echo -e "Para detener: docker compose down"
