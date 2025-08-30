#!/bin/bash

# Required for npm to work
. "$NVM_DIR/nvm.sh"

composer install
npm install

chmod -R 777 storage

php artisan key:generate
php artisan migrate --force

supervisorctl start vite