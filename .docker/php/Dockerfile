FROM php:8.3-fpm

RUN apt-get update && apt-get install -y \
    git unzip libzip-dev libpng-dev libonig-dev libxml2-dev libpq-dev \
    && rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-configure gd \
    && docker-php-ext-install -j$(nproc) gd zip bcmath pcntl

RUN docker-php-ext-install pdo_mysql

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

ARG PUID=1000
ARG PGID=1000
RUN groupadd -g ${PGID} app && useradd -u ${PUID} -g app -m app
USER app
WORKDIR /var/www/html