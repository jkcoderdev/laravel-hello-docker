DEV_COMPOSE = docker compose -f compose.dev.yml
PROD_COMPOSE = docker compose -f compose.prod.yml

.DEFAULT_GOAL := help

help:
	make --help

down:
	$(DEV_COMPOSE) down
	$(PROD_COMPOSE) down

dev-down:
	$(DEV_COMPOSE) down

prod-down:
	$(PROD_COMPOSE) down

dev:
	$(DEV_COMPOSE) up -d --build

build:
	sudo rm -rf ./dist && mkdir -p ./dist
	docker volume rm -f laravel-build-artifact || true
	$(PROD_COMPOSE) run --build --rm builder sh -c "ls -l /out"
	docker run --rm -v laravel-build-artifact:/src -v $(PWD)/dist:/dest alpine sh -c "cp -r /src/. /dest/"

testserver: build
	$(PROD_COMPOSE) down
	$(PROD_COMPOSE) up -d --build testserver
	$(PROD_COMPOSE) exec testserver php artisan migrate --force
	@echo "✅ Testserver running at http://localhost:8000"
