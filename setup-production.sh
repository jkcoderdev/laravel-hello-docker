#!/bin/bash

if [ ! -e .env ]; then
    cp .env.example .env
fi

mkdir -p dist

docker compose -f compose.prod.yml down
docker compose -f compose.prod.yml up --build -d

docker compose -f compose.prod.yml run --rm artisan migrate --force