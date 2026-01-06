#!/bin/bash

# Script principal para ejecutar cualquiera de los 3 proyectos

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}========================================"
echo -e "🎓 BDA - Clase 1: Scripts de Inicio"
echo -e "========================================${NC}"
echo ""

# Verificar que se pasó un argumento
if [ -z "$1" ]; then
    echo -e "${YELLOW}Uso: $0 [proyecto]${NC}"
    echo ""
    echo "Proyectos disponibles:"
    echo -e "  ${GREEN}1${NC} - VisualizacionSQLIntro (SQL Lab Web)"
    echo -e "  ${GREEN}2${NC} - EjemploDockerfile (Migración por Script)"
    echo -e "  ${GREEN}3${NC} - RepoOptimizado (Sin Rebuild)"
    echo ""
    echo "Ejemplos:"
    echo "  ./start-all.sh 1"
    echo "  ./start-all.sh VisualizacionSQLIntro"
    echo "  ./start-all.sh 2"
    echo ""
    exit 1
fi

# Mapear argumentos
case "$1" in
    1|VisualizacionSQLIntro|visualizacionsqlintro)
        PROJECT_DIR="VisualizacionSQLIntro"
        PROJECT_NAME="VisualizacionSQLIntro"
        ;;
    2|EjemploDockerfile|ejemplodockerfile)
        PROJECT_DIR="EjemploDockerfile"
        PROJECT_NAME="EjemploDockerfile"
        ;;
    3|RepoOptimizado|repooptimizado)
        PROJECT_DIR="RepoOptimizado"
        PROJECT_NAME="RepoOptimizado"
        ;;
    *)
        echo -e "${RED}❌ Error: Proyecto '$1' no reconocido${NC}"
        echo ""
        echo "Proyectos disponibles:"
        echo -e "  ${GREEN}1${NC} - VisualizacionSQLIntro"
        echo -e "  ${GREEN}2${NC} - EjemploDockerfile"
        echo -e "  ${GREEN}3${NC} - RepoOptimizado"
        echo ""
        exit 1
        ;;
esac

# Verificar que el directorio del proyecto exista
if [ ! -d "$PROJECT_DIR" ]; then
    echo -e "${RED}❌ Error: No se encuentra el directorio del proyecto: $PROJECT_DIR${NC}"
    exit 1
fi

# Verificar que el script de inicio exista
if [ ! -f "$PROJECT_DIR/start.sh" ]; then
    echo -e "${RED}❌ Error: No se encuentra el script de inicio: $PROJECT_DIR/start.sh${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Proyecto seleccionado: ${PROJECT_NAME}${NC}"
echo ""

# Cambiar al directorio del proyecto y ejecutar el script
cd "$PROJECT_DIR"
exec ./start.sh
