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
    --exclude "compose.*.yml" \
    /src/ /out/

composer install --no-dev --optimize-autoloader --no-interaction
npm install --include=dev
npm run build

rm -rf node_modules

npm install --omit=dev

if [ ! -e .env ]; then
    cp .env.example .env
fi

php artisan key:generate

php artisan config:clear --no-ansi --quiet
php artisan route:clear --no-ansi --quiet
php artisan view:clear --no-ansi --quiet
php artisan cache:clear --no-ansi --quiet

composer dump-autoload --optimize --no-interaction

rm -f artisan
rm -f .env.example

chmod -R 777 storage
chmod -R 777 bootstrap/cache

exec "$@"