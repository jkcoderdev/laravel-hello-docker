#!/bin/bash

if [ ! -e .env ]; then
    cp .env.example .env
fi

docker compose -f compose.dev.yml down
docker compose -f compose.dev.yml up --build -d

clear

docker compose -f compose.dev.yml exec app bash ./setup-docker.sh