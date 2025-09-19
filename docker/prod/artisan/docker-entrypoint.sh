#!/bin/bash

source .env

echo "Waiting for MySQL..."
until php -r "try { new PDO('mysql:host=mysql;dbname=${DB_DATABASE}', '${DB_USERNAME}', '${DB_PASSWORD}'); exit(0);} catch (Exception \$e) { exit(1);}"; do
  sleep 2
done

exec php artisan "$@"
