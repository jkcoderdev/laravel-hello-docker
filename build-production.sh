#!/bin/bash

docker compose -f compose.prod.yml run --remove-orphans --rm --build build
