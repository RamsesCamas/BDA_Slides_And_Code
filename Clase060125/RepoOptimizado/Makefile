.PHONY: help up down restart logs migrate db shell build clean rebuild status

help: ## Muestra esta ayuda
	@echo 'Uso: make [target]'
	@echo ''
	@echo 'Targets disponibles:'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

up: ## Inicia los servicios en segundo plano
	docker compose up -d
	@echo "✅ Servicios iniciados"
	@echo "   - PostgreSQL: localhost:5432"
	@echo "   - Database: mydb"
	@echo "   - User: postgres"

down: ## Detiene y elimina los servicios
	docker compose down
	@echo "✅ Servicios detenidos"

restart: down up ## Reinicia los servicios

logs: ## Muestra los logs de los servicios
	docker compose logs -f

db: ## Ejecuta comandos en la base de datos (ej: make db cmd="SELECT version();")
	@docker compose exec -T db psql -U postgres -d mydb -c "$(cmd)"

shell: ## Abre un shell de psql
	docker compose exec db psql -U postgres -d mydb

migrate: ## Ejecuta las migraciones (scripts SQL)
	@echo "🔄 Ejecutando migraciones..."
	@docker compose exec -T db psql -U postgres -d mydb -f /sql/01_schema.sql && \
	 echo "✅ Schema aplicado" || echo "❌ Error aplicando schema"
	@docker compose exec -T db psql -U postgres -d mydb -f /sql/02_seed.sql && \
	 echo "✅ Seed aplicado" || echo "❌ Error aplicando seed"
	@docker compose exec -T db psql -U postgres -d mydb -f /sql/03_queries.sql > /dev/null && \
	 echo "✅ Queries ejecutadas" || echo "⚠️  Algunas queries pueden fallar (normal si hay datos)"

migrate-schema: ## Ejecuta solo el schema
	@echo "🔄 Aplicando schema..."
	@docker compose exec -T db psql -U postgres -d mydb -f /sql/01_schema.sql && \
	 echo "✅ Schema aplicado"

migrate-seed: ## Ejecuta solo el seed
	@echo "🔄 Aplicando seed..."
	@docker compose exec -T db psql -U postgres -d mydb -f /sql/02_seed.sql && \
	 echo "✅ Seed aplicado"

run-queries: ## Ejecuta las queries y muestra resultados
	@echo "🔄 Ejecutando queries..."
	@docker compose exec db psql -U postgres -d mydb -f /sql/03_queries.sql

reset: down migrate ## Reinicia todo y ejecuta migraciones

build: ## Construye las imágenes
	docker compose build
	@echo "✅ Imágenes construidas"

clean: ## Limpia contenedores, redes y volúmenes
	docker compose down -v
	docker compose rm -f
	docker volume prune -f
	@echo "✅ Limpieza completada"

rebuild: clean build up ## Reconstruye todo desde cero

status: ## Muestra el estado de los servicios
	@echo "📊 Estado de los servicios:"
	@docker compose ps
	@echo ""
	@echo "📦 Volúmenes:"
	@docker volume ls | grep repo-optimizado || echo "  (no hay volúmenes)"

test: ## Ejecuta pruebas de conexión
	@echo "🧪 Probando conexión a PostgreSQL..."
	@docker compose exec -T db psql -U postgres -d mydb -c "SELECT version();" | head -3 && \
	 echo "✅ Conexión exitosa" || echo "❌ Error de conexión"

inspect: ## Muestra información de las tablas
	@echo "📋 Inspeccionando base de datos..."
	@docker compose exec -T db psql -U postgres -d mydb -c "\dt"
	@echo ""
	@echo "📊 Filas por tabla:"
	@docker compose exec -T db psql -U postgres -d mydb -c \
	 "SELECT schemaname, tablename, n_live_tup FROM pg_stat_user_tables;"
