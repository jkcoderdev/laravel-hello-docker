ARG PHP_VERSION=8.3

FROM php:${PHP_VERSION}-apache

ARG NODE_VERSION=24
ARG UID=1000
ARG GID=1000

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

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN export NVM_DIR="$HOME/.nvm" && \
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash && \
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" && \
    nvm install ${NODE_VERSION} && \
    nvm alias default ${NODE_VERSION} && \
    nvm use default && \
    npm config set update-notifier false

ENV NVM_DIR=/root/.nvm

RUN a2enmod rewrite

COPY ./docker/dev/vhost.conf /etc/apache2/sites-available/000-default.conf

RUN echo 'alias art="php artisan"' >> "$HOME/.bashrc"

RUN apt-get update && apt-get install -y --no-install-recommends supervisor
COPY ./docker/dev/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 80
EXPOSE 5173

ENTRYPOINT []
CMD ["/usr/bin/supervisord", "-n"]