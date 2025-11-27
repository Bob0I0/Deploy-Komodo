# Menggunakan image resmi PHP 8.x FPM sebagai base image
FROM php:8.3-fpm

# Mengatur working directory di dalam container
WORKDIR /var/www

# Menginstal dependensi sistem yang dibutuhkan untuk PHP dan Laravel
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip

# Menginstal ekstensi PHP yang dibutuhkan Laravel
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Menginstal Composer secara global
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# --- BAGIAN UNTUK CI/CD ---

# Mengkopi file Composer (untuk menginstal dependensi)
# File ini akan di-copy saat build, memastikan environment siap untuk Composer Install
COPY src/composer.json ./
COPY src/composer.lock ./

# Menginstal dependensi PHP
# Menggunakan --no-dev untuk build produksi atau tanpa flag untuk build development/testing
RUN composer install --no-dev --optimize-autoloader

# Mengkopi semua file aplikasi Laravel lainnya
COPY src .

# Membuat folder cache/storage yang dibutuhkan dan mengatur izin (penting!)
RUN chown -R www-data:www-data /var/www/storage /var/www/bootstrap/cache
RUN chmod -R 775 /var/www/storage /var/www/bootstrap/cache

# Menjalankan PHP-FPM (default command untuk image FPM)
CMD ["php-fpm"]