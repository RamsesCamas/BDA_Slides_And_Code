#!/bin/bash
# ============================================================
# reset.sh — Teardown completo y rebuild del demo
# ============================================================
# Elimina volúmenes (datos de PG y Redis), reconstruye imágenes
# y reinicia todo desde cero. Útil entre demos.
# ============================================================

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m'

echo ""
echo -e "${YELLOW}[1/4] Deteniendo servicios y eliminando volúmenes...${NC}"
docker compose down -v

echo ""
echo -e "${CYAN}[2/4] Reconstruyendo imágenes e iniciando servicios...${NC}"
docker compose up -d --build

echo ""
echo -e "${YELLOW}[3/4] Esperando a que los servicios estén listos...${NC}"
echo "       (El seed de 1M reseñas puede tardar ~30 segundos)"

# Esperar a que ambos backends respondan en /health
for i in $(seq 1 60); do
  PY=$(curl -sf http://localhost:8001/health 2>/dev/null || echo "")
  NODE=$(curl -sf http://localhost:8002/health 2>/dev/null || echo "")

  if [ -n "$PY" ] && [ -n "$NODE" ]; then
    echo -e "${GREEN}  Ambos backends listos (${i}s)${NC}"
    break
  fi

  if [ "$i" -eq 60 ]; then
    echo -e "${RED}  Timeout esperando backends. Revisar: docker compose logs${NC}"
    exit 1
  fi

  sleep 2
done

echo ""
echo -e "${CYAN}[4/4] Verificando datos...${NC}"
docker compose exec -T postgres psql -U bda -d bda -c "
SELECT 'categories' AS tabla, COUNT(*) AS registros FROM categories
UNION ALL SELECT 'products', COUNT(*) FROM products
UNION ALL SELECT 'reviews', COUNT(*) FROM reviews
ORDER BY tabla;
"

echo ""
echo -e "${GREEN}======================================================${NC}"
echo -e "${GREEN}  Reset completado${NC}"
echo -e "${GREEN}======================================================${NC}"
echo -e "  Python:     http://localhost:8001/docs"
echo -e "  Node:       http://localhost:8002/health"
echo -e "  PostgreSQL: localhost:5432"
echo -e "  Redis:      localhost:6379"
echo ""
