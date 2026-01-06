#!/bin/bash

# Script para levantar RepoOptimizado (Proyecto 3)
# Repo del Profe con Makefile + Volumen (Sin Rebuild)

set -e

PROJECT_NAME="RepoOptimizado"
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

# Verificar si make está disponible
if ! command -v make > /dev/null 2>&1; then
    echo -e "${RED}❌ Error: make no está instalado${NC}"
    echo "Por favor, instala make e intenta de nuevo."
    echo "  macOS: xcode-select --install"
    echo "  Linux (Ubuntu/Debian): sudo apt-get install build-essential"
    echo "  Linux (CentOS/RHEL): sudo yum groupinstall 'Development Tools'"
    exit 1
fi

echo -e "${GREEN}✅ make disponible${NC}"
echo ""

# Detener contenedores previos si existen
echo -e "${YELLOW}🧹 Limpiando contenedores previos...${NC}"
make down > /dev/null 2>&1 || true

# Verificar que los archivos necesarios existan
echo -e "${YELLOW}📋 Verificando archivos necesarios...${NC}"

REQUIRED_FILES=(
    "Makefile"
    "docker-compose.yml"
    "sql/01_schema.sql"
    "sql/02_seed.sql"
    "sql/03_queries.sql"
    "scripts/runner.sh"
)

for file in "${REQUIRED_FILES[@]}"; do
    if [ ! -f "$file" ]; then
        echo -e "${RED}❌ Error: No se encuentra el archivo: $file${NC}"
        exit 1
    fi
done

echo -e "${GREEN}✅ Todos los archivos necesarios existen${NC}"
echo ""

# Asegurar que runner.sh sea ejecutable
chmod +x scripts/runner.sh > /dev/null 2>&1 || true

# Iniciar servicios
echo -e "${BLUE}🔨 Iniciando servicios...${NC}"
echo ""

make up

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Error al iniciar los servicios${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}✅ Servicios iniciados correctamente${NC}"
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
echo -e "${BLUE}🔄 Ejecutando migración (sin rebuild)...${NC}"
echo -e "${YELLOW}========================================${NC}"

make migrate

echo -e "${YELLOW}========================================${NC}"

echo ""

# Mostrar resumen de datos
echo -e "${BLUE}📊 Resumen de datos en la base de datos:${NC}"
echo ""

make inspect

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
echo -e "📋 Comandos make disponibles:"
echo -e "========================================${NC}"
echo -e "${YELLOW}Ver todos los comandos:${NC}"
echo -e "  make help"
echo ""
echo -e "${GREEN}Gestión de servicios:${NC}"
echo -e "  make up         - Iniciar servicios"
echo -e "  make down       - Detener servicios"
echo -e "  make restart    - Reiniciar servicios"
echo -e "  make status     - Estado de servicios"
echo -e "  make logs       - Ver logs en tiempo real"
echo ""
echo -e "${GREEN}Migraciones (sin rebuild!):${NC}"
echo -e "  make migrate         - Ejecutar todas las migraciones"
echo -e "  make migrate-schema  - Ejecutar solo schema"
echo -e "  make migrate-seed    - Ejecutar solo seed"
echo -e "  make run-queries     - Ejecutar queries"
echo -e "  make reset           - Reiniciar y migrar"
echo ""
echo -e "${GREEN}Interacción con la DB:${NC}"
echo -e "  make shell           - Abrir psql interactivo"
echo -e "  make db cmd='...'    - Ejecutar comando SQL"
echo -e "  make test            - Probar conexión"
echo -e "  make inspect         - Inspeccionar tablas"
echo ""
echo -e "${GREEN}Mantenimiento:${NC}"
echo -e "  make build       - Construir imágenes"
echo -e "  make clean       - Limpiar contenedores y volúmenes"
echo -e "  make rebuild     - Reconstruir todo"
echo ""
echo -e "${BLUE}========================================"
echo -e "📋 Otros comandos útiles:"
echo -e "========================================${NC}"
echo -e "${YELLOW}Usar el script runner.sh:${NC}"
echo -e "  docker compose exec runner /scripts/runner.sh all"
echo -e "  docker compose exec runner /scripts/runner.sh schema"
echo -e "  docker compose exec runner /scripts/runner.sh seed"
echo ""
echo -e "${YELLOW}Ver logs específicos:${NC}"
echo -e "  docker compose logs -f db"
echo -e "  docker compose logs -f runner"
echo ""
echo -e "${YELLOW}Entrar a contenedor:${NC}"
echo -e "  docker compose exec db sh"
echo -e "  docker compose exec runner sh"
echo ""
echo -e "${YELLOW}Ver contenedores:${NC}"
echo -e "  docker ps"
echo ""
echo -e "${YELLOW}Ejecutar comandos SQL directamente:${NC}"
echo -e "  docker compose exec -T db psql -U postgres -d mydb -c 'SELECT * FROM employees;'"
echo ""
echo -e "${BLUE}========================================"
echo -e "💡 Concepto clave: Sin Rebuild${NC}"
echo -e "========================================${NC}"
echo -e "${GREEN}Para modificar scripts SQL:${NC}"
echo -e "  1. Editar archivos en ./sql/"
echo -e "  2. Ejecutar: make migrate"
echo -e "  3. ¡Listo! No necesitas rebuild${NC}"
echo ""
echo -e "${YELLOW}❌ Enfoque tradicional (lento):${NC}"
echo -e "  docker compose down && docker compose up --build"
echo -e "  ⏱️  2-5 minutos"
echo ""
echo -e "${GREEN}✅ Enfoque optimizado (rápido):${NC}"
echo -e "  make migrate"
echo -e "  ⏱️  1-2 segundos${NC}"
echo ""
echo -e "${BLUE}========================================${NC}"
echo -e "${GREEN}¡Listo para usar! 🚀${NC}"
echo -e "${BLUE}========================================${NC}"

# Mantener el script corriendo para mostrar logs
echo ""
echo -e "${YELLOW}Presiona Ctrl+C para detener todo...${NC}"
echo ""

trap "echo ''; echo -e '${YELLOW}Deteniendo servicios...${NC}'; make down; echo -e '${GREEN}✅ Servicios detenidos${NC}'; exit 0" INT TERM

docker compose logs -f
