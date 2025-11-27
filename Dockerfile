FROM php:8.3-fpm

WORKDIR /var/www

RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip

RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

COPY php.ini /usr/local/etc/php/

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# --- BAGIAN UNTUK CI/CD ---

# Mengkopi file Composer (untuk menginstal dependensi)
# File ini akan di-copy saat build, memastikan environment siap untuk Composer Install
COPY laravel/src/composer.json ./
COPY laravel/src/composer.lock ./

COPY laravel/src .

RUN composer install --no-dev --optimize-autoloader

RUN chown -R www-data:www-data /var/www/storage /var/www/bootstrap/cache
RUN chmod -R 775 /var/www/storage /var/www/bootstrap/cache

CMD ["php-fpm"]