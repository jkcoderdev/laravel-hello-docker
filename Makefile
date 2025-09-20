DEV_COMPOSE = docker compose -f compose.dev.yml
PROD_COMPOSE = docker compose -f compose.prod.yml

.DEFAULT_GOAL := help

help:
	make --help

down:
	$(DEV_COMPOSE) down
	$(PROD_COMPOSE) down

dev-up:
	$(DEV_COMPOSE) up -d --build

dev-down:
	$(DEV_COMPOSE) down

prod-build:
	$(PROD_COMPOSE) run --rm build

prod-down:
	$(PROD_COMPOSE) down