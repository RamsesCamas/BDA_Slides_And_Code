#!/bin/bash

# Script runner para ejecutar scripts SQL en PostgreSQL
# Uso: ./runner.sh [archivo_sql]

set -e

DB_HOST="${DB_HOST:-db}"
DB_PORT="${DB_PORT:-5432}"
DB_NAME="${DB_NAME:-mydb}"
DB_USER="${DB_USER:-postgres}"

SQL_DIR="/sql"

echo "🚀 Runner de Scripts SQL"
echo "================================"
echo "Host: $DB_HOST:$DB_PORT"
echo "Database: $DB_NAME"
echo "User: $DB_USER"
echo ""

wait_for_db() {
    echo "⏳ Esperando a que PostgreSQL esté listo..."
    
    for i in {1..30}; do
        if PGPASSWORD="${DB_PASSWORD:-postgres}" psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" -c '\q' 2>/dev/null; then
            echo "✅ PostgreSQL está listo!"
            return 0
        fi
        echo "  Intento $i/30..."
        sleep 2
    done
    
    echo "❌ No se pudo conectar a PostgreSQL"
    return 1
}

execute_sql_file() {
    local sql_file="$1"
    local description="$2"
    
    if [ ! -f "$sql_file" ]; then
        echo "⚠️  Archivo no encontrado: $sql_file"
        return 1
    fi
    
    echo ""
    echo "⚡ Ejecutando: $description"
    echo "Archivo: $sql_file"
    echo "----------------------------------------"
    
    if PGPASSWORD="${DB_PASSWORD:-postgres}" psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" -f "$sql_file"; then
        echo "✅ $description completado exitosamente"
        return 0
    else
        echo "❌ Error ejecutando $description"
        return 1
    fi
}

execute_all() {
    wait_for_db || exit 1
    
    local success=true
    
    execute_sql_file "${SQL_DIR}/01_schema.sql" "Schema" || success=false
    execute_sql_file "${SQL_DIR}/02_seed.sql" "Seed" || success=false
    execute_sql_file "${SQL_DIR}/03_queries.sql" "Queries" || success=false
    
    echo ""
    echo "================================"
    if [ "$success" = true ]; then
        echo "🎉 Todos los scripts ejecutados exitosamente!"
    else
        echo "⚠️  Algunos scripts fallaron"
    fi
    echo "================================"
}

case "${1:-all}" in
    all|full)
        execute_all
        ;;
    schema)
        wait_for_db || exit 1
        execute_sql_file "${SQL_DIR}/01_schema.sql" "Schema"
        ;;
    seed)
        wait_for_db || exit 1
        execute_sql_file "${SQL_DIR}/02_seed.sql" "Seed"
        ;;
    queries)
        wait_for_db || exit 1
        execute_sql_file "${SQL_DIR}/03_queries.sql" "Queries"
        ;;
    custom)
        if [ -z "$2" ]; then
            echo "❌ Se requiere un archivo SQL"
            echo "Uso: $0 custom <archivo.sql>"
            exit 1
        fi
        wait_for_db || exit 1
        execute_sql_file "$2" "Custom SQL"
        ;;
    help|--help|-h)
        echo "Uso: $0 [comando]"
        echo ""
        echo "Comandos:"
        echo "  all|full    - Ejecuta todos los scripts (schema, seed, queries)"
        echo "  schema       - Ejecuta solo el schema (01_schema.sql)"
        echo "  seed         - Ejecuta solo el seed (02_seed.sql)"
        echo "  queries      - Ejecuta solo las queries (03_queries.sql)"
        echo "  custom <sql> - Ejecuta un archivo SQL personalizado"
        echo "  help         - Muestra esta ayuda"
        ;;
    *)
        echo "❌ Comando desconocido: $1"
        echo "Usa '$0 help' para ver la ayuda"
        exit 1
        ;;
esac
