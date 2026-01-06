#!/bin/bash

# Script para levantar EjemploDockerfile (Proyecto 2)
# Migración por Script con Python + PostgreSQL

set -e

PROJECT_NAME="EjemploDockerfile"
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}========================================"
echo -e "🚀 Levantando ${PROJECT_NAME}"
echo -e "========================================${NC}"
echo ""

cd "$(dirname "$0")"

# Verificar si Docker está corriendo
if ! docker info > /dev/null 2>&1; then
    echo -e "${RED}❌ Error: Docker no está corriendo${NC}"
    echo "Por favor, inicia Docker e intenta de nuevo."
    exit 1
fi

echo -e "${GREEN}✅ Docker está corriendo${NC}"
echo ""

# Verificar si docker compose está disponible
if ! docker compose version > /dev/null 2>&1; then
    echo -e "${RED}❌ Error: docker compose no está disponible${NC}"
    exit 1
fi

echo -e "${GREEN}✅ docker compose disponible${NC}"
echo ""

# Verificar si Python está disponible
if ! command -v python3 > /dev/null 2>&1; then
    echo -e "${RED}❌ Error: Python 3 no está instalado${NC}"
    echo "Por favor, instala Python 3 e intenta de nuevo."
    exit 1
fi

echo -e "${GREEN}✅ Python 3 disponible$(python3 --version)${NC}"
echo ""

# Verificar si pip está disponible
if ! command -v pip3 > /dev/null 2>&1 && ! command -v pip > /dev/null 2>&1; then
    echo -e "${RED}❌ Error: pip no está instalado${NC}"
    exit 1
fi

PIP_CMD=$(command -v pip3 > /dev/null 2>&1 && echo "pip3" || echo "pip")
echo -e "${GREEN}✅ pip disponible${NC}"
echo ""

# Detener contenedores previos si existen
echo -e "${YELLOW}🧹 Limpiando contenedores previos...${NC}"
docker compose down > /dev/null 2>&1 || true

# Verificar que los archivos necesarios existan
echo -e "${YELLOW}📋 Verificando archivos necesarios...${NC}"

REQUIRED_FILES=(
    "docker-compose.yml"
    "Dockerfile"
    "migrate.py"
    "requirements.txt"
    "sql/schema.sql"
    "sql/seed.sql"
    "sql/queries.sql"
)

for file in "${REQUIRED_FILES[@]}"; do
    if [ ! -f "$file" ]; then
        echo -e "${RED}❌ Error: No se encuentra el archivo: $file${NC}"
        exit 1
    fi
done

echo -e "${GREEN}✅ Todos los archivos necesarios existen${NC}"
echo ""

# Instalar dependencias de Python
echo -e "${YELLOW}📦 Instalando dependencias de Python...${NC}"
echo ""

$PIP_CMD install -q -r requirements.txt

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Error al instalar dependencias${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Dependencias instaladas${NC}"
echo ""

# Construir e iniciar contenedor
echo -e "${BLUE}🔨 Construyendo e iniciando contenedor...${NC}"
echo ""

docker compose up -d --build

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Error al iniciar el contenedor${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}✅ Contenedor iniciado correctamente${NC}"
echo ""

# Esperar a que PostgreSQL esté listo
echo -e "${YELLOW}⏳ Esperando a que PostgreSQL esté listo...${NC}"
echo ""

TIMEOUT=60
ELAPSED=0

while [ $ELAPSED -lt $TIMEOUT ]; do
    if docker compose exec -T db pg_isready -U postgres -d mydb > /dev/null 2>&1; then
        echo -e "${GREEN}✅ PostgreSQL listo${NC}"
        break
    fi
    
    sleep 2
    ELAPSED=$((ELAPSED + 2))
    
    if [ $((ELAPSED % 10)) -eq 0 ]; then
        echo -e "${YELLOW}  Esperando... ($ELAPSED/${TIMEOUT}s)${NC}"
    fi
done

if [ $ELAPSED -ge $TIMEOUT ]; then
    echo -e "${RED}❌ Timeout esperando a PostgreSQL${NC}"
    echo -e "${YELLOW}📋 Mostrando logs para diagnóstico:${NC}"
    docker compose logs --tail=50
    exit 1
fi

# Mostrar logs recientes
echo ""
echo -e "${BLUE}📋 Logs recientes:${NC}"
echo -e "${YELLOW}========================================${NC}"
docker compose logs --tail=30
echo -e "${YELLOW}========================================${NC}"
echo ""

# Verificar estado de los servicios
echo -e "${BLUE}📊 Estado de los servicios:${NC}"
docker compose ps
echo ""

# Ejecutar migración
echo -e "${BLUE}🔄 Ejecutando migración con migrate.py...${NC}"
echo -e "${YELLOW}========================================${NC}"

python3 migrate.py

MIGRATION_RESULT=$?

echo -e "${YELLOW}========================================${NC}"

if [ $MIGRATION_RESULT -eq 0 ]; then
    echo -e "${GREEN}✅ Migración completada exitosamente${NC}"
else
    echo -e "${RED}❌ Error en la migración${NC}"
fi

echo ""

# Mostrar resumen de datos
echo -e "${BLUE}📊 Resumen de datos en la base de datos:${NC}"
echo ""

docker compose exec -T db psql -U postgres -d mydb -c "
SELECT 
    schemaname,
    tablename,
    n_live_tup as row_count
FROM pg_stat_user_tables
ORDER BY tablename;
" 2>/dev/null || echo -e "${YELLOW}No se pudo obtener el resumen${NC}"

echo ""

echo -e "${BLUE}========================================"
echo -e "🎉 ${PROJECT_NAME} está listo!"
echo -e "========================================${NC}"
echo ""
echo -e "${GREEN}🗄️  PostgreSQL:${NC}"
echo -e "   Host: localhost"
echo -e "   Port: 5432"
echo -e "   Database: mydb"
echo -e "   User: postgres"
echo -e "   Password: postgres"
echo ""
echo -e "${GREEN}🔗 Conexión desde psql:${NC}"
echo -e "   psql -h localhost -p 5432 -U postgres -d mydb"
echo ""
echo -e "${GREEN}🔗 Conexión desde Python:${NC}"
echo -e "   python3 -c \"import psycopg2; conn = psycopg2.connect(host='localhost', port=5432, database='mydb', user='postgres', password='postgres'); print('Conectado!')\""
echo ""
echo -e "${GREEN}🔗 Conexión desde DBeaver/pgAdmin:${NC}"
echo -e "   Host: localhost"
echo -e "   Port: 5432"
echo -e "   Database: mydb"
echo -e "   Username: postgres"
echo -e "   Password: postgres"
echo ""
echo -e "${BLUE}========================================"
echo -e "📋 Comandos útiles:"
echo -e "========================================${NC}"
echo -e "${YELLOW}Ver logs en tiempo real:${NC}"
echo -e "  docker compose logs -f"
echo ""
echo -e "${YELLOW}Abrir shell de psql:${NC}"
echo -e "  docker compose exec db psql -U postgres -d mydb"
echo ""
echo -e "${YELLOW}Ejecutar query SQL:${NC}"
echo -e "  docker compose exec -T db psql -U postgres -d mydb -c 'SELECT * FROM employees LIMIT 5;'"
echo ""
echo -e "${YELLOW}Listar tablas:${NC}"
echo -e "  docker compose exec -T db psql -U postgres -d mydb -c '\\dt'"
echo ""
echo -e "${YELLOW}Describir tabla:${NC}"
echo -e "  docker compose exec -T db psql -U postgres -d mydb -c '\\d employees'"
echo ""
echo -e "${YELLOW}Reejecutar migración:${NC}"
echo -e "  python3 migrate.py"
echo ""
echo -e "${YELLOW}Reiniciar contenedor:${NC}"
echo -e "  docker compose restart"
echo ""
echo -e "${YELLOW}Detener contenedor:${NC}"
echo -e "  docker compose down"
echo ""
echo -e "${YELLOW}Detener y eliminar datos:${NC}"
echo -e "  docker compose down -v"
echo ""
echo -e "${YELLOW}Ver contenedores:${NC}"
echo -e "  docker ps"
echo ""
echo -e "${YELLOW}Entrar al contenedor:${NC}"
echo -e "  docker compose exec db sh"
echo ""
echo -e "${BLUE}========================================${NC}"
echo -e "${GREEN}¡Listo para usar! 🚀${NC}"
echo -e "${BLUE}========================================${NC}"

# Mantener el script corriendo para mostrar logs
echo ""
echo -e "${YELLOW}Presiona Ctrl+C para detener todo...${NC}"
echo ""

trap "echo ''; echo -e '${YELLOW}Deteniendo servicios...${NC}'; docker compose down; echo -e '${GREEN}✅ Servicios detenidos${NC}'; exit 0" INT TERM

docker compose logs -f
