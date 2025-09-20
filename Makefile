DEV_COMPOSE = docker compose -f compose.dev.yml
PROD_COMPOSE = docker compose -f compose.dev.yml

.DEFAULT_GOAL := help

help:
	make --help

dev-up:
	$(DEV_COMPOSE) up -d --build

dev-down:
	$(DEV_COMPOSE) down

prod-build:
	$(DEV_COMPOSE) run --rm build

prod-down:
	$(DEV_COMPOSE) down