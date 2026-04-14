.PHONY: help up down reset logs bench-py bench-node psql redis-cli

help: ## Muestra esta ayuda
	@echo 'Uso: make [target]'
	@echo ''
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

up: ## Inicia todos los servicios
	docker compose up -d --build

down: ## Detiene los servicios (conserva datos)
	docker compose down

reset: ## Teardown completo y rebuild (borra datos)
	@bash scripts/reset.sh

bench-py: ## Ejecuta demo de cache con backend Python
	@BACKEND_URL=http://localhost:8001 bash scripts/bench.sh

bench-node: ## Ejecuta demo de cache con backend Node
	@BACKEND_URL=http://localhost:8002 bash scripts/bench.sh

logs: ## Muestra logs de todos los servicios
	docker compose logs -f

psql: ## Abre una sesion de psql
	docker compose exec postgres psql -U bda -d bda

redis-cli: ## Abre redis-cli
	docker compose exec redis redis-cli
