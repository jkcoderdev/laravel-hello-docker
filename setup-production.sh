#!/bin/bash

if [ ! -e .env ]; then
    cp .env.example .env
fi

docker compose -f compose.prod.yml down
docker compose -f compose.prod.yml up --build -d