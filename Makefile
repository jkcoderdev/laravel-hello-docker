DEV_COMPOSE = docker compose -f compose.dev.yml
PROD_COMPOSE = docker compose -f compose.prod.yml

.DEFAULT_GOAL := help

help:
	@echo "Available targets:"
	@echo "  make dev: run development environment"
	@echo "  make build: build artifacts into ./dist"
	@echo "  make testserver: build artifacts and host them on a test server"
	@echo "  make dev-down: stop development environment"
	@echo "  make prod-down: stop production environment"
	@echo "  make down: stop all docker environments"

down:
	$(DEV_COMPOSE) down
	$(PROD_COMPOSE) down

dev-down:
	$(DEV_COMPOSE) down

prod-down:
	$(PROD_COMPOSE) down

dev:
	$(DEV_COMPOSE) down
	$(PROD_COMPOSE) down
	$(DEV_COMPOSE) up -d --build
	$(DEV_COMPOSE) exec app bash ./setup-docker.sh
	@echo "✅ Server:     http://localhost:8000"
	@echo "✅ phpMyAdmin: http://localhost:8080"

build:
	sudo rm -rf ./dist && mkdir -p ./dist
	docker volume rm -f laravel-build-artifact || true
	$(PROD_COMPOSE) run --build --rm --remove-orphans builder sh -c "ls -l /out"
	docker run --rm -v laravel-build-artifact:/src -v $(PWD)/dist:/dest alpine sh -c "cp -r /src/. /dest/"

testserver: build
	$(DEV_COMPOSE) down
	$(PROD_COMPOSE) down
	$(PROD_COMPOSE) up -d --build testserver
	$(PROD_COMPOSE) exec testserver php artisan migrate --force
	@echo "✅ Testserver: http://localhost:8000"
	@echo "✅ phpMyAdmin: http://localhost:8080"
