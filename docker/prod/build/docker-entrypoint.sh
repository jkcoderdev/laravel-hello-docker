#!/bin/bash

# Stops the execution of a script if a command or pipeline has an error
set -e

rm -rf /out/*
mkdir -p /out

rsync -av \
    --exclude-from="/src/.gitignore" \
    --exclude ".git/" \
    --exclude "docker/" \
    --exclude "*.sh" \
    --exclude "*.md" \
    --exclude ".*ignore" \
    --exclude ".gitattributes" \
    --exclude ".editorconfig" \
    /src/ /out/

composer install --no-dev --optimize-autoloader --no-interaction
npm ci --omit=dev
npm run build

if [ ! -e .env ]; then
    cp .env.example .env
    php artisan key:generate
fi

php artisan config:cache --no-ansi --quiet
php artisan route:cache --no-ansi --quiet
php artisan view:cache --no-ansi --quiet

rm -f artisan
rm -f .env.example

exec "$@"