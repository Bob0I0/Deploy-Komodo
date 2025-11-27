FROM php:8.2-fpm

RUN apt-get update && apt-get install -y \
    zip unzip curl libpq-dev libonig-dev libzip-dev \
    && docker-php-ext-install pdo pdo_mysql zip

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www
COPY . .

RUN composer install || true

RUN chown -R www-data:www-data /var/www

CMD ["php-fpm"]
