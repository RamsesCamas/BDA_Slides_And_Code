#!/bin/bash
# ============================================================
# bench.sh — Demostración del ciclo completo de cache con Redis
# ============================================================
# Uso:
#   ./scripts/bench.sh                         # Python (default)
#   BACKEND_URL=http://localhost:8002 ./scripts/bench.sh  # Node
# ============================================================

set -e

# --- Colores para la terminal ---
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# --- Configuración ---
BACKEND_URL="${BACKEND_URL:-http://localhost:8001}"
SKU="SKU-000042"

# Detectar si jq está disponible; si no, usar python3 como fallback
if command -v jq &> /dev/null; then
  FMT="jq ."
else
  echo -e "${YELLOW}[aviso] jq no encontrado, usando python3 para formatear JSON${NC}"
  FMT="python3 -m json.tool"
fi

echo ""
echo -e "${CYAN}${BOLD}======================================================${NC}"
echo -e "${CYAN}${BOLD}  Demo Cache-Aside con Redis${NC}"
echo -e "${CYAN}${BOLD}  Backend: ${BACKEND_URL}${NC}"
echo -e "${CYAN}${BOLD}======================================================${NC}"
echo ""

# -----------------------------------------------
# Paso 1: Vaciar cache para empezar limpio
# -----------------------------------------------
echo -e "${YELLOW}[1/7] Vaciando cache (FLUSHDB)...${NC}"
curl -s -X POST "${BACKEND_URL}/cache/flush" | $FMT
echo ""
sleep 1

# -----------------------------------------------
# Paso 2: Primer GET → cache MISS, latencia alta
# -----------------------------------------------
echo -e "${RED}[2/7] Primer request a ${SKU} — esperamos cache MISS...${NC}"
curl -s "${BACKEND_URL}/products/${SKU}" | $FMT
echo ""
sleep 0.5

# -----------------------------------------------
# Paso 3: Cinco GETs más → cache HIT, latencia baja
# -----------------------------------------------
echo -e "${GREEN}[3/7] Cinco requests más — esperamos cache HIT...${NC}"
for i in 1 2 3 4 5; do
  echo -e "${GREEN}  Request ${i}/5:${NC}"
  curl -s "${BACKEND_URL}/products/${SKU}" | $FMT
  echo ""
done
sleep 0.5

# -----------------------------------------------
# Paso 4: Estadísticas de Redis
# -----------------------------------------------
echo -e "${CYAN}[4/7] Estadísticas de Redis (hit_ratio esperado ~83%)...${NC}"
curl -s "${BACKEND_URL}/stats" | $FMT
echo ""
sleep 0.5

# -----------------------------------------------
# Paso 5: PATCH para actualizar precio (invalida cache)
# -----------------------------------------------
echo -e "${YELLOW}[5/7] Actualizando precio de ${SKU} a \$99.99 (invalida cache)...${NC}"
curl -s -X PATCH "${BACKEND_URL}/products/${SKU}/price" \
  -H "Content-Type: application/json" \
  -d '{"price": 99.99}' | $FMT
echo ""
sleep 0.5

# -----------------------------------------------
# Paso 6: GET después de invalidación → cache MISS de nuevo
# -----------------------------------------------
echo -e "${RED}[6/7] Request post-invalidación — esperamos cache MISS...${NC}"
curl -s "${BACKEND_URL}/products/${SKU}" | $FMT
echo ""
sleep 0.5

# -----------------------------------------------
# Paso 7: Estadísticas finales
# -----------------------------------------------
echo -e "${CYAN}[7/7] Estadísticas finales de Redis...${NC}"
curl -s "${BACKEND_URL}/stats" | $FMT
echo ""

echo -e "${CYAN}${BOLD}======================================================${NC}"
echo -e "${GREEN}${BOLD}  Demo completado${NC}"
echo -e "${CYAN}${BOLD}======================================================${NC}"
echo ""
