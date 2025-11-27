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

# Kustomisasi php.ini (Asumsi file php.ini ada di root repositori)
# Jika Anda tidak memiliki file ini, hapus baris ini.
COPY php.ini /usr/local/etc/php/

# Instalasi Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# --- SETUP APLIKASI LARAVEL (kode aplikasi harus di commit ke Git) ---

# Salin seluruh kode Laravel ke dalam container (termasuk artisan dan composer.json)
# Menggunakan path yang benar: laravel/src
COPY laravel/src .

# Instal dependensi PHP
# RUN composer install --no-dev --optimize-autoloader
# Jika Anda ingin menginstal tanpa --no-dev untuk testing, hilangkan flag tersebut.

# Perbaikan Izin (Penting)
RUN chown -R www-data:www-data /var/www/storage /var/www/bootstrap/cache
RUN chmod -R 775 /var/www/storage /var/www/bootstrap/cache

CMD ["php-fpm"]