# Dockerfile di root repositori
FROM php:8.3-fpm

WORKDIR /var/www

# Instalasi Dependensi Sistem dan Ekstensi PHP
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    && rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Instalasi Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Salin source code Laravel ke dalam container
# Note: Since this is built from the root context, we copy relative to the build context.
COPY laravel/src .

# 🛑 Tambahkan baris ini untuk menginstal dependensi dan membuat autoload.php
RUN composer install --no-dev --optimize-autoloader --prefer-dist

# Perubahan Kepemilikan dan Izin
RUN chown -R www-data:www-data /var/www/storage /var/www/bootstrap/cache
RUN chmod -R 775 /var/www/storage /var/www/bootstrap/cache

EXPOSE 9000
CMD ["php-fpm"]