ARG PHP_VERSION=8.3
ARG NODE_VERSION=24

# Stage 1: Install optimized PHP dependencies
FROM php:${PHP_VERSION}-cli AS vendor

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    unzip \
    libxml2-dev \
    libcurl4-openssl-dev \
    libicu-dev \
    libzip-dev \
    && docker-php-ext-install -j$(nproc) \
    pdo_mysql \
    opcache \
    intl \
    zip \
    bcmath \
    && apt-get autoremove -y && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY --from=composer/composer:latest-bin /composer /usr/local/bin/composer

WORKDIR /app

COPY . .

RUN composer install --no-dev --prefer-dist --optimize-autoloader

RUN php artisan config:clear --no-ansi --quiet \
  && php artisan route:clear --no-ansi --quiet \
  && php artisan view:clear --no-ansi --quiet

RUN composer dump-autoload --optimize --no-interaction


# Stage 2: Build assets with Node.js
FROM node:${NODE_VERSION} AS assets

WORKDIR /app

COPY --from=vendor /app /app/
RUN npm ci && npm run build


# Stage 3: Final build files artifact
FROM alpine AS artifact

WORKDIR /out

RUN rm -rf /out/* && mkdir -p /out

COPY --from=vendor /app /out/
COPY --from=assets /app/public /out/public

RUN chown -R 1000:1000 storage bootstrap/cache