ARG PHP_VERSION=8.3

FROM php:${PHP_VERSION}-apache

WORKDIR /var/www

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    unzip \
    libpq-dev \
    libonig-dev \
    libssl-dev \
    libxml2-dev \
    libcurl4-openssl-dev \
    libicu-dev \
    libzip-dev \
    && docker-php-ext-install -j$(nproc) \
    pdo_mysql \
    pdo_pgsql \
    pgsql \
    opcache \
    intl \
    zip \
    bcmath \
    soap \
    && apt-get autoremove -y && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN a2enmod rewrite

COPY ./docker/prod/server/vhost.conf /etc/apache2/sites-available/000-default.conf

RUN chown -R 33:33 /var/www && chmod -R u+rwX,g+rwX /var/www

EXPOSE 80

ENTRYPOINT []
CMD [ "apache2-foreground" ]